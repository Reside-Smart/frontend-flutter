import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Widgets/MyHomeListingCard.dart';
import 'package:reside_smart_flutter/Controllers/SearchController.dart'
    as search_controller;
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = Get.find<search_controller.SearchController>();

  Future<void> _onRefresh() {
    return searchController.search();
  }

  @override
  void initState() {
    super.initState();
    searchController.loadCategories();
    searchController.search();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Search'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => searchController.query.value = v,
                    onSubmitted: (_) => searchController.search(),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    Get.toNamed('/filter');
                  },
                ),
              ],
            ),
          ),

          Obx(() {
            if (searchController.isCatLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: searchController.selectedCategory.value == null,
                    onSelected: (_) {
                      searchController.selectedCategory.value = null;
                      searchController.search();
                    },
                    side: BorderSide.none,
                    selectedColor: (cs.primary),
                  ),
                  const SizedBox(width: 8),
                  ...searchController.categories.map((cat) {
                    final sel = searchController.selectedCategory.value == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: sel,
                        onSelected: (_) {
                          searchController.selectedCategory.value =
                              sel ? null : cat;
                          searchController.search();
                        },
                        side: BorderSide.none,
                        selectedColor: (cs.primary),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (searchController.results.isEmpty) {
                return const Center(child: Text('No results.'));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      text: TextSpan(
                        style: tt.bodyLarge,
                        children: [
                          const TextSpan(text: 'Found '),
                          TextSpan(
                            text: '${searchController.results.length}',
                            style: tt.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const TextSpan(text: ' estates'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,

                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: searchController.results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder:
                              (ctx, i) => MyHomeListingCard(
                                listingModel: searchController.results[i],
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
