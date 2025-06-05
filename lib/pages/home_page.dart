import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/importar_dialog.dart';
import 'package:cadinho/pages/widgets/lista_bottom_sheet.dart';
import 'package:cadinho/pages/widgets/lista_tile.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'lista_detalhe_page.dart';
import 'comparacao_page.dart';

class HomePage extends StatefulWidget {
  final ListaViewModel viewModel;
  final ItemViewModel itemViewModel;
  const HomePage({super.key, required this.viewModel, required this.itemViewModel});

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
    viewModel.buscar().then((listas) {
      this.listas = listas ?? [];
      setState(() {});
    });
  }

  void _updateView() async {
    listas = (await viewModel.buscar()) ?? [];
    setState(() {});
  }

  void _abrirDetalhes(Lista lista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaDetalhePage(
          lista: lista,
          viewModel: widget.itemViewModel,
          onChange: _atualizarLista,
        ),
      ),
    );
    setState(() {});
  }

  void _adicionarLista() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) => ListaBottomSheet(
        viewModel: viewModel,
        onChange: (lista) async {
          if (lista == null) {
            _showErroModal('Erro ao salvar lista');
            return;
          }
          
          listas.add(lista);
          setState(() {});
        }
      )
    );
  }

  void _editarLista(int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) => ListaBottomSheet(
        lista: listas[index],
        viewModel: viewModel,
        onChange: (lista) async {
          if (lista == null) {
            _showErroModal('Erro ao salvar lista');
            return;
          }
          
          listas[index] = lista;
          setState(() {});
        }
      )
    );
  }

  void _atualizarLista(Lista lista) async {
    var temp = await viewModel.atualizar(lista);

    if (temp == null) {
      _showErroModal('Erro ao atualizar lista');
      return;
    }

    _updateView();
  }

  void _abrirComparacao(Lista lista) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComparacaoPage(
          fonte: lista,
          listas: listas,
          itemViewModel: widget.itemViewModel,
        ),
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
        title: SizedBox(
          width: 10 * 16,
          child: Image.asset('assets/icons/banner.png'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (valor) {
              switch(valor) {
                case 'Importar':
                  showDialog(
                    context: context,
                    builder: (builder) => ImportarDialog(
                      viewModel: viewModel,
                      updateView: _updateView,
                    ),
                  );
                  break;
                default: break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'Importar', child: Text('Importar')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: listas.isEmpty
            ? const Center(child: Text('Nenhuma lista foi inserida'))
            : ListView.builder(
                itemCount: listas.length,
                itemBuilder: (context, index) {
                  final lista = listas[index];
              
                  return ListaTile(
                    lista: lista,
                    viewModel: viewModel,
                    onClick: () => _abrirDetalhes(lista),
                    onComp: () => _abrirComparacao(lista),
                    onEdit: () => _editarLista(index),
                    updateView: () => _updateView(),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLista,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Adicionar Lista',
        child: const Icon(Icons.add)
      ),
    );
  }
}
