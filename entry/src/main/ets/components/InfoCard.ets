import { CourseInfo } from "../models/UserModel"
import { PageName } from "../pages/Login"
import { LengthMetrics } from "@kit.ArkUI"


@Component
export struct CourseInfoCard {
  @Require course: CourseInfo

  build() {
    Row() {
      Image($rawfile('fluentemoji/banana_color.svg'))
        .width('20%')
      Divider()
        .vertical(true)
        .margin({left: 5, right: 5})
        .visibility(Visibility.Hidden)
      Column() {
        Text(this.course.courseName)
          .fontSize(24)
        Text(`地点：${this.course.room}`)
          .fontSize(20)
        Text(`教师：${this.course.teacher}`)
          .fontSize(20)
      }
        .alignItems(HorizontalAlign.Start)
        .width('60%')
    }
    .width('100%')
    .height('100%')
    .border({
      width: 1,
      radius: '5%'
    })
  }
}

function getFoldedText(text: string){

}

@AnimatableExtend(Column)
function animatableHeight(height: string | number){
  .width(height)
}
let minTextHeight: number = 100


@Component({freezeWhenInactive: true})
export struct MsgInfoCard {
  @Require @State title: string = "Info"
  @Require @State time: string = 'Time'
  @Require msgId: number | undefined

  @State isFolded: boolean = true
  @State textMaxLines: number = 3
  @State textHeight: number = minTextHeight

  @Consume('navPathStack') navPathStack: NavPathStack

  build() {
    Column() {
      Column(){
        Text(this.title)
          .fontSize(16)
          .maxLines(this.textMaxLines)
          .textOverflow({overflow: TextOverflow.Ellipsis})
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      Blank()
      Column(){
        Text(this.time)
          .fontSize(16)
      }
      .width('100%')
      .alignItems(HorizontalAlign.End)
    }
    .onClick(() => {
      this.navPathStack.pushPath({name: PageName.DetailMsgPage, param: Object({id: this.msgId, title: this.title})})
    })
    .clickEffect({ level: ClickEffectLevel.HEAVY })
    .width('100%')
    .height(this.textHeight)
    .border({
      width: 1,
      radius: '5%',
      color: $r('sys.color.ohos_id_color_foreground')
    })
    .padding({top: 5, bottom: 5, left: 10, right: 10})
  }
}