import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/flavor.dart';
import '../widgets/gf_scaffold.dart';
import 'ai_assistant_screen.dart';
import 'products_screen.dart';
import 'sizing_screen.dart';

/// Where a tool's primary action leads inside the app.
enum ToolTarget { sizing, advancedSelection, products, assistant, calculators }

/// A Product Center tool (from the site's mega menu), presented as a real
/// in-app destination wired to the closest Product Center function.
class AppTool {
  final String title;
  final String tagline;
  final String description;
  final IconData icon;
  final ToolTarget target;

  const AppTool(this.title, this.tagline, this.description, this.icon,
      this.target);

  /// The site's "Products & services" tools.
  static const registry = <AppTool>[
    AppTool(
      'Hot Water Recirculation Sizing Tool',
      'Application tool',
      'Size a circulator for a domestic or commercial hot-water '
          'recirculation loop by setting your flow and head requirements.',
      Icons.water_drop_outlined,
      ToolTarget.sizing,
    ),
    AppTool(
      'iGRID Configurator',
      'Application tool',
      'Configure an iGRID district-energy mixing and metering solution for '
          'your network zone.',
      Icons.hub_outlined,
      ToolTarget.assistant,
    ),
    AppTool(
      'Pit Creator',
      'Application tool',
      'Design a wastewater pit — pump selection, level controls and '
          'installation layout for lifting stations.',
      Icons.foundation_outlined,
      ToolTarget.products,
    ),
    AppTool(
      'Pumping Station Creator',
      'Application tool',
      'Build a complete pumping-station specification, from pumps and '
          'controls to the station structure.',
      Icons.account_tree_outlined,
      ToolTarget.products,
    ),
    AppTool(
      'Build your own Pump',
      'Product tool',
      'Configure a pump to your exact requirements and generate the '
          'product number and specification.',
      Icons.build_circle_outlined,
      ToolTarget.advancedSelection,
    ),
    AppTool(
      'MIXIT Sizing Tool',
      'Product tool',
      'Size a MIXIT connected mixing-loop solution for heating and cooling '
          'circuits.',
      Icons.tune_outlined,
      ToolTarget.sizing,
    ),
    AppTool(
      'Eica Selection Tool',
      'Product tool',
      'Select an Eica dosing and disinfection system for your water '
          'treatment application.',
      Icons.science_outlined,
      ToolTarget.products,
    ),
    AppTool(
      'Dosing Skid Configurator (US)',
      'Product tool',
      'Configure a pre-engineered chemical dosing skid to US standards.',
      Icons.precision_manufacturing_outlined,
      ToolTarget.products,
    ),
    AppTool(
      'Dosing Skid Configurator (Europe)',
      'Product tool',
      'Configure a pre-engineered chemical dosing skid to European '
          'standards.',
      Icons.precision_manufacturing_outlined,
      ToolTarget.products,
    ),
    AppTool(
      'Digital Dosing Pump Selection Tool',
      'Product tool',
      'Select a Grundfos SMART Digital dosing pump for your chemical, flow '
          'and pressure requirements.',
      Icons.opacity_outlined,
      ToolTarget.products,
    ),
  ];

  static AppTool byTitle(String title) =>
      registry.firstWhere((t) => t.title == title);
}

/// Detail screen for a single Product Center tool.
class ToolScreen extends StatelessWidget {
  final AppTool tool;

  const ToolScreen({super.key, required this.tool});

  (String, VoidCallback) _action(BuildContext context) {
    switch (tool.target) {
      case ToolTarget.sizing:
        return (
          'Open sizing',
          () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SizingScreen()))
        );
      case ToolTarget.advancedSelection:
        return (
          'Open Advanced Selection',
          () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AdvancedSelectionScreen()))
        );
      case ToolTarget.products:
        return (
          'Browse products',
          () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProductsScreen()))
        );
      case ToolTarget.assistant:
        return (
          'Ask Grundfos Assist',
          () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AiAssistantScreen(
                  seedQuestion: 'Help me with ${tool.title}')))
        );
      case ToolTarget.calculators:
        return (
          'Open calculators',
          () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CalculatorsScreen()))
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, onTap) = _action(context);
    return GfScaffold(
      children: [
        GradientHero(
          eyebrow: tool.tagline,
          title: tool.title,
          subtitle: tool.description,
          trailing: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: GfColors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(tool.icon, color: GfColors.white, size: 28),
          ),
          actions: [
            LightPillButton(label: label, icon: Icons.arrow_forward, onPressed: onTap),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('How it works'),
              const SizedBox(height: 10),
              const Text(
                'This tool guides you through the inputs for your '
                'application and returns matching Grundfos products with '
                'full specifications, performance curves and downloadable '
                'documentation — all from the digital catalogue.',
                style:
                    TextStyle(fontSize: 14.5, height: 1.5, color: GfColors.grey700),
              ),
              const SizedBox(height: 20),
              _step(1, 'Enter your requirements',
                  'Flow, head, liquid and application conditions.'),
              _step(2, 'Review matching products',
                  'Compare specifications and performance curves.'),
              _step(3, 'Download & share',
                  'Export the specification or full catalogue sheet.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step(int n, String title, String body) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: GfColors.actionBlue.withValues(alpha: 0.1),
              child: Text('$n',
                  style: const TextStyle(
                      color: GfColors.actionBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(body,
                      style: const TextStyle(
                          fontSize: 13.5, height: 1.4, color: GfColors.grey700)),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Working engineering calculators (real formulas). Mirrors the site's
/// "Calculators" tool group.
class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GfScaffold(
      children: [
        GradientHero(
          eyebrow: 'Product tools',
          title: 'Calculators',
          subtitle:
              'Quick hydraulic calculators for sizing and system design.',
        ),
        _FlowVelocityCalculator(),
        _HydraulicPowerCalculator(),
        _FlowUnitConverter(),
        SizedBox(height: 24),
      ],
    );
  }
}

class _CalcCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _CalcCard(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: GfColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GfColors.grey200),
        boxShadow: gfCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: GfColors.actionBlue, size: 22),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: GfColors.ink)),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

Widget _numField(String label, String suffix, TextEditingController c,
    VoidCallback onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(labelText: label, suffixText: suffix),
    ),
  );
}

