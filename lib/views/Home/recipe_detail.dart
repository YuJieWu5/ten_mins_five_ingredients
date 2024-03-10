import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import '../../core/models/global_state.dart';
import 'recipe_rating_form.dart';
import 'package:ten_mins_five_ingredients/routes/app_routes.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  String _display = "ingredient";
  List<dynamic>? currentSaveList;
  // bool _saved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSaveList = context.read<GlobalState>().getSaveList();
    // final Recipe recipe = widget.recipe;
    // setState(() {
    //   _saved = checkExisted(recipe.id);
    // });
  }

  void _onSavedPress(BuildContext context) async{
    //Save the recipe id to database or remove it from database
    final database = context.read<GlobalState>().database;
    final Recipe recipe = widget.recipe;
    String userID = context.read<GlobalState>().getUserId()!;
    DatabaseReference userRef = database.ref('/users/$userID');

    if(!checkExisted(recipe.id)){
      currentSaveList!.add(recipe.id);
      context.read<GlobalState>().setSaveList(currentSaveList!);

      await userRef.update({
        "favorite": currentSaveList
      });
    }else{
      currentSaveList!.remove(recipe.id);
      await userRef.update({
        "favorite": currentSaveList
      });
    }
    setState(() {});
    // print(recipe.id);
  }

  bool checkExisted(String id){
    if(currentSaveList!.contains(id)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = widget.recipe;
    final List<String> list = _display == "ingredient" ? recipe.ingredients : recipe.steps;

    return Scaffold(
      appBar: AppBar(
          title: Text(recipe.title),
          leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios),
              onTap: (){
                GoRouter.of(context).pop(true);
              }
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }, icon: const Icon(Icons.home)),
            IconButton(
                onPressed: (){
                  _onSavedPress(context);
                },
                icon: checkExisted(recipe.id)? const Icon(Icons.bookmark):const Icon(Icons.bookmark_border_rounded)),
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
                child: Image.network(recipe.imageUrl)
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
              children: list.map<Widget>((item) => ListTile(
                title: Text(item),
              )).toList()
            )
            )
          ),
        ],
      )
    );
  }
}
