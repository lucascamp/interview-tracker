<?php

namespace App\Services;

class PlataformaService
{
    public static function extrairPlataforma(string $url): ?string
    {
        $url = strtolower($url);
        
        $plataformas = [
            'linkedin' => ['linkedin.com'],
            'indeed' => ['indeed.com', 'indeed.com.br'],
            'gupy' => ['gupy.io', 'gupy.com.br'],
            'kenoby' => ['kenoby.com', 'kenoby.com.br'],
        ];

        foreach ($plataformas as $plataforma => $dominios) {
            foreach ($dominios as $dominio) {
                if (str_contains($url, $dominio)) {
                    return $plataforma;
                }
            }
        }

        // Se não encontrou nenhuma plataforma conhecida, tenta extrair do domínio
        $parsedUrl = parse_url($url);
        if (isset($parsedUrl['host'])) {
            $host = $parsedUrl['host'];
            // Remove www. se existir
            $host = preg_replace('/^www\./', '', $host);
            // Pega apenas o domínio principal
            $parts = explode('.', $host);
            if (count($parts) >= 2) {
                return $parts[count($parts) - 2];
            }
        }

        return null;
    }
}

