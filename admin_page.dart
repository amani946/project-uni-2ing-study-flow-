// admin_page.dart
import 'package:flutter/material.dart';
import 'auth_screens.dart';
import 'main_app.dart';
import 'main.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  TextEditingController searchController = TextEditingController();

  // Données simulées pour l'admin
  List<Map<String, dynamic>> users = [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "type": "Student",
      "status": "Active",
      "registrationDate": "2023-01-15"
    },
    {
      "id": 2,
      "name": "Tech Corp",
      "email": "contact@techcorp.com",
      "type": "Company",
      "status": "Active",
      "registrationDate": "2023-02-20"
    },
    {
      "id": 3,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "type": "Student",
      "status": "Banned",
      "registrationDate": "2023-03-10"
    },
  ];

  List<Map<String, dynamic>> reportedPosts = [
    {
      "id": 101,
      "content": "This is an inappropriate post",
      "author": "User123",
      "reports": 5,
      "status": "Pending"
    },
    {
      "id": 102,
      "content": "Spam content here",
      "author": "User456",
      "reports": 3,
      "status": "Pending"
    },
    {
      "id": 103,
      "content": "Already reviewed post",
      "author": "User789",
      "reports": 2,
      "status": "Resolved"
    },
  ];

  List<Map<String, dynamic>> statistics = [
    {"label": "Total Users", "value": "1,245", "icon": Icons.people},
    {"label": "Active Today", "value": "342", "icon": Icons.today},
    {"label": "New Posts", "value": "56", "icon": Icons.post_add},
    {"label": "Reports", "value": "12", "icon": Icons.report},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void banUser(int userId) {
    setState(() {
      users.firstWhere((user) => user["id"] == userId)["status"] = "Banned";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User has been banned')),
    );
  }

  void unbanUser(int userId) {
    setState(() {
      users.firstWhere((user) => user["id"] == userId)["status"] = "Active";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User has been unbanned')),
    );
  }

  void resolveReport(int postId) {
    setState(() {
      reportedPosts.firstWhere((post) => post["id"] == postId)["status"] = "Resolved";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report has been resolved')),
    );
  }

  void deletePost(int postId) {
    setState(() {
      reportedPosts.removeWhere((post) => post["id"] == postId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post has been deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildDashboard()
          : _selectedIndex == 1
          ? _buildUserManagement()
          : _buildReportManagement(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: statistics.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(statistics[index]["icon"], size: 40, color: Colors.purple),
                      SizedBox(height: 10),
                      Text(
                        statistics[index]["value"],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(statistics[index]["label"]),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),
          Text(
            'Recent Activities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.person_add, color: Colors.green),
              title: Text('New user registered'),
              subtitle: Text('John Doe (Student) - 2 hours ago'),
            ),
          ),
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.report, color: Colors.orange),
              title: Text('New report received'),
              subtitle: Text('Post #101 - 5 hours ago'),
            ),
          ),
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.people, color: Colors.blue),
              title: Text('New company registered'),
              subtitle: Text('Tech Corp - 1 day ago'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagement() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(users[index]["name"][0]),
                  ),
                  title: Text(users[index]["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(users[index]["email"]),
                      Text('${users[index]["type"]} • ${users[index]["status"]}'),
                      Text('Registered: ${users[index]["registrationDate"]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (users[index]["status"] == "Active")
                        IconButton(
                          icon: Icon(Icons.block, color: Colors.red),
                          onPressed: () => banUser(users[index]["id"]),
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => unbanUser(users[index]["id"]),
                        ),
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          // View user details
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportManagement() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Reported Content',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Chip(
                label: Text('Pending: ${reportedPosts.where((post) => post["status"] == "Pending").length}'),
                backgroundColor: Colors.orange[100],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: reportedPosts.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: reportedPosts[index]["status"] == "Pending"
                    ? Colors.orange[50]
                    : Colors.grey[100],
                child: ListTile(
                  title: Text(reportedPosts[index]["content"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${reportedPosts[index]["author"]}'),
                      Text('Reports: ${reportedPosts[index]["reports"]}'),
                      Text('Status: ${reportedPosts[index]["status"]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (reportedPosts[index]["status"] == "Pending")
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => resolveReport(reportedPosts[index]["id"]),
                        ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deletePost(reportedPosts[index]["id"]),
                      ),
                    ],
                  ),
                  onTap: () {
                    // View post details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Modifiez votre StudyFlowApp pour inclure la route admin
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/student-signup': (context) => StudentSignUpPage(),
        '/company-signup': (context) => CompanySignUpPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/reset-password': (context) => ResetPasswordPage(),
        '/home': (context) => StudyFlowHome(),
        '/admin': (context) => AdminPage(), // Nouvelle route admin
      },
    );
  }
}

// Ajoutez un moyen d'accéder à la page admin depuis votre LoginPage
// Par exemple, dans votre LoginPage, ajoutez un bouton admin pour le test:
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... votre code existant ...
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin');
        },
        child: Icon(Icons.admin_panel_settings),
        tooltip: 'Admin Access',
      ),
    );
  }
}
