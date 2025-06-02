import 'package:cadinho/domain/item.dart';
import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/item_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/item_tile.dart';
import 'package:flutter/material.dart';

class ListaDetalhePage extends StatefulWidget {
  final Lista lista;
  final Function(Lista) onFinish;

  const ListaDetalhePage({required this.lista, required this.onFinish, super.key});

  @override
  State<ListaDetalhePage> createState() => _ListaDetalhePageState();
}

class _ListaDetalhePageState extends State<ListaDetalhePage> {
  late Lista lista;

  @override
  void initState() {
    super.initState();
    lista = widget.lista;
  }

  void _adicionarProduto() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => ItemBottomSheet(
        lista: lista,
        onChange: (item) {
          var map = item.toMap();
          map['id'] = lista.itens.length + 1;
          item = Item.fromMap(map);
          lista.itens.add(item);
          lista.total += (item.valor ?? 1) * item.quantidade;
          setState(() {});
        }
      ),
    );
  }

  void _editarProduto(int index) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => ItemBottomSheet(
        lista: lista,
        item: lista.itens[index],
        onChange: (item) {
          lista.itens[index] = item;
          setState(() {});
        }
      ),
    );
  }

  void _excluirProduto(int index) {
    lista.itens.removeAt(index);
    setState(() {});
  }

  void _finalizarCompra() {
    var map = lista.toMap();
    map['status'] = ListaStatus.finalizado.value;
    lista = Lista.fromMap(map);
    setState(() {});
    widget.onFinish(lista);
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
            lista.status! == ListaStatus.finalizado
                ? SizedBox.shrink()
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () => _finalizarCompra(),
                  child: const Text('Finalizar'),
                ),
          ],
        ),
      ),
      floatingActionButton: lista.status! == ListaStatus.finalizado
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
