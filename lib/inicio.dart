import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'capturaempleados.dart';
import 'gestionproductos.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // El StreamBuilder en main.dart redirige automáticamente al Login
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7C02F),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  'https://raw.githubusercontent.com/Antonio347Vania/im-genes-para-flutter-6toI-11-Feb-2026/refs/heads/main/logo.jpg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.store, color: Color(0xFFF7C02F), size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Área Admin',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
        actions: [
          // Muestra el email del usuario actual
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                user?.email ?? '',
                style:
                    const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          // Botón Cerrar Sesión
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            tooltip: 'Cerrar sesión',
            onPressed: () => _confirmarLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo
            Text(
              '¡Bienvenida, ${user?.email?.split('@').first ?? 'Admin'}!',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selecciona un módulo para gestionar',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // ── Tarjeta Empleados ─────────────────────────────────────
            _tarjetaModulo(
              context: context,
              titulo: 'Nómina de Empleados',
              subtitulo: 'Alta, edición y baja de personal',
              icono: Icons.people,
              color: const Color(0xFF4CAF50),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CapturaEmpleados()),
              ),
            ),
            const SizedBox(height: 20),

            // ── Tarjeta Productos ─────────────────────────────────────
            _tarjetaModulo(
              context: context,
              titulo: 'Inventario de Artículos',
              subtitulo: 'Control de productos y stock',
              icono: Icons.inventory_2,
              color: const Color(0xFFF7C02F),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const GestionProductos()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaModulo({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icono, size: 32, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitulo,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('Se cerrará tu sesión actual.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            child: const Text('Salir',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) await _cerrarSesion(context);
  }
}
