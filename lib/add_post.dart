

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final postController = TextEditingController();
  final idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextFormField(
                controller: idController,
                decoration: InputDecoration(
                    hintText: "Id number",
                    border: OutlineInputBorder()
                ),
              ),
          
              SizedBox(height: 30,),
          
              TextFormField(
                maxLines: 4,
                controller: postController,
                decoration: InputDecoration(
                  hintText: "Any thing you write",
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 30,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
              
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            createData();
                          }, child:Text("Create",style: TextStyle(fontSize: 11,color: Colors.white),),
              
                        ),
                      ),
                    )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
              
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            readData();
                          }, child:Text("Read",style: TextStyle(fontSize: 11,color: Colors.white),),
              
                        ),
                      ),
                    )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
              
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            updateData();
                          }, child:Text("Update",style: TextStyle(fontSize: 11,color: Colors.white),),
              
                        ),
                      ),
                    )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
              
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            deleteData();
                          }, child:Text("Delete",style: TextStyle(fontSize: 11,color: Colors.white),),
              
                        ),
                      ),
                    )),
          
              
              
                  ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: Text("UserId")),
                  Expanded(child: Text("Message"))
                ],
              ),
              StreamBuilder(
                stream: firestore.collection("user").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        String userId = documentSnapshot["id"].toString();
                        String message = documentSnapshot["Any Thing"].toString();
                        return Row(
                          children: [
                            Expanded(child: Text(userId)),
                            Expanded(child: Text(message)),
                          ],
                        );
                      },
                    );
                  }
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                },
              )


            ],
          ),
        ),
      ),
    );
  }
  void createData() {
    String userId = idController.text; // Get the text from the TextEditingController
    DocumentReference documentReference = firestore.collection("user").doc(userId);
    Map<String, dynamic> user = {
      "id": userId,
      "Any Thing": postController.text, // Get the text from the TextEditingController
    };
    documentReference.set(user).whenComplete(() {
      Fluttertoast.showToast(
          msg: "Created",
          textColor: Colors.white,
          backgroundColor: Colors.blue,
        );
      print("$userId created");
    });
  }
  void readData() {
    String userId = idController.text;
    DocumentReference documentReference = firestore.collection("user").doc(userId);

    documentReference.get().then((DocumentSnapshot datasnapshot) {
      if (datasnapshot.exists) {
        // Check if the document exists
        Map<String, dynamic>? data = datasnapshot.data() as Map<String, dynamic>?; // Get the document data

        if (data != null) {
          // Access fields using their keys
          String? id = data['id'];
          String? anything = data['Any Thing'];

          // Print or use the retrieved data
          print("ID: $id,\n Any Thing: $anything");

        } else {
          Fluttertoast.showToast(
              msg: "Document data is null",
              textColor: Colors.white,
              backgroundColor: Colors.blue
          );
          print("Document data is null");
        }
      } else {
        print("Document does not exist");
        Fluttertoast.showToast(
            msg: "Document does not exist",
            textColor: Colors.white,
            backgroundColor: Colors.blue
        );
      }
    }).catchError((error) {
      print("Error reading document: $error");
      Fluttertoast.showToast(
          msg: "Error reading document: $error",
          textColor: Colors.white,
          backgroundColor: Colors.blue
      );
    });
  }

  void updateData() {
    String userId = idController.text;
    DocumentReference documentReference = firestore.collection("user").doc(userId);

    // Create a map of fields to update
    Map<String, dynamic> updatedData = {
      "Any Thing": postController.text,
    };

    // Update the document
    documentReference.update(updatedData).then((_) {
      print("Document updated successfully");
      Fluttertoast.showToast(
        msg: "Document update Successful",
        textColor: Colors.white,
        backgroundColor: Colors.blue
      );
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Error",
          textColor: Colors.white,
          backgroundColor: Colors.blue
      );
      print("Error updating document: $error");
    });
  }
  void deleteData() {
    String userId = idController.text;
    DocumentReference documentReference = firestore.collection("user").doc(userId);

    // Delete the document
    documentReference.delete().then((_) {
      Fluttertoast.showToast(
          msg: "Document deleted successfully",
          textColor: Colors.white,
          backgroundColor: Colors.blue
      );
      print("Document deleted successfully");
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Error deleting document: $error",
          textColor: Colors.white,
          backgroundColor: Colors.blue
      );
      print("Error deleting document: $error");
    });
  }



}








