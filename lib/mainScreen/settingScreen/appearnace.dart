// import 'package:flutter/material.dart';
//
// import '../../utils/colors.dart';
//
// class Themes extends StatefulWidget {
//   const Themes({super.key});
//
//   @override
//   State<Themes> createState() => _ThemesState();
// }
//
// class _ThemesState extends State<Themes> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.PrimaryColor2,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.PrimaryColor1,
//         title: Text(
//           "Themes",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onLongPress: () {
//                     setState(() {
//                       AppColors.PrimaryColor1 = AppColors.defaultColor[0];
//                       AppColors.SecondaryColor2 = AppColors.defaultColor[1];
//                       AppColors.textDefault = AppColors.textColors[0];
//                     });
//                 },
//                 onPressed: () {
//                   setState(() {
//                     AppColors.PrimaryColor1 = AppColors.lavenderBlue[0];
//                     AppColors.textDefault = AppColors.textColors[1];
//                     AppColors.SecondaryColor2 = AppColors.lavenderBlue[1];
//                   });
//                 },
//                 child: Text("Lavender and Dark Blue"),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
