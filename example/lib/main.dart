import 'package:ahkas_database_utils/ahkas_database_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> users = [];
  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    await AhkasSqlite.getInstance().ensureInitialize(databaseName: 'ahkas_database_util');
    await queryAllData();
  }

  Future<void> queryAllData() async {
    final result = await AhkasSqlite.getInstance().database.query('users');
    setState(() {
      users.clear();
      users.addAll(result);
    });
  }

  Future<void> insertData() async {
    await AhkasSqlite.getInstance().database.insert('users', {
      'name': 'Sopheak - ${users.length}',
      'phone': '0968590557',
      'email': 'dev.nhorsopheak@gmail.com',
      'user_name': 'sopheak',
      'password': '123',
      'active': 1,
    });
    await queryAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ahkas Database Util')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => Text(users.elementAt(index)['name']),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: insertData,
        child: const Icon(Icons.add),
      ),
    );
  }
}
