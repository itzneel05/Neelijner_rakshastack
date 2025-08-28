import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  bool isChecked = false; 
  bool _obscurePassword = true; 
  bool _obscureConfirmPassword = true; 
  final _formKey = GlobalKey<FormBuilderState>(); 
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> _saveUserToFirestore(
    String authUid,
    String fullname,
    String email,
  ) async {
    await _firestore.collection('users').doc(authUid).set({
      'authUid': authUid,
      'fullName': fullname,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'phoneNumber': null,
      'location': {
        'label': null, 
        'city': null,
        'state': null,
        'coords': null, 
      },
    });
  }
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to Terms & Conditions')),
        );
        return;
      }
      final String fullname = _fullnameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        final String authUid =
            userCredential.user?.uid ?? ''; 
        await userCredential.user?.updateDisplayName(
          fullname,
        ); 
        await _saveUserToFirestore(
          authUid,
          fullname,
          email,
        ); 
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please log in.'),
            ),
          );
          Navigator.pushReplacement(context, fadeAnimatedRoute(const Login()));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'weak-password': 
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use': 
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email': 
            errorMessage = 'The email address is invalid.';
            break;
          default:
            errorMessage = 'An error occurred: ${e.message}';
        }
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 201, 226, 253),
              Color.fromARGB(255, 218, 222, 225),
            ],
            stops: [0.0, 0.8],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors
              .transparent, 
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(24),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Create Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 28),
                        FormBuilderTextField(
                          controller: _fullnameController,
                          name: 'fullname',
                          decoration: InputDecoration(
                            labelText: 'Enter Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        const SizedBox(height: 14),
                        FormBuilderTextField(
                          controller: _emailController,
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        const SizedBox(height: 14),
                        FormBuilderTextField(
                          controller: _passwordController,
                          name: 'password',
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color.fromARGB(255, 95, 100, 110),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(
                              8,
                              errorText:
                                  'Password must be at least 8 characters',
                            ),
                          ]),
                        ),
                        const SizedBox(height: 14),
                        FormBuilderTextField(
                          controller: _confirmPasswordController,
                          name: 'confirmpassword',
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color.fromARGB(255, 95, 100, 110),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(
                              8,
                              errorText:
                                  'Password must be at least 8 characters',
                            ),
                            (value) {
                              final password = _formKey
                                  .currentState
                                  ?.fields['password']
                                  ?.value;
                              return value == password
                                  ? null
                                  : 'Passwords do not match';
                            },
                          ]),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() => isChecked = value!);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text("I Agree To Terms & Conditons"),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              _signUp();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                36,
                                141,
                                245,
                              ),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF223142),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  fadeAnimatedRoute(Login()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 79, 143, 234),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

