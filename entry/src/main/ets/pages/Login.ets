import { About } from './About';

export enum PageName{
  AboutPage = 'Page_About',
}
@Entry
@Component
struct Login {
  @State appTitle: Resource | string = $r('app.string.EntryAbility_label');

  @State loginButtonText: Resource | string = $r('app.string.Uni_login');
  uiContext = this.getUIContext()
  promptAction = this.uiContext.getPromptAction()

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  // 导航图 pageMap
  @Builder
  pageMap(name: string){
    if(name == PageName.AboutPage){
      About()
    }
  }
  async aboutToAppear(): Promise<void> {
    this.loginButtonText = $r('app.string.Uni_login')
  }

  build() {
    Navigation(this.navPathStack){
      Column({space : '20%'}) {
        Text(this.appTitle)
          .id('title_text')
          .fontSize($r('app.float.page_text_font_size'))
          .onClick(() => {
            this.appTitle = 'Welcome';
          })

        Button($r('app.string.Join_in_group'))
          .onClick(()=>{
            this.navPathStack.pushPath({name: PageName.AboutPage})
          })
      }
    }
    .navDestination(this.pageMap)
    .width('100%').height('100%')
  }
}
