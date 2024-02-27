import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref("users/");

  void _onCreatePressed() async{
    if(_formKey.currentState?.validate() ?? false) {
      //TODO: save account info to database
      // GoRouter.of(context).push('/login');
      // try{
      //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //       email: _userNameController.text,
      //       password: _passwordController.text
      //   );
      // }on FirebaseAuthException catch(ex){
      //   print(ex.code);
      //   print(ex.message);
      // }
      // final ref = FirebaseDatabase.instance.ref();
      // final snapshot = await ref.child('users/').get();
      // if (snapshot.exists) {
      //   print(snapshot.value);
      // } else {
      //   print('No data available.');
      // }
        await ref.push().set({
          "name": _userNameController.text,
          "password": int.parse(_passwordController.text),
        }).catchError((error){
          print(error);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // automaticallyImplyLeading: false,
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
            onTap: (){
              GoRouter.of(context).pop();
            }
        ),
        title: Center(
          child: Text('Sign Up', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Center(
                    child: SizedBox(
                      width: 400.0,
                      child: TextFormField(
                        key: const Key('Username'),
                        decoration: const InputDecoration(
                            labelText: 'Username'
                        ),
                        controller: _userNameController,
                        validator: (newValue) {
                          if(newValue == null || newValue.isEmpty) {
                            return 'Username must not be blank.';
                          }
                          return null;
                        },
                      )
                    )
                  )
                ),
                SizedBox(
                  width: 400.0,
                  child: TextFormField(
                    key: const Key('Password'),
                    decoration: const InputDecoration(
                        labelText: 'Password'
                    ),
                    controller: _passwordController,
                    validator: (newValue) {
                      if(newValue == null || newValue.isEmpty) {
                        return 'Password must not be blank.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 400.0,
                  child: TextFormField(
                    key: const Key('ConfirmPassword'),
                    decoration: const InputDecoration(
                        labelText: 'Confirm Password'
                    ),
                    controller: _confirmPasswordController,
                    validator: (newValue) {
                      if(newValue == null || newValue.isEmpty) {
                        return 'Confirm Password must not be blank.';
                      }else if(_passwordController.text != _confirmPasswordController.text){
                        return 'Passwords must be same.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top:20.0),
                  child: ElevatedButton(
                    // Note: we are not calling _onSavePressed! We are passing it
                    // like an object to this other widget as a constructor arg.
                      onPressed: _onCreatePressed,
                      child: const Text('Create')
                  )
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: ()=> GoRouter.of(context).push('/login'),
                  child: const Text('Log In'),
                )
              ],
            ),
          )
        )
      )
    );
  }
}
