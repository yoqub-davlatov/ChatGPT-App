class ChatModels {
  final String message;
  final int chatIndex;

  ChatModels({required this.message, required this.chatIndex});

  factory ChatModels.fromJson(Map<String, dynamic> json) => ChatModels(
        message: json['msg'],
        chatIndex: json['chatIndex'],
      );
}
