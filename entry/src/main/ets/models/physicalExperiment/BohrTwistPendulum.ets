import { GetData } from './DataProcess'

class BohrTwistPendulum {
  /**
   * 从表格数据中得到周期
   *
   * @param data
   * @returns
   */
  processTimeFromTable(data: string): number{
    let processedData = data.split(/\s/)
    let columnNumber = 3
    let resultData: string[][] = []
    let tempRow: string[] = []

    for(let item of processedData){
      if(item == undefined || item == ''){
        continue
      }
      tempRow.push(item)
      if(tempRow.length % columnNumber == 0) {
        resultData.push(tempRow)
        tempRow = []
      }
    }
    let dataUnit = new GetData(resultData)

    if(dataUnit.data.length == 0)return 0

    let sum = 0
    for(let i = 0; i < dataUnit.data.length; i++){
      sum += parseFloat(dataUnit.data[i][2])
    }
    let averageTime = sum / dataUnit.data.length
    return averageTime
  }
}

export let bohrTwistPendulum = new BohrTwistPendulum()