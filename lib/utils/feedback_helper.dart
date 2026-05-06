import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class FeedbackHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> successFeedback() async {
    await _player.play(AssetSource('sounds/success.mp3'));
    await HapticFeedback.successNotification();
  }

  static Future<void> processCompleteFeedback() async {
    await _player.play(AssetSource('sounds/success.mp3')); // Same for success currently
    await HapticFeedback.successNotification();
  }

  static Future<void> errorFeedback() async {
    await _player.play(AssetSource('sounds/error.mp3'));
    await HapticFeedback.errorNotification();
  }

  static Future<void> cameraShutterFeedback() async {
    await _player.play(AssetSource('sounds/camera_shutter.mp3'));
    await HapticFeedback.selectionClick();
  }
}
