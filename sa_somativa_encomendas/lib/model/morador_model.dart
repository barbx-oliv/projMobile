
class Morador {
  // Atributos da classe Morador
  int? id; // pode começar vazia, sem valor/número
  String nome;
  String documento;
  int idade;
  String endereco;
  // Todos os atributos estão públicos. Se fosse privado seria -> String _documento;


  // Construtor
  Morador({
    this.id,
    required this.nome, // required -> campo obrigatório
    required this.documento,
    required this.idade,
    required this.endereco,
  });

  // Mapeamento de Dados 
  // toMap -> entrega os valores para o BD 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'idade': idade,
      'endereco': endereco,
    };
  }

  // fromMap -> retorna os valores do Map para visualização
  factory Morador.fromMap(Map<String, dynamic> map) {
    return Morador(
      id: map['id'],
      nome: map['nome'],
      documento: map['documento'],
      idade: map['idade'],
      endereco: map['endereco'],
    );
  }
}