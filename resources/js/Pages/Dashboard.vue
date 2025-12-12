<template>
    <Layout>
        <div class="container mx-auto px-4 py-8">
            <!-- Filtros -->
            <div class="bg-white rounded-lg shadow p-6 mb-6">
                <h2 class="text-lg font-semibold mb-4">Filtros</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Plataforma</label>
                        <select
                            v-model="filters.plataforma"
                            @change="applyFilters"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        >
                            <option value="">Todas</option>
                            <option value="linkedin">LinkedIn</option>
                            <option value="indeed">Indeed</option>
                            <option value="gupy">Gupy</option>
                            <option value="kenoby">Kenoby</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                        <select
                            v-model="filters.status"
                            @change="applyFilters"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        >
                            <option value="">Todos</option>
                            <option value="aplicado">Aplicado</option>
                            <option value="entrevista_rh">Entrevista RH</option>
                            <option value="entrevista_tecnica">Entrevista Técnica</option>
                            <option value="entrevista_cultural">Entrevista Cultural</option>
                            <option value="oferta">Oferta</option>
                            <option value="concluido">Concluído</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Entrevistado</label>
                        <select
                            v-model="filters.entrevistado"
                            @change="applyFilters"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        >
                            <option value="">Todos</option>
                            <option value="Lucas">Lucas</option>
                            <option value="Thais">Thais</option>
                        </select>
                    </div>
                </div>
                <div class="mt-4">
                    <button
                        @click="clearFilters"
                        class="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300"
                    >
                        Limpar Filtros
                    </button>
                </div>
            </div>

            <!-- Botão Adicionar -->
            <div class="mb-4">
                <button
                    @click="openCreateModal"
                    class="inline-flex items-center px-4 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700"
                >
                    <span class="mr-2">+</span>
                    Nova Entrevista
                </button>
            </div>

            <!-- Tabela -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Entrevistado
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Plataforma
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Empresa
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Status
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Data Cadastro
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Responsável
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Ações
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="entrevista in entrevistas.data || []" :key="entrevista.id" class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ entrevista.entrevistado }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ entrevista.plataforma || '-' }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ entrevista.nome_empresa || '-' }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span
                                    :class="getStatusClass(entrevista.status)"
                                    class="px-2 py-1 text-xs font-semibold rounded-full"
                                >
                                    {{ formatStatus(entrevista.status) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ formatDate(entrevista.data_cadastro_vaga) }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                {{ entrevista.responsavel_processo || '-' }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <button
                                    @click="openEditModal(entrevista.id)"
                                    class="text-sky-600 hover:text-sky-900 mr-3"
                                >
                                    Editar
                                </button>
                            </td>
                        </tr>
                        <tr v-if="!entrevistas.data || entrevistas.data.length === 0">
                            <td colspan="7" class="px-6 py-4 text-center text-gray-500">
                                Nenhuma entrevista encontrada.
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Paginação -->
                <div v-if="entrevistas.links && entrevistas.links.length > 3" class="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                    <div class="flex items-center justify-between">
                        <div class="flex-1 flex justify-between sm:hidden">
                            <Link
                                v-if="entrevistas.links[0].url"
                                :href="entrevistas.links[0].url"
                                class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                            >
                                Anterior
                            </Link>
                            <Link
                                v-if="entrevistas.links[entrevistas.links.length - 1].url"
                                :href="entrevistas.links[entrevistas.links.length - 1].url"
                                class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                            >
                                Próxima
                            </Link>
                        </div>
                        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                            <div>
                                <p class="text-sm text-gray-700">
                                    Mostrando
                                    <span class="font-medium">{{ entrevistas.from || 0 }}</span>
                                    até
                                    <span class="font-medium">{{ entrevistas.to || 0 }}</span>
                                    de
                                    <span class="font-medium">{{ entrevistas.total || 0 }}</span>
                                    resultados
                                </p>
                            </div>
                            <div>
                                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                    <template v-for="(link, index) in entrevistas.links" :key="index">
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
                                                index === entrevistas.links.length - 1 ? 'rounded-r-md' : ''
                                            ]"
                                        />
                                        <span
                                            v-else
                                            v-html="link.label"
                                            :class="[
                                                'relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-300',
                                                index === 0 ? 'rounded-l-md' : '',
                                                index === entrevistas.links.length - 1 ? 'rounded-r-md' : ''
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

        <!-- Modal de Entrevista -->
        <Modal
            :show="showModal"
            :title="modalTitle"
            subtitle="Preencha os dados abaixo para registrar um novo processo."
            @update:show="showModal = $event"
            @close="closeModal"
        >
            <FormEntrevista
                :entrevista="selectedEntrevista"
                @cancel="closeModal"
                @saved="handleSaved"
            />
        </Modal>
    </Layout>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import Layout from '@/Layouts/Layout.vue';
import Modal from '@/Components/Modal.vue';
import FormEntrevista from '@/Components/FormEntrevista.vue';

// Expor a função route para uso no template e script
const route = window.route;

const props = defineProps({
    entrevistas: Object,
    filters: Object,
});

const filters = ref({
    plataforma: props.filters?.plataforma || '',
    status: props.filters?.status || '',
    entrevistado: props.filters?.entrevistado || '',
});

const applyFilters = () => {
    router.get(route('dashboard'), filters.value, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    filters.value = {
        plataforma: '',
        status: '',
        entrevistado: '',
    };
    applyFilters();
};

const formatStatus = (status) => {
    const statusMap = {
        aplicado: 'Aplicado',
        entrevista_rh: 'Entrevista RH',
        entrevista_tecnica: 'Entrevista Técnica',
        entrevista_cultural: 'Entrevista Cultural',
        oferta: 'Oferta',
        concluido: 'Concluído',
    };
    return statusMap[status] || status;
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    
    // Se já está em formato dd/mm/yyyy, retornar como está
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateString)) {
        return dateString;
    }
    
    // Se está em formato YYYY-MM-DD
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        const [year, month, day] = dateString.split('-');
        return `${day}/${month}/${year}`;
    }
    
    // Tentar parsear como Date
    const date = new Date(dateString);
    if (!isNaN(date.getTime())) {
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
    }
    
    // Se não conseguir formatar, retornar como está
    return dateString;
};

const getStatusClass = (status) => {
    const classes = {
        aplicado: 'bg-blue-100 text-blue-800',
        entrevista_rh: 'bg-yellow-100 text-yellow-800',
        entrevista_tecnica: 'bg-orange-100 text-orange-800',
        entrevista_cultural: 'bg-purple-100 text-purple-800',
        oferta: 'bg-green-100 text-green-800',
        concluido: 'bg-gray-100 text-gray-800',
    };
    return classes[status] || 'bg-gray-100 text-gray-800';
};

// Modal state
const showModal = ref(false);
const selectedEntrevista = ref(null);

const modalTitle = computed(() => {
    return selectedEntrevista.value ? 'Editar Entrevista' : 'Nova Entrevista';
});

const openCreateModal = () => {
    selectedEntrevista.value = null;
    showModal.value = true;
};

const openEditModal = (id) => {
    // Buscar da lista atual de entrevistas
    const entrevista = props.entrevistas.data?.find(e => e.id === id);
    if (entrevista) {
        selectedEntrevista.value = { ...entrevista };
        showModal.value = true;
    }
};

const closeModal = () => {
    showModal.value = false;
    selectedEntrevista.value = null;
};

const handleSaved = () => {
    closeModal();
    // Recarregar a página para atualizar os dados
    router.reload({ only: ['entrevistas'] });
};
</script>

