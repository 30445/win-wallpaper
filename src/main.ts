import { createApp } from 'vue'
import 'ant-design-vue/dist/reset.css';
import './style.scss'
import App from './App.vue'
import router from "@/router";
import {createPinia} from "pinia"
import piniaPluginPersistedState from 'pinia-plugin-persistedstate'

const app = createApp(App)

const pinia = createPinia()
pinia.use(piniaPluginPersistedState)
app.use(pinia)

app.use(router)

app.mount('#app').$nextTick(() => {
  // Use contextBridge
  window.ipcRenderer.on('main-process-message', (_event, message) => {
    console.log(message)
  })
})

