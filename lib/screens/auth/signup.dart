import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // RegEx for a standard email format
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If valid, proceed to Firebase Auth
      print("Form is valid! Registering ${_emailController.text}");
    }
  }

  // Local state for password toggles
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;

  // Controllers for Auth and Firestore Profile
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.bgColor,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 60.0,
              bottom: 40.0,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KigaliApp.primaryTeal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Text(
                  "Join Kigali City Services Directory",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Full Name
                _buildTextFormField(
                  label: "Full Name",
                  icon: Icons.person_outline,
                  hint: "John Doe",
                  controller: _nameController,
                ),
                const SizedBox(height: 16),

                // Email Address
                _buildTextFormField(
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  hint: "you@example.com",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Email is required";
                    if (!emailRegex.hasMatch(value))
                      return "Enter a valid email address";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                _buildTextFormField(
                  label: "Password",
                  icon: Icons.lock_outline,
                  hint: "••••••••",
                  isPassword: _isPasswordObscured,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return "Password must be 6+ characters";
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordObscured = !_isPasswordObscured,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                _buildTextFormField(
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  hint: "••••••••",
                  isPassword: _isConfirmObscured,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return "Password must be 6+ characters";
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _isConfirmObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(
                      () => _isConfirmObscured = !_isConfirmObscured,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KigaliApp.primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Back to Login Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: KigaliApp.primaryTeal,
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
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isPassword = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
