class Supplier {
  Supplier({
    this.idSupplier,
    this.namaSupplier,
    this.namaProduk,
    this.noTelp,
    this.jumlahProduk,
    this.produkTerjual,
    this.sisaProduk,
    this.createdAt,
  });

  int? idSupplier;
  String? namaSupplier;
  String? namaProduk;
  String? noTelp;
  String? jumlahProduk;
  String? produkTerjual;
  String? sisaProduk;
  String? createdAt;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        idSupplier: json["id_supplier"] != null
            ? int.parse(json["id_supplier"].toString())
            : null,
        namaSupplier: json["nama_supplier"],
        namaProduk: json["nama_produk"],
        noTelp: json["no_telp"],
        jumlahProduk: json["jumlah_produk"],
        produkTerjual: json["produk_terjual"],
        sisaProduk: json["sisa_produk"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_supplier": idSupplier,
        "nama_supplier": namaSupplier,
        "nama_produk": namaProduk,
        "no_telp": noTelp,
        "jumlah_produk": jumlahProduk,
        "produk_terjual": produkTerjual,
        "sisa_produk": sisaProduk,
        "created_at": createdAt,
      };
}
