<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('entrevistas', function (Blueprint $table) {
            $table->id();
            $table->enum('entrevistado', ['Lucas', 'Thais']);
            $table->string('data_cadastro_vaga');
            $table->string('link_vaga', 500);
            $table->string('plataforma', 100)->nullable();
            $table->date('data_resposta')->nullable();
            $table->text('resposta')->nullable();
            $table->enum('status', [
                'aplicado',
                'entrevista_rh',
                'entrevista_tecnica',
                'entrevista_cultural',
                'oferta',
                'concluido'
            ]);
            $table->text('dados_desafio_tecnico')->nullable();
            $table->string('responsavel_processo')->nullable();
            $table->string('salario_combinado', 100)->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('entrevistas');
    }
};

