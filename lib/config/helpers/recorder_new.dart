import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:file_picker/file_picker.dart';

class RecorderNew {
  late String _recordingPath;
  late final RecorderController recorderController;
  PlayerController playerController = PlayerController();
  String? musicFile;
  Future<void> init() async {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac_eld
      ..androidOutputFormat = AndroidOutputFormat.aac_adts
      ..sampleRate = 44100
      ..bitRate = 128000;

    final directory = await getTemporaryDirectory();
    _recordingPath = '${directory.path}/recording.wav';

    if (await Permission.microphone.isGranted) {
      await Permission.storage.request();
    } else {
      // Request the permission to record audio.
      await Permission.microphone.request();
    }
  }

  String getRecordingPath() => _recordingPath;

  RecorderNew() {
    init();
  }
  Future<void> startRecording() async {
    recorderController.refresh();
    await recorderController.record(path: _recordingPath);
  }

  Future<void> stopRecording() async {
    String? output = await recorderController.stop();
    //  await _pickFile();
    log("datos: $output otro dato1 $_recordingPath");
  }

  void dispose() => recorderController.dispose();

  /*Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
    } else {
      log("File not picked");
    }
  }*/

  getController() => recorderController;

  void startPlayer() async {
    await playerController.preparePlayer(
      path: _recordingPath,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    await playerController.startPlayer(
        finishMode: FinishMode.stop); // Start audio player
  }

  void stopPlayer() async =>
      await playerController.stopPlayer(); // Stop audio player

  Future<void> initPlayer() async {
    //PlayerController controller = playerController;
// Extract waveform data
    /*final waveformData = await controller.extractWaveformData(
      path: _recordingPath,
      noOfSamples: 100,
    );*/
// Or directly extract from preparePlayer and initialise audio player

    //await controller.pausePlayer(); // Pause audio player
    //await controller.stopPlayer(); // Stop audio player
    /*await controller.setVolume(1.0); // Set volume level
    await controller.seekTo(5000); // Seek audio
    final duration = await controller
        .getDuration(DurationType.max); // Get duration of audio player
    controller.updateFrequency =
        UpdateFrequency.low; // Update reporting rate of current duration.
    controller.onPlayerStateChanged
        .listen((state) {}); // Listening to player state changes
    controller.onCurrentDurationChanged
        .listen((duration) {}); // Listening to current duration changes
    controller.onCurrentExtractedWaveformData
        .listen((data) {}); // Listening to latest extraction data
    controller.onExtractionProgress
        .listen((progress) {}); // Listening to extraction progress
    controller.onCompletion.listen((_) {}); // Listening to audio completion
    controller.stopAllPlayers(); // Stop all registered audio players
    controller.dispose();*/
  }
}
