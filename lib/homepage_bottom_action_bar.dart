import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: Text('Get Recipe'),
          onPressed: () {
            // Placeholder to implement get function
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            // Placeholder to navigate to profile
          },
        ),
        ElevatedButton(
          child: Text('Create Recipe'),
          onPressed: () {
            // Placeholder to implement create function
          },
        ),
      ],
    );
  }
}
