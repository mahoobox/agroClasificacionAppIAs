import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../helper/image_classification_helper.dart';

import 'package:image_classification_mobilenet/ui/consultas_api.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile>? _selectedImages;
  List<img.Image>? _processedImages;
  Map<String, double>? _combinedClassificationResults;
  ImageClassificationHelper? _imageClassificationHelper;

  @override
  void initState() {
    super.initState();
    _imageClassificationHelper = ImageClassificationHelper();
    _imageClassificationHelper!.initHelper();
  }

  Future<void> _processAndClassifyImages() async {
    if (_selectedImages != null) {
      _processedImages = (await Future.wait(_selectedImages!.map((xFile) async {
        final imageData = await xFile.readAsBytes();
        return img.decodeImage(imageData);
      }).toList()))
          .whereType<img.Image>()
          .toList();

      if (_processedImages!.isNotEmpty) {
        _combinedClassificationResults = await _imageClassificationHelper!
            .inferenceImages(_processedImages!.whereType<img.Image>().toList());
        setState(() {});
      }
    }
  }

  Future<void> _pickImages() async {
    _selectedImages = await _imagePicker.pickMultiImage();
    if (_selectedImages != null && _selectedImages!.isNotEmpty) {
      await _processAndClassifyImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                "Por favor seleccione las imágenes para realizar el análisis",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text("Seleccionar Imágenes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 127, 0, 71), // Aplicar el color principal aquí
              ),
            ),
            if (_combinedClassificationResults != null) ...[
              Builder(builder: (context) {
                var sortedEntries =
                    _combinedClassificationResults!.entries.toList();
                sortedEntries.sort((a, b) => b.value.compareTo(a.value));
                return Expanded(
                  child: ListView(
                    children: sortedEntries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        trailing: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Importante para evitar overflow
                          children: [
                            Text("${entry.value.toStringAsFixed(2)}"),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                // Navegar a ConsultasAPI con el valor seleccionado
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConsultasAPI(valor: entry.key),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Opcional: Puedes manejar un tap en el ListTile completo si deseas
                        },
                      );
                    }).toList(),
                  ),
                ); // Se cierra el ListView.builder
              }), // Se cierra el Builder
            ] // Se cierra el if
          ], // Se cierra el Column
        ), // Se cierra el Scaffold
      ), // Se cierra el SafeArea
    ); // Se cierra el Widget build
  } // Fin de la Selección

  @override
  void dispose() {
    _imageClassificationHelper?.close();
    super.dispose();
  }
}
