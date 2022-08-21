import 'package:equatable/equatable.dart';
import 'package:simple_crud/models/models.dart';

abstract class SiswaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiswaFetch extends SiswaEvent {
  SiswaFetch();
}

class SiswaCreate extends SiswaEvent {
  final SiswaModel siswa;

  SiswaCreate({required this.siswa});

  @override
  List<Object?> get props => [siswa];
}
