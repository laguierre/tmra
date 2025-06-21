import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<int> getAndroidSdkInt() async {
  if (!Platform.isAndroid) return 0;
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.version.sdkInt;
}
/// Solicita permiso para acceder al almacenamiento externo.
/// En Android gestiona ManageExternalStorage, en otros retorna true.
Future<bool> requestStoragePermission() async {
  if (!Platform.isAndroid) return true;

  final sdkInt = await getAndroidSdkInt();

  // Para Android 13 (API 33) y superior, no se necesita permiso para guardar
  // un archivo en el directorio de descargas.
  if (sdkInt >= 33) {
    return true;
  }

  // Lógica para Android 11-12 (API 30-32)
  if (sdkInt >= 30) {
    final manage = await Permission.manageExternalStorage.request();
    return manage.isGranted;
  }

  // Lógica para Android 10 e inferior
  else {
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }
}
/// Abre diálogo para seleccionar un archivo con extensión [extension] en la carpeta Descargas,
/// y luego comparte el archivo seleccionado.
/// [title] es el título que se muestra en el diálogo.
Future<void> openDialogSharingFile(
    BuildContext context, String extension, String title) async {
  //var rootPath = await DownloadsPath.downloadsDirectory();
  Directory rootPath = Directory('/storage/emulated/0/Pictures');


  if (rootPath == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo acceder a la carpeta Descargas')),
    );
    return;
  }

  String? fileToShare = await FilesystemPicker.open(
    fileTileSelectMode: FileTileSelectMode.wholeTile,
    theme: FilesystemPickerTheme(
      topBar: FilesystemPickerTopBarThemeData(
        elevation: 10,
        backgroundColor: Colors.amberAccent,
      ),
    ),
    title: title,
    context: context,
    rootDirectory: rootPath,
    fsType: FilesystemType.file,
    pickText: 'Seleccionar este archivo',
    folderIconColor: Colors.white,
    allowedExtensions: [extension],
    requestPermission: requestStoragePermission,
  );

  if (fileToShare != null && fileToShare.isNotEmpty) {
    shareSelectedFile(fileToShare);
  }
}

/// Comparte el archivo dado en [filePath].
void shareSelectedFile(String filePath) {
  final xfile = XFile(filePath);
  Share.shareXFiles([xfile], text: 'Archivo descargado');
}

/// Botón circular personalizado con icono a partir de un asset.
/// [sizeButton] controla el tamaño, [icon] es la ruta asset y [function] la acción al pulsar.
class CircleCustomButton extends StatelessWidget {
  const CircleCustomButton({
    super.key,
    required this.sizeButton,
    required this.icon,
    required this.function,
  });

  final double sizeButton;
  final String icon;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeButton,
      width: sizeButton,
      child: IconButton(
        onPressed: function,
        icon: Image.asset(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

