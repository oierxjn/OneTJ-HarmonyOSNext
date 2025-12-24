import { GetData } from './DataProcess'

class BohrTwistPendulum {
  test(data: string){
    let processedData = data.split(/\s/)
    let cnt = 0
    let columnNumber = 3
    let resultData: string[][] = [[]]

    for(let item of processedData){
      if(item == undefined || item == ''){
        continue
      }
      resultData[cnt++].push(item)
      if(cnt % columnNumber == 0){
        cnt = 0
      }
    }
    let dataUnit = new GetData(resultData)

  }
}

export let bohrTwistPendulum = new BohrTwistPendulum()