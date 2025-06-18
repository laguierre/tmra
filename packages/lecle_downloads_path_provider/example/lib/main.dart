import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _downloadsPath = 'Unknown';

  @override
  void initState() {
    super.initState();
    initDownloadsDirectoryPath();
  }

  Future<void> initDownloadsDirectoryPath() async {
    String downloadsPath;
    try {
      downloadsPath = (await DownloadsPath.downloadsDirectory())?.path ??
          "Downloads path doesn't exist";

      // var dirType = DownloadDirectoryTypes.dcim;
      // downloadsPath = (await DownloadsPath.downloadsDirectory(dirType: dirType))?.path ?? "Downloads path doesn't exist";
    } catch (e) {
      downloadsPath = 'Failed to get downloads paths';
    }

    if (!mounted) return;

    setState(() {
      _downloadsPath = downloadsPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads path example app'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Downloads path:\n $_downloadsPath\n',
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
