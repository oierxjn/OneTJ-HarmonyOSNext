import { http } from "@kit.NetworkKit";
import { fileIo } from "@kit.CoreFileKit";
import { XJNUrlConstants } from "../constants/WebUrlConstants";
import image from "@ohos.multimedia.image";
import { ImageAnimatorModifier } from "@kit.ArkUI";

export function asyncSleep(ms: number): Promise<void>{
  return new Promise((resolve) => setTimeout(resolve, ms));
}



export class Downloader{
  httpRequest: http.HttpRequest;
  httpRequestOptions: http.HttpRequestOptions = {};

  finalArrayBuffer: ArrayBuffer = new ArrayBuffer(0);

  async request(url: string): Promise<number>{
    try {
      return await this.httpRequest.requestInStream(url, this.httpRequestOptions)
    } catch (e){
      console.error(e)
      return (e as BusinessError).code
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

export async function fetchNewWallpaper(context: UIContext): Promise<boolean>{
  const wallpaperFilePath = context.getHostContext()?.cacheDir + '/wallpaper.jpg'
  let downloader = new Downloader()
  try{
    downloader.httpRequestOptions = {
      method: http.RequestMethod.GET
    }
    console.debug(`调试：准备开始下载壁纸`)
    let responseCode = await downloader.get(getWallpaperUrl())
    console.debug(`调试：壁纸下载完成`)
    let pixelMap = await image.createImageSource(downloader.finalArrayBuffer).createPixelMapUsingAllocator(
      {  },
      image.AllocatorType.DMA
    )
    wallpaperPixelMap = pixelMap
    return true
  } catch (e){
    console.error(`调试：获取壁纸时发生错误：${(e as BusinessError).message}\n${(e as BusinessError).stack}`)
    return false
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