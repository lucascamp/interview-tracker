<template>
    <div class="min-h-screen bg-gray-100">
        <nav class="bg-white shadow">
            <div class="container mx-auto px-4">
                <div class="flex justify-between items-center py-4">
                    <Link :href="route('dashboard')" class="text-xl font-bold text-indigo-600">
                        Interview Tracker
                    </Link>
                    <div class="space-x-4">
                        <Link
                            :href="route('dashboard')"
                            class="text-gray-700 hover:text-indigo-600"
                        >
                            Dashboard
                        </Link>
                        <Link
                            :href="route('entrevistados.index')"
                            class="text-gray-700 hover:text-indigo-600"
                        >
                            Entrevistados
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <main>
            <slot />
        </main>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';

// Expor a função route para uso no template
const route = window.route;
</script>

