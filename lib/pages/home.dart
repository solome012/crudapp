import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_prac2/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreServices _firestoreServices = FirestoreServices();
  TextEditingController textController = TextEditingController();

  //open a dialog box to add a note
  void openNoteBox(String? docID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add note"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (docID == null) {
                      _firestoreServices.addNote(textController.text);
                    } else {
                      _firestoreServices.updateNote(docID, textController.text);
                    }

                    //clear text controller
                    textController.clear();
                    //close the box
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.check))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openNoteBox(null);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestoreServices.getNote(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List noteList = snapshot.data!.docs;
              //display as the listview
              return ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    //get the individual docs
                    DocumentSnapshot document = noteList[index];
                    String docId = document.id;
                    //get note from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];
                    //display data in the listTile
                    return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //for updating the note
                          IconButton(
                            onPressed: () {
                              return openNoteBox(docId);
                            },
                            icon: const Icon(Icons.create),
                          ),

                          //delteting the note
                          IconButton(
                              onPressed: () {
                                _firestoreServices.deleteNote(docId);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  });
            } else {
              return const Text("No notes found");
            }
          },
        ));
  }
}
