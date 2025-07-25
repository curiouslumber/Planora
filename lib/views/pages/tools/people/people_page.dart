// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:planora/models/people_model.dart';
// import 'package:planora/utils/font_weights.dart';

// class PeoplePage extends StatelessWidget {
//   const PeoplePage({super.key, required this.people});

//   final PeopleModel people;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(people.name),
//         actions: [
//           IconButton(
//             onPressed:
//                 () => Navigator.popUntil(context, ModalRoute.withName('/')),
//             icon: Icon(CupertinoIcons.home),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 24,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     child: ClipOval(
//                       child:
//                           people.imageUrl.isNotEmpty
//                               ? Image.network(
//                                 people.imageUrl,
//                                 fit: BoxFit.cover,
//                               )
//                               : CircleAvatar(
//                                 radius: 50 / 2,
//                                 backgroundColor:
//                                     Theme.of(
//                                       context,
//                                     ).colorScheme.secondaryFixed,
//                                 child: Text(
//                                   people.name
//                                       .split(' ')
//                                       .map((name) => name[0])
//                                       .join(),
//                                   style: TextStyle(
//                                     color:
//                                         Theme.of(
//                                           context,
//                                         ).colorScheme.onSecondaryFixed,
//                                   ),
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     spacing: 4,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primary,
//                           foregroundColor:
//                               Theme.of(context).colorScheme.onPrimary,
//                         ),
//                         child: Text("Add to Event"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primary,
//                           foregroundColor:
//                               Theme.of(context).colorScheme.onPrimary,
//                         ),
//                         child: Text("Create Meeting"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primary,
//                           foregroundColor:
//                               Theme.of(context).colorScheme.onPrimary,
//                         ),
//                         child: Text("Edit Profile"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               spacing: 16,
//               children: [
//                 Text(
//                   'Recent Events',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 18,
//                     fontWeight: FontWeights.semiBold,
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 60.0,
//                   alignment: Alignment.center,
//                   child: Text(
//                     'None to show here...',
//                     style: TextStyle(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.onSurface.withAlpha(180),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               spacing: 16,
//               children: [
//                 Text(
//                   'Shared Notes',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 18,
//                     fontWeight: FontWeights.semiBold,
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 60.0,
//                   alignment: Alignment.center,
//                   child: Text(
//                     'None to show here...',
//                     style: TextStyle(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.onSurface.withAlpha(180),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
//           BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
//           BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Export'),
//         ],
//       ),
//     );
//   }
// }
