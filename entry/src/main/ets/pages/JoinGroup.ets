import { SymbolGlyphModifier } from "@kit.ArkUI"
import { pasteboard } from '@kit.BasicServicesKit';

let qqGroupCode: string = '322324184'

@Component
export struct JoinGroup {
  build() {
    NavDestination(){
      Column(){
        Text(`QQ群号:${qqGroupCode}`)
          .fontSize(20)
          .fontWeight(FontWeight.Lighter)
          .textAlign(TextAlign.Center)
        Image($r('app.media.qq_group_qrcode'))
          .width('100%')
      }
    }
    // TODO 添加复制QQ号的按键 搁置原因：需要额外申请权限
      // .menus([
      //   {
      //     value: '复制',
      //     symbolIcon: new SymbolGlyphModifier($r('sys.symbol.rectangle_on_rectangle')),
      //     action: async () => {
      //       try {
      //         await pasteboard.getSystemPasteboard().getData()
      //
      //       } catch (e) {
      //         console.error(`复制到剪贴板的时候发生错误：${JSON.stringify(e)}`)
      //       }
      //     }
      //   }
      // ])
  }
}