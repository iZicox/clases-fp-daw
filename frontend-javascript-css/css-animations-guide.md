# Guía Completa de Animaciones y Keyframes en CSS

## Índice
1. Introducción a las Animaciones CSS
2. Fundamentos de @keyframes
3. Propiedades de animation
4. Ejemplos Prácticos
5. Timing Functions Avanzadas
6. Mejores Prácticas y Optimización

---

## 1. Introducción a las Animaciones CSS

Las animaciones CSS permiten crear transiciones complejas y fluidas entre diferentes estilos sin necesidad de JavaScript. Se componen de dos partes principales:

- **@keyframes**: Define los estados de la animación
- **animation**: Aplica la animación a un elemento

### ¿Por qué usar animaciones CSS?

- **Rendimiento**: Utilizan aceleración por hardware (GPU)
- **Simplicidad**: No requieren librerías adicionales
- **Control**: Permiten pausar, revertir y controlar la animación
- **Responsive**: Se adaptan automáticamente a diferentes dispositivos

---

## 2. Fundamentos de @keyframes

### Sintaxis Básica

```css
@keyframes nombreAnimacion {
  from {
    /* Estado inicial */
  }
  to {
    /* Estado final */
  }
}
```

### Sintaxis con Porcentajes (más control)

```css
@keyframes nombreAnimacion {
  0% {
    /* Estado inicial */
  }
  25% {
    /* 25% del progreso */
  }
  50% {
    /* Punto medio */
  }
  75% {
    /* 75% del progreso */
  }
  100% {
    /* Estado final */
  }
}
```

### Ejemplo Práctico: Desvanecimiento

```css
@keyframes fadeIn {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Múltiples Propiedades

Puedes animar múltiples propiedades simultáneamente:

```css
@keyframes slideRotate {
  0% {
    transform: translateX(0) rotate(0deg);
    background-color: #3498db;
    border-radius: 0%;
  }
  50% {
    transform: translateX(200px) rotate(180deg);
    background-color: #e74c3c;
    border-radius: 50%;
  }
  100% {
    transform: translateX(0) rotate(360deg);
    background-color: #3498db;
    border-radius: 0%;
  }
}
```

---

## 3. Propiedades de animation

### 3.1 animation-name
Especifica el nombre del @keyframes a usar.

```css
.elemento {
  animation-name: fadeIn;
}
```

### 3.2 animation-duration
Define cuánto tiempo dura la animación.

```css
.elemento {
  animation-duration: 2s; /* segundos */
  animation-duration: 500ms; /* milisegundos */
}
```

### 3.3 animation-timing-function
Controla la aceleración de la animación.

```css
.elemento {
  /* Valores predefinidos */
  animation-timing-function: ease; /* Por defecto */
  animation-timing-function: linear; /* Velocidad constante */
  animation-timing-function: ease-in; /* Acelera al inicio */
  animation-timing-function: ease-out; /* Desacelera al final */
  animation-timing-function: ease-in-out; /* Acelera y desacelera */
  
  /* Curvas Bézier personalizadas */
  animation-timing-function: cubic-bezier(0.42, 0, 0.58, 1);
  
  /* Funciones por pasos */
  animation-timing-function: steps(4, end);
}
```

### 3.4 animation-delay
Tiempo de espera antes de iniciar la animación.

```css
.elemento {
  animation-delay: 1s; /* Espera 1 segundo */
  animation-delay: -0.5s; /* Comienza a mitad de la animación */
}
```

### 3.5 animation-iteration-count
Número de veces que se repite la animación.

```css
.elemento {
  animation-iteration-count: 1; /* Una vez (por defecto) */
  animation-iteration-count: 3; /* Tres veces */
  animation-iteration-count: infinite; /* Infinitamente */
}
```

### 3.6 animation-direction
Dirección de la animación.

```css
.elemento {
  animation-direction: normal; /* Por defecto, 0% → 100% */
  animation-direction: reverse; /* Invertida, 100% → 0% */
  animation-direction: alternate; /* Alterna normal/reverse */
  animation-direction: alternate-reverse; /* Comienza en reverse */
}
```

### 3.7 animation-fill-mode
Define el estado del elemento antes y después de la animación.

```css
.elemento {
  animation-fill-mode: none; /* No aplica estilos fuera de la animación */
  animation-fill-mode: forwards; /* Mantiene estilos del último keyframe */
  animation-fill-mode: backwards; /* Aplica estilos del primer keyframe antes de iniciar */
  animation-fill-mode: both; /* Combina forwards y backwards */
}
```

### 3.8 animation-play-state
Controla si la animación está corriendo o pausada.

```css
.elemento {
  animation-play-state: running; /* Por defecto */
  animation-play-state: paused; /* Pausada */
}

