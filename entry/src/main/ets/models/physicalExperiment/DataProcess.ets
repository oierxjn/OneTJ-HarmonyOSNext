export class GetData{
  data: string[][]
  constructor(data: string[][] =[]){
    this.data = data
  }

  /**
   * 将数据列表的每一行传入给定函数，并将给定函数的返回值添加为传入行的新元素，加入到行末
   *
   * @param func 传入的处理函数 参数为行数据，返回值为新增数据，新数据为字符串数组
   */
  dataAddByFunc(func: (row: string[]) => string[]): GetData{
    let data = this.data
    for(let i = 0; i < data.length; i++){
      const item = func(data[i])
      data[i].push(...item)
    }
    return this
  }

  printData(tag: string = 'Debug'){
    let data = this.data
    let printData: string = ''
    for (let line of data) {
      for(let item of line){
        printData += item + '\t'
      }
      printData += '\n'
    }
    console.debug(`${tag} ${printData}`)
  }
}