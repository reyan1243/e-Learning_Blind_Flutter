
import 'package:speech_to_text/speech_to_text.dart' as stt;


// class Speech_Recognition{
//
//   _tts(String message) {
//     tt_speech.setRate(rate);
//     tt_speech.speak(message);
//   }
//
//
//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) => print('onStatus: $val'),
//         onError: (val) => {print('onError: $val')},
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (val) => setState(() {
//             _text = val.recognizedWords;
//             // if (val.hasConfidenceRating && val.confidence > 0) {
//             //   _confidence = val.confidence;
//             // }
//           }),
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//
//
// }