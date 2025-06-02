import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/lista_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/lista_tile.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'lista_detalhe_page.dart';
import 'comparacao_page.dart';

class HomePage extends StatefulWidget {
  final ListaViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ListaViewModel viewModel;
  List<Lista> listas = [];

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    viewModel.buscarTodas().then((listas) {
      this.listas = listas ?? [];
      setState(() {});
    });
  }

  void _abrirDetalhes(Lista lista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaDetalhePage(
          lista: lista,
          viewModel: ItemViewModel(),
          onChange: _atualizarLista,
        ),
      ),
    );
    setState(() {});
  }

  void _adicionarLista() async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) => ListaBottomSheet(
        onChange: (lista) async {
          var temp = await viewModel.salvar(lista);

          if (temp == null) {
            _showErroModal('Erro ao salvar lista');
            return;
          }
          
          listas.add(temp);
          
          setState(() {});
        }
      )
    );
  }

  void _editarLista(int index) async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) => ListaBottomSheet(
        lista: listas[index],
        onChange: (lista) async {
          var temp = await viewModel.atualizar(lista);

          if (temp == null) {
            _showErroModal('Erro ao salvar lista');
            return;
          }
          
          listas[index] = temp;
          
          setState(() {});
        }
      )
    );
  }

  void _excluirLista(int index) {
    viewModel.excluir(listas[index]);
    listas.removeAt(index);
    setState(() {});
  }

  void _atualizarLista(Lista lista) async {
    var temp = await viewModel.atualizar(lista);

    if (temp == null) {
      _showErroModal('Erro ao atualizar lista');
      return;
    }

    for (int i = 0; i < listas.length; i++) {
      if (listas[i].id == temp.id) {
        listas[i] = temp;
        setState(() {});
        break;
      }
    }
  }

  void _abrirComparacao() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComparacaoPage(listas: listas),
      ),
    );
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
