# Chrome Nano Check

Prueba local y portable para comprobar si un Chrome ya tiene accesible su modelo integrado Gemini Nano (`v3Nano`) mediante la API `LanguageModel`.

> Este proyecto no es un instalador del modelo. No empaqueta, copia ni fuerza la descarga de Gemini Nano.

## Qué comprueba

La página separa tres niveles:

1. **API:** si este origen puede ver `LanguageModel`.
2. **Disponibilidad:** el resultado de `LanguageModel.availability()`.
3. **Funcionamiento:** una inferencia breve, únicamente cuando el estado es `available`.

Una prueba técnica satisfactoria significa que la API existe, el modelo está accesible y Chrome ha generado una respuesta. No significa que todas las respuestas sean correctas ni que el modelo sirva para tareas complejas.

## Qué no hace

- No instala ni empaqueta el modelo.
- No llama a `LanguageModel.create()` cuando el modelo no está en `available`.
- No implementa un flujo de descarga ni muestra progreso de descarga.
- No modifica Chrome ni sus perfiles.
- No lee archivos, Gmail ni el sistema local.
- No usa claves API, analítica ni backend propio.
- No garantiza la calidad, exactitud o disponibilidad futura del modelo.

Chrome conserva el control de sus propios componentes y, según la versión, el perfil y sus funciones internas, puede gestionar descargas o actualizaciones independientemente de esta página. La página no las fuerza ni las implementa.

## Requisitos orientativos

Los requisitos publicados por Chrome pueden cambiar. Como referencia para las APIs de IA integradas:

- Chrome compatible en Windows 10/11, macOS 13+, Linux o ChromeOS compatible en Chromebook Plus.
- Al menos 16 GB de RAM y 4 núcleos si se utiliza CPU.
- GPU con más de 4 GB de VRAM si Chrome utiliza GPU.
- Aproximadamente 22 GB libres en el volumen que contiene el perfil de Chrome.
- Conexión no limitada para una eventual descarga inicial gestionada por Chrome.

Estos datos son orientativos y no sustituyen la comprobación real. Chrome puede seleccionar variantes y backends distintos según el equipo.

## Ejecutar localmente

Requiere Python 3, que se usa únicamente para servir los archivos estáticos:

```bash
./start.sh
```

El script usa el puerto `8796` por defecto. También se puede elegir otro:

```bash
PORT=8797 ./start.sh
```

Alternativamente:

```bash
python3 -m http.server 8796 --bind 127.0.0.1
```

Abre después:

```text
http://127.0.0.1:8796/
```

El navegador debe ser el Chrome del mismo equipo que ejecuta el servidor. `127.0.0.1` siempre significa “este equipo”; no apunta a otro nodo de la red Tailscale o LAN.

## Interpretación de estados

| Estado | Significado |
|---|---|
| `available` | El modelo ya está accesible y se puede ejecutar la prueba. |
| `downloadable` | Chrome considera que podría descargar recursos, pero esta página no inicia ese flujo. |
| `downloading` | Chrome informa de una descarga en curso; esta página no interviene. |
| `unavailable` | El modelo no está disponible en ese entorno. |

## Diagnóstico adicional

Para conocer la versión de Chrome:

```text
chrome://version
```

Para consultar el componente y los registros del modelo:

```text
chrome://on-device-internals
```

En DevTools también se puede consultar, sin enviar datos a esta página:

```javascript
await LanguageModel.availability()
```

Si el resultado no es el esperado:

1. Comprueba que estás usando el Chrome del equipo correcto.
2. Reinicia Chrome.
3. Revisa `chrome://on-device-internals` y la pestaña **Broker State**.
4. Comprueba espacio libre, versión, plataforma y políticas del navegador.
5. Vuelve a ejecutar la comprobación.

## Casos de uso para evaluar

La prueba breve sirve como demostración técnica. Si el modelo está disponible, se pueden probar textos propios, preferiblemente sin datos sensibles al principio:

- clasificación de avisos y notas;
- resumen de correos cortos;
- extracción de fechas y acciones;
- simplificación de textos;
- corrección o reformulación breve.

Los resultados son sugerencias generadas por un modelo pequeño. Deben revisarse antes de tomar decisiones o ejecutar acciones. Puede producir respuestas plausibles pero añadir inferencias que no aparecen en el texto.

## Casos reproducibles

Para comparar equipos, prueba primero un texto que no contenga información personal:

```text
La reunión de revisión será el 30 de octubre. Hay que confirmar la asistencia antes del viernes.
```

Comprueba si la respuesta identifica, sin inventar datos:

- la fecha del 30 de octubre;
- la acción de confirmar la asistencia;
- el plazo “antes del viernes” como texto ambiguo, sin convertirlo en una fecha concreta.

La misma respuesta no tiene que ser idéntica en todos los equipos o versiones de Chrome.

## Privacidad

La página no contiene llamadas `fetch` a servicios externos, no incorpora analítica y no envía el texto a un backend propio. La inferencia se solicita a la API integrada del Chrome local.

Aun así:

- revisa el código si usas una copia descargada de Internet;
- no introduzcas datos sensibles en una copia cuya procedencia no conozcas;
- el hecho de que el modelo sea local no convierte automáticamente en confiable cualquier página que lo utilice.

## Plantilla de informe

```text
## Resultado Chrome Nano Check

- Sistema operativo:
- Versión de Chrome:
- Fecha:
- Equipo donde se ejecutó el navegador:
- API LanguageModel:
- availability():
- Prueba de inferencia:
- Resultado observado:
- Observaciones:
```

No incluyas en un informe público nombres de usuario, rutas privadas, contenido de correos, claves ni identificadores innecesarios.

## Referencia oficial

- [Prompt API de Chrome](https://developer.chrome.com/docs/ai/prompt-api)
- [Built-in AI: inicio y requisitos](https://developer.chrome.com/docs/ai/get-started)

## Estado

Prototipo local verificado en Chrome sobre Linux. Las APIs, requisitos, estados y modelos integrados pueden cambiar con las versiones de Chrome.
