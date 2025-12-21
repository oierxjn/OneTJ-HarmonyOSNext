import { Markdown } from "@luvi/lv-markdown-in"
import { InputSingleLine } from "../../DisplayUtils/InputUtils"
import { FailureCode } from "@ohos.app.ability.CompletionHandlerForAtomicService"

@Extend(Text)
function textStyle(){
  .fontSize(26)
  .textAlign(TextAlign.Start)
  .width('100%')
}


@Component
export struct BohrTwistPendulum{
  @State freeVibrationPeriod: string = (1.5700).toString()
  @State freeVibrationPeriodList: string = ``

  build() {
    NavDestination(){
      Column() {
        Text(`自由振动`)
          .textStyle()
        InputSingleLine({
          label: `周期`,
          placeholder: this.freeVibrationPeriod,
          text: $freeVibrationPeriodList,
          vertical: false
        })
        ColumnSplit()
        Text(`阻尼振动`)
          .textStyle()
        ColumnSplit()
        Button(`调试按钮`)
          .onClick(() => {
            console.debug(`调试：文本内容${this.freeVibrationPeriodList}`)
          })
      }
        .width('90%').height('100%')
    }
  }
}