import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:bitirme_projesi/model/package_model.dart';
import 'package:flutter/material.dart';

class ScrapperService {
  static List<PackageModel> run(String html) {
    try {
      List<PackageModel> packages = [];
      final soup = BeautifulSoup(html);
      final specificDiv =
          soup.find('div', attrs: {'aria-labelledby': 'nav-bugun-tab'});
      if (specificDiv != null) {
        final allFind = specificDiv
            .findAll('td', attrs: {'colspan': '3', 'class': 'border-bottom'});
        for (var item in allFind) {
          final isim =
              item.find('span', class_: 'isim')?.text ?? 'isim bulunamadı';
          final address = item.find('div', class_: 'col-lg-6');
          String adres = '';
          if (address != null) {
            // Inner HTML'den iç div'leri çıkararak metni alma
            final innerHtml = address.innerHtml;
            final innerSoup = BeautifulSoup(innerHtml);
            innerSoup.findAll('div').forEach((element) => element.extract());
            adres = innerSoup.text.trim();
          } else {
            adres = 'adres bulunamadı';
          }
          final adresDiv = item.find('div', class_: 'col-lg-6');
          String adresTarifi = '';
          if (adresDiv != null) {
            // Inner HTML'den iç div'leri çıkararak metni alma
            final innerHtml = adresDiv.innerHtml;
            final innerSoup = BeautifulSoup(innerHtml);
            innerSoup.findAll('div').forEach((element) => element.extract());
            adresTarifi = innerSoup.text
                .replaceAll(RegExp(r'\([^()]*\)\s*|».*$'), '')
                .trim();
            
          } else {
            adresTarifi = 'adres bulunamadı';
          }

          final ilce = item
                  .find('span',
                      class_:
                          'px-2 py-1 rounded bg-info text-white font-weight-bold')
                  ?.text ??
              'ilçe bulunamadı';
          final telefon = item.find('div', class_: 'col-lg-3 py-lg-2')?.text ??
              'telefon numarası bulunamadı';
          PackageModel model = PackageModel(
              isim: isim,
              adres: adres,
              ilce: ilce,
              telefon: telefon,
              adresTarifi: adresTarifi);
          packages.add(model);
        }

        return packages;
      } else {
        debugPrint('Specific div not found');
      }
    } catch (e) {
      debugPrint('ScrapperService =>  $e');
    }
    return [];
  }
}
