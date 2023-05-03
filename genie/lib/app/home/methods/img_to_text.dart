


  // File? _imageFile;
  // String _mlResult = '<no result>';
  // final _picker = ImagePicker();

  // Future<bool> _pickImage() async {
  //   setState(() => _imageFile = null);
  //   final File? imageFile = await showDialog<File>(
  //     context: context,
  //     builder: (ctx) => SimpleDialog(
  //       children: <Widget>[
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Take picture'),
  //           onTap: () async {
  //             final PickedFile? pickedFile =
  //                 await _picker.getImage(source: ImageSource.camera);
  //             Navigator.pop(ctx, File(pickedFile!.path));
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.image),
  //           title: const Text('Pick from gallery'),
  //           onTap: () async {
  //             try {
  //               final PickedFile? pickedFile =
  //                   await _picker.getImage(source: ImageSource.gallery);
  //               Navigator.pop(ctx, File(pickedFile!.path));
  //             } catch (e) {
  //               print(e);
  //               Navigator.pop(ctx, null);
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   if (imageFile == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please pick one image first.')),
  //     );
  //     return false;
  //   }
  //   setState(() => _imageFile = imageFile);
  //   print('picked image: ${_imageFile}');
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Image to text coming soon .')),
  //   );
  //   return true;
  // }

  // ///

  // // Future<void> _textOcr() async {
  // //   setState(() => _mlResult = '<no result>');
  // //   if (await _pickImage() == false) {
  // //     return;
  // //   }
  // //   String result = '';
  // //   final FirebaseVisionImage visionImage =
  // //       FirebaseVisionImage.fromFile(_imageFile);
  // //   final TextRecognizer textRecognizer =
  // //       FirebaseVision.instance.textRecognizer();
  // //   final VisionText visionText =
  // //       await textRecognizer.processImage(visionImage);
  // //   final String text = visionText.text;
  // //   debugPrint('Recognized text: "$text"');
  // //   result += 'Detected ${visionText.blocks.length} text blocks.\n';
  // //   for (final TextBlock block in visionText.blocks) {
  // //     final Rect boundingBox = block.boundingBox;
  // //     final List<Offset> cornerPoints = block.cornerPoints;
  // //     final String text = block.text;
  // //     final List<RecognizedLanguage> languages = block.recognizedLanguages;
  // //     result += '\n# Text block:\n '
  // //         'bbox=$boundingBox\n '
  // //         'cornerPoints=$cornerPoints\n '
  // //         'text=$text\n languages=$languages';
  // //     // for (TextLine line in block.lines) {
  // //     //   // Same getters as TextBlock
  // //     //   for (TextElement element in line.elements) {
  // //     //     // Same getters as TextBlock
  // //     //   }
  // //     // }
  // //   }
  // //   if (result.isNotEmpty) {
  // //     setState(() => _mlResult = result);
  // //     setState(() {
  // //       collectedText = _mlResult;
  // //     });
  // //   }
  // // }
