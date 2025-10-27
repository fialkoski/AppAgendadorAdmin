import 'dart:async';
import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicosScreen extends StatefulWidget {
  final int empresaId;
  const ServicosScreen({super.key, required this.empresaId});

  @override
  _ServicosScreenState createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  Future<List<Servico>>? _servicosFuture;
  late int idEmpresa = 0; // Ajuste conforme necessário

  @override
  void initState() {
    super.initState();
    idEmpresa = widget.empresaId;
    _servicosFuture = ApiService.buscarLista('/api/$idEmpresa/servicos', Servico.fromJson);
  }

  Future<void> _saveOrUpdateServico(Servico? servico) async {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: servico?.descricao ?? '');
    final duracaoController = TextEditingController(text: servico?.tempo ?? '');
    final precoController = TextEditingController(text: servico?.preco.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(servico == null ? 'Novo Serviço' : 'Editar Serviço'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: duracaoController,
                decoration: InputDecoration(labelText: 'Duração (min)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(labelText: "Preço (R\$)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newServico = Servico(
                  id: servico?.id ?? 0,
                  descricao: nomeController.text,
                  tempo: duracaoController.text,
                  preco: double.parse(precoController.text),
                  idEmpresa: idEmpresa,
                );
                Navigator.pop(context);
                _performSaveOrUpdate(newServico, servico?.id);
              }
            },
            child: Text(servico == null ? 'Salvar' : 'Atualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _performSaveOrUpdate(Servico servico, int? id) async {
    try {
      if (id == null) {
        await ApiService.post('/api/$idEmpresa/servicos', servico.toJson());
      } else {
        await ApiService.put('/api/$idEmpresa/servicos/$id', servico.toJson());
      }
      setState(() {
        _servicosFuture = ApiService.buscarLista('/api/$idEmpresa/servicos', Servico.fromJson);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _deleteServico(int id) async {
    try {
      await ApiService.delete('/api/$idEmpresa/servicos/$id');
      setState(() {
        _servicosFuture = ApiService.buscarLista('/api/$idEmpresa/servicos', Servico.fromJson);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _saveOrUpdateServico(null),
          ),
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) => IconButton(
              icon: Icon(themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: () => themeNotifier.toggleTheme(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Servico>>(
        future: _servicosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Erro ao carregar serviços: ${snapshot.error}');
            return Center(
              child: Text(
                'Erro ao carregar serviços: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum serviço encontrado',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ElevatedButton(
                    onPressed: () => _saveOrUpdateServico(null),
                    child: const Text('Adicionar Serviço'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final servico = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    servico.descricao,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Duração: ${servico.tempo} min | Preço: R\$${servico.preco.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _saveOrUpdateServico(servico),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteServico(servico.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}