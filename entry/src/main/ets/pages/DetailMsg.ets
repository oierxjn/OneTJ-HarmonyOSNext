import { CommonMsgToDetailMsgNavParams } from "../DisplayUtils/DataUtils"
import { tongjiApi } from "../models/TongjiApi"
import { webview } from "@kit.ArkWeb"
import { FailureCode } from "@ohos.app.ability.CompletionHandlerForAtomicService"
import { UIContext } from "@kit.ArkUI"
import { fileIo } from "@kit.CoreFileKit"

enum LoadMode{
  Fetching = 1<<0,
  Rendering = 1<<1
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
      if (this.loadMode & LoadMode.Fetching) {
        Text('详情拉取中')
          .fontSize(30)
      } else if (this.loadMode & LoadMode.Rendering) {
        Text('网页渲染中')
          .fontSize(30)
      }
      Web({ src: `data:text/html, <html><body></body></html>`, controller: this.controller })
        .width('100%')
        .height('95%')
        .align(Alignment.Bottom)
        .domStorageAccess(true)
        .imageAccess(true)
        .overScrollMode(OverScrollMode.ALWAYS)
        .zoomAccess(true)
        .forceEnableZoom(true)
        .javaScriptAccess(true)
        .allowWindowOpenMethod(true)
        .mixedMode(MixedMode.All)
    }
    .title(this.pageTitle)
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
      this.loadMode &= ~LoadMode.Rendering
    })
    .onBackPressed(() => {
      try {
        if(this.controller.accessBackward()){
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