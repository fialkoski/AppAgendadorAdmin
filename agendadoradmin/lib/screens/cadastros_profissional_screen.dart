import 'dart:typed_data';
import 'package:agendadoradmin/models/Profissional.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';
import 'package:agendadoradmin/tools/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CadastroProfissionalScreen extends StatefulWidget {
  final Profissional? profissional;

  const CadastroProfissionalScreen({super.key, this.profissional});

  @override
  _CadastroProfissionalState createState() => _CadastroProfissionalState();
}

class _CadastroProfissionalState extends State<CadastroProfissionalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String? _fotoUrl;
  bool _ativo = true;
  Uint8List? _fotoBytes;
  String? _fotoNome;
  bool _isSaving = false;
  final ProfissionalService _service = ProfissionalService();

  @override
  void initState() {
    super.initState();
    debugPrint('Inicializando CadastroProfissionalFormPage');
    if (widget.profissional != null) {
      _nomeController.text = widget.profissional!.nome;
      _fotoUrl = widget.profissional!.foto;
      _ativo = widget.profissional!.ativo == 1;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }


  Future<void> _uploadImagem() async {
    if (_fotoBytes == null) return;
    ProfissionalService profissionalService = ProfissionalService();
    _fotoUrl = await profissionalService.uploadImagem(_fotoBytes!, _fotoNome!);

    setState(() {
      debugPrint('Erro no upload: $_fotoUrl');
    });

    if (_fotoUrl != null && _fotoUrl!.contains('imagensBarbearia')) {
      debugPrint('Imagem enviada com sucesso, caminho: $_fotoUrl');
    } else {
      debugPrint('Erro no upload: $_fotoUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no upload: $_fotoUrl')),
      );
    }
  }

  Future<void> _salvarProfissional() async {
    if (_isSaving) return; // Evita múltiplos cliques
    setState(() {
      _isSaving = true; // Trava o botão
    });

    if (_formKey.currentState!.validate()) {
      debugPrint('Salvando profissional: ${_nomeController.text}');
      if (EmpresaSingleton.instance.empresa == null) {
        debugPrint('Erro: EmpresaSingleton.empresa é null, buscando empresa...');
        final cpfcnpj = EmpresaSingleton.instance.empresa?.cpfCnpj ?? '0';
        try {
          final empresa = await EmpresaService().buscarEmpresaPorCpfcnpj(cpfcnpj);
          EmpresaSingleton.instance.setEmpresa(empresa);
        } catch (e) {
          debugPrint('Erro ao buscar empresa: $e');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro: Empresa não encontrada')));
          setState(() {
            _isSaving = false;
          });
          return;
        }
      }

      // Envia a imagem antes de salvar, se houver
      if (_fotoBytes != null && _fotoUrl == null) {
        await _uploadImagem();
        if (_fotoUrl == null) {
          debugPrint('Erro: Upload da imagem falhou, abortando salvamento');
          setState(() {
            _isSaving = false; // Reativa o botão em caso de erro
          });
          return;
        }
      }

      Profissional prof = Profissional(
        id: widget.profissional?.id,
        idEmpresa: EmpresaSingleton.instance.empresa!.id,
        nome: _nomeController.text,
        foto: _fotoUrl ?? widget.profissional?.foto ?? '',
        ativo: _ativo ? 1 : 0,
      );

      try {
        String resultado = widget.profissional == null
            ? await _service.salvarProfissional(prof)
            : await _service.atualizarProfissional(prof.id!, prof);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado)));
        final cpfcnpj = EmpresaSingleton.instance.empresa?.cpfCnpj ?? '0';
        debugPrint('Salvando, navegando para /?cpfcnpj=$cpfcnpj');
        context.go('/?cpfcnpj=$cpfcnpj');
      } catch (e) {
        print('Exception: \$e');
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Construindo CadastroProfissionalFormPage');
    final cpfcnpj = EmpresaSingleton.instance.empresa?.cpfCnpj ?? '0';
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          debugPrint('Botão de voltar do navegador pressionado, navegando para /?cpfcnpj=$cpfcnpj');
          context.go('/?cpfcnpj=$cpfcnpj');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              debugPrint('Botão Voltar pressionado, navegando para /?cpfcnpj=$cpfcnpj');
              context.go('/?cpfcnpj=$cpfcnpj');
            },
          ),
          title: Text(widget.profissional == null ? 'Novo Profissional' : 'Editar Profissional'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                      validator: (value) =>
                          value!.isEmpty ? 'Nome obrigatório' : (value.length > 50 ? 'Máx. 50 caracteres' : null),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              debugPrint('Abrindo FilePicker');
                              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                              if (result != null) {
                                setState(() {
                                  _fotoBytes = result.files.single.bytes;
                                  _fotoNome = result.files.single.name;
                                  _fotoUrl = null; // Reseta até o upload ser concluído
                                });
                              }
                            },
                      child: const Text('Upload Foto'),
                    ),
                    const SizedBox(height: 16),
                    if (_fotoBytes != null || _fotoUrl != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _fotoBytes != null && _fotoUrl == null
                            ? Image.memory(_fotoBytes!, height: 150, width: 150, fit: BoxFit.cover)
                            : (_fotoUrl != null && _fotoUrl!.isNotEmpty && _fotoUrl != 'url_placeholder')
                                ? FutureBuilder<bool>(
                                    future: Util.checkImageAccessibility(
                                      _fotoUrl!.startsWith('http') ? _fotoUrl! : ApiService.URLBASEIMG + _fotoUrl!,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasData && snapshot.data == true) {
                                        return Image.network(
                                          _fotoUrl!.startsWith('http') ? _fotoUrl! : ApiService.URLBASEIMG + _fotoUrl!,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            debugPrint('Erro ao carregar imagem $_fotoUrl: $error');
                                            return const Icon(Icons.error, size: 50, color: Colors.red);
                                          },
                                        );
                                      }
                                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                    },
                                  )
                                : const Icon(Icons.person, size: 50),
                      ),
                    SwitchListTile(
                      title: const Text('Ativo'),
                      value: _ativo,
                      onChanged: (value) {
                        debugPrint('Alterando estado ativo: $value');
                        setState(() => _ativo = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _isSaving ? null : _salvarProfissional,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
