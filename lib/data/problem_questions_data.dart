/* 
  Untuk sekarang semua data ini local dari aplikasi karena aku belum nemu cara yang lebih efisien
  tapi kalau kaya gini nanti bakal susah waktu ada penambahan kategori karena aplikasi harus diupdate terus
  belum lagi kalau ada perubahan kata atau kalimat dari database nanti malah terjadi error
*/
class ProblemQuestions {
  // Kendaraan
  // Motor
  static const List<String> banMotor = [
    'Ban dalem',
    'Tubeless',
  ];
  static const List<String> motorMogok = [
    'Aki drop/lemah',
    'Overhead',
    'Kehabisan bensin',
    'Gak tau',
  ];
  static const List<String> kunciMotor = [
    'Biasa',
    'Keyless',
  ];
  static const List<String> motorServiceRingan = [
    'Ganti oli',
    'Tune up',
    'Ganti oli dan Tune up',
    'Inspeksi/konsultasi',
  ];
  static const List<String> cuciMotor = [
    'Cuci standar',
    'Cuci poles',
  ];
  // Mobil
  static const List<String> banMobil = [
    'Tambal',
    'Ganti ban serep',
  ];
  static const List<String> mobilMogok = [
    'Aki drop/lemah',
    'Overhead',
    'Kehabisan BBM',
    'Gak tau',
  ];
  static const List<String> kunciMobil = [
    'Biasa',
    'Keyless',
  ];
  static const List<String> mobilServiceRingan = [
    'Ganti oli',
    'Tune up',
    'Ganti oli dan Tune up',
    'Inspeksi/konsultasi',
  ];
  static const List<String> cuciMobil = [
    'Cuci standar',
    'Cuci poles',
  ];
  // Sepeda
  static const List<String> banSepeda = [
    'Ban dalem',
    'Tubeless',
  ];
  static const List<String> setelSepeda = [
    'Setel biar enak lagi',
    'Rakit sepeda baru'
  ];

  // Rumah
  static const List<String> masalahAirledeng = [
    'Toren kotor',
    'Pompa mati',
    'Air kotor/bau',
    'Air gak keluar',
    'Kran/pipa bocor',
    'Lainnya',
  ];
  static const List<String> septicTankPenuh = [
    'Tinggal sedot',
    'harus bongkar dulu'
  ];
  static const List<String> masalahListrik = [
    'Konslet',
    'Ganti lampu susah',
    'Instalasi jalur baru',
    'Lainnya',
  ];
  static const List<String> kunciRumah = [
    'Kunci biasa',
    'Kunci digital',
  ];
  static const List<String> tukangBangunan = [
    'Atap bocor',
    'Dinding rembes',
    'Ganti keramik pecah',
    'Cat ulang rumah',
    'Lainnya',
  ];

  // Elektronik
  static const List<String> masalahAC = [
    'Gak dingin',
    'Cuci biasa',
    'Bongkar/Pasang',
    'Mati',
    'Lainnya',
  ];

  static const List<String> masalahKulkas = [
    'Gak dingin',
    'Bocor',
    'Berisik',
    'Mati',
    'Lainnya',
  ];

  static const List<String> masalahMesinCuci = [
    'Pembuangan air gak keluar',
    'Berisik',
    'Mati/Error',
    'Lainnya',
  ];

  static const List<String> masalahTV = [
    'Layar mati/pecah',
    'Suara mati',
    'Mati total',
    'Laninnya',
  ];

  static const List<String> masalahLaptop = [
    'Install ulang',
    'Layar blank',
    'Keyboard rusak',
    'Lainnya',
  ];

  static const List<String> masalahHP = [
    'Kecemplung/Kehujanan',
    'Layar pecah',
    'Suara mati',
    'Mati total',
    'Lainnya',
  ];

  // Personal
  static const List<String> keseleo = [
    'Bayi',
    'Anak-anak',
    'Dewasa',
  ];

  static const List<String> genderTerapis = [
    'Pria',
    'Wanita',
  ];
}
