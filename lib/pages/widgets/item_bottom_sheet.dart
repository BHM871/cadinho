import 'package:cadinho/domain/item.dart';
import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:flutter/material.dart';

class ItemBottomSheet extends StatefulWidget {
  final ItemViewModel viewModel;
  final Lista lista; 
  final Item? item;
  final Function(Item?) onChange;

  const ItemBottomSheet({
    super.key, 
    required this.viewModel,
    required this.lista,
    this.item,
    required this.onChange,
  });

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _valorController = TextEditingController();
  final _promocionalController = TextEditingController();
  final _qtPromocaoController = TextEditingController();
  String _unidade = ItemUnidade.kg.name;

  @override
  void initState() {
    super.initState();

    _nomeController.text = widget.item?.titulo ?? '';
    _quantidadeController.text = widget.item?.quantidade.toString().replaceAll(".", ",") ?? '';
    _valorController.text = widget.item?.valor.toString().replaceAll(".", ",") ?? '';
    _promocionalController.text = widget.item?.promocional?.toString().replaceAll(".", ",") ?? '';
    _qtPromocaoController.text = widget.item?.qtPromocao?.toString().replaceAll(".", ",") ?? '';
    _unidade = widget.item?.unidade.name ?? ItemUnidade.kg.name; 
  }

  void _click() async {
    if (_nomeController.text.trim().isEmpty || _quantidadeController.text.trim().isEmpty) {
      return;
    }
    
    if (widget.lista.status == ListaStatus.emCurso && _valorController.text.trim().isEmpty) {
      return;
    }
    
    if (_valorController.text.contains(",")) {
      _valorController.text = _valorController.text
          .replaceAll(",", ".");
    }

    if (_quantidadeController.text.contains(",")) {
      _quantidadeController.text = _quantidadeController.text
          .replaceAll(",", ".");
    }

    final quantidade = double.tryParse(_quantidadeController.text);
    final preco = double.tryParse(_valorController.text);
    if (quantidade == null) return;
    if (widget.lista.status == ListaStatus.emCurso && preco == null) return;

    if (_promocionalController.text.contains(",")) {
      _promocionalController.text = _promocionalController.text
        .replaceAll(",", ".");
    }

    double? promocional = double.tryParse(_promocionalController.text);
    int? qtPromocao = int.tryParse(_qtPromocaoController.text);

    if (promocional != null) {
      if (qtPromocao == null || qtPromocao <= 1) return;

      if (quantidade % qtPromocao != 0) {
        bool? stop = await showDialog<bool>(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Você não pegou itens suficientes para ganhar promoção'),
                  const SizedBox(height: 15,),
                  Text('Pegue mais ${quantidade % qtPromocao} itens para pagar o valor promocional.'),
                  const SizedBox(height: 15,),
                  const Text('Deseja pegar mais ou menos itens?'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Sim'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Não'),
                ),
              ],
            );
          },
        );

        if (stop != null && stop) return;
      }
    }
    
    Item? item = Item(
      id: widget.item?.id,
      titulo: _nomeController.text,
      quantidade: quantidade,
      unidade: ItemUnidade.by(_unidade),
      valor: preco,
      promocional: promocional,
      qtPromocao: qtPromocao,
      idLista: widget.lista.id!,
    );

    var future = widget.item == null
        ? widget.viewModel.criar(item)
        : widget.viewModel.atualizar(item);
    
    future.then((item) {
      widget.onChange(item);
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
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantidadeController,
                      decoration: const InputDecoration(labelText: 'Quantidade'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 10),
              TextField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 10),
              const Text('Itens com Promoção'),
              const SizedBox(height: 10),
              TextField(
                controller: _promocionalController,
                decoration: const InputDecoration(labelText: 'Valor promocional'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _qtPromocaoController,
                decoration: const InputDecoration(labelText: 'A partir de quantos itens'),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                textInputAction: TextInputAction.done,
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
