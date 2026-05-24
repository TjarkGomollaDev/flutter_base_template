part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

// input fields
class ChatEventUpdateUserInputMessage extends ChatEvent {
  final String message;

  ChatEventUpdateUserInputMessage({required this.message});
}

// buttons
class ChatEventSendTextMessage extends ChatEvent {}

class ChatEventSendVoiceMessage extends ChatEvent {}

class ChatEventSendFile extends ChatEvent {}

// state is set up for a specific chat
class ChatEventOpenChat extends ChatEvent {
  final String chatID;
  final String senderID;

  ChatEventOpenChat({
    required this.chatID,
    required this.senderID,
  });
}

// close the chat and reset state to initial
class ChatEventCloseChat extends ChatEvent {}

// intern triggered events
class _ChatEventStreamChatMessagesUpdated extends ChatEvent {
  final List<MessageEntity> newMessages;

  _ChatEventStreamChatMessagesUpdated({required this.newMessages});
}
