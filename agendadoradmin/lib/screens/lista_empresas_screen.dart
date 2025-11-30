import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/tela_listagem_padrao.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:go_router/go_router.dart';

class ListaEmpresasScreen extends StatefulWidget {
  const ListaEmpresasScreen({super.key});

  @override
  State<ListaEmpresasScreen> createState() => _ListaEmpresasScreenState();
}

class _ListaEmpresasScreenState extends State<ListaEmpresasScreen> {
  final EmpresaService empresaService = EmpresaService();

  late Future<List<Empresa>> _empresasFuture;
  ThemeData? _theme;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  @override
  void initState() {
    super.initState();
    _empresasFuture = empresaService.buscarEmpresaPorUsuario();
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
        title: 'Empresas',
        subtitle: 'Gerencie todas as empresas cadastradas na plataforma.',
        tituloBotao: 'Adicionar Empresa',
        onPressed: () {
          context.go('/empresas/cadastro');
        },
      ),
      body: TelaListagemPadrao(
        titulo: 'Lista de Empresas',
        dataTable: FutureBuilder<List<Empresa>>(
          future: _empresasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar empresas: ${snapshot.error}',
                  style: TextStyle(color: _colorScheme.error),
                ),
              );
            }
            final empresas = snapshot.data ?? [];
            if (empresas.isEmpty) {
              return Center(
                child: Text(
                  'Nenhuma empresa encontrada.',
                  style: TextStyle(color: _colorScheme.onSurface),
                ),
              );
            }
            return _gridDados(empresas);
          },
        ),
      ),
    );
  }

  DataTable2 _gridDados(List<Empresa> empresas) {
    final headerStyle = _textTheme.titleSmall?.copyWith(
      color: _colorScheme.onSurface,
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
          label: Text('CNPJ/CPF', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('NOME', style: headerStyle),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('ENDEREÇO', style: headerStyle),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('WHATSAPP', style: headerStyle),
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
      rows: empresas.map((empresa) {
        int index = empresas.indexOf(empresa);
        return DataRow(
          color: WidgetStateProperty.all(
            index % 2 == 0
                ? _colorScheme.onSurface.withValues(alpha: 0.03) // linha clara
                : Colors.transparent,
          ), 
          cells: [
            DataCell(Text(UtilTexto.formatarCpfCnpj(empresa.cpfCnpj), style: itensStyle,)),
            DataCell(Text(empresa.nome, style: itensStyle)),
            DataCell(Text(empresa.endereco.enderecoCompleto(), style: itensStyle)),
            DataCell(Text(UtilTexto.formatarTelefone(empresa.whatsApp), style: itensStyle)),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: _colorScheme.onSurface),
                  onSelected: (value) {
                    if (value == 'editar') {
                      context.go('/empresas/cadastro', extra: empresa);
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
