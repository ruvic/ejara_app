import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCountryPicker extends StatefulWidget{

  double width;
  Function onChanged;

  CustomCountryPicker({Key key,this.width,this.onChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomCountryPickerState();
  }

}

class _CustomCountryPickerState extends State<CustomCountryPicker>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: CountryListPick(

          pickerBuilder: (context, CountryCode countryCode){
            return Container(
              width: widget.width,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    countryCode.flagUri,
                    package: 'country_list_pick',
                    width: 30,
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black)
                ],
              ),
            );
          },

          // Set default value
          initialSelection: '+237',
          // or
          // initialSelection: 'US'
          onChanged: (CountryCode code) {
            /*print(code.name);
              print(code.code);
              print(code.dialCode);
              print(code.flagUri);*/
            widget.onChanged(code.dialCode, code.code);
          },
          // Whether to allow the widget to set a custom UI overlay
          useUiOverlay: true,
          // Whether the country list should be wrapped in a SafeArea
          useSafeArea: false
      ),
    );
  }

}
