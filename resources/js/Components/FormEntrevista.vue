<template>
    <form @submit.prevent="submit" class="space-y-8">
        <div class="grid grid-cols-1 gap-y-6 gap-x-6 sm:grid-cols-6">
            <!-- Entrevistado -->
            <div class="sm:col-span-4">
                <label for="entrevistado" class="block text-sm font-medium text-gray-700">
                    Entrevistado <span class="text-red-500">*</span>
                </label>
                <div class="mt-1">
                    <select
                        id="entrevistado"
                        v-model="form.entrevistado"
                        :class="{
                            'border-red-500': form.errors.entrevistado,
                        }"
                        class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                    >
                        <option value="">Selecione um candidato...</option>
                        <option value="Lucas">Lucas</option>
                        <option value="Thais">Thais</option>
                    </select>
                </div>
                <p v-if="form.errors.entrevistado" class="mt-1 text-sm text-red-600">
                    {{ form.errors.entrevistado }}
                </p>
            </div>

            <!-- Data de Cadastro -->
            <div class="sm:col-span-2">
                <label for="data_cadastro_vaga" class="block text-sm font-medium text-gray-700">
                    Data de Cadastro <span class="text-red-500">*</span>
                </label>
                <div class="mt-1">
                    <DateInput
                        id="data_cadastro_vaga"
                        v-model="form.data_cadastro_vaga"
                        :error="!!form.errors.data_cadastro_vaga"
                        placeholder="dd/mm/aaaa"
                    />
                </div>
                <p v-if="form.errors.data_cadastro_vaga" class="mt-1 text-sm text-red-600">
                    {{ form.errors.data_cadastro_vaga }}
                </p>
            </div>

            <!-- Link da Vaga -->
            <div class="sm:col-span-3">
                <label for="link_vaga" class="block text-sm font-medium text-gray-700">
                    Link da Vaga <span class="text-red-500">*</span>
                </label>
                <div class="mt-1">
                    <input
                        type="url"
                        id="link_vaga"
                        v-model="form.link_vaga"
                        @blur="extractPlataforma"
                        :class="{
                            'border-red-500': form.errors.link_vaga,
                        }"
                        class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                        placeholder="https://..."
                    />
                </div>
                <p v-if="form.errors.link_vaga" class="mt-1 text-sm text-red-600">
                    {{ form.errors.link_vaga }}
                </p>
            </div>

            <!-- Nome da Empresa -->
            <div class="sm:col-span-3">
                <label for="nome_empresa" class="block text-sm font-medium text-gray-700">
                    Nome da Empresa
                </label>
                <div class="mt-1">
                    <input
                        type="text"
                        id="nome_empresa"
                        v-model="form.nome_empresa"
                        class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                        placeholder="Nome da empresa"
                    />
                </div>
                <p v-if="form.errors.nome_empresa" class="mt-1 text-sm text-red-600">
                    {{ form.errors.nome_empresa }}
                </p>
            </div>

            <!-- Plataforma -->
            <div class="sm:col-span-2">
                <label for="plataforma" class="block text-sm font-medium text-gray-700">
                    Plataforma
                </label>
                <div class="mt-1">
                    <input
                        type="text"
                        id="plataforma"
                        v-model="form.plataforma"
                        disabled
                        placeholder="Automático pela URL"
                        class="bg-gray-100 text-gray-500 cursor-not-allowed block w-full text-base border border-gray-200 rounded-lg py-3 px-4 select-none"
                    />
                    <p class="mt-1 text-xs text-gray-400">Extraído automaticamente.</p>
                </div>
            </div>
        </div>

        <div class="border-t border-gray-200"></div>

        <div class="grid grid-cols-1 gap-y-6 gap-x-6 sm:grid-cols-6">
            <!-- Status -->
            <div class="sm:col-span-2">
                <label for="status" class="block text-sm font-medium text-gray-700">
                    Status <span class="text-red-500">*</span>
                </label>
                <select
                    id="status"
                    v-model="form.status"
                    :class="{
                        'border-red-500 hover:border-red-400': form.errors.status,
                    }"
                    class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                >
                    <option value="">Selecione...</option>
                    <option value="aplicado">Aplicado</option>
                    <option value="entrevista_rh">Entrevista RH</option>
                    <option value="entrevista_tecnica">Entrevista Técnica</option>
                    <option value="entrevista_cultural">Entrevista Cultural</option>
                    <option value="oferta">Oferta</option>
                    <option value="concluido">Concluído</option>
                </select>
                <p v-if="form.errors.status" class="mt-1 text-sm text-red-600">
                    {{ form.errors.status }}
                </p>
            </div>

            <!-- Data da Resposta -->
            <div class="sm:col-span-2">
                <label for="data_resposta" class="block text-sm font-medium text-gray-700">
                    Data da Resposta
                </label>
                <div class="mt-1">
                    <DateInput
                        id="data_resposta"
                        v-model="form.data_resposta"
                        :error="!!form.errors.data_resposta"
                        placeholder="dd/mm/aaaa"
                    />
                </div>
                <p v-if="form.errors.data_resposta" class="mt-1 text-sm text-red-600">
                    {{ form.errors.data_resposta }}
                </p>
            </div>

            <!-- Responsável Processo -->
            <div class="sm:col-span-2">
                <label for="responsavel_processo" class="block text-sm font-medium text-gray-700">
                    Recrutador(a)
                </label>
                <input
                    type="text"
                    id="responsavel_processo"
                    v-model="form.responsavel_processo"
                    placeholder="Nome do responsável"
                    class="mt-1 focus:ring-sky-500 focus:border-sky-500 block w-full sm:text-sm border-gray-300 rounded-md py-2.5 px-3 border"
                />
            </div>

            <!-- Feedback / Resposta -->
            <div class="sm:col-span-6">
                <label for="resposta" class="block text-sm font-medium text-gray-700">
                    Feedback / Resposta
                </label>
                <div class="mt-1">
                    <textarea
                        id="resposta"
                        v-model="form.resposta"
                        rows="3"
                        class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 resize-none"
                        placeholder="Insira o texto da resposta recebida..."
                    ></textarea>
                </div>
            </div>

            <!-- Dados do Desafio Técnico -->
            <div class="sm:col-span-6">
                <label for="dados_desafio_tecnico" class="block text-sm font-medium text-gray-700">
                    Dados do Desafio Técnico
                </label>
                <div class="mt-1">
                    <textarea
                        id="dados_desafio_tecnico"
                        v-model="form.dados_desafio_tecnico"
                        rows="3"
                        class="block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 resize-none"
                        placeholder="Informações sobre o desafio..."
                    ></textarea>
                </div>
            </div>

            <!-- Salário Combinado -->
            <div class="sm:col-span-3">
                <label for="salario_combinado" class="block text-sm font-medium text-gray-700">
                    Salário Combinado
                </label>
                <input
                    type="text"
                    id="salario_combinado"
                    v-model="form.salario_combinado"
                    placeholder="Ex: R$ 8.000,00"
                    class="mt-1 focus:ring-sky-500 focus:border-sky-500 block w-full sm:text-sm border-gray-300 rounded-md py-2.5 px-3 border"
                />
            </div>
        </div>

        <!-- Botões -->
        <div class="pt-5 flex justify-end gap-3">
            <button
                type="button"
                @click="$emit('cancel')"
                class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sky-500"
            >
                Cancelar
            </button>
            <button
                type="submit"
                :disabled="processing"
                class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-sky-600 hover:bg-sky-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sky-500 disabled:opacity-50"
            >
                {{ processing ? 'Salvando...' : 'Salvar Entrevista' }}
            </button>
        </div>
    </form>
