class Empleado {
  final String id;
  final String nombre;
  final String puesto;
  final double salario;

  Empleado({
    required this.id,
    required this.nombre,
    required this.puesto,
    required this.salario,
  });

  factory Empleado.fromMap(Map<String, dynamic> data, String documentId) {
    return Empleado(
      id: documentId,
      nombre: data['nombre'] ?? '',
      puesto: data['puesto'] ?? '',
      salario: (data['salario'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'puesto': puesto,
      'salario': salario,
    };
  }
}
