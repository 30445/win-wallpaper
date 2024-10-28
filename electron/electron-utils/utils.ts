import {dialog} from "electron"


export const openSelectorFile = (filters?: any[]) => {
  return dialog.showOpenDialogSync({
    properties: ['openFile'],
    filters: filters
  })
}

