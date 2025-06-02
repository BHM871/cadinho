import 'package:cadinho/domain/item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Item produto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.produto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.from(alpha: .4,blue: .9,red: .9,green: .9),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 8, right: 10, bottom: 0, left: 10),
      child: ListTile(
        title: Text(produto.titulo),
        subtitle: Text('${produto.quantidade} ${produto.unidade.name} - R\$ ${produto.valor?.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
