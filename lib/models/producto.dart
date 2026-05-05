class Producto {
  final String id;
  final String nombre;
  final double precio;
  final int stock;
  final String departamento;
  final int descuento;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.departamento,
    required this.descuento,
  });

  factory Producto.fromMap(Map<String, dynamic> data, String documentId) {
    return Producto(
      id: documentId,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] ?? 0.0).toDouble(),
      stock: data['stock'] ?? 0,
      departamento: data['Departamento'] ?? '',
      descuento: data['Descuento'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'Departamento': departamento,
      'Descuento': descuento,
    };
  }
}
