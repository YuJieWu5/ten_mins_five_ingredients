import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'global_state.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed(){
    // for testing purpose
    context.go('/');
    context.read<GlobalState>().isLogin = true;

    if(_formKey.currentState?.validate() ?? false) {
      //TODO: verify account info
      if(_userNameController.text == "vv" && _passwordController.text == "123"){
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
              child: Text('Log In', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
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
                      Container(
                          margin: const EdgeInsets.only(top:20.0),
                          child: ElevatedButton(
                            // Note: we are not calling _onSavePressed! We are passing it
                            // like an object to this other widget as a constructor arg.
                              onPressed: _onLoginPressed,
                              child: const Text('Log In')
                          )
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}
