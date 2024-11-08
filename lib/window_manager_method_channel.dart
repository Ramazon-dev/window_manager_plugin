import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'window_manager_platform_interface.dart';

/// An implementation of [WindowManagerPlatform] that uses method channels.
class MethodChannelWindowManager extends WindowManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('window_manager');

  @visibleForTesting
  final eventChannel = const EventChannel('window_manager/events');

  @override
  Future<void> blockScreenShot() async {
    final call = await methodChannel.invokeMethod<String>('blockScreenShot');
    print('object blockScreenShot $call');
  }

  @override
  Future<void> unblockScreenShot() async {
    final call = await methodChannel.invokeMethod<String>('unblockScreenShot');
    print('object unblockScreenShot $call');
  }

  @override
  Future<bool> isBlockScreenShot() async {
    final call = await methodChannel.invokeMethod<bool>('isBlockScreenShot');
    print('object isBlockScreenShot $call');
    return call ?? false;
  }

  @override
  Stream<bool> tryToCaptureScreen() async* {
    // this stream only  in ios working
    if (Platform.isIOS) {
      Stream<bool?> scanResultsStream =
          eventChannel.receiveBroadcastStream().cast();

      final buffer = BufferStream.listen(scanResultsStream);

      await for (final item in buffer.stream) {
        print(item);
        yield item ?? false;
      }
    }
  }

  @override
  Future<void> enablePrivacyScreen() async {
    final call =
        await methodChannel.invokeMethod<String>('enablePrivacyScreen');
    print('object enablePrivacyScreen $call');
    print(call);
  }

  @override
  Future<void> disablePrivacyScreen() async {
    final call =
        await methodChannel.invokeMethod<String>('disablePrivacyScreen');
    print('object disablePrivacyScreen $call');
    print(call);
  }
}

class BufferStream<T> {
  final Stream<T> _inputStream;
  late final StreamSubscription? _subscription;
  late final StreamController<T> _controller;

  BufferStream.listen(this._inputStream) {
    _controller = StreamController<T>(
      onCancel: () {
        _subscription?.cancel();
      },
      onPause: () {
        _subscription?.pause();
      },
      onResume: () {
        _subscription?.resume();
      },
      onListen: () {}, // inputStream is already listened to
    );

    // immediately start listening to the inputStream
    _subscription = _inputStream.listen(
      (data) {
        _controller.add(data);
      },
      onError: (e) {
        _controller.addError(e);
      },
      onDone: () {
        _controller.close();
      },
      cancelOnError: false,
    );
  }

  void close() {
    _subscription?.cancel();
    _controller.close();
  }

  Stream<T> get stream async* {
    yield* _controller.stream;
  }
}
