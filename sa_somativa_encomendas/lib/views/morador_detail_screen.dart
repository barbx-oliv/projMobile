import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_somativa_encomendas/model/encomenda_model.dart';
import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/service/database_helper.dart';
import 'package:sa_somativa_encomendas/views/add_encomenda_screen.dart';

class MoradorDetailScreen extends StatefulWidget {
  final Morador morador;
  const MoradorDetailScreen({super.key, required this.morador});

  @override
  _MoradorDetailScreenState createState() => _MoradorDetailScreenState();
}

class _MoradorDetailScreenState extends State<MoradorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ficha: ${widget.morador.nome}"),
      ),
      body: Column(
        children: [
          // Ficha do morador
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Text(
                      widget.morador.nome,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text("Documento: ${widget.morador.documento}"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.cake),
                    title: Text("Idade: ${widget.morador.idade} anos"),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Endereço: ${widget.morador.endereco}"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Histórico de Encomendas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: FutureBuilder<List<Encomenda>>(
              future: DatabaseHelper().getEncomendaPorMorador(widget.morador.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                final encomendas = snapshot.data!;
                if (encomendas.isEmpty) {
                  return Center(child: Text("Nenhuma encomenda registrada."));
                }
                // Lista todas as encomendas do morador
                return ListView.builder(
                  itemCount: encomendas.length,
                  itemBuilder: (context, i) {
                    final e = encomendas[i];
                    // Formatar datas para exibição
                    final dataEntregaFormatada = _formatarData(e.dataEntrega);
                    final dataSaidaFormatada = e.dataSaida.isEmpty
                        ? "Ainda não retirada"
                        : _formatarData(e.dataSaida);
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(e.tipoEncomenda),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Entregue: $dataEntregaFormatada"),
                            Text("Saída: $dataSaidaFormatada"),
                            if (e.observacoes.isNotEmpty)
                              Text("Obs: ${e.observacoes}"),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Icon(Icons.local_shipping),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Botão flutuante para registrar nova encomenda
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Nova Encomenda"),
        icon: Icon(Icons.add_box),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => AddEncomendaScreen(morador: widget.morador),
          ),
        ).then((value) => setState(() {})),
      ),
    );
  }

  String _formatarData(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat("dd/MM/yyyy HH:mm").format(date);
    } catch (e) {
      return isoDate;
    }
  }
}