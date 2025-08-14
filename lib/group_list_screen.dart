import 'package:flutter/material.dart';
import 'contact.dart';
import 'group_creation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Group {
  final String name;
  final String lastMessage;
  final String time;
  final List<Contact> members;

  Group({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastMessage': lastMessage,
        'time': time,
        'members': members
            .map((e) => {
                  'name': e.name,
                  'lastMessage': e.lastMessage,
                  'time': e.time,
                  'avatarUrl': e.avatarUrl,
                })
            .toList(),
      };

  static Group fromJson(Map<String, dynamic> json) {
    var membersJson = json['members'] as List;
    List<Contact> membersList = membersJson
        .map((i) => Contact(
              name: i['name'],
              lastMessage: i['lastMessage'],
              time: i['time'],
              avatarUrl: i['avatarUrl'],
            ))
        .toList();

    return Group(
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      time: json['time'] as String,
      members: membersList,
    );
  }
}

class GroupListScreen extends StatefulWidget {
  final List<Contact> contacts;

  const GroupListScreen({super.key, required this.contacts});

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final String? groupsString = prefs.getString('groups');
    if (groupsString != null) {
      List<dynamic> jsonResponse = json.decode(groupsString);
      setState(() {
        groups =
            jsonResponse.map((groupJson) => Group.fromJson(groupJson)).toList();
      });
    }
  }

  Future<void> _saveGroups() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> groupStrings =
        groups.map((group) => json.encode(group.toJson())).toList();
    prefs.setString('groups', json.encode(groupStrings));
  }

  void _addGroup(String name, List<Contact> members) {
    final newGroup = Group(
      name: name,
      lastMessage: 'Создана новая группа',
      time: DateTime.now().toString(),
      members: members,
    );
    setState(() {
      groups.add(newGroup);
      _saveGroups(); // Сохраняем группы после добавления
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GroupCreationScreen(
                    contacts: widget.contacts,
                    onGroupCreated: _addGroup,
                  );
                },
              );
            },
            child: const Text('Создать группу'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  title: Text(group.name),
                  subtitle: Text('${group.lastMessage} • ${group.time}'),
                  onTap: () {
                    // Логика для взаимодействия с группой может быть добавлена здесь
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
