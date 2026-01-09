import { CourseInfoCard } from '../components/InfoCard';
import { CourseInfoListDataSource } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { CourseInfo, CourseInfoList, SchoolCalendarInfo } from '../models/UserModel';
import { JSON } from '@kit.ArkTS';
import { AsyncLock, getRandomSingleElementFromArray, TaskStatusManager } from '../components/Funcs';

let courseInfoGetStatusManager: TaskStatusManager = new TaskStatusManager(`CourseInfoGetStatusManager`)

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
      .backgroundColor($r('sys.color.ohos_id_color_sub_background')) // Light gray background
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
        .fontColor(this.currentIndex === index ? '#007DFF' : '#999999')
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



@Component
struct SingleDayTimeTable{

  @Require courseInfoList: CourseInfoListDataSource

  @State isCourseListEmpty: boolean = false
  @State dayOfWeekOfQuery: number = new Date().getDay()
  @State weekOfQuery: number = 1

  async aboutToAppear(){
    try {
      await courseInfoGetStatusManager.waitForComplete()
      this.weekOfQuery = SchoolCalendarInfo.schoolWeek || 1
      let weekCourse = CourseInfoList.getWeekCourseInfo(this.weekOfQuery)
      let todayCourse = CourseInfoList.getDayOfWeekCourseInfo(this.dayOfWeekOfQuery, weekCourse)
      for(let course of todayCourse){
        this.courseInfoList.push(course)
      }
      this.isCourseListEmpty = todayCourse.length == 0
    } catch (e){
      console.error(`获取课程数据出错: ${JSON.stringify(e)}`)
    }
  }

  build() {
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
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
  }
}