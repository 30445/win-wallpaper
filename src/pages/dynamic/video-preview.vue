<template>
  <div class="video-preview flex flex-column">
    <div class="video-box flex justify-center">
      <video :src="videoUrl" controls></video>
    </div>
    <div class="handle">
      <a-form layout="inline">
        <a-form-item label="对齐">
          <a-radio-group v-model:value="modal.mode">
            <a-radio v-for="(item, index) in alignMode" :key="index" :value="item.value">{{item.label}}</a-radio>
          </a-radio-group>
        </a-form-item>
        <a-form-item label="播放速度">
          <a-slider v-model:value="modal.speed" :min="1" :max="100" :step="1" style="width: 200px"></a-slider>
        </a-form-item>
        <a-form-item label="设置窗口">
          <a-select style="width: 200px" v-model:value="modal.screen">
            <a-select-option :value="-1">全部</a-select-option>
            <a-select-option v-for="(item, index) in screenList" :key="index" :value="item.id">{{item.label}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item>
          <a-button type="primary" @click="handleOk">确定</a-button>
        </a-form-item>
      </a-form>
    </div>
  </div>
</template>

<script setup lang="ts">
import {ipcInvoke, ipcSend} from "@/utils/ipc.ts";
import {wallpaperStore} from "@/stores/wallpaper.ts";

const videoUrl = ref("")

const route = useRoute()

watch(() => route.query.url, (val) => {
  videoUrl.value = val as string
}, { immediate: true })

const alignMode = [
  { label: "自适应", value: "contain" },
  { label: "铺满", value: "cover" },
  { label: "居中", value: "center" }
]

const screenList = ref<{
  label: string,
  isMain: boolean,
  id: number
}>()

const modal = reactive({
  mode: "contain",
  speed: 50,
  screen: -1
})

const wallpaper = wallpaperStore()

onMounted(async () => {
  const {screens, mainId} = await ipcInvoke("get-all-screen-list")
  screenList.value = screens.map((item: any) => {
    return {
      label: `${mainId === item.id ? '主显示器 - ' : ''}${item.label}`,
      isMain: mainId === item.id,
      id: item.id as number
    }
  }).sort((a: any, b: any) => {
    return b.isMain - a.isMain
  })
})

const handleOk = () => {
  wallpaper.setWallpaper({
    src: videoUrl.value,
    type: "dynamic",
    option: {
      mode: modal.mode,
      speed: modal.speed,
      screen: modal.screen
    }
  })
  ipcSend("set-dynamic-wallpaper", JSON.stringify(wallpaper.wallpaper.option))
}

</script>

<style scoped lang="scss">
.video-preview {
  .video-box {
    //height: calc(100vh - 80px);
    video {
      width: 100%;
      height: 100%;
    }
  }
  .handle {
    height: 80px;
  }
}
</style>
