import 'dart:math';

import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/pages/widgets/comparacao_tile.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:flutter/material.dart';

import '../domain/item.dart';

class ComparacaoPage extends StatefulWidget {
  final Lista fonte;
  final List<Lista> listas; // Recebe todas as listas criadas no app
  final ItemViewModel itemViewModel;

  const ComparacaoPage({
    super.key,
    required this.fonte,
    required this.listas,
    required this.itemViewModel,
  });

  @override
  State<ComparacaoPage> createState() => _ComparacaoPageState();
}

class _ComparacaoPageState extends State<ComparacaoPage> {
  late Lista fonte;
  Lista? compare;
  late List<Lista> listas;
  late Map<String, Item> compareMap;

  @override
  void initState() {
    super.initState();
    fonte = widget.fonte;
    listas = widget.listas;

    compareMap = <String,Item>{};
    widget.itemViewModel.buscar(fonte.id!).then((itens) {
      fonte.itens = itens ?? [];

      for (Item i in fonte.itens) {
        compareMap[_gerarChave(i.titulo)] = i;
      }

      setState(() {});
    });

    for (int i = 0; i < listas.length; i++) {
      widget.itemViewModel.buscar(listas[i].id!).then((itens) {
        listas[i].itens = itens ?? [];
        setState(() {});
      });
    }
  }

  String _gerarChave(String chave) {
    return chave.trim()
        .toLowerCase()
        .replaceAll("-", " ")
        .replaceAll("_", " ");
  }

  Map<String, double> _compare() {
    double totalQuantidate = 0;
    double totalValor = 0;

    int itemCount = max(fonte.itens.length, compare?.itens.length ?? 0);
    for(int index = 0; index < itemCount; index++) {
      if (index < fonte.itens.length) {
        totalValor -= (fonte.itens[index].valor ?? 1) * fonte.itens[index].quantidade;
        totalQuantidate -= fonte.itens[index].quantidade;
      }

      if (compare != null && index < compare!.itens.length) {
        totalValor += (compare!.itens[index].valor ?? 1) * compare!.itens[index].quantidade;
        totalQuantidate += compare!.itens[index].quantidade;
      }
    }

    return <String, double>{
      'valor': totalValor,
      'quantidade': totalQuantidate,
    };
  }

  List<String> _maisProdutosMensagem(double quantidade) {
    if (compare == null) {
      return ['', 'Sem lista para comparar'];
    }

    if (quantidade == 0) {
      return ['','Listas tem a mesma quantidade de produtos'];
    }

    return [(quantidade < 0 ? fonte.titulo : compare!.titulo), ' tem mais produtos'];
  }

  List<String> _maisBaratoMensagem(double valor) {
    if (compare == null) {
      return ['', 'Sem lista para comparar'];
    }

    if (valor == 0) {
      return ['', 'Listas tem o mesmo valor'];
    }

    return [(valor > 0 ? fonte.titulo : compare!.titulo), ' é mais barata'];
  }

  @override
  Widget build(BuildContext context) {
    var map = _compare();
    return Scaffold(
      appBar: AppBar(title: const Text('Comparação de Listas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      '${fonte.titulo} | ${fonte.mercado}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: const Icon(Icons.arrow_right_alt)),
                  Expanded(
                    flex: 6,
                    child: DropdownButton<Lista>(
                      hint: const Text('Compare com...'),
                      value: compare,
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                      items: widget.listas.map((lista) {
                        return DropdownMenuItem(
                          value: lista,
                          child: Text('${lista.titulo} | ${lista.mercado}'),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        compare = value;

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: max(fonte.itens.length, compare?.itens.length ?? 0),
                itemBuilder: (builder, index) {
                  if (compare == null || index >= compare!.itens.length) {
                    return ComparacaoTile(fonte: fonte.itens[index]);
                  }

                  if (index >= (fonte.itens.length)) {
                    return ComparacaoTile(fonte: compare!.itens[index]);
                  }

                  return ComparacaoTile(
                    fonte: compareMap[_gerarChave(compare!.itens[index].titulo)],
                    compare: compare!.itens[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 16, right: 20, bottom: 16, left: 25),
          color: Colors.grey[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _maisProdutosMensagem(map['quantidade']!)[0],
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(_maisProdutosMensagem(map['quantidade']!)[1]),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(
                    _maisBaratoMensagem(map['valor']!)[0],
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(_maisBaratoMensagem(map['valor']!)[1]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
