import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_screen/widgets/body.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_screen/widgets/chat_app_bar.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_screen/widgets/chat_typing_area.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: ChatAppBar(),
      body: ChatBody(),
      bottomNavigationBar: ChatTypingArea(),
    );
  }
}
