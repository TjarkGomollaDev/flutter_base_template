// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:mark_lxxxv/3rd_layer_domain/entities/ai_message_entity.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_chatbot_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mark_lxxxv/4th_layer_infrastructure/models/ai_message_model.dart';
import 'package:mark_lxxxv/core/errors/chatbot_errors.dart';

class ChatbotRepository implements InterfaceChatbotRepository {
  static const String _API_KEY =
      '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';
  static const String _API_URL = 'https://api.openai.com/v1/chat/completions';
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $_API_KEY",
  };

  @override
  Future<String> chatbotRequest({required List<AiMessageEntity> context}) async {
    try {
      final prompt = context
          .map(
            (aiMessageEntity) => AiMessageModel.fromDomain(aiMessageEntity).toOpenAi(),
          )
          .toList();

      final data = {
        'model': 'gpt-4o-mini',
        'messages': prompt,
      };
      final response =
          await http.post(Uri.parse(_API_URL), headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['message']['content'];
      }
      throw ErrorChatbotRequest();
    } on ErrorChatbotRequest catch (_) {
      rethrow;
    } catch (_) {
      throw ErrorChatbotRequest();
    }
  }
}
