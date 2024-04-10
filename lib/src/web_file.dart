import 'dart:async';
import 'dart:typed_data';

/// A reference to a file obtained from web browser
abstract class WebFile {
  // Creates a new instance of the WebFile class
  WebFile(Object file);

  /// File name
  String get name;

  /// File size in bytes
  int get size;

  /// File mime type
  String get type;

  /// The last modified date
  DateTime get lastModifiedDate;

  /// Read date as bytes
  Future<Uint8List> readAsBytes();

  /// Open file stream
  Future<Stream<List<int>>> openRead();
}
