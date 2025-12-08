import { asyncSleep, fetchNewWallpaper, wallpaperPixelMap } from '../components/Funcs';
import { initKVManager } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { OAuthCode, TokenData } from '../models/UserModel';
import { DetailMsg } from './DetailMsg';
import { Home } from './Home';
import { LoginOAuthWebView } from './LoginOAuthWebView';
import image from '@ohos.multimedia.image';

export enum PageName{
  HomePage = 'Page_Home',
  LoginOAuthWebView = 'Page_LoginOAuth_WebView',
  DetailMsgPage = 'Page_Detail_Msg'
}
// TODO 不进行令牌刷新
const REFRESH_TOKEN: boolean = false
const AUTO_LOGIN_DELAY: number = 0

// @Styles
// function backgroundAnimation{
//
// }



@Entry
@Component
struct Login {
  @State appTitle: Resource | string = $r('app.string.EntryAbility_label');

  @State loginButtonText: Resource | string = $r('app.string.Uni_login');
  @State allowLogin: boolean = false;
  @State wallpaper: string | image.PixelMap = '#40942610'
  @State backgroundOpacity: number = 0;

  @State colorTheme: Array<Array<[string, number]>> = [
    [['#FF000000', 0.0], ['#FF000000', 1]],
    [['#ff32d043', 0.0], ['#ffff4136', 1]]
  ]

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string){
    if(name == PageName.HomePage){
      Home()
    }else if(name == PageName.LoginOAuthWebView){
      LoginOAuthWebView()
    }else if(name == PageName.DetailMsgPage){
      DetailMsg()
    }
  }

  async aboutToAppear(): Promise<void> {
    this.loginButtonText = '自动登录中'
    this.allowLogin = false

    let wallpaperTask = this.setWallPaper()
    if(!await initKVManager(this.getUIContext().getHostContext()!!)){
      console.error('KVManager初始化失败')
      return
    }

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
      await TokenData.initKV()
      await TokenData.loadFromKV()
      if(!TokenData.isFetched){
        throw new Error('未获取到Token')
      }
      if(refreshFlag){
        return await tongjiApi.refreshAccessToken()
      }else return tongjiApi.isTokenAvailable()
    } catch (e){
      console.error(e)
    }
    return false
  }

  async setWallPaper(){
    console.debug(`调试：准备开始设置壁纸`)
    if(await fetchNewWallpaper(this.getUIContext())){
      this.wallpaper = wallpaperPixelMap!!
      this.backgroundOpacity = 1
      console.debug(`调试：壁纸设置完成`)
    }
  }

  async onPageShow(){
    if(tongjiApi.switchRequire){
      this.loginButtonText = $r('app.string.Uni_login')
      this.allowLogin = true
    }
  }


  build() {
    Stack(){
      Column()
        .backgroundImage(this.wallpaper)
        .opacity(this.backgroundOpacity)
        .animation({duration: 1000})
        .width('100%').height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
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
              .shaderStyle({
                direction: GradientDirection.Right,
                colors: this.colorTheme[this.backgroundOpacity]
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
            .backgroundBlurStyle(BlurStyle.Thin)
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
        // Column()
        // .width('100%').height('100%')
      }
      .backgroundColor('#00000000')
      .navDestination(this.pageMap)
      .width('100%').height('100%')
    }
  }
}
