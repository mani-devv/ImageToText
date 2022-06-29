import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("S C A N N E R"),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!textScanning && imageFile == null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 280,
                        height: 280,
                        color: Colors.deepPurple.shade200,
                      ),
                    ),
                  if (imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 280,
                        height: 280,
                        // padding: EdgeInsets.symmetric(vertical: 8),
                        color: Colors.deepPurple.shade200,
                        // margin: EdgeInsets.all(20),
                        child: Image.file(
                          File(imageFile!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 280,
                      height: 160,
                      padding: const EdgeInsets.all(8),
                      color: Colors.deepPurple[50],
                      child: SingleChildScrollView(
                        child: SelectableText(scannedText),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.document_scanner_rounded,
                            size: 30),
                        label: Text("Scan".toUpperCase()),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                            const Size(150, 50),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        icon: const Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 30,
                        ),
                        label: Text("Pick".toUpperCase()),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                            const Size(150, 50),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        // Navigator.push(
        //   context,
        //   PageTransition(
        //     child: FinalScreen(),
        //     type: PageTransitionType.rightToLeftJoined,
        //   ),
        // );
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {
        scannedText = "Error occured while Scanning";
      });
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetecor = GoogleMlKit.vision.textDetectorV2();
    RecognisedText recognisedText = await textDetecor.processImage(inputImage);
    await textDetecor.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
