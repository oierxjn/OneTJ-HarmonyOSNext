import { distributedKVStore } from "@kit.ArkData";
import { bundleManager } from "@kit.AbilityKit";

export let kvManager: distributedKVStore.KVManager | undefined = undefined;

/**
 * 异步初始化KV数据库管理器
 *
 * @param context UI上下文
 * @returns 是否初始化完成
 */
export async function initKVManager(context: Context): Promise<boolean> {
  let appID: string;
  let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
  try {
    let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    appID = bundleInfo.name;
    if(appID == null){
      throw new Error('获取到空值')
    }
  } catch (e){
    console.error(`获取应用ID错误：${e}`)
    return false
  }
  const kvManagerConfig: distributedKVStore.KVManagerConfig = {
    context: context,
    bundleName: appID
  }
  try {
    kvManager = distributedKVStore.createKVManager(kvManagerConfig);
  } catch (err) {
    console.error(`数据库管理器初始化错误：${err}`)
    return false
  }
  return true
}

/**
 * 泛型懒加载数据提供类型
 *
 * @author oierxjn
 * @template T -数据源类型
 */
export class ListDataSource<T> implements IDataSource{
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

/**
 * 普通消息数据
 */
export class CommonMsgData{
  id: number;
  title: string;
  publishTime: string;
  constructor(id: number, title: string, publishTime: string) {
    this.id = id;
    this.title = title;
    this.publishTime = publishTime;
  }
}

/**
 * 详细消息数据
 */
export class DetailMsgData{
  content: string | null;
  // TODO: Attachments
  constructor(content: string | null) {
    this.content = content;
  }
}