import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WaveForm extends StatelessWidget {
  final RecorderController controller;

  const WaveForm({required this.controller, super.key});
  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      size: Size(MediaQuery.of(context).size.width, 200.0),
      recorderController: controller,
      enableGesture: false,
      waveStyle: WaveStyle(
        scaleFactor: 500, //size waveform
        waveColor: Colors.black,
        showDurationLabel: true,
        spacing: 8.0,
        showBottom: true,
        extendWaveform: true,
        showMiddleLine: false,
        gradient: ui.Gradient.linear(
          const Offset(70, 50),
          Offset(MediaQuery.of(context).size.width / 2, 0),
          [Colors.red, Colors.green],
        ),
      ),
    );
  }
}
