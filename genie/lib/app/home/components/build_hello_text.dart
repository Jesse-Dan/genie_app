
  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typewritertext/typewritertext.dart';

Padding buildHelloText() {
    return Padding(
          padding: const EdgeInsets.only(bottom: 30.0, top: 50),
          child: TypeWriterText(
            play: true,
            text: Text(
              "Hello \n I'm GENIE",
              style: GoogleFonts.barlow(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            duration: Duration(milliseconds: 50),
          ),
        );
  }