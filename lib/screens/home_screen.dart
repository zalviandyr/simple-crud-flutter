import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_crud/blocs/blocs.dart';
import 'package:simple_crud/models/siswa_model.dart';
import 'package:simple_crud/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SiswaBloc _siswaBloc;

  @override
  void initState() {
    _siswaBloc = BlocProvider.of(context);

    _siswaBloc.add(SiswaFetch());

    super.initState();
  }

  void _toCreateSiswaAction() {
    Get.to(() => const CreateSiswaScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Crud')),
      body: BlocBuilder<SiswaBloc, SiswaState>(
        builder: (context, state) {
          if (state is SiswaInitialized) {
            return ListView.builder(
              itemCount: state.listSiswa.length,
              itemBuilder: (context, index) {
                SiswaModel siswa = state.listSiswa[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 2),
                          spreadRadius: .5,
                          blurRadius: .5,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(siswa.nama),
                            Text(siswa.kelas),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd MMMM y').format(siswa.tanggalLahir),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red.shade400,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toCreateSiswaAction,
        mini: true,
        child: const Icon(Icons.add, size: 17),
      ),
    );
  }
}
