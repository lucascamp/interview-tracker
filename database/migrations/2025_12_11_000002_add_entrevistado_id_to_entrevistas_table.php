<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Primeiro, criar os entrevistados Lucas e Thais se não existirem
        DB::statement("INSERT IGNORE INTO entrevistados (nome, created_at, updated_at) VALUES ('Lucas', NOW(), NOW())");
        DB::statement("INSERT IGNORE INTO entrevistados (nome, created_at, updated_at) VALUES ('Thais', NOW(), NOW())");

        // Adicionar a coluna entrevistado_id sem constraint inicialmente
        Schema::table('entrevistas', function (Blueprint $table) {
            $table->unsignedBigInteger('entrevistado_id')->nullable()->after('id');
        });

        // Atualizar as entrevistas existentes com os IDs corretos
        DB::statement("
            UPDATE entrevistas e
            JOIN entrevistados en ON en.nome = e.entrevistado
            SET e.entrevistado_id = en.id
            WHERE e.entrevistado IS NOT NULL
        ");

        // Remover a coluna antiga
        Schema::table('entrevistas', function (Blueprint $table) {
            $table->dropColumn('entrevistado');
        });

        // Agora adicionar a foreign key constraint
        Schema::table('entrevistas', function (Blueprint $table) {
            $table->foreign('entrevistado_id')->references('id')->on('entrevistados')->onDelete('restrict');
        });
    }

    public function down(): void
    {
        // Remover a foreign key primeiro
        Schema::table('entrevistas', function (Blueprint $table) {
            $table->dropForeign(['entrevistado_id']);
        });

        Schema::table('entrevistas', function (Blueprint $table) {
            // Adicionar a coluna antiga de volta
            $table->enum('entrevistado', ['Lucas', 'Thais'])->after('id');
        });

        // Migrar dados de volta
        DB::statement("
            UPDATE entrevistas e
            JOIN entrevistados en ON en.id = e.entrevistado_id
            SET e.entrevistado = en.nome
            WHERE e.entrevistado_id IS NOT NULL
        ");

        Schema::table('entrevistas', function (Blueprint $table) {
            $table->dropColumn('entrevistado_id');
        });
    }
};

