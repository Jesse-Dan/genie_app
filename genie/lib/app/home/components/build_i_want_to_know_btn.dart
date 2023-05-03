
  import 'package:flutter/material.dart';

Padding buildIWantToKnowBtn() {
    return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            type: MaterialType.button,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 30, right: 30),
              child: Text(
                'I want to know',
                style: TextStyle(fontSize: 30, color: Colors.blue.shade900),
              ),
            ),
          ),
        );
  }
