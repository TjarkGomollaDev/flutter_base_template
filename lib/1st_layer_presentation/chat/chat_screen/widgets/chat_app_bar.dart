import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(95);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 11),
          child: Container(
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(color: AppTheme.grayLight4)),
              color: const Color.fromARGB(230, 235, 235, 235),
            ),
            child: Center(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      // Turn into a NetworkImage later
                      backgroundImage: AssetImage(
                        "assets/backgrounds/Tjark.jpeg",
                      ),
                    ),
                    10.heightSizedBox,
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tjark",
                          style: TextStyle(fontSize: 12, color: AppTheme.black),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 10,
                          color: AppTheme.grayDark2,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
