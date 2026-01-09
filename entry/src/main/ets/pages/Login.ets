import { asyncSleep, fetchNewWallpaper, wallpaperPixelMap } from '../components/Funcs';
import { initKVManager } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { OAuthCode, TokenData } from '../models/UserModel';
import { DetailMsg } from './DetailMsg';
import { Home } from './Home';
import { LoginOAuthWebView } from './LoginOAuthWebView';
import image from '@ohos.multimedia.image';
import { StudentTimeTable } from './StudentTimeTable';
import { PhysicalExperiment } from './PhysicalExperiment';
import { BohrTwistPendulum } from './physicalExperimentPages/BohrTwistPendulum';
import { ExperimentHelp } from './helpPages/ExperimentHelp';
import bundleManager from '@ohos.bundle.bundleManager'
import { About } from './About';
import { JoinGroup } from './JoinGroup';
import { Settings } from './Settings';
import { PrivacyPolicy } from './PrivacyPolicy';
import { deviceInfo } from '@kit.BasicServicesKit';
import { font } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

export enum PageName{
  HomePage = 'Page_Home',
  LoginOAuthWebView = 'Page_LoginOAuth_WebView',
  DetailMsgPage = 'Page_Detail_Msg',
  StudentTimeTablePage = 'Page_Student_Time_Table',
  PhysicalExperimentPage = 'Page_Physical_Experiment',
  AboutPage = 'Page_About',
  JoinGroupPage = 'Page_Join_Group',
  SettingsPage = 'Page_Settings',
  PrivacyPolicyPage = 'Page_Privacy_Policy',
}

export enum PhysicalExperimentSub{
  BohrTwistPendulumPage = 'Page_Physical_Experiment_Bohr_Twist_Pendulum',
}

export enum HelpSub{
  ExperimentHelpPage = 'Page_Help_Experiment_Help',
}

export let bundleInfo: undefined | bundleManager.BundleInfo

const REFRESH_TOKEN: boolean = true
const AUTO_LOGIN_DELAY: number = 0


AppStorage.setOrCreate('allowLogin', false)
AppStorage.setOrCreate('loginButtonText', $r('app.string.Uni_login'))

@Entry
@Component
struct Login {
  @State appTitle: Resource | string = $r('app.string.EntryAbility_label');

  @StorageLink('loginButtonText') loginButtonText: Resource | string = $r('app.string.Uni_login');
  @StorageLink('allowLogin') allowLogin: boolean = false;
  @State wallpaper: string | image.PixelMap = '#40942610'
  @State backgroundOpacity: number = 0;

  @State colorTheme: Array<Array<[ResourceStr, number]>> = [
    [[$r('sys.color.ohos_id_color_text_primary'), 0.0], [$r('sys.color.ohos_id_color_text_primary'), 1]],
    [['#ff32d043', 0.0], ['#ffff4136', 1]]
  ]

  uiContext = this.getUIContext()
  promptAction = this.uiContext.getPromptAction()

  titleTextFamily:string = 'HarmonyOS Sans SC'


  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  // 导航图 pageMap
  @Builder
  pageMap(name: string){
    if(name == PageName.HomePage){
      Home()
    }else if(name == PageName.LoginOAuthWebView){
      LoginOAuthWebView()
    }else if(name == PageName.DetailMsgPage){
      DetailMsg()
    }else if(name == PageName.PrivacyPolicyPage) {
      PrivacyPolicy()
    }else if(name == PageName.StudentTimeTablePage){
      StudentTimeTable()
    }else if(name == PageName.PhysicalExperimentPage) {
      PhysicalExperiment()
    }else if(name == PageName.JoinGroupPage){
      JoinGroup()
    }else if(name == PageName.AboutPage){
      About()
    }else if(name == PageName.SettingsPage){
      Settings()
    }else if(name == PhysicalExperimentSub.BohrTwistPendulumPage){
      BohrTwistPendulum()
    }else if(name == HelpSub.ExperimentHelpPage){
      ExperimentHelp()
    }
  }

