import 'package:cadinho/domain/lista.dart';
import 'package:flutter/material.dart';

class ComparacaoPage extends StatefulWidget {
  final List<Lista> listas; // Recebe todas as listas criadas no app

  const ComparacaoPage({super.key, required this.listas});

  @override
  State<ComparacaoPage> createState() => _ComparacaoPageState();
}

class _ComparacaoPageState extends State<ComparacaoPage> {
  Lista? listaSelecionada1;
  Lista? listaSelecionada2;

  String comparar() {
    if (listaSelecionada1 == null || listaSelecionada2 == null) {
      return 'Selecione duas listas para comparar.';
    }

    final total1 = listaSelecionada1!.total;
    final total2 = listaSelecionada2!.total;

    if (total1 < total2) {
      return '${listaSelecionada1!.titulo} é mais barata.';
    } else if (total1 > total2) {
      return '${listaSelecionada2!.titulo} é mais barata.';
    } else {
      return 'As duas listas têm o mesmo valor.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação de Listas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecione a primeira lista:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<Lista>(
              hint: const Text('Escolha a Lista 1'),
              value: listaSelecionada1,
              isExpanded: true,
              items: widget.listas.map((lista) {
                return DropdownMenuItem(
                  value: lista,
                  child: Text('${lista.titulo} | ${lista.mercado} - R\$ ${lista.total.toStringAsFixed(2)}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  listaSelecionada1 = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Selecione a segunda lista:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<Lista>(
              hint: const Text('Escolha a Lista 2'),
              value: listaSelecionada2,
              isExpanded: true,
              items: widget.listas.map((lista) {
                return DropdownMenuItem(
                  value: lista,
                  child: Text('${lista.titulo} | ${lista.mercado} - R\$ ${lista.total.toStringAsFixed(2)}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  listaSelecionada2 = value;
                });
              },
            ),
            const SizedBox(height: 30),
            if (listaSelecionada1 != null && listaSelecionada2 != null)
              Text(
                comparar(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
