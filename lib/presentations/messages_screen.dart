import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:provider/provider.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/helpers/param.dart';
import 'package:sp_front/providers/auth_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<types.Message> _messages = [];
  late Timer _timer;
  late final _user;
  int userId = 0;
  int _userTo = 0;
  @override
  void initState() {
    context.read<AuthProvider>().loggedUser.firstName;
    userId = context.read<AuthProvider>().loggedUser.userId;
    _userTo = context.read<AuthProvider>().userSelected;
    _user = types.User(
      id: "$userId",
    );
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 2), (timer) async => _loadMessages());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final jsonMessage = {
      "fromUser": "$userId",
      "status": "sent",
      "text": message.text,
      "type": "text",
      "toUser": _userTo
    };
    await Api.post(Param.postSendMessage, jsonMessage);

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);

    await _audioPlayer.setAsset('assets/audio/message_sent2.mp3',
        initialPosition: const Duration(seconds: 0));
    await _audioPlayer.play();
  }

  Future<void> _loadMessages() async {
    final response = await Api.get("${Param.getMessages}/$_userTo",
        queryParameters: {"limit": 20});
    _messages.clear();
    response.forEach((e) {
      e['id'] = e['id'].toString();
      e['author']['id'] = e['author']['id'].toString();

      _messages.add(types.Message.fromJson(e));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          showUserNames: true,
          user: _user,
          l10n: const ChatL10nEs(),
          theme: DefaultChatTheme(
              primaryColor: Theme.of(context).primaryColorDark,
              secondaryColor: colorList[7],
              userAvatarNameColors: [Theme.of(context).primaryColor],
              inputBackgroundColor: Colors.white,
              inputTextColor: Colors.black,
              inputBorderRadius: BorderRadius.circular(50),
              inputContainerDecoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(50)))),
        ),
      ),
    );
  }
}




/*
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Foto'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Archivo'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }
  */