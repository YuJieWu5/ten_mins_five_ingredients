import 'package:flutter/material.dart';
import '../../ingredients_list.dart';
import 'camera_widget.dart';

class PhotoCapturePage extends StatelessWidget {
  const PhotoCapturePage({super.key});

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
                child: const CameraWidget(),
              ),
            ),
            const ActionBar(), // Confirm to use the photo
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Retake'),
              onPressed: () {
                // TODO: Retake the photo
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IngredientListPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
