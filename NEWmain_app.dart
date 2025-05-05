// main_app.dart
import 'package:flutter/material.dart';

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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Internships',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Scholarships',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
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
            onPressed: () {},
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
                          label: Text('Photo', style: TextStyle(color: Colors.purple)),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.videocam, color: Colors.purple),
                          label: Text('Video', style: TextStyle(color: Colors.purple)),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.location_on, color: Colors.purple),
                          label: Text('Location', style: TextStyle(color: Colors.purple)),
                          onPressed: () {},
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
              itemCount: 5,
              itemBuilder: (context, index) {
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
                          backgroundImage: AssetImage('assets/user${index + 1}.jpg'),
                        ),
                        title: Text('User ${index + 1}', style: TextStyle(color: Colors.purple[800])),
                        subtitle: Text('2 hrs ago'),
                        trailing: Icon(Icons.more_vert, color: Colors.purple),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'This is a sample post content. It can be about study tips, internship opportunities, or anything related to education.',
                        ),
                      ),
                      if (index % 2 == 0)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/post${index + 1}.jpg',
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
                              icon: Icon(Icons.favorite_border, color: Colors.purple),
                              onPressed: () {},
                            ),
                            Text('24'),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.comment, color: Colors.purple),
                              onPressed: () {},
                            ),
                            Text('5'),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.purple),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
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

// Internship Screen
class InternshipScreen extends StatelessWidget {
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
                        style: TextStyle(color: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Apply Now'),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Apply Now'),
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
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                bool isGroup = index % 3 == 0;
                return ListTile(
                  leading: isGroup
                      ? CircleAvatar(
                    backgroundColor: Colors.purple[100],
                    child: Icon(Icons.group, color: Colors.purple[800]),
                  )
                      : CircleAvatar(
                    backgroundImage: AssetImage('assets/user${index % 5 + 1}.jpg'),
                  ),
                  title: Text(isGroup ? 'Study Group ${index + 1}' : 'User ${index + 1}'),
                  subtitle: Text('Last message...'),
                  trailing: Text('2h ago'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: index + 1,
                          isGroup: isGroup,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<bool> _selectedUsers = List.generate(10, (index) => false);

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
              // Create group logic here
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
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text('User ${index + 1}'),
                    secondary: CircleAvatar(
                      backgroundImage: AssetImage('assets/user${index % 5 + 1}.jpg'),
                    ),
                    value: _selectedUsers[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedUsers[index] = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final int userId;
  final bool isGroup;

  ChatDetailScreen({required this.userId, this.isGroup = false});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

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
              backgroundImage: AssetImage('assets/user${widget.userId}.jpg'),
            ),
            SizedBox(width: 12),
            Text(widget.isGroup ? 'Group ${widget.userId}' : 'User ${widget.userId}',
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
                          _messages.add(ChatMessage(
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
}

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
                            'John Doe',
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
                          title: Text('University of Algiers'),
                          subtitle: Text('Bachelor in Computer Science'),
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
                              label: Text('Flutter'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('Dart'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('Java'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('Python'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('SQL'),
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text('Git'),
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
                          title: Text('john.doe@example.com'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.purple),
                          title: Text('+213 123 456 789'),
                        ),
                        ListTile(
                          leading: Icon(Icons.link, color: Colors.purple),
                          title: Text('linkedin.com/in/johndoe'),
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

class TodoItem {
  final String text;
  final bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}
