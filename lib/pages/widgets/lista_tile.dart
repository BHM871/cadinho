import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaTile extends StatelessWidget {
  final Lista lista;
  final ListaViewModel viewModel;
  final VoidCallback onComp;
  final VoidCallback onEdit;
  final VoidCallback onClick;
  final VoidCallback updateView;

  const ListaTile({
    super.key,
    required this.lista,
    required this.viewModel,
    required this.onComp,
    required this.onEdit,
    required this.onClick,
    required this.updateView,
  });

  TextStyle? getStyle() {
    if (lista.status == ListaStatus.pendente) {
      return TextStyle(color: Colors.red);
    }

    if (lista.status == ListaStatus.emCurso) {
      return TextStyle(color: Colors.orange);
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
        borderRadius: BorderRadius.circular(12),
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
            switch (valor) {
              case 'Editar': onEdit(); break;
              case 'Duplicar':
                viewModel.duplicar(lista);
                updateView();
                break;
              case 'Comparar': onComp(); break;
              case 'Compartilhar':
                viewModel.compartilhar(lista);
                break;
              case 'Excluir':
                viewModel.excluir(lista);
                updateView();
                break;
              default:
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'Editar', child: Text('Editar')),
            const PopupMenuItem(value: 'Duplicar', child: Text('Duplicar')),
            const PopupMenuItem(value: 'Comparar', child: Text('Comparar')),
            const PopupMenuItem(value: 'Compartilhar', child: Text('Compartilhar')),
            const PopupMenuItem(value: 'Excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }
}
