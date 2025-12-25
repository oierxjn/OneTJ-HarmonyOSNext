import common from '@ohos.app.ability.common'
import bundleManager from '@ohos.bundle.bundleManager'
import { bundleInfo } from './Login'

@Extend(Text)
function titleTextStyle(){
  .fontSize(26)
  .textAlign(TextAlign.Start)
  .width('100%')
}

@Component
export struct About{
  @State colorTheme: Array<[string, number]> =[['#ff32d043', 0.0], ['#ffff4136', 1]]

  build() {
    NavDestination(){
      Column({space: 10}){
        Image($r('app.media.logo'))
          .width('40%')
          .borderRadius('20%')
        Text($r('app.string.EntryAbility_label'))
          .fontSize(40)
          .textAlign(TextAlign.Center)
          .shaderStyle({
            direction: GradientDirection.Right,
            colors: this.colorTheme
          })
        Text($r('app.string.Version_name'))
          .fontSize(25)
          .textAlign(TextAlign.Center)
        Text($r('app.string.Build_time'))
          .fontSize(25)
          .textAlign(TextAlign.Center)
        // Text(`在信息化办公室指导下研发完成`)
        Blank()
        Text(`Based on Tongji Open Platform APIs`)
          .fontSize(16)
          .fontWeight(FontWeight.Lighter)
          .textAlign(TextAlign.Center)
        Text(){
          Span(`Developed by XJN`)
          ImageSpan($r('app.media.oierxjn'))
            .verticalAlign(ImageSpanAlignment.CENTER)
            .borderRadius('20%')
            .height(20)
          Span(` , and from GTY`)
          ImageSpan($r('app.media.GuanTouYu'))
            .verticalAlign(ImageSpanAlignment.CENTER)
            .borderRadius('20%')
            .height(20)
        }
          .fontSize(16)
          .fontWeight(FontWeight.Lighter)
          .textAlign(TextAlign.Center)
        // Column(){
        //   Text(`    这是`)
        // }
        //   .width('100%')
      }
        .width('100%').height('100%')
        .padding({left: 20, right: 20, top: 40, bottom: 10})
    }
    .title(`关于本app`)
  }
}