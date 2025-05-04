import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import 'auth_screens.dart';
import 'firebase_service.dart';

class StudyFlowCompanyHome extends StatefulWidget {
  @override
  _StudyFlowCompanyHomeState createState() => _StudyFlowCompanyHomeState();
}

class _StudyFlowCompanyHomeState extends State<StudyFlowCompanyHome> {
  String selectedMenu = "Homepage";
  bool isSidebarOpen = true;
  TextEditingController postController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController socialMediaController = TextEditingController();
  TextEditingController companyDomainController = TextEditingController();
  String profilePhotoUrl = "";

  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> chatMessages = [];
  List<String> friends = [];
  String selectedFriend = "";

  // Internship posting variables
  TextEditingController internshipTitleController = TextEditingController();
  TextEditingController internshipDescController = TextEditingController();
  TextEditingController internshipSkillsController = TextEditingController();
  TextEditingController internshipLinkController = TextEditingController();

  // Internships list
  List<Map<String, dynamic>> internships = [];

  User? currentUser;
  Map<String, dynamic>? companyData;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _loadCompanyData();
    _setupStreams();
  }

  void _loadCompanyData() async {
    if (currentUser != null) {
      final companyDoc = await FirebaseService().getUserData(currentUser!.uid);
      if (companyDoc.exists) {
        setState(() {
          companyData = companyDoc.data() as Map<String, dynamic>;
          bioController.text = companyData?['bio'] ?? '';
          companyDomainController.text = companyData?['domain'] ?? '';
          profilePhotoUrl = companyData?['profile_picture'] ?? '';
          if (companyData?['social_links'] != null && companyData!['social_links'].isNotEmpty) {
            socialMediaController.text = companyData!['social_links'][0];
          }
        });
      }
    }
  }

  void _setupStreams() {
    // Posts stream
    FirebaseService().getPostsStream().listen((QuerySnapshot snapshot) {
      setState(() {
        posts = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'user_id': doc['user_id'],
            'username': 'Loading...',
            'content': doc['content'],
            'image': doc['image'],
            'likes': doc['likes'] != null ? doc['likes'].length : 0,
            'isLiked': doc['likes'] != null && currentUser != null
                ? doc['likes'].containsKey(currentUser!.uid)
                : false,
            'isSaved': false,
            'comments': doc['comments'] != null
                ? doc['comments'].values.map((c) => c['content']).toList()
                : [],
            'hashtags': doc['hashtags'] != null
                ? doc['hashtags'].values.map((h) => h['name']).toList()
                : [],
          };
        }).toList();
      });

      // Fetch usernames for each post
      for (var post in posts) {
        FirebaseService().getUserData(post['user_id']).then((userDoc) {
          if (userDoc.exists) {
            setState(() {
              post['username'] = userDoc['name'];
            });
          }
        });
      }
    });

    // Internships stream
    FirebaseService().getInternshipsStream().listen((QuerySnapshot snapshot) {
      setState(() {
        internships = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'company_id': doc['company_id'],
            'title': doc['title'],
            'description': doc['description'],
            'skills_required': doc['skills_required'],
            'link': doc['link'],
            'created_at': doc['created_at']?.toDate(),
          };
        }).toList();
      });
    });
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  Future<void> updateProfile() async {
    if (currentUser != null) {
      await FirebaseService().updateUserProfile(
        userId: currentUser!.uid,
        bio: bioController.text,
        socialLink: socialMediaController.text,
        profilePicture: profilePhotoUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  Future<void> addPost() async {
    if (currentUser != null && postController.text.trim().isNotEmpty) {
      final hashtags = RegExp(r'#\w+')
          .allMatches(postController.text)
          .map((match) => match.group(0)!)
          .toList();

      await FirebaseService().createPost(
        userId: currentUser!.uid,
        content: postController.text.trim(),
        hashtags: hashtags,
      );
      postController.clear();
    }
  }

  Future<void> toggleLike(int index) async {
    if (currentUser != null && index < posts.length) {
      if (posts[index]['isLiked']) {
        await FirebaseService().unlikePost(posts[index]['id'], currentUser!.uid);
      } else {
        await FirebaseService().likePost(posts[index]['id'], currentUser!.uid);
      }
    }
  }

  Future<void> addComment(int index, String comment) async {
    if (currentUser != null && index < posts.length && comment.isNotEmpty) {
      await FirebaseService().addComment(
        posts[index]['id'],
        currentUser!.uid,
        comment,
      );
    }
  }

  Future<void> sendMessage() async {
    if (currentUser != null && selectedFriend.isNotEmpty && chatController.text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message would be sent to $selectedFriend')),
      );
      chatController.clear();
    }
  }

  void selectFriend(String friend) {
    setState(() {
      selectedFriend = friend;
    });
  }

  Future<void> createInternship() async {
    if (currentUser != null &&
        internshipTitleController.text.trim().isNotEmpty &&
        internshipDescController.text.trim().isNotEmpty) {

      final skills = internshipSkillsController.text
          .trim()
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList();

      await FirebaseService().createInternship(
        companyId: currentUser!.uid,
        title: internshipTitleController.text.trim(),
        description: internshipDescController.text.trim(),
        skillsRequired: skills,
        link: internshipLinkController.text.trim(),
      );

      internshipTitleController.clear();
      internshipDescController.clear();
      internshipSkillsController.clear();
      internshipLinkController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internship posted successfully!')),
      );
    }
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
                  hintText: "Update your company domain...",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => setState(() {
                  profilePhotoUrl = value;
                }),
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
              Navigator.pop(context);
              updateProfile();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void showCreateInternshipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Internship"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: internshipTitleController,
                decoration: InputDecoration(
                  hintText: "Internship Title",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: internshipDescController,
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextField(
                controller: internshipSkillsController,
                decoration: InputDecoration(
                  hintText: "Required Skills (comma separated)",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: internshipLinkController,
                decoration: InputDecoration(
                  hintText: "Application Link (optional)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              createInternship();
            },
            child: Text("Post"),
          ),
        ],
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
                  IconButton(
                    icon: Icon(isSidebarOpen ? Icons.menu_open : Icons.menu),
                    onPressed: toggleSidebar,
                  ),

                  if (selectedMenu == "Homepage") ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                                        Text(posts[index]["content"]),
                                        if (posts[index]["image"] != null && posts[index]["image"].isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Image.network(posts[index]["image"]),
                                          ),
                                        SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          children: (posts[index]["hashtags"] as List).map<Widget>((hashtag) {
                                            return Chip(
                                              label: Text(hashtag),
                                              backgroundColor: Colors.purple[100],
                                            );
                                          }).toList(),
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
                                              onPressed: () {
                                                setState(() {
                                                  posts[index]["isSaved"] = !posts[index]["isSaved"];
                                                });
                                              },
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
                                        ...posts[index]["comments"].map<Widget>((comment) {
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

                  if (selectedMenu == "Internships") ...[
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: showCreateInternshipDialog,
                              child: Text("Create New Internship"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: internships.length,
                              itemBuilder: (context, index) {
                                final internship = internships[index];
                                return Card(
                                  elevation: 3,
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          internship["title"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(internship["description"]),
                                        SizedBox(height: 10),
                                        Text(
                                          "Skills Required:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          children: (internship["skills_required"] as List).map<Widget>((skill) {
                                            return Chip(
                                              label: Text(skill),
                                              backgroundColor: Colors.purple[100],
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 10),
                                        if (internship["link"] != null && internship["link"].isNotEmpty)
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Launch URL
                                            },
                                            child: Text("View Application Link"),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ... (rest of your UI code remains the same)
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
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  buildSidebarItem("Homepage"),
                  buildSidebarItem("Chat"),
                  buildSidebarItem("Internships"),
                  buildSidebarItem("User Account"),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      await FirebaseService().signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false,
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

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
