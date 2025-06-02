import 'package:cadinho/domain/lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaTile extends StatelessWidget {
  final Lista lista;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClick;

  const ListaTile({
    super.key,
    required this.lista,
    required this.onEdit,
    required this.onDelete,
    required this.onClick,
  });

  TextStyle? getStyle() {
    if (lista.status == ListaStatus.pendente) {
      return TextStyle(color: Colors.red);
    }

    if (lista.status == ListaStatus.emCurso) {
      return TextStyle(color: Colors.yellow);
    }

    if (lista.status == ListaStatus.finalizado) {
      return TextStyle(color: Colors.green);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.from(alpha: .4,blue: .9,red: .9,green: .9),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 8, right: 8, bottom: 0, left: 8),
      padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 5),
      child: ListTile(
        title: Text('${lista.titulo} | ${lista.mercado}'),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lista.data != null ? DateFormat('dd/MM/yyyy').format(lista.data!) : ''),
            Row(
              children: [
                Text('Total: R\$ '),
                Text(
                  lista.total.toStringAsFixed(2),
                  style: getStyle(),
                )
              ],
            ),
          ],
        ),
        onTap: onClick,
        trailing: PopupMenuButton<String>(
          onSelected: (valor) {
            if (valor == 'Editar') onEdit();
            if (valor == 'Excluir') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'Editar', child: Text('Editar')),
            const PopupMenuItem(value: 'Excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }
}
