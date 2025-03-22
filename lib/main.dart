import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversor de Metros para Km',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  double? _ultimoResultado;

  @override
  void initState() {
    super.initState();
    _carregarUltimaConversao();
  }

  Future<void> _carregarUltimaConversao() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ultimoResultado = prefs.getDouble('ultimaConversao');
    });
  }

  Future<void> _salvarUltimaConversao(double valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ultimaConversao', valor);
  }

  void _converter() {
    final String texto = _controller.text;
    if (texto.isNotEmpty) {
      final double metros = double.tryParse(texto) ?? 0;
      final double km = metros / 1000;
      setState(() {
        _ultimoResultado = km;
      });
      _salvarUltimaConversao(km);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de Metros para Km')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite a distância em metros',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _converter,
              child: const Text('Converter'),
            ),
            const SizedBox(height: 20),
            if (_ultimoResultado != null)
              Text(
                'Conversão: $_ultimoResultado km',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
