class Lista {
    final int? id;
    final String? titulo;
    final String? mercado;
    final DateTime? data;
    final ListaStatus? status;

    Lista({this.id, this.titulo, this.mercado, this.data, this.status});

    Map<String, Object?> toMap() {
        var map = <String, Object?> {
            'id': id,
            'titulo': titulo,
            'mercado': mercado,
            'data': data,
            'status': status?.value,
        };
        return map;
    }

    static Lista fromMap(Map<String, Object?> map) {
        return Lista(
            id: map['id'] as int?,
            titulo: map['titulo'] as String?,
            mercado: map['mercado'] as String?,
            data: map['data'] != null ? DateTime.parse(map['data'] as String) : null,
            status: map['status'] != null ? ListaStatus.by(map['status'] as String) : null
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
