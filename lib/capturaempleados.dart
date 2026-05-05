import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CapturaEmpleados extends StatefulWidget {
  const CapturaEmpleados({super.key});

  @override
  State<CapturaEmpleados> createState() => _CapturaEmpleadosState();
}

class _CapturaEmpleadosState extends State<CapturaEmpleados> {
  // ✅ Colección con mayúscula para coincidir con Firebase Console
  final _col = FirebaseFirestore.instance.collection('Empleados');

  final _nombreCtrl    = TextEditingController();
  final _apellidoCtrl  = TextEditingController();
  final _puestoCtrl    = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _edadCtrl      = TextEditingController();
  final _numeroCtrl    = TextEditingController();
  String? _editandoId;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _puestoCtrl.dispose();
    _direccionCtrl.dispose();
    _edadCtrl.dispose();
    _numeroCtrl.dispose();
    super.dispose();
  }

  void _limpiar() {
    _nombreCtrl.clear();
    _apellidoCtrl.clear();
    _puestoCtrl.clear();
    _direccionCtrl.clear();
    _edadCtrl.clear();
    _numeroCtrl.clear();
    setState(() => _editandoId = null);
  }

  Future<void> _guardar() async {
    final nombre   = _nombreCtrl.text.trim();
    final apellido = _apellidoCtrl.text.trim();
    final puesto   = _puestoCtrl.text.trim();
    if (nombre.isEmpty || apellido.isEmpty) {
      _snack('Nombre y Apellido son obligatorios', Colors.redAccent);
      return;
    }
    // ✅ Campos con mayúscula igual que en Firebase Console
    final datos = {
      'Nombre':    nombre,
      'Apellido':  apellido,
      'Puesto':    _puestoCtrl.text.trim(),
      'Direccion': _direccionCtrl.text.trim(),
      'Edad':      int.tryParse(_edadCtrl.text.trim()) ?? 0,
      'Numero':    int.tryParse(_numeroCtrl.text.trim()) ?? 0,
    };
    if (_editandoId == null) {
      await _col.add(datos);
      _snack('Empleado agregado ✔', const Color(0xFF4CAF50));
    } else {
      await _col.doc(_editandoId).update(datos);
      _snack('Empleado actualizado ✔', Colors.orange);
    }
    _limpiar();
  }

  void _cargarEdicion(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    _nombreCtrl.text    = d['Nombre'] ?? '';
    _apellidoCtrl.text  = d['Apellido'] ?? '';
    _puestoCtrl.text    = d['Puesto'] ?? '';
    _direccionCtrl.text = d['Direccion'] ?? '';
    _edadCtrl.text      = (d['Edad'] ?? '').toString();
    _numeroCtrl.text    = (d['Numero'] ?? '').toString();
    setState(() => _editandoId = doc.id);
  }

  Future<void> _eliminar(String id, String nombre) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Eliminar empleado?'),
        content: Text('Se eliminará permanentemente a "$nombre".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
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
      _snack('Empleado eliminado', Colors.redAccent);
    }
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
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
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text('Nómina de Empleados',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Formulario ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editandoId == null ? 'Agregar Empleado' : 'Editar Empleado',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  // Fila 1: Nombre, Apellido, Puesto
                  Row(
                    children: [
                      Expanded(child: _campo(_nombreCtrl, 'Nombre', Icons.person)),
                      const SizedBox(width: 10),
                      Expanded(child: _campo(_apellidoCtrl, 'Apellido', Icons.person_outline)),
                      const SizedBox(width: 10),
                      Expanded(child: _campo(_puestoCtrl, 'Puesto', Icons.work)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Fila 2: Dirección, Edad, Número
                  Row(
                    children: [
                      Expanded(child: _campo(_direccionCtrl, 'Dirección', Icons.home)),
                      const SizedBox(width: 10),
                      Expanded(child: _campo(_edadCtrl, 'Edad', Icons.cake, tipo: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(child: _campo(_numeroCtrl, 'Teléfono', Icons.phone, tipo: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _guardar,
                        icon: Icon(_editandoId == null ? Icons.add : Icons.save, size: 18),
                        label: Text(_editandoId == null ? 'Agregar' : 'Actualizar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      if (_editandoId != null) ...[
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: _limpiar,
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Cancelar'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ],
                  )
                ],
              ),
            ),
          ),

          // ── Tabla en tiempo real ─────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _col.orderBy('Nombre').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('No hay empleados registrados.'));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFF4CAF50)),
                          headingTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          border: TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.grey.shade200),
                          ),
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido')),
                            DataColumn(label: Text('Puesto')),
                            DataColumn(label: Text('Dirección')),
                            DataColumn(label: Text('Edad')),
                            DataColumn(label: Text('Teléfono')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: List.generate(docs.length, (i) {
                            final d = docs[i].data() as Map<String, dynamic>;
                            final isEditing = _editandoId == docs[i].id;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                  (states) {
                                if (isEditing) return const Color(0xFFE8F5E9);
                                return i.isEven
                                    ? Colors.white
                                    : const Color(0xFFF9FBE7);
                              }),
                              cells: [
                                DataCell(Text('${i + 1}',
                                    style: const TextStyle(color: Colors.grey))),
                                DataCell(Text(d['Nombre'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600))),
                                DataCell(Text(d['Apellido'] ?? '')),
                                DataCell(Text(d['Puesto'] ?? '')),
                                DataCell(Text(d['Direccion'] ?? '')),
                                DataCell(Text('${d['Edad'] ?? ''}')),
                                DataCell(Text('${d['Numero'] ?? ''}')),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color(0xFF4CAF50), size: 20),
                                      tooltip: 'Editar',
                                      onPressed: () => _cargarEdicion(docs[i]),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent, size: 20),
                                      tooltip: 'Eliminar',
                                      onPressed: () => _eliminar(
                                          docs[i].id, d['Nombre'] ?? ''),
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
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        prefixIcon: Icon(icono, size: 20, color: const Color(0xFF4CAF50)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }
}
