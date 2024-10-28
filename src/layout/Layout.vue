<template>
  <div class="layout flex">
    <base-header />

    <div class="content flex-1">
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup lang=ts>
import BaseHeader from "./BaseHeader.vue";

</script>

<style scoped lang="scss">
.layout {
  height: 100vh;
}
</style>
