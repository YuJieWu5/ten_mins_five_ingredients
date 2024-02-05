import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
            child: Text('Get Recipe'),
            onPressed: () => context.go('/getRecipe')),
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            // TODO: Placeholder to navigate to profile
          },
        ),
        ElevatedButton(
          child: Text('Create Recipe'),
          onPressed: () => context.go('/uploadRecipe'),
        ),
      ],
    );
  }
}
