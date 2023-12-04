import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:js_util' as js_util;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  js.JsObject? _instance; // Declare instance variable
  js.JsObject? _documentViewer; // Declare documentViewer variable
  js.JsObject? _annotationManager; // Declare annotationManager variable
  String _version = 'Show Version'; // Declare version variable
  List<String> _annotationChanges = []; // Declare annotation changes list

  @override
  Widget build(BuildContext context) {
    // Create a view type
    const String viewType = 'webviewer-iframe';
    // Register the view type
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) =>
          html.querySelector('#viewer') ?? html.Element.tag('viewer'),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WebViewer Demo'),
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: showWebViewer,
                    child: const Text('Show WebViewer (pdf1)'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () => loadNewDocument(
                        'https://firebasestorage.googleapis.com/v0/b/labour-link.appspot.com/o/docs%2Fb72UzZyXPdf2MZZfsiUnF3jRFMn1%2Fb72UzZyXPdf2MZZfsiUnF3jRFMn12023-11-20%2014%3A54%3A46.414%2FT.211.1558.11.301%20Architect%20Plot%2011%20floor%20plans%20(rev%20J).pdf?alt=media&token=d0724641-26cc-48fa-98cc-11fb172cf9bf'),
                    child: const Text('Show pdf2'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () => loadNewDocument('document.pdf'),
                    child: const Text('Show pdf3'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed:
                        showVersion, // Call showVersion without arguments
                    child: Text(_version), // Use _version as button text
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: _annotationChanges.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_annotationChanges[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: HtmlElementView(viewType: viewType),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showWebViewer() {
    if (_instance == null) {
      var viewerElement = html.querySelector('#viewer');
      viewerElement!.style.display = 'block';

      js.context['WebViewer']['WebComponent'].apply([
        js.JsObject.jsify({
          'path': 'assets/apryse_lib',
          'licenseKey':
              'demo:1701188789873:7caa6e08030000000081ca891f3759a6d34f2f8b9631cbb769af02ec8c',
          'initialDoc':
              'https://pdftron.s3.amazonaws.com/downloads/pl/webviewer-demo.pdf',
        }),
        viewerElement,
      ]).callMethod('then', [
        (instance) {
          _instance = instance;
          _documentViewer = instance['Core']
              ['documentViewer']; // Store documentViewer in _documentViewer
          _annotationManager = instance['Core']['annotationManager'];

          _documentViewer!.callMethod('addEventListener', [
            'documentLoaded',
            () {
              // call methods relating to the loaded document
            }
          ]);

          _annotationManager!.callMethod('addEventListener', [
            'annotationChanged',
            (annotations, action, info) {
              setState(() {
                _annotationChanges.add('Annotations changed: $annotations');
                _annotationChanges.add('Action: $action');
                _annotationChanges.add('Info: $info');
              });
            }
          ]);
        },
      ]);
    }else{
      if (kDebugMode) {
        print('instance already exists');
      }
    }
  }

  void showVersion() {
    if (_instance != null) {
      var version = _instance!['Core'].callMethod('getVersion');
      setState(() {
        _version = 'WebViewer version: $version'; // Update _version
      });
    } else {
      if (kDebugMode) {
        print('instance is null');
      }
    }
  }

  void loadNewDocument(String url) {
    if (_instance != null) {
      _documentViewer!.callMethod('loadDocument', [url]);
    } else {
      if (kDebugMode) {
        print('instance is null');
      }
    }
  }
}
