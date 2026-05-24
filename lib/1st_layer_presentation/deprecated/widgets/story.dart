import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';

class Story extends StatelessWidget {
  final int index;
  final String username;
  final String imagePath;

  const Story({
    super.key,
    required this.index,
    required this.imagePath,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: AppConstants.SPACE_HORIZONTAL_S,
          left: index == 0 ? AppConstants.PAGE_PADDING_HORIZONTAL : 0),
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            ClipOval(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: (84 - 5) / 2,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        imagePath,
                      ),
                      radius: (84 - 7) / 2,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              username,
              style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}
