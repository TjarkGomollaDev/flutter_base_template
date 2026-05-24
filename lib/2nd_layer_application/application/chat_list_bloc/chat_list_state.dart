part of 'chat_list_bloc.dart';

class ChatListState {
  final List<String> chatIDs;
  final List<ChatEntity> chats;
  final Map<String, UserContactInfoEntity> contactInfos;

  ChatListState._({
    required this.chatIDs,
    required this.chats,
    required this.contactInfos,
  });

  factory ChatListState.initial() {
    return ChatListState._(
      chatIDs: [],
      chats: [],
      contactInfos: {},
    );
  }

  ChatListState copyWith({
    List<String>? chatIDs,
    List<ChatEntity>? chats,
    Map<String, UserContactInfoEntity>? contactInfos,
  }) {
    return ChatListState._(
      chats: chats ?? this.chats,
      contactInfos: contactInfos ?? this.contactInfos,
      chatIDs: chatIDs ?? this.chatIDs,
    );
  }
}
