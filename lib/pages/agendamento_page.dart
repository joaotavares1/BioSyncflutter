import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  // Rota estática para facilitar a navegação no main.dart
  static const String routePath = '/agendamento';

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  // Controladores
  final TextEditingController _searchController = TextEditingController();

  // Variáveis de Estado (State)
  int? _selectedDayIndex; // Para controlar qual dia foi clicado no calendário
  String? _selectedColetor;
  String? _selectedMaterial;
  String? _selectedHorario;

  // Listas de dados (Mock)
  final List<String> _coletores = ['João Silva', 'Maria Santos', 'Pedro Costa'];
  final List<String> _materiais = ['Papel', 'Plástico', 'Metal', 'Vidro'];
  final List<String> _horarios = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '14:00 - 16:00',
    '16:00 - 18:00'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tema base
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238), // Cor de fundo original
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 80, 225, 138),
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Agendamento de Coleta',
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- 1. BARRA DE PESQUISA ---
              TextFormField(
                style: const TextStyle(color: Colors.black54, fontSize: 16),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar agendamentos...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 16),

              // --- 2. CALENDÁRIO ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color.fromARGB(255, 217, 217, 217)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Selecione a Data',
                      style: GoogleFonts.interTight(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // GridView gerando os dias do mês (1 a 30)
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isSelected = _selectedDayIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Color.fromARGB(255, 80, 225, 138) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Color.fromARGB(255, 80, 225, 138) : Color(0xFFDDDDDD),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$day',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Color.fromARGB(255, 150, 150, 150),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- 3. FORMULÁRIO DE DADOS ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Agendamento',
                  style: GoogleFonts.interTight(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Row com Coletor e Material
              Row(
                children: [
                  Expanded(
                    child: _buildNativeDropdown(
                      hint: 'Coletor',
                      value: _selectedColetor,
                      items: _coletores,
                      onChanged: (val) => setState(() => _selectedColetor = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNativeDropdown(
                      hint: 'Material',
                      value: _selectedMaterial,
                      items: _materiais,
                      onChanged: (val) => setState(() => _selectedMaterial = val),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Dropdown Horário
              _buildNativeDropdown(
                hint: 'Horário da Coleta',
                value: _selectedHorario,
                items: _horarios,
                onChanged: (val) => setState(() => _selectedHorario = val),
              ),

              const SizedBox(height: 12),

              // Botão Agendar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDayIndex != null &&
                        _selectedColetor != null &&
                        _selectedMaterial != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agendamento Realizado!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Preencha todos os campos e selecione a data.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Agendar Coleta',
                    style: GoogleFonts.interTight(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // --- 4. CARD DE AGENDAMENTO CONFIRMADO (Detalhes) ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromARGB(255, 217, 217, 217)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Cabeçalho do Card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Agendamento Confirmado',
                            style: GoogleFonts.interTight(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Lógica de deletar
                            },
                            icon: const Icon(Icons.delete,
                                color: Colors.black54, size: 18),
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFFDDDDDD)),
                      const SizedBox(height: 8),

                      // Detalhes (Linha a Linha)
                      _buildDetailRow('Data:', '15/12/2024'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Coletor:', 'João Silva'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Material:', 'Papel'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Horário:', '08:00 - 10:00'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Endereço:', 'Rua das Flores, 123'),
                      const SizedBox(height: 16),

                      // Status Badge
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(96, 0, 0, 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Status: Agendado',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets Auxiliares para limpar o código ---

  // Widget de Dropdown Nativo
  Widget _buildNativeDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 80, 225, 138)),
        ),
      ),
      hint: Text(
        hint,
        style: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 16 ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Widget para as linhas de detalhe do Card
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}