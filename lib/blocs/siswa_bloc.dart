import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_crud/blocs/blocs.dart';
import 'package:simple_crud/models/siswa_model.dart';
import 'package:simple_crud/services/services.dart';
import 'package:simple_crud/widgets/widgets.dart';

class SiswaBloc extends Bloc<SiswaEvent, SiswaState> {
  SiswaBloc() : super(SiswaUninitialized()) {
    on(_onCreate);
    on(_onFetch);
  }

  Future<void> _onFetch(SiswaFetch event, Emitter<SiswaState> emit) async {
    try {
      emit(SiswaLoading());

      List<SiswaModel> listSiswa = await SiswaService.fetch();

      emit(SiswaInitialized(listSiswa: listSiswa));
    } catch (e) {
      log(e.toString(), name: 'SiswaBloc - _onFetch');

      showSnackbar('Gagal ambil siswa', isError: true);

      emit(SiswaError());
    }
  }

  Future<void> _onCreate(SiswaCreate event, Emitter<SiswaState> emit) async {
    try {
      emit(SiswaLoading());

      await SiswaService.create(event.siswa);

      showSnackbar('Sukses tambah siswa');

      emit(SiswaCreateSuccess());

      add(SiswaFetch());
    } catch (e) {
      log(e.toString(), name: 'SiswaBloc - _onCreate');

      showSnackbar('Gagal tambah siswa', isError: true);

      emit(SiswaError());
    }
  }
}
