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
      backgroundColor: _colorScheme.surface,
      appBar: AppBarPadrao(
          icon: null,
          title: 'Empresas',
          subtitle: 'Gerencie todas as empresas cadastradas na plataforma.',
          tituloBotao: 'Adicionar Empresa',
          onPressed: () {
            context.go('/empresas/cadastro');
          }),
      body: TelaListagemPadrao(
        titulo: 'Lista de Empresas',
        dataTable: FutureBuilder<List<Empresa>>(
          future: _empresasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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

  DataTable2 _gridDados(
      List<Empresa> empresas) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 800,
      columns: [
        DataColumn2(
            label: Text(
              'CNPJ / CPF',
              style: _textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.S),
        DataColumn2(
            label: Text(
              'Nome',
              style: _textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.L),
        DataColumn2(
            label: Text(
              'Endereço',
              style: _textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.L),
        DataColumn2(
            label: Text(
              'WhatsApp',
              style: _textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.S),
        DataColumn2(
            label: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ações',
                style: _textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _colorScheme.onSurface,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            size: ColumnSize.S),
      ],
      rows: empresas.map((empresa) {
        return DataRow(
          cells: [
            DataCell(Text(UtilTexto.formatarCpfCnpj(empresa.cpfCnpj))),
            DataCell(Text(empresa.nome)),
            DataCell(Text(empresa.endereco.enderecoCompleto())),
            DataCell(Text(UtilTexto.formatarTelefone(empresa.whatsApp))),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: _colorScheme.onSurface,
                  ),
                  onSelected: (value) {
                    if (value == 'editar') {
                      context.go('/empresas/cadastro', extra: empresa) ;
                    } else if (value == 'excluir') {
                      // TODO: excluir empresa
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
                    PopupMenuItem(
                      value: 'excluir',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: _colorScheme.error),
                          SizedBox(width: 8),
                          Text('Excluir'),
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
