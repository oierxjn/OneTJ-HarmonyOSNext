import { WebUrlConstants } from "../constants/WebUrlConstants";
import { http } from "@kit.NetworkKit";
import { TokenData } from "./UserModel";

class TongjiApi {

  static authorizationHeader : Record<string, string>;

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
    // TODO: 实现
    return false
  }

  constructor() {
    TongjiApi.authorizationHeader = {
      'Authorization' : `Bearer ${TokenData.accessToken}`
    }
  }
}

export let tongjiApi = new TongjiApi();