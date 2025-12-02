import { webview } from "@kit.ArkWeb";
import { WebUrlConstants } from "../constants/WebUrlConstants";
import { url } from "@kit.ArkTS";
import { OAuthCode } from "../models/UserModel";

@Component
export struct LoginOAuthWebView {
  @State message: string = 'Hello World';

  @Consume('navPathStack') navPathStack: NavPathStack
  private webController: WebviewController = new webview.WebviewController()

  build() {
    NavDestination(){
      Web({src: '', controller: this.webController})
        .javaScriptAccess(true)
        .onControllerAttached(() => {
          let OAuthUrl = WebUrlConstants.OAUTH_BASE_URL
          let scopeStr = WebUrlConstants.SCOPE_LIST.join(" ")
          OAuthUrl += `&scope=${scopeStr}`
          try {
            this.webController.loadUrl(OAuthUrl)
          }catch (e){
            console.error(e)
          }
        })
        .onLoadIntercept((event) => {
          let targetUrl = event.data.getRequestUrl()
          if(targetUrl.startsWith(WebUrlConstants.OAUTH_REDIRECT_URL)) {
            let urlParams = new url.URLParams(targetUrl)
            OAuthCode.code = urlParams.get("code")
            OAuthCode.error = urlParams.get("error")

            // console.info(`code: ${code}\n error: ${error}`)
            this.navPathStack.pop()
          }
          return false
        })

    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}