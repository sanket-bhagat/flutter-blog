import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_blog/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String authorName, title, desc;
  bool _isLoading = false;
  String url = '';
  Crud crud = new Crud();
  final ImagePicker _picker = ImagePicker();
  File? image;
  getImage() async {
    var selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(selectedImage!.path);
    });
  }

  uploadBlog() async {
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      var imageFile = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${randomAlphaNumeric(9)}.jpg');
      UploadTask task = imageFile.putFile(image!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      // print('Download URL: $url');
      Map<String, String> map = {
        'url': url,
        'author': authorName,
        'title': title,
        'desc': desc,
      };
      crud.addData(map).then((value) {
        Navigator.pop(context);
      });
    }
  }

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
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.upload),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  image != null
                      ? Container(
                          height: 170.0,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 170.0,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Author Name: ',
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        authorName = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Title: ',
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Description: ',
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        desc = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
