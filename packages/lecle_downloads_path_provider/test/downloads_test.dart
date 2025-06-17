import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';

void main() {
  const MethodChannel channel = MethodChannel('downloads_path');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DownloadsPath.downloadsDirectory, '42');
  });
}
