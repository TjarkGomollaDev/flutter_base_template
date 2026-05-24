part of 'chat_list_bloc.dart';

@immutable
sealed class ChatListEvent {}

// intern triggered events
class ChatListEventStreamChatIDsUpdated extends ChatListEvent {
  final List<String> chatIDs;
  ChatListEventStreamChatIDsUpdated({required this.chatIDs});
}

class ChatListEventStreamChatsUpdated extends ChatListEvent {
  final List<ChatEntity> chats;
  ChatListEventStreamChatsUpdated({required this.chats});
}
