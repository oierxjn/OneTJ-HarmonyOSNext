import { asyncSleep } from '../components/Funcs';
import { initKVManager } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { OAuthCode, TokenData } from '../models/UserModel';
import { Home } from './Home';
import { LoginOAuthWebView } from './LoginOAuthWebView';

export enum PageName{
  HomePage = 'Page_Home',
  LoginOAuthWebView = 'Page_LoginOAuth_WebView'
}

const REFRESH_TOKEN: boolean = true
const AUTO_LOGIN_DELAY: number = 0

@Entry
@Component
struct Login {
  @State appTitle: Resource | string = $r('app.string.EntryAbility_label');

  @State loginButtonText: Resource | string = $r('app.string.Uni_login');
  @State allowLogin: boolean = false;

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

  async aboutToAppear(): Promise<void> {
    this.loginButtonText = '自动登录中'
    this.allowLogin = false

    if(!await initKVManager(this.getUIContext().getHostContext()!!)){
      console.error('KVManager初始化失败')
      return
    }
    await TokenData.initKV()

    let result = await Promise.all([this.autoLogin(), asyncSleep(AUTO_LOGIN_DELAY)])
    if(result[0]){
      this.navPathStack.pushPath({name: PageName.HomePage})
    }else{
      this.loginButtonText = $r('app.string.Uni_login')
      this.allowLogin = true
    }
  }

  async autoLogin(refreshFlag: boolean = REFRESH_TOKEN): Promise<boolean>{
    try {
      if(await initKVManager(this.getUIContext().getHostContext()!!)){
        await TokenData.loadFromKV()
        if(!TokenData.isFetched){
          throw new Error('未获取到Token')
        }
        if(refreshFlag){
          return await tongjiApi.refreshAccessToken()
        }else return tongjiApi.isTokenAvailable()
      }
    } catch (e){
      console.error(e)
    }
    return false
  }

  build() {
    Navigation(this.navPathStack){
      Column() {
        RelativeContainer() {
          Text(this.appTitle)
            .id('title_text')
            .fontSize($r('app.float.page_text_font_size')).fontWeight(FontWeight.Bold)
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              top: { anchor: '__container__', align: VerticalAlign.Top }
            })
            .onClick(() => {
              this.appTitle = 'Welcome';
            })

          Column(){
            Button(this.loginButtonText)
              .fontSize($r('app.float.page_text_normal_size')).fontColor($r('app.color.black'))
              .width("80%")
              .padding({
                top:$r('app.float.text_vertical_padding'),
                bottom: $r('app.float.text_vertical_padding')
              })
              .backgroundColor($r('app.color.start_window_button_background'))
              .margin({bottom: "5%",top: "10%"})
              .onClick(async () => {
                if(!this.allowLogin)return;
                if(TokenData.isFetched){
                  this.navPathStack.pushPath({name: PageName.HomePage})
                }else{
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
      .onVisibleAreaChange([0.0, 1.0], async (isExpend, _) => {
        if(isExpend){
          if(OAuthCode.isFetched){
            let enterHome: boolean = await tongjiApi.code2token(OAuthCode.code!!)
            if(enterHome){
              setTimeout(() => {
                this.navPathStack.pushPath({name: PageName.HomePage})
              })
            }else{
              OAuthCode.isFetched = false
            }
          }
        }
      })
    }
    .navDestination(this.pageMap)
  }
}