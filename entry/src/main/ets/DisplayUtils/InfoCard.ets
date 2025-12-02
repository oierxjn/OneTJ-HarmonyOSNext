

@Component
struct InfoCard {
  @State info: string = "Info"
  build() {
    Row() {
      Text(this.info)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Button()
        .onClick(() => {
          this.info = "Click"
        })
    }
  }
}