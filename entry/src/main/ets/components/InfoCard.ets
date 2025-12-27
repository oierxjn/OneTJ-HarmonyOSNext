import { CourseInfo } from "../models/UserModel"
import { PageName } from "../pages/Login"
import { LengthMetrics } from "@kit.ArkUI"

@Component
export struct CommonInfoCard {
  @Require title: string
  description: string = ''

  async aboutToAppear() {
    console.debug(`调试：${this.title}出现`)
  }

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
        if (this.description) {
          Text(this.description)
            .fontSize(14)
            .fontColor(Color.Gray)
            .margin({ top: 4 })
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
  }
}


@Component
export struct CourseInfoCard {
  @Require course: CourseInfo
  avatar: ResourceStr = $rawfile('fluentemoji/banana_color.svg')

  build() {
    Row() {
      Image(this.avatar)
        .width(60)
        .height(60)
        .objectFit(ImageFit.Contain)
        .margin({ right: 12 })
        
      Column() {
        Text(this.course.courseName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          
        Text(`地点：${this.course.room}`)
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          
        Text(`教师：${this.course.teacher}`)
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
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
  
  @Consume('navPathStack') navPathStack: NavPathStack

  build() {
    Column() {
      Column(){
        Text(this.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .maxLines(this.textMaxLines)
          .textOverflow({overflow: TextOverflow.Ellipsis})
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      
      Blank()
      
      Column(){
        Text(this.time)
          .fontSize(12)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .alignItems(HorizontalAlign.End)
      .margin({ top: 8 })
    }
    .onClick(() => {
      this.navPathStack.pushPath({name: PageName.DetailMsgPage, param: Object({id: this.msgId, title: this.title})})
    })
    .clickEffect({ level: ClickEffectLevel.HEAVY })
    .width('100%')
    .constraintSize({ minHeight: 80 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
    .padding(12)
  }
}