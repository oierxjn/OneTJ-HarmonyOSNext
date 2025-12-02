import { OAuthCode } from '../models/UserModel';
import { Home } from './Home';
import { LoginOAuthWebView } from './LoginOAuthWebView';

export enum PageName{
  HomePage = 'Page_Home',
  LoginOAuthWebView = 'Page_LoginOAuth_WebView'
}

@Entry
@Component
struct Login {
  @State message: Resource | string = $r('app.string.EntryAbility_label');

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string){
    if(name == PageName.HomePage){
      Home()
    }
    if(name == PageName.LoginOAuthWebView){
      LoginOAuthWebView()
    }
  }
  build() {
    Navigation(this.navPathStack){
      Column() {
        RelativeContainer() {
          Text(this.message)
            .id('title_text')
            .fontSize($r('app.float.page_text_font_size')).fontWeight(FontWeight.Bold)
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              top: { anchor: '__container__', align: VerticalAlign.Top }
            })
            .onClick(() => {
              this.message = 'Welcome';
            })

          Column(){
            Button($r('app.string.Uni_login'))
              .fontSize($r('app.float.page_text_normal_size')).fontColor($r('app.color.black'))
              .width("80%")
              .padding({
                top:$r('app.float.text_vertical_padding'),
                bottom: $r('app.float.text_vertical_padding')
              })
              .backgroundColor($r('app.color.start_window_button_background'))
              .margin({bottom: "5%",top: "10%"})
              .onClick(async () => {
                // TODO: 删掉调试
                let codeData = OAuthCode.code || 1
                let errorData = OAuthCode.error
                if(codeData != null){
                  console.log("code获取完成")
                  this.navPathStack.pushPath({name: PageName.HomePage})
                }else{
                  console.error(errorData)
                  this.navPathStack.pushPath({name: PageName.LoginOAuthWebView})
                }
              })
            Button($r('app.string.Join_in_group'))
              .fontSize($r('app.float.page_text_normal_size')).fontColor($r('app.color.black'))
              .width("80%")
              .padding({
                top:$r('app.float.text_vertical_padding'),
                bottom: $r('app.float.text_vertical_padding')
              })
              .backgroundColor($r('app.color.start_window_button_background'))
              .margin({bottom: "10%",top: "5%"})
          }
          .borderRadius('10%')
          .backgroundColor($r('app.color.blue'))
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            top: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .width('80%')
        }
        .height('80%').width('100%')
      }
      .justifyContent(FlexAlign.Center)
      .width('100%').height('100%')
    }
    .navDestination(this.pageMap)
  }
}