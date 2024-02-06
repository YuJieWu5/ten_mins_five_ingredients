import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class UploadRecipePage extends StatefulWidget {
  const UploadRecipePage({super.key});

  @override
  State<UploadRecipePage> createState() => _UploadRecipePageState();
}

class _UploadRecipePageState extends State<UploadRecipePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // This will hold the selected image
  XFile? _image;

  // Store dynamic TextField data for Ingredients
  int _ingredientsCount = 1;
  List<TextEditingController> _ingredientsController = [TextEditingController()];
  List<TextEditingController> _ingredientsQuantityController = [TextEditingController()];

  // Store dynamic TextField data for Instructions
  int _instructionsCount = 1;
  List<TextEditingController> _instructionsController = [TextEditingController()];
  List<TextEditingController> _instructionsQuantityController = [TextEditingController()];

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
    for (int i = 0; i < count; i++) {
      if( i<_ingredientsController.length ){
        _ingredientsController.add(TextEditingController());
        _ingredientsQuantityController.add(TextEditingController());
      }
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
                      _ingredientsQuantityController.removeAt(i);
                      _ingredientsController.removeAt(i);
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
    // _instructionsController = List.generate(count, (index) => TextEditingController());
    // _instructionsQuantityController = List.generate(count, (index) => TextEditingController());
    for (int i = 0; i < count; i++) {
      if(i<_instructionsController.length){
        _instructionsController.add(TextEditingController());
        _instructionsQuantityController.add(TextEditingController());
      }
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
                          _instructionsQuantityController.removeAt(i);
                          _instructionsController.removeAt(i);
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

  void _onUploadPressed(){
    //TODO: call uploadRecipe API, save input data to database
    _openAlertDialog(context);
  }

  void _openAlertDialog(BuildContext context){
    //TODO: save the recipe data to database
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Center(child: Text('Upload Successful')),
              actions: <Widget>[
                TextButton(
                  onPressed: () => GoRouter.of(context).push('/'),
                  child: const Text('OK'),
                )
              ],
          );
        }
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Recipe'),
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: (){
              GoRouter.of(context).pop();
            }
        ),
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
                  onPressed: _onUploadPressed,
                  child: const Text("Upload")
              )
            ],
          ),
        ),
      )
    );
  }
}
