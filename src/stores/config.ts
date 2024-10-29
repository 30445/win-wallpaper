import {defineStore} from "pinia";

export const configStore = defineStore("config", () => {
  const config = ref({})


  return {
    config
  }
}, {
  persist: true
})


