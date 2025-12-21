import { CommonInfoCard } from '../components/InfoCard'
import { PageName, PhysicalExperimentSub } from './Login'

class physicalExperimentInfo{
  title: string = ""
  description: string = ""
  onClick: ()=>void = () => {}
}

@Component
export struct PhysicalExperiment {

  @Consume('navPathStack') navPathStack: NavPathStack

  physicalExperimentList: physicalExperimentInfo[] = [
    { title: "波尔扭摆实验", description: "", onClick: ()=>{
      this.navPathStack.pushPath({
        name: PhysicalExperimentSub.BohrTwistPendulumPage,
      })
  }},
    // { title: "Experiment 2", description: "This is the second experiment"}
  ]


  build() {
    NavDestination(){
      Column(){
        ForEach(this.physicalExperimentList, (item: physicalExperimentInfo, index) => {
          CommonInfoCard({
            title: item.title,
            description: item.description,
          })
            .onClick(()=>{
              item.onClick()
            })
            .width('100%').height(120)
        })
      }
        .alignItems(HorizontalAlign.Center)
        .width('95%').height('100%')
    }
  }
}