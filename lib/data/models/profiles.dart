class ProfilesModel {
  final String id;
  final String nama;
  final String notelp;
  final String role;
  final String image;

  ProfilesModel({required this.id, required this.nama, required this.notelp,required this.role, required this.image});

  factory ProfilesModel.fromJson(Map<String, dynamic> json) {
    return ProfilesModel(
      id: json['id'],
      nama: json['nama'] ?? '',
      notelp: json['notelp'] ?? '',
      role: json['role'] ?? 'customer',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'notelp': notelp,
      'role': role,
      'image': image,
    };
  }
}