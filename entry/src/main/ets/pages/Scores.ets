import { CommonInfoCard, CourseScoreCard } from '../components/InfoCard'
import { Global } from '../models/Global'
import { tongjiApi } from '../models/TongjiApi'
import { CreditInfo, TermScore } from '../models/UserModel'

@Component
export struct Scores{
  @State totalGradePoint: number = 0
  @State actualCredit: number = 0
  @State failingCredits: number = 0
  @State failingCourseCount: number = 0

  @State isLoaded: boolean = false

  async aboutToAppear(){
    try {
      await tongjiApi.getCourseScore()
      this.totalGradePoint = Global.courseScore.totalGradePoint
      this.actualCredit = Global.courseScore.actualCredit
      this.failingCredits = Global.courseScore.failingCredits
      this.failingCourseCount = Global.courseScore.failingCourseCount
      this.isLoaded = true
    }catch (e){
      console.error(JSON.stringify(e))
    }
  }

  build() {
    NavDestination(){
      Scroll(){

        Column(){
          Grid(){
            GridItem(){
              Column(){
                Text('总绩点')
                  .fontSize(24)
                  .textAlign(TextAlign.Center)
                Text(this.totalGradePoint.toFixed(2))
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
              }
            }
            GridItem(){
              Column(){
                Text('总学分')
                  .fontSize(24)
                  .textAlign(TextAlign.Center)
                Text(this.actualCredit.toFixed(2))
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
              }
            }
            GridItem(){
              Column(){
                Text('总失利学分')
                  .fontSize(24)
                  .textAlign(TextAlign.Center)
                Text(this.failingCredits.toFixed(2))
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
              }
            }
            GridItem(){
              Column(){
                Text('失利门数')
                  .fontSize(24)
                  .textAlign(TextAlign.Center)
                Text(this.failingCourseCount.toString())
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
              }
            }
          }
          .backgroundColor($r('sys.color.ohos_id_color_background'))
          .borderRadius(16)
          .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
          .columnsTemplate('1fr 1fr')
          .height(120)
          if(this.isLoaded){
            ForEach(Global.courseScore.termScoreList, (course: TermScore) => {
              Column(){
                Text(course.termName)
                  .fontSize(22)
                  .textAlign(TextAlign.Center)
                Text(`平均绩点: ${course.averagePoint.toFixed(2)}`)
                  .fontSize(22)
                ForEach(course.creditInfoList, (creditInfo: CreditInfo) =>{
                  CourseScoreCard({creditInfo})
                })
              }
            })
          }
        }
        .width('100%')
      }
      .expandSafeArea()
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ left: 16, right: 16, top: 16 })
    }
    .title("成绩")
  }
}