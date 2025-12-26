import { http } from "@kit.NetworkKit";
import { fileIo } from "@kit.CoreFileKit";
import { XJNUrlConstants } from "../constants/WebUrlConstants";
import image from "@ohos.multimedia.image";
import { ImageAnimatorModifier } from "@kit.ArkUI";
import util from "@ohos.util";
import { deviceInfo } from "@kit.BasicServicesKit";

export function asyncSleep(ms: number): Promise<void>{
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export function arrayBufferToString(buffer: ArrayBuffer, encoding: string = 'utf-8'): string {
  // 步骤1：判断ArrayBuffer是否有效
  if (!buffer || buffer.byteLength === 0) {
    console.warn("ArrayBuffer为空，转换结果为空字符串");
    return "";
  }

  // 步骤2：将ArrayBuffer转为Uint8Array（二进制字节数组，TextDecoder仅支持TypedArray输入）
  const uint8Array = new Uint8Array(buffer);

  // 步骤3：创建TextDecoder实例，指定编码格式，解码为字符串
  const textDecoder = new util.TextDecoder();
  const resultStr = textDecoder.decodeToString(uint8Array);

  return resultStr;
}

export function getRandomSingleElementFromArray<T>(arr: T[]): T | undefined {
  // 边界处理：空数组直接返回undefined
  if (arr.length === 0) {
    console.warn("源数组不能为空！");
    return undefined;
  }
  // 生成随机合法索引
  const randomIndex = Math.floor(Math.random() * arr.length);
  // 返回对应索引的元素
  return arr[randomIndex];
}


export class Downloader{
  httpRequest: http.HttpRequest;
  httpRequestOptions: http.HttpRequestOptions = {};

  finalArrayBuffer: ArrayBuffer = new ArrayBuffer(0);

  /**
   * 构造基础流式请求 异常将向上层传播
   *
   * @param url
   * @returns
   */
  async request(url: string): Promise<number>{
    try {
      return await this.httpRequest.requestInStream(url, this.httpRequestOptions)
    } finally {
      this.httpRequest.destroy()
    }
  }

  async get(url: string): Promise<number>{
    this.httpRequestOptions.method = http.RequestMethod.GET;
    return await this.request(url)
  }

  async saveToFile(filePath: string){
    let tempFile: fileIo.File | undefined;
    try {
      tempFile = await fileIo.open(
        filePath,
        fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC
      )
      await fileIo.write(tempFile.fd, this.finalArrayBuffer)
    } catch (e){
      console.error(`保存文件时发生错误：${(e as BusinessError).message}`)
    } finally {
      await fileIo.close(tempFile)
    }
  }

  destroy(){
    this.httpRequest.destroy()
  }

  constructor() {
    this.httpRequest = http.createHttp()
    this.httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      const newRes = new ArrayBuffer(this.finalArrayBuffer.byteLength + data.byteLength);
      const resView = new Uint8Array(newRes);
      resView.set(new Uint8Array(this.finalArrayBuffer));
      resView.set(new Uint8Array(data), this.finalArrayBuffer.byteLength);
      this.finalArrayBuffer = newRes;
    });
    this.httpRequest.on('dataEnd', () => {
      console.info('No more data in response, data receive end');
    });
  }
}


export let wallpaperPixelMap: image.PixelMap | undefined;

export async function checkOldWallpaper(context: UIContext): Promise<boolean>{
  const wallpaperFilePath = context.getHostContext()?.cacheDir + '/wallpaper.jpg'
  try{
    if(await fileIo.access(wallpaperFilePath)){

      return true
    }
  } catch (e){
    console.error(`检查壁纸时发生错误：${(e as BusinessError).message}`)
  }
  return false
}

export async function fetchNewWallpaper(context: UIContext): Promise<void>{
  const wallpaperFilePath = context.getHostContext()?.cacheDir + '/wallpaper.jpg'
  let downloader = new Downloader()
  try{
    downloader.httpRequestOptions = {
      method: http.RequestMethod.GET
    }
    console.debug(`调试：准备开始下载壁纸`)
    let responseCode = await downloader.get(getWallpaperUrl())
    console.debug(`调试：壁纸下载完成`)
    let imageSource = image.createImageSource(downloader.finalArrayBuffer)
    let pixelMap: image.PixelMap

    /*
     * createPixelMapUsingAllocator的兼容性判断
     */
    if(deviceInfo.sdkApiVersion >= 15) {
      pixelMap = await imageSource.createPixelMapUsingAllocator(
        {},
        image.AllocatorType.DMA
      )
    }else{
      pixelMap = await imageSource.createPixelMap()
    }
    wallpaperPixelMap = pixelMap
  } catch (e){
    console.error(`ONETJ:Funcs 获取壁纸时发生错误：${(e as BusinessError).message}\n${(e as BusinessError).stack}`)
    throw e as Error
  } finally {
    downloader.destroy()
  }
}

let maxImageNumbers = 7;
function getRandomInt(min: number, max: number): number {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getWallpaperUrl(): string{
  let baseUrl = XJNUrlConstants.GET_PORTRAIT_WALLPAPER_URL + `/${getRandomInt(1, maxImageNumbers)}.jpg`;
  return baseUrl;
}