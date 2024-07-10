import { createRouter, createWebHistory } from 'vue-router';
import LoginView from '../views/LoginView.vue';
import HomeView from '../views/HomeView.vue';
import NotFoundView from '../views/NotFoundView.vue';
import AddProductView from '../views/AddProductView.vue';
import DeleteProductView from '../views/DeleteProductView.vue';
import TransferView from '../views/TransferView.vue';
import AddDeleteUser from '../views/AddUserView.vue';
import DeleteUser from '../views/DeleteUserView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Login',
      component: LoginView,
    },
    {
      path: '/home',
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
      path: '/transfer',
      name: 'transfer',
      component: () => import('../views/TransferView.vue'),
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
