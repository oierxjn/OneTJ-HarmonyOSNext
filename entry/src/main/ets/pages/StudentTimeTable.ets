import { CourseInfoCard } from '../components/InfoCard';
import { CourseInfoListDataSource } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { CourseInfo, CourseInfoList, SchoolCalendarInfo } from '../models/UserModel';
import { JSON } from '@kit.ArkTS';

@Component
export struct StudentTimeTable {

  @Consume('navPathStack') navPathStack: NavPathStack;

  @State courseInfoList: CourseInfoListDataSource = new CourseInfoListDataSource()


  async aboutToAppear(){
    console.debug('调试：StudentTimeTable页面即将出现')
    let isFromInternet: boolean = false;
    if(!CourseInfoList.isFetched){
      await CourseInfoList.initKV()
      await CourseInfoList.loadFromKV()
      if(!CourseInfoList.isFetched){
        if(await tongjiApi.getCourseInfoList())
          console.debug(`调试：从网络加载课程表完成`)
          isFromInternet = true
      }
    }
    let weekCourse = CourseInfoList.getWeekCourseInfo(SchoolCalendarInfo.schoolWeek!!)
    let now = new Date();
    let todayCourse = CourseInfoList.getDayOfWeekCourseInfo(now.getDay(), weekCourse)
    for(let course of todayCourse){
      this.courseInfoList.push(course)
    }
    if(isFromInternet)
      await CourseInfoList.storeIntoKV()
  }

  build() {
    NavDestination(){
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
