import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    _textController.text = context.watch<ChatBloc>().state.userInput;
    return Expanded(
      child: TextField(
        controller: _textController,
        onChanged: (value) =>
            context.read<ChatBloc>().add(ChatEventUpdateUserInputMessage(message: value)),
        autocorrect: false,
        textAlignVertical: TextAlignVertical.center,
        style: textTheme.bodyLarge,
        cursorColor: AppTheme.black,
        decoration: InputDecoration(
          hintText: 'Message',
          fillColor: AppTheme.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.SPACE_HORIZONTAL_L),
          // enabledBorder: AppTheme.enabledChatBorderLight,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: AppTheme.grayLight3),
          ),
        ),
      ),
    );
  }
}
