import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modul 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

// MAIN PAGE - Tab navigation 4 percobaan
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Modul 6'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'P1: GridView'),
              Tab(text: 'P2: ListView'),
              Tab(text: 'P3: GridView.builder'),
              Tab(text: 'P4: ListView.builder'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Percobaan1GridView(),
            Percobaan2ListView(),
            Percobaan3GridViewBuilder(),
            Percobaan4ListViewBuilder(),
          ],
        ),
      ),
    );
  }
}

// PERCOBAAN 1 - GridView
class Percobaan1GridView extends StatelessWidget {
  const Percobaan1GridView({super.key});

  ClipRRect tile(Color warnaKotak, String gambar, String judul) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: warnaKotak,
        child: GridTile(
          footer: SizedBox(
            height: 45,
            child: GridTileBar(
              backgroundColor: Colors.black38,
              title: Text(
                judul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: Image.asset(gambar, scale: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        tile(Colors.blueAccent.shade400, 'assets/icons/boy.png', 'Kehadiran'),
        tile(Colors.greenAccent.shade400, 'assets/icons/timetable.png', 'Jadwal Kuliah'),
        tile(Colors.yellowAccent.shade400, 'assets/icons/homeschooling.png', 'Tugas'),
        tile(Colors.redAccent.shade400, 'assets/icons/clipboard.png', 'Pengumuman'),
        tile(Colors.purpleAccent.shade400, 'assets/icons/marks.png', 'Nilai'),
        tile(Colors.tealAccent.shade400, 'assets/icons/pencil.png', 'Catatan'),
      ],
    );
  }
}

// PERCOBAAN 2 - ListView
class Percobaan2ListView extends StatelessWidget {
  const Percobaan2ListView({super.key});

  Container listTile(
    Color warna,
    Color warnaAvatar,
    String judul,
    String subjudul,
    String gambar,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: warna,
        title: Text(
          judul,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subjudul,
          style: const TextStyle(fontSize: 16),
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: warnaAvatar,
          child: Image.asset(gambar, width: 35, height: 35),
        ),
        trailing: Icon(Icons.star, color: Colors.orangeAccent.shade400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        listTile(Colors.blueAccent.shade400, Colors.greenAccent.shade400,
            'Kehadiran', 'Presensi kehadiran kuliah', 'assets/icons/boy.png'),
        listTile(Colors.greenAccent.shade400, Colors.blueAccent.shade400,
            'Jadwal', 'Jadwal perkuliahan', 'assets/icons/timetable.png'),
        listTile(Colors.yellowAccent.shade400, Colors.redAccent.shade400,
            'Tugas', 'Tugas perkuliahan di luar kelas', 'assets/icons/homeschooling.png'),
        listTile(Colors.redAccent.shade400, Colors.amberAccent.shade400,
            'Pengumuman', 'Informasi terkait perkuliahan', 'assets/icons/clipboard.png'),
        listTile(Colors.purpleAccent.shade400, Colors.tealAccent.shade400,
            'Nilai', 'Nilai ujian dan tugas', 'assets/icons/marks.png'),
        listTile(Colors.tealAccent.shade400, Colors.purpleAccent.shade400,
            'Catatan', 'Pengingat kegiatan perkuliahan', 'assets/icons/pencil.png'),
      ],
    );
  }
}

// PERCOBAAN 3 - GridView.builder (API)
class Percobaan3GridViewBuilder extends StatefulWidget {
  const Percobaan3GridViewBuilder({super.key});

  @override
  State<Percobaan3GridViewBuilder> createState() =>
      _Percobaan3GridViewBuilderState();
}

class _Percobaan3GridViewBuilderState
    extends State<Percobaan3GridViewBuilder> {
  List dataBerita = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jakpost.vercel.app/api/category/business/tech'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dataBerita = data['posts'];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: dataBerita.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GridTile(
              footer: SizedBox(
                height: 65,
                child: GridTileBar(
                  backgroundColor: Colors.black26.withAlpha(175),
                  title: Text(
                    dataBerita[index]['title'] ?? 'Tanpa judul',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              child: Image(
                image: NetworkImage(
                  dataBerita[index]['image'] ??
                      'http://cdn.pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

// PERCOBAAN 4 - ListView.builder (API)
class Percobaan4ListViewBuilder extends StatefulWidget {
  const Percobaan4ListViewBuilder({super.key});

  @override
  State<Percobaan4ListViewBuilder> createState() =>
      _Percobaan4ListViewBuilderState();
}

class _Percobaan4ListViewBuilderState
    extends State<Percobaan4ListViewBuilder> {
  List dataBerita = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jakpost.vercel.app/api/category/business/tech'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dataBerita = data['posts'];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    return ListView.builder(
      itemCount: dataBerita.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(
                dataBerita[index]['title'] ?? 'Tidak ada judul',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                dataBerita[index]['published_at'] ?? 'Tidak ada data',
                maxLines: 1,
                style: const TextStyle(fontSize: 16),
              ),
              leading: Image.network(
                dataBerita[index]['image'] ??
                    'http://cdn.pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
                fit: BoxFit.cover,
                width: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}
