class Encomenda {
  int? id; // pode começar sem valor/número 
  int moradorId;
  String tipoEncomenda;
  String dataEntrega;
  String dataSaida;
  String observacoes;

  // Todos os atributos estão públicos. Se fosse privado seria -> int _moradorId;

  Encomenda({
    this.id,
    // O required seria campo obrigatório 
    required this.moradorId,
    required this.tipoEncomenda,
    required this.dataEntrega,
    required this.dataSaida,
    required this.observacoes,
  });

  // Mapeamento de Dados 
  // toMap -> entrega os valores para o BD 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moradorId': moradorId,
      'tipoEncomenda': tipoEncomenda,
      'dataEntrega': dataEntrega,
      'dataSaida': dataSaida,
      'observacoes': observacoes,
    };
  }
  // fromMap -> retorna os valores do Map para visualização
  factory Encomenda.fromMap(Map<String, dynamic> map) {
    return Encomenda(
      id: map['id'],
      moradorId: map['moradorId'],
      tipoEncomenda: map['tipoEncomenda'],
      dataEntrega: map['dataEntrega'],
      dataSaida: map['dataSaida'],
      observacoes: map['observacoes'],
    );
  }
}