Widget _result(String label, String value) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GfColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: GfColors.grey600)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Grundfos-Extd',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: GfColors.darkBlue)),
        ],
      ),
    );

class _FlowVelocityCalculator extends StatefulWidget {
  const _FlowVelocityCalculator();
  @override
  State<_FlowVelocityCalculator> createState() => _FlowVelocityState();
}

class _FlowVelocityState extends State<_FlowVelocityCalculator> {
  final _flow = TextEditingController(text: '10');
  final _dia = TextEditingController(text: '50');

  @override
  void dispose() {
    _flow.dispose();
    _dia.dispose();
    super.dispose();
  }

  String get _velocity {
    final q = double.tryParse(_flow.text); // m³/h
    final d = double.tryParse(_dia.text); // mm
    if (q == null || d == null || d <= 0) return '—';
    final area = 3.141592653589793 * (d / 1000) * (d / 1000) / 4; // m²
    final v = (q / 3600) / area; // m/s
    return '${v.toStringAsFixed(2)} m/s';
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Pipe flow velocity',
      icon: Icons.speed,
      children: [
        _numField('Flow rate', 'm³/h', _flow, () => setState(() {})),
        _numField('Pipe inner diameter', 'mm', _dia, () => setState(() {})),
        _result('Velocity  (v = Q / A)', _velocity),
      ],
    );
  }
}

class _HydraulicPowerCalculator extends StatefulWidget {
  const _HydraulicPowerCalculator();
  @override
  State<_HydraulicPowerCalculator> createState() => _HydraulicPowerState();
}

class _HydraulicPowerState extends State<_HydraulicPowerCalculator> {
  final _flow = TextEditingController(text: '10');
  final _head = TextEditingController(text: '20');
  final _eff = TextEditingController(text: '70');

  @override
  void dispose() {
    _flow.dispose();
    _head.dispose();
    _eff.dispose();
    super.dispose();
  }

  String get _power {
    final q = double.tryParse(_flow.text); // m³/h
    final h = double.tryParse(_head.text); // m
    final e = double.tryParse(_eff.text); // %
    if (q == null || h == null || e == null || e <= 0) return '—';
    // P[kW] = rho*g*Q*H / (3.6e6 * eff)
    final p = (1000 * 9.81 * q * h) / (3.6e6 * (e / 100));
    return '${p.toStringAsFixed(2)} kW';
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Pump shaft power',
      icon: Icons.bolt,
      children: [
        _numField('Flow rate', 'm³/h', _flow, () => setState(() {})),
        _numField('Head', 'm', _head, () => setState(() {})),
        _numField('Pump efficiency', '%', _eff, () => setState(() {})),
        _result('Power  (P = ρgQH / η)', _power),
      ],
    );
  }
}

class _FlowUnitConverter extends StatefulWidget {
  const _FlowUnitConverter();
  @override
  State<_FlowUnitConverter> createState() => _FlowUnitState();
}

class _FlowUnitState extends State<_FlowUnitConverter> {
  final _value = TextEditingController(text: '10');

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = double.tryParse(_value.text); // m³/h
    final ls = q == null ? '—' : '${(q / 3.6).toStringAsFixed(2)} l/s';
    final gpm = q == null ? '—' : '${(q * 4.40287).toStringAsFixed(1)} US gpm';
    return _CalcCard(
      title: 'Flow unit converter',
      icon: Icons.swap_horiz,
      children: [
        _numField('Flow rate', 'm³/h', _value, () => setState(() {})),
        Row(
          children: [
            Expanded(child: _result('litres / second', ls)),
            const SizedBox(width: 12),
            Expanded(child: _result('US gallons / min', gpm)),
          ],
        ),
      ],
    );
  }
}
