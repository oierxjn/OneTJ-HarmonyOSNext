import { ComposeListItem } from '@kit.ArkUI'

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
        TextInput({
          text: $$this.text,
          placeholder: this.placeholder,
        })
      }
    }else{
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
        TextInput({
          text: this.text,
          placeholder: this.placeholder,
        })
      }
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
      }
    }else {
      Row(){
        Text(this.label)
          .fontSize(this.labelFontSize)
        TextArea({
          text: $$this.text,
          placeholder: this.placeholder,
        })
      }
    }
  }
}