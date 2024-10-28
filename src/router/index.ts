import {createRouter, createWebHistory, RouteRecordRaw} from "vue-router";

const routes: RouteRecordRaw[] = [
  {
    path: "/",
    name: "home",
    component: () => import("@/pages/home/home.vue"),
    meta: {
      title: "首页"
    }
  },
  {
    path: "/static",
    name: "static",
    component: () => import("@/pages/static/static.vue"),
    meta: {
      title: "静态"
    }
  },
  {
    path: "/dynamic",
    name: "dynamic",
    component: () => import("@/pages/dynamic/dynamic.vue"),
    meta: {
      title: "动态"
    }
  },
  {
    path: "/setting",
    name: "setting",
    component: () => import("@/pages/setting/setting.vue"),
    meta: {
      title: "设置"
    }
  }
]


const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, _, next) => {
  document.title = to.meta.title as string
  next()
})

export default router
