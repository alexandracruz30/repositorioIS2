class Producto {
  final int? id;
  final String? nombre;
  final String? descripcion;

  Producto({this.id, this.nombre, this.descripcion});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      descripcion: json['descripcion'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
      };
}
