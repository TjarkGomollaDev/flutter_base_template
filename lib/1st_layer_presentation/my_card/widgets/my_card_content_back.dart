import 'package:flutter/material.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:mark_lxxxv/app_dependency_injection.dart';

class MyCardContentBack extends StatelessWidget {
  const MyCardContentBack({super.key});

  @override
  Widget build(BuildContext context) {
    // flip is needed to show the content on the backside correctly
    return Transform.flip(
      flipX: true,
      child: Stack(
        children: [
          // button
          Positioned(
            top: AppConstants.SPACE_VERTICAL_S,
            right: AppConstants.SPACE_HORIZONTAL_L,
            child: CoreLabelBtn(
              name: 'Back',
              color: AppTheme.white.withAlpha(38),
              textColor: AppTheme.white,
              callback: () {},
            ),
          ),
          // qr code
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.white,
                  width: 1.2,
                ),
              ),
              child: QrImageView(
                data: sl<InterfaceAuthRepository>()
                    .currentAuthUser
                    .id, // Hier einen Link zum hinzufügen mit der ID hinterlegen
                version: QrVersions.auto,
                size: 140,
                dataModuleStyle: const QrDataModuleStyle(
                  color: AppTheme.white,
                  dataModuleShape: QrDataModuleShape.square,
                ),
                eyeStyle: const QrEyeStyle(
                  color: AppTheme.white,
                  eyeShape: QrEyeShape.square,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
