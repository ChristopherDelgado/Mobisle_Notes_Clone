import 'package:flutter/material.dart';
import 'authenticate.dart';

class Login extends StatefulWidget {
  // required because we cannot allow a null value
  Login({required this.auth, required this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginState();

}
enum FormType {
  login,
  register
}
class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  FormType _formType = FormType.login;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if(form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async{
    if(_validateAndSave()) {
      try {
        if(_formType == FormType.login) {
          String userID = await widget.auth
              .signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userID');
        } else {
            String userID = await widget.auth
                .createUserWithEmailAndPassword(_email, _password);
            print('Registered user: $userID');
        }
        widget.onSignedIn();
      } catch(error) {
        print('Error: $error');
      }
    }
  }

  void _moveToRegister() {
    // resetting our form
    _formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void _moveToLogin() {
    // resetting our form
    _formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 101, 198, 0),
        title: Text('Mobisle Notes'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color.fromARGB(255, 101, 198, 0),
        constraints: BoxConstraints.expand(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset('assets/logo.jpg', width: 150, height: 150, fit: BoxFit.fill,)
      ),
      Padding(
        padding: EdgeInsets.only(right: 25, left: 25, top: 15),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',),
          validator: (value) => value!.isEmpty ? "Email can't be empty" : null,
          onSaved: (value) => _email = value!,
          style: TextStyle(color: Colors.white),
        ),),
      Padding(
        padding: EdgeInsets.only(right: 25, left: 25),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',),
          validator: (value) => value!.isEmpty ? "Password can't be empty" : null,
          onSaved: (value) => _password = value!,
          style: TextStyle(color: Colors.white),
          obscureText: true,
        ),),
    ];
  }

  List<Widget> buildButtons() {
   if(_formType == FormType.login) {
     return [
       Padding(
         padding: EdgeInsets.only(right: 25, left: 25, top: 15),
         child: ElevatedButton(
             onPressed: _validateAndSubmit,
             child: Text('Sign In'),
         style: ElevatedButton.styleFrom(
             minimumSize: Size(double.infinity, 35)),),
       ),
       Padding(
         padding: EdgeInsets.only(right: 25, left: 25, top: 5),
         child: TextButton(
             onPressed: _moveToRegister,
             child: Text('Create Account',
               style: TextStyle(color: Colors.white),)),
       )
     ];
   }
   else {
     return [
       Padding(
         padding: EdgeInsets.only(right: 25, left: 25, top: 15),
         child: ElevatedButton(
             onPressed: _validateAndSubmit,
             child: Text('Create Account'),
             style: ElevatedButton.styleFrom(
         minimumSize: Size(double.infinity, 35)),),
       ),
       Padding(
         padding: EdgeInsets.only(right: 25, left: 25, top: 5),
         child: TextButton(
             onPressed: _moveToLogin,
             child: Text('Already have an account? Log in',
               style: TextStyle(color: Colors.white),)),
       )
     ];
   }
  }
}