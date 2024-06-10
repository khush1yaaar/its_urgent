import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

PinTheme pinputPinTheme(BuildContext context) {
  return PinTheme(
    width: 60,
    height: 64,
    textStyle: Theme.of(context).textTheme.bodyLarge,
    decoration: const BoxDecoration(),
  );
}

// Column pinputCursor(BuildContext context) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       Container(
//         width: 56,
//         height: 3,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     ],
//   );
// }

// Column pinputPreFilledWidget() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       Container(
//         width: 56,
//         height: 3,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     ],
//   );
// }
