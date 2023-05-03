
  import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

Padding buildLogoListenState(BuildContext context,{required bool isListening}) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: !isListening
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 5,
                              spreadRadius: 2,
                              color: Color.fromARGB(255, 104, 101, 101))
                        ],
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : AvatarGlow(
                  animate: true,
                  endRadius: 75,
                  glowColor: Theme.of(context).primaryColor,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 5,
                              spreadRadius: 2,
                              color: Color.fromARGB(255, 104, 101, 101))
                        ],
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        );
  }