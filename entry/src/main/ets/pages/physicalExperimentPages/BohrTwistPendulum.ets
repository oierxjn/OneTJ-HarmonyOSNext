import { Markdown } from "@luvi/lv-markdown-in"
import { InputMultiLine, InputSingleLine } from "../../DisplayUtils/InputUtils"
import { FailureCode } from "@ohos.app.ability.CompletionHandlerForAtomicService"
import { bohrTwistPendulum } from "../../models/physicalExperiment/BohrTwistPendulum"

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
          text: $freeVibrationPeriod,
          vertical: false
        })
        InputMultiLine({
          label: `周期表格`,
          text: $freeVibrationPeriodList
        })
          .width('100%').height('20%')
        ColumnSplit()
        Text(`阻尼振动`)
          .textStyle()
        ColumnSplit()
        Button(`调试按钮`)
          .onClick(() => {
            // console.debug(`调试：文本内容${this.freeVibrationPeriodList}`)
            bohrTwistPendulum.test(this.freeVibrationPeriodList)
          })
      }
        .width('90%').height('100%')
    }
  }
}