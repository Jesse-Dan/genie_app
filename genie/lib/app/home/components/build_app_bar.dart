import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../chat_page.dart';
import '../../routes/app_pages.dart';

Align buildButtomAppBar(BuildContext context) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => Get.toNamed(Routes.CHAT_IMAGE),
              child: Icon(
                MdiIcons.image,
                color: Colors.blue.shade900,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatTextView(),
                  ),
                );
              },
              child: Icon(
                Icons.keyboard,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ));
}
