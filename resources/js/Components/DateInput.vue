<template>
    <div class="relative">
        <input
            :id="id"
            ref="inputRef"
            type="text"
            :value="displayValue"
            @input="handleInput"
            @focus="showPicker = true"
            @blur="handleBlur"
            :class="[
                'block w-full text-base border border-gray-200 rounded-lg py-3 px-4 bg-white transition-colors hover:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500',
                error ? 'border-red-500 hover:border-red-400' : '',
            ]"
            :placeholder="placeholder"
            autocomplete="off"
        />
        
        <!-- Date Picker Dropdown -->
        <div
            v-if="showPicker"
            v-click-outside="closePicker"
            class="absolute z-50 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg p-4"
            style="min-width: 300px;"
        >
            <div class="flex justify-between items-center mb-4">
                <button
                    type="button"
                    @click="previousMonth"
                    class="p-1 hover:bg-gray-100 rounded"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                </button>
                <div class="text-sm font-semibold text-gray-700">
                    {{ monthNames[currentMonth] }} {{ currentYear }}
                </div>
                <button
                    type="button"
                    @click="nextMonth"
                    class="p-1 hover:bg-gray-100 rounded"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                </button>
            </div>
            
            <div class="grid grid-cols-7 gap-1 mb-2">
                <div
                    v-for="day in weekDays"
                    :key="day"
                    class="text-xs text-center text-gray-500 font-medium py-1"
                >
                    {{ day }}
                </div>
            </div>
            
            <div class="grid grid-cols-7 gap-1">
                <div
                    v-for="day in calendarDays"
                    :key="day.key"
                    @click="selectDate(day.date)"
                    :class="[
                        'text-center py-2 rounded cursor-pointer text-sm',
                        day.isCurrentMonth
                            ? day.isSelected
                                ? 'bg-sky-600 text-white'
                                : day.isToday
                                ? 'bg-sky-100 text-sky-700 font-semibold'
                                : 'text-gray-700 hover:bg-gray-100'
                            : 'text-gray-300',
                    ]"
                >
                    {{ day.day }}
                </div>
            </div>
            
            <div class="mt-4 flex justify-end gap-2">
                <button
                    type="button"
                    @click="selectToday"
                    class="px-3 py-1 text-xs bg-gray-100 text-gray-700 rounded hover:bg-gray-200"
                >
                    Hoje
                </button>
                <button
                    type="button"
                    @click="clearDate"
                    class="px-3 py-1 text-xs bg-gray-100 text-gray-700 rounded hover:bg-gray-200"
                >
                    Limpar
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';

const props = defineProps({
    modelValue: {
        type: String,
        default: '',
    },
    id: {
        type: String,
        default: '',
    },
    placeholder: {
        type: String,
        default: 'dd/mm/aaaa',
    },
    error: {
        type: Boolean,
        default: false,
    },
});

const emit = defineEmits(['update:modelValue']);

const inputRef = ref(null);
const showPicker = ref(false);
const currentDate = ref(new Date());
const selectedDate = ref(null);

const monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
];

const weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

const currentYear = computed(() => currentDate.value.getFullYear());
const currentMonth = computed(() => currentDate.value.getMonth());

// Converter YYYY-MM-DD para Date
const parseDate = (dateString) => {
    if (!dateString) return null;
    
    // Se já está em formato YYYY-MM-DD
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        const [year, month, day] = dateString.split('-').map(Number);
        return new Date(year, month - 1, day);
    }
    
    // Se está em formato DD/MM/YYYY
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateString)) {
        const [day, month, year] = dateString.split('/').map(Number);
        return new Date(year, month - 1, day);
    }
    
    return null;
};

// Converter Date para YYYY-MM-DD
const formatDateForInput = (date) => {
    if (!date) return '';
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
};

// Converter Date para DD/MM/YYYY (exibição)
const formatDateForDisplay = (date) => {
    if (!date) return '';
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
};

const displayValue = computed(() => {
    if (selectedDate.value) {
        return formatDateForDisplay(selectedDate.value);
    }
    return '';
});

