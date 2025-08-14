import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String lastMessage;

  const ChatScreen({
    required this.userName,
    required this.lastMessage,
    super.key,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static final Map<String, List<Message>> _chatHistory = {};
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    if (widget.lastMessage.isNotEmpty) {
      _messages.add(Message(
        text: widget.lastMessage,
        sender: Sender.other,
      ));
    }
  }

  void _loadMessages() {
    setState(() {
      _messages.addAll(_chatHistory[widget.userName] ?? []);
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = Message(text: _controller.text, sender: Sender.me);
      setState(() {
        _messages.add(message);
        _chatHistory[widget.userName] = [
          ...?_chatHistory[widget.userName],
          message
        ];
        _controller.clear();
      });
    }
  }

  Future<void> _sendFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result != null) {
        final file = result.files.single;
        final isImage = file.extension?.toLowerCase().contains('jpg') == true ||
            file.extension?.toLowerCase().contains('png') == true ||
            file.extension?.toLowerCase().contains('jpeg') == true;

        final message = Message(
          sender: Sender.me,
          fileName: file.name,
          fileBytes: file.bytes,
          filePath: file.path,
          isImage: isImage,
        );

        setState(() {
          _messages.add(message);
          _chatHistory[widget.userName] = [
            ...?_chatHistory[widget.userName],
            message
          ];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при выборе файла: $e")),
      );
    }
  }

  void _showCallOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text("Позвонить"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Позвонить по видео"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onOpenLink(LinkableElement link) async {
    final uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не удалось открыть ссылку")),
      );
    }
  }

  Future<void> _downloadFile(Message message) async {
    try {
      final fileName = message.fileName ?? 'file';
      final bytes = message.fileBytes;

      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Файл недоступен для загрузки.")),
        );
        return;
      }

      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Нет доступа к хранилищу.")),
          );
          return;
        }
      }

      final dir = await getDownloadsDirectory();
      final file = File('${dir!.path}/$fileName');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Файл сохранён: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при сохранении: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: _showCallOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  onPressed: _sendFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Напишите сообщение...',
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Align(
      alignment: message.sender == Sender.me
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.sender == Sender.me ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: message.fileBytes != null
            ? _buildFileBubble(message)
            : Linkify(
                text: message.text,
                style: const TextStyle(color: Colors.white),
                linkStyle: const TextStyle(
                  color: Colors.lightBlueAccent,
                  decoration: TextDecoration.underline,
                ),
                onOpen: _onOpenLink,
              ),
      ),
    );
  }

  Widget _buildFileBubble(Message message) {
    if (message.isImage) {
      if (UniversalPlatform.isWeb) {
        return Text(
          '[Изображение] ${message.fileName}',
          style: const TextStyle(color: Colors.white),
        );
      } else {
        return Image.file(
          File(message.filePath ?? ''),
          width: 200,
          height: 150,
          fit: BoxFit.cover,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.fileName ?? 'Файл',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () => _downloadFile(message),
          icon: const Icon(Icons.download, color: Colors.white),
          label: const Text("Скачать", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class Message {
  final String text;
  final String? filePath;
  final String? fileName;
  final Uint8List? fileBytes;
  final bool isImage;
  final Sender sender;

  Message({
    this.text = '',
    this.filePath,
    this.fileName,
    this.fileBytes,
    this.isImage = false,
    required this.sender,
  });
}

enum Sender { me, other }
