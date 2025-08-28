import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{


  //get collection of notes
CollectionReference notes =
    FirebaseFirestore.instance.collection("notes");

  //CREATE: add a new note
Future<void> addNotes(String note){
  return notes.add({
    'note': notes,
    'timestamp': Timestamp.now(),
  });
}

  //READ : get notes from database
Stream<QuerySnapshot> getNoteStraem(){
  final notesStream = notes.orderBy('timestamp',descending: true).snapshots();
  return notesStream;
}


  //UPDATE : update notes given a doc id
Future <void> updateNotes(String docID,String newNote){
  return notes.doc(docID).update({
    'mote': newNote,
    'timestamp': Timestamp.now()
  }
  );
}
  // DELETE :  delete notes given a doc id


}