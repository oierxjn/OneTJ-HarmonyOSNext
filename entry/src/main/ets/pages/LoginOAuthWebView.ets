import { webview } from "@kit.ArkWeb";
import { TongjiApiUrlConstants } from "../constants/WebUrlConstants";
import { url } from "@kit.ArkTS";
import { OAuthCode } from "../models/UserModel";
import { buildAlertDialog } from "../DisplayUtils/AlertDialogUtils";
import { tongjiApi } from "../models/TongjiApi";
import { PageName } from "./Login";
import { deviceInfo } from "@kit.BasicServicesKit";

@Extend(Web)
function WebStyles(){
  .domStorageAccess(true)
  .imageAccess(true)
  .overScrollMode(OverScrollMode.ALWAYS)
  .zoomAccess(true)
  .javaScriptAccess(true)
  .allowWindowOpenMethod(true)
  .mixedMode(MixedMode.All)
  .darkMode(WebDarkMode.Auto)
  .forceDarkAccess(true)
}

class WebModifier implements AttributeModifier<WebAttribute>{
  applyNormalAttribute(instance: WebAttribute): void {
    if(deviceInfo.sdkApiVersion >= 21){
      instance.forceEnableZoom(true)
    }
  }
}

export let loginWebviewTag: string = 'LoginWebView'

@Component
export struct LoginOAuthWebView {
  @State message: string = 'Hello World';

  @State webModifier: WebModifier = new WebModifier()

  @Consume('navPathStack') navPathStack: NavPathStack
  private webController: WebviewController = new webview.WebviewController(loginWebviewTag)

  build() {
    NavDestination(){
      Web({src: '', controller: this.webController})
        .onControllerAttached(() => {
          let OAuthUrl = TongjiApiUrlConstants.OAUTH_BASE_URL
          let scopeStr = TongjiApiUrlConstants.SCOPE_LIST.join(" ")
          OAuthUrl += `&scope=${scopeStr}`
          try {
            this.webController.loadUrl(OAuthUrl)
          }catch (e){
            console.error(e)
          }
        })
        .onLoadIntercept((event) => {
          let targetUrl = event.data.getRequestUrl()
          if(targetUrl.startsWith(TongjiApiUrlConstants.OAUTH_REDIRECT_URL)) {
            let urlParams = new url.URLParams(targetUrl)
            OAuthCode.code = urlParams.get("code")
            OAuthCode.error = urlParams.get("error")
            if(OAuthCode.code){
              OAuthCode.isFetched = true
              this.navPathStack.pop()
              // 将页面跳转抛出
              setTimeout(async () => {
                let enterHome: boolean = await tongjiApi.code2token(OAuthCode.code!!)
                if(enterHome){
                  this.navPathStack.pushPath({name: PageName.HomePage})
                }else{
                  OAuthCode.isFetched = false
                }
              })
            }else{
              buildAlertDialog(this.getUIContext(), OAuthCode.error)
              console.error(`错误：${OAuthCode.error}`)
            }
          }
          return false
        })
        .WebStyles()
        .attributeModifier(this.webModifier)
    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}