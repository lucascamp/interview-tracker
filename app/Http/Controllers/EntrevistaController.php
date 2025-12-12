<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreEntrevistaRequest;
use App\Http\Requests\UpdateEntrevistaRequest;
use App\Http\Resources\EntrevistaResource;
use App\Models\Entrevista;
use App\Models\Entrevistado;
use App\Services\PlataformaService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class EntrevistaController extends Controller
{
    public function index(Request $request)
    {
        $query = Entrevista::with('entrevistado');

        // Filtros
        if ($request->filled('plataforma')) {
            $query->where('plataforma', $request->plataforma);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('entrevistado_id')) {
            $query->where('entrevistado_id', $request->entrevistado_id);
        }

        $entrevistas = $query->latest('created_at')->paginate(10);

        return Inertia::render('Dashboard', [
            'entrevistas' => EntrevistaResource::collection($entrevistas)->response()->getData(true),
            'entrevistados' => Entrevistado::orderBy('nome')->get(),
            'filters' => $request->only(['plataforma', 'status', 'entrevistado_id']),
        ]);
    }

    public function create()
    {
        return Inertia::render('Entrevista/Form', [
            'entrevistados' => Entrevistado::orderBy('nome')->get(),
        ]);
    }

    public function store(StoreEntrevistaRequest $request)
    {
        $data = $request->validated();

        // Extrair plataforma se não foi preenchida
        if (empty($data['plataforma']) && !empty($data['link_vaga'])) {
            $data['plataforma'] = PlataformaService::extrairPlataforma($data['link_vaga']);
        }

        Entrevista::create($data);

        return redirect()->route('dashboard')->with('success', 'Entrevista criada com sucesso!');
    }

    public function edit(Entrevista $entrevista)
    {
        return Inertia::render('Entrevista/Form', [
            'entrevista' => new EntrevistaResource($entrevista->load('entrevistado')),
            'entrevistados' => Entrevistado::orderBy('nome')->get(),
        ]);
    }

    public function update(UpdateEntrevistaRequest $request, Entrevista $entrevista)
    {
        $data = $request->validated();

        // Extrair plataforma se não foi preenchida
        if (empty($data['plataforma']) && !empty($data['link_vaga'])) {
            $data['plataforma'] = PlataformaService::extrairPlataforma($data['link_vaga']);
        }

        $entrevista->update($data);

        return redirect()->route('dashboard')->with('success', 'Entrevista atualizada com sucesso!');
    }

    public function destroy(Entrevista $entrevista)
    {
        $entrevista->delete();

        return redirect()->route('dashboard')->with('success', 'Entrevista excluída com sucesso!');
    }
}

