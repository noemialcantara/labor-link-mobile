import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:labor_link_mobile/apis/SubscribersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Subscriber.dart';
import 'package:labor_link_mobile/models/SubscriptionPlan.dart';
import 'package:labor_link_mobile/screens/EmployerSubscriptionManagementScreen.dart';
import 'package:labor_link_mobile/screens/EmployerSubscriptionScreen.dart';
import 'package:uuid/uuid.dart';

class CreditCardPaymentScreen extends StatefulWidget {
  late SubscriptionPlan subscriptionPlan;
  CreditCardPaymentScreen({super.key, required this.subscriptionPlan});

  @override
  State<StatefulWidget> createState() => CreditCardPaymentScreenState();
}

class CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  bool isLightTheme = true;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                leading: BackButton(
                  onPressed: () {
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EmployerSubscriptionScreen()));
                  },
                ),
                iconTheme: IconThemeData( color: Colors. black,size: 30 ), title: Text(widget.subscriptionPlan.planName, style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
               
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(
                    'assets/icons/bg-light.png'
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height:30),
                    // Padding(
                    //   padding: EdgeInsets.only(left:20, right: 20),
                    //   child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () => Navigator.pop(context),
                    //       child: Icon(Icons.arrow_back, size: 30,),
                    //     ),
                    // ],)),
                    // SizedBox(height:20),
                    CreditCardWidget(
                      enableFloatingCard: useFloatingAnimation,
                      glassmorphismConfig: _getGlassmorphismConfig(),
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      bankName: 'Credit Card',
                      frontCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      backCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: isLightTheme
                          ? Color(0xff39373b)
                          : Color(0xff39373b),
                      backgroundImage:
                          useBackgroundImage ? 'assets/card_bg.png' : null,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            'assets/icons/mastercard.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration:  InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Number',
                                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  labelText: 'Card Holder',
                                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            const SizedBox(height: 20),
                            
                                Padding(
                                  padding: EdgeInsets.only(left:20,right:20,bottom:25),
                                  child: CustomButton(
                                  text: "Pay Now",
                                  onTap: _onValidate)),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
       AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Congratulations!',
        desc: 'You have now subscribed to the application!',
        btnOkOnPress: () {
          DateTime now = DateTime.now();
          DateTime nextDuration = DateTime.now();
          if(widget.subscriptionPlan.duration == "monthly"){
            nextDuration = nextDuration.add(Duration(days: 30));
          }else{
            nextDuration = nextDuration.add(Duration(days: 365));
          }
          DateFormat format = DateFormat('yyyy-MM-dd kk:mm:ss');
          String formattedDateNow = format.format(now);
          String formattedDateNextDuration = format.format(nextDuration);
          String subscriptionId =  Uuid().v4();

          Subscriber subscriptionPayload = Subscriber(widget.subscriptionPlan.duration, FirebaseAuth.instance.currentUser?.email ?? "", widget.subscriptionPlan.price,widget.subscriptionPlan.planName + " Premium",formattedDateNow, formattedDateNextDuration, "false", subscriptionId, Timestamp.now());
          SubscribersApi.addSubscription(subscriptionPayload.toJson());
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> EmployerSubscriptionManagementScreen(subscriber: subscriptionPayload)));
        },
      )..show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Alert!',
        desc: 'An error has occurred. Please try again.',
        btnOkOnPress: () {
        
        },
      )..show();
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}