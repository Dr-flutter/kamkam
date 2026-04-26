import 'package:hive/hive.dart';

class MessageModel extends HiveObject {
  String id;
  String conversationId; // 'care' | 'rights' | 'anger'
  String text;
  bool isUser;
  DateTime timestamp;
  int? riskScore; // 0-100 for care

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.riskScore,
  });
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 3;

  @override
  MessageModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (var i = 0; i < n; i++) reader.readByte(): reader.read()};
    return MessageModel(
      id: f[0], conversationId: f[1], text: f[2], isUser: f[3],
      timestamp: f[4], riskScore: f[5],
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer..writeByte(6)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.conversationId)
      ..writeByte(2)..write(obj.text)
      ..writeByte(3)..write(obj.isUser)
      ..writeByte(4)..write(obj.timestamp)
      ..writeByte(5)..write(obj.riskScore);
  }
}
