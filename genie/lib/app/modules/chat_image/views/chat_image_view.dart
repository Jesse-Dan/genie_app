import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/constants.dart';
import '../../../chat_page.dart';
import '../../../common/headers.dart';
import '../controllers/chat_image_controller.dart';
import 'widgets/image_card.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
class ChatImageView extends GetView<ChatImageController> {
  ChatImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller.getGenerateImages("cat");

    return Scaffold(
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

        title: Text(
          "GENIE VIRTUAL ASSISTANT",
          style: GoogleFonts.actor(),
          maxLines: 2,
        ),
        backgroundColor: Colors.blue[900],
        // botBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => Center(
                  child: controller.state.value == ApiState.loading
                      ? const CircularProgressIndicator()
                      : controller.state.value == ApiState.success
                          ? ImageCard(images: controller.images)
                          : controller.state.value == ApiState.notFound
                              ? const Center(
                                  child: Text("Search what ever you want."),
                                )
                              : Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Image Generation Failed!",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle()
                                            .copyWith(height: 2),
                                      ),
                                      Icon(
                                        Icons.image,
                                        size: 40,
                                      )
                                    ],
                                  ),
                                ),
                ),
              ),
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
                  topRight: Radius.circular(40),
                ),
              ),
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

  Padding _buildList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: controller.scrollController,
        // itemCount: _messages.length,
        itemBuilder: (context, index) {
          // var message = _messages[index];
          return ImageCard(images: controller.images);
        },
      ),
    );
  }

  Widget _buildSubmit() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !(controller.state.value == ApiState.loading),
        child: Container(
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
              onPressed: controller.searchTextController.text.isNotEmpty
                  ? () {
                      controller.getGenerateImages(
                          controller.searchTextController.text);

                      controller.searchTextController.clear();
                      Future.delayed(const Duration(milliseconds: 50));
                      // .then((_) => _scrollDown());
                      controller.searchTextController.clear();
                    }
                  : () {}),
        ),
      ),
    );
  }

  // void _scrollDown() {
  //   controller.scrollController.animateTo(
  //     controller.scrollController.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  // }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        cursorColor: Colors.blue[900],
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
            color: Color.fromARGB(255, 89, 88, 88), fontSize: 20),
        controller: controller.searchTextController,
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
}
