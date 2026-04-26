import 'package:hive/hive.dart';

class PostModel extends HiveObject {
  String id;
  String pseudonym;
  String category; // témoignage, conseil, juridique, soutien
  String content;
  int hearts;
  int comments;
  DateTime createdAt;

  PostModel({
    required this.id,
    required this.pseudonym,
    required this.category,
    required this.content,
    this.hearts = 0,
    this.comments = 0,
    required this.createdAt,
  });
}

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 6;

  @override
  PostModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (var i = 0; i < n; i++) reader.readByte(): reader.read()};
    return PostModel(
      id: f[0], pseudonym: f[1], category: f[2], content: f[3],
      hearts: f[4] ?? 0, comments: f[5] ?? 0, createdAt: f[6],
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer..writeByte(7)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.pseudonym)
      ..writeByte(2)..write(obj.category)
      ..writeByte(3)..write(obj.content)
      ..writeByte(4)..write(obj.hearts)
      ..writeByte(5)..write(obj.comments)
      ..writeByte(6)..write(obj.createdAt);
  }
}
