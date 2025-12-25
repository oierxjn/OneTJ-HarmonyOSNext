import { CourseInfoList, SchoolCalendarInfo, StudentInfo } from '../models/UserModel'

@Extend(Text)
function titleTextStyle(){
  .width('100%')
  .textAlign(TextAlign.Start)
  .fontSize(24)
}
@Extend(Column)
function cardStyle(backgroundColor: ResourceColor){
  .border({
    radius: 5,
    color: '#00000000'
  })
  .padding(10)
  .backgroundColor(backgroundColor)
}

@Component
export struct Settings {
  promptAction = this.getUIContext().getPromptAction()


  build() {
    NavDestination(){
      Column({space: 5}){
        Column({space: 5}){
          Text(`本地缓存清理`)
            .titleTextStyle()
          Column({space: 5}){
            Button(`清理学生信息缓存`)
              .onClick(async ()=>{
                try {
                  await StudentInfo.clearFromKV()
                  this.promptAction.showToast({message: '学生信息清理成功'})
                } catch (e) {
                  this.promptAction.showToast({message: '学生信息清理失败'})
                }
              })
              .width('90%')
            Button(`清理学期信息缓存`)
              .onClick(async ()=>{
                try {
                  await SchoolCalendarInfo.clearFromKV()
                  this.promptAction.showToast({message: '学期信息清理成功'})
                } catch (e) {
                  this.promptAction.showToast({message: '学期信息清理失败'})
                }
              })
              .width('90%')
            Button(`清理课程表缓存`)
              .onClick(async ()=>{
                try{
                  await CourseInfoList.clearFromKV()
                  this.promptAction.showToast({message: '课程表清理成功'})
                } catch (e) {
                  this.promptAction.showToast({message: '课程表清理失败'})
                }
              })
              .width('90%')
          }
            .width('90%')
        }
          .cardStyle('#20000080')
      }
        .width('90%').height('100%')
    }
      .title(`设置`)
  }
}