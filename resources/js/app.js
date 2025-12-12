import './bootstrap';
import '../css/app.css';

import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

// Helper para rotas (será preenchido via Inertia)
window.route = function(name, params = {}) {
    const ziggy = window.Ziggy || {};
    const routes = ziggy.routes || {};
    const route = routes[name];
    
    if (!route) {
        console.warn(`Route "${name}" not found`);
        return '#';
    }
    
    let url = route.uri;
    
    // Substituir parâmetros
    Object.keys(params).forEach(key => {
        url = url.replace(`{${key}}`, params[key]);
        url = url.replace(`{${key}?}`, params[key]);
    });
    
    // Remover parâmetros opcionais não preenchidos
    url = url.replace(/\/\{[^}]+\?\}/g, '');
    
    return url;
};

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .mount(el);
    },
    progress: {
        color: '#4B5563',
    },
});

