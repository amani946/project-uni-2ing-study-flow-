
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'StudyFlow',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: MainAppScreen(),
  ));
}

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    InternshipScreen(),
    ScholarshipScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Internships'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Scholarships'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String name;
  final String avatar;
  final String time;
  final String postText;
  final bool hasImage;
  final String? image;
  int likes;
  int comments;
  bool isLiked;
  List<String> hashtags;
  List<Comment> postComments;

  Post({
    required this.id,
    required this.name,
    required this.avatar,
    required this.time,
    required this.postText,
    required this.hasImage,
    this.image,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    this.hashtags = const [],
    this.postComments = const [],
  });
}

class Comment {
  final String id;
  final String author;
  final String avatar;
  final String text;
  final DateTime time;
  int likes;
  bool isLiked;
  List<String> hashtags;

  Comment({
    required this.id,
    required this.author,
    required this.avatar,
    required this.text,
    required this.time,
    this.likes = 0,
    this.isLiked = false,
    this.hashtags = const [],
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postController = TextEditingController();
  List<Post> _posts = [
    Post(
      id: '1',
      name: 'Malak_222',
      avatar: 'assets/user1.jpg',
      time: '2 hrs ago',
      postText: 'Hello! Can I get advice on how to learn #coding?',
      hasImage: true,
      image: 'assets/post1.jpg',
      likes: 24,
      comments: 2,
      hashtags: ['#coding'],
      postComments: [
        Comment(
          id: 'c1',
          author: 'Amina_T',
          avatar: 'assets/user2.jpg',
          text: 'Start with #Python, it has great learning resources!',
          time: DateTime.now().subtract(Duration(hours: 1)),
          hashtags: ['#Python'],
        ),
        Comment(
          id: 'c2',
          author: 'Yassine_D',
          avatar: 'assets/user3.jpg',
          text: 'Check out #freeCodeCamp and #Codecademy',
          time: DateTime.now().subtract(Duration(minutes: 30)),
          hashtags: ['#freeCodeCamp', '#Codecademy'],
        ),
      ],
    ),
    Post(
      id: '2',
      name: 'Amani_Oa',
      avatar: 'assets/user2.jpg',
      time: '5 hrs ago',
      postText: 'Just finished my #Flutter project! So excited!',
      hasImage: false,
      likes: 42,
      comments: 1,
      hashtags: ['#Flutter'],
      postComments: [
        Comment(
          id: 'c3',
          author: 'Karim_F',
          avatar: 'assets/user4.jpg',
          text: 'Great job! What was the project about? #coding',
          time: DateTime.now().subtract(Duration(hours: 3)),
          hashtags: ['#coding'],
        ),
      ],
    ),
  ];

  void _addPost(String text) {
    if (text.isEmpty) return;

    final hashtagRegex = RegExp(r'\B#\w*[a-zA-Z]+\w*');
    final matches = hashtagRegex.allMatches(text);
    final hashtags = matches.map((match) => match.group(0)!).toList();

    setState(() {
      _posts.insert(0, Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'You',
        avatar: 'assets/profile.png',
        time: 'Just now',
        postText: text,
        hasImage: false,
        likes: 0,
        comments: 0,
        hashtags: hashtags,
      ));
    });
    _postController.clear();
  }

  void _toggleLike(int index) {
    setState(() {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].likes += _posts[index].isLiked ? 1 : -1;
    });
  }

  void _toggleCommentLike(int postIndex, int commentIndex) {
    setState(() {
      final comment = _posts[postIndex].postComments[commentIndex];
      comment.isLiked = !comment.isLiked;
      comment.likes += comment.isLiked ? 1 : -1;
    });
  }

