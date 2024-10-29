<template>
  <div class="base-header">
    <div class="menu-box">
      <a-menu
        v-model:openKeys="state.openKeys"
        v-model:selectedKeys="state.selectedKeys"
        :inline-collapsed="state.collapsed"
        :items="items"
        @select="handleSelect"
      ></a-menu>
    </div>
  </div>
</template>

<script setup lang="ts">
const items = ref([
  {
    key: "home",
    label: "首页",
    title: "首页"
  },
  {
    key: "static",
    label: "静态",
    title: "静态"
  },
  {
    key: "dynamic",
    label: "动态",
    title: "动态"
  },
  {
    key: "setting",
    label: "设置",
    title: "设置"
  }
])

const state = reactive({
  openKeys: [],
  selectedKeys: ['home'],
  collapsed: false
})

const router = useRouter()
const route = useRoute()

const handleSelect = ({key}: {key: string}) => {
  router.push({name: key})
}

watch(() => route.name, (val) => { state.selectedKeys = [val as string] }, { immediate: true })
</script>

<style scoped lang="scss">
.base-header {
  border-inline-end: 1px solid rgba(5, 5, 5, 0.06);
  .menu-box {
    .ant-menu {
      border-inline-end: none;
    }
  }
}
</style>
