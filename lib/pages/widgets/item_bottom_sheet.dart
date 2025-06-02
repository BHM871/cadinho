import 'package:cadinho/domain/item.dart';
import 'package:flutter/material.dart';

class ItemBottomSheet extends StatefulWidget {
  final Function(Item) onChange;
  final int idLista; 
  final Item? item;

  const ItemBottomSheet({super.key, required this.onChange, required this.idLista, this.item});

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _valorController = TextEditingController();
  String _unidade = ItemUnidade.kg.name;

  @override
  void initState() {
    super.initState();

    _nomeController.text = widget.item?.titulo ?? '';
    _quantidadeController.text = widget.item?.quantidade.toString() ?? '';
    _valorController.text = widget.item?.valor.toString() ?? '';
    _unidade = widget.item?.unidade.name ?? ItemUnidade.kg.name; 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantidadeController,
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  ),
                ),
                DropdownButton<String>(
                  value: _unidade,
                  onChanged: (value) {
                    setState(() {
                      _unidade = value!;
                    });
                  },
                  items: ['kg', 'lt', 'un'].map((u) => DropdownMenuItem(
                    value: u,
                    child: Text(u),
                  )).toList(),
                ),
              ],
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Finalizar'),
              onPressed: () {
                if (_nomeController.text.trim().isEmpty || _quantidadeController.text.trim().isEmpty || _valorController.text.trim().isEmpty) {
                  return;
                }

                final quantidade = double.tryParse(_quantidadeController.text);
                final preco = double.tryParse(_valorController.text);
                if (quantidade == null || preco == null) return;

                widget.onChange(Item(
                  titulo: _nomeController.text,
                  quantidade: quantidade,
                  unidade: ItemUnidade.by(_unidade),
                  valor: preco,
                  promocional: widget.item?.promocional,
                  qtPromocao: widget.item?.qtPromocao,
                  idLista: widget.idLista,
                ));

                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
