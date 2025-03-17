import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

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
                    color:
                        Theme.of(
                          context,
                        ).primaryColor, // Primary color background
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white, // Icon color set to white
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              )
              : null,
      elevation: 3,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text(
        'ResideSmart',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // Standard AppBar height
}
