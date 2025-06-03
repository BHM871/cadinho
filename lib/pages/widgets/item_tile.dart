import 'package:cadinho/domain/item.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final ItemViewModel viewModel;
  final Item produto;
  final VoidCallback onEdit;
  final VoidCallback updateView;

  const ItemTile({
    super.key,
    required this.viewModel,
    required this.produto,
    required this.onEdit,
    required this.updateView,
  });

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
        title: Text(produto.titulo),
        subtitle: Text('${produto.quantidade} ${produto.unidade.name} - R\$ ${produto.valor?.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: onEdit),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red), 
              onPressed: () async {
                await viewModel.excluir(produto);
                updateView();
              }
            ),
          ],
        ),
      ),
    );
  }
}
