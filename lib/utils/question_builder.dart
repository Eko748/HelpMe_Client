import '../data/problem_questions_data.dart';

// TODO: Implementasi untuk kategori masalah baru di sini
List<String?> questionsBuilder(
  String problemName,
  List<String> questionChoices,
) {
  // Kendaraan
  // Motor
  if (problemName.toLowerCase().contains('ban motor')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.banMotor);
    return ['Jenis bannya apa?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('motor mogok')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.motorMogok);
    return ['Kenapa mogoknya?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('kunci motor')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.kunciMotor);
    return ['Jenis kuncinya apa?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('motor perlu service')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.motorServiceRingan);
    return ['Jenis service', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('motor perlu dicuci')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.cuciMotor);
    return ['Pilihan cuci', 'Fotoin kendaraannya'];
  }
  // Mobil
  if (problemName.toLowerCase().contains('ban mobil')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.banMobil);
    return ['Jenis service?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('mobil mogok')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.mobilMogok);
    return ['Kenapa mogoknya?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('kunci mobil')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.kunciMobil);
    return ['Jenis kuncinya apa?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('mobil perlu service')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.mobilServiceRingan);
    return ['Jenis service', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('mobil perlu dicuci')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.cuciMobil);
    return ['Pilihan cuci', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('ac mobil')) {
    return [null, 'Fotoin kendaraannya'];
  }
  // Sepeda
  if (problemName.toLowerCase().contains('ban sepeda')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.banSepeda);
    return ['Jenis bannya apa?', 'Fotoin kendaraannya'];
  }
  if (problemName.toLowerCase().contains('setel sepeda')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.setelSepeda);
    return ['Pilih jenis servicenya', 'Fotoin kendaraannya'];
  }

  // Bantuan rumah
  if (problemName.toLowerCase().contains('masalah air')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahAirledeng);
    return ['Masalahnya apa?', 'Fotoin masalahnya'];
  }
  if (problemName.toLowerCase().contains('septic tank penuh')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.septicTankPenuh);
    return ['Posisi sepric tanknya bagaimana?', 'Fotoin masalahnya'];
  }
  if (problemName.toLowerCase().contains('masalah listrik')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahListrik);
    return ['Masalahnya apa?', 'Fotoin masalahnya'];
  }
  if (problemName.toLowerCase().contains('kunci rumah hilang')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.kunciRumah);
    return ['Jenis kuncinya apa?', 'Fotoin masalahnya'];
  }
  if (problemName.toLowerCase().contains('panggil tukang bangunan')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.tukangBangunan);
    return ['Masalahnya apa?', 'Fotoin masalahnya'];
  }

  // Bantuan elektronik
  if (problemName.toLowerCase().contains('masalah ac')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahAC);
    return ['Kenapa AC nya?', 'Fotoin AC nya'];
  }
  if (problemName.toLowerCase().contains('masalah kulkas')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahKulkas);
    return ['Kenapa kulkas nya?', 'Fotoin kulkas nya'];
  }
  if (problemName.toLowerCase().contains('masalah Mesin Cuci')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahMesinCuci);
    return ['Kenapa Mesin Cuci nya?', 'Fotoin Mesin Cuci nya'];
  }
  if (problemName.toLowerCase().contains('masalah tv')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahTV);
    return ['Kenapa TV nya?', 'Fotoin TV nya'];
  }
  if (problemName.toLowerCase().contains('masalah laptop')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahLaptop);
    return ['Kenapa laptop nya?', 'Fotoin laptop nya'];
  }
  if (problemName.toLowerCase().contains('masalah hp')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.masalahHP);
    return ['Kenapa HP nya?', 'Fotoin HP nya'];
  }

  // Serabutan
  if (problemName.toLowerCase().contains('keseleo')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.keseleo);
    return ['Kategori usia', 'Fotoin masalahnya'];
  }
  if (problemName.toLowerCase().contains('butuh pijet')) {
    questionChoices.clear;
    questionChoices.addAll(ProblemQuestions.genderTerapis);
    return ['Gender terapis'];
  }
  if (problemName.toLowerCase().contains('lainnya')) {
    return ['Kasih tau kami apa masalahmu', 'Fotoin masalahnya\n*Opsional'];
  }

  return [];
}
