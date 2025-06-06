import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/importar_dialog.dart';
import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaBottomSheet extends StatefulWidget {
  final Lista? lista;
  final ListaViewModel viewModel;
  final Function(Lista?) onChange;
  final Function(String) onImporte;

  const ListaBottomSheet({
    super.key,
    this.lista,
    required this.viewModel,
    required this.onChange,
    required this.onImporte,
  });

  @override
  State<ListaBottomSheet> createState() => _ListaBottomSheetState();
}

class _ListaBottomSheetState extends State<ListaBottomSheet> {
  final _nomeController = TextEditingController();
  final _merdacoController = TextEditingController();
  final _dataController = TextEditingController();
  DateTime? _dateTime = DateTime.now();
  String _status = "";

  @override
  void initState() {
    super.initState();

    _nomeController.text = widget.lista?.titulo ?? '';
    _merdacoController.text = widget.lista?.mercado ?? '';
    _dateTime = widget.lista?.data ?? DateTime.now();
    if (_dateTime != null) {
      _dataController.text = DateFormat('dd/MM/yyyy').format(_dateTime!);
    }
    _status = widget.lista?.status.value ?? ListaStatus.pendente.value;
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    return picked;
  }

  void _click() {
    if (_nomeController.text.isEmpty) return;

    Lista? lista = Lista(
      id: widget.lista?.id,
      titulo: _nomeController.text.trim(),
      mercado: _merdacoController.text.trim(),
      data: _dateTime,
      status: ListaStatus.by(_status),
      total: widget.lista?.total ?? 0
    );

    var future = widget.lista == null
        ? widget.viewModel.criar(lista)
        : widget.viewModel.atualizar(lista);

    future.then((lista) {
      widget.onChange(lista);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        top: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
      ),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          builder: (builder) => ImportarDialog(
                            onImportar: widget.onImporte,
                          ),
                        );
                      },
                      child: const Text('Importe'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Lista'),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _merdacoController,
                decoration: const InputDecoration(labelText: 'Supermercado'),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(labelText: 'Data'),
                textInputAction: TextInputAction.done,
                onTap: () async {
                  DateTime? date = await _selectDate(context);
                  _dateTime = date; 
          
                  if (date != null) {
                    _dataController.text = DateFormat('dd/MM/yyyy').format(date);
                  } else {
                    _dataController.text = '';
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _status,
                onChanged: (value) {
                  _status = value!;
                  setState(() {});
                },
                items: ['PENDENTE', 'EM CURSO', 'FINALIZADO'].map((u) => DropdownMenuItem(
                  value: u,
                  child: Text(u),
                )).toList(),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: _click,
                child: const Text('Finalizar'),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
