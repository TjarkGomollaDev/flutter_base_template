part of 'chat_bloc.dart';

class ChatState {
  final DoublyLinkedList<MessageEntity> messages;
  final String userInput;
  final String chatID;
  final String senderID;
  final bool isMessageValid;
  final int counter;

  const ChatState._({
    required this.messages,
    required this.userInput,
    required this.chatID,
    required this.senderID,
    required this.isMessageValid,
    required this.counter,
  });

  factory ChatState.initial() {
    return ChatState._(
      messages: DoublyLinkedList(),
      userInput: '',
      chatID: '',
      senderID: '',
      isMessageValid: false,
      counter: 0,
    );
  }

  ChatState copyWith({
    DoublyLinkedList<MessageEntity>? messages,
    String? userInput,
    String? chatID,
    String? senderID,
    bool? isMessageValid,
    int? counter,
  }) {
    return ChatState._(
      messages: messages ?? this.messages,
      userInput: userInput ?? this.userInput,
      chatID: chatID ?? this.chatID,
      senderID: senderID ?? this.senderID,
      isMessageValid: isMessageValid ?? this.isMessageValid,
      counter: counter ?? this.counter,
    );
  }
}
