import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index 0 adalah halaman Home, sehingga aplikasi selalu mulai dari Home.
  int selectedIndex = 0;
  final List<int> pageHistory = [];

  final List<String> titles = [
    'Home',
    'Biodata Mahasiswa',
    'Form Nilai Mahasiswa',
    'Profil Pengguna',
  ];

  void openPage(int index) {
    if (index == selectedIndex) return;

    setState(() {
      pageHistory.add(selectedIndex);
      selectedIndex = index;
    });
  }

  void goHome() {
    if (selectedIndex == 0) return;

    setState(() {
      pageHistory.add(selectedIndex);
      selectedIndex = 0;
    });
  }

  void goBack() {
    if (pageHistory.isNotEmpty) {
      setState(() {
        selectedIndex = pageHistory.removeLast();
      });
    } else if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
    } else {
      // Ketika sudah berada di Home, minta Android menutup Activity.
      SystemNavigator.pop();
    }
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int pageIndex,
    String? imagePath,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: Colors.blue.shade50,
          backgroundImage: imagePath != null ? AssetImage(imagePath) : null,
          child: imagePath == null ? Icon(icon, color: Colors.blue) : null,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.blue),
        onTap: () => openPage(pageIndex),
      ),
    );
  }

  Widget buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/img.png',
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 190,
                color: Colors.blue.shade50,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance, size: 60, color: Colors.blue),
                      SizedBox(height: 8),
                      Text(''),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selamat Datang',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'di Aplikasi Biodata Mahasiswa',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Universitas Esa Unggul',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
        const SizedBox(height: 24),
        const Text(
          'Menu Utama',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Menu ditampilkan berurutan dari atas ke bawah.
        buildMenuCard(
          icon: Icons.badge_outlined,
          title: 'Biodata Mahasiswa',
          subtitle: 'Lihat data pribadi, pendidikan, dan pekerjaan',
          pageIndex: 1,
          imagePath: 'assets/images/foto_dadang.png',
        ),
        buildMenuCard(
          icon: Icons.assignment_outlined,
          title: 'Form Nilai Mahasiswa',
          subtitle: 'Tambah dan kelola nilai mahasiswa',
          pageIndex: 2,
        ),
        buildMenuCard(
          icon: Icons.person_outline,
          title: 'Profil Pengguna',
          subtitle: 'Lihat ringkasan profil pengguna',
          pageIndex: 3,
          imagePath: 'assets/images/foto_dadang.png',
        ),
      ],
    );
  }

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 1:
        return const BiodataPage();
      case 2:
        return const NilaiPage();
      case 3:
        return const ProfilPage();
      default:
        return buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: getCurrentPage(),

      // Tombol bawah: Home (kiri), Tutup (tengah), Back (kanan).
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: const Border(
              top: BorderSide(color: Colors.black12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  tooltip: 'Home',
                  onPressed: goHome,
                  icon: Icon(
                    Icons.home,
                    color: selectedIndex == 0 ? Colors.blue : Colors.black54,
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  tooltip: 'Tutup aplikasi',
                  onPressed: () => SystemNavigator.pop(),
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: goBack,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                    size: 28,
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

// ================= MENU 1: BIODATA =================

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  Widget sectionCard(
      String title,
      IconData icon,
      List<Widget> children,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage('assets/images/foto_dadang.png'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Dadang Darmawan',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'NIM: 20240801308',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),

        sectionCard(
          'Biodata Pribadi',
          Icons.person,
          [
            infoRow('Nama', 'Dadang Darmawan'),
            infoRow('NIM', '20240801308'),
            infoRow('Alamat', 'Jakarta Utara'),
          ],
        ),

        sectionCard(
          'Pendidikan',
          Icons.school,
          [
            infoRow('Universitas', 'Universitas Esa Unggul'),
            infoRow('Program Studi', 'Teknik Informatika'),
            infoRow('Semester', '5'),
          ],
        ),

        sectionCard(
          'Pekerjaan',
          Icons.work,
          [
            infoRow('Perusahaan', 'PT Ekamas Morarepublik Tbk'),
            infoRow('Jabatan', 'Senior Supervisor R&D'),
          ],
        ),

        sectionCard(
          'Organisasi',
          Icons.groups,
          [
            infoRow(
              'Keanggotaan',
              'Tidak mengikuti organisasi kampus',
            ),
          ],
        ),
      ],
    );
  }
}

// ================= MENU 2: DAFTAR NILAI =================

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  // Data nilai diisi langsung di kode. Ubah daftar ini jika ingin mengganti data.
  static const List<Map<String, String>> daftarNilai = [
    {
      'nama': 'Dadang Darmawan',
      'nim': '20240801308',
      'matkul': 'Pemrograman Mobile',
      'nilai': '90',
      'grade': 'A',
    },
    {
      'nama': 'Dadang Darmawan',
      'nim': '20240801308',
      'matkul': 'Kecerdasan Artifisial',
      'nilai': '82',
      'grade': 'B',
    },
    {
      'nama': 'Dadang Darmawan',
      'nim': '20240801308',
      'matkul': 'Rekayasa Kebutuhan Perangkat Lunak',
      'nilai': '88',
      'grade': 'A',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Daftar Nilai Mahasiswa',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Data nilai ditentukan langsung di dalam kode aplikasi.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ...daftarNilai.map((data) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  data['grade']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                data['matkul']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Nama: ${data['nama']}\\n'
                      'NIM: ${data['nim']}\\n'
                      'Nilai: ${data['nilai']}',
                ),
              ),
              isThreeLine: true,
              trailing: Text(
                data['nilai']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ================= MENU 3: PROFIL PENGGUNA =================

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Widget profileItem(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 28),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),

        const Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            backgroundImage: AssetImage('assets/images/foto_dadang.png'),
            onBackgroundImageError: null,
          ),
        ),

        const SizedBox(height: 16),

        const Center(
          child: Text(
            'Dadang Darmawan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 6),

        const Center(
          child: Text(
            'Mahasiswa Teknik Informatika',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Card(
          child: Column(
            children: [
              profileItem(
                Icons.badge,
                'NIM',
                '20240801308',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.school,
                'Universitas',
                'Universitas Esa Unggul',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.computer,
                'Program Studi',
                'Teknik Informatika',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.calendar_month,
                'Semester',
                '5',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.location_on,
                'Alamat',
                'Jakarta Utara',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.work,
                'Pekerjaan',
                'Senior Supervisor R&D',
              ),
              const Divider(height: 1),
              profileItem(
                Icons.business,
                'Perusahaan',
                'PT Ekamas Morarepublik Tbk',
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Center(
          child: Text(
            'Aplikasi Biodata Mahasiswa Flutter',
            style: TextStyle(color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
