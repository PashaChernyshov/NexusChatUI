import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'contact.dart';
import 'contact_info_popup.dart';

class ContactTile extends StatefulWidget {
  final Contact contact;

  const ContactTile({super.key, required this.contact});

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool _isHovered = false;
  bool _isAvatarHovered = false;

  void _openContactInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ContactInfoPopup(contact: widget.contact),
    );
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: widget.contact.name,
          lastMessage: widget.contact.lastMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          onTap: () => _openChat(context),
          leading: MouseRegion(
            onEnter: (_) => setState(() => _isAvatarHovered = true),
            onExit: (_) => setState(() => _isAvatarHovered = false),
            child: GestureDetector(
              onTap: () => _openContactInfo(context),
              child: AnimatedScale(
                scale: _isAvatarHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.contact.avatarUrl),
                ),
              ),
            ),
          ),
          title: Text(
            widget.contact.name,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${widget.contact.lastMessage} • ${widget.contact.time}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
