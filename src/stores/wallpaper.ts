import {defineStore} from "pinia";

export const wallpaperStore = defineStore('wallpaper', () => {
  const wallpaper = reactive<{
    type: "dynamic" | "static" | "",
    src: string,
    option: any
  }>({
    type: "",
    src: "",
    option: {}
  })

  const setWallpaper = (config: {src: string, type: "dynamic" | "static", option: any}) => {
    wallpaper.src = config.src
    wallpaper.type = config.type
    wallpaper.option = config.option
  }

  return {
    wallpaper,
    setWallpaper
  }
}, {
  persist: true
})
