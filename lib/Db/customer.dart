import 'package:hive/hive.dart';
part 'customer.g.dart';

@HiveType(typeId: 0)
class itemlist extends HiveObject {
  itemlist(
    this.item_list,
  );

  @HiveField(0)
  List item_list;
}