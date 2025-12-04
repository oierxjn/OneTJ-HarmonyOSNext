export function buildAlertDialogParams(
  message: string | Error,
  title: string = '错误',
  tipText: string = '你可以选择截图并联系开发人员'
): AlertDialogParam {
  let result: AlertDialogParamWithConfirm = {
    title: title,
    message: `${message}\n`+tipText,
    confirm: {
      value: '确认',
      action: () => {}
    }
  }
  return result
}