import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import NotFoundView from '../views/NotFoundView.vue';
import AddProductView from '../views/AddProductView.vue';
import DeleteProductView from '../views/DeleteProductView.vue';
import AddDeleteUser from '../views/AddUserView.vue';
import DeleteUser from '../views/DeleteUserView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/addproduct',
      name: 'addproduct',
      component: () => import('../views/AddProductView.vue'),
    },
    {
      path: '/deleteproduct',
      name: 'deleteproduct',
      component: () => import('../views/DeleteProductView.vue'),
    },
    {
      path: '/adduser',
      name: 'adduser',
      component: () => import('../views/AddUserView.vue'),
    },
    {
      path: '/deleteuser',
      name: 'deleteuser',
      component: () => import('../views/DeleteUserView.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      name: '404',
      component: NotFoundView,
    },
  ],
});

export default router;
