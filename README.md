# TMRA In Situ APP
- Aplicación para ver en el sitio los sensores y realizar la bajada de los datos en la EM.
## v0.1
- Usa el widget "screenshot"  [link](https://pub.dev/packages/screenshot)
## v0.1b
- Usar el widget para captura de pantalla "widget_screenshot" [link](https://pub.dev/packages/widget_screenshot)
## v0.1c
- Se agrega la navegación legada y se cambian la unidad del sensor CS451 por PSI.
- Compatibilidad hacia version WiFi 2.1
- [010823] Se usa el package para ajustar la fuente https://pub.dev/packages/flutter_screenutil
## v0.1d
- Se hace adaptación reactiva y se cambia todo a .sp. 
- Se actualizan algunas deprecated
- Apareció un error en el widget_screenshot sobre las pantallas largas, aplicando un pequeño delay funciona nuevamente
## v0.1e
- Existió un problema con widget_screenshot, quité el delay.
- Cambie el lugar de guardado para el almacenamiento y permisos.
- Solucionado los problemas del scroll y captura. El problema era que no pedía permiso en Android 15 y APIs altos.

## TODO
- Cuando el archivo es grande, se tendría que particionar en 300k.
- Una vez que el archivo termina de guardarse, se debería actualizar los límites inferior con el bueno valor guardado.