import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Widgets/MyHomeListingCard.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Controllers/FilterController.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late final FilterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(FilterController());
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyMainAppBar(title: 'Filter'),
      body: Obx(() {
        if (_controller.isCatLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .05, vertical: 16),
          child: ListView(
            children: [
              const Text(
                "Search",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                onChanged: (value) => _controller.searchQuery.value = value,
                decoration: const InputDecoration(
                  hintText: 'Enter search term',
                ),
              ),
              const Divider(height: 30),

              const Text(
                "Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children:
                    ['sell', 'rent'].map((t) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(t.capitalizeFirst!),
                          value: t,
                          groupValue: _controller.selectedType.value,
                          onChanged: (val) {
                            _controller.selectedType.value = val!;
                          },
                        ),
                      );
                    }).toList(),
              ),
              const Divider(height: 30),

              const Text(
                "Price range",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RangeSlider(
                values: _controller.priceRange.value,
                min: 0,
                max: 10000,
                divisions: 20,
                labels: RangeLabels(
                  '\$${_controller.priceRange.value.start.round()}',
                  '\$${_controller.priceRange.value.end.round()}',
                ),
                onChanged: (r) {
                  _controller.priceRange.value = r;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_controller.priceRange.value.start.round()}'),
                    Text('\$${_controller.priceRange.value.end.round()}'),
                  ],
                ),
              ),
              const Divider(height: 30),

              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._controller.categories.map((cat) {
                final isSelected = _controller.selectedCategories.contains(
                  cat.id,
                );
                return CheckboxListTile(
                  title: Text(cat.name),
                  value: isSelected,
                  onChanged: (bool? checked) {
                    if (checked == true) {
                      _controller.selectedCategories.add(cat.id);
                    } else {
                      _controller.selectedCategories.remove(cat.id);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
              const Divider(height: 40),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _controller.isLoading.value
                              ? null
                              : () => _controller.applyFilter(),
                      child:
                          _controller.isLoading.value
                              ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Apply Now",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                    ),
                  ),
                ],
              ),

              Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (_controller.filteredResults.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "Results:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children:
                            _controller.filteredResults.map((l) {
                              return SizedBox(
                                width: 170,
                                height: 250,
                                child: MyHomeListingCard(listingModel: l),
                              );
                            }).toList(),
                      ),
                    ],
                  );
                } else if (_controller.isFilterApplied.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No such listing found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
