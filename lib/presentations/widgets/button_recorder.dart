import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recorder_provider.dart';

class ButtonRecorder extends StatelessWidget {
  const ButtonRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();

    return GestureDetector(
        onTapUp: (details) => recorderProv.stopRecording(),
        onTapDown: (details) => recorderProv.startRecording(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCirc,
          decoration: BoxDecoration(
            color: recorderProv.recordingOn
                ? Colors.grey[400]
                : const Color.fromARGB(255, 127, 163, 85),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              if (recorderProv.recordingOn)
                BoxShadow(
                  color: Colors.grey[400]!,
                  offset: const Offset(0, 2),
                  blurRadius: 2.0,
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mic,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 8.0),
              Text(
                recorderProv.recordingOn ? '...' : 'Grabar',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
