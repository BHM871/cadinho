import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';

class ImportarDialog extends StatefulWidget {
  final ListaViewModel viewModel;
  final Function() updateView;

  const ImportarDialog({
    super.key,
    required this.viewModel,
    required this.updateView,
  });

  @override
  State<StatefulWidget> createState() => _ImportDialog();
}

class _ImportDialog extends State<ImportarDialog> {

  final _importarController = TextEditingController();

  void _click() {
    widget.viewModel.importar(_importarController.text.trim()).then((lista) {
      if (lista == null) return;
      widget.updateView();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importe Lista'),
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _importarController,
                decoration: const InputDecoration(labelText: 'Cole aqui..'),
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                minLines: 8,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: _click,
                child: const Text('Importar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
