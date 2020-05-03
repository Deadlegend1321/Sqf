import 'package:flutter/material.dart';
import 'package:sqf/models/user.dart';
import 'package:sqf/utils/database_helper.dart';

List _users;
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  var db = new DatabaseHelper();
  await db.saveuser(new User("sfsf", "fgfg"));

  int count = await db.getCount();
  print("Count: $count");

  User ana = await db.getUser(1);
  User anaUpdated = User.fromMap({
    "username": "UpdatedAna",
    "password" : "updatedPassword",
    "id"       : 1
  });
  await
  db.updateUser(anaUpdated);
  int userDeleted = await db.deleteUser(2);
  print("Delete User:  $userDeleted");

  _users = await db.getAllUsers();
  for(int i=0;i<_users.length;i++)
    {
      User user = User.map(_users[i]);
      print("Username: ${user.username}");
    }
  runApp(new MaterialApp(
    title: "Database",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: new ListView.builder(
          itemCount: _users.length,
          itemBuilder: (_, int position) {
            return new Card(
              color: Colors.white,
              elevation: 2.0,
              child: new ListTile(
                leading: new CircleAvatar(
                  child:  Text("${User.fromMap(_users[position]).username.substring(0, 1)}"),
                ),
                title: new Text("User: ${User.fromMap(_users[position]).username}"),
                subtitle: new Text("Id: ${User.fromMap(_users[position]).id}"),

                onTap: () => debugPrint("${User.fromMap(_users[position]).password}"),
              ),
            );


          }),

    );
  }
}
