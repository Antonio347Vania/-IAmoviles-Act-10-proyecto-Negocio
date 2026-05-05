class Empleado {
  final int id;
  final String nombre;
  final String puesto;
  final double salario;

  Empleado({
    required this.id,
    required this.nombre,
    required this.puesto,
    required this.salario,
  });
}

// Nuestra base de datos local (Diccionario)
Map<int, Empleado> datosEmpleado = {};
int contadorId = 1;
