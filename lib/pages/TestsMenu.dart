import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestsMenu extends StatelessWidget {
  static const routeName = 'TestsMenu';

  var items = [
    "Test 1",
    "Assignment 1",
    "Test 2",
    "Assignment 2",
    "Test 3",
    "Assignment 3",
    "Test 4",
    "Assignment 4",
    "Test 5",
    "Assignment 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tests & Assignments Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assignmentsTests')
                    .snapshots(),

                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((
                          DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Title: ${data['title']}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 5,),
                                Text("Description:", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(data['desc']),
                                SizedBox(height: 5,),
                                Text("Date:", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(data['date'].toDate().toString().substring(0,16))

                              ],
                            ),

                          ),
                        );
                      }).toList(),

                      // itemCount: items.length,
                      // itemBuilder: (context, index) {
                      //
                      // },
                      // ),
                    ),
                    //},

                  );
                }
            ),
          ],
        ),
      ),
      // Container(
      //   child: Padding(
      //     padding: EdgeInsets.all(10),
      //     child: Column(
      //       children: [
      //         SizedBox(
      //           height: 15.0,
      //         ),
      //         Expanded(
      //           child: ListView.builder(
      //             itemCount: items.length,
      //             itemBuilder: (context, index) {
      //               return Container(
      //                 height: 100.0,
      //                 child: Card(
      //                   child: ListTile(
      //                     title: Text(items[index]),
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
