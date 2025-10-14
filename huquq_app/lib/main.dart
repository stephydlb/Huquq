import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HuquqApp());
}

class HuquqApp extends StatelessWidget {
  const HuquqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huququ\'llah Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PinScreen(),
    );
  }
}

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _savedPin = '';
  bool _isSettingPin = false;
  String _confirmPin = '';
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('pin') ?? '';
    });
  }

  Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
    setState(() {
      _savedPin = pin;
    });
  }

  void _addDigit(String digit) {
    if (_isConfirming) {
      if (_confirmPin.length < 4) {
        setState(() {
          _confirmPin += digit;
        });
      }
    } else {
      if (_pin.length < 4) {
        setState(() {
          _pin += digit;
        });
      }
    }
  }

  void _clearDigit() {
    if (_isConfirming) {
      if (_confirmPin.isNotEmpty) {
        setState(() {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        });
      }
    } else {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin = _pin.substring(0, _pin.length - 1);
        });
      }
    }
  }

  void _validatePin() {
    if (_isSettingPin) {
      if (!_isConfirming) {
        if (_pin.length == 4) {
          setState(() {
            _isConfirming = true;
            _confirmPin = '';
          });
        }
      } else {
        if (_confirmPin.length == 4) {
          if (_pin == _confirmPin) {
            _savePin(_pin);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            setState(() {
              _pin = '';
              _confirmPin = '';
              _isConfirming = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Les codes PIN ne correspondent pas'),
              ),
            );
          }
        }
      }
    } else {
      if (_pin.length == 4) {
        if (_pin == _savedPin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            _pin = '';
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Code PIN incorrect')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_savedPin.isEmpty && !_isSettingPin) {
      _isSettingPin = true;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  _isSettingPin
                      ? (_isConfirming ? 'Confirmer le PIN' : 'Créer un PIN')
                      : 'Entrez votre PIN',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final currentPin = _isConfirming ? _confirmPin : _pin;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < currentPin.length
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: [
                    for (int i = 1; i <= 9; i++)
                      ElevatedButton(
                        onPressed: () => _addDigit(i.toString()),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Text(
                          i.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _clearDigit,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(Icons.backspace),
                    ),
                    ElevatedButton(
                      onPressed: () => _addDigit('0'),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text('0', style: TextStyle(fontSize: 24)),
                    ),
                    ElevatedButton(
                      onPressed: _validatePin,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.green,
                      ),
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _revenusController = TextEditingController();
  final _depensesController = TextEditingController();
  final _dettesController = TextEditingController();
  final _dejaPayeController = TextEditingController();
  String _monnaie = 'EUR';
  double? _revenusNets;
  double? _huququTotal;
  double? _montantRestant;

  final Map<String, String> _symboles = {
    'EUR': '€',
    'USD': '\$',
    'GBP': '£',
    'CAD': 'CAD',
    'CHF': 'CHF',
    'MAD': 'MAD',
    'TND': 'TND',
  };

  void _calculerHuququ() {
    if (_formKey.currentState!.validate()) {
      final revenus = double.tryParse(_revenusController.text) ?? 0;
      final depenses = double.tryParse(_depensesController.text) ?? 0;
      final dettes = double.tryParse(_dettesController.text) ?? 0;
      final dejaPaye = double.tryParse(_dejaPayeController.text) ?? 0;

      final revenusNets = revenus - depenses - dettes;
      final huququTotal = revenusNets * 0.19;
      final montantRestant = huququTotal - dejaPaye;

      setState(() {
        _revenusNets = revenusNets > 0 ? revenusNets : 0;
        _huququTotal = huququTotal > 0 ? huququTotal : 0;
        _montantRestant = montantRestant > 0 ? montantRestant : 0;
      });
    }
  }

  String _formatNombre(double nombre) {
    return '${nombre.toStringAsFixed(2)} ${_symboles[_monnaie]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur Huququ\'llah'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const PinScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Prix de l\'or',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('1 gramme d\'or 24k'),
                      const SizedBox(height: 8),
                      Text(
                        '65.50 €',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💰 Revenus annuels totaux',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _revenusController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 50000',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer vos revenus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏠 Dépenses essentielles annuelles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _depensesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 30000',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📋 Dettes en cours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _dettesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Ex: 5000'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Huququ\'llah déjà payé cette année',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _dejaPayeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Ex: 0'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💱 Monnaie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: _monnaie,
                        items: _symboles.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text('${entry.key} (${entry.value})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _monnaie = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculerHuququ,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text(
                  '🧮 Calculer le Huququ\'llah',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              if (_revenusNets != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 Résultats du calcul',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow(
                          'Revenus nets (après dépenses et dettes)',
                          _formatNombre(_revenusNets!),
                          Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        _buildResultRow(
                          'Huququ\'llah total dû (19%)',
                          _formatNombre(_huququTotal!),
                          Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildResultRow(
                          'Montant restant à payer',
                          _formatNombre(_montantRestant!),
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
