import { CourseInfoCard } from '../components/InfoCard';
import { CourseInfoListDataSource } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { CourseInfo, CourseInfoList, SchoolCalendarInfo } from '../models/UserModel';
import { JSON } from '@kit.ArkTS';

@Component
export struct StudentTimeTable {

  @Consume('navPathStack') navPathStack: NavPathStack;

  @State courseInfoList: CourseInfoListDataSource = new CourseInfoListDataSource()
  @State currentIndex: number = 0;

  private tabPageController: TabsController = new TabsController();

  async aboutToAppear(){
    let isFromInternet: boolean = false;
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
    let weekCourse = CourseInfoList.getWeekCourseInfo(SchoolCalendarInfo.schoolWeek!!)
    let now = new Date();
    let todayCourse = CourseInfoList.getDayOfWeekCourseInfo(now.getDay(), weekCourse)
    for(let course of todayCourse){
      this.courseInfoList.push(course)
    }
    if(isFromInternet){
      await CourseInfoList.storeIntoKV()
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
          .tabBar('每日')
          /*
          TabContent() {
            // 每周视图，暂时留空
            Column() {
              Text('每周课表')
                .fontSize(24)
              Text('功能开发中...')
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }
          .tabBar('每周')
          
          TabContent() {
            // 每年视图，暂时留空
            Column() {
              Text('每年课表')
                .fontSize(24)
              Text('功能开发中...')
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }
          .tabBar('每年')
          */
        }
        .layoutWeight(1)
        .barMode(BarMode.Fixed)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .width('100%')
      .height('100%')
    }
    .onBackPressed( () => {
      this.navPathStack.pop()
      return true
    })
  }
}

@Component
struct SingleDayTimeTable{

  @Require courseInfoList: CourseInfoListDataSource

  build() {
    List(){
      LazyForEach(this.courseInfoList, (item: CourseInfo) => {
        ListItem(){
          Column(){
            CourseInfoCard({course: item})
              .width('95%').height('120')
            Divider()
              .margin({top: 5, bottom: 5})
              .visibility(Visibility.Hidden)
          }
        }
      })
    }
      .width('100%').height('100%')
  }
}