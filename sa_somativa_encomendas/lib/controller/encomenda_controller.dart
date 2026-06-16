import 'package:sa_somativa_encomendas/service/database_helper.dart';
import 'package:sa_somativa_encomendas/model/encomenda_model.dart';

class EncomendaController { // CRUD
  final _dbHelper = DatabaseHelper();

  // Create
  Future<int> salvarEncomenda(Encomenda e) async =>
      _dbHelper.insertEncomenda(e);

  // listar todas as encomendas pelo morador (moradorId) -> READ
  Future<List<Encomenda>> listarEncomendas(int moradorId) async =>
      _dbHelper.getEncomendaPorMorador(moradorId);
}