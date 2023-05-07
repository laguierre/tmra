import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

//TODO chequar otra opcion
Future<void> openDialogSharingFile(
    BuildContext context, String extension, String title) async {
  var rootPath = await DownloadsPath.downloadsDirectory();
  //print('Folder: $rootPath');

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
    rootDirectory: rootPath!,
    fsType: FilesystemType.file,
    pickText: 'Save file to this folder',
    folderIconColor: Colors.white,
    allowedExtensions: [extension],
    requestPermission: requestPermissionToRead,
  );
  if (fileToShare!.isNotEmpty) {
    shareSelectedFile(fileToShare);
  }
}

void shareSelectedFile(String file) {
  // TODO: Cuando se cambió de versión el ShareXFile, comenzaron los errores en build. En la actualización el soporte del ShareXFile, dejo de funcionar
  Share.shareFiles([file]);
  //Share.shareXFiles(XFile(fileToShare), text: 'Archivo descargado');
}

Future<bool> requestPermissionToRead() async {
  return await Permission.manageExternalStorage.request().isGranted;
}

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
          )),
    );
  }
}
