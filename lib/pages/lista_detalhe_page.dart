import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/item_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/item_tile.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:flutter/material.dart';

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

    viewModel.buscarTodos(lista.id!).then((itens) {
      lista.itens = itens ?? [];
      setState(() {});
    });
  }

  void _adicionarProduto() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemBottomSheet(
        lista: lista,
        onChange: (item) async {
          var temp = await viewModel.salvar(item);

          if (temp == null) {
            _showErroModal('Erro ao salvar produto');
            return;
          }

          lista.itens.add(temp);
          lista.total += (temp.valor ?? 1) * temp.quantidade;
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
        item: lista.itens[index],
        onChange: (item) async {
          var temp = await viewModel.atualizar(item);

          if (temp == null) {
            _showErroModal('Erro ao salvar produto');
            return;
          }

          lista.total -= (lista.itens[index].valor ?? 1) * lista.itens[index].quantidade;
          lista.total += (temp.valor ?? 1) * temp.quantidade;
          lista.itens[index] = temp;
          setState(() {});

          widget.onChange(lista);
        }
      ),
    );
  }

  void _excluirProduto(int index) async {
    viewModel.excluir(lista.itens[index]);
    lista.total -= (lista.itens[index].valor ?? 1) * lista.itens[index].quantidade;
    lista.itens.removeAt(index);
    setState(() {});
  }

  void _finalizarCompra() async {
    var map = lista.toMap();
    map['status'] = ListaStatus.finalizado.value;

    lista = Lista.fromMap(map);
    lista.itens = await viewModel.buscarTodos(lista.id!) ?? [];
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
      body: lista.itens.isEmpty
          ? const Center(child: Text('Nenhum produto na lista.'))
          : ListView.builder(
              itemCount: lista.itens.length,
              itemBuilder: (context, index) {
                final produto = lista.itens[index];
                return ItemTile(
                  produto: produto,
                  onEdit: () => _editarProduto(index),
                  onDelete: () => _excluirProduto(index),
                );
              },
            ),
      bottomNavigationBar: Container(
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
