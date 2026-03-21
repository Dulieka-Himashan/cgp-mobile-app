import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _vehicleController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _vehicleType = 'car';
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  Future<void> _register() async {
    if (_vehicleController.text.isEmpty || _nameController.text.isEmpty) {
      setState(() {
        _message = 'Please fill in all required fields';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final result = await ApiService.registerVehicle(
      _vehicleController.text.toUpperCase().trim(),
      _nameController.text.trim(),
      _vehicleType,
      _phoneController.text.trim(),
    );

    setState(() {
      _isLoading = false;
      _isSuccess = result['status'] == 'success';
      _message = result['message'] ?? 'Something went wrong';
    });

    if (_isSuccess) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Register Vehicle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.app_registration, size: 64, color: Colors.white),
              const SizedBox(height: 12),
              const Text(
                'New Vehicle Registration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your vehicle will be reviewed by admin',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _vehicleController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: 'Vehicle Number *',
                          hintText: 'e.g. SPQL9904',
                          prefixIcon: const Icon(Icons.directions_car),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Owner Name *',
                          hintText: 'e.g. John Doe',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number (optional)',
                          hintText: 'e.g. 0771234567',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Vehicle Type',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _TypeButton(
                            label: 'Car',
                            icon: Icons.directions_car,
                            selected: _vehicleType == 'car',
                            onTap: () => setState(() => _vehicleType = 'car'),
                          ),
                          const SizedBox(width: 12),
                          _TypeButton(
                            label: 'Bike',
                            icon: Icons.two_wheeler,
                            selected: _vehicleType == 'bike',
                            onTap: () => setState(() => _vehicleType = 'bike'),
                          ),
                          const SizedBox(width: 12),
                          _TypeButton(
                            label: 'Van',
                            icon: Icons.airport_shuttle,
                            selected: _vehicleType == 'van',
                            onTap: () => setState(() => _vehicleType = 'van'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isSuccess
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isSuccess
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isSuccess
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: _isSuccess
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _message,
                                    style: TextStyle(
                                      color: _isSuccess
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'REGISTER VEHICLE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1565C0)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1565C0)
                  : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}