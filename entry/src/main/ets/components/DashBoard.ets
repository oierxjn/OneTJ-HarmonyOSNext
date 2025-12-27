import { HomeFunctionItem, HomeFunctions } from "../DisplayUtils/DataUtils"
import { UIContext } from "@kit.ArkUI"
import { tongjiApi } from "../models/TongjiApi"
import { webview } from "@kit.ArkWeb"
import { loginWebviewTag } from "../pages/LoginOAuthWebView"
import { PageName } from "../pages/Login"

// TODO 主要功能
let HomeFunctionMap: Record<HomeFunctions, (navPathStack: NavPathStack, context?: UIContext) => void> = {
  [HomeFunctions.GRADUATE_STUDENT_TIME_TABLE_SINGLE_DAY]: (navPathStack) => {
    navPathStack.pushPath({name: PageName.StudentTimeTablePage})
  },
  [HomeFunctions.NONE]: (): void => {
    return
  },
  [HomeFunctions.SETTINGS]: (): void => {
    throw new Error("Function not implemented.")
  },
  [HomeFunctions.ABOUT]: (navPathStack: NavPathStack): void => {
    navPathStack.pushPath({name: PageName.AboutPage})
  },
  [HomeFunctions.LOGOUT]: (navPathStack): void => {
    setTimeout(async () =>{
      tongjiApi.switchRequire = true
      let clearLoginDataTask = tongjiApi.clearLoginData()
      let clearLoginCookie = webview.WebCookieManager.clearAllCookies()
      navPathStack.pop()
      await Promise.all([clearLoginDataTask, clearLoginCookie])
    })
  },
  [HomeFunctions.JOIN_QQ_GROUP]: (_, context): void => {
    throw new Error("Function not implemented.")
  },
  [HomeFunctions.EXP_CALC]: (navPathStack: NavPathStack): void => {
    navPathStack.pushPath({name: PageName.PhysicalExperimentPage})
  }
}


@Component
export struct DashBoard {

  @Consume('navPathStack') navPathStack: NavPathStack

  HomeFuncList: HomeFunctionItem[] = new Array<HomeFunctionItem>()
  async aboutToAppear() {
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.GRADUATE_STUDENT_TIME_TABLE_SINGLE_DAY, '今日课程', $rawfile('fluentemoji-png/alarm_clock_3d.png')))
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.EXP_CALC, '实验计算', $rawfile('fluentemoji-png/microscope_3d.png')))
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.LOGOUT, '退出登录', $rawfile('fluentemoji-png/wilted_flower_3d.png')))
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.JOIN_QQ_GROUP, '加讨论群', $rawfile('fluentemoji-png/zany_face_3d.png')))
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.ABOUT, '关于应用', $rawfile('fluentemoji-png/teddy_bear_3d.png')))
    this.HomeFuncList.push(new HomeFunctionItem(HomeFunctions.SETTINGS, '应用设置', $rawfile('fluentemoji-png/gear_3d.png')))
  }


  build() {
    Grid(){
      ForEach(this.HomeFuncList, (item: HomeFunctionItem, index: number) => {
        GridItem(){
          Column(){
            Image(item.icon)
              .width(40)
              .height(40)
              .objectFit(ImageFit.Contain)
              .draggable(false)
            Text(item.name)
              .fontSize(14)
              .fontColor('#333333')
              .margin({ top: 8 })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            HomeFunctionMap[item.uid](this.navPathStack, this.getUIContext())
          })
        }
        .clickEffect({ level: ClickEffectLevel.LIGHT })
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .rowsGap(12)
    .columnsGap(12)
    .padding(12)
  }
}