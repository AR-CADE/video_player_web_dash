class NoScriptTagException implements Exception {
  @override
  String toString() =>
      'Did you add   <script src="http://cdn.dashjs.org/latest/dash.all.min.js"  type="application/javascript"></script> in index.html? ';
}
