import 'package:flutter/material.dart';
import 'package:proyecto5/models/respuestas.dart';
import 'package:proyecto5/models/textoVacio.dart';
import 'resultados.dart';
import 'dart:math';
import 'dart:async';
import '/db/database_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RotatingImage(),
    );
  }
}

class RotatingImage extends StatefulWidget {
  const RotatingImage({super.key});

  @override
  _RotatingImageState createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController textFieldController = TextEditingController();
  String texto = '8';
  double tamanoFuente = 80.0;
  bool botonHabilitado = true;
  Color color = Colors.black;
  final dbHelper = DatabaseHelper();

  List<TextoVacio> listaTextoVacio = [
    TextoVacio('Espero por tu pregunta...'),
    TextoVacio('Haz una pregunta...'),
    TextoVacio('mmmm... y la pregunta?'),
    TextoVacio('Ingresa una pregunta'),
    TextoVacio('o.O y la pregunta?'),
    TextoVacio('no tienes nada que preguntar?')
  ];

  void obtenerRespuestaAleatoria() async {
    String pregunta = textFieldController.text;

    if (pregunta.isEmpty) {
      Random random = Random();
      int seleccionPreguntaVacia = random.nextInt(listaTextoVacio.length);

      setState(() {
        botonHabilitado = false;
        tamanoFuente = 15.0;
        color = Colors.red;
        texto = listaTextoVacio[seleccionPreguntaVacia].texto;
      });
    } else {
      try {
        List<Respuesta> respuestas = await dbHelper.getRespuestas();
        if (respuestas.isNotEmpty) {
          Random random = Random();
          int indiceAleatorio = random.nextInt(respuestas.length);
          setState(() {
            botonHabilitado = false;
            tamanoFuente = 15.0;
            color = Colors.green;
            texto = respuestas[indiceAleatorio].texto;
          });
        } else {
          setState(() {
            botonHabilitado = false;
            tamanoFuente = 15.0;
            texto = 'No hay respuestas creadas';
          });
        }
      } catch (error) {
        setState(() {
          botonHabilitado = false;
          tamanoFuente = 15.0;
          texto = 'Error al obtener respuestas';
        });
      }
    }

    Timer(const Duration(seconds: 3), () {
      setState(() {
        tamanoFuente = 80.0;
        texto = '8';
        color = Colors.black;
        botonHabilitado = true;
        textFieldController.clear();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/Fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            GestureDetector(
              onDoubleTap: botonHabilitado ? obtenerRespuestaAleatoria : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        child: const CircleAvatar(
                          radius: 150,
                          backgroundImage:
                              AssetImage('assets/imagen/Bola 8 sin 8.png'),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 125),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        texto,
                        style: TextStyle(
                          fontSize: tamanoFuente,
                          color: color,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  labelText: 'Haz una pregunta',
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 30,
            ),
            SizedBox(
              width: 120.0,
              height: 120.0,
              child: ElevatedButton(
                onPressed: botonHabilitado ? obtenerRespuestaAleatoria : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 241, 247),
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  'Enviar Pregunta',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResultadosPage()),
                  );
                },
                child: const Text('Agregar Respuestas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
