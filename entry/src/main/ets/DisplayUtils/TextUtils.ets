@Component
export struct ColorText{
  content: string | Resource | undefined
  @State colorTheme: Array<[string, number]> =[['#ff0631f5', 0.0], ['#ff922626', 1]]

  value: TextOptions | undefined
  fontSize: number = 20
  textAlign: TextAlign = TextAlign.Center
  build() {
    Row(){
      Text(this.content, this.value)
        .fontSize(this.fontSize)
        .textAlign(this.textAlign)
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
    }
      .linearGradient({
        direction: GradientDirection.Right,
        colors: this.colorTheme
      })
      .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }
}