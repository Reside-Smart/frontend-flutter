import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/ReviewService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class AddReviews extends StatefulWidget {
  const AddReviews({super.key});

  @override
  State<AddReviews> createState() => _AddReviewsState();
}

class _AddReviewsState extends State<AddReviews> {
  final ReviewsService reviewsService = Get.find<ReviewsService>();

  double rating = 0.0;
  bool hasRated = false;
  List<String> userReviewTexts = [];

  final TextEditingController reviewController = TextEditingController();
  final int listingId = Get.arguments['listingId'];

  @override
  void initState() {
    super.initState();
    fetchUserRating();
    fetchUserReviews();
  }

  Future<void> fetchUserRating() async {
    final result = await reviewsService.fetchRating(listingId);
    if (result != null) {
      setState(() {
        rating = result;
        hasRated = true;
      });
    }
  }

  Future<void> fetchUserReviews() async {
    userReviewTexts = await reviewsService.fetchUserReviews(listingId);
    setState(() {});
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Add Review'),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchUserRating();
          fetchUserReviews();
        },

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello, how was your overall experience?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: rating,
                min: 0,
                max: 5,
                divisions: 50,
                label: rating.toStringAsFixed(1),
                onChanged:
                    hasRated
                        ? null
                        : (value) {
                          setState(() {
                            rating = value;
                          });
                        },
              ),
              const SizedBox(height: 35),
              const Text(
                'Write your experience in here',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reviewController,
                maxLines: 5,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Describe your experience...',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    reviewsService.addRating(
                      rating: rating,
                      listingId: listingId,
                    );
                    reviewsService.addReview(
                      text: reviewController.text,
                      listingId: listingId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 24),
              if (userReviewTexts.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Your Previous Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children:
                      userReviewTexts
                          .map(
                            (text) => Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'You',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            text,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
