<template>
    <Layout>
        <div class="container mx-auto px-4 py-8 max-w-4xl">
            <h1 class="text-2xl font-bold mb-6">
                {{ entrevista ? 'Editar Entrevista' : 'Nova Entrevista' }}
            </h1>

            <form @submit.prevent="submit" class="bg-white rounded-lg shadow p-6">
                <div class="space-y-6">
                    <!-- Entrevistado -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Entrevistado <span class="text-red-500">*</span>
                        </label>
                        <select
                            v-model="form.entrevistado_id"
                            :class="{
                                'border-red-500': errors.entrevistado_id,
                            }"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        >
                            <option value="">Selecione...</option>
                            <option v-for="entrevistado in entrevistados" :key="entrevistado.id" :value="entrevistado.id">
                                {{ entrevistado.nome }}
                            </option>
                        </select>
                        <p v-if="errors.entrevistado_id" class="mt-1 text-sm text-red-600">
                            {{ errors.entrevistado_id }}
                        </p>
                    </div>

                    <!-- Data Cadastro Vaga -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Data de Cadastro na Vaga <span class="text-red-500">*</span>
                        </label>
                        <input
                            v-model="form.data_cadastro_vaga"
                            type="text"
                            :class="{
                                'border-red-500': errors.data_cadastro_vaga,
                            }"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Ex: 2024-01-15"
                        />
                        <p v-if="errors.data_cadastro_vaga" class="mt-1 text-sm text-red-600">
                            {{ errors.data_cadastro_vaga }}
                        </p>
                    </div>

                    <!-- Link da Vaga -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Link da Vaga <span class="text-red-500">*</span>
                        </label>
                        <input
                            v-model="form.link_vaga"
                            type="url"
                            @blur="extractPlataforma"
                            :class="{
                                'border-red-500': errors.link_vaga,
                            }"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="https://..."
                        />
                        <p v-if="errors.link_vaga" class="mt-1 text-sm text-red-600">
                            {{ errors.link_vaga }}
                        </p>
                    </div>

                    <!-- Plataforma -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Plataforma
                        </label>
                        <input
                            v-model="form.plataforma"
                            type="text"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Será extraída automaticamente da URL"
                        />
                        <p class="mt-1 text-xs text-gray-500">
                            A plataforma será extraída automaticamente ao preencher o link da vaga.
                        </p>
                    </div>

                    <!-- Data Resposta -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Data da Resposta
                        </label>
                        <input
                            v-model="form.data_resposta"
                            type="date"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        />
                        <p v-if="errors.data_resposta" class="mt-1 text-sm text-red-600">
                            {{ errors.data_resposta }}
                        </p>
                    </div>

                    <!-- Resposta -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Resposta
                        </label>
                        <textarea
                            v-model="form.resposta"
                            rows="4"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Texto da resposta recebida..."
                        ></textarea>
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Status <span class="text-red-500">*</span>
                        </label>
                        <select
                            v-model="form.status"
                            :class="{
                                'border-red-500': errors.status,
                            }"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                        >
                            <option value="">Selecione...</option>
                            <option value="aplicado">Aplicado</option>
                            <option value="entrevista_rh">Entrevista RH</option>
                            <option value="entrevista_tecnica">Entrevista Técnica</option>
                            <option value="entrevista_cultural">Entrevista Cultural</option>
                            <option value="oferta">Oferta</option>
                            <option value="concluido">Concluído</option>
                        </select>
                        <p v-if="errors.status" class="mt-1 text-sm text-red-600">
                            {{ errors.status }}
                        </p>
                    </div>

                    <!-- Dados Desafio Técnico -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Dados do Desafio Técnico
                        </label>
                        <textarea
                            v-model="form.dados_desafio_tecnico"
                            rows="4"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Informações sobre o desafio técnico..."
                        ></textarea>
                    </div>

                    <!-- Responsável Processo -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Nome da Pessoa Conduzindo o Processo
                        </label>
                        <input
                            v-model="form.responsavel_processo"
                            type="text"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Nome do responsável"
                        />
                    </div>

                    <!-- Salário Combinado -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Salário Combinado
                        </label>
                        <input
                            v-model="form.salario_combinado"
                            type="text"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Ex: R$ 8.000,00"
                        />
                    </div>
                </div>

                <!-- Botões -->
                <div class="mt-6 flex justify-end space-x-4">
                    <Link
                        :href="route('dashboard')"
                        class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
                    >
                        Cancelar
                    </Link>
                    <button
                        type="submit"
                        :disabled="processing"
                        class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 disabled:opacity-50"
                    >
                        {{ processing ? 'Salvando...' : 'Salvar' }}
                    </button>
                </div>
            </form>
        </div>
    </Layout>
</template>

<script setup>
import { reactive } from 'vue';
import { useForm, Link } from '@inertiajs/vue3';
import Layout from '@/Layouts/Layout.vue';
import axios from 'axios';

// Expor a função route para uso no template e script
const route = window.route;

const props = defineProps({
    entrevista: Object,
    entrevistados: Array,
    errors: Object,
});

const form = useForm({
    entrevistado_id: props.entrevista?.entrevistado_id || '',
    data_cadastro_vaga: props.entrevista?.data_cadastro_vaga || '',
    link_vaga: props.entrevista?.link_vaga || '',
    nome_empresa: props.entrevista?.nome_empresa || '',
    plataforma: props.entrevista?.plataforma || '',
    data_resposta: props.entrevista?.data_resposta || '',
    resposta: props.entrevista?.resposta || '',
    status: props.entrevista?.status || '',
    dados_desafio_tecnico: props.entrevista?.dados_desafio_tecnico || '',
    responsavel_processo: props.entrevista?.responsavel_processo || '',
    salario_combinado: props.entrevista?.salario_combinado || '',
});

const extractPlataforma = () => {
    // A extração será feita automaticamente no backend ao salvar
    // Esta função pode ser usada para validação visual se necessário
};

const submit = () => {
    if (props.entrevista) {
        form.put(route('entrevistas.update', props.entrevista.id));
    } else {
        form.post(route('entrevistas.store'));
    }
};

const processing = form.processing;
const errors = props.errors || {};
</script>

