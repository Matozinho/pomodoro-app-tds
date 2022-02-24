import 'package:flutter/material.dart';
import 'package:pomodoro/model/conquest.dart';

class SpecificConquest extends StatelessWidget {
  final Conquest currentConquest;
  const SpecificConquest({Key? key, required this.currentConquest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: const Text(
            'Conquistas',
            style: TextStyle(
              fontSize: 36,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 58.0,
              top: 48.0,
              left: 25.0,
              right: 25.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 150,
                    ),
                    Text(
                      currentConquest.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      currentConquest.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                // TODO: make share with social medias
                // TextButton(
                //   onPressed: () {},
                //   child: const Text(
                //     "Compartilhar",
                //     style: TextStyle(
                //       fontSize: 18,
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   style: ButtonStyle(
                //     padding: MaterialStateProperty.all(
                //       const EdgeInsets.symmetric(
                //         vertical: 12,
                //       ),
                //     ),
                //     backgroundColor: MaterialStateProperty.all(
                //       Theme.of(context).primaryColor,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
