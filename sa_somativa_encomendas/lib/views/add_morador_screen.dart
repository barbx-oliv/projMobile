import 'package:flutter/material.dart';
import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/controller/morador_controller.dart';

class AddMoradorScreen extends StatefulWidget {
  @override
  _AddMoradorScreenState createState() => _AddMoradorScreenState();
}

class _AddMoradorScreenState extends State<AddMoradorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _idadeController = TextEditingController();
  final _enderecoController = TextEditingController();

  final MoradorController _moradorController = MoradorController();

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final novoMorador = Morador(
        nome: _nomeController.text,
        documento: _documentoController.text,
        idade: int.parse(_idadeController.text),
        endereco: _enderecoController.text,
      );

      bool sucesso = await _moradorController.salvarMorador(novoMorador) > 0;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Morador cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar o morador.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Morador"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: "Nome Completo",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o nome" : null,
              ),
              SizedBox(height: 16),

              // Campo Documento
              TextFormField(
                controller: _documentoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Documento (CPF/RG)",
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o documento" : null,
              ),
              SizedBox(height: 16),

              // Campo Idade
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Idade",
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Informe a idade";
                  if (int.tryParse(value) == null) return "Digite um número válido";
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo Endereço
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: "Endereço (Apto / Bloco)",
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o endereço" : null,
              ),
              SizedBox(height: 24),

              // Botão Salvar
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text("Salvar Cadastro"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    _idadeController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }
}