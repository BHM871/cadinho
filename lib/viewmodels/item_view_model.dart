import 'package:cadinho/domain/item.dart';
import 'package:cadinho/repositories/item_repository.dart';

class ItemViewModel {

  final ItemRepository repository;

  const ItemViewModel({
    required this.repository,
  });

  Future<Item?> peloId(int id) async {
    try {
      return await repository.buscarId(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Item>?> buscar(int idLista) async {
    try {
      return await repository.buscarTodos(idLista);
    } catch (e) {
      return null;
    }
  }

  Future<Item?> criar(Item item) async {
    try {
      return await repository.salvar(item);
    } catch (e) {
      return null;
    }
  }

  Future<Item?> atualizar(Item item) async {
    try {
      return await repository.atualizar(item);
    } catch (e) {
        return null;
    }
  }

  Future<bool> excluir(Item item) async {
    try {
      await repository.excluir(item);
      return true;
    } catch (e) {
      return false;
    }
  }
}
