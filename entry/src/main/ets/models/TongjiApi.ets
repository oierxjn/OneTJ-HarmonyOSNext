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
      let studentInfo = JSON.parse(response.result as string)

      let studentId = (studentInfo as object)?.['userId'];
      let studentName = (studentInfo as object)?.['name'];
      let deptName = (studentInfo as object)?.['deptName'];
      let secondDeptName = (studentInfo as object)?.['secondDeptName'];
      let currentGrade = (studentInfo as object)?.['currentGrade'];
      let gender = (studentInfo as object)?.['sexCode'];
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
    }
  }

  /**
   * 拿code换token
   * token获取成功后会存储在数据类中，不会存入数据库
   * @param code 从授权页面获取的授权码
   * @returns
   */
  async code2token(code: string): Promise<boolean> {
    let baseUrl = WebUrlConstants.CODE2TOKEN_URL
    let httpRequest = http.createHttp()
    const param: [string, string][] = [
      ["grant_type", "authorization_code"],
      ["client_id", WebUrlConstants.CLIENT_ID],
      ["code", code],
      ["redirect_uri", WebUrlConstants.OAUTH_REDIRECT_URL]
    ]
    let formBody = param
      .map(([key, value]) => {
        return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`
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
        TongjiApi.authorizationHeader = {
          'Authorization': `Bearer ${TokenData.accessToken}`
        }
        return true
      }
    }catch (e) {
      console.error(`错误：${e}`)
    }
    return false
  }

  // TODO
  async refreshAccessToken(): Promise<void> {

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

  async initSharePreference(context: Context){
    try {
      TongjiApi.sharePreference = await preferences.getPreferences(context, 'TongjiApi')
    }catch (e){
      console.error(`错误：${e}`)
    }
  }
}

export let tongjiApi = new TongjiApi();