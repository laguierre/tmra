import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> openSharingFile(BuildContext context) async {
  var rootPath = await DownloadsPath.downloadsDirectory();
  print('Folder: $rootPath');
  String? path = await FilesystemPicker.openDialog(
    fileTileSelectMode: FileTileSelectMode.wholeTile,
    title: 'Archivos descargados',
    context: context,
    rootDirectory: rootPath!,
    fsType: FilesystemType.file,
    pickText: 'Save file to this folder',
    folderIconColor: Colors.black,
    allowedExtensions: ['.raw'],
  );
  print('Picker: $path');
  if (path!.isNotEmpty) {
    Share.shareXFiles([XFile(path)], text: 'Archivo descargado');
  }
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