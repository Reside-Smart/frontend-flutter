import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/FirebaseService.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({super.key});
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

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
      actions: [
        // Then in your build method, add a badge to the notifications icon
        Obx(
          () => Badge(
            isLabelVisible: _firebaseService.unreadCount.value > 0,
            label: Text(
              _firebaseService.unreadCount.value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: Icon(Icons.notifications),
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // Standard AppBar height
}
