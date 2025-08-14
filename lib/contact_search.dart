import 'package:flutter/material.dart';
import 'contact.dart';
import 'contact_tile.dart';

class ContactSearch extends SearchDelegate<Contact?> {
  final List<Contact> contacts;

  ContactSearch(this.contacts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children:
          results.map((contact) => ContactTile(contact: contact)).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children:
          suggestions.map((contact) => ContactTile(contact: contact)).toList(),
    );
  }
}
