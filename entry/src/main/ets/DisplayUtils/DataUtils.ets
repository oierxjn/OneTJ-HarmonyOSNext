/**
 * 泛型懒加载数据提供类型
 *
 * @author oierxjn
 * @template T -数据源类型
 */
class ListDataSource<T> implements IDataSource{
  listeners: DataChangeListener[] = [];
  list: T[] = [];

  constructor(list: T[]){
    this.list = list;
  }

  public totalCount(): number {
    return this.list.length;
  }
  public getData(index: number): T {
    return this.list[index];
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  public notifyDataChanged(): void {
    this.listeners.forEach((listener) => {
      listener.onDataReloaded()
    });
  }

  public notifyDataAdd(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataAdd(index)
    })
  }

  public notifyDataChange(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataChange(index)
    })
  }

  public notifyDataDelete(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataDelete(index)
    })
  }

  public notifyDataMove(fromIndex: number, toIndex: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataMove(fromIndex, toIndex)
    })
  }

  public notifyDatasetChange(operations: DataOperation[]): void{
    this.listeners.forEach((listener) => {
      listener.onDatasetChange(operations)
    })
  }
}
