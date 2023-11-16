import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/presentations/messages_screen.dart';
import 'package:sp_front/presentations/screens/choice_patient_screen_messages.dart';
import 'package:sp_front/presentations/screens/choice_patient_screen_rfi.dart';
import 'package:sp_front/providers/auth_provider.dart';

class MessagesView extends StatefulWidget {
  static const String name = 'messages';
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesView();
}

class _MessagesView extends State<MessagesView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.read<AuthProvider>().loggedUser.type == "patient"
          ? const MessagesScreen()
          : const ChoicePatientScreenMessages(route: "messages_screen"),
    );
  }
}
