

@Component
export struct InfoCard {
  @State info: string = "Info"
  build() {
    Row() {
      Column() {
        Text(this.info)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#25303345')
        Button()
          .onClick(() => {
            this.info = "Click"
          })
      }
      .alignItems(HorizontalAlign.Center)
      .width('70%')
      Image($rawfile('fluentemoji/banana_color.svg'))
        .width('30%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#35253033')
    .borderRadius('5%')
  }
}