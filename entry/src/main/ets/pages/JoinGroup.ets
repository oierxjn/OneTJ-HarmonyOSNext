import { SymbolGlyphModifier } from "@kit.ArkUI"
import { pasteboard } from '@kit.BasicServicesKit';

@Component
export struct JoinGroup {
  build() {
    NavDestination(){
      Column(){
        Image($r('app.media.qq_group_qrcode'))
          .width('100%')
      }
    }
    // TODO 添加复制QQ号的按键
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