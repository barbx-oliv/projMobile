import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/service/database_helper.dart';

// SlimController - chama e executa
class MoradorController {
  final _dbHelper = DatabaseHelper(); // Atributo para estabelecer conexão com o banco 

  // Métodos dos Controller
  Future<int> salvarMorador(Morador morador) async => _dbHelper.insertMorador(morador);
  
  // Lista todos os moradores 
  Future<List<Morador>> listarTodos() async => _dbHelper.getMoradores();
}