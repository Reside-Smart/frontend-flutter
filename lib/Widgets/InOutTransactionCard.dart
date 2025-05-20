import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class InOutTransactionCard extends StatefulWidget {
  final int id;
  final String image;
  final String name;
  final String transactionType;

  const InOutTransactionCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.transactionType,
  });

  @override
  State<InOutTransactionCard> createState() => _InOutTransactionCardState();
}

class _InOutTransactionCardState extends State<InOutTransactionCard> {
  final AuthService authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/view-single-transactions', arguments: {'id': widget.id});
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 170,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: MyNetworkImage(
                      url: "storage/${widget.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "For ${widget.transactionType}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
