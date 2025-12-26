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
      Column() {
        Column({space: 20}){
          Image($r('app.media.logo'))
            .width(80)
            .height(80)
            .borderRadius(16)
          
          Text($r('app.string.EntryAbility_label'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .shaderStyle({
              direction: GradientDirection.Right,
              colors: this.colorTheme
            })
            
          Column({ space: 8 }) {
            Text($r('app.string.Version_name'))
              .fontSize(16)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
            Text($r('app.string.Build_time'))
              .fontSize(14)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
          }

          Divider().color('#F1F3F5').margin({ top: 10, bottom: 10 })

          Text(`Based on Tongji Open Platform APIs`)
            .fontSize(14)
            .fontColor('#666666')
            .textAlign(TextAlign.Center)
            
          Text(){
            Span(`Developed by XJN`)
            ImageSpan($r('app.media.oierxjn'))
              .verticalAlign(ImageSpanAlignment.CENTER)
              .borderRadius(10)
              .height(20)
              .margin({ left: 4, right: 4 })
            Span(` , and from GTY`)
            ImageSpan($r('app.media.GuanTouYu'))
              .verticalAlign(ImageSpanAlignment.CENTER)
              .borderRadius(10)
              .height(20)
              .margin({ left: 4 })
          }
            .fontSize(14)
            .fontColor('#666666')
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .padding(24)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F1F3F5')
    }
    .title(`关于本app`)
    .backgroundColor('#F1F3F5')
  }
}