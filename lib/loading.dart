import "package:flutter/material.dart";

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
