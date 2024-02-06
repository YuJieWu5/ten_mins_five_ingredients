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
  List<TextEditingController> _instructionsQuantityController = [];

  // Method to pick image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // If an image is picked, update the state
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  List<Widget> buildIngredientsTextField(int count) {
    List<Widget> ingredientTextFieldList = [];
    _ingredientsController = List.generate(count, (index) => TextEditingController());
    _ingredientsQuantityController = List.generate(count, (index) => TextEditingController());
    for (int i = 0; i < count; i++) {
      ingredientTextFieldList.add(
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
    return ingredientTextFieldList;
  }

  List<Widget> buildInstructionsTextField(int count) {
    List<Widget> instructionTextFieldList = [];
    _instructionsController = List.generate(count, (index) => TextEditingController());
    _instructionsQuantityController = List.generate(count, (index) => TextEditingController());
    for (int i = 0; i < count; i++) {
      instructionTextFieldList.add(
          Card(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Ingredient'
                  ),
                  controller: _instructionsController[i],
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Quantity'
                  ),
                  controller: _instructionsQuantityController[i],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(onPressed: (){
                      setState(() {
                        _instructionsCount = _instructionsCount+1;
                      });
                    },
                        icon: const Icon(Icons.add_circle_outlined)
                    ),
                    IconButton(onPressed: (){
                      if(_instructionsCount>1){
                        setState(() {
                          _instructionsCount = _instructionsCount-1;
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
    return instructionTextFieldList;
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
              _image != null ? Image.file(File(_image!.path)) : const Text('No image selected.'),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              const Text('Ingredients:', style: TextStyle(fontSize: 20),),
              SizedBox(
                width: 500,
                child: Column(
                  children: [
                    ...buildIngredientsTextField(_ingredientsCount)
                  ],
                )
              ),
              const Text('Instructions:', style: TextStyle(fontSize: 20)),
              SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      ...buildInstructionsTextField(_instructionsCount)
                    ],
                  )
              ),
              ElevatedButton(
                  onPressed: (){},
                  child: const Text("Upload")
              )
            ],
          ),
        ),
      )
    );
  }
}
