/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../configurations/ThemeNotifier.dart';
import '../singleton/EmpresaSingleton.dart';
import '../models/Profissional.dart';
import '../services/ApiService.dart';
import '../services/ProfissionalService.dart';

class ListaProfissionalScreen extends StatefulWidget {
  const ListaProfissionalScreen({super.key});

  @override
  _ListaProfissionalScreenState createState() => _ListaProfissionalScreenState();
}

class _ListaProfissionalScreenState extends State<ListaProfissionalScreen> {
  final ProfissionalService _service = ProfissionalService();
  List<Profissional> _profissionais = [];

  @override
  void initState() {
    super.initState();
    debugPrint('Inicializando CadastroProfissionalPage');
    _carregarProfissionais();
  }

  Future<void> _carregarProfissionais() async {
    try {
      debugPrint('Carregando lista de profissionais');
      _profissionais = await _service.buscarListaProfissionais();
      setState(() {});
    } catch (e) {
      debugPrint('Erro ao carregar profissionais: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Construindo CadastroProfissionalPage');
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          debugPrint('Botão de voltar do navegador pressionado, navegando para /');
          String cpfcnpj = EmpresaSingleton().empresa!.cpfCnpj;
          context.go('/?cpfcnpj=$cpfcnpj');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              debugPrint('Botão Voltar pressionado, navegando para /');
              context.go('/');
            },
          ),
          title: const Text('Cadastro de Profissionais'),
          actions: [
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) => IconButton(
                icon: Icon(themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
                onPressed: () {
                  debugPrint('Trocando tema');
                  themeNotifier.toggleTheme();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildLista()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('Navegando para /profissionais/cadastro');
                  context.go('/profissionais/cadastro');
                },
                child: const Text('Novo Profissional'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista() {
    return ListView.builder(
      itemCount: _profissionais.length,
      itemBuilder: (context, index) {
        var prof = _profissionais[index];
        return Card(
          child: ListTile(
            leading: prof.foto != null && prof.foto != ''
                ? CircleAvatar(backgroundImage: NetworkImage(ApiService.URLBASEIMG + prof.foto!))
                : const Icon(Icons.person),
            title: Text(prof.nome),
            subtitle: Text(prof.ativo == 1 ? 'Ativo' : 'Inativo'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    debugPrint('Editando profissional: ${prof.nome}');
                    context.go('/profissionais/cadastro', extra: prof);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    debugPrint('Abrindo diálogo de exclusão para: ${prof.nome}');
                    bool? confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: Text('Deseja excluir ${prof.nome}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      debugPrint('Excluindo profissional: ${prof.nome}');
                      String resultado = await _service.excluirProfissional(prof.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado)));
                      _carregarProfissionais();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/tela_listagem_padrao.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:go_router/go_router.dart';

class ListaProfissionaisScreen extends StatefulWidget {
  const ListaProfissionaisScreen({super.key});

  @override
  State<ListaProfissionaisScreen> createState() =>
      _ListaProfissionaisScreenState();
}

class _ListaProfissionaisScreenState extends State<ListaProfissionaisScreen> {
  final ProfissionalService profissionalService = ProfissionalService();

  ThemeData? _theme;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _colorScheme = _theme!.colorScheme;
    _textTheme = _theme!.textTheme;
  }

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarPadrao(
        icon: null,
        title: 'Profissionais',
        subtitle: 'Gerencie todas os profissionais cadastrados na plataforma.',
        tituloBotao: 'Adicionar Profissional',
        onPressed: () {
          context.go('/profissionais/cadastro');
        },
      ),
      body: TelaListagemPadrao(
        titulo: 'Lista de Profissionais',
        dataTable: FutureBuilder<List<Profissional>>(
          future: profissionalService.buscarListaProfissionais(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar profissionais: ${snapshot.error}',
                  style: TextStyle(color: _colorScheme.error),
                ),
              );
            }
            final profissionais = snapshot.data ?? [];
            if (profissionais.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum profissional encontrado.',
                  style: TextStyle(color: _colorScheme.onSurface),
                ),
              );
            }
            return _gridDados(profissionais);
          },
        ),
      ),
    );
  }

  DataTable2 _gridDados(
    List<Profissional> profissionais
  ) {
    final headerStyle = _textTheme.titleSmall?.copyWith(
      color: _colorScheme.onSurface,//.withValues(alpha: 0.9),
      fontWeight: FontWeight.w600,
    );
    final itensStyle = TextStyle(
      color: _colorScheme.onSurface.withValues(alpha: 0.8),
    );
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 800,
      headingTextStyle: headerStyle,
      dividerThickness: 0,
      columns: [
        DataColumn2(
          label: Text(
            'NOME',
            style: headerStyle,
          ),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text(
            'E-MAIL',
            style: headerStyle,
          ),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '',
              style: headerStyle,
              textAlign: TextAlign.right,
            ),
          ),
          size: ColumnSize.S,
        ),
      ],
      rows: profissionais.map((profissional) {
        int index = profissionais.indexOf(profissional);
        return DataRow(
          color: WidgetStateProperty.all(
            index % 2 == 0
                ? _colorScheme.onSurface.withValues(alpha: 0.03) // linha clara
                : Colors.transparent,
          ), 
          cells: [
            DataCell(Text(profissional.nome, style: itensStyle,)),
            DataCell(Text(profissional.email, style: itensStyle)),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: _colorScheme.onSurface),
                  onSelected: (value) {
                    if (value == 'editar') {
                      context.go(
                        '/profissionais/cadastro',
                        extra: profissional,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: _colorScheme.primary),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
