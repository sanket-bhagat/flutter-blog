import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/screens/create_blog.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:flutter_blog/components/blog_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = Crud();
  final Stream<QuerySnapshot> blogsStream =
      FirebaseFirestore.instance.collection('blogs').snapshots();
  CollectionReference blogs = FirebaseFirestore.instance.collection('blogs');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Flutter',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              Text(
                'Blog',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 22.0,
                ),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: blogsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Something went wrong in streambuilder');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List storedBlogs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map map = document.data() as Map<String, dynamic>;
              map['id'] = document.id;
              storedBlogs.add(map);
            }).toList();
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: storedBlogs.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return BlogTile(
                          imageUrl: storedBlogs[index]['url'],
                          author: storedBlogs[index]['author'],
                          title: storedBlogs[index]['title'],
                          desc: storedBlogs[index]['desc'],
                          id: storedBlogs[index]['id'],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateBlog(),
              ),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
