import { Global } from '../models/Global'
import { tongjiApi } from '../models/TongjiApi'

@Component
export struct Scores{
  @State totalGradePoint: number = 0
  @State actualCredit: number = 0
  @State failingCredits: number = 0
  @State failingCourseCount: number = 0

  async aboutToAppear(){
    try {
      await tongjiApi.getCourseScore()
      this.totalGradePoint = Global.courseScore.totalGradePoint
      this.actualCredit = Global.courseScore.actualCredit
      this.failingCredits = Global.courseScore.failingCredits
      this.failingCourseCount = Global.courseScore.failingCourseCount
    }catch (e){
      console.error(JSON.stringify(e))
    }
  }

  build() {
    NavDestination(){
      Column(){
        Grid(){
          GridItem(){
            Column(){
              Text('总绩点')
                .fontSize(16)
                .textAlign(TextAlign.Center)
              Text(this.totalGradePoint.toFixed(2))
                .fontSize(16)
                .textAlign(TextAlign.Center)
            }
          }
          GridItem(){
            Column(){
              Text('总学分')
                .fontSize(16)
                .textAlign(TextAlign.Center)
              Text(this.actualCredit.toFixed(2))
                .fontSize(16)
                .textAlign(TextAlign.Center)
            }
          }
          GridItem(){
            Column(){
              Text('总失利学分')
                .fontSize(16)
                .textAlign(TextAlign.Center)
              Text(this.failingCredits.toFixed(2))
                .fontSize(16)
                .textAlign(TextAlign.Center)
            }
          }
          GridItem(){
            Column(){
              Text('失利门数')
                .fontSize(16)
                .textAlign(TextAlign.Center)
              Text(this.failingCourseCount.toString())
                .fontSize(16)
                .textAlign(TextAlign.Center)
            }
          }
        }
        .columnsTemplate('1fr 1fr')
      }
      .width('100%').height('100%')
      .expandSafeArea()
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ left: 16, right: 16, top: 16 })
    }
    .title("成绩")
  }
}