</template>

<script setup>
import { useForm } from '@inertiajs/vue3';
import { watch } from 'vue';
import DateInput from '@/Components/DateInput.vue';

const props = defineProps({
    entrevista: {
        type: Object,
        default: null,
    },
});

const emit = defineEmits(['cancel', 'saved']);

const form = useForm({
    entrevistado: props.entrevista?.entrevistado || '',
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

// Atualizar form quando entrevista mudar
watch(() => props.entrevista, (newEntrevista) => {
    if (newEntrevista) {
        form.entrevistado = newEntrevista.entrevistado || '';
        form.data_cadastro_vaga = newEntrevista.data_cadastro_vaga || '';
        form.link_vaga = newEntrevista.link_vaga || '';
        form.nome_empresa = newEntrevista.nome_empresa || '';
        form.plataforma = newEntrevista.plataforma || '';
        form.data_resposta = newEntrevista.data_resposta || '';
        form.resposta = newEntrevista.resposta || '';
        form.status = newEntrevista.status || '';
        form.dados_desafio_tecnico = newEntrevista.dados_desafio_tecnico || '';
        form.responsavel_processo = newEntrevista.responsavel_processo || '';
        form.salario_combinado = newEntrevista.salario_combinado || '';
    } else {
        form.reset();
    }
}, { deep: true, immediate: true });

const extractPlataforma = () => {
    // A extração será feita automaticamente no backend ao salvar
};

const route = window.route;

const submit = () => {
    if (props.entrevista?.id) {
        form.put(route('entrevistas.update', { entrevista: props.entrevista.id }), {
            onSuccess: () => {
                emit('saved');
            },
        });
    } else {
        form.post(route('entrevistas.store'), {
            onSuccess: () => {
                emit('saved');
            },
        });
    }
};

const processing = form.processing;
</script>

