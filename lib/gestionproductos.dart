import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GestionProductos extends StatefulWidget {
  const GestionProductos({super.key});

  @override
  State<GestionProductos> createState() => _GestionProductosState();
}

class _GestionProductosState extends State<GestionProductos> {
  final _col = FirebaseFirestore.instance.collection('articulos');

  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _editandoId;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _deptCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _limpiar() {
    _nombreCtrl.clear();
    _precioCtrl.clear();
    _stockCtrl.clear();
    _deptCtrl.clear();
    _descCtrl.clear();
    setState(() => _editandoId = null);
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 0;
    final departamento = _deptCtrl.text.trim();
    final descuento = int.tryParse(_descCtrl.text.trim()) ?? 0;
    if (nombre.isEmpty) {
      _snack('El nombre es obligatorio', Colors.redAccent);
      return;
    }
    final datos = {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'Departamento': departamento,
      'Descuento': descuento,
    };
    if (_editandoId == null) {
      await _col.add(datos);
      _snack('Artículo agregado ✔', const Color(0xFFF7C02F));
    } else {
      await _col.doc(_editandoId).update(datos);
      _snack('Artículo actualizado ✔', Colors.orange);
    }
    _limpiar();
  }

  void _cargarEdicion(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    _nombreCtrl.text = d['nombre'] ?? '';
    _precioCtrl.text = (d['precio'] ?? 0.0).toString();
    _stockCtrl.text = (d['stock'] ?? 0).toString();
    _deptCtrl.text = d['Departamento'] ?? '';
    _descCtrl.text = (d['Descuento'] ?? 0).toString();
    setState(() => _editandoId = doc.id);
  }

  Future<void> _eliminar(String id, String nombre) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Eliminar artículo?'),
        content: Text('Se eliminará permanentemente "$nombre".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _col.doc(id).delete();
      _snack('Artículo eliminado', Colors.redAccent);
    }
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.black87)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7C02F),
        title: const Text('Inventario de Artículos',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Formulario ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editandoId == null ? 'Agregar Artículo' : 'Editar Artículo',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  // Fila 1: Nombre y Departamento
                  Row(
                    children: [
                      Expanded(child: _campo(_nombreCtrl, 'Nombre', Icons.inventory_2)),
                      const SizedBox(width: 12),
                      Expanded(child: _campo(_deptCtrl, 'Departamento', Icons.category)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Fila 2: Precio, Stock, Descuento
                  Row(
                    children: [
                      Expanded(child: _campo(_precioCtrl, 'Precio \$', Icons.attach_money, tipo: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _campo(_stockCtrl, 'Stock', Icons.production_quantity_limits, tipo: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _campo(_descCtrl, 'Desc. %', Icons.percent, tipo: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _guardar,
                          icon: Icon(_editandoId == null ? Icons.add : Icons.save, size: 18),
                          label: Text(_editandoId == null ? 'Agregar' : 'Actualizar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7C02F),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      if (_editandoId != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _limpiar,
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancelar'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Tabla en tiempo real ─────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _col.orderBy('nombre').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No hay artículos en inventario.'));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF7C02F)),
                          headingTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                          border: TableBorder(
                            horizontalInside: BorderSide(color: Colors.grey.shade200),
                          ),
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Artículo')),
                            DataColumn(label: Text('Precio')),
                            DataColumn(label: Text('Stock')),
                            DataColumn(label: Text('Departamento')),
                            DataColumn(label: Text('Desc. %')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: List.generate(docs.length, (i) {
                            final d = docs[i].data() as Map<String, dynamic>;
                            final stock = d['stock'] ?? 0;
                            final isEditing = _editandoId == docs[i].id;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (isEditing) return const Color(0xFFFFF9C4);
                                return i.isEven ? Colors.white : const Color(0xFFFFFDE7);
                              }),
                              cells: [
                                DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.grey))),
                                DataCell(Text(d['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text('\$${(d['precio'] ?? 0.0).toStringAsFixed(2)}')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: stock > 0
                                          ? const Color(0xFFE8F5E9)
                                          : const Color(0xFFFFEBEE),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '$stock',
                                      style: TextStyle(
                                        color: stock > 0 ? Colors.green.shade700 : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(d['Departamento'] ?? '-')),
                                DataCell(Text('${d['Descuento'] ?? 0}%')),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFFF57F17), size: 20),
                                      tooltip: 'Editar',
                                      onPressed: () => _cargarEdicion(docs[i]),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                      tooltip: 'Eliminar',
                                      onPressed: () => _eliminar(docs[i].id, d['nombre'] ?? ''),
                                    ),
                                  ],
                                )),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String label, IconData icono,
      {TextInputType tipo = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: Icon(icono, size: 20, color: const Color(0xFFF7C02F)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF7C02F), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
