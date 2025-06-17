import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';

/// Simple class to call for invoking the method that get and return the demand directory
class DownloadsPath {
  /// Invoke method channel to get the downloads directory absolute path in Android and iOS device
  static const MethodChannel _channel = MethodChannel('downloads_path');

  /// Static property to simply call and get the directory created from the returned path of native code
  ///
  /// * You can get the dirType from [DownloadDirectoryTypes] class
  ///
  /// * dirType property can work with Android device only
  /// ``` Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory; ```
  /// ``` String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory)?.path; ```
  static Future<Directory?> downloadsDirectory({String? dirType}) async {
    final String? path = await _channel
        .invokeMethod('getDownloadsDirectory', {'directoryType': dirType});

    return path == null ? null : Directory(path);
  }
}
