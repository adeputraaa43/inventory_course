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
    this.harga,
  });

  int? idSupplier;
  String? namaSupplier;
  String? namaProduk;
  String? noTelp;
  String? jumlahProduk;
  String? produkTerjual;
  String? sisaProduk;
  String? createdAt;
  int? harga; // ← jadi int

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
        harga: json["harga"] != null
            ? int.parse(json["harga"].toString())
            : null, // ← parse jadi int
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
        "harga": harga, // ← kirim int
      };
}
