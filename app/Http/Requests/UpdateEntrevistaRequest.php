<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEntrevistaRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'entrevistado_id' => 'required|exists:entrevistados,id',
            'data_cadastro_vaga' => 'required|string|max:255',
            'link_vaga' => 'required|url|max:500',
            'nome_empresa' => 'nullable|string|max:255',
            'plataforma' => 'nullable|string|max:100',
            'data_resposta' => 'nullable|date',
            'resposta' => 'nullable|string',
            'status' => 'required|in:aplicado,entrevista_rh,entrevista_tecnica,entrevista_cultural,oferta,concluido',
            'dados_desafio_tecnico' => 'nullable|string',
            'responsavel_processo' => 'nullable|string|max:255',
            'salario_combinado' => 'nullable|string|max:100',
        ];
    }

    public function messages(): array
    {
        return [
            'entrevistado_id.required' => 'O campo entrevistado é obrigatório.',
            'entrevistado_id.exists' => 'O entrevistado selecionado é inválido.',
            'data_cadastro_vaga.required' => 'A data de cadastro na vaga é obrigatória.',
            'link_vaga.required' => 'O link da vaga é obrigatório.',
            'link_vaga.url' => 'O link da vaga deve ser uma URL válida.',
            'status.required' => 'O status é obrigatório.',
            'status.in' => 'O status selecionado é inválido.',
        ];
    }
}

