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
- Existió un problema con widget_screenshot, quité el delay para el modo debug.
- Cambié el lugar de guardado para el almacenamiento y permisos usando el package image: ^4.5.4.
- Habilitado el modo invermiso para quitar la barra inferior de la pantalla.
- Solucionado los problemas del scroll y captura. El problema era que no pedía permiso en Android 15 y APIs altos, se pasó a librería de imagenes.
- Se agrega el paquete wakelock_plus para que la pantalla no se apague cuando está en uso la aplicacion.
- Una vez que el archivo termina de guardarse, se actualizan límites inferior con el nuevo valor guardado.
``PS D:\flutter_app\tmra> flutter --version    
Flutter 3.24.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 2663184aa7 (9 months ago) • 2024-09-11 16:27:48 -0500
Engine • revision 36335019a8
Tools • Dart 3.5.3 • DevTools 2.37.3
``
## TODO
- Chequear donde se guarda el .raw
- Cuando el archivo es grande, se tendría que particionar en 300k.
