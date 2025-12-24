import { GetData } from './DataProcess'

class BohrTwistPendulum {
  testProcessTime(data: string): number{
    let processedData = data.split(/\s/)
    let cnt = 0
    let columnNumber = 3
    let T = 0
    let resultData: string[][] = []
    let tempRow: string[] = []

    for(let item of processedData){
      if(item == undefined || item == ''){
        continue
      }
      tempRow.push(item)
      if(tempRow.length % columnNumber == 0) {
        resultData.push(tempRow)
        cnt++
      }
    }
    let dataUnit = new GetData(resultData)

    if(dataUnit.data.length == 0)return 0

    let sum = 0
    for(let i = 0; i < dataUnit.data.length; i++){
      sum += parseFloat(dataUnit.data[i][2])
    }
    let averageTime = sum / dataUnit.data.length
    console.debug(`调试：计算sum:${sum}\n长度${dataUnit.data.length}\n最终值为${averageTime}`)
    return averageTime
  }
}

export let bohrTwistPendulum = new BohrTwistPendulum()