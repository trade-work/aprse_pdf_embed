import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a view type
    final String viewType = 'webviewer-iframe';
    // Register the view type
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => html.querySelector('viewer'),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WebViewer Demo'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: showWebViewer,
              child: const Text('Show WebViewer'),
            ),
            Expanded(
              child: HtmlElementView(viewType: viewType),
            ),
          ],
        ),
      ),
    );
  }

  void showWebViewer() {
    var viewerElement = html.querySelector('viewer');
    viewerElement!.style.display = 'block';
    js.context.callMethod('WebViewer', [
      js.JsObject.jsify({
        'enableMeasurement': true,
        'path': 'assets/apryse_lib',
        'licenseKey':
            'demo:1701188789873:7caa6e08030000000081ca891f3759a6d34f2f8b9631cbb769af02ec8c',
        'initialDoc': 'document.pdf',
      }),
      viewerElement,
    ]);
  }
}
