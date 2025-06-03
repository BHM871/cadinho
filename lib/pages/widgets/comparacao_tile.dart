import 'package:flutter/material.dart';

import '../../domain/item.dart';

class ComparacaoTile extends StatelessWidget {
  final Item? fonte;
  final Item? compare;

  const ComparacaoTile({
    super.key,
    this.fonte,
    this.compare,
  });

  double _compareValor() {
    if (fonte == null && compare == null) {
      return 0;
    }

    if (fonte != null && compare == null) {
      return fonte!.valor ?? 1 * fonte!.quantidade;
    }

    if (fonte == null && compare != null) {
      return compare!.valor ?? 1 * compare!.quantidade;
    }

    return ((compare!.valor ?? 1) * compare!.quantidade) - ((fonte!.valor ?? 1) * fonte!.quantidade);
  }

  double _compareQuantidade() {
    if (fonte == null && compare == null) {
      return 0;
    }

    if (fonte != null && compare == null) {
      return fonte!.quantidade;
    }

    if (fonte == null && compare != null) {
      return compare!.quantidade;
    }

    return compare!.quantidade - fonte!.quantidade;
  }

  Color _buscarCor(double valor, {bool inverso = false}) {
    if (valor < 0) {
      return inverso ? Colors.green : Colors.red;
    }

    if (valor > 0) {
      return inverso ? Colors.red : Colors.green;
    }

    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    double valor = _compareValor();
    double quantidade = _compareQuantidade();
    return Container(
      decoration: BoxDecoration(
        color: Color.from(alpha: .4, blue: .9, red: .9, green: .9),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 8, right: 0, bottom: 3, left: 0),
      padding: EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 13),
      child: Row(
        children: [
          Text(
            fonte?.titulo ?? compare?.titulo ?? '',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(width: 5,),
          Icon(Icons.arrow_right_alt),
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Qt:',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    '$quantidade ${fonte?.unidade.name ?? compare?.unidade.name ?? ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _buscarCor(quantidade),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Val:',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    'R\$ ${valor.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _buscarCor(valor, inverso: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}