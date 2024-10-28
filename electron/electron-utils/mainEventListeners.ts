import {BrowserWindow, ipcMain} from "electron";
import {openSelectorFile} from "./utils.ts"

export default (win: BrowserWindow) => {
  ipcMain.on("select-file", (_, arg) => {
    let filters: any[] = []
    if (arg === "video") {
      filters = [ { name: 'Video', extensions: ['mp4'] } ]
    }

    const files = openSelectorFile(filters)
    win.webContents.send("selected-file", files)
  })
}