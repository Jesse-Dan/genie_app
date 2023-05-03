enum ChatMessageType { user, bot }

enum ChatmessageMedium { voice, text, picture }

class ChatMessage {
  ChatMessage({
    required this.time,
    required this.text,
    required this.chatMessageType,
  });

  final String text;
  final int time;
  final ChatMessageType chatMessageType;
}
