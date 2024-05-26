import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  //Create : add note to the database
  Future<void> addNote(String note) {
    return notes.add({
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  //Read: get the data from firstore

  Stream<QuerySnapshot> getNote() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // Update : update notes in the given docid
  Future<void> updateNote(String docID, String newNote) {
    return notes
        .doc(docID)
        .update({'note': newNote, 'timestamp': Timestamp.now()});
  }

  //delete : delete notes given a doc id
  Future<void> deleteNote(docID) {
    return notes.doc(docID).delete();
  }
}
