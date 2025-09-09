import 'package:flutter/material.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/message.dart';
import 'package:athletica/utils/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  final Client client;

  const ChatScreen({super.key, required this.client});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock messages - in real app, this would come from API
    _messages = [
      Message(
        id: '1',
        senderId: widget.client.id,
        receiverId:
            Provider.of<AuthProvider>(context, listen: false).coach?.id ??
                'coach_id',
        content: 'Hello! I\'m excited to start my fitness journey with you.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: '2',
        senderId: Provider.of<AuthProvider>(context, listen: false).coach?.id ??
            'coach_id',
        receiverId: widget.client.id,
        content:
            'Welcome! I\'m here to help you achieve your fitness goals. Let\'s start with a consultation.',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      Message(
        id: '3',
        senderId: widget.client.id,
        receiverId:
            Provider.of<AuthProvider>(context, listen: false).coach?.id ??
                'coach_id',
        content: 'That sounds great! When can we schedule our first session?',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      Message(
        id: '4',
        senderId: Provider.of<AuthProvider>(context, listen: false).coach?.id ??
            'coach_id',
        receiverId: widget.client.id,
        content:
            'How about tomorrow at 6 PM? I\'ll send you the workout plan after our session.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      Message(
        id: '5',
        senderId: widget.client.id,
        receiverId:
            Provider.of<AuthProvider>(context, listen: false).coach?.id ??
                'coach_id',
        content: 'Perfect! I\'ll be there. Thank you for the quick response.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryBlue,
              backgroundImage: widget.client.profilePhotoUrl != null
                  ? NetworkImage(widget.client.profilePhotoUrl!)
                  : null,
              child: widget.client.profilePhotoUrl == null
                  ? Text(
                      widget.client.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.client.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: AppTheme.successGreen,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: AppTheme.textPrimary),
            onPressed: () {
              // TODO: Implement video call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call feature coming soon'),
                  backgroundColor: AppTheme.warningOrange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: AppTheme.textPrimary),
            onPressed: () {
              // TODO: Implement voice call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call feature coming soon'),
                  backgroundColor: AppTheme.warningOrange,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId ==
                    (Provider.of<AuthProvider>(context, listen: false)
                            .coach
                            ?.id ??
                        'coach_id');
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${widget.client.name} is typing...',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryBlue,
              backgroundImage: widget.client.profilePhotoUrl != null
                  ? NetworkImage(widget.client.profilePhotoUrl!)
                  : null,
              child: widget.client.profilePhotoUrl == null
                  ? Text(
                      widget.client.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.primaryBlue : AppTheme.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe ? null : Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatMessageTime(message.timestamp),
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppTheme.textGrey,
                          fontSize: 12,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 16,
                          color: message.isRead
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.successGreen,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.cardBackground,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppTheme.textSecondary),
            onPressed: _showAttachmentOptions,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      const BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
                filled: true,
                fillColor: AppTheme.darkBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppTheme.primaryBlue),
            onPressed: _sendMessage,
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: Provider.of<AuthProvider>(context, listen: false).coach?.id ??
          'coach_id',
      receiverId: widget.client.id,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate client response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            final responses = [
              'Thank you for the message!',
              'That sounds great!',
              'I understand, thank you for explaining.',
              'Perfect! I\'ll work on that.',
              'Got it, thanks for the guidance.',
            ];

            final response =
                responses[DateTime.now().millisecond % responses.length];

            final clientMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: widget.client.id,
              receiverId:
                  Provider.of<AuthProvider>(context, listen: false).coach?.id ??
                      'coach_id',
              content: response,
              timestamp: DateTime.now(),
              isRead: true,
            );

            setState(() {
              _messages.add(clientMessage);
              _isTyping = false;
            });

            _scrollToBottom();
          }
        });
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send Attachment',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo,
                  label: 'Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.video_library,
                  label: 'Video',
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.attach_file,
                  label: 'File',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.fitness_center,
                  label: 'Workout',
                  onTap: () {
                    Navigator.pop(context);
                    _sendWorkoutPlan();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final message = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId:
              Provider.of<AuthProvider>(context, listen: false).coach?.id ??
                  'coach_id',
          receiverId: widget.client.id,
          content: '📷 Photo',
          timestamp: DateTime.now(),
          type: MessageType.image,
          attachmentUrl: image.path,
          isRead: false,
        );

        setState(() {
          _messages.add(message);
        });

        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video attachment feature coming soon'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  Future<void> _pickFile() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File attachment feature coming soon'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  void _sendWorkoutPlan() {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: Provider.of<AuthProvider>(context, listen: false).coach?.id ??
          'coach_id',
      receiverId: widget.client.id,
      content: '💪 New workout plan shared!',
      timestamp: DateTime.now(),
      type: MessageType.workout,
      isRead: false,
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
