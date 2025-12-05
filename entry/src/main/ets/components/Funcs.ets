import { http } from "@kit.NetworkKit";

export function asyncSleep(ms: number): Promise<void>{
  return new Promise((resolve) => setTimeout(resolve, ms));
}


// TODO
export class HttpRequest{
  httpRequest: http.HttpRequest;
  param: Map<string, string> = new Map();
  requestUrl: string = '';
  formBody: string = '';
  header: Map<string, string> = new Map();

  constructor() {
    this.httpRequest = http.createHttp()
  }

  add(name: string, value: string){
    this.param.set(name, value)
  }

  build(requestUrl: string){
    this.requestUrl = requestUrl+'?'
  }
}