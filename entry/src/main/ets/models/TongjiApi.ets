import { WebUrlConstants } from "../constants/WebUrlConstants";
import { http } from "@kit.NetworkKit";
import { StudentInfo, TokenData } from "./UserModel";
import { preferences } from "@kit.ArkData";
import { distributedKVStore } from '@kit.ArkData'

class TongjiApi {

  static sharePreference: preferences.Preferences;
  static authorizationHeader : Record<string, string>;

  static postHeader : Record<string, string> = {
    'Content-Type' : 'application/x-www-form-urlencoded'
  }

  /**
   * 获取学生的基础信息
   * 获取后会存入数据类中，不会存入数据库
   *
   * @returns -boolean，返回true表示请求成功，并保存在数据类中
   */
  async getStudentInfo(): Promise<boolean>{
    let baseUrl = WebUrlConstants.GET_STUDENT_INFO_URL
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, {
        header : TongjiApi.authorizationHeader
      })
      let studentInfo: Object = JSON.parse(response.result as string)

      let studentId: string = (studentInfo as object)?.['userId'];
      let studentName: string = (studentInfo as object)?.['name'];
      let deptName: string = (studentInfo as object)?.['deptName'];
      let secondDeptName: string = (studentInfo as object)?.['secondDeptName'];
      let currentGrade: string = (studentInfo as object)?.['currentGrade'];
      let gender: number = (studentInfo as object)?.['sexCode'];
      StudentInfo.storeStudentInfo(
        studentId!!,
        studentName!!,
        deptName!!,
        secondDeptName!!,
        currentGrade!!,
        gender!!
      )
      return true
    }catch (e){
      console.error(`错误：${e}`)
      return false
    }finally {
      httpRequest.destroy()
    }
  }

  /**
   * 拿code换token
   * token获取成功后会存储在数据类中，不会存入数据库
   * @param code 从授权页面获取的授权码
   * @returns
   */
  async code2token(code: string): Promise<boolean> {
    console.debug("调试：进入code2token")
    let baseUrl = WebUrlConstants.CODE2TOKEN_URL
    let httpRequest = http.createHttp()
    const param: [string, string][] = [
      ["grant_type", "authorization_code"],
      ["client_id", WebUrlConstants.CLIENT_ID],
      ["code", code],
      ["redirect_uri", WebUrlConstants.OAUTH_REDIRECT_URL]
    ]
    let formBody = param
      .map((item) => {
        return `${encodeURIComponent(item[0])}=${encodeURIComponent(item[1])}`
      })
      .join("&")
    let response : http.HttpResponse
    try{
      response = await httpRequest.request(baseUrl, {
        method: http.RequestMethod.POST,
        extraData: formBody,
        header: TongjiApi.postHeader
      })
      console.debug(`请求成功：${response.responseCode}\n内容：${response.result}`)
      let result = this.processTokenFromResponse(response.result as string)
      if(result){
        await TokenData.storeIntoKV()
        this.initAuthorizationHeader()
        return true
      }
    }catch (e) {
      console.error(`错误：${e}`)
    } finally {
      httpRequest.destroy()
    }
    return false
  }

  /**
   * 刷新token
   *
   * 参考OneTJ项目，济星云项目
   * @returns
   */
  async refreshAccessToken(): Promise<boolean> {
    console.debug(`调试：刷新令牌是否有效：${tongjiApi.isRefreshTokenAvailable()}`)
    if(!tongjiApi.isRefreshTokenAvailable())return false

    let httpRequest = http.createHttp()
    let baseUrl = WebUrlConstants.CODE2TOKEN_URL
    let param = [
      ["refresh_token", TokenData.refreshToken],
      ["grant_type", "refresh_token"],
      ["client_id", WebUrlConstants.CLIENT_ID]
    ]
    let formBody = param
      .map((item) => {
        return `${encodeURIComponent(item[0]!!)}=${encodeURIComponent(item[1]!!)}`
      })
      .join("&")
    try {
      let response = await httpRequest.request(baseUrl, {
        method: http.RequestMethod.POST,
        extraData: formBody,
        header: TongjiApi.postHeader
      })
      console.debug(`请求成功：${response.responseCode}\n内容：${response.result}`)
      let result = this.processTokenFromResponse(response.result as string)
      if(result){
        await TokenData.storeIntoKV()
        this.initAuthorizationHeader()
        return true
      }
    } catch (e){
      console.error(`错误：${e}`)
    }
    return false
  }

  isTokenAvailable(): boolean{
    let currentTime: number = Date.now()
    let tokenExpireTime: number = TokenData.expireTimeSec!!
    return currentTime / 1000 + 10 < tokenExpireTime
  }
  isRefreshTokenAvailable(): boolean{
    // TODO BUG 时间间隔
    let currentTime: number = Date.now()
    let refreshTokenExpireTime: number = TokenData.refreshTokenExpireSec!!
    return currentTime / 1000 + 10 < refreshTokenExpireTime
  }

  private processTokenFromResponse(str: string): boolean{
    let tokenData: Object | null;
    try{
      tokenData = JSON.parse(str);
      let accessToken:string = (tokenData as object)?.['access_token']
      let expiresIn:number = (tokenData as object)?.['expires_in']
      let refreshToken:string = (tokenData as object)?.['refresh_token']
      let refreshTokenExpireSec:number = (tokenData as object)?.['refresh_expires_in']
      TokenData.storeTokenData(
        accessToken!!,
        expiresIn!!,
        refreshToken!!,
        refreshTokenExpireSec!!
      )
      return true
    }catch (e){
      console.error(`错误：${e}`)
    }
    return false
  }

  async autoLogin(refreshFlag?: boolean): Promise<boolean>{
    if(refreshFlag){
      return await this.refreshAccessToken()
    }
    return this.isTokenAvailable()
  }

  initAuthorizationHeader(){
    TongjiApi.authorizationHeader = {
      'Authorization': `Bearer ${TokenData.accessToken}`
    }
  }

  async initSharePreference(context: Context){
    try {
      TongjiApi.sharePreference = await preferences.getPreferences(context, 'TongjiApi')
    }catch (e){
      console.error(`错误：${e}`)
    }
  }
}

export let tongjiApi = new TongjiApi();