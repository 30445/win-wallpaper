<template>
  <div class="dynamic-win">
    <video :src="wallpaper.wallpaper.src" autoplay loop ></video>
  </div>
</template>

<script setup lang="ts">
import {wallpaperStore} from "@/stores/wallpaper.ts";

const wallpaper = wallpaperStore()


</script>

<style scoped lang="scss">
.dynamic-win {
  width: 100vw !important;
  height: 100vh !important;
  overflow: hidden;
  video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}
</style>
