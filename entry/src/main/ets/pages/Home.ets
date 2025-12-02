@Component
export struct Home {
  @Consume('navPathStack') navPathStack: NavPathStack

  build() {
    NavDestination(){
      Column(){
        Row(){
          Text('一统同济Home')
        }
        .height('40%')
        List(){

        }
        .width('100%').height('60%')
      }
    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}