/* Ejemplo con hover */
.elemento:hover {
  animation-play-state: paused;
}
```

### 3.9 Sintaxis Abreviada

Todas las propiedades en una sola línea:

```css
.elemento {
  animation: nombre duración timing-function delay iteration-count direction fill-mode play-state;
}

/* Ejemplo completo */
.elemento {
  animation: slideIn 1s ease-in-out 0.5s infinite alternate both running;
}

/* Ejemplo simplificado (más común) */
.elemento {
  animation: fadeIn 2s ease-out;
}
```

---

## 4. Ejemplos Prácticos

### 4.1 Animación de Carga (Spinner)

```css
@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

### 4.2 Efecto de Pulso

```css
@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
}

.boton-pulso {
  animation: pulse 2s ease-in-out infinite;
}
```

### 4.3 Efecto de Rebote

```css
@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-30px);
  }
  60% {
    transform: translateY(-15px);
  }
}

.icono-flecha {
  animation: bounce 2s infinite;
}
```

### 4.4 Texto Escribiéndose (Typewriter)

```css
@keyframes typing {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
}

@keyframes blink {
  50% {
    border-color: transparent;
  }
}

.texto-typewriter {
  width: 0;
  overflow: hidden;
  white-space: nowrap;
  border-right: 2px solid;
  animation: 
    typing 3.5s steps(40, end),
    blink 0.75s step-end infinite;
}
```

### 4.5 Animación de Entrada Desde Abajo

```css
@keyframes slideUp {
  0% {
    transform: translateY(100px);
    opacity: 0;
  }
  100% {
    transform: translateY(0);
    opacity: 1;
  }
}

.tarjeta {
  animation: slideUp 0.8s ease-out;
}
```

### 4.6 Animación de Onda (Wave)

```css
@keyframes wave {
  0%, 100% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(20deg);
  }
  75% {
    transform: rotate(-20deg);
  }
}

.emoji-mano {
  display: inline-block;
  animation: wave 1.5s ease-in-out infinite;
  transform-origin: 70% 70%;
}
```

### 4.7 Gradiente Animado

```css
@keyframes gradientMove {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.fondo-gradiente {
  background: linear-gradient(270deg, #ff6b6b, #4ecdc4, #45b7d1);
  background-size: 600% 600%;
  animation: gradientMove 8s ease infinite;
}
```

---

## 5. Timing Functions Avanzadas

### Curvas Bézier Personalizadas

Las curvas Bézier te dan control total sobre la aceleración:

```css
/* Formato: cubic-bezier(x1, y1, x2, y2) */

/* Efecto elástico al final */
.elemento {
  animation-timing-function: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

/* Movimiento rápido al inicio */
.elemento {
  animation-timing-function: cubic-bezier(0.7, 0, 1, 1);
}

/* Suave pero con rebote sutil */
.elemento {
  animation-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

### Funciones Steps (Animaciones por Pasos)

Útiles para sprites o efectos pixelados:

```css
@keyframes spriteAnimation {
  to {
    background-position: -1000px;
  }
}

.sprite {
  animation: spriteAnimation 1s steps(10) infinite;
}
```

### Herramientas útiles:
- **cubic-bezier.com**: Para crear curvas personalizadas
- **easings.net**: Galería de easing functions

---

## 6. Mejores Prácticas y Optimización

### 6.1 Propiedades Optimizadas para Animación

Estas propiedades usan aceleración por hardware (GPU):

✅ **Recomendadas:**
- `transform` (translate, rotate, scale)
- `opacity`

❌ **Evitar (afectan el rendimiento):**
- `width`, `height`
- `margin`, `padding`
- `top`, `left`, `right`, `bottom`

```css
/* ❌ Malo - Causa reflow */
@keyframes slideWrong {
  from {
    left: 0;
  }
  to {
    left: 100px;
  }
}

