import 'package:cadinho/domain/lista.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${lista.titulo} | ${lista.mercado}'),
      subtitle: Text('Total: R\$ ${lista.total.toStringAsFixed(2)}'),
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
    );
  }
}
