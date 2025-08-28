import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/pages/services/firestore.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  void openNoteBox({String ? docID}){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller:textController,
          ),
          actions: [
            ElevatedButton(
                onPressed: (){
        if (docID == null){
          firestoreService.addNotes(textController.text);
        }
        else firestoreService.updateNotes(docID, textController.text);
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text("add?")
            )
          ],
        )

    );
  }


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(title: Text("Notes"),),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.cyclone),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStraem(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            List noteList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index){
              DocumentSnapshot document = noteList[index];
              String docID = document.id;

              Map <String, dynamic> data =
              document.data() as Map<String, dynamic>;
              String noteText = data['note'];
              return ListTile(
                title: Text(noteText),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => openNoteBox(docID: docID),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () =>firestoreService.deleteNote(docID),
                      icon: Icon(Icons.delete),
                    ),

                  ],
                )
              );
            });
          }//trailing
          else return const Text("no notes yet");
        }
      )
    );;
  }
}