// Calcular dias do calendário
const calendarDays = computed(() => {
    const year = currentYear.value;
    const month = currentMonth.value;
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    const daysInMonth = lastDay.getDate();
    const startingDayOfWeek = firstDay.getDay();
    
    const days = [];
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    // Dias do mês anterior
    const prevMonth = new Date(year, month, 0);
    const daysInPrevMonth = prevMonth.getDate();
    for (let i = startingDayOfWeek - 1; i >= 0; i--) {
        const date = new Date(year, month - 1, daysInPrevMonth - i);
        days.push({
            day: daysInPrevMonth - i,
            date: new Date(date),
            isCurrentMonth: false,
            isSelected: selectedDate.value && isSameDay(date, selectedDate.value),
            isToday: isSameDay(date, today),
            key: `prev-${i}`,
        });
    }
    
    // Dias do mês atual
    for (let day = 1; day <= daysInMonth; day++) {
        const date = new Date(year, month, day);
        days.push({
            day,
            date: new Date(date),
            isCurrentMonth: true,
            isSelected: selectedDate.value && isSameDay(date, selectedDate.value),
            isToday: isSameDay(date, today),
            key: `current-${day}`,
        });
    }
    
    // Dias do próximo mês para completar a grade
    const remainingDays = 42 - days.length; // 6 semanas * 7 dias
    for (let day = 1; day <= remainingDays; day++) {
        const date = new Date(year, month + 1, day);
        days.push({
            day,
            date: new Date(date),
            isCurrentMonth: false,
            isSelected: selectedDate.value && isSameDay(date, selectedDate.value),
            isToday: isSameDay(date, today),
            key: `next-${day}`,
        });
    }
    
    return days;
});

const isSameDay = (date1, date2) => {
    if (!date1 || !date2) return false;
    return (
        date1.getFullYear() === date2.getFullYear() &&
        date1.getMonth() === date2.getMonth() &&
        date1.getDate() === date2.getDate()
    );
};

const selectDate = (date) => {
    selectedDate.value = new Date(date);
    emit('update:modelValue', formatDateForInput(selectedDate.value));
    showPicker.value = false;
};

const selectToday = () => {
    const today = new Date();
    selectDate(today);
};

const clearDate = () => {
    selectedDate.value = null;
    emit('update:modelValue', '');
    showPicker.value = false;
};

const previousMonth = () => {
    currentDate.value = new Date(currentYear.value, currentMonth.value - 1, 1);
};

const nextMonth = () => {
    currentDate.value = new Date(currentYear.value, currentMonth.value + 1, 1);
};

const handleInput = (event) => {
    const value = event.target.value;
    
    // Permitir apenas números e barras
    const cleaned = value.replace(/[^\d/]/g, '');
    
    // Formatação automática enquanto digita
    let formatted = cleaned;
    if (cleaned.length > 2 && !cleaned.includes('/')) {
        formatted = cleaned.slice(0, 2) + '/' + cleaned.slice(2);
    }
    if (formatted.length > 5 && formatted.split('/').length === 2) {
        formatted = formatted.slice(0, 5) + '/' + formatted.slice(5, 9);
    }
    
    // Validar e converter
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(formatted)) {
        const date = parseDate(formatted);
        if (date && !isNaN(date.getTime())) {
            selectedDate.value = date;
            emit('update:modelValue', formatDateForInput(date));
        }
    }
};

const handleBlur = () => {
    // Delay para permitir cliques no datepicker
    setTimeout(() => {
        showPicker.value = false;
    }, 200);
};

const closePicker = () => {
    showPicker.value = false;
};

// Diretiva para detectar cliques fora
const vClickOutside = {
    mounted(el, binding) {
        el.clickOutsideEvent = (event) => {
            if (!(el === event.target || el.contains(event.target))) {
                binding.value();
            }
        };
        document.addEventListener('click', el.clickOutsideEvent);
    },
    unmounted(el) {
        document.removeEventListener('click', el.clickOutsideEvent);
    },
};

// Inicializar com valor do modelValue
watch(() => props.modelValue, (newValue) => {
    if (newValue) {
        const date = parseDate(newValue);
        if (date && !isNaN(date.getTime())) {
            selectedDate.value = date;
            currentDate.value = new Date(date);
        }
    } else {
        selectedDate.value = null;
    }
}, { immediate: true });

onMounted(() => {
    if (props.modelValue) {
        const date = parseDate(props.modelValue);
        if (date && !isNaN(date.getTime())) {
            selectedDate.value = date;
            currentDate.value = new Date(date);
        }
    }
});
</script>