  void _addComment(int index, String commentText) {
    if (commentText.isEmpty) return;

    final hashtagRegex = RegExp(r'\B#\w*[a-zA-Z]+\w*');
    final matches = hashtagRegex.allMatches(commentText);
    final hashtags = matches.map((match) => match.group(0)!).toList();

    setState(() {
      _posts[index].postComments.add(Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: 'You',
        avatar: 'assets/profile.png',
        text: commentText,
        time: DateTime.now(),
        hashtags: hashtags,
      ));
      _posts[index].comments = _posts[index].postComments.length;
    });
  }

  void _showCommentDialog(int index) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              decoration: InputDecoration(hintText: 'Write your comment...'),
              maxLines: 3,
            ),
            SizedBox(height: 8),
            Text(
              'Use # to create hashtags (e.g. #coding)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addComment(index, commentController.text);
              Navigator.pop(context);
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  void _searchHashtags(String hashtag) {
    final allPostsWithHashtag = _posts.where((post) {
      return post.hashtags.any((h) => h.toLowerCase() == hashtag.toLowerCase()) ||
          post.postComments.any((comment) =>
              comment.hashtags.any((h) => h.toLowerCase() == hashtag.toLowerCase()));
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Posts with $hashtag'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allPostsWithHashtag.length,
            itemBuilder: (context, index) {
              final post = allPostsWithHashtag[index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(post.avatar)),
                title: Text(post.name),
                subtitle: Text(post.postText),
                onTap: () {
                  Navigator.pop(context);
                  // Scroll to the post in the main list
                  final postIndex = _posts.indexWhere((p) => p.id == post.id);
                  if (postIndex != -1) {
                    Scrollable.ensureVisible(
                      context,
                      alignment: 0.5,
                      duration: Duration(milliseconds: 500),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithHashtags(String text, List<String> hashtags) {
    final words = text.split(' ');
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: words.map((word) {
          return TextSpan(
            text: '$word ',
            style: hashtags.contains(word)
                ? TextStyle(color: Colors.purple[800], fontWeight: FontWeight.bold)
                : null,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('StudyFlow', style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.purple[800]),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _HashtagSearchDelegate(
                  onHashtagSelected: _searchHashtags,
                  posts: _posts,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.purple[800]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Create Post Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _postController,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.photo, color: Colors.purple),
                          label: Text('Photo'),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.videocam, color: Colors.purple),
                          label: Text('Video'),
                          onPressed: () {},
                        ),
                        TextButton(
                          child: Text('Post'),
                          onPressed: () => _addPost(_postController.text),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Posts List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(post.avatar),
                        ),
                        title: Text(post.name, style: TextStyle(color: Colors.purple[800])),
                        subtitle: Text(post.time),
                        trailing: Icon(Icons.more_vert, color: Colors.purple),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _buildTextWithHashtags(post.postText, post.hashtags),
                      ),
                      if (post.hashtags.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            children: post.hashtags.map((hashtag) => GestureDetector(
                              onTap: () => _searchHashtags(hashtag),
                              child: Chip(
                                label: Text(hashtag),
                                backgroundColor: Colors.purple[50],
                              ),
                            )).toList(),
                          ),
                        ),
                      if (post.hasImage)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              post.image!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                post.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: post.isLiked ? Colors.red : Colors.purple,
                              ),
                              onPressed: () => _toggleLike(index),
                            ),
                            Text(post.likes.toString()),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.comment, color: Colors.purple),
                              onPressed: () => _showCommentDialog(index),
                            ),
                            Text(post.comments.toString()),
                          ],
                        ),
                      ),
                      // Display comments section
                      if (post.postComments.isNotEmpty) ...[
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              ...post.postComments.map((comment) => Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: AssetImage(comment.avatar),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.author,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.purple[800],
                                                ),
                                              ),
                                              _buildTextWithHashtags(comment.text, comment.hashtags),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${comment.time.hour}:${comment.time.minute.toString().padLeft(2, '0')}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    icon: Icon(
                                                      comment.isLiked ? Icons.favorite : Icons.favorite_border,
                                                      size: 16,
                                                      color: comment.isLiked ? Colors.red : Colors.grey,
                                                    ),
                                                    onPressed: () => _toggleCommentLike(index, post.postComments.indexOf(comment)),
                                                  ),
                                                  Text(
                                                    comment.likes > 0 ? comment.likes.toString() : '',
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (comment.hashtags.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Wrap(
                                          spacing: 4,
                                          children: comment.hashtags.map((hashtag) => GestureDetector(
                                            onTap: () => _searchHashtags(hashtag),
                                            child: Chip(
                                              label: Text(hashtag),
                                              backgroundColor: Colors.purple[50],
                                              labelStyle: TextStyle(fontSize: 12),
                                            ),
                                          )).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              )).toList(),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HashtagSearchDelegate extends SearchDelegate<String> {
  final Function(String) onHashtagSelected;
  final List<Post> posts;

  _HashtagSearchDelegate({required this.onHashtagSelected, required this.posts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allHashtags = <String>{};

    // Collect all hashtags from posts and comments
    for (final post in posts) {
      allHashtags.addAll(post.hashtags);
      for (final comment in post.postComments) {
        allHashtags.addAll(comment.hashtags);
      }
    }

    final suggestions = query.isEmpty
        ? <String>[]
        : allHashtags
        .where((hashtag) => hashtag.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(Icons.tag),
          title: Text(suggestion),
          onTap: () {
            onHashtagSelected(suggestion);
            close(context, suggestion);
          },
        );
      },
    );
  }
}

