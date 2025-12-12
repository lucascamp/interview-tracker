<template>
    <Layout>
        <div class="container mx-auto px-4 py-8 max-w-2xl">
            <h1 class="text-2xl font-bold mb-6">
                {{ entrevistado ? 'Editar Entrevistado' : 'Novo Entrevistado' }}
            </h1>

            <form @submit.prevent="submit" class="bg-white rounded-lg shadow p-6">
                <div class="space-y-6">
                    <!-- Nome -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Nome <span class="text-red-500">*</span>
                        </label>
                        <input
                            v-model="form.nome"
                            type="text"
                            :class="{
                                'border-red-500': errors.nome,
                            }"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                            placeholder="Nome do entrevistado"
                        />
                        <p v-if="errors.nome" class="mt-1 text-sm text-red-600">
                            {{ errors.nome }}
                        </p>
                    </div>
                </div>

                <!-- Botões -->
                <div class="mt-6 flex justify-end space-x-4">
                    <Link
                        :href="route('entrevistados.index')"
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
import { useForm, Link } from '@inertiajs/vue3';
import Layout from '@/Layouts/Layout.vue';

const route = window.route;

const props = defineProps({
    entrevistado: Object,
    errors: Object,
});

const form = useForm({
    nome: props.entrevistado?.nome || '',
});

const submit = () => {
    if (props.entrevistado) {
        form.put(route('entrevistados.update', props.entrevistado.id));
    } else {
        form.post(route('entrevistados.store'));
    }
};

const processing = form.processing;
const errors = props.errors || {};
</script>

