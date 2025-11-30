import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/services/servico_service.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/tela_listagem_padrao.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:go_router/go_router.dart';

class ListaServicosScreen extends StatefulWidget {
  const ListaServicosScreen({super.key});

  @override
  State<ListaServicosScreen> createState() => _ListaServicosScreenState();
}

class _ListaServicosScreenState extends State<ListaServicosScreen> {
  final ServicoService servicoService = ServicoService();

  late Future<List<Servico>> _servicosFuture;
  ThemeData? _theme;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  @override
  void initState() {
    super.initState();
    _servicosFuture = servicoService.buscarListaServicos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _colorScheme = _theme!.colorScheme;
    _textTheme = _theme!.textTheme;
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarPadrao(
        icon: null,
        title: 'Serviços',
        subtitle: 'Gerencie todas os serviços cadastrados na plataforma.',
        tituloBotao: 'Adicionar Serviço',
        onPressed: () {
          context.go('/servicos/cadastro');
        },
      ),
      body: TelaListagemPadrao(
        titulo: 'Lista de Servicos',
        dataTable: FutureBuilder<List<Servico>>(
          future: _servicosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar serviços: ${snapshot.error}',
                  style: TextStyle(color: _colorScheme.error),
                ),
              );
            }
            final servicos = snapshot.data ?? [];
            if (servicos.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum serviço encontrado.',
                  style: TextStyle(color: _colorScheme.onSurface),
                ),
              );
            }
            return _gridDados(servicos);
          },
        ),
      ),
    );
  }

  DataTable2 _gridDados(List<Servico> servicos) {
    final headerStyle = _textTheme.titleSmall?.copyWith(
      color: _colorScheme.onSurface, //.withValues(alpha: 0.9),
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
            'DESCRIÇÃO',
            style: headerStyle,
          ),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text(
            'TEMPO',
            style: headerStyle,
          ),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text(
            'PREÇO',
            style: headerStyle,
          ),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '',
              style: _textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          size: ColumnSize.S,
        ),
      ],
      rows: servicos.map((servico) {
         int index = servicos.indexOf(servico);
        return DataRow(
          color: WidgetStateProperty.all(
            index % 2 == 0
                ? _colorScheme.onSurface.withValues(alpha: 0.03) // linha clara
                : Colors.transparent,
          ), 
          cells: [
            DataCell(Text(servico.descricao, style: itensStyle)),
            DataCell(Text(servico.tempo, style: itensStyle)),
            DataCell(Text(UtilTexto.formatarDecimalParaMoeda(servico.preco), style: itensStyle)),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: _colorScheme.onSurface),
                  onSelected: (value) {
                    if (value == 'editar') {
                      context.go('/servicos/cadastro', extra: servico);
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
