import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_crud/blocs/blocs.dart';
import 'package:simple_crud/models/models.dart';

class CreateSiswaScreen extends StatefulWidget {
  const CreateSiswaScreen({Key? key}) : super(key: key);

  @override
  State<CreateSiswaScreen> createState() => _CreateSiswaScreenState();
}

class _CreateSiswaScreenState extends State<CreateSiswaScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _bookPageController = TextEditingController();
  final List<String> _class = ['XI MIPA 1', 'XI MIPA 2', 'XI MIPA 3'];
  final GlobalKey<FormState> _form = GlobalKey();
  final ValueNotifier<List<BookModel>> _books = ValueNotifier([]);
  late SiswaBloc _siswaBloc;
  String? _selectedClass;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    _siswaBloc = BlocProvider.of(context);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _bookTitleController.dispose();
    _bookPageController.dispose();

    super.dispose();
  }

  void _showDatePickerAction() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      DateFormat format = DateFormat('dd MMMM y');
      _selectedDate = date;
      _dateController.text = format.format(date);
    }
  }

  void _addBookAction() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'add_book_dialog',
      pageBuilder: (context, a1, a2) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _bookTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextFormField(
                  controller: _bookPageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Page',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    BookModel book = BookModel(
                      title: _bookTitleController.text.trim(),
                      page: int.parse(_bookPageController.text.trim()),
                    );

                    // buat list baru untuk trigger agar biar state ke update
                    _books.value = List.from(_books.value)..add(book);

                    _bookTitleController.clear();
                    _bookPageController.clear();

                    Get.back();
                  },
                  child: const Text('Add Book'),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, a1, a2, child) {
        double curve = Curves.elasticInOut.transform(a1.value);

        return Transform.scale(
          scale: curve,
          child: child,
        );
      },
    );
  }

  void _submitAction() {
    if (_form.currentState!.validate()) {
      SiswaModel siswa = SiswaModel(
        nama: _nameController.text.trim(),
        kelas: _selectedClass!,
        tanggalLahir: _selectedDate!,
        books: [],
      );

      _siswaBloc.add(SiswaCreate(siswa: siswa));
    }
  }

  void _siswaListener(BuildContext context, SiswaState state) {
    if (state is SiswaLoading) {
      setState(() => _isLoading = true);
    }

    if (state is SiswaCreateSuccess || state is SiswaError) {
      setState(() => _isLoading = false);

      if (state is SiswaCreateSuccess) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SiswaBloc, SiswaState>(
      listener: _siswaListener,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Siswa')),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            children: [
              TextFormField(
                controller: _nameController,
                validator: ValidationBuilder().required().build(),
                decoration: const InputDecoration(
                  hintText: 'Nama siswa',
                ),
                readOnly: _isLoading,
              ),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                hint: const Text('Pilih kelas'),
                validator: ValidationBuilder().required().build(),
                items: _class
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (selectedClass) => _selectedClass = selectedClass,
              ),
              TextFormField(
                controller: _dateController,
                onTap: _isLoading ? null : _showDatePickerAction,
                readOnly: true,
                validator: ValidationBuilder().required().build(),
                decoration: const InputDecoration(
                  hintText: 'Pilih tanggal lahir',
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _addBookAction,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: const Text('Add Book'),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<List<BookModel>>(
                valueListenable: _books,
                builder: (context, books, child) {
                  return Column(
                    children: books
                        .asMap()
                        .entries
                        .map((e) => Row(
                              children: [
                                Text(e.value.title),
                                const SizedBox(width: 20),
                                Text(e.value.page.toString()),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    int index = e.key;

                                    List<BookModel> books2 =
                                        List.from(_books.value);
                                    books2.removeAt(index);

                                    _books.value = books2;
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _submitAction,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
