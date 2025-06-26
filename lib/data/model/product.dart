class Product {
  Product({
    this.code,
    this.name,
    this.stock,
    this.unit,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.idKategori,
    this.kategori,
  });

  String? code;
  String? name;
  int? stock;
  String? unit;
  String? price;
  String? createdAt;
  String? updatedAt;
  String? idKategori;
  String? kategori;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        code: json["code"],
        name: json["name"],
        stock:
            json["stock"] != null ? int.parse(json["stock"].toString()) : null,
        unit: json["unit"],
        price: json["price"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        idKategori: json["id_kategori"],
        kategori: json["kategori"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "stock": stock,
        "unit": unit,
        "price": price,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "id_kategori": idKategori,
        "kategori": kategori,
      };
}
