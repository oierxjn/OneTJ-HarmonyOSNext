
@Extend(Text)
function titleTextStyle(){
  .fontSize(18)
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Start)
  .width('100%')
  .margin({ bottom: 12 })
}

@Extend(Text)
function questionTextStyle(){
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
  .fontColor('#333333')
  .textAlign(TextAlign.Start)
  .width('100%')
  .margin({ bottom: 4 })
}

@Extend(Text)
function answerTextStyle(){
  .fontSize(14)
  .fontColor('#666666')
  .textAlign(TextAlign.Start)
  .width('100%')
  .lineHeight(20)
  .margin({ bottom: 12 })
}

@Extend(Text)
function italicTextStyle(fontSize: string | number | Resource = 14){
  .fontStyle(FontStyle.Italic)
  .fontSize(fontSize)
  .fontColor('#999999')
  .textAlign(TextAlign.Start)
  .width('100%')
}

@Extend(Column)
function cardStyle(){
  .backgroundColor(Color.White)
  .borderRadius(16)
  .shadow({ radius: 5, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 2 })
  .padding(16)
  .width('100%')
}

@Component
export struct ExperimentHelp{
  build(){
    NavDestination(){
      Scroll() {
        Column({space: 16}){
          Column(){
            Text(`常见问题`)
              .titleTextStyle()
            Column({space: 4}){
              Text(`表格数据都是怎么得到的？`)
                .questionTextStyle()
              Text(`一般的实验都是手输的。但是对于『用玻尔共振仪研究物体受迫振动』和『扭摆法测刚体转动惯量』这两个实验，你可以从学校给的实验表格中获取数据，比如在手机上选中对应的内容，直接复制。`)
                .answerTextStyle()
                .fontColor(Color.Red)
              
              Text(`应用预置的数据可以直接用吗？`)
                .questionTextStyle()
              Text(`一般来说，应用中预置的数据都是合法的数据。`)
                .answerTextStyle()
                .fontColor(Color.Red)
            }
          }
            .cardStyle()

          Column(){
            Text(`波尔实验`)
              .titleTextStyle()
            Column({space: 4}){
              Text(`周期和周期表格数据只需要二选一填写。优先使用周期表格数据，当周期表格数据为空时，会自动使用周期数据填写的数据。`)
                .answerTextStyle()
              Text(`自由振动需要的周期数据格式：三个数据为一组，第一个数据和第二个分别为序号和振幅（都不重要），第三个数据为周期。应用预填的数据为合法数据。`)
                .answerTextStyle()
              Text(`你可能可以在这个实验发现一个小彩蛋😋`)
                .italicTextStyle()
            }
          }
            .cardStyle()
        }
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .width('100%')
      }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
    }
      .title(`帮助：物理实验`)
      .backgroundColor('#F1F3F5')
  }
}