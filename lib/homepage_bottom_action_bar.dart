import 'package:flutter/material.dart';
import 'photo_capture_page.dart';

class BottomActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: Text('Get Recipe'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhotoCapturePage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            // TODO: Placeholder to navigate to profile
          },
        ),
        ElevatedButton(
          child: Text('Create Recipe'),
          onPressed: () {
            // TODO: Placeholder to implement create function
          },
        ),
      ],
    );
  }
}
