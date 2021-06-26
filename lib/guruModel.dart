import 'package:flutter/material.dart';
import 'package:sekolah/main.dart';

class DataGuru {
  String id;
  String nip;
  String nama;
  String pelajaran;
  String nohp;

  DataGuru({this.id, this.nip, this.nama, this.pelajaran, this.nohp});

  factory DataGuru.fromJson(Map<String, dynamic> json) => DataGuru(
        id: json['id'],
        nama: json['guru_nama'],
        nip: json['guru_nip'],
        pelajaran: json['guru_pelajaran'],
        nohp: json['no_hp'],
      );
}
