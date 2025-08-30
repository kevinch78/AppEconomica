// import 'package:clean_architecture/domain/entities/user.dart';
// import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
// import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
// import 'package:clean_architecture/presentation/bloc/user/user_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uuid/uuid.dart';

// class UserListPage extends StatelessWidget {
//   const UserListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Gestión de Usuarios"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocBuilder<UserBloc, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is UserError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Error: ${state.message}",
//                     style: const TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (state is UserLoaded) {
//             if (state.users.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.people_outline, size: 64, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text(
//                       "No hay usuarios registrados",
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Presiona + para agregar un usuario",
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 final user = state.users[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.yellow,
//                       child: Text(
//                         user.name.isNotEmpty ? user.name[0].toUpperCase() : "U",
//                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     title: Text(
//                       user.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Ingreso mensual: \$${user.monthlyIncome.toStringAsFixed(2)}"),
//                         Text("Meta de ahorro: \$${user.savingsGoal.toStringAsFixed(2)}"),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         _showDeleteConfirmation(context, user);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.people, size: 64, color: Colors.blue),
//                 SizedBox(height: 16),
//                 Text(
//                   "Presiona + para agregar un usuario",
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Crear un usuario con datos fijos para probar
//           final user = User(
//             id: const Uuid().v4(),
//             name: "Usuario Test ${DateTime.now().millisecondsSinceEpoch}",
//             monthlyIncome: 1500.0,
//             savingsGoal: 500.0,
//           );
          
//           print('UserListPage: Dispatching AddUser event for: ${user.name}');
//           context.read<UserBloc>().add(AddUser(user));
//         },
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context, User user) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Confirmar eliminación"),
//           content: Text("¿Estás seguro de que quieres eliminar a ${user.name}?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancelar"),
//             ),
//             TextButton(
//               onPressed: () {
//                 context.read<UserBloc>().add(DeleteUserEvent(user.id));
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddUserDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final incomeController = TextEditingController();
//     final goalController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Agregar Usuario"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                     labelText: "Nombre",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: incomeController,
//                   decoration: const InputDecoration(
//                     labelText: "Ingreso Mensual (\$)",
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: goalController,
//                   decoration: const InputDecoration(
//                     labelText: "Meta de Ahorro (\$)",
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancelar"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final name = nameController.text.trim();
//                 final income = double.tryParse(incomeController.text) ?? 0.0;
//                 final goal = double.tryParse(goalController.text) ?? 0.0;

//                 if (name.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("El nombre es obligatorio")),
//                   );
//                   return;
//                 }

//                 if (income < 0 || goal < 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Los valores no pueden ser negativos")),
//                   );
//                   return;
//                 }

//                 final user = User(
//                   id: const Uuid().v4(),
//                   name: name,
//                   monthlyIncome: income,
//                   savingsGoal: goal,
//                 );

//                 print('UserListPage: Dispatching AddUser event for: ${user.name}');
//                 context.read<UserBloc>().add(AddUser(user));
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Agregar"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
