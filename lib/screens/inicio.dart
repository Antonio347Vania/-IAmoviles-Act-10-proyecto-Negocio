import 'package:flutter/material.dart';
import 'gestion_productos.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EB), // Fondo crema suave
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7C02F), // Amarillo
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: Color(0xFFF7C02F)),
            ),
            SizedBox(width: 10),
            Text('Soriana Vania', style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDashboardCard(
              context: context,
              title: 'Nómina de Empleados',
              icon: Icons.people,
              color: const Color(0xFF4CAF50), // Verde
              onTap: () {
                // Navegar a Gestión de Empleados (por implementar)
              },
            ),
            const SizedBox(height: 20),
            _buildDashboardCard(
              context: context,
              title: 'Inventario de Productos',
              icon: Icons.inventory,
              color: const Color(0xFFF7C02F), // Amarillo
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionProductosScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
