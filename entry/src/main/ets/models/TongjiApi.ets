import { TongjiApiUrlConstants } from "../constants/WebUrlConstants";
import { http } from "@kit.NetworkKit";
import { CourseInfo, CourseInfoList, MsgList, SchoolCalendarInfo, StudentInfo, TokenData } from "./UserModel";
import { preferences } from "@kit.ArkData";
import { distributedKVStore } from '@kit.ArkData'
import { ErrorCode } from "@kit.AbilityKit";
import { CommonMsgData } from "../DisplayUtils/DataUtils";
import { BusinessError } from "@kit.BasicServicesKit";

class TongjiApi {

  static sharePreference: preferences.Preferences;

  static postHeader : Record<string, string> = {
    'Content-Type' : 'application/x-www-form-urlencoded'
  }
  static requestOptions: http.HttpRequestOptions

  switchRequire: boolean = false

  async clearLoginData(){
    try{
      let TokenDataTask = TokenData.clearFromKV()
      let StudentInfoTask = StudentInfo.clearFromKV()
      await Promise.all([TokenDataTask, StudentInfoTask])
    } catch (e){
      console.error(`清除数据库数据时发生错误：${e}`)
    } finally {
      TokenData.isFetched = false
      StudentInfo.isFetched = false
    }
  }

