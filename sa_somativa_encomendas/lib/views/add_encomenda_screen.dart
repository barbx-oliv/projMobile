import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_somativa_encomendas/controller/encomenda_controller.dart';
import 'package:sa_somativa_encomendas/model/encomenda_model.dart';
import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/views/morador_detail_screen.dart';

class AddEncomendaScreen extends StatefulWidget {
  final Morador morador;
  const AddEncomendaScreen({super.key, required this.morador});

  @override
  _AddEncomendaScreenState createState() => _AddEncomendaScreenState();
}

class _AddEncomendaScreenState extends State<AddEncomendaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _encomendaController = EncomendaController();

  late String _tipoEncomenda;
  late String _observacoes;
  bool _jaRetirada = false;

  // Data de entrega (quando chegou)
  DateTime _dataEntrega = DateTime.now();
  TimeOfDay _horaEntrega = TimeOfDay.now();

  // Data de saída (quando o morador retirou)
  DateTime _dataSaida = DateTime.now();
  TimeOfDay _horaSaida = TimeOfDay.now();

  // Seletor de data de entrega
  void _selecionarDataEntrega(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataEntrega) {
      setState(() {
        _dataEntrega = picked;
      });
    }
  }

  // Seletor de hora de entrega
  void _selecionarHoraEntrega(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _horaEntrega);
    if (picked != null && picked != _horaEntrega) {
      setState(() {
        _horaEntrega = picked;
      });
    }
  }

  // Seletor de data de saída
  void _selecionarDataSaida(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSaida,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataSaida) {
      setState(() {
        _dataSaida = picked;
      });
    }
  }

  // Seletor de hora de saída
  void _selecionarHoraSaida(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _horaSaida);
    if (picked != null && picked != _horaSaida) {
      setState(() {
        _horaSaida = picked;
      });
    }
  }

  void _salvarEncomenda() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Montar data/hora de entrega em ISO8601
      final DateTime dataEntregaFinal = DateTime(
        _dataEntrega.year,
        _dataEntrega.month,
        _dataEntrega.day,
        _horaEntrega.hour,
        _horaEntrega.minute,
      );

      // Montar data/hora de saída (somente se já foi retirada)
      String dataSaidaFinal = "";
      if (_jaRetirada) {
        final DateTime saidaDateTime = DateTime(
          _dataSaida.year,
          _dataSaida.month,
          _dataSaida.day,
          _horaSaida.hour,
          _horaSaida.minute,
        );
        dataSaidaFinal = saidaDateTime.toIso8601String();
      }

      final novaEncomenda = Encomenda(
        moradorId: widget.morador.id!,
        tipoEncomenda: _tipoEncomenda,
        dataEntrega: dataEntregaFinal.toIso8601String(),
        dataSaida: dataSaidaFinal,
        observacoes: _observacoes.isEmpty ? "" : _observacoes,
      );

      try {
        await _encomendaController.salvarEncomenda(novaEncomenda);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Encomenda registrada com sucesso!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MoradorDetailScreen(morador: widget.morador),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dataFormatada = DateFormat("dd/MM/yyyy");
    final DateFormat horaFormatada = DateFormat("HH:mm");

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Encomenda"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Info do morador
              Text(
                "Morador: ${widget.morador.nome}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("Endereço: ${widget.morador.endereco}"),
              SizedBox(height: 16),
              Divider(),

              // Tipo de encomenda
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Tipo de Encomenda",
                  prefixIcon: Icon(Icons.inventory_2),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Informe o tipo de encomenda" : null,
                onSaved: (newValue) => _tipoEncomenda = newValue!,
              ),
              SizedBox(height: 16),

              // Data de entrega
              Text(
                "Data de Entrega (chegada)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Data: ${dataFormatada.format(_dataEntrega)}"),
                  ),
                  TextButton(
                    onPressed: () => _selecionarDataEntrega(context),
                    child: Text("Selecionar Data"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Hora: ${horaFormatada.format(DateTime(0, 0, 0, _horaEntrega.hour, _horaEntrega.minute))}"),
                  ),
                  TextButton(
                    onPressed: () => _selecionarHoraEntrega(context),
                    child: Text("Selecionar Hora"),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Checkbox saída
              CheckboxListTile(
                title: Text("Encomenda já foi retirada?"),
                value: _jaRetirada,
                onChanged: (value) {
                  setState(() {
                    _jaRetirada = value!;
                  });
                },
              ),

              // Data de saída (só aparece se marcado)
              if (_jaRetirada) ...[
                Text(
                  "Data de Saída (retirada)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Data: ${dataFormatada.format(_dataSaida)}"),
                    ),
                    TextButton(
                      onPressed: () => _selecionarDataSaida(context),
                      child: Text("Selecionar Data"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Hora: ${horaFormatada.format(DateTime(0, 0, 0, _horaSaida.hour, _horaSaida.minute))}"),
                    ),
                    TextButton(
                      onPressed: () => _selecionarHoraSaida(context),
                      child: Text("Selecionar Hora"),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],

              // Observações
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Observações",
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (newValue) => _observacoes = newValue ?? "",
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _salvarEncomenda,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text("Registrar Encomenda"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}