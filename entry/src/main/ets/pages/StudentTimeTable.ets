import { CourseInfoCard } from '../components/InfoCard';
import { CourseInfoListDataSource } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { CourseInfo, CourseInfoList, SchoolCalendarInfo } from '../models/UserModel';
import { JSON } from '@kit.ArkTS';
import { AsyncLock, getRandomSingleElementFromArray, TaskStatusManager, dayOfWeekOfChinese } from '../components/Funcs';

let courseInfoGetStatusManager: TaskStatusManager = new TaskStatusManager(`CourseInfoGetStatusManager`)

let MaxSchoolWeek: number = 21

@Component
export struct StudentTimeTable {

  @Consume('navPathStack') navPathStack: NavPathStack;

  @State courseInfoList: CourseInfoListDataSource = new CourseInfoListDataSource()
  @State currentIndex: number = 0;

  private tabPageController: TabsController = new TabsController();

  async aboutToAppear(){
    let isFromInternet: boolean = false;
    try {
      if(!CourseInfoList.isFetched){
        await CourseInfoList.initKV()
        await CourseInfoList.loadFromKV()
        if(!CourseInfoList.isFetched){
          if(await tongjiApi.getCourseInfoList()){
            console.debug(`调试：从网络加载课程表完成`)
            isFromInternet = true
          }
        }
      }

      if(CourseInfoList.isFetched){
        courseInfoGetStatusManager.setCompleted()
      }
      if(isFromInternet){
        await CourseInfoList.storeIntoKV()
      }
    } catch (e) {
      console.error(`加载课程数据出错: ${JSON.stringify(e)}`)
    }
  }

  build() {
    NavDestination(){
      Column() {
        Tabs({ 
          controller: this.tabPageController,
          barPosition: BarPosition.End,
          index: this.currentIndex
        }) {
          TabContent() {
            SingleDayTimeTable({courseInfoList: this.courseInfoList})
              .layoutWeight(1)
          }
          .tabBar(this.TabBuilder(0, '每日'))
        }
        .layoutWeight(1)
        .barMode(BarMode.Fixed)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    }
    .onBackPressed( () => {
      this.navPathStack.pop()
      return true
    })
    .title('今日课程')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('sys.color.ohos_id_color_emphasize') : '#999999')
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
        .width(20)
    }
    .width('100%')
  }
}

let CourseAvatar: Resource[] = [
  $rawfile('fluentemoji-png/pear_3d.png'),
  $rawfile('fluentemoji-png/hamburger_3d.png'),
  $rawfile('fluentemoji-png/tropical_drink_3d.png'),
  $rawfile('fluentemoji-png/watermelon_3d.png'),
  $rawfile('fluentemoji-png/bread_3d.png')
]

@Extend(Text)
function titleTextStyle(){
  .fontSize(28)
  .textAlign(TextAlign.Center)
}
@Extend(Text)
function buttonTextStyle(){
  .fontSize(18)
  .textAlign(TextAlign.Center)
}
@Extend(Button)
function buttonCardStyle(){
  .fontColor($r('sys.color.ohos_id_color_emphasize'))
  .backgroundColor($r('sys.color.ohos_id_color_background'))
  .borderRadius(10)
  .padding(10)
  .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
}

@Component
struct SingleDayTimeTable{

  @Require courseInfoList: CourseInfoListDataSource

  @State isCourseListEmpty: boolean = false
  @State dayOfWeekOfQuery: number = 0
  @State weekOfQuery: number = 1

  promptAction = this.getUIContext().getPromptAction()

  async aboutToAppear(){
    try {
      await courseInfoGetStatusManager.waitForComplete()
      this.setToday()
      this.update()
    } catch (e){
      console.error(`获取课程数据出错: ${JSON.stringify(e)}`)
    }
  }

  weekAdd(){
    if(this.weekOfQuery >= MaxSchoolWeek){
      throw new Error(`周数已超出最大值: ${MaxSchoolWeek}`)
    }
    this.weekOfQuery += 1
  }
  weekSub(){
    if(this.weekOfQuery <= 1){
      throw new Error(`周数已超出最小值: 1`)
    }
    this.weekOfQuery -= 1
  }
  dayAdd(){
    this.dayOfWeekOfQuery += 1
    if(this.dayOfWeekOfQuery > 7){
      try{
        this.weekAdd()
      } catch (_){
        this.dayOfWeekOfQuery -= 1
        throw new Error(`不能再往后了`)
      }
      this.dayOfWeekOfQuery = 0
    }
  }
  daySub(){
    this.dayOfWeekOfQuery -= 1
    if(this.dayOfWeekOfQuery < 1){
      try{
        this.weekSub()
      } catch (_){
        this.dayOfWeekOfQuery += 1
        throw new Error(`不能再往前了`)
      }
      this.dayOfWeekOfQuery = 7
    }
  }
  setToday(){
    let day = new Date().getDay()
    this.dayOfWeekOfQuery = day == 0 ? 7 : day
    this.weekOfQuery = SchoolCalendarInfo.schoolWeek || 1
  }

  update(){
    try{
      let weekCourse = CourseInfoList.getWeekCourseInfo(this.weekOfQuery)
      let todayCourse = CourseInfoList.getDayOfWeekCourseInfo(this.dayOfWeekOfQuery, weekCourse)
      this.courseInfoList.clear()
      for(let course of todayCourse){
        this.courseInfoList.push(course)
      }
      this.isCourseListEmpty = todayCourse.length == 0
    } catch (error){
      console.error(`更新课程数据出错: ${JSON.stringify(error)}`)
    }
  }

  build() {
    Column(){
      Row() {
        Text(`第${this.weekOfQuery}周`)
          .titleTextStyle().width('50%')
        Text(`星期${dayOfWeekOfChinese[this.dayOfWeekOfQuery]}`)
          .titleTextStyle().width('50%')
      }
      List({ space: 12 }){
        LazyForEach(this.courseInfoList, (item: CourseInfo) => {
          ListItem(){
            CourseInfoCard({course: item, avatar: getRandomSingleElementFromArray(CourseAvatar)})
              .width('100%')
          }
        })
        if(this.isCourseListEmpty){
          ListItem(){
            Text('今日没有课程')
              .fontSize(20)
              .fontWeight(FontWeight.Lighter)
              .width('100%')
              .textAlign(TextAlign.Center)
          }
            .offset({top: '50%'})
        }
      }
        .width('100%').layoutWeight(1)
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      Row() {
        Button() {
          Text('上一天')
            .buttonTextStyle()
        }
          .onClick(() => {
            try {
              this.daySub()
            } catch (e){
              this.promptAction.showToast({message :(e as Error).message})
            }
            this.update()
          })
          .buttonCardStyle()
          .width('30%')
        Button(){
          Text(`今天`)
            .buttonTextStyle()
        }
          .onClick(() => {
            this.setToday()
            this.update()
          })
          .buttonCardStyle()
          .width('30%')
        Button() {
          Text('下一天')
            .buttonTextStyle()
        }
          .onClick(() => {
            try {
              this.dayAdd()
            } catch (e){
              this.promptAction.showToast({message :(e as Error).message})
            }
            this.update()
          })
          .buttonCardStyle()
          .width('30%')
      }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
    }
  }
}