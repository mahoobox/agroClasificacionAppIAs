# Clasificación de Imagenes MobileNet

Aplicación Flutter que integra modelo TensorFlow en local para identificación de plagas y enfermedades de plantas.

## Supported platforms

|      | Android | iOS | Linux                                                 | Mac                                                   | Windows                                               | Web |
| ---- | ------- | --- | ----------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- | --- |
| file | ✅      | ✅  | ✅                                                    | ✅                                                    | ✅                                                    |     |
| life | ✅      | ✅  | [🚧](https://github.com/flutter/flutter/issues/41710) | [🚧](https://github.com/flutter/flutter/issues/41708) | [🚧](https://github.com/flutter/flutter/issues/41709) |     |


# Estructura 

```
└── 📁assets
    └── 📁images
            └── logo.png
    └── 📁models
            └── labels.txt
            └── modelo_clasificacion_uint8.tflite
└── 📁lib
    └── 📁helper
        └── image_classification_helper.dart
        └── isolate_inference.dart
    └── image_utils.dart
    └── main.dart
    └── 📁ui
        └── camera.dart
        └── consultas_api.dart
        └── gallery.dart
└── README.md
└── makefile
└── pubspec.lock
└── pubspec.yaml
```
