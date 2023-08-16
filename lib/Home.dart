import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  File? croppedImage;
  PickedFile? imageVar;
  File? _image;
  String? _imageCaption;

  Future<void> _shareImage() async {
    if (_image != null) {
      String caption = _imageCaption ?? "";
      List<String> paths = [_image!.path];
      await Share.shareFiles(paths, text: caption);
    }
  }

  Widget ImageWidget() {
    if (_image?.path == null) {
      return GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select Image"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close the dialog
                        final image = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (image == null) return;
                        File? img = File(image.path);
                        img = await _cropImage(imageFile: img);
                        setState(() {
                          _image = img;
                          _imageCaption = null;
                        });
                      },
                      child: Text("Take a Photo"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close the dialog
                        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        File? img = File(image.path);
                        img = await _cropImage(imageFile: img);
                        setState(() {
                          _image = img;
                        });
                      },
                      child: Text("Choose from Gallery"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.only(top: 15, bottom: 5, right: 20, left: 20),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.file_upload_outlined, size: 40),
                      SizedBox(height: 10.0),
                      Text(
                        'Add Photo',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding:
        const EdgeInsets.only(top: 15, bottom: 5, right: 20, left: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            //height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
              child:
              //Image.asset(imageVar!.path),
              Column(
                children: [
                  Image.file(File(_image!.path)),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () async {

                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(image == null) return;
                      File? img = File(image.path);
                      img = await _cropImage(imageFile: img);
                      setState(() {
                        _image = img;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Change Image",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _imageCaption = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Image Caption',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              )),
        ),
      );
    }
  }

  Future<File?> _cropImage({required File imageFile}) async{
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sizefont = size.width * 0.044;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tanika Tech',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),
            Column(
              children: [
                ImageWidget(),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: (){
                    _shareImage();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenWidth*0.6, screenHeight*0.04), // Set the width and height here
                  ),
                  child: Text("Share"),
                ),
              ],
            ),

            SizedBox(width: 16),
          ],
        ),
      ),

    );
  }
}
