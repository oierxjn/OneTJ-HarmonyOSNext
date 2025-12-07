import { webview } from "@kit.ArkWeb";
import { TongjiApiUrlConstants } from "../constants/WebUrlConstants";
import { url } from "@kit.ArkTS";
import { OAuthCode } from "../models/UserModel";
import { buildAlertDialog } from "../DisplayUtils/AlertDialogUtils";
import { tongjiApi } from "../models/TongjiApi";

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
export struct LoginOAuthWebView {
  @State message: string = 'Hello World';
  @State appearDone: boolean = false;

  @Consume('navPathStack') navPathStack: NavPathStack
  private webController: WebviewController = new webview.WebviewController()

  async aboutToAppear() {
    if(tongjiApi.switchRequire){
      await webview.WebCookieManager.clearAllCookies()
      this.appearDone = true
    }
  }

  build() {
    NavDestination(){
      if(this.appearDone){
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
              }else{
                buildAlertDialog(this.getUIContext(), OAuthCode.error)
                console.error(`错误：${OAuthCode.error}`)
              }
            }
            return false
          })
          .WebStyles()
      }
    }
    // .backgroundImage()
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}