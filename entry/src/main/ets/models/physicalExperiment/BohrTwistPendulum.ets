import { DataDot, GetData } from './DataProcess'

class BohrTwistPendulum {
  /**
   * 平均周期
   */
  averageTime: number = 0
  numberOfIntervals: number = 5
  logSlopeK: number = 0
  graphSlopeK: number = 0

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

    resultData = GetData.getDataFromList(processedData, columnNumber)

    let dataUnit = new GetData(resultData)

    if(dataUnit.data.length == 0)return 0

    let sum = 0
    for(let i = 0; i < dataUnit.data.length; i++){
      sum += parseFloat(dataUnit.data[i][2])
    }
    let averageTime = sum / dataUnit.data.length
    this.averageTime = averageTime
    return averageTime
  }
  /**
   * 从表格数据中得到振幅
   *
   * @param data
   * @returns
   */
  processAmplitudeFromTable(data: string): void{
    let processedData = data.split(/\s/)
    let columnNumber = 3
    let resultData: string[][] = []
    resultData = GetData.getDataFromList(processedData, columnNumber)

    let dataUnit = new GetData(resultData)
    if(dataUnit.data.length == 0)return

    /**
     * 对数逐差法
     */
    dataUnit.dataAddColumnByFunc((row: string[])=>{
      /**
       * \beta &= \frac{ln\theta _{n}-ln\theta _{n+5}}{5T}
       */
      return [((Math.log(parseFloat(row[1]))-Math.log(parseFloat(row[2])))/this.numberOfIntervals/this.averageTime).toString()]
    })
    let tempSum = 0
    for(let item of dataUnit.data){
      tempSum += parseFloat(item[3])
    }
    this.logSlopeK = tempSum/dataUnit.data.length
    console.debug(`对数逐差法结果为：${this.logSlopeK}`)

    let amplitudeLogList: DataDot[] = []
    for(let item of dataUnit.data){
      amplitudeLogList.push({x: parseInt(item[0]), y: Math.log(parseFloat(item[1]))})
      amplitudeLogList.push({x: parseInt(item[0])+this.numberOfIntervals, y: Math.log(parseFloat(item[2]))})
    }
    let graphSlopeK = GetData.leastSquareFitting(amplitudeLogList).x/-1/this.averageTime
    this.graphSlopeK = graphSlopeK
    console.debug(`图解法斜率结果为：${graphSlopeK}`)
  }
}

export let bohrTwistPendulum = new BohrTwistPendulum()

