import 'package:hive/hive.dart';
part 'customer.g.dart';

@HiveType(typeId: 0)
class ItemList extends HiveObject {
  @HiveField(0)
  late List<String> itemList;
}

@HiveType(typeId: 1)
class Location extends HiveObject {
  @HiveField(0)
  late List<String> locationList;
  Location(this.locationList);
}
