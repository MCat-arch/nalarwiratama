import 'package:flutter/material.dart';
import 'package:frontend/views/pages/login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5DC), // Background warna krem muda
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gambar header
              SizedBox(
                height: 400,
                width: double.infinity,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('/images/img_dip.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Konten
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(minHeight: screenHeight * 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gambar gulungan dengan teks
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('/images/roll.png', height: 150),
                            Center(
                              child: const Text(
                                'NALARWIRATAMA',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kalimat deskripsi
                      const Column(
                        children: [
                          Text(
                            'JADILAH BAGIAN DALAM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'PERTARUNGAN STRATEGI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'PERANG DIPONEGORO',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Tombol Daftar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman home
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD2691E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'DAFTAR SEKARANG',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Teks Login
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman login
                        },
                        child: const Text(
                          'SUDAH MEMILIKI AKUN? MASUK',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
