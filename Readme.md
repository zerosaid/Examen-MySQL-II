Examen MySQL-II
📌 Descripción del Proyecto

Examen MySQL-II es un conjunto de archivos SQL que muestran el desarrollo y la creación de una base de datos en entorno MySQL.
La base de datos, llamada Chinook, está diseñada para almacenar y gestionar información relacionada con contenido multimedia discográfico.

Incluye:

Consultas optimizadas para obtener información de forma eficiente.

Funciones que muestran datos específicos.

Eventos para almacenamiento y actualización automática de registros.

Estructura con llaves foráneas para garantizar la integridad referencial.

🖥️ Requisitos del Sistema

MySQL Server 8.0 o superior.

Cliente MySQL (Workbench o CLI).

Sistema operativo compatible con MySQL (Windows, Linux o macOS).

⚙️ Instalación y Configuración

Crear la base de datos:

CREATE DATABASE `Chinook`;
USE `Chinook`;


Crear las tablas:

Abrir el archivo ddl.sql ubicado en la carpeta correspondiente.

Ejecutar el script completo usando:

Ctrl + Enter (Workbench, para ejecutar línea o bloque seleccionado).

Alt + X (para ejecutar todo el script).

Configurar relaciones:

Ejecutar los comandos ALTER TABLE del mismo archivo ddl.sql para establecer las llaves foráneas y asegurar la conexión entre tablas.

📂 Estructura del Proyecto
Examen-MySQL-II/
│
├── ddl.sql             # Definición de tablas y relaciones
├── consultas.sql       # Consultas SQL de ejemplo
├── funciones.sql       # Funciones definidas en la BD
├── triggers.sql        # Triggers implementados
├── eventos.sql         # Eventos programados
└── README.md           # Documentación del proyecto

🚀 Uso

Una vez creada y configurada la base de datos, puedes ejecutar los scripts de:

Consultas para obtener reportes.

Funciones para cálculos específicos.

Triggers y eventos para automatizar tareas.