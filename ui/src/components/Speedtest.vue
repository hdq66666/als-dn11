<script setup>
import Librespeed from '@/components/Speedtest/Librespeed.vue'
import { useAppStore } from '@/stores/app'

const appStore = useAppStore()
</script>

<template>
  <n-card v-if="appStore.config.feature_librespeed">
    <template #header> {{ $t('server_speedtest') }} </template>
    <Librespeed />
  </n-card>
</template>
