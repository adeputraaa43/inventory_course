class Kategori {
  final String id;
  final String name;

  Kategori({required this.id, required this.name});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id_kategori'],
      name: json['nama_kategori'],
    );
  }
}
