

# 🎯 ¿Qué es `classList`?

`classList` es una **interfaz del DOM** que representa la lista de clases CSS de un elemento como si fuera un **array dinámico**, con métodos muy útiles para añadir, quitar, alternar y comprobar clases.

Es mucho más cómodo y seguro que manipular `className` manualmente.

---

# 🧩 ¿Cómo se accede?

```js
element.classList
```

Esto devuelve un objeto especial llamado **DOMTokenList**.

Ejemplo:

```html
<div id="caja" class="rojo grande"></div>
```

```js
const caja = document.getElementById("caja");
console.log(caja.classList);
// DOMTokenList ["rojo", "grande"]
```

---

# 🧱 Métodos principales de `classList`

## 1. **add()** → añade una o varias clases
```js
element.classList.add("activo");
element.classList.add("rojo", "borde");
```

Si la clase ya existe, no la duplica.

---

## 2. **remove()** → elimina una o varias clases
```js
element.classList.remove("rojo");
element.classList.remove("rojo", "borde");
```

Si la clase no existe, no pasa nada.

---

## 3. **toggle()** → alterna una clase
```js
element.classList.toggle("visible");
```

- Si la clase existe → la elimina  
- Si no existe → la añade

Muy útil para menús, modales, animaciones, etc.

También acepta un segundo parámetro booleano:

```js
element.classList.toggle("activo", true);  // fuerza añadir
element.classList.toggle("activo", false); // fuerza quitar
```

---

## 4. **contains()** → comprueba si la clase existe
```js
if (element.classList.contains("error")) {
  console.log("Tiene clase error");
}
```

---

## 5. **replace()** → sustituye una clase por otra
```js
element.classList.replace("rojo", "verde");
```

---

# 🧠 ¿Por qué `classList` es mejor que `className`?

### ❌ Con `className`:
```js
element.className += " activo";  // puede duplicar clases
element.className = "";          // borra todas las clases
```

### ✔️ Con `classList`:
- No duplica clases
- No borra accidentalmente otras
- Es más legible
- Es más seguro

---

# 🧪 Ejemplo práctico completo

```js
const caja = document.querySelector(".caja");

// Añadir clase
caja.classList.add("activo");

// Quitar clase
caja.classList.remove("activo");

// Alternar clase
caja.classList.toggle("visible");

// Comprobar clase
if (caja.classList.contains("visible")) {
  console.log("La caja está visible");
}

// Reemplazar clase
caja.classList.replace("rojo", "verde");
```

---

# 🎁 Bonus: recorrer las clases

```js
for (const clase of element.classList) {
  console.log(clase);
}
```

---

# 🎯 Resumen didáctico para tus guías

| Método | Acción |
|--------|--------|
| `add()` | Añade clases |
| `remove()` | Elimina clases |
| `toggle()` | Alterna clases |
| `contains()` | Comprueba si existe |
| `replace()` | Sustituye una clase por otra |

