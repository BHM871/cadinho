import 'package:cadinho/domain/item.dart';

class Lista {
  final int? id;
  final String titulo;
  final String? mercado;
  final DateTime? data;
  final ListaStatus status;
  List<Item> itens;
  double total;

  Lista({
    this.id,
    required this.titulo,
    this.mercado,
    this.data,
    required this.status,
    this.total = 0,
    List<Item>? itens
  }) : itens = itens ?? [];

  Map<String, Object?> toMap() {
    var map = <String, Object?>{};

    if (data != null) {
      map['id'] = id;
    }

    map['titulo'] = titulo;
    map['mercado'] = mercado;
    map['data'] = data?.toIso8601String();
    map['status'] = status.value;
    map['total'] = total;

    return map;
  }

  static Lista fromMap(Map<String, Object?> map) {
    return Lista(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      mercado: map['mercado'] as String?,
      data: map['data'] != null ? DateTime.parse(map['data'] as String) : null,
      status: ListaStatus.by(map['status'] as String),
      total: map['total'] as double
    );
  }
}

enum ListaStatus {
  pendente(value: "PENDENTE"),
  emCurso(value: "EM CURSO"),
  finalizado(value: "FINALIZADO");
  
  final String value;

  const ListaStatus({required this.value});

  static ListaStatus by(String value) {
    if (value == ListaStatus.pendente.value) {
      return ListaStatus.pendente;
    }

    if (value == ListaStatus.emCurso.value) {
      return ListaStatus.emCurso;
    }

    if (value == ListaStatus.finalizado.value) {
      return ListaStatus.finalizado;
    }

    throw UnsupportedError("Status não suportado");
  }
}
