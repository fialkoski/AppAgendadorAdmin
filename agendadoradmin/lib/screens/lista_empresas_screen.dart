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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
          future: empresaService.buscarEmpresaPorUsuario(),
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
                  style: TextStyle(color: colorScheme.error),
                ),
              );
            }
            final empresas = snapshot.data ?? [];
            if (empresas.isEmpty) {
              return Center(
                child: Text(
                  'Nenhuma empresa encontrada.',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              );
            }
            return _gridDados(empresas, colorScheme, textTheme);
          },
        ),
      ),
    );
  }

  DataTable2 _gridDados(
      List<Empresa> empresas, ColorScheme colorScheme, textTheme) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 800,
      columns: [
        DataColumn2(
            label: Text(
              'CNPJ / CPF',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.S),
        DataColumn2(
            label: Text(
              'Nome',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.L),
        DataColumn2(
            label: Text(
              'Endereço',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.L),
        DataColumn2(
            label: Text(
              'WhatsApp',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.S),
        DataColumn2(
            label: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ações',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
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
                    color: colorScheme.onSurface,
                  ),
                  onSelected: (value) {
                    if (value == 'editar') {
                      // TODO: editar empresa
                    } else if (value == 'excluir') {
                      // TODO: excluir empresa
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: colorScheme.primary),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'excluir',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: colorScheme.error),
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
