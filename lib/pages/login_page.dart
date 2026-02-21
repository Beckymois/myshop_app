import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  // Kredansyal administratè a sèlman
  final String _adminEmail = 'admin@store.com';
  final String _adminPassword = 'Admin@2024';

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);

        if (_emailController.text == _adminEmail &&
            _passwordController.text == _adminPassword) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _showErrorDialog('Email ou mot de passe incorrècte');
        }
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur de connexion'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mot de passe oublié'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Veuillez contacter le service informatique pour réinitialiser votre mot de passe.',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email support',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Text(
                          'support@store.com',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============ ESPAS POU LOGO OU ============
  Widget _buildMyLogo() {
    return Image.asset(
      'assets/images/logo_jk.png',  // Chanje non logo ou a
      width: 300,
      height: 300,
      fit: BoxFit.contain,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // ============ ESPAS POU LOGO OU ============
                _buildMyLogo(),  // <--- MET PROP LOGO OU ISIT LA

                const SizedBox(height: 50),

                const Text(
                  'JK Store',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Espace réservé à l\'administrateur',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 49),

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email administrateur',
                    hintText: 'admin@store.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email obligatoire';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Format email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mot de passe obligatoire';
                    }
                    if (value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Lien mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton connexion
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SE CONNECTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Enfòmasyon sekirite
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.blue.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.blue.shade200),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.security,
                //         color: Colors.blue.shade700,
                //         size: 24,
                //       ),
                //       const SizedBox(width: 12),
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             // Text(
                //             //   'Accès restreint',
                //             //   style: TextStyle(
                //             //     fontWeight: FontWeight.bold,
                //             //     color: Colors.blue.shade700,
                //             //   ),
                //             // ),
                //             const SizedBox(height: 4),
                //             // Text(
                //             //   'Cette section est réservée à l\'administrateur uniquement',
                //             //   style: TextStyle(
                //             //     fontSize: 12,
                //             //     color: Colors.grey.shade600,
                //             //   ),
                //             // ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}