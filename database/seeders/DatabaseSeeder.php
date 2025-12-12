<?php

namespace Database\Seeders;

use App\Models\Entrevista;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $entrevistas = [
            [
                'entrevistado' => 'Lucas',
                'data_cadastro_vaga' => '2024-01-15',
                'link_vaga' => 'https://www.linkedin.com/jobs/view/123456',
                'plataforma' => 'linkedin',
                'data_resposta' => '2024-01-20',
                'resposta' => 'Olá! Gostaríamos de agendar uma entrevista inicial.',
                'status' => 'entrevista_rh',
                'dados_desafio_tecnico' => null,
                'responsavel_processo' => 'Maria Silva',
                'salario_combinado' => null,
            ],
            [
                'entrevistado' => 'Lucas',
                'data_cadastro_vaga' => '2024-01-10',
                'link_vaga' => 'https://www.indeed.com.br/viewjob?jk=789012',
                'plataforma' => 'indeed',
                'data_resposta' => '2024-01-18',
                'resposta' => 'Agradecemos seu interesse. Infelizmente não seguiremos com seu perfil.',
                'status' => 'concluido',
                'dados_desafio_tecnico' => null,
                'responsavel_processo' => 'João Santos',
                'salario_combinado' => null,
            ],
            [
                'entrevistado' => 'Thais',
                'data_cadastro_vaga' => '2024-01-12',
                'link_vaga' => 'https://empresa.gupy.io/jobs/456789',
                'plataforma' => 'gupy',
                'data_resposta' => '2024-01-19',
                'resposta' => 'Parabéns! Você passou para a próxima etapa.',
                'status' => 'entrevista_tecnica',
                'dados_desafio_tecnico' => 'Desafio: Criar uma API REST com Laravel. Prazo: 7 dias.',
                'responsavel_processo' => 'Ana Costa',
                'salario_combinado' => null,
            ],
            [
                'entrevistado' => 'Thais',
                'data_cadastro_vaga' => '2024-01-08',
                'link_vaga' => 'https://empresa.kenoby.com/vaga/321654',
                'plataforma' => 'kenoby',
                'data_resposta' => '2024-01-22',
                'resposta' => 'Gostaríamos de fazer uma proposta.',
                'status' => 'oferta',
                'dados_desafio_tecnico' => null,
                'responsavel_processo' => 'Pedro Oliveira',
                'salario_combinado' => 'R$ 8.000,00',
            ],
            [
                'entrevistado' => 'Lucas',
                'data_cadastro_vaga' => '2024-01-20',
                'link_vaga' => 'https://www.linkedin.com/jobs/view/987654',
                'plataforma' => 'linkedin',
                'data_resposta' => null,
                'resposta' => null,
                'status' => 'aplicado',
                'dados_desafio_tecnico' => null,
                'responsavel_processo' => null,
                'salario_combinado' => null,
            ],
        ];

        foreach ($entrevistas as $entrevista) {
            Entrevista::create($entrevista);
        }
    }
}