/* ✅ Bueno - Usa GPU */
@keyframes slideRight {
  from {
    transform: translateX(0);
  }
  to {
    transform: translateX(100px);
  }
}
```

### 6.2 Will-change

Indica al navegador qué propiedades van a cambiar:

```css
.elemento-animado {
  will-change: transform, opacity;
}

/* Aplícalo solo cuando sea necesario */
.elemento:hover {
  will-change: transform;
}

.elemento {
  will-change: auto; /* Remuévelo después */
}
```

⚠️ **Precaución**: No abuses de `will-change`, puede consumir más memoria.

### 6.3 Reducir Movimiento para Accesibilidad

Respeta las preferencias del usuario:

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### 6.4 Animaciones Múltiples

Puedes aplicar varias animaciones a un elemento:

```css
.elemento {
  animation: 
    fadeIn 1s ease-out,
    slideUp 1s ease-out,
    rotate 2s linear infinite;
}
```

### 6.5 Variables CSS en Animaciones

Hace tus animaciones más flexibles:

```css
:root {
  --duracion-animacion: 1s;
  --color-primario: #3498db;
}

@keyframes colorChange {
  to {
    background-color: var(--color-primario);
  }
}

.elemento {
  animation: colorChange var(--duracion-animacion) ease;
}
```

### 6.6 Debugging de Animaciones

```css
/* Ralentiza la animación para debugging */
.elemento {
  animation: miAnimacion 10s ease; /* En lugar de 1s */
}

/* Pausa la animación en un punto específico */
.elemento {
  animation-play-state: paused;
  animation-delay: -2s; /* Detente en el segundo 2 */
}
```

---

## 7. Cheat Sheet Rápido

```css
/* Sintaxis completa */
@keyframes nombre {
  0% { /* estilos iniciales */ }
  50% { /* estilos intermedios */ }
  100% { /* estilos finales */ }
}

.elemento {
  /* Forma corta */
  animation: nombre 1s ease 0s infinite normal both running;
  
  /* Equivalente en forma larga */
  animation-name: nombre;
  animation-duration: 1s;
  animation-timing-function: ease;
  animation-delay: 0s;
  animation-iteration-count: infinite;
  animation-direction: normal;
  animation-fill-mode: both;
  animation-play-state: running;
}
```

### Valores Comunes

| Propiedad | Valores Típicos |
|-----------|----------------|
| `animation-duration` | `0.3s`, `1s`, `2s` |
| `animation-timing-function` | `ease`, `linear`, `ease-in-out` |
| `animation-iteration-count` | `1`, `3`, `infinite` |
| `animation-direction` | `normal`, `alternate` |
| `animation-fill-mode` | `forwards`, `both` |

---

## 8. Recursos Adicionales

- **MDN Web Docs**: Documentación completa de CSS Animations
- **Animate.css**: Librería de animaciones prediseñadas
- **Animista**: Generador visual de animaciones CSS
- **CodePen**: Busca ejemplos de animaciones CSS

---

## 9. Ejercicios Prácticos

### Ejercicio 1: Botón Interactivo
Crea un botón que tenga:
- Animación de hover con efecto de elevación
- Animación de click con efecto de pulso
- Transición suave entre estados

### Ejercicio 2: Loader Creativo
Diseña un loader original usando solo CSS con:
- Mínimo 3 elementos animados
- Uso de `animation-delay` para efectos escalonados
- Loop infinito

### Ejercicio 3: Tarjeta con Entrada Animada
Crea una tarjeta que:
- Entre desde fuera de pantalla
- Tenga una animación de rebote al finalizar
- Use `animation-fill-mode` apropiadamente

---

## Conclusión

Las animaciones CSS son una herramienta poderosa para mejorar la experiencia de usuario. Recuerda:

1. **Usa transform y opacity** para mejor rendimiento
2. **Sé sutil**: las mejores animaciones son las que no se notan conscientemente
3. **Respeta las preferencias** de reducción de movimiento
4. **Prueba en dispositivos móviles**: el rendimiento puede variar
5. **No abuses**: demasiada animación distrae y cansa

¡Experimenta, practica y crea experiencias visuales increíbles! 🚀