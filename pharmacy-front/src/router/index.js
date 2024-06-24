import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import NotFoundView from '../views/NotFoundView.vue';
import AddProductView from '../views/AddProductView.vue';
import LiveProducts from '../views/LiveProducts.vue';
import AddDeleteUser from '../views/AddDeleteUser.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue'),
    },
    {
      path: '/addproduct',
      name: 'addproduct',
      component: () => import('../views/AddProductView.vue'),
    },
    {
      path: '/live',
      name: 'live',
      component: () => import('../views/LiveProducts.vue'),
    },
    {
      path: '/users',
      name: 'users',
      component: () => import('../views/AddDeleteUser.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      name: '404',
      component: NotFoundView,
    },
  ],
});

export default router;
