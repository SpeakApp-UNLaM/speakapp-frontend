import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recorder_provider.dart';

class ButtonRecorder extends StatelessWidget {
  final GestureTapCallback? onTap;

  const ButtonRecorder({required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          width: 135.0,
          height: 135.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: recorderProv.recordingOn
                  ? const Color.fromARGB(255, 163, 201, 119)
                  : const Color.fromARGB(255, 108, 134, 79)),
          child: recorderProv.recordingOn
              ? const Icon(
                  Icons.mic,
                  color: Color.fromARGB(255, 91, 138, 93),
                  size: 40,
                )
              : const Icon(Icons.mic,
                  size: 40, color: Color.fromARGB(255, 163, 201, 119)),
        ),
      ),
    );
  }
}
