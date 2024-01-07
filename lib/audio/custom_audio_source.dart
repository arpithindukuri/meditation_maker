// Feed your own stream of bytes into the player
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class SpeakAudioSource extends StreamAudioSource {
  final List<int> bytes;
  SpeakAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    var start = 0;
    var end = bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class PauseAudioSource extends StreamAudioSource {
  late final Uint8List _header;
  late final int _trackLength;
  late final int _streamLength;

  PauseAudioSource({required Duration duration, super.tag})
      : _header = _createWavHeader(duration),
        _trackLength = _calculateByteLength(duration) {
    _streamLength = _trackLength + _header.length;
  }

  /// Creates a WAV file header.
  static Uint8List _createWavHeader(Duration duration) {
    int sampleRate = 44100;
    int channels = 2;
    int bitsPerSample = 16;

    int subchunk2Size =
        duration.inSeconds * sampleRate * channels * (bitsPerSample ~/ 8);
    int chunkSize = 36 + subchunk2Size;

    var header = Uint8List(44);
    var writer = ByteData.sublistView(header);

    // RIFF header
    writer.setUint32(0, 0x46464952, Endian.little); // "RIFF"
    writer.setUint32(4, chunkSize, Endian.little);
    writer.setUint32(8, 0x45564157, Endian.little); // "WAVE"

    // Subchunk1 (format)
    writer.setUint32(12, 0x20746D66, Endian.little); // "fmt "
    writer.setUint32(16, 16, Endian.little); // Subchunk1 size
    writer.setUint16(20, 1, Endian.little); // PCM format
    writer.setUint16(22, channels, Endian.little);
    writer.setUint32(24, sampleRate, Endian.little);
    writer.setUint32(
        28, sampleRate * channels * (bitsPerSample ~/ 8), Endian.little);
    writer.setUint16(32, channels * (bitsPerSample ~/ 8), Endian.little);
    writer.setUint16(34, bitsPerSample, Endian.little);

    // Subchunk2 (data)
    writer.setUint32(36, 0x61746164, Endian.little); // "data"
    writer.setUint32(40, subchunk2Size, Endian.little);
    return header;
  }

  /// Calculates the byte-length of a silent track of [duration].
  static int _calculateByteLength(Duration duration) {
    int sampleRate = 44100;
    int channels = 2;
    int bitsPerSample = 16;

    return duration.inSeconds * sampleRate * channels * (bitsPerSample ~/ 8);
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _streamLength;

    // SparseList is a custom implementation of a List that avoids storing
    // all its data in memory
    // final bytes = SparseList<int>(end - start, 0);
    final bytes = List<int>.filled(end - start, 0);

    if (start < _header.length) {
      bytes.setRange(
        start,
        _header.length,
        _header.sublist(start, _header.length),
      );
    }

    return StreamAudioResponse(
      sourceLength: _streamLength,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes),
      contentType: 'audio/wav',
    );
  }
}
