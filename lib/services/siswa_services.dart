import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:simple_crud/models/models.dart';
import 'package:simple_crud/services/api.dart';

class SiswaService {
  static final Dio _dio = API.instance.dio;

  static Future<List<SiswaModel>> fetch() async {
    Response response = await _dio.get('/api/siswa');

    return (response.data['data'] as List)
        .map((elm) => SiswaModel.fromMap(elm))
        .toList();
  }

  static Future<void> create(SiswaModel siswa) async {
    DateFormat format = DateFormat('y-M-d');

    await _dio.post('/api/siswa', data: {
      'nama': siswa.nama,
      'kelas': siswa.kelas,
      'tgl_lahir': format.format(siswa.tanggalLahir),
    });
  }
}
