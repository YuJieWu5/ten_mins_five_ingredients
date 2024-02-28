import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import 'package:ten_mins_five_ingredients/core/models/global_state.dart';

class SaveList extends StatefulWidget {
  const SaveList({super.key});

  @override
  State<SaveList> createState() => _SaveListState();
}

class _SaveListState extends State<SaveList> {
  final ref = FirebaseDatabase.instance.ref();
  List<dynamic>? saveListId;
  final List _recipesList=[];

  @override
  initState(){
    super.initState();
    saveListId = context.read<GlobalState>().getSaveList();
    // readDatabase();
  }

  // Future<void> readDatabase() async {
  //   print("is loading");
  //   final snapshot = await ref.child('recipes/').get();
  //   if(snapshot.exists){
  //     String dataString = jsonEncode(snapshot.value);
  //     Map dataMap = jsonDecode(dataString);
  //
  //     for(var recipe in dataMap.entries){
  //       if(saveListId!.contains(recipe.key)){
  //         _recipesList.add(recipe.value);
  //         print(recipe.key);
  //       }
  //     }
  //     setState(() {});
  //   }else{
  //     print('No data available.');
  //   }
  // }

  Future<List<dynamic>> readDatabase() async {
    final snapshot = await ref.child('recipes/').get();
    // recipesList = [];
    if (snapshot.exists) {
      String dataString = jsonEncode(snapshot.value);
      Map dataMap = jsonDecode(dataString);

      for (var recipe in dataMap.entries) {
        if (saveListId!.contains(recipe.key)) {
          _recipesList.add(recipe.value);
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
        future: readDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(snapshot.hasData) {
            // List<dynamic> _recipesList = snapshot.data!;
            return ListView(
              children: _recipesList.map((item) => ListTile(
                // leading: CircleAvatar(
                //         child: Image.asset(
                //               'assets/images/${item['image']}',
                //               fit: BoxFit.contain,
                //             ),
                //     ),
                title: Text(item['title']),
                subtitle: Text(item['rating'].toString()),
                trailing: IconButton(
                  key: Key(item['title']),
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => GoRouter.of(context).push('/recipeDetail'),
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
