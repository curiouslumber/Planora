import 'package:hive/hive.dart';

part 'people_model.g.dart';

@HiveType(typeId: 3)
class PeopleModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final List<String> email;
  @HiveField(4)
  final List<String> phone;

  PeopleModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.phone,
  });
}
