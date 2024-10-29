import {BrowserWindow, ipcMain, screen} from "electron";
import {createNewWindow, openSelectorFile} from "./utils.ts"
import path from "node:path";
import {exec} from "child_process";
import * as fs from "fs";
import process from "process";

export default (win: BrowserWindow) => {
  ipcMain.on("select-file", (_, arg) => {
    let filters: any[] = []
    if (arg === "video") {
      filters = [ { name: 'Video', extensions: ['mp4'] } ]
    }

    const files = openSelectorFile(filters)
    win.webContents.send("selected-file", files)
  })
  ipcMain.on("preview-video", (_, arg) => {
    const defWin= createNewWindow('modal')
    console.log(defWin)
    defWin.setParentWindow(win)
    defWin.loadURL(arg)
  })
  ipcMain.handle("get-all-screen-list", () => {
    return {
      screens: screen.getAllDisplays(),
      mainId: screen.getPrimaryDisplay().id
    }
  })
  ipcMain.on("set-dynamic-wallpaper", (_, arg) => {
    const {screen: screenId, speed, mode} = JSON.parse(arg)

    const displays = screen.getAllDisplays()

    let useScreen = []

    if (screenId !== -1) { // 不是全部窗口
      useScreen = displays.filter(item => item.id === screenId)
    } else {
      useScreen = displays
    }
    useScreen.forEach(item => {
      createWallpaperWindow(item.bounds.x, item.bounds.y, item.bounds.width, item.bounds.height)
    })
  })
}

const createWallpaperWindow = (x: number, y: number, w: number, h: number) => {
  const wWin = createNewWindow('wallpaper', {x, y, width: w, height: h})
  wWin.loadURL('http://localhost:5173/dynamic-win')
  wWin.setIgnoreMouseEvents(true)
  setWallpaperLayer(wWin)
}

function setWallpaperLayer(win: BrowserWindow) {
  const hwnd = win.getNativeWindowHandle().readInt32LE(0)
  const command = `powershell -ExecutionPolicy Bypass -File "${path.join(process.env.VITE_PUBLIC, "set-window-pos.ps1")}" -myAppHwnd ${hwnd}`
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(error)
      console.log(`error: ${error.message}`)
      return
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return
    }
    console.log(`stdout: ${stdout}`)
  })
}


