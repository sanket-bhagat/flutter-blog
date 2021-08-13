import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BlogTile extends StatelessWidget {
  final String imageUrl, author, title, desc, id;
  BlogTile({
    required this.imageUrl,
    required this.author,
    required this.title,
    required this.desc,
    required this.id,
  });

  CollectionReference blogs = FirebaseFirestore.instance.collection('blogs');
  Future<void> deleteBlog() async {
    await blogs.doc(id).delete();
  }

  void showAlert(context) {
    Alert(
      context: context,
      title: 'Delete Blog?',
      buttons: [
        DialogButton(
          child: Text(
            'Delete',
          ),
          onPressed: () {
            deleteBlog();
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showAlert(context);
      },
      child: Container(
        height: 170.0,
        margin: EdgeInsets.only(bottom: 16.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 170.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(author),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
