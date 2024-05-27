class Respuesta {
  int? id;
  String texto;

  Respuesta({this.id, required this.texto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
    };
  }
}



// List<Respuestas> respuestasBola8 = [
  //   Respuesta(1,'Sí, definitivamente.'),
  //   Respuesta(2,'Es cierto.'),
  //   Respuesta(3,'Es decididamente así.'),
  //   Respuesta('Sin duda.'),
  //   Respuesta('Sí, absolutamente.'),
  //   Respuesta('Puedes confiar en ello.'),
  //   Respuesta('Como yo lo veo, sí.'),
  //   Respuesta('Más probablemente sí que no.'),
  //   Respuestas('Las señales apuntan a sí.'),
  //   Respuestas('Respuesta borrosa, intenta de nuevo.'),
  //   Respuestas('Pregunta de nuevo más tarde.'),
  //   Respuestas('Mejor no decirte ahora.'),
  //   Respuestas('No se puede predecir ahora.'),
  //   Respuestas('Concéntrate y pregunta de nuevo.'),
  //   Respuestas('No cuentes con ello.'),
  //   Respuestas('Mi respuesta es no.'),
  //   Respuestas('Mis fuentes dicen que no.'),
  //   Respuestas('Muy dudoso.'),
  //   Respuestas('No cuentes con eso.'),
  //   Respuestas('Definitivamente no.'),
  // ];