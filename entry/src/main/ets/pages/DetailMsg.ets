import { CommonMsgToDetailMsgNavParams } from "../DisplayUtils/DataUtils"
import { tongjiApi } from "../models/TongjiApi"
import { webview } from "@kit.ArkWeb"
import { FailureCode } from "@ohos.app.ability.CompletionHandlerForAtomicService"
import { UIContext } from "@kit.ArkUI"
import { fileIo, fileUri, picker } from "@kit.CoreFileKit"
import { common, UIAbility } from "@kit.AbilityKit"
import { ArkTSUtils } from "@kit.ArkTS"

enum LoadMode{
  Fetching = 1<<0,
  Rendering = 1<<1
}

let isTempHtmlDownLoaded: boolean = false;

let buttonBackgroundColor = $r('sys.color.ohos_id_color_floating_button_shadow_start')
let normalTextColor = $r('sys.color.ohos_id_color_text_primary')

async function downloadHTML(htmlStr: string, uiContext: UIContext){
  let tempDir = uiContext.getHostContext()?.tempDir
  let tempFileDir: string = tempDir + '/temp.html'
  let tempFile: fileIo.File | undefined;
  if(!isTempHtmlDownLoaded){
    try {
      tempFile = await fileIo.open(
        tempFileDir,
        fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC
      )
      let writeLength = await fileIo.write(tempFile.fd, htmlStr)
      console.debug(`写入完成，写入长度：${writeLength}`)
    } catch (e){
      console.error(`下载时出现异常：${e}`)
    } finally {
      if(tempFile){
        await fileIo.close(tempFile)
        console.debug(`文件流正常关闭`)
      }
    }
    isTempHtmlDownLoaded = true
  }
  let tempUri = fileUri.getUriFromPath(tempFileDir)
  let abilityContext = uiContext.getHostContext() as common.UIAbilityContext
  abilityContext.openLink(tempUri)
}

@Extend(Web)
function WebStyles(){
  .domStorageAccess(true)
  .imageAccess(true)
  .overScrollMode(OverScrollMode.ALWAYS)
  .zoomAccess(true)
  .forceEnableZoom(true)
  .javaScriptAccess(true)
  .allowWindowOpenMethod(true)
  .mixedMode(MixedMode.All)
  .darkMode(WebDarkMode.Auto)
  .forceDarkAccess(true)
}

@Component
export struct DetailMsg {
  @State pageTitle: string = ''
  @State content: string = '加载中'

  @State head: string = "<head>" +
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> " +
    "<style>img{max-width: 100%; width:auto; height:auto;}*{margin:0px;padding:0px;}</style>" +
    "</head>"

  @State loadMode: LoadMode = LoadMode.Fetching
  messageId: number | undefined
  isWebPageVisible: boolean = false

  htmlStr: string = ''
  controller: WebviewController = new webview.WebviewController(`MsgWebView`)
  tempFile: fileIo.File | undefined;

  build() {
    NavDestination() {
      Column() {
        if (this.loadMode & LoadMode.Fetching) {
          Column() {
            Text('详情拉取中')
              .fontSize(16)
              .fontColor('#999999')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
        } else if (this.loadMode & LoadMode.Rendering) {
          Column() {
            Text('网页渲染中')
              .fontSize(16)
              .fontColor('#999999')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
        } else {
          Row({ space: 12 }){
            Button(`刷新`)
              .onClick(() => {
                this.controller.refresh()
                console.debug(`网页开始刷新`)
              })
              .height(40)
              .layoutWeight(1)
              .fontColor('#007DFF')
              .backgroundColor(Color.White)
              .borderRadius(20)
              .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
            Button(`用其他应用打开`)
              .onClick(async () => {
                await downloadHTML(this.htmlStr, this.getUIContext())
              })
              .height(40)
              .layoutWeight(1)
              .fontColor('#007DFF')
              .backgroundColor(Color.White)
              .borderRadius(20)
              .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        }
        
        List(){
          ListItem(){
            Web({ src: `data:text/html, <html><body></body></html>`, controller: this.controller })
              .align(Alignment.Bottom)
              .WebStyles()
              .onLoadFinished(() => {
                this.loadMode &= ~LoadMode.Rendering
                console.debug(`调试：网页加载完成`)
              })
              .onErrorReceive(( event ) => {
                let request = event.request
                let error = event.error
                console.error(`调试：错误码${error.getErrorCode()}\n错误信息：${error.getErrorInfo()}\n对应请求：${request.getRequestUrl()}\n主框架：${request.isMainFrame()}`)
                return
              })
              .onHttpErrorReceive((event) => {
                console.error(`调试：httpError收到`)
              })
          }
          .backgroundColor(Color.White)
          .borderRadius(16)
          .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
          .padding(12)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .title(this.pageTitle)
    .backgroundColor('#F1F3F5')
    .onReady(async (context) => {
      let param = context.pathInfo.param as CommonMsgToDetailMsgNavParams
      this.pageTitle = param.title
      this.messageId = param.id
      let content = await tongjiApi.getDetailMsg(param.id)
      this.loadMode &= ~LoadMode.Fetching
      this.loadMode |= LoadMode.Rendering
      this.content = content ?? '加载失败'
      this.htmlStr = `<html>${this.head}<body>${this.content}</body></html>`
      try {
        this.controller.loadData(this.htmlStr, 'text/html', 'utf-8')
      } catch (e) {
        console.error(`调试：加载网页失败\n${JSON.stringify(e as object)}`)
      }
    })
    .onBackPressed(() => {
      try {
        if(this.controller.accessStep(-2)){
          this.controller.backward()
          return true
        }
      } catch (e){
        console.error(`调试：回退失败\n${JSON.stringify(e as object)}`)
      }
      return false
    })
  }
}
