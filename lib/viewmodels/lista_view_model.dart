import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/repositories/lista_repository.dart';

class ListaViewModel {

  final ListaRepository repository;

  const ListaViewModel({required this.repository});

  Future<Lista?> peloId(int id) async {
    try {
      return await repository.buscarId(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Lista>?> buscar() async {
    try {
      return await repository.buscarTodas();
    } catch (e) {
      return null;
    }
  }

  Future<Lista?> criar(Lista lista) async {
    try {
      return await repository.salvar(lista);
    } catch (e) {
      return null;
    }
  }

  Future<Lista?> atualizar(Lista lista) async {
    try {
      return await repository.atualizar(lista);
    } catch (e) {
      return null;
    }
  }

  Future<bool> excluir(Lista lista) async {
    try {
      await repository.excluir(lista);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Lista?> finalizar(Lista lista) async {
    try {
      var tmp = lista.toMap();
      tmp['status'] = ListaStatus.finalizado.value;

      return await repository.atualizar(Lista.fromMap(tmp));
    } catch (e) {
      return null;
    }
  }
}
