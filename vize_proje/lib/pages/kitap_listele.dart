import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'kitap_ekle.dart';
import '../services/firestore.dart';


class KitapListesiSayfasi extends StatefulWidget {
  @override
  _KitapListesiSayfasiState createState() => _KitapListesiSayfasiState();
}

class _KitapListesiSayfasiState extends State<KitapListesiSayfasi> {

  final _fireStoreService = FireStoreService();
  Stream<QuerySnapshot> stream = FireStoreService.listede_yayinlanacak_kitaplar.snapshots(); 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kerem Mert İzmir Kütüphane Yönetim Sistemi"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(  
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  leading: Text(doc['ad']),
                  title: Text(doc['yazarlar']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //Güncelleme işlemi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KitapEkleSayfasi(
                                kitap_adi: doc['ad'],
                                yayin_evi: doc['yayin_evi'],
                                yazar: doc['yazarlar'],
                                sayfa_sayisi: doc['sayfa_sayisi'],
                                kategori: doc['kategori'],
                                basim_yili: doc['basim_yili'],
                                isChecked: doc['listede_yayinla'],
                                isUpdating: true,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //Silme işlemi
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Silmek istediğinize emin misiniz?"),
                                actions: [
                                  TextButton(
                                    child: Text("İptal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Sil"),
                                    onPressed: () {
                                      print(doc.id);
                                      _fireStoreService.kitapSil(
                                        doc.id
                                        );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //Ekleme işlemi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KitapEkleSayfasi(
                kitap_adi: "",
                yayin_evi: "",
                yazar: "",
                sayfa_sayisi: 0,
                kategori: "Roman",
                basim_yili: 0,
                isChecked: true,
                isUpdating: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
