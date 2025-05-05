#  Karate DSL - Ejercicios Avanzados

> **Importante**: Crea un usuario propio para hacer los ejercicios en la web de pruebas [conduit.bondaracademy.com](https://conduit.bondaracademy.com/)

---

## 1. Autenticación de usuario y obtención de token

**Escenario: Autenticación**

- Método: `POST`
- Endpoint: `/users/login`
- Variables:
  - `userEmail`
  - `userPassword`
- Requisitos:
  - Código de respuesta esperado: `200`
  - Extraer y guardar `response.user.token` en una variable
- **Ruta sugerida**: `helpers/createToken.feature`

---

## 2. Gestión de artículos

### Contexto (Background)

Antes de ejecutar los escenarios:

1. Definir `apiUrl`
2. Cargar cuerpo desde `newArticleRequest.json`
3. Generar datos aleatorios con `dataGenerator`:
   - `title`
   - `description`
   - `body`
4. Ejecutar `createToken.feature` para autenticación

### Escenario 1: Crear un nuevo artículo

- Método: `POST` a `/articles`
- Requisitos:
  - Código de respuesta: `201`
  - Verificar que el título de respuesta coincide con el enviado

### Escenario 2: Crear y eliminar un artículo

**Pasos:**

1. **Crear artículo**
   - `POST /articles`
   - Código esperado: `201`
   - Extraer `slug` del artículo

2. **Verificar creación**
   - `GET /articles?limit=10&offset=0`
   - Código: `200`
   - Verificar que el primer título coincide

3. **Eliminar artículo**
   - `DELETE /articles/{slug}`
   - Código: `204`

4. **Verificar eliminación**
   - `GET /articles?limit=10&offset=0`
   - Verificar que el título ya no aparece

- **Ruta sugerida**: `src/test/java/examples/conduit/bondarAcademyTests/articles.feature`

---

## 3. Validaciones en la página de inicio

### Contexto (Background)

- Definir `apiUrl`

### Escenario 1: Obtener todas las etiquetas

- `GET /tags`
- Código esperado: `200`
- Validaciones:
  - Contiene los tags: `["Test", "GitHub", "Coding", "Git", "Enroll", "Bondar Academy", "Zoom", "qa career"]`
  - No contiene: `"truck"`
  - `tags` es un array de strings

### Escenario 2: Obtener 10 artículos

- `GET /articles?limit=10&offset=0`
- Código esperado: `200`
- Validaciones:
  - 10 artículos en `articles`
  - `articlesCount` correcto
  - Cada artículo tiene:
    - `slug`, `title`, `description`, `body`: Strings
    - `tagList`: Array
    - `createdAt`, `updatedAt`: Fechas válidas (`timeValidator`)
    - `favorited`: Boolean
    - `favoritesCount`: Número
    - `author`: 
      - `username`: String
      - `bio`: String (opcional)
      - `image`: String
      - `following`: Boolean

- **Ruta sugerida**: `src/test/java/examples/conduit/bondarAcademyTests/homePage.feature`

---

## 4. Registro de nuevos usuarios

### Contexto (Background)

1. Importar `DataGenerator` desde `examples.conduitApp.helpers.DataGenerator`
2. Generar valores aleatorios para `email` y `username`
3. Definir `apiUrl`

### Escenario 1 (Ignorado en CI): Registro de un nuevo usuario

> ⚠️ Solo para pruebas locales.

- `POST /users` con:
  - `email`: Aleatorio
  - `username`: Aleatorio
  - `password`: `"karate1234"`
- Código esperado: `201`
- Validaciones:
  - `id`: Número
  - `email`, `username`: Coinciden con los generados
  - `bio`: null
  - `image`: String
  - `token`: String

### Escenario 2: Validaciones de error

- `POST /users` con combinaciones inválidas
- Código esperado: `422`
- Ejemplos:

| Caso               | Email                  | Password     | Username       | Respuesta esperada                                      |
|--------------------|------------------------|--------------|----------------|----------------------------------------------------------|
| Usuario ya existe  | Aleatorio              | karate1234   | karateRaul25   | `{"errors":{"username":["has already been taken"]}}`     |
| Email ya existe    | karateRaul25@test.com  | karate1234   | Aleatorio      | `{"errors":{"email":["has already been taken"]}}`        |
| Username vacío     | Aleatorio              | karate1234   | ""             | `{"errors":{"username":["can't be blank"]}}`             |
| Email vacío        | ""                     | karate1234   | Aleatorio      | `{"errors":{"email":["can't be blank"]}}`                |
| Password vacío     | Aleatorio              | ""           | Aleatorio      | `{"errors":{"password":["can't be blank"]}}`             |

- **Ruta sugerida**: `src/test/java/examples/conduit/bondarAcademyTests/signUp.feature`

---
