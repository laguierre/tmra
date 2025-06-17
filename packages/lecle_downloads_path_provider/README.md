# lecle_downloads_path_provider

A Flutter plugin to get the downloads folder directory on Android and iOS device. Besides, on Android device you can get the other directories too (Movies,
Pictures, DCIM,...).

## How to use

- Simply import the [lecle_downloads_path_provider](https://pub.dev/packages/lecle_downloads_path_provider) package on pub.dev or with the syntax below
  under dependencies in pubspec.yaml file and run flutter command **flutter pub get** in terminal

  `dependencies:`\
  &emsp;`flutter:` \
  &emsp;&emsp;`sdk:flutter`

  `lecle_downloads_path_provider: <latest version>`

- Add `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />` to your AndroidManifest.xml

## Example
`import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';`

* **If you want to get the different directory path (default type is Downloads directory)**\
  `import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';`

* **Default use**\
  `Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();`\
  `String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;`

* **With custom directory type**\
  `var dirType = DownloadDirectoryTypes.dcim;`\
  `Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory(dirType: dirPath);`\
  `String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory(dirType: dirPath))?.path`
