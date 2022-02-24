import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomodoro/model/conquest.dart';
import 'package:pomodoro/model/todo.dart';

class DatabaseService {
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('Todos');
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('UserData');
  final CollectionReference conquestsCollection =
      FirebaseFirestore.instance.collection('Conquests');

  final userId = "GQUvM7FefmmfUJYm2Njw";
  final tasksCollectionId = "T569jg2DPVLlTQ5e8l7N";
  final timeCollectionId = "TypKzZxL67vJmvZzkngd";

  Future createNewTodo(String title) async {
    try {
      return await todosCollection.add({
        "title": title,
        "isCompleted": false,
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future increaseTotalTasks() async {
    try {
      return await userDataCollection.doc(userId).update({
        "total_tasks": FieldValue.increment(1),
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future validateTaskConquest() async {
    try {
      DocumentSnapshot userDataDoc = await userDataCollection.doc(userId).get();
      QuerySnapshot tasksConquestQuery = await conquestsCollection
          .doc(tasksCollectionId)
          .collection('Tasks')
          .get();

      Conquest newConquest = Conquest(title: "", description: "");
      bool hasNewConquest = false;

      tasksConquestQuery.docs.forEach((conquest) {
        if (userDataDoc['total_tasks'] >= conquest['tasks_needed'] &&
            !userDataDoc['conquests'].contains(conquest.id)) {
          userDataDoc.reference.update({
            "conquests": FieldValue.arrayUnion([conquest.id])
          });
          newConquest.title = conquest['title'];
          newConquest.description = conquest['description'];
          hasNewConquest = true;
        }
      });

      if (hasNewConquest) {
        return newConquest;
      } else {
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future toggleTaskState(uuid, bool currentState) async {
    try {
      await todosCollection.doc(uuid).update({"isCompleted": !currentState});
      if (!currentState) {
        await increaseTotalTasks();
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future removeTask(uuid) async {
    try {
      await todosCollection.doc(uuid).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    try {
      if (snapshot != null) {
        return snapshot.docs.map((e) {
          return Todo(
              uuid: e.id, title: e['title'], isCompleted: e["isCompleted"]);
        }).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Stream<List<Todo>> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }

  Future<List<Conquest>> listConquests() async {
    try {
      DocumentSnapshot userDataDoc = await userDataCollection.doc(userId).get();
      QuerySnapshot tasksSnapshot = await conquestsCollection
          .doc(tasksCollectionId)
          .collection("Tasks")
          .get();
      QuerySnapshot timesSnapshot = await conquestsCollection
          .doc(timeCollectionId)
          .collection("Times")
          .get();

      final dynamicUserConquests = userDataDoc['conquests'].map((conquest) {
        final timesConquests = timesSnapshot.docs.map((item) {
          if (item.id == conquest) {
            return Conquest(
                title: item['title'], description: item['description']);
            // return item.data();
          }
        });
        final tasksConquests = tasksSnapshot.docs.map((item) {
          if (item.id == conquest) {
            return Conquest(
                title: item['title'], description: item['description']);
            // return item.data();
          }
        });
        var userConquests = List.from(timesConquests)..addAll(tasksConquests);
        return userConquests.whereType<Conquest>().toList()[0];
      });

      List<Conquest> userConquests = List<Conquest>.from(dynamicUserConquests);

      return userConquests;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  void increaseTotalTime(time) async {
    try {
      await userDataCollection.doc(userId).update({
        "total_time": FieldValue.increment(time),
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future validateTimeConquest() async {
    try {
      DocumentSnapshot userDataDoc = await userDataCollection.doc(userId).get();
      QuerySnapshot timesConquestQuery = await conquestsCollection
          .doc('TypKzZxL67vJmvZzkngd')
          .collection('Times')
          .get();

      Conquest newConquest = Conquest(title: "", description: "");
      bool hasNewConquest = false;

      timesConquestQuery.docs.forEach((conquest) {
        if (userDataDoc['total_time'] >= conquest['time_needed'] &&
            !userDataDoc['conquests'].contains(conquest.id)) {
          userDataDoc.reference.update({
            "conquests": FieldValue.arrayUnion([conquest.id])
          });
          newConquest.title = conquest['title'];
          newConquest.description = conquest['description'];
          hasNewConquest = true;
        }
      });

      if (hasNewConquest) {
        return newConquest;
      } else {
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
