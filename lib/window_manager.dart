import 'window_manager_platform_interface.dart';

class WindowManager {
  Future<void> blockScreenShot() {
    return WindowManagerPlatform.instance.blockScreenShot();
  }

  Future<void> unblockScreenShot() {
    return WindowManagerPlatform.instance.unblockScreenShot();
  }

  Future<bool> isBlockScreenShot() {
    return WindowManagerPlatform.instance.isBlockScreenShot();
  }

  Future<void> toggleScreenShot() async {
    final block = await isBlockScreenShot();
    if (block) {
      WindowManagerPlatform.instance.unblockScreenShot();
    } else {
      WindowManagerPlatform.instance.blockScreenShot();
    }
  }

  Stream<bool> tryToCaptureScreen() {
    return WindowManagerPlatform.instance.tryToCaptureScreen();
  }

  Future<void> enablePrivacyScreen() {
    return WindowManagerPlatform.instance.enablePrivacyScreen();
  }

  Future<void> disablePrivacyScreen() {
    return WindowManagerPlatform.instance.disablePrivacyScreen();
  }
}
