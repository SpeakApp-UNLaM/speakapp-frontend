import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recorder_provider.dart';

class ButtonRecorder extends StatelessWidget {
  final VoidCallback? onPressed;

  const ButtonRecorder({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Color.fromARGB(255, 127, 163, 85),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mic,
            color: 
          Colors.white,
            size: 40,
          ),
          const SizedBox(width: 8.0),
          Text(
            recorderProv.recordingOn ? '...' : 'Grabar',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
