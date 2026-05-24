import 'package:flutter_base_template/3rd_layer_domain/entities/user_application_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/user_contact_info_entity.dart';

abstract class InterfaceUserRepository {
  Future<bool> isUserDocumentExisting({required String userID});

  Future<void> initUserDocument({required UserApplicationEntity applicationUserEntity});

  Future<void> loadCurrrentUserContactInfo({required String userID});

  Future<UserContactInfoEntity> getContactInfo({required String userID});

  Stream<List<String>> streamChatIDs({required String userID});

  // current User info
  UserContactInfoEntity get currentUserContactInfo;

  // ai chats
  Future<String?> isAnyAiChatExisting({required String userID});
  Future<void> addNewAiChat({required String aiChatID, required String userID});
}
