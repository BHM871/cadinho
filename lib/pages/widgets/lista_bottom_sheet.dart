import 'package:cadinho/domain/lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaBottomSheet extends StatefulWidget {
  final Function(Lista) onChange;
  final Lista? lista;

  const ListaBottomSheet({super.key, required this.onChange, this.lista});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome da Lista'),
          ),
          TextField(
            controller: _merdacoController,
            decoration: const InputDecoration(labelText: 'Supermercado'),
          ),
          TextField(
            controller: _dataController,
            decoration: InputDecoration(labelText: 'Data'),
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
            child: const Text('Finalizar'),
            onPressed: () {
              if (_nomeController.text.isEmpty) return;

              widget.onChange(Lista(
                id: widget.lista?.id,
                titulo: _nomeController.text.trim(),
                mercado: _merdacoController.text.trim(),
                data: _dateTime,
                status: ListaStatus.by(_status),
              ));

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
