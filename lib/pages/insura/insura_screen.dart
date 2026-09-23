import 'package:flutter/material.dart';

/// Static "Assistência · Automóvel" search screen for Insura, a generic
/// insurance brand: a CPF/CNPJ + placa lookup form. Colors and layout are
/// hardcoded for this page rather than following the site's own light/dark
/// palette, since it is a standalone UI mockup rather than portfolio
/// content.
class InsuraScreen extends StatefulWidget {
  const InsuraScreen({super.key});

  @override
  State<InsuraScreen> createState() => _InsuraScreenState();
}

class _InsuraScreenState extends State<InsuraScreen> {
  static const _accentColor = Color(0xFF2CA58D);
  static const _headingColor = Color(0xFF1A1818);
  static const _subtitleColor = Color(0xFF8C8C8C);
  static const _borderColor = Color(0xFFDDDDDD);

  final _cpfCnpjController = TextEditingController();
  final _placaController = TextEditingController();

  @override
  void dispose() {
    _cpfCnpjController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: _InsuraLogo(color: _headingColor)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assistência',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: _headingColor,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Automóvel',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: _subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Divider(color: _borderColor, height: 1.0),
                      const SizedBox(height: 24.0),
                      const _FieldLabel('CPF/CNPJ'),
                      const SizedBox(height: 8.0),
                      _InsuraTextField(controller: _cpfCnpjController),
                      const SizedBox(height: 24.0),
                      const _FieldLabel('PLACA'),
                      const SizedBox(height: 8.0),
                      _InsuraTextField(controller: _placaController),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _accentColor,
                            side: const BorderSide(color: _accentColor),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Text(
                            'Buscar',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsuraLogo extends StatelessWidget {
  final Color color;
  final bool compact;

  const _InsuraLogo({required this.color, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 22.0 : 32.0;
    final fontSize = compact ? 11.0 : 15.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.shield_outlined,
          color: _InsuraScreenState._accentColor,
          size: iconSize,
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Insura',
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12.0,
        color: _InsuraScreenState._subtitleColor,
      ),
    );
  }
}

class _InsuraTextField extends StatelessWidget {
  final TextEditingController controller;

  const _InsuraTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14.0,
        color: _InsuraScreenState._headingColor,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: _InsuraScreenState._borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: _InsuraScreenState._borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: _InsuraScreenState._accentColor),
        ),
      ),
    );
  }
}
