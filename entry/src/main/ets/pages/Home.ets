import { CourseInfoCard, MsgInfoCard } from '../components/InfoCard'
import { buildAlertDialog } from '../DisplayUtils/AlertDialogUtils'
import { ListDataSource } from '../DisplayUtils/DataUtils'
import { tongjiApi } from '../models/TongjiApi'
import { SchoolCalendarInfo, StudentInfo } from '../models/UserModel'


@Component
export struct Home {
  @Consume('navPathStack') navPathStack: NavPathStack

  @State arr: ListDataSource<number> = new ListDataSource([1,2,3,4,5,6,9])

  @State avatarSrc: ResourceStr = $rawfile('fluentemoji/banana_color.svg')

  @State studentNameAndId: string = '黄泽华'
  @State deptName: string = '继续搞事学院'
  @State currentGrade: string = '114514级'

  @State termSimpleName: string = '1919-9178学年度第0学期 第13周'

  async aboutToAppear(): Promise<void> {
    let studentInfoTask = this.createStudentInfoTask()
    let termInfoTask = this.createTermInfoTask()
    await Promise.all([studentInfoTask, termInfoTask])
  }

  async createStudentInfoTask(): Promise<void> {
    await StudentInfo.initKV()
    await StudentInfo.loadFromKV()
    if(!StudentInfo.isFetched){
      if(!await tongjiApi.getStudentInfo()){
        console.error('获取学生信息失败')
        return
      }
    }
    try {
      this.studentNameAndId = `${StudentInfo.studentName}  ${StudentInfo.studentId}`
      this.deptName = StudentInfo.deptName!!
      // TODO BUG : 未知Bug，应当在空闲时间上报
      this.currentGrade = StudentInfo.currentGrade + '级'
    } catch (e){
      console.error(`出现异常：${e}`)
    }
  }
  async createTermInfoTask(): Promise<void> {
    console.debug(`调试：进入TermInfoTask`)
    await SchoolCalendarInfo.initKV()
    await SchoolCalendarInfo.loadFromKV()
    if(!SchoolCalendarInfo.isFetched){
      if(!await tongjiApi.getSchoolCalendarInfo()){
        console.error('调试：获取学期信息失败')
        return
      }
    }
    try {
      this.termSimpleName = `${SchoolCalendarInfo.simpleName} 第${SchoolCalendarInfo.schoolWeek}周`
    } catch (e){
      console.error(`出现异常：${e}`)
    }
  }


  build() {
    NavDestination(){
      Column(){
        Column(){
          Row(){
            Image(this.avatarSrc)
              .width('30%')
            Column(){
              Text(this.studentNameAndId)
                .fontSize(27)
              Blank()
              Text(this.deptName)
                .fontSize(27)
              Blank()
              Text(this.currentGrade)
                .fontSize(27)
            }
            .alignItems(HorizontalAlign.Start)
            .height('100%').width('70%')
          }
          .width('90%').height('60%')
          Text(this.termSimpleName)
            .fontSize(22)
            .height('20%')
            .margin({bottom: '5%', top: '5%'})
        }
        .height('30%').width('100%')
        Divider()
          .margin({top: '5', bottom: '5'})
          .visibility(Visibility.Hidden)
        List(){
          LazyForEach(this.arr, (item: number, index: number) => {
            ListItem(){
              Column(){
                MsgInfoCard({title: `${item.toString()}索引${index}`, time: Date().toString()}).width('100%').height('20%')
                Divider()
                  .margin({top: '5', bottom: '5'})
                  .visibility(Visibility.Hidden)
              }
            }
          })
        }
        .height('70%').width('100%')
      }
      .margin({top: '10%', left: '5%', right: '5%'})
      .width('90%').height('100%')
    }
    .hideBackButton(true)
    .onBackPressed(() => {
      return true
    })
  }
}