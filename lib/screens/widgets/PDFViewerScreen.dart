import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final String resumeLink;
  
  PDFViewerScreen({Key? key, required this.resumeLink}) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(
                widget.resumeLink));
  }

}