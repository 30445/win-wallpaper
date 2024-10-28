<template>
  <div class="dynamic flex-center">
    <a-button @click="handleClick">选择视频</a-button>
  </div>
</template>

<script setup lang=ts>
import {ipcOn, ipcSend} from '@/utils/ipc'
const handleClick = () => {
  ipcSend("select-file", "video")
}

ipcOn("selected-file", (_, data) => {
  if (data) {
    console.log(data)
  }
})
</script>

<style scoped lang="scss">
.dynamic {

}
</style>
