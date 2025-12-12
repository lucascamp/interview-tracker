<template>
    <Layout>
        <div class="container mx-auto px-4 py-8">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Entrevistados</h1>
                <Link
                    :href="route('entrevistados.create')"
                    class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700"
                >
                    <span class="mr-2">+</span>
                    Novo Entrevistado
                </Link>
            </div>

            <div class="bg-white rounded-lg shadow overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Nome
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Ações
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="entrevistado in entrevistados.data || []" :key="entrevistado.id" class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ entrevistado.nome }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <Link
                                    :href="route('entrevistados.edit', entrevistado.id)"
                                    class="text-indigo-600 hover:text-indigo-900 mr-3"
                                >
                                    Editar
                                </Link>
                                <button
                                    @click="deleteEntrevistado(entrevistado.id)"
                                    class="text-red-600 hover:text-red-900"
                                >
                                    Excluir
                                </button>
                            </td>
                        </tr>
                        <tr v-if="!entrevistados.data || entrevistados.data.length === 0">
                            <td colspan="2" class="px-6 py-4 text-center text-gray-500">
                                Nenhum entrevistado encontrado.
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Paginação -->
                <div v-if="entrevistados.links && entrevistados.links.length > 3" class="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                    <div class="flex items-center justify-between">
                        <div class="flex-1 flex justify-between sm:hidden">
                            <Link
                                v-if="entrevistados.links[0].url"
                                :href="entrevistados.links[0].url"
                                class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                            >
                                Anterior
                            </Link>
                            <Link
                                v-if="entrevistados.links[entrevistados.links.length - 1].url"
                                :href="entrevistados.links[entrevistados.links.length - 1].url"
                                class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                            >
                                Próxima
                            </Link>
                        </div>
                        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                            <div>
                                <p class="text-sm text-gray-700">
                                    Mostrando
                                    <span class="font-medium">{{ entrevistados.from || 0 }}</span>
                                    até
                                    <span class="font-medium">{{ entrevistados.to || 0 }}</span>
                                    de
                                    <span class="font-medium">{{ entrevistados.total || 0 }}</span>
                                    resultados
                                </p>
                            </div>
                            <div>
                                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                    <template v-for="(link, index) in entrevistados.links" :key="index">
                                        <Link
                                            v-if="link.url"
                                            :href="link.url"
                                            v-html="link.label"
                                            :class="[
                                                'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                                                link.active
                                                    ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
                                                    : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                                                index === 0 ? 'rounded-l-md' : '',
                                                index === entrevistados.links.length - 1 ? 'rounded-r-md' : ''
                                            ]"
                                        />
                                        <span
                                            v-else
                                            v-html="link.label"
                                            :class="[
                                                'relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-300',
                                                index === 0 ? 'rounded-l-md' : '',
                                                index === entrevistados.links.length - 1 ? 'rounded-r-md' : ''
                                            ]"
                                        />
                                    </template>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </Layout>
</template>

<script setup>
import { Link, router } from '@inertiajs/vue3';
import Layout from '@/Layouts/Layout.vue';

const route = window.route;

const props = defineProps({
    entrevistados: Object,
});

const deleteEntrevistado = (id) => {
    if (confirm('Tem certeza que deseja excluir este entrevistado?')) {
        router.delete(route('entrevistados.destroy', id), {
            preserveState: true,
            preserveScroll: true,
            onError: (errors) => {
                if (errors.message) {
                    alert(errors.message);
                }
            },
        });
    }
};
</script>

