import 'package:cadinho/domain/lista.dart';
import 'package:cadinho/repositories/item_repository.dart';
import 'package:cadinho/repositories/lista_repository.dart';
import 'package:cadinho/services/serializer_service.dart';
import 'package:cadinho/services/share_service.dart';

import '../domain/item.dart';

class ListaViewModel {

  final ListaRepository repository;
  final ItemRepository itemRepository;

  final SerializerService serializerService;
  final ShareService shareService;

  const ListaViewModel({
    required this.repository,
    required this.itemRepository,
    required this.serializerService,
    required this.shareService,
  });

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

  Future<Lista?> duplicar(Lista lista) async {
    try {
      var tmp = lista.toMap();
      tmp.remove('id');
      tmp['titulo'] = '${tmp['titulo']} Cópia';

      var nova = await repository.salvar(Lista.fromMap(tmp));
      if (nova == null) return null;

      var itens = await itemRepository.buscarTodos(lista.id!) ?? [];
      for(Item i in itens) {
        tmp = i.toMap();
        tmp.remove('id');
        tmp['id_lista'] = nova.id!;

        var novo = (await itemRepository.salvar(Item.fromMap(tmp)))!;
        nova.itens.add(novo);
      }

      return nova;
    } catch (e) {
      return null;
    }
  }

  Future<bool> compartilhar(Lista lista) async {
    try {
      dynamic tmp = await repository.buscarId(lista.id!);
      if (tmp == null) return false;

      lista = tmp;

      tmp = await itemRepository.buscarTodos(lista.id!);
      if (tmp == null) return false;

      lista.itens = tmp;

      String shareable = serializerService.encode(lista);

      return shareService.share(shareable);
    } catch (e) {
      return false;
    }
  }
}
