# Explicación del Código - Editor de Archivos Cifrados

## Descripción General

Este programa es un editor de texto que permite cargar archivos mediante drag and drop, cifrar y descifrar el contenido usando el cifrado César, y guardar el resultado.

---

## Estructura del Código

### 1. Variables Globales

```javascript
var textoSinCifrar = "";   // Almacena el texto original
var textoCifrado = "";      // Almacena el texto cifrado
var claveActual = "";       // Almacena la clave del usuario
```

Estas variables mantienen el estado de la aplicación entre operaciones.

---

### 2. Función `iniciar()`

Es la función principal que se ejecuta al cargar la página (`window.onload = iniciar`). Crea toda la interfaz dinámicamente.

#### Flujo de ejecución:

1. **Crear contenedor principal** - Un div que agrupa todos los elementos
2. **Crear título** - Encabezado "Editor de Archivos Cifrados"
3. **Crear campo de clave** - Input password para ingresar la clave
4. **Crear botones** - 4 botones: Cifrar, Descifrar, Guardar, Limpiar
5. **Crear zona de drop** - Área para arrastrar archivos
6. **Crear textarea** - Editor de texto editable
7. **Crear mensaje de estado** - Muestra información al usuario

---

### 3. Eventos Utilizados

| Evento | Descripción |
|--------|-------------|
| **input** | Se dispara al escribir en el campo de clave. Guarda la clave en la variable `claveActual` |
| **click** | Se dispara al hacer clic en los botones. Ejecuta las acciones de cifrar, descifrar, guardar o limpiar |
| **dragover** | Se dispara al pasar el mouse sobre la zona de drop. Necesario para permitir el drop |
| **dragenter** | Se dispara cuando el archivo entra en la zona. Cambia el color de fondo |
| **dragleave** | Se dispara cuando el archivo sale de la zona. Restaura el color de fondo |
| **drop** | Se dispara al soltar el archivo. Lee el archivo y lo carga en el textarea |
| **change** | Se dispara al cambiar el contenido del textarea. Actualiza `textoSinCifrar` |

---

### 4. Funciones de Cifrado

#### `cifrarCesarc(texto, clave)`
- Recorre cada carácter del texto
- Calcula el desplazamiento basado en la clave (usa el carácter correspondiente de la clave de forma cíclica)
- Suma el desplazamiento al código ASCII de cada carácter
- Retorna el texto cifrado

#### `descifrarCesarc(texto, clave)`
- Proceso inverso al cifrado
- Resta el desplazamiento al código ASCII de cada carácter
- Retorna el texto descifrado

---

### 5. Función `guardarArchivo(contenido)`

1. Crea un objeto Blob con el contenido
2. Genera una URL temporal con `URL.createObjectURL()`
3. Crea un elemento `<a>` con la URL y atributo download
4. Simula un clic para descargar el archivo
5. Limpia los elementos temporales

---

## Flujo de Uso

```
1. Usuario arrastra archivo .txt
   ↓
2. Evento drop → FileReader lee el archivo
   ↓
3. Contenido se muestra en el textarea
   ↓
4. Usuario ingresa una clave
   ↓
5. Usuario hace clic en "Cifrar" o "Descifrar"
   ↓
6. Se aplica el algoritmo César
   ↓
7. Resultado se muestra en el textarea
   ↓
8. Usuario hace clic en "Guardar"
   ↓
9. Se descarga el archivo
```

---

## Controles de Interfaz (mínimo 3 diferentes)

1. **Input type="password"** - Campo para la clave
2. **Button** - 4 botones para acciones
3. **Textarea** - Editor de texto
4. **Div (zonaDrop)** - Área de drag and drop

---

## Almacenamiento

- **textoSinCifrar**: Guarda la versión original del archivo
- **textoCifrado**: Guarda la versión cifrada
- **claveActual**: Guarda la clave ingresada por el usuario
