import 'package:bitirme_projesi/core/media_size.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:bitirme_projesi/viewmodel/home_view_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:bitirme_projesi/widget/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../widget_model/bottom_navigationvar_model.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<void> fetchAllPharmaciesFuture;

  @override
  void initState() {
    super.initState();

    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final getUserData = Provider.of<GetUserData>(context, listen: false);
    fetchAllPharmaciesFuture = homeViewModel.fetchAllPharmacies(
        getUserData.latitude, getUserData.longitude);
    homeViewModel.getPackages();
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8FB),
      body: _buildBody(context, size),
    );
  }

  Widget _buildBody(BuildContext context, ScreenSize size) {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.screenHeight * 0.01),
          _buildSearchBar(context, size),
          SizedBox(height: size.screenHeight * 0.01),
          _buildLitsView(size, homeViewModel),
          SizedBox(height: size.screenHeight * 0.02),
          _buildTextSeeAllPharmacy(size),
          SizedBox(height: size.screenHeight * 0.01),
          _buildLitsViewRow(size, homeViewModel),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ScreenSize size) {
    return Padding(
      padding: EdgeInsets.only(
          left: size.screenWidth * 0.02,
          right: size.screenWidth * 0.02,
          top: size.screenHeight * 0.012),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          onTap: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
          cursorColor: Colors.black,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.green,
            hintText: 'Eczane ara...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLitsView(ScreenSize size, HomeViewModel homeViewModel) {
    return FutureBuilder(
      future: fetchAllPharmaciesFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          // If something went wrong
          return const Center(child: Text('An error occurred!'));
        } else {
          return Padding(
            padding: EdgeInsets.only(
                left: size.screenWidth * 0.01,
                right: size.screenWidth * 0.01,
                top: size.screenHeight * 0.01),
            child: SizedBox(
              height: size.screenHeight * 0.38,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                      padding:
                          EdgeInsets.only(bottom: size.screenHeight * 0.02),
                      child: _buildItemColumn(context, index, homeViewModel));
                },
                itemCount: homeViewModel.pharmacyList.length,
              ),
            ),
          );
        }
      },
    );
  }

  Widget? _buildItemColumn(
      BuildContext context, int index, HomeViewModel homeViewModel) {
    final pharmacyViewModel =
        Provider.of<PharmacyViewDetailsViewModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Image.asset('assets/images/eczane.jpg'),
                  title: Text(
                    homeViewModel.pharmacyList[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    homeViewModel.pharmacyList[index].address,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
          Consumer<BottomNavigationBarModel>(
            builder: (context, value, child) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFFF8F8FB)),
                ),
                onPressed: () {
                  pharmacyViewModel.selectedPharmacyName =
                      homeViewModel.pharmacyList[index].name;
                  pharmacyViewModel.selectedPharmacyAddress =
                      homeViewModel.pharmacyList[index].address;
                  pharmacyViewModel.selectedPharmacyPhoneNumber =
                      homeViewModel.pharmacyList[index].phoneNumber;
                  pharmacyViewModel.selectedPharmacyId =
                      homeViewModel.pharmacyList[index].documentId;
                  Navigator.of(context).pushNamed('/pharmacyDetails');
                },
                child: const Text(
                  'Şipariş Ver',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextSeeAllPharmacy(ScreenSize size) {
    return Row(
      children: [
        SizedBox(
          width: size.screenWidth * 0.03,
        ),
        const Text(
          'Nöbetçi Eczaneler',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(
          width: size.screenWidth * 0.1,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/pharmacyOnDuty');
          },
          child: const Text(
            'Tümünü Gör',
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget _buildLitsViewRow(ScreenSize size, HomeViewModel homeViewModel) {
    return Consumer<HomeViewModel>(
      builder: (context, value, child) {
        return value.list.isEmpty
            ? SizedBox(
                height: size.screenHeight * 0.22,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildShimmerItemRow(size);
                  },
                ),
              )
            : SizedBox(
                height: size.screenHeight * 0.22,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _buildItemRow(context, index, size, homeViewModel);
                  },
                  itemCount: homeViewModel.list.length,
                ),
              );
      },
    );
  }

  Widget _buildShimmerItemRow(ScreenSize size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          SizedBox(
            width: size.screenWidth * 0.04,
          ),
          SizedBox(
            width: size.screenWidth * 0.45,
            height: size.screenHeight * 0.25,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: size.screenHeight * 0.035,
                  child: Container(
                    width: size.screenWidth * 0.45,
                    height: size.screenHeight * 0.25,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: size.screenWidth * 0.15,
                  top: 0,
                  child: Container(
                    width: size.screenWidth * 0.15,
                    height: size.screenWidth * 0.15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildItemRow(BuildContext context, int index, ScreenSize size,
      HomeViewModel homeViewModel) {
    return Row(
      children: [
        SizedBox(
          width: size.screenWidth * 0.04,
        ),
        SizedBox(
          width: size.screenWidth * 0.45,
          height: size.screenHeight * 0.25,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: size.screenHeight * 0.035,
                child: _buildProfileContainer(size, index, homeViewModel),
              ),
              Positioned(
                left: size.screenWidth * 0.15,
                top: 0,
                child: _buildCircularAvatar(size),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContainer(ScreenSize size, int index, homeViewModel) {
    return SizedBox(
      width: size.screenWidth * 0.45,
      height: size.screenHeight * 0.18,
      child: SizedBox(
        child: Stack(
          children: [
            _buildRoundedBackground(size),
            _buildPharmacyName(size, index, homeViewModel),
            _buildAdressDetails(size, index, homeViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedBackground(ScreenSize size) {
    return Positioned(
      left: 0,
      top: 0,
      child: InkWell(
        child: Container(
          width: size.screenWidth * 0.45,
          height: size.screenHeight * 0.20,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyName(ScreenSize size, index, homeViewModel) {
    return Positioned(
      left: size.screenWidth * 0.027,
      top: size.screenHeight * 0.05,
      child: Text(
        homeViewModel.list[index].isim,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: 0.20,
        ),
      ),
    );
  }

  Widget _buildAdressDetails(ScreenSize size, index, homeViewModel) {
    return Positioned(
      left: size.screenWidth * 0.027,
      top: size.screenHeight * 0.07,
      child: SizedBox(
        width: size.screenWidth * 0.4,
        child: Text(
          homeViewModel.list[index].adres,
          style: const TextStyle(
            color: Color(0xFF908F8F),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularAvatar(ScreenSize size) {
    return Container(
      width: size.screenWidth * 0.15,
      height: size.screenHeight * 0.07,
      decoration: const ShapeDecoration(
        color: Color.fromARGB(255, 77, 178, 241),
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.location_on_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildratingBar() {
    return Positioned(
      bottom: 0,
      child: RatingBar.builder(
        itemSize: 20,
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }
}
