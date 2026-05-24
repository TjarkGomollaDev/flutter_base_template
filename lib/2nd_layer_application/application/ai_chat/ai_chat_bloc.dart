import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/ai_chat_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/ai_message_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_ai_chat_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_chatbot_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';
import 'package:flutter_base_template/core/errors/ai_chat_errors.dart';
import 'package:flutter_base_template/core/errors/chatbot_errors.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final InterfaceAiChatRepository _aiChatRepository;
  final InterfaceUserRepository _userRepository;
  final InterfaceChatbotRepository _chatbotRepository;
  StreamSubscription<List<AiMessageEntity>>? _streamSubscription;

  AiChatBloc({
    required InterfaceAiChatRepository aiChatRepository,
    required InterfaceUserRepository userRepository,
    required InterfaceChatbotRepository chatbotRepository,
  })  : _aiChatRepository = aiChatRepository,
        _userRepository = userRepository,
        _chatbotRepository = chatbotRepository,
        super(AiChatState.initial()) {
    on<AiChatEventUpdateTextfield>(_onUpdateTextfield);
    on<AiChatEventSendMessage>(_onSendMessage);
    on<AiChatEventRequestSuccessful>(_onRequestSuccessful);
    on<AiChatEventRegenerate>(_onRegenerate);
    on<_AiChatEventDeleteMessageInBloc>(_onDeleteMessageInBloc);
    on<_AiChatEventStreamMessagesUpdated>(_onStreamMessagesUpdated);
    on<AiChatEventOpenChat>(_onOpenChat);
    add(AiChatEventOpenChat());
  }

  void _onUpdateTextfield(AiChatEventUpdateTextfield event, Emitter<AiChatState> emit) {
    if (event.textfield.trim().isEmpty) {
      emit(state.copyWith(textfield: event.textfield, flag: AiChatFlag.initial));
    } else {
      emit(state.copyWith(textfield: event.textfield, flag: AiChatFlag.readyToSent));
    }
  }

  Future<void> _onSendMessage(AiChatEventSendMessage event, Emitter<AiChatState> emit) async {
    emit(state.copyWith(flag: AiChatFlag.submitting));
    // create user message
    final messageUser = AiMessageEntity.newAiMessage(message: state.textfield, isMyMessage: true);
    // create prompt with context of last messages
    final context = _prepareContextMessages(messageUser);
    try {
      // store user message
      await _storeMessageWithHandling(
        aiMessageEntity: messageUser,
        aiChatID: state.aiChatID,
        onError: ErrorAiChatStoreUserMessage(),
      );
      // create init chatbot message
      final messageChatbotInit = AiMessageEntity.newAiMessage(message: '', isMyMessage: false);
      //emit(state.copyWith(lastChatbotMessageID: messageChatbotInit.messageID));
      // store init chatbot message
      await _storeMessageWithHandling(
        aiMessageEntity: messageChatbotInit,
        aiChatID: state.aiChatID,
        onError: ErrorAiChatStoreChatbotMessageInit(),
      );
      try {
        // request to chatbot api
        //throw ErrorChatbotRequest();
        final answer = await _chatbotRepository.chatbotRequest(context: context);
        // create updated chatbot message
        final messageChatbotUpdated = messageChatbotInit.updateMessageWithTimestamp(answer);
        // store updated chatbot message
        await _storeMessageWithHandling(
          aiMessageEntity: messageChatbotUpdated,
          aiChatID: state.aiChatID,
          onError: ErrorAiChatStoreChatbotMessageUpdated(),
          update: true,
        );
        // SUCCESS
        // we stay in the submitting state until the chatbot answer with animation is fully rendered in the ui and an event is triggered that everything was successful
      } on ErrorChatbotRequest catch (_) {
        //throw Error();
        // create failed chatbot message
        final messageChatbotFailed = messageChatbotInit.updateMessageWithTimestamp('error');
        // store failed chatbot message
        await _storeMessageWithHandling(
          aiMessageEntity: messageChatbotFailed,
          aiChatID: state.aiChatID,
          onError: ErrorAiChatStoreChatbotMessageFailed(),
          update: true,
        );
        emit(state.copyWith(flag: AiChatFlag.initial, textfield: '', toAnimateMessageID: ''));
      }
    } on ErrorAiChatStoreUserMessage catch (_) {
    } on ErrorAiChatStoreChatbotMessageInit catch (_) {
    } on ErrorAiChatStoreChatbotMessageUpdated catch (_) {
    } on ErrorAiChatStoreChatbotMessageFailed catch (_) {
    } catch (e) {
      emit(state.copyWith(flag: AiChatFlag.initial, textfield: '', toAnimateMessageID: ''));
      log(e.toString());
    }
  }

  Future<void> _storeMessageWithHandling({
    required AiMessageEntity aiMessageEntity,
    required String aiChatID,
    required Error onError,
    bool update = false,
  }) async {
    try {
      if (update) {
        await _aiChatRepository.updateMessageInAiChat(
            aiMessageEntity: aiMessageEntity, aiChatID: aiChatID);
      } else {
        await _aiChatRepository.storeMessageInAiChat(
            aiMessageEntity: aiMessageEntity, aiChatID: aiChatID);
      }
    } catch (_) {
      throw onError;
    }
  }

  List<AiMessageEntity> _prepareContextMessages(AiMessageEntity newMessage) {
    // cache chat as it is at this very moment to avoid possible synchronization problems with the database
    final messages = state.messages;
    // create a sublist with a maximum of 5 of the last messages to give the chatbot context in addition to the actual prompt
    final numberLastMessages = messages.length < 5 ? messages.length : 5;
    final contextMessages = messages.sublist(messages.length - numberLastMessages);
    // add actual prompt to the sublist
    contextMessages.add(newMessage);
    return contextMessages;
  }

  List<AiMessageEntity> _prepareContextMessagesOnRegenerate(String referenceMessageID) {
    // cache chat as it is at this very moment to avoid possible synchronization problems with the database
    final messages = state.messages;
    final index = messages.indexWhere((message) => message.messageID == referenceMessageID);
    // should not happen
    if (index == -1) return [];
    // calculate the start index to get the last 6 messages before the reference message
    final start = (index - 6) < 0 ? 0 : index - 6;
    // create a sublist containing the messages from start to exclusive index
    final contextMessages = messages.sublist(start, index);
    return contextMessages;
  }

  void _onDeleteMessageInBloc(_AiChatEventDeleteMessageInBloc event, Emitter<AiChatState> emit) {
    // cache chat as it is at this very moment to avoid possible synchronization problems with the database
    final messages = state.messages;
    final index = messages.indexWhere((message) => message.messageID == event.aiMessageID);
    // should not happen
    if (index == -1) return;
    messages.removeAt(index);
    emit(state.copyWith(messages: messages));
  }

  Future<void> _deleteMessageInDatabase(
      {required String aiMessageID, required String aiChatID}) async {
    try {
      await _aiChatRepository.deleteMessageInAiChat(aiMessageID: aiMessageID, aiChatID: aiChatID);
    } on ErrorAiChatDeleteMessage catch (_) {
    } catch (e) {
      log(e.toString());
    }
  }

  void _onRequestSuccessful(AiChatEventRequestSuccessful event, Emitter<AiChatState> emit) {
    emit(state.copyWith(flag: AiChatFlag.initial, textfield: '', toAnimateMessageID: ''));
  }

  Future<void> _onRegenerate(AiChatEventRegenerate event, Emitter<AiChatState> emit) async {
    emit(state.copyWith(flag: AiChatFlag.submitting));
    final context = _prepareContextMessagesOnRegenerate(event.regnerateMessage.messageID);
    // reset chatbot message to init
    final messageChatbotInit = event.regnerateMessage.updateMessageWithoutTimestamp('');
    //emit(state.copyWith(lastChatbotMessageID: messageChatbotInit.messageID));
    try {
      // store init chatbot message
      await _storeMessageWithHandling(
        aiMessageEntity: messageChatbotInit,
        aiChatID: state.aiChatID,
        onError: ErrorAiChatStoreChatbotMessageInit(),
        update: true,
      );
      try {
        Future.delayed(Duration(seconds: 4));
        //throw Error();
        // request to chatbot api
        final answer = await _chatbotRepository.chatbotRequest(context: context);
        // create updated chatbot message
        final messageChatbotUpdated = messageChatbotInit.updateMessageWithTimestamp(answer);
        // store updated chatbot message
        await _storeMessageWithHandling(
          aiMessageEntity: messageChatbotUpdated,
          aiChatID: state.aiChatID,
          onError: ErrorAiChatStoreChatbotMessageUpdated(),
          update: true,
        );
        // SUCCESS
        // we stay in the submitting state until the chatbot answer with animation is fully rendered in the ui and an event is triggered that everything was successful
      } catch (_) {
        //throw ErrorAiChatStoreChatbotMessageFailed();
        // create failed chatbot message
        final messageChatbotFailed = messageChatbotInit.updateMessageWithoutTimestamp('error');
        // store failed chatbot message
        await _storeMessageWithHandling(
          aiMessageEntity: messageChatbotFailed,
          aiChatID: state.aiChatID,
          onError: ErrorAiChatStoreChatbotMessageFailed(),
          update: true,
        );
        emit(state.copyWith(flag: AiChatFlag.initial, toAnimateMessageID: ''));
      }
    } on ErrorAiChatStoreChatbotMessageInit catch (_) {
      emit(state.copyWith(flag: AiChatFlag.initial, toAnimateMessageID: ''));
    } on ErrorAiChatStoreChatbotMessageFailed catch (_) {
      add(_AiChatEventDeleteMessageInBloc(aiMessageID: event.regnerateMessage.messageID));
      // nachricht lokal im bloc löschen
      // todo id speichern im bloc in einer liste
      // todo in der onUpdate methode prüfen, ob die liste leer ist, sonst versuchen, diese messages in der db zu löschen
      emit(state.copyWith(flag: AiChatFlag.initial, toAnimateMessageID: ''));
    } catch (e) {
      emit(state.copyWith(flag: AiChatFlag.initial, toAnimateMessageID: ''));
      log(e.toString());
    }
  }

  void _onStreamMessagesUpdated(
      _AiChatEventStreamMessagesUpdated event, Emitter<AiChatState> emit) {
    // if there is a new init message from the chatbot or an old chatbot failed message has been regenerated, toAnimateMessageID should also be set
    if ((!event.messages.last.isMyMessage && event.messages.last.message.isEmpty) ||
        (state.messages.isNotEmpty &&
            !event.messages.last.isMyMessage &&
            event.messages.last.message.isNotEmpty &&
            state.messages.last.messageID != event.messages.last.messageID)) {
      emit(state.copyWith(
          messages: event.messages, toAnimateMessageID: event.messages.last.messageID));
    } else {
      emit(state.copyWith(messages: event.messages));
    }
  }

  Future<void> _onOpenChat(AiChatEventOpenChat event, Emitter<AiChatState> emit) async {
    emit(state.copyWith(flag: AiChatFlag.loadingChat));
    try {
      // check if an ai chat already exists
      String? aiChatID = await _userRepository.isAnyAiChatExisting(
          userID: sl<InterfaceAuthRepository>().currentAuthUser.id);
      if (aiChatID == null) {
        // create new ai chat
        final newAiChat = AiChatEntity.newAiChat();
        // store in ai chat repository
        await _aiChatRepository.initNewAiChat(aiChatEntity: newAiChat);
        // set reference in user repository
        aiChatID = newAiChat.chatID;
        await _userRepository.addNewAiChat(
          aiChatID: aiChatID,
          userID: sl<InterfaceAuthRepository>().currentAuthUser.id,
        );
      }
      // start stream subscription to load chat
      _streamSubscription = _aiChatRepository.streamAiChatMessages(aiChatID: aiChatID).listen(
        (messages) {
          add(_AiChatEventStreamMessagesUpdated(messages: messages));
        },
      );
      emit(state.copyWith(flag: AiChatFlag.initial, aiChatID: aiChatID));
    } catch (_) {
      emit(state.copyWith(flag: AiChatFlag.errorLoadingChat));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}


// falls wir eine nachricht löschen, müssen wir falls es eine regnerate nachricht danach gibt, diese auch lösche
// bei submitting muss regnerate button deaktiviert sein