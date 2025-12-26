import { deviceInfo } from '@kit.BasicServicesKit'


class HShaderStyleModifier implements AttributeModifier<TextAttribute>{
  colorTheme: Array<[string, number]> = [['#ff32d043', 0.0], ['#ffff4136', 1]]

  applyNormalAttribute(instance: TextAttribute): void {
    if(deviceInfo.sdkApiVersion >= 20){
      console.debug(`调试：字体色彩渐变`)
      instance.shaderStyle({
        direction: GradientDirection.Right,
        colors: this.colorTheme
      })
      console.debug(`调试：字体色彩渐变完成`)
    }
  }
  constructor(colorTheme: Array<[string, number]>) {
    this.colorTheme = colorTheme
  }
}

@Component
export struct About{
  @State colorTheme: Array<[string, number]> =[['#ff32d043', 0.0], ['#ffff4136', 1]]

  shaderStyleModifier = new HShaderStyleModifier(this.colorTheme)

  build() {
    NavDestination(){
      Column({space: 10}){
        Text('114514')
          .attributeModifier(this.shaderStyleModifier)
      }
        .width('100%').height('100%')
        .padding({left: 20, right: 20, top: 40, bottom: 10})
    }
    .title(`关于本app`)
  }
}