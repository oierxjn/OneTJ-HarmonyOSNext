@Entry
@Component
struct Login {
  @State message: Resource | string = $r('app.string.EntryAbility_label');

  build() {
    Column() {

      RelativeContainer() {
        Text(this.message)
          .id('title_text')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            top: { anchor: '__container__', align: VerticalAlign.Top }
          })
          .onClick(() => {
            this.message = 'Welcome';
          })

        Column(){
          Button($r('app.string.Uni_login'))
            .fontSize($r('app.float.page_text_normal_size'))
            .fontColor($r('app.color.black'))
            .width("80%")
            .padding({
              top:$r('app.float.text_vertical_padding'),
              bottom: $r('app.float.text_vertical_padding')
            })
            .backgroundColor($r('app.color.start_window_button_background'))
            .margin({bottom: "5%",top: "10%"})
          Button($r('app.string.Join_in_group'))
            .fontSize($r('app.float.page_text_normal_size'))
            .fontColor($r('app.color.black'))
            .width("80%")
            .padding({
              top:$r('app.float.text_vertical_padding'),
              bottom: $r('app.float.text_vertical_padding')
            })
            .backgroundColor($r('app.color.start_window_button_background'))
            .margin({bottom: "10%",top: "5%"})
        }
        .borderRadius('10%')
        .backgroundColor($r('app.color.blue'))
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Center }
        })
        .width('80%')
      }
      .height('80%')
      .width('100%')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}