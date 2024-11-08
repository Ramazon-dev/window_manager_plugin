import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_manager/window_manager_method_channel.dart';
import 'package:window_manager/window_manager_platform_interface.dart';

class MockWindowManagerPlatform
    with MockPlatformInterfaceMixin
    implements WindowManagerPlatform {
  @override
  Future<void> blockScreenShot() {
    // TODO: implement blockScreenShot
    throw UnimplementedError();
  }

  @override
  Future<void> unblockScreenShot() {
    // TODO: implement unblockScreenShot
    throw UnimplementedError();
  }

  @override
  Future<bool> isBlockScreenShot() {
    // TODO: implement isBlockScreenShot
    throw UnimplementedError();
  }

  @override
  Stream<bool> tryToCaptureScreen() {
    // TODO: implement tryToCaptureScreen
    throw UnimplementedError();
  }

  @override
  Future<void> disablePrivacyScreen() {
    // TODO: implement disablePrivacyScreen
    throw UnimplementedError();
  }

  @override
  Future<void> enablePrivacyScreen() {
    // TODO: implement enablePrivacyScreen
    throw UnimplementedError();
  }
}

void main() {
  final WindowManagerPlatform initialPlatform = WindowManagerPlatform.instance;

  test('$MethodChannelWindowManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWindowManager>());
  });

  test('getPlatformVersion', () async {
    WindowManager windowManagerPlugin = WindowManager();
    MockWindowManagerPlatform fakePlatform = MockWindowManagerPlatform();
    WindowManagerPlatform.instance = fakePlatform;
  });
}
