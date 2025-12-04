import { InfoCard } from '../components/InfoCard'
import { ListDataSource } from '../DisplayUtils/DataUtils'


@Component
export struct Home {
  @Consume('navPathStack') navPathStack: NavPathStack

  @State arr: ListDataSource<number> = new ListDataSource([1,2,3,4,5,6,9])
  @State testCount: number = 0

  async aboutToAppear(): Promise<void> {
    
  }

  build() {
    NavDestination(){
      Column(){
        Row(){
          Image($rawfile('fluentemoji/banana_color.svg'))
            .width('30%')
          Text(this.testCount.toString())
        }
        .height('30%')
        Divider()
          .margin({top: '5', bottom: '5'})
        List(){
          LazyForEach(this.arr, (item: number, index: number) => {
            ListItem(){
              Column(){
                InfoCard({info: `${item.toString()}索引${index}`}).width('100%').height('30%')
                Divider()
                  .margin({top: '5', bottom: '5'})
              }
            }
          })
        }
        .width('100%').height('70%')
      }
      .width('100%').height('100%')
    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}