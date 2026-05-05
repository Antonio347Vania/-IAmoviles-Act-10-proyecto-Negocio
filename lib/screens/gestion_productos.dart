import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../agents/firebase_agent.dart';

class GestionProductosScreen extends StatefulWidget {
  const GestionProductosScreen({super.key});

  @override
  State<GestionProductosScreen> createState() => _GestionProductosScreenState();
}

class _GestionProductosScreenState extends State<GestionProductosScreen> {
  final FirebaseAgent _agent = FirebaseAgent();
  
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();
  
  String? _editingId;

  void _guardarProducto() async {
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text) ?? 0.0;
    final stock = int.tryParse(_stockCtrl.text) ?? 0;

    if (nombre.isEmpty) return;

    final producto = Producto(
      id: _editingId ?? '',
      nombre: nombre,
      precio: precio,
      stock: stock,
    );

    if (_editingId == null) {
      await _agent.crearProducto(producto);
    } else {
      await _agent.actualizarProducto(producto);
      _editingId = null;
    }

    _nombreCtrl.clear();
    _precioCtrl.clear();
    _stockCtrl.clear();
    setState(() {});
  }

  void _editarProducto(Producto p) {
    _editingId = p.id;
    _nombreCtrl.text = p.nombre;
    _precioCtrl.text = p.precio.toString();
    _stockCtrl.text = p.stock.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EB), // Crema suave
      appBar: AppBar(
        title: const Text('Inventario', style: TextStyle(color: Colors.black87)),
        backgroundColor: const Color(0xFFF7C02F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Formulario Superior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nombreCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Producto',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _precioCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Precio',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _stockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _guardarProducto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7C02F), // Amarillo
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        _editingId == null ? 'Agregar Producto' : 'Actualizar Producto',
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de Productos Inferior
          Expanded(
            child: StreamBuilder<List<Producto>>(
              stream: _agent.leerProductos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final productos = snapshot.data!;
                if (productos.isEmpty) {
                  return const Center(child: Text('No hay productos en inventario.'));
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final p = productos[index];
                    return Card(
                      color: const Color(0xFF4CAF50), // Verde
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          p.nombre, 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        subtitle: Text(
                          '\$${p.precio} - Stock: ${p.stock}', 
                          style: const TextStyle(color: Colors.white70)
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editarProducto(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _agent.borrarProducto(p.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
