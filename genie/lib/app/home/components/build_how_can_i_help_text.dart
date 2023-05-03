
  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Padding buildHowCanIHelpText() {
    return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Text(
            'How can i help \n you ?',
            style: GoogleFonts.secularOne(fontSize: 35, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
  }