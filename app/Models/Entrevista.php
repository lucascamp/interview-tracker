<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Entrevista extends Model
{
    use HasFactory;

    protected $fillable = [
        'entrevistado_id',
        'data_cadastro_vaga',
        'link_vaga',
        'nome_empresa',
        'plataforma',
        'data_resposta',
        'resposta',
        'status',
        'dados_desafio_tecnico',
        'responsavel_processo',
        'salario_combinado',
    ];

    protected $casts = [
        'data_resposta' => 'date',
    ];

    public function entrevistado(): BelongsTo
    {
        return $this->belongsTo(Entrevistado::class);
    }

    public static function getStatus(): array
    {
        return [
            'aplicado',
            'entrevista_rh',
            'entrevista_tecnica',
            'entrevista_cultural',
            'oferta',
            'concluido',
        ];
    }
}

