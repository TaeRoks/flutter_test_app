import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isSending = false;
  String _responseMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {
              _isButtonEnabled = _formKey.currentState?.validate() ?? false;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Message is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _postForm : null,
                child: _isSending ? Text('Please Wait...') : Text('Send'),
              ),
              SizedBox(height: 10.0),
              Text(_responseMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  _postForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonEnabled = false;
        _isSending = true;
        _responseMessage = '';
      });
      var response = await http
          .post(Uri.parse('https://api.byteplex.info/api/test/contact'), body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "message": _messageController.text
      });

      setState(() {
        _isSending = false;
        _isButtonEnabled = true;
        _responseMessage = response.statusCode == 201
            ? 'Form submitted successfully'
            : 'Error: Server response ${response.statusCode}';
      });
    }
  }
}
