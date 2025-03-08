//company.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StudyFlowHome(),
      routes: {
        '/hashtag': (context) => HashtagPage(hashtag: '', posts: []),
      },
    );
  }
}

class StudyFlowHome extends StatefulWidget {
  @override
  _StudyFlowHomeState createState() => _StudyFlowHomeState();
}

class _StudyFlowHomeState extends State<StudyFlowHome> {
  String selectedMenu = "Homepage";
  bool isSidebarOpen = true;
  TextEditingController postController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController socialMediaController = TextEditingController();
  TextEditingController companyDomainController = TextEditingController();
  String profilePhotoUrl = "";

  List<Map<String, dynamic>> posts = [
    {
      "username": "user1",
      "content": "This is a sample post with #StudyFlow.",
      "likes": 10,
      "comments": ["Great post!", "Nice!"],
      "isLiked": false,
      "isSaved": false,
    },
    {
      "username": "user2",
      "content": "Another post here. #StudyFlow",
      "likes": 5,
      "comments": ["Awesome!", "Well done!"],
      "isLiked": false,
      "isSaved": false,
    },
  ];

  List<Map<String, dynamic>> chatMessages = [
    {
      "sender": "Rema XXX",
      "message": "hello",
      "time": "7:33 AM",
    },
    {
      "sender": "name XXX",
      "message": "hi ,how are you ?",
      "time": "7:33 AM",
    },
  ];

  List<String> friends = ["Friend 1", "Friend 2", "Friend 3", "Friend 4"];
  String selectedFriend = "";

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  void addPost() {
    String post = postController.text.trim();
    if (post.isNotEmpty) {
      setState(() {
        posts.add({
          "username": "You",
          "content": post,
          "likes": 0,
          "comments": [],
          "isLiked": false,
          "isSaved": false,
        });
      });
      postController.clear();
    }
  }

  void toggleLike(int index) {
    setState(() {
      posts[index]["isLiked"] = !posts[index]["isLiked"];
      if (posts[index]["isLiked"]) {
        posts[index]["likes"] += 1;
      } else {
        posts[index]["likes"] -= 1;
      }
    });
  }

  void toggleSave(int index) {
    setState(() {
      posts[index]["isSaved"] = !posts[index]["isSaved"];
    });
  }

  void addComment(int index, String comment) {
    setState(() {
      posts[index]["comments"].add(comment);
    });
  }

