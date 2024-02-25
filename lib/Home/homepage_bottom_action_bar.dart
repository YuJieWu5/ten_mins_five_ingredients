import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
            child: const Text('Get Recipe'),
            onPressed: () => GoRouter.of(context).push('/getRecipe')),
        ElevatedButton(
          child: const Text('Create Recipe'),
          onPressed: () => GoRouter.of(context).push('/uploadRecipe'),
        ),
      ],
    );
  }
}
