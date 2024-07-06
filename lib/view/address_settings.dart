import 'dart:async';

import 'package:bitirme_projesi/viewmodel/address_view_model.dart';
import 'package:bitirme_projesi/widget/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddressSetting extends StatefulWidget {
  Function? mergeAddress;
  AddressSetting({super.key, this.mergeAddress});

  @override
  _AddressSettingState createState() => _AddressSettingState();
}

class _AddressSettingState extends State<AddressSetting> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressSettingModel>(context, listen: false)
          .findUserLocation();
    });
  }

  @override
  void dispose() {
    AddressSettingModel address =
        Provider.of<AddressSettingModel>(context, listen: false);
    address.mapController.dispose();
    address.markers.clear();
    address.selectedAddress = '';
    super.dispose();
  }

  // Initial marker location
  @override
  Widget build(BuildContext context) {
    return Consumer<AddressSettingModel>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Adres Seçimi'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      zoomControlsEnabled: false,
                      onCameraMove: (CameraPosition position) {
                        value.markerLocation = position.target;
                      },
                      onCameraIdle: () async {
                        if (!value.isBottomSheetShown) {
                          Timer(const Duration(milliseconds: 1000), () async {
                            await value.findAddress(value.markerLocation);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                value.isBottomSheetShown = true;
                                return BottomSheetCustom(
                                  mergeAddress: () {
                                    widget.mergeAddress!(value.selectedAddress);
                                  },
                                );
                              },
                            ).whenComplete(
                                () => value.isBottomSheetShown = false);
                          });
                        }
                      },
                      onMapCreated: (controller) =>
                          value.mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: value.markerLocation,
                        zoom: 12,
                      ),
                      markers: value.markers,
                    ),
                    const Center(
                        child: Icon(
                      Icons.location_on,
                      size: 50.0,
                      color: Colors.red,
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
