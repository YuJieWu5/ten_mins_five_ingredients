import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';

class CreateList extends StatefulWidget {
  final test;
  const CreateList({required this.test, super.key});

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  String? _userId;
  final List _recipesList=[];

  @override
  initState(){
    super.initState();
    _userId = context.read<GlobalState>().getUserId();
  }

  void openRecipeDetail(Map<String, dynamic> recipe, BuildContext context) async {
      final reLoadPage = await GoRouter.of(context).push('/recipeDetail', extra: Recipe.fromJson(recipe));
      if (reLoadPage as bool) {
          setState(() {});
      }
  }

  Future<List<dynamic>> readDatabase(BuildContext context) async {
    final snapshot = await context.read<GlobalState>().database.ref().child('recipes/').get();
    if (snapshot.exists) {
      String dataString = jsonEncode(snapshot.value);
      Map dataMap = jsonDecode(dataString);
      _recipesList.clear();
      for (var recipe in dataMap.entries) {
        if(recipe.value['creator']==_userId) {
          // _recipesList.add(recipe.value);
          try {
            // Upload the file
            final storageReference = context.read<GlobalState>().storage.ref().child(recipe.value['image']);

            // Optionally, if you want the file URL after the upload completes
            final String downloadUrl = await storageReference.getDownloadURL();
            recipe.value['image'] = downloadUrl;
            recipe.value['id'] = recipe.key;
            _recipesList.add(recipe.value);
          } catch (e) {
            print(e); // Handle errors
          }
        }
      }
    } else {
      print('No data available.');
    }
    return _recipesList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe List'),
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: (){
              GoRouter.of(context).pop();
            }
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: readDatabase(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(snapshot.hasData) {
            // List<dynamic> _recipesList = snapshot.data!;
            return ListView(
              children: _recipesList.map((item) => ListTile(
                leading: widget.test ? null : CircleAvatar(
                    backgroundImage: NetworkImage(item['image'])
                ),
                title: Text(item['title']),
                subtitle: Text(item['rating'].toString()),
                trailing: IconButton(
                  key: Key(item['title']),
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => openRecipeDetail(item, context),
                  // onPressed: () => GoRouter.of(context).push('/recipeDetail'),
                ),
                isThreeLine: true,
              )).toList(),
            );
          }else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
