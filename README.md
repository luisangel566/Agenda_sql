# 📇 Sistema de Agenda de Contactos Empresarial — Oracle SQL

Base de datos relacional diseñada en Oracle para la gestión de contactos, empresas y etiquetas, aplicando buenas prácticas de modelado y consultas SQL avanzadas.

---

## 🎯 Objetivo del Proyecto

Simular un módulo de gestión de contactos tipo CRM, permitiendo almacenar, relacionar y consultar información empresarial de forma estructurada y eficiente.

---

## 🧠 Conceptos Aplicados

* Modelado relacional (1:N y N:M)
* Constraints avanzados:

  * PRIMARY KEY
  * FOREIGN KEY
  * UNIQUE
  * CHECK
  * NOT NULL
* Secuencias (`SEQUENCE`) para generación de IDs
* Índices para optimización de consultas
* Subconsultas correlacionadas
* Funciones Oracle:

  * `NVL`
  * `LISTAGG`
  * `TO_CHAR`
  * `ADD_MONTHS`
* Agregaciones:

  * `GROUP BY`
  * `HAVING`
* Búsquedas insensibles a mayúsculas (`UPPER`)

---

## 🧱 Modelo de Datos

### Tablas principales:

* **empresas** → Información de organizaciones
* **contactos** → Personas con datos de contacto
* **etiquetas** → Clasificación de contactos
* **contacto_etiquetas** → Relación N:M entre contactos y etiquetas

---

## ⚙️ Funcionalidades Implementadas

* Gestión de contactos y empresas
* Clasificación mediante etiquetas (N:M)
* Validaciones de datos (email, favorito)
* Consultas avanzadas para análisis de información

---

## 📊 Consultas Destacadas

### 🔹 Contactos favoritos con empresa y etiquetas

* Uso de `LEFT JOIN`
* Manejo de NULL con `NVL`
* Agregación con `LISTAGG`

---

### 🔹 Conteo de contactos por ciudad

* `GROUP BY` + `HAVING`
* Agregación de favoritos

---

### 🔹 Empresas con contactos asociados

* JOIN + agregación

---

### 🔹 Búsqueda por nombre

* Uso de `UPPER` para búsqueda insensible

---

### 🔹 Contactos recientes

* Funciones de fecha (`ADD_MONTHS`, `TO_CHAR`)

---

### 🔹 Etiquetas más utilizadas

* Análisis de frecuencia con `COUNT`

---

## 🚀 Ejecución

Ejecutar el script completo en Oracle:

```sql
@01_agenda.sql
```

---

## 🧪 Datos de Prueba

El script incluye:

* Empresas reales (Bancolombia, Ecopetrol, etc.)
* Contactos con diferentes roles
* Etiquetas como Cliente, Proveedor, Mentor

---

## 🏗️ Estructura del Proyecto

```
02-agenda-contactos/
├── sql/
│   └── 01_agenda.sql
└── README.md
```

---

## 💡 Lo que demuestra este proyecto

* Diseño de bases de datos relacionales
* Manejo de relaciones complejas (N:M)
* Construcción de consultas SQL de nivel intermedio-avanzado
* Optimización básica mediante índices
* Capacidad para modelar soluciones tipo empresa

---

## 👨‍💻 Autor

Luis Ángel Tapias Madroñero
Ingeniero de Sistemas — Bogotá, Colombia

🔗 https://github.com/luisangel566
