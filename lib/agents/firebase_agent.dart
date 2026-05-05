import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/producto.dart';
import '../models/empleado.dart';

class FirebaseAgent {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- CRUD para Productos (Colección: articulos) ---

  Future<void> crearProducto(Producto producto) async {
    await _firestore.collection('articulos').add(producto.toMap());
  }

  Stream<List<Producto>> leerProductos() {
    return _firestore.collection('articulos').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Producto.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> actualizarProducto(Producto producto) async {
    await _firestore.collection('articulos').doc(producto.id).update(producto.toMap());
  }

  Future<void> borrarProducto(String id) async {
    await _firestore.collection('articulos').doc(id).delete();
  }

  // --- CRUD para Empleados (Colección: empleados) ---

  Future<void> crearEmpleado(Empleado empleado) async {
    await _firestore.collection('empleados').add(empleado.toMap());
  }

  Stream<List<Empleado>> leerEmpleados() {
    return _firestore.collection('empleados').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Empleado.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> actualizarEmpleado(Empleado empleado) async {
    await _firestore.collection('empleados').doc(empleado.id).update(empleado.toMap());
  }

  Future<void> borrarEmpleado(String id) async {
    await _firestore.collection('empleados').doc(id).delete();
  }
}flutter doctor
