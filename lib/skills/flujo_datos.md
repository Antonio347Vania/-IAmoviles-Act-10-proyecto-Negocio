# Flujo de Datos: UI a Firebase Agent

Este documento describe la Skill de interacción entre la interfaz de usuario (UI) y la base de datos a través de nuestro agente especializado.

## 1. Patrón de Arquitectura
Utilizamos un patrón de diseño basado en **Agentes y Modelos** para asegurar la escalabilidad y mantenibilidad de la aplicación multiplataforma.

- **UI (Screens)**: Solicita datos y envía órdenes (crear, editar, eliminar) a través de eventos de usuario.
- **Firebase Agent (`FirebaseAgent`)**: El cerebro encargado de la persistencia de datos. Traduce las órdenes de la UI en operaciones CRUD (Create, Read, Update, Delete) hacia Cloud Firestore.
- **Modelos (`Producto`, `Empleado`)**: Estructuras de datos *strongly-typed* que actúan como contrato entre la UI y el Agente.

## 2. Flujo de Trabajo (CRUD)

### Lectura (Read)
1. La UI se suscribe a los métodos de lectura del `FirebaseAgent` (ej. `leerProductos()`).
2. El Agente retorna un `Stream` constante de la colección respectiva en Firestore.
3. La UI, utilizando un `StreamBuilder`, escucha los cambios y actualiza automáticamente la pantalla con los nuevos datos, sin recargar.

### Escritura (Create / Update)
1. El usuario llena un formulario en la UI.
2. La UI empaqueta la información en un objeto Modelo (ej. instanciando un `Producto`).
3. La UI invoca el método correspondiente en el Agente (ej. `crearProducto(producto)`).
4. El Agente desglosa el Modelo a un `Map` mediante el método `toMap()` y lo envía a la colección en Firestore.

### Borrado (Delete)
1. Desde la UI, el usuario indica la eliminación de un registro.
2. La UI pasa el `id` (identificador único del documento) al Agente.
3. El Agente ejecuta la orden de borrado directamente sobre la referencia de ese documento en la base de datos.

## 3. Consideraciones de Identidad Visual
Toda la UI debe respetar nuestra Identidad Visual (definida en `lib/utils/app_theme.dart`):
- **Colores primarios**: Amarillo (`#F7C02F`), Verde (`#4CAF50`), Naranja suave (`#FFB74D`).
- **Formas**: Bordes redondeados con un radius de `30`.
- **Perfiles y Logos**: Uso del logotipo oficial dentro de componentes `CircleAvatar`.
