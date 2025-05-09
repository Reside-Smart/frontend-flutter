import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyDrawer.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;
  final AuthService authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  @override
  Widget build(BuildContext context) {
    print("storage/${authService.globalUser?.image}");
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: Colors.black), // Ensure icons are black
        automaticallyImplyLeading: false,

        actions: [
          Builder(
            builder:
                (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(
                      context,
                    ).openDrawer(); // Open drawer when tapped
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 15,
                    ), // Add spacing from right
                    padding: EdgeInsets.all(10), // Increase tap area
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // Gray background
                      shape: BoxShape.circle, // Circular background
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ), // Black icon
                  ),
                ),
          ),
        ],
      ),
      drawer: MyDrawer(authService: authService),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      child:
                          authService.globalUser?.image != null
                              ? isLoading.value
                                  ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                  : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MyNetworkImage(
                                      url:
                                          "storage/${authService.globalUser?.image}",
                                    ),
                                  )
                              : Icon(Icons.person, size: 90),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                authService.globalUser!.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                authService.globalUser!.email,
                style: TextStyle(color: Color.fromARGB(255, 41, 40, 40)),
              ),
              SizedBox(height: 30),
              Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 0
                                  ? Colors.white
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Account",
                          style: TextStyle(
                            color:
                                selectedTab == 0
                                    ? Colors.black
                                    : const Color.fromARGB(255, 81, 81, 81),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 1
                                  ? Colors.white
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            color:
                                selectedTab == 1
                                    ? Colors.black
                                    : const Color.fromARGB(255, 81, 81, 81),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              selectedTab == 0
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Get.toNamed('edit-profile');
                          },
                          icon: Icon(Icons.edit),
                          label: Text("Edit Profile"),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Get.toNamed('change-password');
                          },
                          icon: Icon(Icons.lock),
                          label: Text("Change Password"),
                        ),
                      ],
                    ),
                  )
                  : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "No analytics available",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
