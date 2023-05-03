import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:typewritertext/typewritertext.dart';

import '../../constants/constants.dart';
import '../chat_gpt_model.dart';

//TODO: work in using the time to indicate when message was sent
class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {Key? key,
      required this.time,
      required this.message,
      required this.chatMessageType})
      : super(key: key);

  final String message;
  final ChatMessageType chatMessageType;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    return chatMessageType == ChatMessageType.bot
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.png'),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: chatMessageType == ChatMessageType.bot
                              ? botBackgroundColor
                              : backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (message.trim() == "") {
                            print('error picking the text');
                          } else {
                            print('success picking the text');
                            FlutterClipboard.copy(message)
                                .then((value) => StatusAlert.show(
                                      context,
                                      duration: Duration(seconds: 2),
                                      title: 'GENIE',
                                      subtitle: 'genie answer copied 😎',
                                      configuration: IconConfiguration(
                                          icon: Icons.done_rounded),
                                      maxWidth: 260,
                                    ));
                          }
                        },
                        child: TypeWriterText(
                          // play: false,
                          repeat: false,
                          maintainSize: false,
                          text: Text(message.trim(),
                              style: GoogleFonts.abel(
                                  color: Colors.black, fontSize: 15)),
                          duration: const Duration(milliseconds: 50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 70.0),
              //   child: Text(
              //     getTime(time),
              //     textAlign: TextAlign.start,
              //   ),
              // )
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: chatMessageType == ChatMessageType.bot
                                  ? botBackgroundColor
                                  : backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(16),
                          child: Text(message,
                              style: GoogleFonts.abel(color: Colors.white))),
                    ),
                    SizedBox(width: 10),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage('assets/user.png'),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 100.0),
                //   child: Text(getTime(time),style:GoogleFonts.abel()),
                // )
              ],
            ),
          );
  }

  String getTime(DateTime rawTime) {
    var formattime = DateFormat.jms();
    var realTime = formattime.format(rawTime);
    var hour = realTime.split(':')[0];
    var min = realTime.split(':')[1];
    var periodOfDays = realTime.split(' ')[1];

    var finalTime = '$hour:$min:$periodOfDays';

    return finalTime;
  }
}
