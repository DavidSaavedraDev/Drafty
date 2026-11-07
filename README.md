# Drafty

Aplicación de notas rápidas construida con Flutter y Material 3. Drafty está pensada para capturar ideas, organizarlas por carpetas y encontrarlas rápidamente desde una interfaz limpia, adaptable y cómoda tanto en escritorio como en móvil.

## Características

- Crear, editar y eliminar notas desde un editor rápido.
- Buscar por título y contenido en tiempo real.
- Organizar notas en las carpetas `Trabajo`, `Personal` e `Inspiración`.
- Filtrar todas las notas y consultar las notas favoritas.
- Vista responsive para pantallas grandes y pequeñas.
- Interfaz basada en Material 3 con tema claro y componentes accesibles.
- Estado inicial con notas de ejemplo para probar la aplicación inmediatamente.
- Compilación web de producción lista para servir como archivos estáticos.

> **Estado de los datos:** actualmente las notas se mantienen en memoria. Al reiniciar o recargar la aplicación, vuelven a aparecer los datos iniciales. La integración con almacenamiento persistente puede añadirse posteriormente.

## Requisitos

- Flutter instalado en el canal estable.
- Dart incluido en el SDK de Flutter.
- Para la versión web, un navegador compatible y un servidor HTTP local.

Comprueba el entorno con:

```bash
flutter doctor
```

## Ejecutar en desarrollo

Instala las dependencias y lanza la aplicación en el navegador:

```bash
flutter pub get
flutter config --enable-web
flutter run -d chrome
```

Para trabajar en un GitHub Codespace sin abrir un navegador dentro del contenedor:

```bash
flutter run \
	-d web-server \
	--web-hostname 0.0.0.0 \
	--web-port 8080
```

Después, abre el puerto `8080` desde la pestaña **Ports** de VS Code y utiliza la URL reenviada por Codespaces.

## Compilación web de producción

Genera los archivos optimizados en `build/web`:

```bash
flutter clean
flutter pub get
flutter build web --release
```

Puedes servir esa compilación localmente con el servidor HTTP incluido en Python:

```bash
python3 -m http.server 8080 \
	--bind 0.0.0.0 \
	--directory build/web
```

En Codespaces, abre el puerto `8080` desde **Ports**. Si está ocupado, utiliza otro puerto, por ejemplo `8081`:

```bash
python3 -m http.server 8081 \
	--bind 0.0.0.0 \
	--directory build/web
```

## Calidad y pruebas

Analiza el código y ejecuta las pruebas con:

```bash
flutter analyze
flutter test
```

## Estructura principal

```text
lib/main.dart       # Aplicación, modelo de nota y widgets de Drafty
test/               # Pruebas de widgets
web/                # Configuración de la plataforma web
build/web/          # Salida generada por flutter build web
pubspec.yaml        # Dependencias y configuración del proyecto
```

## Tecnologías

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- Material 3

## Licencia

Este proyecto es privado y no está preparado para publicarse en `pub.dev`.