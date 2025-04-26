import 'package:get/get.dart';
import '../Views/HomePage.dart';
import '../Views/SearchPage.dart';
import '../Views/FavoritesPage.dart';
import '../Views/ProfilePage.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  final pages = [HomePage(), SearchPage(), FavoritesPage(), ProfilePage()];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
