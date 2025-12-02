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

export class TongjiApi {

}