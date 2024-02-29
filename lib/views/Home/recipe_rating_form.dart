import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';

class RecipeRatingForm extends StatefulWidget {
  final Recipe recipe;
  const RecipeRatingForm({super.key, required this.recipe});

  @override
  State<RecipeRatingForm> createState() => _RecipeRatingFormState();
}

class _RecipeRatingFormState extends State<RecipeRatingForm> {
  int _rating = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void _onSubmitPressed() async {
    //TODO: send the rating score to database
    if (!context.read<GlobalState>().getLoginStatus()) {
      return;
    }

    final snapshot = await ref.child('recipes/').get();
    if (snapshot.exists) {
      String dataString = jsonEncode(snapshot.value);
      Map dataMap = jsonDecode(dataString);
      String recipeId = _findRecipe(dataMap, widget.recipe.title);
      ref = FirebaseDatabase.instance.ref("recipes/$recipeId");

      //calculate new rating count and rating
      int ratingCount = widget.recipe.ratingCount + 1;
      double rate =
          ((widget.recipe.ratingCount * widget.recipe.ratingCount) + _rating) /
              ratingCount;
      print(ratingCount.toString() + " " + rate.toString());

      //update rating and rating-count
      await ref
          .update({
            "rating": double.parse(rate.toStringAsFixed(1)),
            "rating-count": ratingCount,
          })
          .then((value) => Navigator.pop(context))
          .catchError((error) {
            print(error);
          });
    }

    // print("Rating:$_rating");
  }

  String _findRecipe(Map data, String title) {
    // Iterate through all values in the data map
    for (var user in data.entries) {
      // Check if any user matches the name and password
      var id = user.key;
      var info = user.value;
      if (info['title'] == title) {
        print(id);
        return id;
        // context.read<GlobalState>().setUserId(id);
        // context.read<GlobalState>().setSaveList(info['favorite']);
      }
    }
    return ""; // No match found
  }

  List<Widget> _buildHearts(int score) {
    List<Widget> hearts = [];
    for (int i = 0; i < score; i++) {
      hearts.add(
        IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              setState(() {
                _rating = i + 1;
                print(_rating);
              });
            }),
      );
    }
    for (int i = score; i < 5; i++) {
      hearts.add(IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.red),
          onPressed: () {
            setState(() {
              _rating = i + 1;
              print(_rating);
            });
          }));
    }
    return hearts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Rating", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildHearts(_rating),
            ],
          ),
        ),
        ElevatedButton(onPressed: _onSubmitPressed, child: const Text("Submit"))
      ],
    );
  }
}
