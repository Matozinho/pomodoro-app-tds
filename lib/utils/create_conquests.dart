import 'package:cloud_firestore/cloud_firestore.dart';

class CreateConquests {
  CollectionReference conquestCollection =
      FirebaseFirestore.instance.collection('Conquests');

  final timesConquests = {
    {
      "time_needed": 25 * 60,
      "title": '25 minutos focado',
      "description":
          'Parabéns, você conseguiu se manter focado por 25 minutos!',
    },
    {
      "time_needed": 100 * 60,
      "title": '100 minutos focado',
      "description":
          'Parabéns, você conseguiu se manter focado por 100 minutos!',
    },
    {
      "time_needed": 250 * 60,
      "title": '250 minutos focado',
      "description":
          'Parabéns, você conseguiu se manter focado por 250 minutos!',
    },
    {
      "time_needed": 1000 * 60,
      "title": '1000 minutos focado',
      "description":
          'Parabéns, você conseguiu se manter focado por 1000 minutos!',
    },
  };

  final tasksConquests = {
    {
      "tasks_needed": 1,
      "title": '1 tarefa concluída',
      "description": 'Parabéns, você conseguiu completar 1 tarefa!',
    },
    {
      "tasks_needed": 5,
      "title": '5 tarefas concluídas',
      "description": 'Parabéns, você conseguiu completar 5 tarefas!',
    },
    {
      "tasks_needed": 20,
      "title": '20 tarefas concluídas',
      "description": 'Parabéns, você conseguiu completar 20 tarefas!',
    },
    {
      "tasks_needed": 50,
      "title": '50 tarefas concluídas',
      "description": 'Parabéns, você conseguiu completar 50 tarefas!',
    },
  };

  addCoquests() {
    CollectionReference taskCollection =
        conquestCollection.doc('T569jg2DPVLlTQ5e8l7N').collection('Tasks');
    CollectionReference timesCollection =
        conquestCollection.doc('TypKzZxL67vJmvZzkngd').collection('Times');

    timesConquests.forEach((conquest) {
      timesCollection.add(conquest);
    });

    tasksConquests.forEach((conquest) {
      taskCollection.add(conquest);
    });
  }
}
