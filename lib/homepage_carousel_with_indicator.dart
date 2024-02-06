import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ten_mins_five_ingredients/recipe_detail.dart';

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({super.key});

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  // Data for the images, names, likes, and scores
  final List<Map<String, dynamic>> _recipeData = [
    {
      'image': 'tomatoes_and_burrata.jpg',
      'name': 'Tomatoes & Burrata',
      'likes': 273,
      'score': 4.8
    },
    { 'image': 'omelet.jpg',
      'name': 'Omelet',
      'likes': 209,
      'score': 4.6
    },
    {
      'image': 'hummus_veggie_wrap.jpg',
      'name': 'Hummus Veggie Wrap',
      'likes': 166,
      'score': 4.4
    },
  ];

  // hearts showing scores
  List<Widget> buildHearts(double score) {
    List<Widget> hearts = [];
    int fullHearts = score.round();
    for (int i = 0; i < fullHearts; i++) {
      hearts.add(const Icon(Icons.favorite, color: Colors.red));
    }
    for (int i = fullHearts; i < 5; i++) {
      hearts.add(const Icon(Icons.favorite_border, color: Colors.red));
    }
    return hearts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider.builder(
        itemCount: _recipeData.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          var recipe = _recipeData[itemIndex];
          return GestureDetector(
            onTap: () {
              // Navigate to the recipe details page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipeDetail()),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Image.asset(
                      'assets/images/${recipe['image']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    recipe['name'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...buildHearts(recipe['score']),
                      Text(' (${recipe['likes']})'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        carouselController: _controller,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 2),
          enlargeCenterPage: true,
          aspectRatio: 3 / 4,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _recipeData.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == entry.key
                    ? const Color(0xFFF4C2C2) // Active dot
                    : Colors.grey, // Inactive dot
              ),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
