import { Markdown } from "@luvi/lv-markdown-in"
import { PhysicalExperimentInputMultiLine, PhysicalExperimentInputSingleLine } from "../../DisplayUtils/InputUtils"
import { FailureCode } from "@ohos.app.ability.CompletionHandlerForAtomicService"
import { bohrTwistPendulum } from "../../models/physicalExperiment/BohrTwistPendulum"
import { PromptAction, SymbolGlyphModifier } from "@kit.ArkUI"
import { HelpSub } from "../Login"

@Extend(Text)
function titleTextStyle(){
  .fontSize(26)
  .textAlign(TextAlign.Start)
  .width('100%')
}

@Extend(Text)
function normalTextStyle(){
  .fontSize(20)
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
export struct BohrTwistPendulum{
  @State freeVibrationPeriod: string = (1.5700).toString()
  @State freeVibrationPeriodListData: string = `1 160 1.5625 2 159 1.5626 3 158 1.5627`
  @State dampedVibrationPeriodListData: string = `1 173 102 2 156 91 3 140 82 4 126 73 5 114 66`

  @State buttonText: string = `计算`

  @State logAnswer: string = ``
  @State graphAnswer: string = ``

  @Consume('navPathStack') navPathStack: NavPathStack

  promptAction: PromptAction = this.getUIContext().getPromptAction()

  build() {
    NavDestination(){
      Column() {
        Column({space: 5}){
          Text(`自由振动`)
            .titleTextStyle()
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
          .cardStyle('#60DCE5D6')
        Column({space: 5}){
          Text(`阻尼振动`)
            .titleTextStyle()
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
          .cardStyle('#30E45D25')
        Button(this.buttonText)
          .onClick(() => {
            let time = bohrTwistPendulum.processTimeFromTable(this.freeVibrationPeriodListData)
            console.debug(`调试：周期${time}`)
            if(time != 0){
              this.freeVibrationPeriod = time.toString()
            }else{
              bohrTwistPendulum.averageTime = parseFloat(this.freeVibrationPeriod)
            }
            bohrTwistPendulum.processAmplitudeFromTable(this.dampedVibrationPeriodListData)
            if(Math.random() < 0.3){
              this.buttonText = `Bingo`
            }else{
              this.buttonText = `再次计算`
            }
            this.logAnswer = bohrTwistPendulum.logSlopeK.toString()
            this.graphAnswer = bohrTwistPendulum.graphSlopeK.toString()
          })
          .width('100%')
        Column({space: 5}) {
          Text(`计算结果`)
            .titleTextStyle()
          Column({ space: 5 }) {
            Text(`对数逐差法：${this.logAnswer}`)
              .normalTextStyle()
            Text(`作图法：${this.graphAnswer}`)
              .normalTextStyle()
          }
        }
          .cardStyle('#305556A4')
      }
        .width('90%').height('100%')
    }
      .menus([
        {
          value: `帮助`,
          action: ()=>{
            this.navPathStack.pushPath({name: HelpSub.ExperimentHelpPage})
          },
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.questionmark_circle'))
        }
      ])
  }
}