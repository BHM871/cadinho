import 'package:cadinho/domain/item.dart';
import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/item_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/item_tile.dart';
import 'package:flutter/material.dart';

class ListaDetalhePage extends StatefulWidget {
  final Lista lista;
  const ListaDetalhePage({required this.lista, super.key});

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
        idLista: lista.id!,
        onChange: (item) {
          item = Item(id: lista.itens.length + 1, titulo: item.titulo, valor: item.valor, quantidade: item.quantidade, unidade: item.unidade, idLista: item.idLista);
          lista.itens.add(item);
          setState(() {});
        }
      ),
    );
  }

  void _editarProduto(int index) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => ItemBottomSheet(
        idLista: lista.id!,
        item: lista.itens[index],
        onChange: (item) {
          lista.itens[index] = item;
          setState(() {});
        }
      ),
    );
  }

  void _excluirProduto(int index) {
    setState(() {
      lista.itens.removeAt(index);
    });
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
        child: Text(
          'Total: R\$ ${lista.total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _adicionarProduto,
        tooltip: 'Adicionar Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
