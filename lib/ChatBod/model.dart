class ModelMessage {
  final bool isprompt;
  final String message;
  final DateTime time;

  ModelMessage(
      {required this.isprompt, required this.message, required this.time});

  Map<String, dynamic> toJson() => {
        'isprompt': isprompt,
        'message': message,
        'time': time.toIso8601String(),
      };

  factory ModelMessage.fromJson(Map<String, dynamic> json) {
    return ModelMessage(
      isprompt: json['isprompt'],
      message: json['message'],
      time: DateTime.parse(json['time']),
    );
  }
}
