import 'package:flutter/material.dart';
import 'package:sa_somativa_encomendas/controller/morador_controller.dart';
import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/views/add_morador_screen.dart';
import 'package:sa_somativa_encomendas/views/morador_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = MoradorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Encomendas"),
      ),
      body: FutureBuilder<List<Morador>>(
        future: _controller.listarTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final moradores = snapshot.data!;
          if (moradores.isEmpty) {
            return Center(
              child: Text("Nenhum morador cadastrado."),
            );
          }
          // Lista com todos os moradores cadastrados
          return ListView.builder(
            itemCount: moradores.length,
            itemBuilder: (context, i) => ListTile(
              leading: Icon(Icons.person),
              title: Text(moradores[i].nome),
              subtitle: Text(moradores[i].endereco),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) =>
                      MoradorDetailScreen(morador: moradores[i]),
                ),
              ).then((value) => setState(() {})),
            ),
          );
        },
      ),
      // Botão flutuante para adicionar novo morador
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => AddMoradorScreen()),
        ).then((value) => setState(() {})),
      ),
    );
  }
}