<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreEntrevistadoRequest;
use App\Http\Requests\UpdateEntrevistadoRequest;
use App\Models\Entrevistado;
use Illuminate\Http\Request;
use Inertia\Inertia;

class EntrevistadoController extends Controller
{
    public function index()
    {
        $entrevistados = Entrevistado::orderBy('nome')->paginate(15);

        return Inertia::render('Entrevistado/Index', [
            'entrevistados' => $entrevistados,
        ]);
    }

    public function create()
    {
        return Inertia::render('Entrevistado/Form');
    }

    public function store(StoreEntrevistadoRequest $request)
    {
        Entrevistado::create($request->validated());

        return redirect()->route('entrevistados.index')
            ->with('success', 'Entrevistado criado com sucesso!');
    }

    public function edit(Entrevistado $entrevistado)
    {
        return Inertia::render('Entrevistado/Form', [
            'entrevistado' => $entrevistado,
        ]);
    }

    public function update(UpdateEntrevistadoRequest $request, Entrevistado $entrevistado)
    {
        $entrevistado->update($request->validated());

        return redirect()->route('entrevistados.index')
            ->with('success', 'Entrevistado atualizado com sucesso!');
    }

    public function destroy(Entrevistado $entrevistado)
    {
        // Verificar se há entrevistas associadas
        if ($entrevistado->entrevistas()->count() > 0) {
            return redirect()->route('entrevistados.index')
                ->with('error', 'Não é possível excluir o entrevistado pois existem entrevistas associadas.');
        }

        $entrevistado->delete();

        return redirect()->route('entrevistados.index')
            ->with('success', 'Entrevistado excluído com sucesso!');
    }
}

