

part of wemapgl;

class WeMapStream<T> {
  //Controller, Stream for control color of locate button
  StreamController<T> _streamController = new StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;

  T data;

  void dispose() {
    _streamController.close();
  }

  void increment([T value]) {
    this.data = value;
    value == null
        ? _streamController.sink.add(null)
        : _streamController.sink.add(value);
  }
}