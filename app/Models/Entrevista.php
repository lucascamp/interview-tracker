<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Entrevista extends Model
{
    use HasFactory;

    protected $fillable = [
        'entrevistado',
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

    public static function getEntrevistados(): array
    {
        return ['Lucas', 'Thais'];
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

