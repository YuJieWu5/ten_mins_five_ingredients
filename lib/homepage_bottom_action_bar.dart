import 'package:flutter/material.dart';
import 'photo_capture_page.dart';
import 'recipe_list_page.dart';
import 'package:go_router/go_router.dart';

class BottomActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          child: ElevatedButton(
          child: Text('📷 Get Recipe'),
          onPressed: () => context.go('/getRecipe')
        )
        ),
        Flexible(
          child: ElevatedButton(
            child: Text('View Recipe'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeList()),
              );
            },
          ),
        ),
        Flexible(
          child: ElevatedButton(
            child: Text('Create Recipe'),
            onPressed: () {
              // TODO: Placeholder to implement create function
            },
          ),
        ),
        Flexible(
          child: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Placeholder to navigate to profile
            },
          ),
        ),
      ],
    );
  }
}
