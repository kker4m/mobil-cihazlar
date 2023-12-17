import 'package:flutter/material.dart';

import '../services/firestore.dart';

class KitapEkleSayfasi extends StatefulWidget {
  final String kitap_adi;
  final String yazar;
  final String yayin_evi;
  final int sayfa_sayisi;
  final int basim_yili;
  final String kategori;
  final bool isChecked;
  final bool isUpdating;

  KitapEkleSayfasi({
    required this.kitap_adi,
    required this.yazar,
    required this.yayin_evi,
    required this.sayfa_sayisi,
    required this.kategori,
    required this.basim_yili,
    required this.isChecked,
    required this.isUpdating,
  });

  @override
  // ignore: no_logic_in_create_state
  _KitapEkleSayfasiState createState() => _KitapEkleSayfasiState(
    kitap_adi_text: kitap_adi,
    yazar_text: yazar,
    yayin_evi_text: yayin_evi,
    sayfa_sayisi_text: sayfa_sayisi,
    kategori_text: kategori,
    basim_yili_text: basim_yili,
    isUpdating: isUpdating,
  );
}


class _KitapEkleSayfasiState extends State<KitapEkleSayfasi> {
  final kitap_adi = TextEditingController();
  final yayin_evi = TextEditingController();
  final yazar = TextEditingController();
  final kategori = TextEditingController();
  final sayfa_sayisi = TextEditingController();
  final basim_yili = TextEditingController();
  
  final String kitap_adi_text;
  final String yazar_text;
  final String yayin_evi_text;
  final int sayfa_sayisi_text;
  final int basim_yili_text;
  final String kategori_text;
  final bool isUpdating;
  bool isChecked=false;

  _KitapEkleSayfasiState({
    required this.kitap_adi_text,
    required this.yazar_text,
    required this.yayin_evi_text,
    required this.sayfa_sayisi_text,
    required this.kategori_text,
    required this.basim_yili_text,
    required this.isUpdating,
  });
  String? idString;
  @override
  void initState() {
    super.initState();

    // controller'ı başlatın
    kitap_adi.text = kitap_adi_text;
    yayin_evi.text = yayin_evi_text;
    yazar.text = yazar_text;
    kategori.text = kategori_text;
    sayfa_sayisi.text = sayfa_sayisi_text.toString();
    basim_yili.text = basim_yili_text.toString();
    if (isUpdating){
      idString = idBul().toString();
      print(idString);
    }
    else{
      idString="";
    }
  }

  //async id bulma metodu
  Future<String> idBul() async{
    final Future<String> idFuture = FireStoreService.kitaplar
          .where('ad', isEqualTo: kitap_adi_text)
          .where('yayin_evi', isEqualTo: yayin_evi_text)
          .where('yazarlar', isEqualTo: yazar_text)
          .where('kategori', isEqualTo: kategori_text)
          .where('sayfa_sayisi', isEqualTo: int.parse(sayfa_sayisi_text.toString()))
          .where('basim_yili', isEqualTo: int.parse(basim_yili_text.toString()))
          .get()
          .then((value) => value.docs[0].id);

        idFuture.then((value) => idString = value);
        
        return idString ?? "";
  }
  
  final _fireStoreService = FireStoreService();

  void clearText(){
    kitap_adi.clear();
      yayin_evi.clear();
      yazar.clear();
      kategori.clear();
      sayfa_sayisi.clear();
      basim_yili.clear();
      isChecked = false;
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Kitap Adı",
              ),
              controller: kitap_adi,
              
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Yayınevi",
              ),
              controller: yayin_evi,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Yazarlar",
              ),
              controller: yazar,
            ),
            DropdownButtonFormField(
              onChanged: (value) {
                kategori.text = value.toString();
              },
              items: [
                DropdownMenuItem(
                  child: Text("Roman"),
                  value: "Roman",
                ),
                DropdownMenuItem(
                  child: Text("Tarih"),
                  value: "Tarih",
                ),
                DropdownMenuItem(
                  child: Text("Edebiyat"),
                  value: "Edebiyat",
                ),
                DropdownMenuItem(
                  child: Text("Şiir"),
                  value: "Şiir",
                ),
                DropdownMenuItem(
                  child: Text("Ansiklopedi"),
                  value: "Ansiklopedi",
                ),
                DropdownMenuItem(
                  child: Text("Biyografi"),
                  value: "Biyografi",
                ),
                DropdownMenuItem(
                  child: Text("Aşk Romanı"),
                  value: "Aşk Romanı",
                ),
              ],
              value: "Roman",
              decoration: InputDecoration(
                labelText: "Kategori",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Sayfa Sayısı",
              ),
              keyboardType: TextInputType.number,
              controller: sayfa_sayisi,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Basım Yılı",
              ),
              keyboardType: TextInputType.number,
              controller: basim_yili,
            ),
            CheckboxListTile(
              title: Text("Listede Yayınlanacak mı?"),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            ElevatedButton(
              child: Text("Kaydet"),
              onPressed: () {
                //Kaydet
                if(isUpdating){
                  _fireStoreService.kitapGuncelle(
                    idString ?? "",
                    kitap_adi.text ?? "",
                    yayin_evi.text ?? "",
                    yazar.text ?? "",
                    kategori.text ?? "",
                    int.tryParse(sayfa_sayisi.text) ?? 0,
                    int.tryParse(basim_yili.text) ?? 0,
                    isChecked ?? false
                    );
                }
                else{
                  _fireStoreService.kitapEkle(
                    kitap_adi.text ?? "", 
                    yayin_evi.text ?? "",
                    yazar.text ?? "",
                    kategori.text ?? "",
                    int.tryParse(sayfa_sayisi.text) ?? 0,
                    int.tryParse(basim_yili.text) ?? 0,
                    isChecked ?? false
                    );
                }
                if(isUpdating){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Kitap Güncellendi"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tamam"),
                        ),
                      ],
                    )
                  );
                }
                else{
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Kitap Eklendi"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tamam"),
                        ),
                      ],
                    )
                  );
                }
                //Tum alanlari temizle
                clearText();
              },
            ),
          ],
        ),
      ),
    );
  }
}
