import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List _recipesList = [];

  @override
  initState(){
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    print("is loading");
    final String response = await rootBundle.loadString('assets/mock_data/recipes.json');
    final data = await json.decode(response);
    setState(() {
      _recipesList = data["recipes"];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe List')),
      body: ListView(
        children: _recipesList.map((item)=>ListTile(
          leading: CircleAvatar(
              child: Image.asset(
                    'assets/images/${item['image']}',
                    fit: BoxFit.contain,
                  ),
          ),
          title: Text(item['name']),
          subtitle: Text(item['score'].toString()),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: ()=> context.go('/recipeDetail'),
          ),
          isThreeLine: true,
        )).toList()
      ),
    );
  }
}
