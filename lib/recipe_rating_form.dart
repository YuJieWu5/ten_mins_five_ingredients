import 'package:flutter/material.dart';

class RecipeRatingForm extends StatefulWidget {
  const RecipeRatingForm({super.key});

  @override
  State<RecipeRatingForm> createState() => _RecipeRatingFormState();
}

class _RecipeRatingFormState extends State<RecipeRatingForm> {
  int _rating = 0;
  List<Widget> _buildHearts(int score) {
    List<Widget> hearts = [];
    for (int i = 0; i < score; i++) {
      hearts.add(
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              setState(() {
                _rating = i+1;
                print(_rating);
              });
            }),
      );
    }
    for (int i = score; i < 5; i++) {
      hearts.add(
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.red),
          onPressed: () {
            setState(() {
              _rating = i+1;
              print(_rating);
            });
          })
      );
    }
    return hearts;
  }

  void _onSubmitPressed(){
    //TODO: send the rating score to database
    print("Rating:"+ _rating.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Rating", style: TextStyle(fontSize:  20)),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            ..._buildHearts(_rating),
          ],
        ),
        ),
        ElevatedButton(
            onPressed: _onSubmitPressed,
            child: const Text("Submit")
        )
      ],
    );
  }
}
