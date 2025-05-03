import 'package:usettle/models/item.dart';
import 'package:usettle/models/profile.dart';

class Participant {
  const Participant({
    required this.id,
    required this.person,
    required this.items,
    required this.author,
  });

  final int id;
  final Profile person;
  final bool author;
  final List<Item> items;
}
