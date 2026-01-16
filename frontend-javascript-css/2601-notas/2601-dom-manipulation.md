

# 📘 **DOM Manipulation Cheat Sheet (JavaScript)**

## 🏗️ **1. Selección de elementos**
```js
document.getElementById("id")
document.getElementsByClassName("clase")
document.getElementsByTagName("div")

document.querySelector("#id")
document.querySelectorAll(".clase")
```

---

## 🧱 **2. Crear, clonar y eliminar nodos**
```js
const div = document.createElement("div")
const copia = div.cloneNode(true)   // true = copia profunda
div.remove()                        // elimina el nodo
```

---

## 🔌 **3. Insertar elementos**
```js
parent.appendChild(hijo)
parent.insertBefore(nuevo, referencia)

element.insertAdjacentHTML("beforebegin", "<p>Hola</p>")
element.insertAdjacentHTML("afterend", "<p>Fin</p>")
```

---

## 🎨 **4. Manipulación de estilos**
```js
element.style.backgroundColor = "red"
element.style.removeProperty("float")
element.style.cssText = "width:100px; height:50px;"
```

---

## 🏷️ **5. Atributos**
```js
element.setAttribute("id", "caja")
element.getAttribute("id")
element.removeAttribute("id")
```

---

## 🎛️ **6. Clases CSS**
```js
element.classList.add("activo")
element.classList.remove("activo")
element.classList.toggle("visible")
element.classList.contains("error")
```

---

## 📝 **7. Contenido**
```js
element.textContent = "Hola"
element.innerHTML = "<b>Hola</b>"
element.innerText = "Texto visible"
```

---

## 🧭 **8. Navegación del DOM**
```js
element.parentNode
element.children
element.firstElementChild
element.lastElementChild
element.nextElementSibling
element.previousElementSibling
```

---

## 🎯 **9. Eventos**
```js
element.addEventListener("click", () => console.log("click"))
element.removeEventListener("click", handler)

window.onload = () => console.log("cargado")
```

---

## 🧪 **10. Formularios**
```js
const valor = input.value
input.value = "nuevo valor"
form.reset()
```

---

## 🧩 **11. Dimensiones y posición**
```js
element.offsetWidth
element.offsetHeight
element.getBoundingClientRect()   // posición y tamaño
```

---

## 🚀 **12. Utilidades comunes**
```js
document.createDocumentFragment()   // inserciones masivas eficientes
element.scrollIntoView()            // desplazar hasta el elemento
```