import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_mins_five_ingredients/homepage.dart';
import './recipe_rating_form.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Map<String, dynamic> _recipe = {};
  String _display = "ingredients";

  @override
  initState(){
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/mock_data/mock_recipe_data.json');
    final data = await json.decode(response);
    setState(() {
      _recipe = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _recipe['name']!=null?Text(_recipe['name']): const Text(""),
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
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
                      return const RecipeRatingForm();
                    },
                  );
                },
                icon: const Icon(Icons.rate_review_rounded)),
          ],
      ),

      // appBar: AppBar(title: Text("123")),
      body: ListView(
        children: [
          SizedBox( height: 500, child: Column(
            children: [
              SizedBox(
                height: 400.0,
                child: _recipe['image']!=null?Image.asset(
                  'assets/images/${_recipe['image']}',
                  fit: BoxFit.contain,
                ): const Text("Data loading"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: SegmentedButton(
                    segments: const<ButtonSegment<String>>[
                      ButtonSegment<String>(
                          value: "ingredients",
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
              children: _recipe[_display] != null
                  ? (_recipe[_display] as List<dynamic>).map<Widget>((item) => ListTile(
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
