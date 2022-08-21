import 'package:equatable/equatable.dart';
import 'package:simple_crud/models/models.dart';

abstract class SiswaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiswaUninitialized extends SiswaState {}

class SiswaLoading extends SiswaState {}

class SiswaError extends SiswaState {}

class SiswaCreateSuccess extends SiswaState {}

class SiswaInitialized extends SiswaState {
  final List<SiswaModel> listSiswa;

  SiswaInitialized({required this.listSiswa});

  @override
  List<Object?> get props => [listSiswa];
}
