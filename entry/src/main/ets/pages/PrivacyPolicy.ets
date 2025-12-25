import { Markdown, MarkdownController } from '@luvi/lv-markdown-in'

@Component
export struct PrivacyPolicy {
  markdownController: MarkdownController = new MarkdownController()

  aboutToAppear(): void {
    this.markdownController.setTextColor($r('sys.color.ohos_id_color_text_primary'))
    this.markdownController.setTitleColor($r('sys.color.ohos_id_color_text_primary'))
  }

  build(){
    NavDestination(){
      Scroll(){
        Markdown({
          controller: this.markdownController,
          mode: 'rawfile',
          rawfilePath: 'privacy_policy.md',
          context: this.getUIContext().getHostContext()
        })
      }
      .padding({
        left: 15,
        right: 15,
        top: 60,
      })
    }
      .title(`一统同济用户隐私政策`)
  }
}