  async getCourseInfoList(): Promise<boolean>{
    let baseUrl = TongjiApiUrlConstants.GET_STUDENT_TIMETABLE_URL;
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, TongjiApi.requestOptions)
      let responseData = this.responseToDataArray(response.result as string)
      CourseInfoList.processCourseInfoData(responseData)
      return true
    } catch (e){
      console.error(`请求课程表时发生错误：${(e as BusinessError).message}`)
      return false
    } finally {
      httpRequest.destroy()
    }
  }

  async getDetailMsg(id: number): Promise<string | null>{
    let baseUrl = `${TongjiApiUrlConstants.GET_MSG_DETAIL_URL}?id=${id}`
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, TongjiApi.requestOptions)
      let responseData = this.responseToData(response.result as string)
      let content: string = (responseData as object)?.['content']
      return content
    } catch (e){
      console.error(`请求通知详情时发生错误：${JSON.stringify(e as object)}`)
      return null
    } finally {
      httpRequest.destroy()
    }
  }

  /**
   * 一次性获取接口的所有通知
   *
   * @returns
   */
  async getCommonMsgList(): Promise<boolean>{
    let baseUrl = TongjiApiUrlConstants.GET_ALL_MSG_LIST_URL
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, TongjiApi.requestOptions)
      let responseData = this.responseToData(response.result as string)
      let msgList: Array<Object> = (responseData as object)?.['list']
      for (let msg of msgList){
        let id: number = (msg as object)?.['id']
        let title: string = (msg as object)?.['title']
        let publishTime: string = (msg as object)?.['publishTime']
        MsgList.msgArray.push(new CommonMsgData(
          id!!,
          title!!,
          publishTime!!
        ))
      }
      MsgList.isFetched = true
      return true
    } catch (e){
      console.error(`请求通知列表时发生错误：${e}`)
      return false
    } finally {
      httpRequest.destroy()
    }
  }

  async getSchoolCalendarInfo(): Promise<boolean>{
    let baseUrl = TongjiApiUrlConstants.GET_SCHOOL_CALENDAR_URL
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, TongjiApi.requestOptions)
      let schoolCalendarInfo: Object = this.responseToData(response.result as string)
      let schoolWeek: string = (schoolCalendarInfo as object)?.['week']
      let simpleName: string = (schoolCalendarInfo as object)?.['simpleName']
      let schoolCalendar: object = (schoolCalendarInfo as object)?.['schoolCalendar']
      let calendarId: string = schoolCalendar?.['id']
      let year: string = schoolCalendar?.['year']
      let term: string = schoolCalendar?.['term']

      SchoolCalendarInfo.storeSchoolCalendarInfo(
        calendarId!!,
        year!!,
        term!!,
        schoolWeek!!,
        simpleName!!,
      )
      return true
    } catch (e){
      console.error(`请求校历时发生错误：${e}`)
      return false
    } finally {
      httpRequest.destroy()
    }
  }

  /**
   * 拉取学生的基础信息
   * 获取后会存入数据类中，不会存入数据库
   *
   * @returns -boolean，返回true表示请求成功，并保存在数据类中
   */
  async getStudentInfo(): Promise<boolean>{
    let baseUrl = TongjiApiUrlConstants.GET_STUDENT_INFO_URL
    let httpRequest = http.createHttp()
    let response : http.HttpResponse
    try {
      response = await httpRequest.request(baseUrl, TongjiApi.requestOptions)
      let responseData = this.responseToDataArray(response.result as string)
      // console.debug(`调试：校历转换结果\n${responseData}`)
      let studentInfo = responseData[0]
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
   * 专门为同济开放平台设计的通用data提取
   *
   * @param jsonStr
   * @returns
   */
  responseToData(jsonStr: string): Object{
    let jsonObj: Object = JSON.parse(jsonStr)!!
    let responseCode: string = (jsonObj as object)?.['code']
    if(responseCode != 'A00000')throw new Error(`响应码错误：${responseCode}`)
    let responseData: Object = (jsonObj as object)?.['data']
    return responseData
  }


  /**
   * 从响应内容的 `data` 中提取第一个元素
   *
   * @see responseToDataArray
   *
   * @param jsonStr 需要转换的响应内容
   * @returns
   */
  responseToSingleData(jsonStr: string): Object{
    let responseData = this.responseToDataArray(jsonStr)
    return responseData[0]
  }

  /**
   * 专门为同济开放平台设计的**数组类**data提取
   * 注意：只有返回数组类的时候才需要用这个
   * 响应码不为 `A00000` 的时候会直接抛出对应的响应码
   * @param jsonStr 需要转换的响应内容
   * @returns 响应的data数组
   */
  responseToDataArray(jsonStr: string): Array<Object>{
    let responseData = this.responseToData(jsonStr)
    return responseData as Array<Object>
  }


  /**
   * 拿code换token
   * token获取成功后会存储在数据类中，不会存入数据库
   * @param code 从授权页面获取的授权码
   * @returns
   */
  async code2token(code: string): Promise<boolean> {
    let baseUrl = TongjiApiUrlConstants.CODE2TOKEN_URL
    let httpRequest = http.createHttp()
    const param: [string, string][] = [
      ["grant_type", "authorization_code"],
      ["client_id", TongjiApiUrlConstants.CLIENT_ID],
      ["code", code],
      ["redirect_uri", TongjiApiUrlConstants.OAUTH_REDIRECT_URL]
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
   * 参考OneTJ项目，济星云项目
   * 请求前将会判断 `refresh_token` 是否可用
   * @returns 刷新成功或否
   */
  async refreshAccessToken(): Promise<boolean> {
    if(!tongjiApi.isRefreshTokenAvailable())return false

    let httpRequest = http.createHttp()
    let baseUrl = TongjiApiUrlConstants.CODE2TOKEN_URL
    let param = [
      ["refresh_token", TokenData.refreshToken],
      ["grant_type", "refresh_token"],
      ["client_id", TongjiApiUrlConstants.CLIENT_ID]
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
    } finally {
      httpRequest.destroy()
    }
    return false
  }

  isTokenAvailable(): boolean{
    let currentTime: number = Date.now()
    let lastUpdateTime: number = TokenData.updateTime
    let tokenExpireTime: number = TokenData.expireTimeSec!!
    return (currentTime - lastUpdateTime) / 1000 < tokenExpireTime
  }
  isRefreshTokenAvailable(): boolean{
    let currentTime: number = Date.now()
    let lastUpdateTime: number = TokenData.updateTime
    let refreshTokenExpireTime: number = TokenData.refreshTokenExpireSec!!
    return (currentTime - lastUpdateTime) / 1000 < refreshTokenExpireTime
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
    TongjiApi.requestOptions = {
      maxLimit: 100*1024*1024,
      header: {
        'Authorization': `Bearer ${TokenData.accessToken}`
      }
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