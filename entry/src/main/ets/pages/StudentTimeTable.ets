import { CourseInfoCard } from '../components/InfoCard';
import { CourseInfoListDataSource } from '../DisplayUtils/DataUtils';
import { tongjiApi } from '../models/TongjiApi';
import { CourseInfo, CourseInfoList, SchoolCalendarInfo } from '../models/UserModel';
import { JSON } from '@kit.ArkTS';
import { getRandomSingleElementFromArray } from '../components/Funcs';

@Component
export struct StudentTimeTable {

  @Consume('navPathStack') navPathStack: NavPathStack;

  @State courseInfoList: CourseInfoListDataSource = new CourseInfoListDataSource()
  @State currentIndex: number = 0;

  private tabPageController: TabsController = new TabsController();

  async aboutToAppear(){
    // TODO: 测试数据，正式使用时请删除
    // 强制先添加测试数据，看看是否能显示，排除逻辑问题
    this.courseInfoList.push(new CourseInfo('高等数学', 1, 2, '张三', 'A101', 1, [1]))
    this.courseInfoList.push(new CourseInfo('大学物理', 3, 4, '李四', 'B202', 1, [1]))
    this.courseInfoList.push(new CourseInfo('线性代数', 5, 6, '王五', 'C303', 1, [1]))
    
    let isFromInternet: boolean = false;
    try {
      if(!CourseInfoList.isFetched){
        await CourseInfoList.initKV()
        await CourseInfoList.loadFromKV()
        if(!CourseInfoList.isFetched){
          // 只有在确定要联网获取时才去获取，避免阻塞
          // if(await tongjiApi.getCourseInfoList()){
          //   console.debug(`调试：从网络加载课程表完成`)
          //   isFromInternet = true
          // }
        }
      }
      
      // 如果获取到了真实数据，再覆盖或追加
      if (CourseInfoList.isFetched) {
        let weekCourse = CourseInfoList.getWeekCourseInfo(SchoolCalendarInfo.schoolWeek || 1)
        let now = new Date();
        let todayCourse = CourseInfoList.getDayOfWeekCourseInfo(now.getDay(), weekCourse)
        // 这里只是演示，实际可能需要先清空测试数据
        // this.courseInfoList = new CourseInfoListDataSource() 
        for(let course of todayCourse){
          this.courseInfoList.push(course)
        }
      }
      
      if(isFromInternet){
        await CourseInfoList.storeIntoKV()
      }
    } catch (e) {
      console.error(`加载课程数据出错: ${e}`)
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
      .backgroundColor('#F1F3F5') // Light gray background
    }
    .onBackPressed( () => {
      this.navPathStack.pop()
      return true
    })
    .title('今日课程')
    .backgroundColor('#F1F3F5')
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

  build() {
    List({ space: 12 }){
      LazyForEach(this.courseInfoList, (item: CourseInfo) => {
        ListItem(){
          CourseInfoCard({course: item, avatar: getRandomSingleElementFromArray(CourseAvatar)})
            .width('100%')
        }
      })
    }
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
  }
}