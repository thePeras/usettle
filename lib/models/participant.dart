import 'package:collectors/models/item.dart';
import 'package:collectors/models/profile.dart';

class Participant {
  const Participant({
    required this.id,
    required this.person,
    required this.items,
  });

  final int id;
  final Profile person;
  final List<Item> items;
}
