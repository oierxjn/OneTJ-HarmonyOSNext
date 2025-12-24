import { ComposeListItem, LengthUnit } from '@kit.ArkUI'

// TODO 抽成简化的输入框
@Component
export struct PhysicalExperimentInputSingleLine{
  label: string = ''
  placeholder: string = ''
  @Link text: ResourceStr
  labelFontSize: string | number | Resource = 16
  vertical: boolean = true

  textWidth(): string | number | Resource {
    return this.vertical? '100%' :'30%'
  }
  inputBoxWidth(): string | number | Resource {
    return this.vertical? '100%' : '70%'
  }

  build() {
    if(this.vertical){
      Column(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Start)
          .width(this.textWidth())
          .maxLines(1)
        TextInput({
          text: $$this.text,
          placeholder: this.placeholder,
        })
      }
    }else{
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Center)
          .width(this.textWidth())
          .onClick(()=>{
            console.debug(`调试：文本宽度${this.textWidth()}`)
          })
        TextInput({
          text: this.text,
          placeholder: this.placeholder,
        })
          .width(this.inputBoxWidth())
          .backgroundColor('#30114514')
      }
        .backgroundColor('#30984514')
        .width('100%')
        .alignItems(VerticalAlign.Center)
    }
  }
}

@Component
export struct PhysicalExperimentInputMultiLine{
  label: string = ''
  placeholder: string = ''
  @Link text: ResourceStr
  labelFontSize: string | number | Resource = 16
  vertical: boolean = true
  build() {
    if(this.vertical){
      Column(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Start)
          .width('100%')
        TextArea({
          text: $$this.text,
          placeholder: this.placeholder,
        })
          .height('80%')
      }
    }else {
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
        TextArea({
          text: $$this.text,
          placeholder: this.placeholder,
        })
          .height('100%')
      }
    }
  }
}


@Component
export struct InputSingleLine{
  label: string = ''
  placeholder: string = ''
  @Link text: ResourceStr
  labelFontSize: string | number | Resource = 16
  vertical: boolean = true
  textWidth: string | number | Resource = this.vertical? '100%' :'30%'
  inputBoxWidth: string | number | Resource = this.vertical? '100%' : '70%'

  build() {
    if(this.vertical){
      Column(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Start)
          .width(this.textWidth)
          .maxLines(1)
        TextInput({
          text: $$this.text,
          placeholder: this.placeholder,
        })
      }
    }else{
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Center)
          .width(this.textWidth)
        TextInput({
          text: this.text,
          placeholder: this.placeholder,
        })
          .width(this.inputBoxWidth)
          .backgroundColor('#30114514')
      }
      .backgroundColor('#30984514')
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
  }
}

@Component
export struct InputMultiLine{
  label: string = ''
  placeholder: string = ''
  @Link text: ResourceStr
  labelFontSize: string | number | Resource = 16
  vertical: boolean = true
  build() {
    if(this.vertical){
      Column(){
        Text(this.label)
          .fontSize(this.labelFontSize)
          .align(Alignment.Start)
          .width('100%')
        TextArea({
          text: $$this.text,
          placeholder: this.placeholder,
        })
          .height('80%')
      }
    }else {
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
        TextArea({
          text: $$this.text,
          placeholder: this.placeholder,
        })
          .height('100%')
      }
    }
  }
}