  async aboutToAppear(): Promise<void> {
    // 轻量字体设置
    console.debug('[ONETJ] Login Begin')
    this.getUIContext().getFont().registerFont({
      familyName: 'SanJiPoMoTi',
      familySrc: $rawfile('font/SanJiPoMoTi-2-slim.ttf')
    })
    this.titleTextFamily = 'SanJiPoMoTi'

    this.loginButtonText = '自动登录中'
    this.allowLogin = false

    let wallpaperTask = this.setWallPaper()
    let bundleInfoTask = this.getBundleInfo()
    if(!await initKVManager(this.getUIContext().getHostContext()!!)){
      console.error('KVManager初始化失败')
      return
    }

    let result = await Promise.all([this.autoLogin(), asyncSleep(AUTO_LOGIN_DELAY)])
    if(result[0]){
      setTimeout(()=>{
        this.navPathStack.pushPath({name: PageName.HomePage})
      })
    }else{
      this.loginButtonText = $r('app.string.Uni_login')
      this.allowLogin = true
    }
    Promise.all([wallpaperTask, bundleInfoTask])
  }

  async getBundleInfo(){
    bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
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
    console.debug(`准备开始设置壁纸`)
    try {
      await fetchNewWallpaper(this.getUIContext())
      this.wallpaper = wallpaperPixelMap!!
      this.backgroundOpacity = 1
      console.debug(`壁纸设置完成`)
    } catch (e){
      this.promptAction.showToast({message: `壁纸设置时发生错误：${JSON.stringify(e)}`})
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
        Column({space : 20}) {
          Row(){
            Text(this.backgroundOpacity ? this.appTitle : this.appTitle)
              .id('title_text')
              .fontSize($r('app.float.page_text_font_size')).fontFamily(this.titleTextFamily)
              .onClick(() => {
                this.titleTextFamily = 'HarmonyOS Sans SC'
                this.appTitle = '欢迎来到同济';
              })
              .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
          }
            .linearGradient({
              direction: GradientDirection.Right,
              colors: this.colorTheme[this.backgroundOpacity]
            })
            .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)


          Column(){
            Button(this.loginButtonText)
              .fontSize($r('app.float.page_text_normal_size')).fontColor($r('sys.color.ohos_id_color_text_primary'))
              .width("80%")
              .padding({
                top:$r('app.float.text_vertical_padding'),
                bottom: $r('app.float.text_vertical_padding')
              })
              .backgroundColor($r('app.color.start_window_button_background'))
              .margin({bottom: "5%",top: "10%"})
              .onClick(()=>{
                setTimeout(async () => {
                  if (!this.allowLogin) return;
                  if (TokenData.isFetched) {
                    this.navPathStack.pushPath({ name: PageName.HomePage })
                  } else {
                    this.navPathStack.pushPath({ name: PageName.LoginOAuthWebView })
                  }
                })
              })
            Button($r('app.string.Join_in_group'))
              .fontSize($r('app.float.page_text_normal_size')).fontColor($r('sys.color.ohos_id_color_text_primary'))
              .width("80%")
              .padding({
                top:$r('app.float.text_vertical_padding'),
                bottom: $r('app.float.text_vertical_padding')
              })
              .backgroundColor($r('app.color.start_window_button_background'))
              .margin({bottom: "10%",top: "5%"})
              .onClick(()=>{
                this.navPathStack.pushPath({name: PageName.JoinGroupPage})
              })
            Text(`登录本应用则视为已同意`)
              .textAlign(TextAlign.Center)
            Text(`『一统同济用户隐私政策』`)
              .fontColor(Color.Blue)
              .onClick(()=>{
                this.navPathStack.pushPath({name: PageName.PrivacyPolicyPage})
              })
              .textAlign(TextAlign.Center)
          }
          .borderRadius('10%')
          .backgroundBlurStyle(BlurStyle.Thin)
          .width('80%')
          .alignRules({bottom: {anchor: '__container__', align: VerticalAlign.Bottom}})
        }
        .justifyContent(FlexAlign.Center)
        .width('100%').height('100%')
      }
      .backgroundColor('#00000000')
      .navDestination(this.pageMap)
      .width('100%').height('100%')
    }
  }
}
