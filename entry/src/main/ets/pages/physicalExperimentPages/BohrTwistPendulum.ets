import { Markdown } from "@luvi/lv-markdown-in"
import { PhysicalExperimentInputMultiLine, PhysicalExperimentInputSingleLine } from "../../DisplayUtils/InputUtils"
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
  @State freeVibrationPeriodListData: string = ``
  @State dampedVibrationPeriodListData: string = ``

  build() {
    NavDestination(){
      Column() {
        Column({space: 5}){
          Text(`自由振动`)
            .textStyle()
          Column({space: 5}){
            PhysicalExperimentInputSingleLine({
              label: `周期`,
              placeholder: this.freeVibrationPeriod,
              text: $freeVibrationPeriod,
              vertical: false
            })
            PhysicalExperimentInputMultiLine({
              label: `周期表格数据`,
              text: $freeVibrationPeriodListData,
              vertical: false
            })
              .width('100%').height('20%')
          }.padding({left: 5, right: 5})
        }
        Column({space: 5}){
          Text(`阻尼振动`)
            .textStyle()
          Column(){
            PhysicalExperimentInputMultiLine({
              label: `振幅表格数据`,
              text: $dampedVibrationPeriodListData,
              vertical: false
            })
              .width('100%').height('20%')
          }
            .padding({left: 5, right: 5})
        }
        Button(`调试按钮`)
          .onClick(() => {
            // console.debug(`调试：文本内容${this.freeVibrationPeriodList}`)
            let time = bohrTwistPendulum.processTimeFromTable(this.freeVibrationPeriodListData)
            this.freeVibrationPeriod = time.toString()
            console.debug(`调试：周期${time}`)
            if(time != 0){
              bohrTwistPendulum.processAmplitudeFromTable(this.dampedVibrationPeriodListData)
            }
          })
      }
        .width('90%').height('100%')
    }
  }
}