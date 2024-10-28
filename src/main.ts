import { createApp } from 'vue'
import 'ant-design-vue/dist/reset.css';
import './style.scss'
import App from './App.vue'
import router from "@/router";

const app = createApp(App)

app.use(router)

app.mount('#app').$nextTick(() => {
  // Use contextBridge
  window.ipcRenderer.on('main-process-message', (_event, message) => {
    console.log(message)
  })
})

