import 'package:flutter/material.dart';
import 'contact.dart'; // Убедитесь, что модель контакта импортирована
import 'contact_tile.dart'; // Импортируем виджет для отображения контакта

class ContactListScreen extends StatelessWidget {
  final List<Contact> contacts;

  const ContactListScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    // Групируем контакты по первой букве
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.name[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Сортируем ключи, чтобы отобразить буквы в алфавитном порядке
    List<String> sortedKeys = groupedContacts.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
      ),
      body: ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          String letter = sortedKeys[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Отображаем контакты для данной буквы
              ...groupedContacts[letter]!.map((contact) {
                return ContactTile(
                  contact: contact,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
