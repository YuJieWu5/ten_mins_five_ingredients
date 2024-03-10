import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/recipe.dart';


class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({super.key});

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final ref = FirebaseDatabase.instance.ref();
  List<dynamic>? saveListId;
  List<Map<String, dynamic>> _recipesList = [];
  Future<List<dynamic>>? _futureRecipesList;

  @override
  void initState(){
    super.initState();
    _futureRecipesList = readDatabase();
  }

  Future<List<dynamic>> readDatabase() async {
    final snapshot = await ref.child('recipes/').get();
    _recipesList.clear();
    if (snapshot.exists) {
      String dataString = jsonEncode(snapshot.value);
      Map dataMap = jsonDecode(dataString);

      for (var recipe in dataMap.entries) {
        // if (saveListId!.contains(recipe.key)) {
          // _recipesList.add(recipe.value);
          try {
            // Upload the file
            Reference storageReference = FirebaseStorage.instance.ref().child(recipe.value['image']);

            // Optionally, if you want the file URL after the upload completes
            final String downloadUrl = await storageReference.getDownloadURL();
            recipe.value['image'] = downloadUrl;
            recipe.value['id'] = recipe.key;
            _recipesList.add(recipe.value);
            // print('Download URL: $downloadUrl');
          } catch (e) {
            print(e); // Handle errors
          }
        // }
      }
      _recipesList.sort((a, b) => b['rating'].compareTo(a['rating']));
      if (_recipesList.length > 3) {
        _recipesList = _recipesList.sublist(0, 3);
      }
    } else {
      print('No data available.');
    }

    return _recipesList;
  }

  void openRecipeDetail(Map<String, dynamic> recipe, BuildContext context) async {
    final reLoadPage = await GoRouter.of(context).push('/recipeDetail', extra: Recipe.fromJson(recipe));
    if (reLoadPage as bool) {
      setState(() {});
    }
  }

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
      FutureBuilder<List<dynamic>>(
        future: _futureRecipesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final recipes = snapshot.data!;
            return Column(
              children: [
                CarouselSlider.builder(
                  itemCount: recipes.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    var recipe = _recipesList[itemIndex];
                    return GestureDetector(
                      onTap: () {
                        openRecipeDetail(recipe, context);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              recipe['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              recipe['title'],
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
                                ...buildHearts(recipe['rating'].toDouble()),
                                Text(' (${recipe['rating-count']})'),
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
                  children: recipes.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
              ],
            );
          } else {
            return Text('No data available.');
          }
        },
      ),
    ]);
  }
}
