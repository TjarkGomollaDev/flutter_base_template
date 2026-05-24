import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/chat/chat_screen/widgets/message_card.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/message_entity.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final ScrollController _scrollController;
  double hight = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.counter != current.counter,
      builder: (context, state) {
        final allMessages = state.messages;
        MessageEntity? previousMessage; // vllt noch weg
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          reverse: true,
          itemCount: allMessages.length,
          itemBuilder: (context, index) {
            debugPrint('RENDERING');
            final message = allMessages.at(index);
            previousMessage = index == 0 ? null : allMessages.at(index - 1);
            // final tempPreviousMessage = previousMessage;
            // previousMessage = message;
            return MessageCard(
              timeSent: message.timeSent,
              isSeen: true,
              message: message.message,
              messageType: message.messageType,
              isMyMessage: (message.senderID) == state.senderID,
              isSpeechBubble:
                  previousMessage == null ? true : message.senderID != previousMessage!.senderID,
            );
          },
        );
      },
    );
  }
}
