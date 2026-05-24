part of 'ai_chat_bloc.dart';

enum AiChatFlag {
  loadingChat,
  errorLoadingChat,
  initial,
  readyToSent,
  submitting,
  // auslagern in attribute
  // errorSendingMessage,
  // errorRequest,
}

@immutable
class AiChatState {
  final AiChatFlag flag;
  final String textfield;
  final String aiChatID;
  final List<AiMessageEntity> messages;
  final String toAnimateMessageID;

  const AiChatState._({
    required this.flag,
    required this.textfield,
    required this.aiChatID,
    required this.messages,
    required this.toAnimateMessageID,
  });

  factory AiChatState.initial() {
    return AiChatState._(
      flag: AiChatFlag.initial,
      textfield: '',
      aiChatID: '',
      messages: [],
      toAnimateMessageID: '',
    );
  }

  AiChatState copyWith({
    AiChatFlag? flag,
    String? textfield,
    String? aiChatID,
    List<AiMessageEntity>? messages,
    String? toAnimateMessageID,
  }) {
    return AiChatState._(
      flag: flag ?? this.flag,
      textfield: textfield ?? this.textfield,
      aiChatID: aiChatID ?? this.aiChatID,
      messages: messages ?? this.messages,
      toAnimateMessageID: toAnimateMessageID ?? this.toAnimateMessageID,
    );
  }
}
