const ipcRenderer = window.ipcRenderer

const ipcOn = (...args: Parameters<typeof ipcRenderer.on>) => {
  const [channel, listener] = args
  ipcRenderer.on(channel, listener)
}

const ipcOff = (...args: Parameters<typeof ipcRenderer.off>) => {
  const [channel, ...omit] = args
  ipcRenderer.off(channel, ...omit)
}

const ipcSend = (...args: Parameters<typeof ipcRenderer.send>) => {
  const [channel, ...omit] = args
  ipcRenderer.send(channel, ...omit)
}

const ipcInvoke = (...args: Parameters<typeof ipcRenderer.invoke>) => {
  const [channel, ...omit] = args
  return ipcRenderer.invoke(channel, ...om)
}

const ipcOnce = (...args: Parameters<typeof ipcRenderer.once>) => {
  const [channel, listener] = args
  ipcRenderer.once(channel, listener)
}

export default {
  ipcOn,
  ipcOff,
  ipcSend,
  ipcInvoke
}

