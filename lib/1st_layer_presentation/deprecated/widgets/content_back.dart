import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';

class ContentBack extends StatelessWidget {
  const ContentBack({super.key});

  @override
  Widget build(BuildContext context) {
    // flip is needed to show the content on the backside correctly
    return Transform.flip(
      flipX: true,
      child: Column(
        children: [
          const Text('Das ist ein Test'),
          Center(
            child: QrImageView(
              data: sl<InterfaceAuthRepository>()
                  .currentAuthUser
                  .id, // Hier einen Link zum hinzufügen mit der ID hinterlegen
              version: QrVersions.auto,
              size: 100,
              dataModuleStyle: const QrDataModuleStyle(
                color: Colors.white,
                dataModuleShape: QrDataModuleShape.square,
              ),
              eyeStyle: const QrEyeStyle(
                color: Colors.white,
                eyeShape: QrEyeShape.square,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
