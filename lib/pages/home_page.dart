import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/lista_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/lista_tile.dart';
import 'package:flutter/material.dart';
import 'lista_detalhe_page.dart';
import 'comparacao_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Lista> listas = [];

  void _abrirDetalhes(Lista lista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaDetalhePage(lista: lista),
      ),
    );
    setState(() {}); // Atualiza total ao voltar
  }

  void _adicionarLista() async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) => ListaBottomSheet(
        onChange: (lista) {
          lista = Lista(id: listas.length + 1, titulo: lista.titulo, mercado: lista.mercado, data: lista.data, status: lista.status);
          listas.add(lista);
          setState(() {});
        })
    );
  }

  void _editarLista(int index) async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) => ListaBottomSheet(
        lista: listas[index],
        onChange: (lista) {
          listas[index] = lista;
          setState(() {});
        })
    );
  }

  void _excluirLista(int index) {
    setState(() {
      listas.removeAt(index);
    });
  }

  void _abrirComparacao() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComparacaoPage(listas: listas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: const [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'CADINHO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _abrirComparacao,
            tooltip: 'Comparar Listas',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, index) {
          final lista = listas[index];
          lista.total = lista.itens.fold<double>(
            0,
            (soma, p) => soma + (p.valor * p.quantidade),
          );

          return ListaTile(
            lista: lista,
            onClick: () => _abrirDetalhes(lista),
            onEdit: () => _editarLista(index),
            onDelete: () => _excluirLista(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLista,
        tooltip: 'Adicionar Lista',
        child: const Icon(Icons.add)
      ),
    );
  }
}