  void sendMessage() {
    String message = chatController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        chatMessages.add({
          "sender": "You",
          "message": message,
          "time": "${DateTime.now().hour}:${DateTime.now().minute}",
        });
      });
      chatController.clear();
    }
  }

  void selectFriend(String friend) {
    setState(() {
      selectedFriend = friend;
    });
  }

  void updateProfilePhoto(String url) {
    setState(() {
      profilePhotoUrl = url;
    });
  }

  void showProfileModificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modify Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: "Update your bio...",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: socialMediaController,
                decoration: InputDecoration(
                  hintText: "Add your social media link...",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: companyDomainController,
                decoration: InputDecoration(
                  hintText: "Enter your company domain...",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => updateProfilePhoto(value),
                decoration: InputDecoration(
                  hintText: "Enter profile photo URL...",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                bioController.text = bioController.text;
                socialMediaController.text = socialMediaController.text;
                companyDomainController.text = companyDomainController.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void navigateToHashtagPage(String hashtag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HashtagPage(hashtag: hashtag, posts: posts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: isSidebarOpen ? MediaQuery.of(context).size.width * 0.3 : 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle Sidebar Button
                  IconButton(
                    icon: Icon(isSidebarOpen ? Icons.menu_open : Icons.menu),
                    onPressed: toggleSidebar,
                  ),

                  if (selectedMenu == "Homepage") ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: "Search for accounts or themes...",
                                  prefixIcon: Icon(Icons.search, color: Colors.purple),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),

                            // Create Post
                            Card(
                              elevation: 3,
                              margin: EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: postController,
                                      decoration: InputDecoration(
                                        hintText: "What's on your mind?",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: addPost,
                                      child: Text("Post"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Posts Feed
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 3,
                                  margin: EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          posts[index]["username"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        RichText(
                                          text: TextSpan(
                                            children: _parsePostContent(posts[index]["content"]),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                posts[index]["isLiked"]
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: posts[index]["isLiked"]
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () => toggleLike(index),
                                            ),
                                            Text("${posts[index]["likes"]} Likes"),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                posts[index]["isSaved"]
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: posts[index]["isSaved"]
                                                    ? Colors.purple
                                                    : Colors.grey,
                                              ),
                                              onPressed: () => toggleSave(index),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Comments:",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ...posts[index]["comments"].map((comment) {
                                          return ListTile(
                                            title: Text(comment),
                                          );
                                        }).toList(),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: "Add a comment...",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onSubmitted: (comment) {
                                            addComment(index, comment);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (selectedMenu == "Chat") ...[
                    Expanded(
                      child: Column(
                        children: [
                          // Chat Header
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.purple[800],
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Friends List
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(friends[index]),
                                    onTap: () => selectFriend(friends[index]),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Chat Messages
                          if (selectedFriend.isNotEmpty)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: chatMessages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: chatMessages[index]["sender"] == "You"
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chatMessages[index]["sender"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: chatMessages[index]["sender"] == "You"
                                                  ? Colors.purple[100]
                                                  : Colors.grey[200],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              chatMessages[index]["message"],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            chatMessages[index]["time"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Chat Input
                          if (selectedFriend.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(top: BorderSide(color: Colors.grey)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: chatController,
                                      decoration: InputDecoration(
                                        hintText: "Type a message...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send, color: Colors.purple),
                                    onPressed: sendMessage,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  if (selectedMenu == "User Account") ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              // Profile Photo
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.purple[200],
                                backgroundImage: profilePhotoUrl.isNotEmpty
                                    ? NetworkImage(profilePhotoUrl)
                                    : null,
                                child: profilePhotoUrl.isEmpty
                                    ? Icon(Icons.person, size: 50, color: Colors.white)
                                    : null,
                              ),
                              SizedBox(height: 10),

                              // User Information
                              Text(
                                "user name",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text("Company Domain: ${companyDomainController.text}"),
                              SizedBox(height: 10),

                              // Bio
                              Text(
                                "Bio:",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(bioController.text.isEmpty ? "No bio yet." : bioController.text),
                              SizedBox(height: 10),

                              // Social Media Link
                              Text(
                                "Social Media Link:",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(socialMediaController.text.isEmpty
                                  ? "No link added yet."
                                  : socialMediaController.text),
                              SizedBox(height: 20),

                              // Historique Section
                              Text(
                                "Historique:",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text("No history available yet."),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Sliding Sidebar
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: isSidebarOpen ? 0 : -MediaQuery.of(context).size.width * 0.3,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/sidebar.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  buildSidebarItem("Homepage"),
                  buildSidebarItem("Chat"),
                  buildSidebarItem("User Account"),
                ],
              ),
            ),
          ),

          // Floating Action Button for Profile Modification
          if (selectedMenu == "User Account")
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: showProfileModificationDialog,
                child: Icon(Icons.edit),
                backgroundColor: Colors.purple,
              ),
            ),
        ],
      ),
    );
  }

  List<TextSpan> _parsePostContent(String content) {
    List<TextSpan> textSpans = [];
    List<String> words = content.split(" ");

    for (String word in words) {
      if (word.startsWith("#")) {
        textSpans.add(
          TextSpan(
            text: "$word ",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => navigateToHashtagPage(word),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: "$word ",
            style: TextStyle(color: Colors.black),
          ),
        );
      }
    }

    return textSpans;
  }

  Widget buildSidebarItem(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: selectedMenu == title ? Colors.purple[500] : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class HashtagPage extends StatelessWidget {
  final String hashtag;
  final List<Map<String, dynamic>> posts;

  HashtagPage({required this.hashtag, required this.posts});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredPosts =
    posts.where((post) => post["content"].contains(hashtag)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts with $hashtag"),
      ),
      body: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredPosts[index]["username"]),
            subtitle: Text(filteredPosts[index]["content"]),
          );
        },
      ),
    );
  }
}
