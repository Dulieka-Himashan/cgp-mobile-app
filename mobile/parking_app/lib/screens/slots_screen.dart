import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({super.key});

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  List<dynamic> _slots = [];
  bool _isLoading = true;
  int _available = 0;
  int _occupied = 0;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getSlots();
    if (result['status'] == 'success') {
      setState(() {
        _slots = result['data'];
        _available = result['available'];
        _occupied = result['occupied'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSlots,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Available',
                            value: _available.toString(),
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Occupied',
                            value: _occupied.toString(),
                            color: Colors.red,
                            icon: Icons.cancel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Total',
                            value: _slots.length.toString(),
                            color: Colors.blue,
                            icon: Icons.local_parking,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: _slots.length,
                      itemBuilder: (context, index) {
                        final slot = _slots[index];
                        final isOccupied = slot['is_occupied'] == 1;
                        return Container(
                          decoration: BoxDecoration(
                            color: isOccupied ? Colors.red[100] : Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isOccupied ? Colors.red : Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isOccupied ? Icons.directions_car : Icons.check,
                                color: isOccupied ? Colors.red : Colors.green,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                slot['slot_number'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isOccupied ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadSlots,
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}