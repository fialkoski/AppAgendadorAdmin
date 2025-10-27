import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:agendadoradmin/tools/util.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dropdown_button2/dropdown_button2.dart';

class PrincipalScreen extends StatefulWidget {
  final Widget child;
  const PrincipalScreen({super.key, required this.child});

  @override
  State<PrincipalScreen> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<PrincipalScreen> {
  bool _isCollapsed = false;
  final EmpresaService empresaService = EmpresaService();
  late var provider;
   bool _inicializado = false;

  @override
  void initState() {
    super.initState();
    html.document.title =
        'BarbeariaApp - Plataforma de Agendamento para Barbearias';
    if (EmpresaSingleton.instance.empresa == null) {
      atualizarListaEmpresa();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      provider = context.watch<EmpresaProvider>();
      // Aqui é seguro usar Provider com listen (dependências já disponíveis)
      //final provider = Provider.of<EmpresaProvider>(context); // listen: true por padrão
      //provider.carregarEmpresas(); // ou qualquer inicialização que dependa do provider
      _inicializado = true;
    }
  }

  void atualizarListaEmpresa() {
    empresaService.buscarEmpresaPorUsuario().then((listaEmpresas) {
      setState(() {
        ListaEmpresaSingleton.instance.setListaEmpresa(listaEmpresas);
      });

      if (EmpresaSingleton.instance.empresa == null) {
        setState(() {
          if (ListaEmpresaSingleton.instance.empresas != null) {
            EmpresaSingleton.instance
                .setEmpresa(ListaEmpresaSingleton.instance.empresas!.first);
          }
        });
      }
      Util.salvaDadosLocal("empresaSelecionada",
          EmpresaSingleton.instance.empresa!.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          _menuLateral(),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: _menuSuperior(),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuLateral() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return MouseRegion(
      // onEnter: (_) => setState(() => _isCollapsed = false),
      // onExit: (_) => setState(() => _isCollapsed = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isCollapsed ? 70 : 230,
        color: colorScheme.surface,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/img/logo.png",
                      height: 25,
                    ),

                    const SizedBox(width: 8),

                    // Textos à direita
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Barbearia Fácil',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Software para barbearia',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _menuItem(Icons.dashboard, 'Dashboard', '/dashboard', context),
            _menuItem(Icons.business, 'Empresas', '/empresas', context),
            _menuItem(Icons.people, 'Profissionais', '/profissionais', context),
            _menuItem(Icons.content_cut, 'Serviços', '/servicos', context),
            const Spacer(),
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) => ListTile(
                leading: Icon(
                  themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                  color: colorScheme.primary,
                ),
                title: Text(
                  'Tema ${themeNotifier.isDarkMode ? 'Claro' : 'Escuro'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                onTap: () {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuSuperior() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ListaEmpresaSingleton.instance.empresas != null)
              DropdownButtonHideUnderline(
                child: DropdownButton2<int>(
                  isExpanded: true,
                  buttonStyleData: ButtonStyleData(
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 60,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                    ),
                  ),
                  items: ListaEmpresaSingleton.instance.empresas!.map((empresa) {
                    return DropdownMenuItem<int>(
                      value: empresa.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${empresa.nome} - ${UtilTexto.formatarCpfCnpj(empresa.cpfCnpj)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            empresa.endereco.enderecoCompleto(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  value: EmpresaSingleton.instance.selectedEmpresaId,
                  onChanged: (value) {
                    setState(() {
                      EmpresaSingleton.instance.setSelectedEmpresaId(value!);
                      final empresaSelecionada =
                          ListaEmpresaSingleton.instance.empresas!.firstWhere((e) => e.id == EmpresaSingleton.instance.selectedEmpresaId);
                      EmpresaSingleton.instance.setEmpresa(empresaSelecionada);
                    });
                  },
                  selectedItemBuilder: (context) {
                    return ListaEmpresaSingleton.instance.empresas!.map((empresa) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${empresa.nome} - ${UtilTexto.formatarCpfCnpj(empresa.cpfCnpj)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            empresa.endereco.enderecoCompleto(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            Spacer(),
            const SizedBox(width: 16),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.notifications_none,
                    color: colorScheme.onSurface, size: 20),
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.person,
              size: 40,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    UsuarioSingleton.instance.usuario!.nome,
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Administrador",
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurface, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.surface,
                ),
                child: Icon(Icons.keyboard_arrow_down,
                    color: colorScheme.primary, size: 24),
              ),
            ),
          ],
        ));
  }

  Widget _menuItem(
      IconData icon, String label, String route, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isActive = GoRouterState.of(context).uri.toString() == route;

    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withOpacity(0.7);

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.08) : Colors.transparent,
          border: isActive
              ? Border(left: BorderSide(color: activeColor, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? activeColor : inactiveColor),
            if (!_isCollapsed) ...[
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isActive ? activeColor : inactiveColor,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
