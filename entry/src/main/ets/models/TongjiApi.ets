import { WebUrlConstants } from "../constants/WebUrlConstants";
import { http } from "@kit.NetworkKit";
import { TokenData } from "./UserModel";

class TongjiApi {

  static authorizationHeader : Record<string, string>;

  static postHeader : Record<string, string> = {
    'Content-Type' : 'application/x-www-form-urlencoded'
  }

  /**
   * 获取学生的基础信息
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
      // TODO: 数据处理和储存
      return true
    }catch (e){
      console.error(`错误：${e}`)
      return false
    }
  }

  /**
   * 拿code换token
   * @param code
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
        extraData: formBody
      })
      console.debug(`请求成功：${response.responseCode}\n内容：${response.result}`)
    }catch (e) {
      console.error(`错误：${e}`)
    }
    return false
  }

  constructor() {
    TongjiApi.authorizationHeader = {
      'Authorization' : `Bearer ${TokenData.accessToken}`
    }
  }
}

export let tongjiApi = new TongjiApi();