import "dart:ui" as dart_ui;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"isMe": false, "text": "Hey! How are you doing?", "time": "10:00 AM"},
    {"isMe": true, "text": "I am doing great! Just working on this cool Flutter app.", "time": "10:01 AM"},
    {"isMe": false, "text": "That sounds awesome! Show me the UI.", "time": "10:02 AM"},
    {"isMe": true, "text": "Here it is! It has a liquid glass effect and neon vibes.", "time": "10:03 AM"},
    {"isMe": true, "text": "\u{1F525}\u{1F525}", "time": "10:03 AM"},
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "User";
    final avatar = args?["avatar"] ?? "";
    final initials = args?["initials"] ?? name.substring(0, 1);
    final id = args?["id"] ?? "0";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2E0249), Color(0xff0A1832)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Hero(
                tag: "avatar_chat_$id", // Matching Hero Tag from Home
                child: Stack(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        color: Colors.deepPurple.shade800,
                        image: avatar.toString().startsWith("http")
                            ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover)
                            : null,
                      ),
                      child: avatar.toString().startsWith("http")
                          ? null
                          : Center(
                              child: Text(
                                initials,
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF69F0AE),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xff0A1832), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                  const Text(
                    "Online",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Color(0xFF69F0AE),
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam_outlined, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                child: BackdropFilter(
                  filter: dart_ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0A1832).withValues(alpha: 0.3),
                      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Extra bottom padding for floating input
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg["isMe"] as bool;
                        return RepaintBoundary(
                          child: Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                      decoration: BoxDecoration(
                                        gradient: isMe
                                            ? const LinearGradient(
                                                colors: [Color(0xFFD96FF8), Color(0xFF6A1B9A)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : LinearGradient(
                                                colors: [
                                                  Colors.white.withValues(alpha: 0.15),
                                                  Colors.white.withValues(alpha: 0.05),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(24),
                                          topRight: const Radius.circular(24),
                                          bottomLeft: isMe ? const Radius.circular(24) : const Radius.circular(4),
                                          bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(24),
                                        ),
                                        border: Border.all(
                                          color: isMe
                                              ? Colors.white.withValues(alpha: 0.2)
                                              : Colors.white.withValues(alpha: 0.1),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isMe
                                                ? const Color(0xFFD96FF8).withValues(alpha: 0.25)
                                                : Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        msg["text"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .scale(
                                      duration: 300.ms,
                                      curve: Curves.easeOutBack,
                                      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                                    )
                                    .fadeIn(duration: 200.ms),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    msg["time"],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontSize: 10,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ).animate().fadeIn(delay: 200.ms),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Premium Floating Input Area
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Handle keyboard
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: dart_ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 16),
                        cursorColor: const Color(0xFF69F0AE),
                        decoration: InputDecoration(
                          hintText: "Type a vibe...",
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: "Poppins",
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_none_outlined, color: Colors.white70),
                      onPressed: () {},
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        if (_messageController.text.isNotEmpty) {
                          setState(() {
                            _messages.add({
                              "isMe": true,
                              "text": _messageController.text,
                              "time": '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                            });
                            _messageController.clear();
                          });
                        }
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFD96FF8), Color(0xFF6A1B9A)]),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD96FF8).withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().slideY(begin: 1, duration: 500.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }
}
