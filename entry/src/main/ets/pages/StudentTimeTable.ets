import { tongjiApi } from '../models/TongjiApi';
import { CourseInfoList } from '../models/UserModel';

@Component
export struct StudentTimeTable {

  @Consume('navPathStack') navPathStack: NavPathStack;

  async aboutToAppear(){
    console.debug('调试：StudentTimeTable页面即将出现')
    await tongjiApi.getCourseInfoList()

  }

  build() {
    NavDestination(){
      Column()
    }
    .onBackPressed( () => {
      this.navPathStack.pop()
      return true
    })
  }
}