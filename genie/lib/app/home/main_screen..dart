import 'package:flutter/material.dart';

import '../chat_page.dart';
import '../services/speech_to_text_service.dart';
import 'components/build_app_bar.dart';
import 'components/build_hello_text.dart';
import 'components/build_how_can_i_help_text.dart';
import 'components/build_i_want_to_know_btn.dart';
import 'components/build_logo_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SpeechServices appPermissions = SpeechServices();
  bool isListening = false;
  String collectedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildHelloText(),
          buildLogoListenState(context, isListening: isListening),
          buildHowCanIHelpText(),
          buildIWantToKnowBtn(),
          buildButtomAppBar(context)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 27.0),
        child: FloatingActionButton(
          elevation: 20,
          backgroundColor: Colors.white,
          child: Icon(
            isListening ? Icons.mic_none_rounded : Icons.mic,
            color: Colors.blue.shade900,
          ),
          onPressed: () {
            toggleRecording();
          },
        ),
      ),
    );
  }

  // toggle recording
  Future toggleRecording() => SpeechServices.togglerecord(onResult: (onResult) {
        setState(() {
          if (onResult.isEmpty) {
            print('null');
          } else {
            setState(() {
              collectedText = onResult;
            });
            // print(text);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatTextView(
                          textFromSTT: collectedText,
                        )));
            // print(text);
          }
        });
      }, onlistening: (bool value) {
        setState(() {
          isListening = value;
        });
      });
}
