
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
@Extend(Text)
function italicTextStyle(fontSize: string | number | Resource = 16){
  .fontStyle(FontStyle.Italic)
  .normalTextStyle()
  .fontSize(fontSize)
}

@Component
export struct ExperimentHelp{
  build(){
    NavDestination(){
      Column({space: 5}){
        Column({space: 5}){
          Text(`常见问题`)
            .titleTextStyle()
          Column({space: 5}){
            Text(`表格数据都是怎么得到的？`)
              .normalTextStyle()
            Text(`    一般的实验都是手输的。但是对于『用玻尔共振仪研究物体受迫振动』和『扭摆法测刚体转动惯量』这两个实验，你可以从学校给的实验表格中获取数据，比如在手机上选中对应的内容，直接复制。`)
              .normalTextStyle()
              .fontColor(Color.Red)
            Text(`应用预置的数据可以直接用吗？`)
              .normalTextStyle()
            Text(`    一般来说，应用中预置的数据都是合法的数据。`)
              .normalTextStyle()
              .fontColor(Color.Red)
          }
            .padding(10)
        }
        Column({space: 5}){
          Text(`波尔实验`)
            .titleTextStyle()
          Column({space: 5}){
            Text(`    周期和周期表格数据只需要二选一填写。优先使用周期表格数据，当周期表格数据为空时，会自动使用周期数据填写的数据。`)
              .normalTextStyle()
            Text(`    自由振动需要的周期数据格式：三个数据为一组，第一个数据和第二个分别为序号和振幅（都不重要），第三个数据为周期。应用预填的数据为合法数据。`)
              .normalTextStyle()
            Text(`    你可能可以在这个实验发现一个小彩蛋😋`)
              .italicTextStyle()
          }
            .padding(10)
        }
      }
        .padding(10)
        .width('100%').height('100%')
    }
      .title(`帮助：物理实验`)
  }
}