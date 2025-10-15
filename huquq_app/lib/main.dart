import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/notification_service.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const HuquqApp(),
    ),
  );
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
                  key: const ValueKey('pin_title'),
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
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (int i = 1; i <= 9; i++)
                      ElevatedButton(
                        key: ValueKey('digit_$i'),
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
                      key: const ValueKey('clear'),
                      onPressed: _clearDigit,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(Icons.backspace),
                    ),
                    ElevatedButton(
                      key: const ValueKey('zero'),
                      onPressed: () => _addDigit('0'),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text('0', style: TextStyle(fontSize: 24)),
                    ),
                    ElevatedButton(
                      key: const ValueKey('validate'),
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _revenusController = TextEditingController();
  final _depensesController = TextEditingController();
  final _dettesController = TextEditingController();
  final _dejaPayeController = TextEditingController();
  String _monnaie = 'EUR';
  String _periodePaiement = 'annuel'; // New field for payment period: 'annuel', 'trimestriel', 'mensuel'
  double? _revenusNets;
  double? _huququTotal;
  double? _montantRestant;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, String> _symboles = {
    'EUR': '€',
    'USD': '\$',
    'GBP': '£',
    'CAD': 'CAD',
    'CHF': 'CHF',
    'MAD': 'MAD',
    'TND': 'TND',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadGoldPrice();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculerHuququ() {
    if (_formKey.currentState!.validate()) {
      final revenus = double.tryParse(_revenusController.text) ?? 0;
      final depenses = double.tryParse(_depensesController.text) ?? 0;
      final dettes = double.tryParse(_dettesController.text) ?? 0;
      final dejaPaye = double.tryParse(_dejaPayeController.text) ?? 0;

      // Adjust calculation based on payment period
      double revenusAjustes = revenus;
      double depensesAjustes = depenses;
      double dettesAjustes = dettes;
      double dejaPayeAjuste = dejaPaye;

      switch (_periodePaiement) {
        case 'trimestriel':
          // Convert quarterly to annual for calculation
          revenusAjustes *= 4;
          depensesAjustes *= 4;
          dettesAjustes *= 4;
          dejaPayeAjuste *= 4;
          break;
        case 'mensuel':
          // Convert monthly to annual for calculation
          revenusAjustes *= 12;
          depensesAjustes *= 12;
          dettesAjustes *= 12;
          dejaPayeAjuste *= 12;
          break;
        case 'annuel':
        default:
          // Already annual, no conversion needed
          break;
      }

      final revenusNets = revenusAjustes - depensesAjustes - dettesAjustes;
      final huququTotal = revenusNets * 0.19;
      final montantRestant = huququTotal - dejaPayeAjuste;

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

  String _getPeriodeLabel() {
    switch (_periodePaiement) {
      case 'trimestriel':
        return 'trimestriels';
      case 'mensuel':
        return 'mensuels';
      case 'annuel':
      default:
        return 'annuels';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final goldPrice = appProvider.goldPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur Huququ\'llah'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2, // Reduced elevation for better performance
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
                        if (appProvider.isLoading)
                          const CircularProgressIndicator()
                        else if (goldPrice != null)
                          Column(
                            children: [
                              Text(
                                '${goldPrice.pricePerGram.toStringAsFixed(2)} ${goldPrice.currency}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Prix par kilo: ${goldPrice.pricePerKilo.toStringAsFixed(2)} ${goldPrice.currency}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Prix par mithqal: ${goldPrice.pricePerMithqal.toStringAsFixed(2)} ${goldPrice.currency}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        else
                          const Text('Prix non disponible'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Payment Period Selection
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📅 Période de paiement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment<String>(
                              value: 'annuel',
                              label: Text('Annuel'),
                            ),
                            ButtonSegment<String>(
                              value: 'trimestriel',
                              label: Text('Trimestriel'),
                            ),
                            ButtonSegment<String>(
                              value: 'mensuel',
                              label: Text('Mensuel'),
                            ),
                          ],
                          selected: {_periodePaiement},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _periodePaiement = newSelection.first;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  '💰 Revenus ${_getPeriodeLabel()} totaux',
                  _revenusController,
                  'Ex: ${_periodePaiement == 'annuel' ? '50000' : _periodePaiement == 'trimestriel' ? '12500' : '4167'}',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer vos revenus';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  '🏠 Dépenses essentielles ${_getPeriodeLabel()}',
                  _depensesController,
                  'Ex: ${_periodePaiement == 'annuel' ? '30000' : _periodePaiement == 'trimestriel' ? '7500' : '2500'}',
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  '📋 Dettes en cours',
                  _dettesController,
                  'Ex: 5000',
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  '✅ Huququ\'llah déjà payé cette ${_periodePaiement == 'annuel' ? 'année' : _periodePaiement == 'trimestriel' ? 'trimestre' : 'mois'}',
                  _dejaPayeController,
                  'Ex: 0',
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2, // Reduced elevation for better performance
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
                          key: const ValueKey('currency_dropdown'),
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
                    elevation: 2, // Reduced elevation for better performance
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
      ),
    );
  }

  Widget _buildInputCard(
    String label,
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 2, // Reduced elevation for better performance
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              key: ValueKey('input_${label.hashCode}'),
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: hint),
              validator: validator,
            ),
          ],
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
