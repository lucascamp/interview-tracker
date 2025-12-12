<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EntrevistaResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'entrevistado' => $this->entrevistado,
            'data_cadastro_vaga' => $this->data_cadastro_vaga,
            'link_vaga' => $this->link_vaga,
            'nome_empresa' => $this->nome_empresa,
            'plataforma' => $this->plataforma,
            'data_resposta' => $this->data_resposta?->format('Y-m-d'),
            'resposta' => $this->resposta,
            'status' => $this->status,
            'dados_desafio_tecnico' => $this->dados_desafio_tecnico,
            'responsavel_processo' => $this->responsavel_processo,
            'salario_combinado' => $this->salario_combinado,
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}

