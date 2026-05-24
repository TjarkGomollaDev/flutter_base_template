import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/ai_chat/widgets/ai_chat_app_bar.dart';
import 'package:flutter_base_template/1st_layer_presentation/ai_chat/widgets/ai_chat_body.dart';
import 'package:flutter_base_template/1st_layer_presentation/ai_chat/widgets/ai_chat_typing_area.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AiChatAppBar(),
      body: AiChatBody(),
      bottomNavigationBar: AiChatTypingArea(),
    );
  }
}
