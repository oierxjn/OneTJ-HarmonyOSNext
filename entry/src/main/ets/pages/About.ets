import common from '@ohos.app.ability.common'
import bundleManager from '@ohos.bundle.bundleManager'
import { bundleInfo, PageName } from './Login'
import { deviceInfo } from '@kit.BasicServicesKit'

@Extend(Text)
function titleTextStyle(){
  .fontSize(26)
  .textAlign(TextAlign.Start)
  .width('100%')
}
@Extend(Column)
function cardStyle(backgroundColor: ResourceColor){
  .border({
    width: 10,
    radius: 5,
    color: '#00000000'
  })
  .backgroundColor(backgroundColor)
}


@Component
export struct About{
  @State colorTheme: Array<[string, number]> =[['#ff0631f5', 0.0], ['#ff922626', 1]]

  @Consume('navPathStack')navPathStack: NavPathStack
  build() {
    NavDestination(){
      Column({space: 10}){
        Image($r('app.media.logo'))
          .width('40%')
          .borderRadius('20%')
        Row(){
          Text($r('app.string.EntryAbility_label'))
            .fontSize(40).fontFamily('SanJiPoMoTi')
            .textAlign(TextAlign.Center)
            .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
        }
          .linearGradient({
            direction: GradientDirection.Right,
            colors: this.colorTheme
          })
          .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
        Text($r('app.string.Version_name'))
          .fontSize(25)
          .textAlign(TextAlign.Center)
        Text($r('app.string.Build_time'))
          .fontSize(25)
          .textAlign(TextAlign.Center)
        // Text(`在信息化办公室指导下研发完成`)
        Blank()
        Column(){
          Text(`查看隐私政策`)
            .fontSize(25)
            .textAlign(TextAlign.Center)
        }
          .cardStyle('#30A9B0AA')
          .width('80%').height(50)
          .onClick(()=>{
            this.navPathStack.pushPath({name: PageName.PrivacyPolicyPage})
          })

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
          .width('100%').height('100%')
          .padding(24)
          .backgroundColor($r('sys.color.ohos_id_color_background'))
          .borderRadius(16)
          .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
    }
    .padding(16)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .title(`关于本app`)
  }
}