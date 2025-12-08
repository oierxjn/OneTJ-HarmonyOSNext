import { distributedKVStore } from "@kit.ArkData";
import { ability, Ability, bundleManager, UIAbility, common } from "@kit.AbilityKit";

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
  dataList: T[] = [];

  constructor(list?: T[]){
    if(list != null) {
      this.dataList = list;
    }
  }

  public totalCount(): number {
    return this.dataList.length;
  }
  public getData(index: number): T {
    return this.dataList[index];
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

export class MsgListDataSource extends ListDataSource<CommonMsgData> {
  push(msg: CommonMsgData){
    this.dataList.push(msg);
    this.notifyDataAdd(this.dataList.length - 1);
  }
}

/**
 * 详细消息数据
 */
export class DetailMsgData{
  title: string | undefined | null;
  content: string | undefined | null;

  constructor(content: string | null) {
    this.content = content;
  }
}

export class TextSectionAttribute {
  title: ResourceStr = '';
  maxLines: number;
  fontColor: ResourceStr;
  fontSize: Resource | number | string;
  lineHeight: number;
  constraintWidth: Resource | number | string;

  constructor(title: ResourceStr = '', maxLines: number = 2, fontColor: ResourceStr = '#000',
    fontSize: Resource | number | string = '16vp', lineHeight: number = 16,
    constraintWidth: Resource | number | string = 350) {
    this.title = title;
    this.maxLines = maxLines;
    this.fontColor = fontColor;
    this.fontSize = fontSize;
    this.lineHeight = lineHeight;
    this.constraintWidth = constraintWidth;
  }
}

export interface CommonMsgToDetailMsgNavParams{
  id: number;
  title: string;
}

export enum HomeFunctions {
  NONE = 'none',
  SETTINGS = 'settings',
  ABOUT = 'about',
  GRADUATE_STUDENT_TIME_TABLE_SINGLE_DAY = 'graduate_student_time_table_single_day',
  LOGOUT = 'logout',
  JOIN_QQ_GROUP = 'join_qq_group',
  EXP_CALC = 'experimental_calculation'
}

export class HomeFunctionItem {
  uid: HomeFunctions;
  name: string;
  icon: ResourceStr;
  constructor(uid: HomeFunctions, name: string, icon: ResourceStr) {
    this.uid = uid;
    this.name = name;
    this.icon = icon;
  }
  static keyGenerator(item: HomeFunctionItem): string {
    return item.uid;
  }
}

export class GlobalContext{
  private static context: Context;
  static initContext(context: Context){
    GlobalContext.context = context
  }
  static getContext(): Context{
    return GlobalContext.context;
  }
}
