import { PageName } from "../pages/Login"


@Component
export struct CourseInfoCard {
  @State info: string = "Info"
  build() {
    Row() {
      Column() {
        Text(this.info)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#25303345')
        Button()
          .onClick(() => {
            this.info = "Click"
          })
      }
      .alignItems(HorizontalAlign.Center)
      .width('70%')
      Image($rawfile('fluentemoji/banana_color.svg'))
        .width('30%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#35253033')
    .borderRadius('5%')
  }
}

function getFoldedText(text: string){

}

@AnimatableExtend(Column)
function animatableHeight(height: string | number){
  .width(height)
}
let minTextHeight: string = '17%'


@Component({freezeWhenInactive: true})
export struct MsgInfoCard {
  @Require @State title: string = "Info"
  @Require @State time: string = 'Time'
  @Require msgId: number | undefined

  @State isFolded: boolean = true
  @State textMaxLines: number = 3
  @State textHeight: string = minTextHeight

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
    .border({width: 1, radius: '5%'})
    .padding({top: 5, bottom: 5, left: 10, right: 10})
  }
}