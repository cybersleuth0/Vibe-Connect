import "dart:ui" as dart_ui;

import "package:vibe_connect/screens/chat/chat_cubit/chat_cubit.dart";
import "package:vibe_connect/screens/chat/chat_cubit/chat_state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "../../data/models/message_model.dart"; // Added import

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String targetUserId;
  String? currentTargetId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    targetUserId = args?["id"] ?? "";
    if (targetUserId.isNotEmpty && targetUserId != currentTargetId) {
      currentTargetId = targetUserId;
      // Don't initialize the chat room here anymore - only initialize when sending first message
      // We'll handle showing existing messages through the stream once the room is initialized
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "User";
    final avatar = args?["avatar"] ?? "";
    final initials = args?["initials"] ?? name.substring(0, 1).toUpperCase();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2E0249), Color(0xff0A1832)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                Stack(
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
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xFF69F0AE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                    filter: dart_ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff0A1832).withValues(alpha: 0.3),
                        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
                      ),
                      child: Stack(
                        children: [
                          BlocBuilder<ChatCubit, ChatState>(
                            buildWhen: (previous, current) => current is! ChatInitial,
                            builder: (context, state) {
                              if (state is ChatLoading) {
                                return const Center(child: CircularProgressIndicator(color: Color(0xFFD96FF8)));
                              } else if (state is ChatError) {
                                return Center(
                                  child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.white)),
                                );
                              } else if (state is ChatRoomLoaded) {
                                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: context.read<ChatCubit>().getMessagesStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          "Error: ${snapshot.error}",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator(color: Color(0xFFD96FF8)));
                                    }

                                    final messages = snapshot.data!.docs;

                                    // Logic: Mark messages as seen when data arrives
                                    // We use a microtask to avoid calling setState/Bloc during build
                                    if (messages.isNotEmpty) {
                                      Future.microtask(() {
                                        if (context.mounted) {
                                          context.read<ChatCubit>().markAsSeen();
                                        }
                                      });
                                    }

                                    if (messages.isEmpty) {
                                      return const Center(
                                        child: Text("Say Hi! \u{1F44B}", style: TextStyle(color: Colors.white70)),
                                      );
                                    }

                                    return ListView.builder(
                                      controller: _scrollController,
                                      reverse: true, // Show newest at bottom
                                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        final msg = messages[index].data();
                                        final isMe = msg[MessageModel.KEY_SENDER_ID] == currentUserId;
                                        final isSeen = msg[MessageModel.KEY_SEEN] ?? false;
                                        final time = (msg[MessageModel.KEY_CREATION_DATE] as Timestamp?)?.toDate();
                                        final timeString = time != null ? DateFormat("h:mm a").format(time) : "";

                                        return RepaintBoundary(
                                          child: Align(
                                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: isMe
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                      margin: const EdgeInsets.only(bottom: 6),
                                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                                      constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        gradient: isMe
                                                            ? const LinearGradient(
                                                                colors: [Color(0xFFD96FF8), Color(0xFF9C27B0)],
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                              )
                                                            : LinearGradient(
                                                                colors: [
                                                                  Colors.white.withValues(alpha: 0.12),
                                                                  Colors.white.withValues(alpha: 0.05),
                                                                ],
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                              ),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: const Radius.circular(22),
                                                          topRight: const Radius.circular(22),
                                                          bottomLeft: isMe
                                                              ? const Radius.circular(22)
                                                              : const Radius.circular(4),
                                                          bottomRight: isMe
                                                              ? const Radius.circular(4)
                                                              : const Radius.circular(22),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withValues(alpha: 0.1),
                                                            blurRadius: 10,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color: isMe
                                                              ? Colors.white.withValues(alpha: 0.2)
                                                              : Colors.white.withValues(alpha: 0.1),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        msg[MessageModel.KEY_TEXT] ?? "",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    )
                                                    .animate()
                                                    .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                                                    .slideY(begin: 0.1),
                                                if (timeString.isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 12,
                                                      left: isMe ? 0 : 6,
                                                      right: isMe ? 6 : 0,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          timeString,
                                                          style: TextStyle(
                                                            color: Colors.white.withValues(alpha: 0.35),
                                                            fontSize: 10,
                                                            fontFamily: "Poppins",
                                                          ),
                                                        ),
                                                        if (isMe) ...[
                                                          const SizedBox(width: 4),
                                                          Icon(
                                                            isSeen ? Icons.done_all : Icons.done,
                                                            size: 14,
                                                            color: isSeen
                                                                ? const Color(0xFF69F0AE) // Neon Green for Seen
                                                                : Colors.white.withValues(alpha: 0.35), // Grey for Sent
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                // For ChatInitial state, show a message prompting user to send first message
                                return const Center(
                                  child: Text("Send a message to start chatting!",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              }
                            },
                          ),
                          // Premium Floating Input Area
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: BackdropFilter(
                                filter: dart_ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                          ),
                                          cursorColor: const Color(0xFF69F0AE),
                                          decoration: InputDecoration(
                                            hintText: "Type a vibration...",
                                            hintStyle: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.4),
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          ),
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (value) {
                                            if (value.trim().isNotEmpty) {
                                              context.read<ChatCubit>().sendMessage(value.trim(), targetUserId: targetUserId);
                                              _messageController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          if (_messageController.text.isNotEmpty) {
                                            context.read<ChatCubit>().sendMessage(_messageController.text, targetUserId: targetUserId);
                                            _messageController.clear();
                                          }
                                        },
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFFD96FF8), Color(0xFF9C27B0)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFD96FF8).withValues(alpha: 0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ).animate().slideY(begin: 1, duration: 500.ms, curve: Curves.easeOutBack),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
