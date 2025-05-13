import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Container(
                  width: 48, // Slightly larger avatar
                  height: 48,
                  child:
                      authService.globalUser?.image == null
                          ? CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: MyNetworkImage(
                              url: "storage/${authService.globalUser?.image}",
                            ),
                          ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.all(21)),
                    Text(
                      authService.globalUser!.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      authService.globalUser!.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.house_rounded),
            title: Text("Listing"),
            onTap: () {
              Get.toNamed('listing');
            },
          ),
          ListTile(
            leading: Icon(Icons.discount),
            title: Text("Discount"),
            onTap: () {
              Get.toNamed('discount');
            },
          ),

          ListTile(
            leading: Icon(Icons.assignment),
            title: Text("Transaction"),
            onTap: () {
              // Handle action
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: () {
              // Handle action
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text("Chatbot"),
            onTap: () {
              // Handle action
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              AppDialog.showConfirm(
                title: "Logout",
                message: "Are you sure you want to logout?",
                onConfirm: () {
                  Get.find<AuthService>().logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
