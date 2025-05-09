import 'package:flutter/material.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class ListingAllImages extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ListingAllImages({required this.images, this.initialIndex = 0});

  @override
  State<ListingAllImages> createState() => _ListingAllImagesState();
}

class _ListingAllImagesState extends State<ListingAllImages> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children:
                widget.images
                    .map(
                      (image) => MyNetworkImage(
                        url: "storage/$image",
                        fit: BoxFit.contain,
                      ),
                    )
                    .toList(),
          ),

          if (_currentIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.chevron_left, size: 40, color: Colors.white),
                  onPressed:
                      () => _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                ),
              ),
            ),

          if (_currentIndex < widget.images.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed:
                      () => _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                ),
              ),
            ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${widget.images.length}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
