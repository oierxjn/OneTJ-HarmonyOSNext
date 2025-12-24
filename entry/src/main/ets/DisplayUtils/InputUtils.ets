import { ComposeListItem, LengthUnit } from '@kit.ArkUI'

@Component
export struct InputSingleLine{
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
          .width('30%')
        TextInput({
          text: this.text,
          placeholder: this.placeholder,
        })
          .width('70%')
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