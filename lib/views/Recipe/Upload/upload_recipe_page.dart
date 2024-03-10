import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadRecipePage extends StatefulWidget {
  const UploadRecipePage({super.key});

  @override
  State<UploadRecipePage> createState() => _UploadRecipePageState();
}

class _UploadRecipePageState extends State<UploadRecipePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  // This will hold the selected image
  XFile? _image;

  // Store dynamic TextField data for Ingredients
  int _ingredientsCount = 1;
  final List<TextEditingController> _ingredientsController = [
    TextEditingController()
  ];
  final List<TextEditingController> _ingredientsQuantityController = [
    TextEditingController()
  ];

  // Store dynamic TextField data for Instructions
  int _instructionsCount = 1;
  final List<TextEditingController> _instructionsController = [
    TextEditingController()
  ];

  List<Widget> buildIngredientsTextField(int count) {
    List<Widget> ingredientTextFieldList = [];
    for (int i = 0; i < count; i++) {
      if (i < _ingredientsController.length) {
        _ingredientsController.add(TextEditingController());
        _ingredientsQuantityController.add(TextEditingController());
      }
      ingredientTextFieldList.add(Card(
        child: Column(
          children: [
            TextFormField(
              key: Key('Ingredient${(i + 1).toString()}'),
              decoration: const InputDecoration(labelText: 'Ingredient'),
              controller: _ingredientsController[i],
              validator: (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return 'Ingredient can not be blank.';
                }
                return null;
              },
            ),
            TextFormField(
              key: Key('Quantity${(i + 1).toString()}'),
              decoration: const InputDecoration(labelText: 'Quantity'),
              controller: _ingredientsQuantityController[i],
              validator: (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return 'Quantity can not be blank.';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      _ingredientsCount = _ingredientsCount + 1;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outlined),
                  key: Key('addIngredientButton${(i + 1).toString()}'),
                ),
                IconButton(
                  onPressed: () {
                    if (_ingredientsCount > 1) {
                      setState(() {
                        _ingredientsQuantityController.removeAt(i);
                        _ingredientsController.removeAt(i);
                        _ingredientsCount = _ingredientsCount - 1;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  key: Key('removeIngredientButton${(i + 1).toString()}'),
                )
              ],
            )
          ],
        ),
      ));
    }
    return ingredientTextFieldList;
  }

  List<Widget> buildInstructionsTextField(int count) {
    List<Widget> instructionTextFieldList = [];
    for (int i = 0; i < count; i++) {
      if (i < _instructionsController.length) {
        _instructionsController.add(TextEditingController());
      }
      instructionTextFieldList.add(Card(
        child: Column(
          children: [
            TextFormField(
              key: Key('Instruction${(i + 1).toString()}'),
              decoration: const InputDecoration(labelText: 'Instruction'),
              controller: _instructionsController[i],
              validator: (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return 'Instruction can not be blank.';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      _instructionsCount = _instructionsCount + 1;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outlined),
                  key: Key('addInstructionButton${(i + 1).toString()}'),
                ),
                IconButton(
                  onPressed: () {
                    if (_instructionsCount > 1) {
                      setState(() {
                        _instructionsCount = _instructionsCount - 1;
                        _instructionsController.removeAt(i);
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  key: Key('removeInstructionButton${(i + 1).toString()}'),
                )
              ],
            )
          ],
        ),
      ));
    }
    return instructionTextFieldList;
  }

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
      // uploadFile(_image);
    }
  }

  void _onUploadPressed(BuildContext context) async {
    //TODO: call uploadRecipe API, save input data to database
    if (_image != null && (_formKey.currentState?.validate() ?? false)) {
      List<String> ingredients = [];
      List<String> instructions = [];
      for (int i = 0; i < _ingredientsCount; i++) {
        ingredients.add(_ingredientsController[i].text +
            " " +
            _ingredientsQuantityController[i].text);
      }
      for (int i = 0; i < _instructionsCount; i++) {
        instructions.add(_instructionsController[i].text);
      }
      final ref = context.read<GlobalState>().database.ref('recipes/');

      await ref.push().set({
        "creator": context.read<GlobalState>().getUserId(),
        "image": _image!
            .name, //upload the image to storage, only store image name in database
        "ingredient": ingredients,
        "instruction": instructions,
        "rating": 0,
        "rating-count": 0,
        "title": _titleController.text
      }).then((value) {
        uploadFile(_image, context);
      }).catchError((error) {
        //TODO: display error message to notify the user
        print(error);
      });
    } else {
      showErrorDialog(context, "Please fill all fields and select an image.");
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information Missing"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFile(XFile? file, BuildContext context) async {
    // Create a reference to the location you want to upload to in Firebase Storage
    Reference storageReference =
        context.read<GlobalState>().storage.ref().child(file!.name);

    //Setup the datatype
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file!.name},
    );

    try {
      // Upload the file
      await storageReference
          .putFile(File(file!.path), metadata)
          .then((p0) => _openAlertDialog(context));
    } catch (e) {
      //TODO: display error message to notify the user
      print(e); // Handle errors
    }
  }

  void _openAlertDialog(BuildContext context) {
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Recipe'),
          leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios),
              onTap: () {
                GoRouter.of(context).pop();
              }),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _image != null
                        ? Image.file(File(_image!.path), errorBuilder:
                            (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                            return const Text('Can not load the image');
                          })
                        : const Text('No image selected.'),
                    ElevatedButton(
                      key: const Key('SelectImage'),
                      onPressed: _pickImage,
                      child: const Text('Select Image'),
                    ),
                    const Text(
                      'Title:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        key: Key('Title'),
                        controller: _titleController,
                        validator: (newValue) {
                          if (newValue == null || newValue.isEmpty) {
                            return 'Title can not be blank.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Ingredients:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                        width: 500,
                        child: Column(
                          children: [
                            ...buildIngredientsTextField(_ingredientsCount)
                          ],
                        )),
                    const Text('Instructions:', style: TextStyle(fontSize: 20)),
                    SizedBox(
                        width: 500,
                        child: Column(
                          children: [
                            ...buildInstructionsTextField(_instructionsCount)
                          ],
                        )),
                    ElevatedButton(
                        key: const Key('Upload'),
                        onPressed: () => _onUploadPressed(context),
                        child: const Text("Upload"))
                  ],
                ),
              )),
        ));
  }
}
