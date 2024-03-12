import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultasAPI extends StatefulWidget {
  final String valor;

  const ConsultasAPI({Key? key, required this.valor}) : super(key: key);

  @override
  _ConsultasAPIState createState() => _ConsultasAPIState();
}

class _ConsultasAPIState extends State<ConsultasAPI> {
  // Inicializa _resultadoConsulta con un valor dinámico basado en widget.valor
  late String _resultadoConsulta;

  @override
  void initState() {
    super.initState();
    // Actualiza _resultadoConsulta para incluir el valor de widget.valor
    _resultadoConsulta =
        "Realizando consulta para: ${widget.valor}. Por favor espere...";
    // Llama a consultaChatGPT después de establecer el mensaje inicial
    consultaChatGPT(widget.valor);
  }

  Future<void> consultaChatGPT(String valorEnviado) async {
    final uri = Uri.parse("https://api.openai.com/v1/chat/completions");
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer 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", // Ojo Mauricio del Futuro
      },
      body: jsonEncode({
        //"model": "gpt-3.5-turbo",
        "model": "gpt-3.5-turbo-0125",
        "messages": [
          {"role": "system", "content": "Tú eres un asistente muy útil.."},
          {
            "role": "user",
            "content":
                "Eres experto veterinario. Da una muy corta descripción de la plaga/infección $valorEnviado en el ganado vacuno, su posible relación con la inapetencia y seguido en lista los pasos para resolver"
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _resultadoConsulta = responseData["choices"][0]["message"]["content"];
      });
    } else {
      setState(() {
        _resultadoConsulta =
            "Error al obtener respuesta: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Experto'),
        backgroundColor:
            const Color.fromARGB(255, 127, 0, 71), // Estilo original del AppBar
      ),
      body: SingleChildScrollView(
        // Añade SingleChildScrollView aquí
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _resultadoConsulta,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 33, 37, 41)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Retroceder a la pantalla anterior
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 127, 0, 71), // Color del botón
                  ),
                  child: Text('Volver'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          consultaChatGPT(widget.valor);
        },
        tooltip: 'Consultar',
        child: const Icon(Icons.send),
        backgroundColor: const Color.fromARGB(255, 127, 0, 71),
      ),
    );
  }
}
