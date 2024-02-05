import 'package:flutter/material.dart';
import 'ingredients_list.dart';

class PhotoCapturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Photo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView for scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3 / 4, // Square box
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: Text('Placeholder for camera widget'),
                  // TODO: Implement camera widget
                ),
              ),
            ),
            ActionBar(), // Confirm to use the photo
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Retake'),
              onPressed: () {
                // TODO: Retake the photo
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IngredientListPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
