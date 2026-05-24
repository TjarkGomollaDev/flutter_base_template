import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_router.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';

class ChatContainer extends StatelessWidget {
  final String chatID;
  final String message;
  final String username;
  final DateTime timeSent;
  final int countNewMessages;

  const ChatContainer({
    super.key,
    required this.chatID,
    required this.message,
    required this.username,
    required this.timeSent,
    required this.countNewMessages,
  });

  @override
  Widget build(BuildContext context) {
    const double rowPaddingTop = 8;
    return GestureDetector(
      // go to the chat window of that current chat
      onTap: () {
        context.read<ChatBloc>().add(
              ChatEventOpenChat(
                chatID: chatID,
                senderID: context.read<AuthBloc>().state.user.id,
              ),
            );
        Navigator.pushNamed(context, RouteNames.CHAT);
      },
      child: SizedBox(
        height: 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  top: rowPaddingTop,
                  left: AppConstants.PAGE_PADDING_HORIZONTAL,
                  right: AppConstants.SPACE_HORIZONTAL_S,
                ),
                child: CircleAvatar(
                  radius: 24,
                  // Network Image
                  backgroundImage: AssetImage("assets/backgrounds/Tjark.jpeg"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.grayLight6),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: rowPaddingTop),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        message,
                        style: const TextStyle(color: AppTheme.grayLight1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.grayLight6),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: rowPaddingTop),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(timeSent),
                          style: const TextStyle(color: AppTheme.grayLight1),
                        ),
                        12.widthSizedBox,
                        const Padding(
                          padding: EdgeInsets.only(right: 14.0),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: AppTheme.grayLight3,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    if (countNewMessages != 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 20,
                            width: countNewMessages >= 10 ? 25 : 20, //! Switch case für höhere Zahlen bis 999+
                            color: AppTheme.blueLight,
                            child: Center(
                              child: Text(
                                countNewMessages.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
