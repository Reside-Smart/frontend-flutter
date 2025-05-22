import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ReviewModel.dart';
import 'package:reside_smart_flutter/Models/RatingModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/ReviewService.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class ViewAllReviews extends StatefulWidget {
  const ViewAllReviews({super.key});

  @override
  State<ViewAllReviews> createState() => _ViewAllReviewsState();
}

class _ViewAllReviewsState extends State<ViewAllReviews> {
  final ReviewsService reviewsService = Get.find<ReviewsService>();
  final AuthService authService = Get.find<AuthService>();

  List<ReviewModel> reviewTexts = [];
  Map<int, double> userRatings = {};
  bool isLoading = true;

  final int listingId = Get.arguments['listingId'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String formatReviewDate(String? dateStr) {
    if (dateStr == null) return '';

    final reviewDate = DateTime.tryParse(dateStr);
    if (reviewDate == null) return '';

    final now = DateTime.now();
    final difference = now.difference(reviewDate).inDays;

    if (difference == 0 && now.day == reviewDate.day) {
      return 'Today';
    } else if (difference <= 1 &&
        now.subtract(const Duration(days: 1)).day == reviewDate.day) {
      return 'Yesterday';
    } else {
      return '${reviewDate.year}-${reviewDate.month.toString().padLeft(2, '0')}-${reviewDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    await fetchUserRatings();
    await fetchReviews();

    setState(() => isLoading = false);
  }

  Future<void> fetchUserRatings() async {
    final List<RatingModel> ratings = await reviewsService.fetchAllRatings(
      listingId,
    );
    userRatings = {for (var rating in ratings) rating.userId!: rating.rating!};
  }

  Future<void> fetchReviews() async {
    reviewTexts = await reviewsService.fetchAllReviews(listingId);
    setState(() {});
  }

  List<Widget> buildStarIcons(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
      } else if (rating >= i - 0.5) {
        stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
      } else {
        stars.add(const Icon(Icons.star_border, size: 16, color: Colors.amber));
      }
    }
    return stars;
  }

  Map<int, List<ReviewModel>> groupReviewsByUser(List<ReviewModel> reviews) {
    final Map<int, List<ReviewModel>> grouped = {};
    for (var review in reviews) {
      final userId = review.user?.id ?? 0;
      if (!grouped.containsKey(userId)) {
        grouped[userId] = [];
      }
      grouped[userId]!.add(review);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedReviews = groupReviewsByUser(reviewTexts);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Reviews'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviewTexts.isEmpty
                ? Center(
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        groupedReviews.entries.map((entry) {
                          final userId = entry.key;
                          final userReviews = entry.value;
                          final firstReview = userReviews[0];
                          final userRating = userRatings[userId] ?? 0.0;

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  userReviews[0].user?.image != null &&
                                          userReviews[0].user!.image!.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: MyNetworkImage(
                                            url:
                                                "storage/${userReviews[0].user!.image!}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.account_circle,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  userReviews[0].user?.id ==
                                                          authService
                                                              .globalUser
                                                              ?.id
                                                      ? 'You'
                                                      : userReviews[0]
                                                              .user
                                                              ?.name ??
                                                          'Unknown',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  formatReviewDate(
                                                    userReviews[0].createdAt,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                ...buildStarIcons(userRating),
                                                const SizedBox(width: 6),
                                                Text(
                                                  userRating.toStringAsFixed(1),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              userReviews.asMap().entries.map((
                                                entry,
                                              ) {
                                                final index = entry.key;
                                                final review = entry.value;
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      review.text ?? '',
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (index !=
                                                        userReviews.length - 1)
                                                      const Divider(
                                                        thickness: 0.5,
                                                        color: Colors.grey,
                                                        height: 16,
                                                      ),
                                                  ],
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
      ),
    );
  }
}
