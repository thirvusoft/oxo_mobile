class offline {
  final int? id;
  final String name;

  offline({
    this.id,
    required this.name,
  });

  offline.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'];

  Map<String, Object?> toMap() {
    return {'id': id, "name": name};
  }

  static query(String s) {}
}
