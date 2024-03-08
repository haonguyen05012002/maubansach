class Sach {
    final String id_sach;
    final String tieu_de;
    final String ngay_xuat_ban;
    final String id_theloai;
    final String mo_ta;
    final String hinh_bia;
    final String noidung;
    final String id_nhaxuatban;
    final String id_tacgia;
    final String danhgia;
    final String gia;

    Sach({
      required this.id_sach,
      required this.tieu_de,
      required this.ngay_xuat_ban,
      required this.id_theloai,
      required this.mo_ta,
      required this.hinh_bia,
      required this.noidung,
      required this.id_nhaxuatban,
      required this.id_tacgia,
      required this.danhgia,
      required this.gia
}
     );

    factory Sach.fromJson(Map<String, dynamic> json){
      return Sach(
      id_sach: json["id_sach"],
      tieu_de : json["tieu_de"],
      ngay_xuat_ban : json["ngay_xuat_ban"],
      id_theloai : json["id_theloai"],
    mo_ta : json["mo_ta"],
    hinh_bia : json["hinh_bia"],
    noidung : json["noidung"],
    id_nhaxuatban : json["id_nhaxuatban"],
    id_tacgia : json["id_tacgia"],
    danhgia : json["danhgia"],
    gia : json["gia"],
    );
    }
}