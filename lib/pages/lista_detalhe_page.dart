import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/item_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/item_tile.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:flutter/material.dart';

import '../domain/item.dart';

class ListaDetalhePage extends StatefulWidget {
  final Lista lista;
  final ItemViewModel viewModel;
  final Function(Lista) onChange;

  const ListaDetalhePage({required this.lista, required this.viewModel, required this.onChange, super.key});

  @override
  State<ListaDetalhePage> createState() => _ListaDetalhePageState();
}

class _ListaDetalhePageState extends State<ListaDetalhePage> {
  late ItemViewModel viewModel;
  late Lista lista;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    lista = widget.lista;

    viewModel.buscar(lista.id!).then((itens) {
      lista.itens = itens ?? [];
      setState(() {});
    });
  }

  void _updateView() async {
    lista.itens = (await viewModel.buscar(lista.id!)) ?? [];

    lista.total = 0;
    for(Item i in lista.itens) {
      lista.total += i.getValorTotal();
    }

    setState(() {});
    widget.onChange(lista);
  }

  void _adicionarProduto() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemBottomSheet(
        lista: lista,
        viewModel: viewModel,
        onChange: (item) async {
          if (item == null) {
            _showErroModal('Erro ao salvar produto');
            return;
          }

          lista.itens.add(item);
          lista.total += item.getValorTotal();
          setState(() {});

          widget.onChange(lista);
        }
      ),
    );
  }

  void _editarProduto(int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemBottomSheet(
        lista: lista,
        viewModel: viewModel,
        item: lista.itens[index],
        onChange: (item) async {
          if (item == null) {
            _showErroModal('Erro ao salvar produto');
            return;
          }

          lista.total -= lista.itens[index].getValorTotal();
          lista.total += item.getValorTotal();
          lista.itens[index] = item;
          setState(() {});

          widget.onChange(lista);
        }
      ),
    );
  }

  void _finalizarCompra() async {
    var map = lista.toMap();
    map['status'] = ListaStatus.finalizado.value;

    lista = Lista.fromMap(map);
    lista.itens = (await viewModel.buscar(lista.id!)) ?? [];

    setState(() {});
    widget.onChange(lista);
  }

  void _showErroModal(String mensagem) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (buider) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${lista.titulo} | ${lista.mercado}'),
      ),
      body: SafeArea(
        child: lista.itens.isEmpty
            ? const Center(child: Text('Nenhum produto na lista.'))
            : ListView.builder(
                itemCount: lista.itens.length,
                itemBuilder: (context, index) {
                  final produto = lista.itens[index];
                  return ItemTile(
                    produto: produto,
                    viewModel: viewModel,
                    onEdit: () => _editarProduto(index),
                    updateView: () => _updateView(),
                  );
                },
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: R\$ ${lista.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              lista.status == ListaStatus.finalizado
                  ? SizedBox.shrink()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () => _finalizarCompra(),
                    child: const Text('Finalizar'),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: lista.status == ListaStatus.finalizado
          ? SizedBox.shrink()
          : FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: _adicionarProduto,
            tooltip: 'Adicionar Item',
            child: const Icon(Icons.add),
          ),
    );
  }
}
