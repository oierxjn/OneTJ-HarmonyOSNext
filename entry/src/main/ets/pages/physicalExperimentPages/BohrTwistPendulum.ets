import { Markdown } from "@luvi/lv-markdown-in"
@Component
export struct BohrTwistPendulum{
  @State freeVibrationPeriod: string = (1.5700).toString()
  @State freeVibrationPeriodList: string = ``

  build() {
    NavDestination(){
      Column(){
        Text(`自由振动`)
          .fontSize(26)
        TextInput({
          placeholder: this.freeVibrationPeriod,
          text: $$this.freeVibrationPeriod
        })
        TextArea({
          placeholder: ``,
          text: this.freeVibrationPeriodList
        })
        ColumnSplit()
        Text(`阻尼振动`)
        ColumnSplit()

      }
    }
  }
}