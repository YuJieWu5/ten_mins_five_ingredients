import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import 'recipe_rating_form.dart';

class RecipeDetail extends StatefulWidget {
  final Map recipe;
  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  String _display = "ingredient";

  @override
  Widget build(BuildContext context) {
    final Map recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
          title: Text(recipe['title']),
          leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios),
              onTap: (){
                GoRouter.of(context).pop();
              }
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }, icon: const Icon(Icons.home)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border_rounded)),
            IconButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return RecipeRatingForm(recipe: recipe);
                    },
                  );
                },
                icon: const Icon(Icons.rate_review_rounded)),
          ],
      ),
      body: ListView(
        children: [
          SizedBox( height: 500, child: Column(
            children: [
              SizedBox(
                height: 400.0,
                child: Image.network(recipe['image'])
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: SegmentedButton(
                    segments: const<ButtonSegment<String>>[
                      ButtonSegment<String>(
                          value: "ingredient",
                          label: Text("Ingredients")
                      ),
                      ButtonSegment<String>(
                          value: "instruction",
                          label: Text("Instruction")
                      ),
                    ],
                    selected: <String>{_display},
                    onSelectionChanged:(Set<String> newValue){
                      setState(() {
                        _display = newValue.first;
                      });
                    }
                )
              )
            ],
            )
          ),
          Center(
            child: SizedBox(height: 1000, width: 400, child: Column(
              children: recipe[_display] != null
                  ? (recipe[_display] as List<dynamic>).map<Widget>((item) => ListTile(
                title: Text('$item'),
              )).toList()
                  : [const Text("No data")],
            )
            )
          ),
        ],
      )
    );
  }
}
