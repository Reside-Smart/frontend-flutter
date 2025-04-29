import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyMainAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.of(context).canPop();
    return AppBar(
      leading:
          canPop
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
              )
              : null,
      elevation: 3,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Text(title, style: TextStyle(color: Colors.black)),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
