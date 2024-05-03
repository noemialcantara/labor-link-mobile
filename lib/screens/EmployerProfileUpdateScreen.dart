import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/models/Employer.dart';

class EmployerProfileUpdateScreen extends StatefulWidget {
  final Employer? employerData;
  EmployerProfileUpdateScreen({Key? key, required this.employerData}) : super(key: key);

  @override
  State<EmployerProfileUpdateScreen> createState() => _EmployerProfileUpdateScreenState();
}

class _EmployerProfileUpdateScreenState extends State<EmployerProfileUpdateScreen> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyAboutController = TextEditingController();
  TextEditingController companySizeController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  _getProfileData(){
    setState(() {
      companyNameController.text = widget.employerData!.employerName.toString();
      addressController.text = widget.employerData!.employerAddress.toString();
      companyAboutController.text = widget.employerData!.employerAbout.toString();
      companySizeController.text = widget.employerData!.companySize.toString();
      industryController.text = widget.employerData!.industry.toString();
      phoneNumberController.text = widget.employerData!.phone.toString();
    });
  }

  void updateProfile(){
    Employer employerData = Employer(
      companyNameController.text,
      addressController.text,
      widget.employerData!.emailAddress,
      companyAboutController.text,
      widget.employerData!.logoUrl,
      industryController.text,
      '',
      '',
      companySizeController.text,
      phoneNumberController.text,
    );

    UsersApi.updateEmployerProfile(employerData.toJson());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully updated your profile',
      btnOkOnPress: () {
          Navigator.pop(context);
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Update Employer Profile", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  body: SingleChildScrollView(
                      child: Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:30),
                          Text('Company Name',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: companyNameController,
                            hintText: 'Enter company name',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          Text('Company Address',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: addressController,
                            hintText: 'Enter complete address',
                            obscureText: false
                          ),
                          SizedBox(height: 20),
                          Text('Company About',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: companyAboutController,
                            hintText: 'Enter company about',
                            obscureText: false,
                            maxLines: 6,
                          ),
                          SizedBox(height: 20),
                          Text('Company Size',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: companySizeController,
                            hintText: 'Enter company size',
                            obscureText: false,
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text('Industry',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: industryController,
                            hintText: 'Enter industry',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          Text('Phone Number',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: phoneNumberController,
                            hintText: 'Enter phone number',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          
                          SizedBox(height: 30),
                          CustomButton(
                            text: "Update",
                            onTap: () {
                              updateProfile();
                            },
                          ),
                          SizedBox(height: 50),
                         
                        ]
                      )),
                  )
    );
  }
}
