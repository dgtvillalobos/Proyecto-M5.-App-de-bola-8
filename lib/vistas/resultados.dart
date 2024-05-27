import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/respuestas.dart';

class ResultadosPage extends StatefulWidget {
  const ResultadosPage({super.key});

  @override
  State<ResultadosPage> createState() => _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {
  final TextEditingController _controller = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _addRespuesta() async {
    if (_controller.text.isNotEmpty) {
      await _dbHelper.insertRespuesta(Respuesta(texto: _controller.text));
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistencia Local'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/Fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Ingresa una Respuesta',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addRespuesta,
              child: const Text('Agregar Respuesta Escrita'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().addRespuestasAutomaticas();
                setState(() {});
              },
              child: const Text('Agregar Respuestas Automáticas'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().deleteAllRespuestas();
                setState(() {});
              },
              child: const Text('Eliminar Todas las Respuestas'),
            ),
            Expanded(
              child: FutureBuilder<List<Respuesta>>(
                future: _dbHelper.getRespuestas(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final respuestas = snapshot.data!;
                  return ListView.builder(
                    itemCount: respuestas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(respuestas[index].texto),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
