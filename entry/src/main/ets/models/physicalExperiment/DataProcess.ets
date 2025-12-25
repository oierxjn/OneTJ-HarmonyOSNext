export interface DataDot{
  x: number,
  y: number
}
export class GetData{
  data: string[][]
  constructor(data: string[][] =[]){
    this.data = data
  }

  /**
   * 最小二乘法拟合直线
   * 拟合公式：Y = C + kX （Y=lnAₙ，X=n）
   * 斜率k = (nΣXY - ΣXΣY) / (nΣX² - (ΣX)²)
   * 截距C = (ΣY - kΣX) / n
   *
   * @param data 数据点
   * @returns 拟合结果，x为斜率，y为截距
   */
  static leastSquareFitting(data: DataDot[]): DataDot {
    let slopeK = 0
    let interceptC = 0
    const dataCount = data.length
    if (dataCount < 2) { // 至少2个数据才能拟合直线
      slopeK = 0;
      interceptC = 0;
      return {x: 0, y: 0}
    }

    // 计算各项累加和
    let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (let i = 0; i < dataCount; i++) {
      const x = data[i].x
      const y = data[i].y
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    // 计算斜率k和截距C
    slopeK = (dataCount * sumXY - sumX * sumY) / (dataCount * sumX2 - sumX * sumX);
    interceptC = (sumY - slopeK * sumX) / dataCount;
    return {x: slopeK, y: interceptC}
  }

  /**
   * 将线性数据转换为二维数组
   *
   * @param list
   * @param columnNumber
   * @returns
   */
  static getDataFromList(list: string[], columnNumber: number,): string[][]{
    if(columnNumber == 0)
      throw new Error('获取数据时列数不能为0')

    let tempRow:string[] = []
    let result: string[][] = []
    for(let item of list){
      if(item == undefined || item == ''){
        continue
      }
      tempRow.push(item)
      if(tempRow.length % columnNumber == 0){
        result.push(tempRow)
        tempRow = []
      }
    }
    return result
  }

  /**
   * 将数据列表的每一行传入给定函数，并将给定函数的返回值添加为传入行的新元素，加入到行末
   *
   * @param func 传入的处理函数 参数为行数据，返回值为新增数据，新数据为字符串数组
   */
  dataAddColumnByFunc(func: (row: string[]) => string[]): GetData{
    let data = this.data
    for(let i = 0; i < data.length; i++){
      const item = func(data[i])
      data[i].push(...item)
    }
    return this
  }
  /**
   * 将数据列表的每一列传入给定函数，将给定函数的返回值作为行数据
   *
   * @param func 传入的处理函数
   */
  dataAddRowByFunc(func: (column: string[], index: number) => string[]): GetData{
    let data = this.data
    for(let i = 0; i < data[0].length; i++){
      let column: string[] = []
      for(let j = 0; j < data.length; j++){
        column.push(data[j][i])
      }
      let result = func(column, i)
      for(let j = data.length; j < data.length + result.length; j++){
        if(i == 0)data.push([])
        data[j].push(result[j - data.length])
      }
    }
    return this
  }


  printData(tag: string = 'Debug', print: (message: string)=>void = console.debug){
    let data = this.data
    let printData: string = ''
    for (let line of data) {
      for(let item of line){
        printData += item + '\t'
      }
      printData += '\n'
    }
    print(`${tag} ${printData}`)
  }
}