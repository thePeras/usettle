import 'package:collectors/models/item.dart';
import 'package:collectors/models/profile.dart';

class Participant {
  const Participant({required this.person, required this.items});

  final Profile person;
  final List<Item> items;
}
