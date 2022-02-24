import 'package:flutter/material.dart';
import 'package:pomodoro/loading.dart';
import 'package:pomodoro/model/conquest.dart';
import 'package:pomodoro/screens/specific_conquest.dart';
import 'package:pomodoro/services/database_services.dart';

class Conquests extends StatefulWidget {
  const Conquests({Key? key}) : super(key: key);

  @override
  _ConquestsState createState() => _ConquestsState();
}

class _ConquestsState extends State<Conquests> {
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Conquest>>(
            future: DatabaseService().listConquests(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }
              List<Conquest>? conquests = snapshot.data;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: conquests!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecificConquest(
                            currentConquest: conquests[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_purple500_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                conquests[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
