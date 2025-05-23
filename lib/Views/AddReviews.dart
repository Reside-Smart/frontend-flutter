import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/ReviewService.dart';
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
  List<Map<String, dynamic>> userReviews = [];

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
    final result = await reviewsService.fetchUserReviewsWithIds(listingId);
    setState(() {
      userReviews = result;
    });
  }

  Future<void> deleteReview(int reviewId) async {
    await reviewsService.deleteReview(reviewId);
    fetchUserReviews();
  }

  Future<void> editReview(int reviewId, String newText) async {
    await reviewsService.editReview(reviewId: reviewId, newText: newText);
    fetchUserReviews();
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
          await fetchUserRating();
          await fetchUserReviews();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  onPressed: () async {
                    await reviewsService.addRating(
                      rating: rating,
                      listingId: listingId,
                    );
                    await reviewsService.addReview(
                      text: reviewController.text,
                      listingId: listingId,
                    );
                    reviewController.clear();
                    fetchUserReviews();
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
              if (userReviews.isNotEmpty) ...[
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
                      userReviews.map((review) {
                        print(review);
                        final int reviewId = review['id'];
                        final String reviewText = review['text'];
                        final String createdAt = review['created_at'];
                        final textController = TextEditingController(
                          text: reviewText,
                        );
                        bool isEditing = false;

                        final DateTime reviewDate = DateTime.parse(createdAt);
                        final DateTime now = DateTime.now();
                        final DateTime today = DateTime(
                          now.year,
                          now.month,
                          now.day,
                        );
                        final DateTime yesterday = today.subtract(
                          const Duration(days: 1),
                        );
                        final DateTime reviewDay = DateTime(
                          reviewDate.year,
                          reviewDate.month,
                          reviewDate.day,
                        );

                        String displayDate;
                        if (reviewDay == today) {
                          displayDate = 'Today';
                        } else if (reviewDay == yesterday) {
                          displayDate = 'Yesterday';
                        } else {
                          displayDate =
                              '${reviewDate.year}-${reviewDate.month.toString().padLeft(2, '0')}-${reviewDate.day.toString().padLeft(2, '0')}';
                        }

                        return StatefulBuilder(
                          builder: (context, localSetState) {
                            return Card(
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
                                          Row(
                                            children: [
                                              Text(
                                                'You',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                displayDate,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                    255,
                                                    124,
                                                    123,
                                                    123,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          isEditing
                                              ? TextField(
                                                controller: textController,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              : Text(
                                                reviewText,
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                    if (isEditing)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          editReview(
                                            reviewId,
                                            textController.text,
                                          );
                                          localSetState(
                                            () => isEditing = false,
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                        ),
                                      )
                                    else
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          localSetState(() => isEditing = true);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                        ),
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Delete Review',
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete this review?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deleteReview(reviewId);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
