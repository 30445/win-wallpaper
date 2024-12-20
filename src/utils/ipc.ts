const ipcRenderer = window.ipcRenderer

export const ipcOn = (...args: Parameters<typeof ipcRenderer.on>) => {
  const [channel, listener] = args
  ipcRenderer.on(channel, listener)
}

export const ipcOff = (...args: Parameters<typeof ipcRenderer.off>) => {
  const [channel, ...omit] = args
  ipcRenderer.off(channel, ...omit)
}

export const ipcSend = (...args: Parameters<typeof ipcRenderer.send>) => {
  const [channel, ...omit] = args
  ipcRenderer.send(channel, ...omit)
}

export const ipcInvoke = (...args: Parameters<typeof ipcRenderer.invoke>) => {
  const [channel, ...omit] = args
  return ipcRenderer.invoke(channel, ...omit)
}

export const ipcOnce = (...args: Parameters<typeof ipcRenderer.once>) => {
  const [channel, listener] = args
  ipcRenderer.once(channel, listener)
}



