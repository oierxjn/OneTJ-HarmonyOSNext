import { WebUrlConstants } from "../constants/WebUrlConstants";
import { http } from "@kit.NetworkKit";
import { TokenData } from "./UserModel";


class TongjiApi {

  static authorizationHeader : Record<string, string>;

  getStudentInfo(): void {
    let baseUrl = WebUrlConstants.GET_STUDENT_INFO_URL
    let httpRequest = http.createHttp()
    httpRequest.request(baseUrl, {
      header : TongjiApi.authorizationHeader
    },(err: BusinessError, response: http.HttpResponse) =>{
      // TODO: 数据处理与存储
    })
  }

  constructor() {
    TongjiApi.authorizationHeader = {
      'Authorization' : `Bearer ${TokenData.accessToken}`
    }
  }
}

export let tongjiApi = new TongjiApi();