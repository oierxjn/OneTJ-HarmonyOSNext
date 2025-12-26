class HShaderStyleModifier implements AttributeModifier<TextAttribute>{
  colorTheme: Array<[string, number]> = [['#ff32d043', 0.0], ['#ffff4136', 1]]

  applyNormalAttribute(instance: TextAttribute): void {
    console.debug(`调试：字体色彩渐变`)
    instance.shaderStyle({
      direction: GradientDirection.Right,
      colors: this.colorTheme
    })
    console.debug(`调试：字体色彩渐变完成`)
  }
  constructor(colorTheme: Array<[string, number]>) {
    console.debug(`调试：调用构造函数`)
    this.colorTheme = colorTheme
  }
}

@Entry
@Component
struct Login {
  @State appTitle: Resource | string = '114514';

  @State colorTheme: Array<[string, number]> =[['#ff32d043', 0.0], ['#ffff4136', 1]]
  shaderStyleModifier = new HShaderStyleModifier(this.colorTheme)

  build() {
    Column({space : '20%'}) {
      Text(this.appTitle)
        .attributeModifier(this.shaderStyleModifier)
    }
  }
}
