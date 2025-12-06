
export function buildAlertDialog(
  uiContext: UIContext,
  message: string | Error | null,
  title: string = '错误',
  tipText: string = '你可以选择截图并联系开发人员'
){
  uiContext.showAlertDialog({
    title: title,
    message: `${message}\n`+tipText,
    confirm: {
      value: '确认',
      action: () => {}
    }
  })
}