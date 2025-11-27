import 'dart:async';

import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
  bool _carregandoEmpresas = false;

  @override
  void initState() {
    super.initState();
    buscarListaEmpresa();
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

  void buscarListaEmpresa() async {
    await ListaEmpresaSingleton.instance.buscarListaEmpresaUsuarioLocal().then((
      value,
    ) {
      setState(() {
        ListaEmpresaSingleton.instance.empresas;
      });
    });

    if (ListaEmpresaSingleton.instance.empresas.isEmpty) {
      atualizarListaEmpresa();
    }
  }

  Future<void> atualizarListaEmpresa() async {
    setState(() {
      _carregandoEmpresas = true;
    });

    try {
      var listaEmpresas = await empresaService.buscarEmpresaPorUsuario();
      ListaEmpresaSingleton.instance.setListaEmpresa(listaEmpresas);

      if ((ListaEmpresaSingleton.instance.selectedEmpresaId ?? 0) == 0) {
        if (ListaEmpresaSingleton.instance.empresas.isNotEmpty) {
          ListaEmpresaSingleton.instance.setSelectedEmpresaId(
            ListaEmpresaSingleton.instance.empresas.first.id,
          );
        }
      }

      setState(() {
        _carregandoEmpresas = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoEmpresas = false);
      UtilMensagem.showErro(context, "Falha ao buscar as empresas do usuário: $e");
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          _menuLateral(),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  color: theme.scaffoldBackgroundColor,
                  child: _menuSuperior(),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.onSurfaceVariant,
                        width: 0.5,
                      ),
                    ),
                    child: (_carregandoEmpresas)
                        ? Center(child: CircularProgressIndicator())
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: widget.child,
                          ), // conteúdo da agenda
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MouseRegion(
      //onEnter: (_) => setState(() => _isCollapsed = false),
      //onExit: (_) => setState(() => _isCollapsed = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isCollapsed ? 70 : 230,
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      themeNotifier.isDarkMode
                          ? "assets/img/logo128.png"
                          : "assets/img/logoClaro128.png",
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
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Software para barbearia',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
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
            _menuItem(Icons.content_cut, 'Serviços', '/servicos', context),
            _menuItem(Icons.people, 'Profissionais', '/profissionais', context),
            _menuItem(Icons.calendar_month, 'Agenda', '/agendas', context),
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
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
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
          if (UsuarioSingleton.instance.usuario != null)
            if ((ListaEmpresaSingleton.instance.empresas.isNotEmpty) &&
                ((ListaEmpresaSingleton.instance.selectedEmpresaId ?? 0) > 0))
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
                  menuItemStyleData: const MenuItemStyleData(height: 60),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(color: colorScheme.surface),
                  ),
                  items: ListaEmpresaSingleton.instance.empresas.map((empresa) {
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
                  value: ListaEmpresaSingleton.instance.selectedEmpresaId,
                  onChanged: (value) {
                    setState(() {
                      ListaEmpresaSingleton.instance.setSelectedEmpresaId(
                        value!,
                      );
                    });
                    context.go('/dashboard');
                  },
                  selectedItemBuilder: (context) {
                    return ListaEmpresaSingleton.instance.empresas.map((
                      empresa,
                    ) {
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
              child: Icon(
                Icons.notifications_none,
                color: colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.person, size: 40, color: colorScheme.primary),
          const SizedBox(width: 4),
          if (UsuarioSingleton.instance.usuario != null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    UsuarioSingleton.instance.usuario!.nome,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Administrador",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
            onSelected: (value) {
              if (value == 'sair') {
                UsuarioSingleton.instance.clear();
                ListaEmpresaSingleton.instance.clear();
                context.go('/');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sair',
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined, color: colorScheme.primary),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String label,
    String route,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isActive = GoRouterState.of(context).uri.toString() == route;

    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.7);

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.08)
              : Colors.transparent,
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
            ],
          ],
        ),
      ),
    );
  }
}
