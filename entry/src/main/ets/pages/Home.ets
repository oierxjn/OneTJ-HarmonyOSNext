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
        // Header Card
        Column() {
          if (!this.isInfoBoardFolded) {
            Row() {
              Image(this.avatarSrc)
                .width(64)
                .height(64)
                .clip(new Circle())
                .objectFit(ImageFit.Cover)
              
              Column({ space: 6 }) {
                Text(this.studentNameAndId)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                Text(this.deptName)
                  .fontSize(14)
                  .fontColor('#666666')
                Text(this.currentGrade)
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 16 })
              .layoutWeight(1)
            }
            .width('100%')
            .transition({ type: TransitionType.All, opacity: 0 })
          }
          
          Text(this.termSimpleName)
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: this.isInfoBoardFolded ? 0 : 16 })
            .width('100%')
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
        .onClick(() => {
          animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
            this.isInfoBoardFolded = !this.isInfoBoardFolded
          })
        })
        .margin({ bottom: 16 })

        // Content List
        List({ space: 12 }){
          ListItem(){
            DashBoard()
              .height(200) // Give sufficient height for the grid
          }
          .backgroundColor(Color.White)
          .borderRadius(16)
          .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
          
          LazyForEach(this.commonMsgList, (item: CommonMsgData, index: number) => {
            ListItem(){
              MsgInfoCard({title: item.title, time: item.publishTime, msgId: item.id})
                .width('100%')
            }
          })
        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Off)
        .onAreaChange((_ ,area) => {
          msgTextSectionAttribute.constraintWidth = Number(area.width) * 0.85
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .padding({ left: 16, right: 16, top: 16 })
    }
    .hideBackButton(true)
    .onBackPressed(() => {
      return true
    })
  }
}