import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadRecipePage extends StatefulWidget {
  const UploadRecipePage({super.key});

  @override
  State<UploadRecipePage> createState() => _UploadRecipePageState();
}

class _UploadRecipePageState extends State<UploadRecipePage> {
  XFile? _image; // This will hold the selected image
  int _ingredientsCount = 1;
  List<TextEditingController> _ingredientsController = [];
  List<TextEditingController> _ingredientsQuantityController = [];
  int _instructionsCount = 1;
  List<TextEditingController> _instructionsController = [];

  // Method to pick image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // If an image is picked, update the state
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  List<Widget> buildIngredientsTextField(int count) {
    List<Widget> IngredientsTextFieldList = [];
    _ingredientsController = List.generate(count, (index) => TextEditingController());
    _ingredientsQuantityController = List.generate(count, (index) => TextEditingController());
    for (int i = 0; i < count; i++) {
      IngredientsTextFieldList.add(
        Card(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Ingredient'
                ),
                controller: _ingredientsController[i],
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Quantity'
                ),
                controller: _ingredientsQuantityController[i],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(onPressed: (){
                    setState(() {
                      _ingredientsCount = _ingredientsCount+1;
                    });
                  },
                      icon: const Icon(Icons.add_circle_outlined)
                  ),
                IconButton(onPressed: (){
                  if(_ingredientsCount>1){
                    setState(() {
                      _ingredientsCount = _ingredientsCount-1;
                    });
                  }
                },
                    icon: const Icon(Icons.remove_circle_outline)
                )
              ],
            )
            ],
          ),
        )
      );
    }
    return IngredientsTextFieldList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Image from Album'),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image != null ? Image.file(File(_image!.path)) : Text('No image selected.'),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              const Text('Ingredients:', style: TextStyle(fontSize: 20),),
              Container(
                width: 500,
                child: Column(
                  children: [
                    ...buildIngredientsTextField(_ingredientsCount)
                  ],
                )
              ),
              const Text('Ingredients:', style: TextStyle(fontSize: 20),),
              Container(
                  width: 500,
                  child: Column(
                    children: [
                      ...buildIngredientsTextField(_ingredientsCount)
                    ],
                  )
              ),
            ],
          ),
        ),
      )
    );
  }
}
