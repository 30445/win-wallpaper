<template>
  <a-config-provider :locale="zhCN">
    <Layout />
  </a-config-provider>
</template>

<script setup lang="ts">
import zhCN from "ant-design-vue/es/locale/zh_CN"
import dayjs from "dayjs"
import "dayjs/locale/zh-cn"
import Layout from "@/layout/Layout.vue";

dayjs.locale("zh-cn")

</script>

<style scoped>

</style>
