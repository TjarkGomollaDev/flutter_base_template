import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_screen/widgets/message_input_field.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class ChatTypingArea extends StatelessWidget {
  const ChatTypingArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 11,
        ),
        child: Container(
          color: AppTheme.white.withAlpha(230),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.SPACE_HORIZONTAL_S,
            ).copyWith(top: 5),
            child: SafeArea(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppTheme.grayLight5,
                    child: Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 142, 142, 147),
                    ),
                  ),
                  AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                  const MessageInputField(),
                  IconButton(
                    onPressed: () => context.read<ChatBloc>().add(ChatEventSendTextMessage()),
                    icon: const Icon(Icons.send),
                    color: const Color.fromARGB(255, 142, 142, 147),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
