import { DashBoard } from '../components/DashBoard'
import { CourseInfoCard, MsgInfoCard } from '../components/InfoCard'
import { buildAlertDialog } from '../DisplayUtils/AlertDialogUtils'
import { CommonMsgData, ListDataSource, MsgListDataSource, TextSectionAttribute } from '../DisplayUtils/DataUtils'
import { tongjiApi } from '../models/TongjiApi'
import { MsgList, SchoolCalendarInfo, StudentInfo } from '../models/UserModel'


export let msgTextSectionAttribute: TextSectionAttribute = new TextSectionAttribute()

@Component
export struct Home {
  @Consume('navPathStack') navPathStack: NavPathStack

  @State commonMsgList: MsgListDataSource = new MsgListDataSource()

  @State avatarSrc: ResourceStr = $rawfile('fluentemoji-png/sleeping_face_3d.png')

  @State studentNameAndId: string = '黄泽华'
  @State deptName: string = '继续搞事学院'
  @State currentGrade: string = '114514级'

  @State isInfoBoardFolded: boolean = false
  @State termSimpleName: string = '1919-9178学年度第0学期 第13周'


  async aboutToAppear(): Promise<void> {
    msgTextSectionAttribute.maxLines = 3
    let studentInfoTask = this.createStudentInfoTask()
    let termInfoTask = this.createTermInfoTask() // TODO 不进行学期刷新
    let msgListTask = this.createMsgListTask()

    await Promise.all([studentInfoTask, termInfoTask, msgListTask])
  }

  async createMsgListTask(): Promise<void> {
    if(!MsgList.isFetched){
      if(!await tongjiApi.getCommonMsgList()) {
        console.error('获取消息列表失败')
        return
      }
    }
    try {
      for(let msg of MsgList.msgArray){
        this.commonMsgList.push(msg)
      }
    } catch (e){
      console.error(`出现异常：${e}`)
    }
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
    await StudentInfo.storeIntoKV()
  }
  async createTermInfoTask(): Promise<void> {
    await SchoolCalendarInfo.initKV()
    await SchoolCalendarInfo.loadFromKV()
    if(!SchoolCalendarInfo.isFetched){
      if(!await tongjiApi.getSchoolCalendarInfo()){
        console.error('获取学期信息失败')
        return
      }
    }
    try {
      this.termSimpleName = `${SchoolCalendarInfo.simpleName} 第${SchoolCalendarInfo.schoolWeek}周`
    } catch (e){
      console.error(`出现异常：${e}`)
    }
    await SchoolCalendarInfo.storeIntoKV()
  }

  titleFontSize: number = 25;

  build() {
    NavDestination(){
      Column(){
        Column(){
          Row(){
            Image(this.avatarSrc)
              .width('25%')
            Blank()
            Column(){
              Text(this.studentNameAndId)
                .fontSize(this.titleFontSize)
              Blank()
              Text(this.deptName)
                .fontSize(this.titleFontSize)
              Blank()
              Text(this.currentGrade)
                .fontSize(this.titleFontSize)
            }
            .alignItems(HorizontalAlign.Start)
            .height('100%').width('70%')
          }
          .width('90%').height('60%')
          .opacity(this.isInfoBoardFolded? 0 : 1)
          .animation({})
          Text(this.termSimpleName)
            .fontSize(22)
            .height('20%')
            .margin({bottom: '5%', top: '5%'})
            .animation({})
        }
        .height('30%').width('100%')
        .translate({y: this.isInfoBoardFolded? '-80%' : 0})
        .animation({duration: 1000})
        .onClick(() => {
          this.isInfoBoardFolded = !this.isInfoBoardFolded
        })
        List(){
          ListItem(){
            DashBoard()
              .width('100%').height('30%')
          }
          LazyForEach(this.commonMsgList, (item: CommonMsgData, index: number) => {
            ListItem(){
              Column(){
                MsgInfoCard({title: item.title, time: item.publishTime, msgId: item.id}).width('100%')
                Divider()
                  .margin({top: '5', bottom: '5'})
                  .visibility(Visibility.Hidden)
              }
            }
          })
        }
        .translate({y: this.isInfoBoardFolded? '-28%' : 0})
        .animation({duration: 1000})
        .onAreaChange((_ ,area) => {
          msgTextSectionAttribute.constraintWidth = Number(area.width) *0.85
        })
        .height('100%').width('100%')
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