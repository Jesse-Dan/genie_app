// ignore_for_file: unnecessary_null_comparison, avoid_print, must_be_immutable

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:status_alert/status_alert.dart';
import 'package:whatsapp/whatsapp.dart';
import '../constants/constants.dart';
import 'chat_gpt_model.dart';
import 'routes/app_pages.dart';
import 'services/speech_to_text_service.dart';
import 'widget/chat_message.dart';

class ChatTextView extends StatefulWidget {
  String textFromSTT;

  ChatTextView({Key? key, this.textFromSTT = ''}) : super(key: key);

  @override
  State<ChatTextView> createState() => _ChatTextViewState();
}

class _ChatTextViewState extends State<ChatTextView> {
  List<Map<String, dynamic>> generatedAnswers = [];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;
  SpeechServices appPermissions = SpeechServices();
  bool isListening = false;
  var onclicked = false;
  WhatsApp whatsapp = WhatsApp();

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.textFromSTT == null) {
        print('speech from first page is null');
      } else if (widget.textFromSTT.isEmpty) {
        print('speech from first page is empty');
      } else {
        _textController.text = widget.textFromSTT;
      }
    });
    isLoading = false;
  }

  // generate response

  Future<String> generateResponse(String prompt) async {
    const apiKey = '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';

    var url = Uri.https("api.openai.com", "/v1/completions");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    // Do something with the response
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    generatedAnswers.add(newresponse);

    return newresponse['choices'][0]['text'];
  }

  final numberController = TextEditingController();
  sendMessageToAdmin() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: TextField(
              keyboardType: TextInputType.phone,
              controller: numberController,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    bool sN = await whatsapp.messagesText(
                        to: int.parse(numberController.text),
                        message:
                            "Hey, GENIE user, you started a debug ssession pleas wed love to know your problem also contact the developer on twitter  https://twitter.com/jessedan160",
                        previewUrl: true);

                    if (sN) {
                      numberController.clear();
                      Navigator.pop(context);
                    } else {
                      print('couldn\'t send message');
                    }
                  },
                  child: Text(
                    'done',
                    style: TextStyle(color: Colors.green),
                  ))
            ],
          );
        });
  }

  // toggle recording
  toggleRecording() {
    _textController.clear();

    SpeechServices.togglerecord(onResult: (onResult) {
      setState(() {
        _textController.text = onResult;
        if (onResult.isEmpty) {
          print('null');
        } else {
          print('from inner stt ${_textController.text}');
        }
      });
    }, onlistening: (bool value) {
      setState(() {
        isListening = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: add the drawer and other features is next realease
      drawerScrimColor: Colors.blue[300]!.withOpacity(0.5),
      endDrawer: MyDrawer(),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 70,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: AvatarGlow(
            glowColor: Colors.blue,
            endRadius: 5,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         StatusAlert.show(
        //           context,
        //           duration: Duration(seconds: 2),
        //           title: 'GENIE',
        //           subtitle: 'Double click GENIE answers to copy them. 😜',
        //           configuration:
        //               IconConfiguration(icon: Icons.favorite_border_rounded),
        //           maxWidth: 260,
        //         );
        //       },
        //       icon: const Icon(Icons.info))
        // ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "GENIE VIRTUAL ASSISTANT",
              style: GoogleFonts.actor(),
              maxLines: 2,
            ),
            Text(
              "Text Completion",
              style: GoogleFonts.actor(),
              maxLines: 2,
            ),
          ],
        ),
        backgroundColor: Colors.blue[900],
        // botBackgroundColor,
      ),
      // backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildList()),
            Visibility(
              visible: isLoading,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                      highlightColor: Colors.grey,
                      baseColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ))),
            ),
            Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        // offset: Offset(4, 4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        blurStyle: BlurStyle.outer)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const SizedBox(height: 200),
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: botBackgroundColor,
              ),
              child: IconButton(
                icon: isListening
                    ? AvatarGlow(
                        animate: true,
                        endRadius: 75,
                        glowColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.mic_none_outlined,
                          size: 30,
                        ),
                      )
                    : const Icon(
                        Icons.mic,
                        size: 30,
                      ),
                onPressed: () {
                  toggleRecording();
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[900],
              ),
              child: IconButton(
                  splashColor: Colors.blue[900]!.withOpacity(0.2),
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: _textController.text.isNotEmpty
                      ? () {
                          setState(
                            () {
                              _messages.add(
                                ChatMessage(
                                  time: 3,
                                  text: _textController.text,
                                  chatMessageType: ChatMessageType.user,
                                ),
                              );
                              isLoading = true;
                            },
                          );
                          var input = _textController.text;
                          _textController.clear();
                          Future.delayed(const Duration(milliseconds: 50))
                              .then((_) => _scrollDown());
                          generateResponse(input).then((value) {
                            setState(() {
                              var newValue = value;

                              isLoading = false;
                              _messages.add(
                                ChatMessage(
                                  time: 9,
                                  text: (newValue),
                                  chatMessageType: ChatMessageType.bot,
                                ),
                              );
                            });
                          });
                          _textController.clear();
                          Future.delayed(const Duration(milliseconds: 50))
                              .then((_) => _scrollDown());
                          _textController.clear();
                        }
                      : () {}),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        cursorColor: Colors.blue[900],
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
            color: Color.fromARGB(255, 89, 88, 88), fontSize: 20),
        controller: _textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.add,
            size: 25,
          ),
          fillColor: botBackgroundColor,
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Padding _buildList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          var message = _messages[index];
          return ChatMessageWidget(
            time: DateTime.now(),
            message: message.text,
            chatMessageType: message.chatMessageType,
          );
        },
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, top: 45, bottom: 10, right: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35)),
        child: Drawer(
          backgroundColor: Colors.blue[900],
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 5.0, bottom: 0),
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 25),
                            onPressed: (() => Navigator.pop(context)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 5.0, bottom: 0),
                          child: IconButton(
                              onPressed: () {
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 2),
                                  title: 'GENIE',
                                  subtitle:
                                      'Double click GENIE answers to copy them. 😜',
                                  configuration: IconConfiguration(
                                      icon: Icons.favorite_border_rounded,
                                      color: Colors.white),
                                  maxWidth: 260,
                                );
                              },
                              icon: const Icon(
                                Icons.info,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 4, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Jesse Oyofo",
                              style: GoogleFonts.alikeAngular(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Dan-Amuda .F',
                              style: GoogleFonts.adventPro(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => Get.toNamed(Routes.CHAT_IMAGE),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.withOpacity(.2),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.blue.withOpacity(0.1),
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage('assets/author.jpg'),
                                        // child: Icon(Icons.image,
                                        //     size: 40, color: Colors.blue[900]),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'C.E.O and Co-Founder',
                                            style: GoogleFonts.dmSans(
                                                fontSize: 18),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            textAlign: TextAlign.left,
                                            'BREACHAI GROUP',
                                            style: GoogleFonts.dmSans(
                                                fontSize: 12,
                                                color: Colors.blue
                                                    .withOpacity(0.6)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.CHAT_TEXT),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                radius: 30,
                                child: Icon(Icons.text_fields_sharp,
                                    size: 40, color: Colors.blue[900]),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Text completion',
                                    style: GoogleFonts.dmSans(fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    'Helps you in overall text completion',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.CHAT_IMAGE),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                radius: 30,
                                child: Icon(Icons.image,
                                    size: 40, color: Colors.blue[900]),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Image Generation',
                                    style: GoogleFonts.dmSans(fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    'You can also generate images',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => StatusAlert.show(
                          context,
                          duration: Duration(seconds: 2),
                          title: 'GENIE',
                          subtitle: 'Code Completion feature coming soon. 😎',
                          configuration: IconConfiguration(
                              icon: Icons.favorite_border_rounded,
                              color: Colors.white),
                          maxWidth: 260,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                radius: 30,
                                child: Icon(Icons.code,
                                    size: 40, color: Colors.blue[900]),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Code Completion',
                                    style: GoogleFonts.dmSans(fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    'Helps you write your Code',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => StatusAlert.show(
                          context,
                          duration: Duration(seconds: 2),
                          title: 'GENIE',
                          subtitle: 'Embeddings feature coming soon. 😎',
                          configuration: IconConfiguration(
                              icon: Icons.favorite_border_rounded,
                              color: Colors.white),
                          maxWidth: 260,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                radius: 30,
                                child: Icon(Icons.auto_graph,
                                    size: 40, color: Colors.blue[900]),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Embeddings',
                                    style: GoogleFonts.dmSans(fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    'use the Embedding feature ',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