// Internship Screen
class InternshipScreen extends StatelessWidget {
  void _showApplicationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have successfully applied!'),
        duration: Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Internship Opportunities', style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Software Development Intern',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tech Company Inc.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'We are looking for a motivated software development intern to join our team for 3 months.',
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text('Flutter'),
                        backgroundColor: Colors.purple[50],
                      ),
                      Chip(
                        label: Text('Dart'),
                        backgroundColor: Colors.purple[50],
                      ),
                      Chip(
                        label: Text('Mobile'),
                        backgroundColor: Colors.purple[50],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Algiers, Algeria',
                        style: TextStyle(color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showApplicationSnackBar(context);
                        },
                        child: Text('Apply Now', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Scholarship Screen
class ScholarshipScreen extends StatelessWidget {
  void _showApplicationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have successfully applied!'),
        duration: Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Scholarship Opportunities', style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STEM Scholarship Program',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ministry of Higher Education',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Full scholarship for outstanding students in Science, Technology, Engineering and Mathematics.',
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text('Full Tuition'),
                        backgroundColor: Colors.purple[50],
                      ),
                      Chip(
                        label: Text('Monthly Stipend'),
                        backgroundColor: Colors.purple[50],
                      ),
                      Chip(
                        label: Text('2 Years'),
                        backgroundColor: Colors.purple[50],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deadline: 30/06/2023',
                        style: TextStyle(color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showApplicationSnackBar(context);
                        },
                        child: Text('Apply Now', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Chat Screen
class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String sender;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.sender,
  });
}

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<bool> _selectedUsers = List.generate(3, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Create Group', style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CREATE', style: TextStyle(color: Colors.purple[800])),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: TextStyle(color: Colors.purple),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: Text('Anis'),
                    value: _selectedUsers[0],
                    onChanged: (value) {
                      setState(() {
                        _selectedUsers[0] = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                  CheckboxListTile(
                    title: Text('Meriem'),
                    value: _selectedUsers[1],
                    onChanged: (value) {
                      setState(() {
                        _selectedUsers[1] = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                  CheckboxListTile(
                    title: Text('Ghizlan'),
                    value: _selectedUsers[2],
                    onChanged: (value) {
                      setState(() {
                        _selectedUsers[2] = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.group_add, color: Colors.purple[800]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                hintText: 'Search messages',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.purple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple[100],
                    child: Icon(Icons.group, color: Colors.purple[800]),
                  ),
                  title: Text('ING2 Study Group'),
                  subtitle: Text('Anis: Let\'s meet tomorrow'),
                  trailing: Text('2h ago'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: 1,
                          isGroup: true,
                          userName: 'ING2 Study Group',
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('A', style: TextStyle(color: Colors.blue[800])),
                  ),
                  title: Text('Anis'),
                  subtitle: Text('I sent the project files'),
                  trailing: Text('1d ago'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: 2,
                          isGroup: false,
                          userName: 'Anis',
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: Text('M', style: TextStyle(color: Colors.pink[800])),
                  ),
                  title: Text('Meriem'),
                  subtitle: Text('Did you finish the assignment?'),
                  trailing: Text('3d ago'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: 3,
                          isGroup: false,
                          userName: 'Meriem',
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Text('G', style: TextStyle(color: Colors.green[800])),
                  ),
                  title: Text('Ghizlan'),
                  subtitle: Text('The exam is next week'),
                  trailing: Text('5d ago'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: 4,
                          isGroup: false,
                          userName: 'Ghizlan',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final int userId;
  final bool isGroup;
  final String userName;

  ChatDetailScreen({
    required this.userId,
    this.isGroup = false,
    required this.userName
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.isGroup) {
      _messages.addAll([
        ChatMessage(
          text: 'Welcome everyone to the ING2 study group!',
          isMe: false,
          time: '10:30 AM',
          sender: 'Anis',
        ),
        ChatMessage(
          text: 'Thanks for creating the group',
          isMe: false,
          time: '10:35 AM',
          sender: 'Meriem',
        ),
        ChatMessage(
          text: 'When is our next meeting?',
          isMe: false,
          time: '10:40 AM',
          sender: 'Ghizlan',
        ),
      ]);
    } else {
      switch (widget.userId) {
        case 2: // Anis
          _messages.addAll([
            ChatMessage(
              text: 'Hi there! Did you get the project files I sent?',
              isMe: false,
              time: '9:00 AM',
              sender: 'Anis',
            ),
            ChatMessage(
              text: 'Yes, I got them. Thanks!',
              isMe: true,
              time: '9:05 AM',
              sender: 'Me',
            ),
          ]);
          break;
        case 3: // Meriem
          _messages.addAll([
            ChatMessage(
              text: 'Hey, did you finish the assignment?',
              isMe: false,
              time: '2:00 PM',
              sender: 'Meriem',
            ),
            ChatMessage(
              text: 'Almost done, just need to check a few things',
              isMe: true,
              time: '2:30 PM',
              sender: 'Me',
            ),
          ]);
          break;
        case 4: // Ghizlan
          _messages.addAll([
            ChatMessage(
              text: 'The exam is next week, are you ready?',
              isMe: false,
              time: '4:00 PM',
              sender: 'Ghizlan',
            ),
            ChatMessage(
              text: 'I need to study more, what about you?',
              isMe: true,
              time: '4:10 PM',
              sender: 'Me',
            ),
          ]);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Row(
          children: [
            widget.isGroup
                ? CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Icon(Icons.group, color: Colors.purple[800]),
            )
                : CircleAvatar(
              backgroundColor: _getUserColor(widget.userId),
              child: Text(
                widget.userName[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text(widget.userName,
                style: TextStyle(color: Colors.purple[800])),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Align(
                  alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMe ? Colors.purple[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isGroup && !message.isMe)
                          Text(
                            message.sender,
                            style: TextStyle(
                              color: Colors.purple[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isMe ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message.time,
                          style: TextStyle(
                            color: message.isMe ? Colors.white70 : Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.purple[800],
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        setState(() {
                          _messages.insert(0, ChatMessage(
                            text: _messageController.text,
                            isMe: true,
                            time: 'Just now',
                            sender: 'Me',
                          ));
                          _messageController.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getUserColor(int userId) {
    switch (userId) {
      case 2: // Anis
        return Colors.blue;
      case 3: // Meriem
        return Colors.pink;
      case 4: // Ghizlan
        return Colors.green;
      default:
        return Colors.purple;
    }
  }
}
// Profile Screen with To-Do List
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _bioController = TextEditingController(
    text: 'I am a passionate computer science student looking for internship opportunities to gain real-world experience.',
  );
  final TextEditingController _todoController = TextEditingController();
  final List<TodoItem> _todos = [];
  bool _isEditingBio = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('My Profile', style: TextStyle(color: Colors.purple[800])),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.purple[800]),
              onPressed: () {
                setState(() {
                  _isEditingBio = !_isEditingBio;
                });
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.purple[800],
            labelColor: Colors.purple[800],
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'To-Do List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Profile Tab
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple[800]!,
                          Colors.purple[400]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'GHALI Riham',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Computer Science Student',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        _isEditingBio
                            ? TextField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                          ),
                        )
                            : Text(_bioController.text),
                        SizedBox(height: 24),
                        Text(
                          'Education',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          leading: Icon(Icons.school, color: Colors.purple),
                          title: Text('University of Tlemcen'),
                          subtitle: Text('Engineer in Computer Science'),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              label: Text('HTML'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('CSS'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('JavaScript'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('Java'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('SQL'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('C/C++'),
                              backgroundColor: Colors.purple[50],
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.purple),
                          title: Text('GHALIRiham@example.com'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.purple),
                          title: Text('+213 123 456 789'),
                        ),
                        ListTile(
                          leading: Icon(Icons.link, color: Colors.purple),
                          title: Text('linkedin.com/in/GHALIRiham'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // To-Do List Tab
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            labelText: 'Add a new task',
                            labelStyle: TextStyle(color: Colors.purple),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.purple[800]),
                        onPressed: () {
                          if (_todoController.text.isNotEmpty) {
                            setState(() {
                              _todos.add(TodoItem(
                                text: _todoController.text,
                                isCompleted: false,
                              ));
                              _todoController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  _todos[index] = TodoItem(
                                    text: todo.text,
                                    isCompleted: value!,
                                  );
                                });
                              },
                              activeColor: Colors.purple,
                            ),
                            title: Text(
                              todo.text,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _todos.removeAt(index);
                                });
                              },
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
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text("Posts with $hashtag", style: TextStyle(color: Colors.purple[800])),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.purple[200],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text(
                        filteredPosts[index]["username"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(filteredPosts[index]["content"]),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red),
                      SizedBox(width: 4),
                      Text("${filteredPosts[index]["likes"]}"),
                      SizedBox(width: 16),
                      Icon(Icons.comment, color: Colors.purple),
                      SizedBox(width: 4),
                      Text("${filteredPosts[index]["comments"].length}"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TodoItem {
  final String text;
  final bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}
