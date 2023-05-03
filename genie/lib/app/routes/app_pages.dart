import 'package:get/get.dart';

import '../chat_page.dart';
import '../modules/chat_image/bindings/chat_image_binding.dart';
import '../modules/chat_image/views/chat_image_view.dart';
import '../modules/chat_text/bindings/chat_text_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../home/main_screen..dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_IMAGE,
      page: () => ChatImageView(),
      binding: ChatImageBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_TEXT,
      page: () => ChatTextView(),
      binding: ChatTextBinding(),
    ),
  ];
}
