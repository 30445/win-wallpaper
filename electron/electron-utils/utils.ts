import {BrowserWindow} from "electron";
import path from "node:path";
import {fileURLToPath} from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url))
export const setWindowToWallpaper = async (win: BrowserWindow): Promise<void> => {

  console.log(__dirname)
  //
  // const hwnd = win.getNativeWindowHandle().readInt32LE(0);
  //
  // if (!hwnd) {
  //   return Promise.reject("获取窗口句柄失败");
  // }




};



