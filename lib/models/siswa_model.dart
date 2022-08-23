import 'package:intl/intl.dart';
import 'package:simple_crud/models/models.dart';

class SiswaModel {
  final int? id;
  final String nama;
  final String kelas;
  final DateTime tanggalLahir;
  final List<BookModel> books;

  SiswaModel({
    this.id,
    required this.nama,
    required this.kelas,
    required this.tanggalLahir,
    required this.books,
  });

  factory SiswaModel.fromMap(dynamic map) {
    DateFormat format = DateFormat('y-M-d');

    return SiswaModel(
      id: map['id'],
      nama: map['nama'],
      kelas: map['kelas'],
      tanggalLahir: format.parse(map['tgl_lahir']),
      books: [],
    );
  }
}
