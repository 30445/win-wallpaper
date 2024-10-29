import {BrowserWindow, dialog} from "electron"
import path from "node:path";


export const openSelectorFile = (filters?: any[]) => {
  return dialog.showOpenDialogSync({
    properties: ['openFile'],
    filters: filters
  })
}

export const createNewWindow = (type?: 'wallpaper' | 'modal', config?: {
  x: number,
  y: number,
  width: number,
  height: number
}) => {
  if (type === "wallpaper" && config) {
    const { width, height, x, y} = config
    return new BrowserWindow({
      width: width,
      height: height,
      x: x,
      y: y,
      frame: false, // 是否显示窗口边框
      focusable: false, //禁止窗口获取焦点
      fullscreen: true, //是否全屏显示
      webPreferences: {
        nodeIntegration: true, //赋予此窗口页面中的JavaScript访问Node.js环境的能力
        webSecurity: false, //可以使用本地资源
        contextIsolation: false, //是否使用上下文隔离
        preload: path.join(__dirname, 'preload.mjs')
      }
    })
  } else {
    return new BrowserWindow({
      width: 800,
      height: 600,
      modal: type === 'modal',
      webPreferences: {
        webSecurity: false,
        preload: path.join(__dirname, 'preload.mjs')
      }
    })
  }
}

