import 'package:flutter/material.dart';
import 'package:healthyfoodscan/api_handler.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.text});
  final String text;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String _definition = ''; // Variable para almacenar la definición obtenida
  final ApiHandler _apiHandler = ApiHandler();

  // Método para buscar la definición en la API
  Future<void> _fetchDefinition(String text) async {
    print('Fetching definition for: $text');
    final producto = await _apiHandler.getProductoData(text);

    setState(() {
      if (producto != null) {
        print('Product found: ${producto.descripcion}');
        _definition = producto.descripcion ?? 'Definición no encontrada';
      } else {
        print('Product not found');
        _definition = 'Definición no encontrada';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              widget.text,
              style: const TextStyle(
                  fontSize: 18.0), // Tamaño de la fuente ajustable
              onTap: () {
                // Aquí puedes hacer lo que necesites al tocar el texto
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Texto seleccionado'),
                      content: Text('Texto: ${widget.text}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchDefinition(widget.text);
              },
              child: const Text('Buscar Aditivo'),
            ),
            const SizedBox(height: 20),
            if (_definition.isNotEmpty)
              Text(
                'Definición: $_definition',
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            if (_definition.isEmpty)
              const Text(
                'Definición no encontrada',
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
