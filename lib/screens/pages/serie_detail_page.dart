// // lib/pages/serie_detail_page.dart

// import 'package:boton/models/sampling_serie_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'mold_detail_page.dart'; // صفحه‌ای که در مرحله ۱ ساختیم

// class SerieDetailPage extends StatelessWidget {
//   final SamplingSerie serie;
//   final String sampleCategory;

//   const SerieDetailPage({
//     super.key,
//     required this.serie,
//     required this.sampleCategory,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('قالب‌ها: $sampleCategory')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         itemCount: serie.molds.length,
//         itemBuilder: (context, index) {
//           final mold = serie.molds[index];
//           return Card(
//             child: ListTile(
//               leading: CircleAvatar(child: Text(mold.ageInDays.toString())),
//               title: Text('قالب: ${mold.sampleIdentifier}'),
//               subtitle: Text(
//                 'ددلاین: ${DateFormat('yyyy/MM/dd').format(mold.deadline)}',
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 // ✅ با کلیک روی هر قالب، به صفحه جزئیات آن می‌رویم
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MoldDetailPage(mold: mold),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
