// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:setareggan/models/user.dart';
import 'package:setareggan/screens/utils/end_date_calculator.dart';
import 'package:setareggan/services/user.dart';
import 'package:setareggan/theme.dart';

class AddEditScreen extends StatefulWidget {
  AddEditScreen({required this.user, super.key});
  User user;

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  Jalali? registerDate;
  Jalali? endDate;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController registerDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController palceOfIssueController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  ValueNotifier<int> registerType = ValueNotifier(1);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.user.id != null) {
      fullNameController.text = widget.user.fullname!;
      priceController.text = widget.user.price.toString();
      phoneController.text = widget.user.phone!;
      endDateController.text = widget.user.enddate!;
      registerDateController.text = widget.user.registerdate!;
      registerType.value = widget.user.registertype!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: BackButton(color: Theme.of(context).colorScheme.onSecondary),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "باشگاه ورزشی ستارگان",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/add_user.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      "ثبت نام هنرجو ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا نام و نام خانوادگی را وارد کنید";
                    }
                    return null;
                  },
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "نام و نام خانوادگی"),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا نام پدر را وارد کنید";
                    }
                    return null;
                  },
                  controller: fatherNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "نام پدر"),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  controller: idNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(hintText: 'کدملی/کد اختصاصی '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'کد ملی/کد اختصاصی را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  controller: palceOfIssueController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'محل صدور را وارد کنید';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'محل صدور'),
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: dateOfBirthController,
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'تاریخ تولد را وارد کنید';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'تاریخ تولد',
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () async {
                          var birthdate = await showPersianDatePicker(
                            context: context,
                            firstDate: Jalali(1300),
                            lastDate: Jalali(1425),
                            initialDate: Jalali.now(),
                            initialDatePickerMode: PersianDatePickerMode.day,
                            initialEntryMode:
                                PersianDatePickerEntryMode.calendar,
                            holidayConfig: PersianHolidayConfig(
                              weekendDays: {7},
                            ),
                            fieldHintText: 'روز/ماه/سال',
                          );
                          dateOfBirthController.text =
                              birthdate?.formatCompactDate() ??
                              "تاریخ تولد به درستی وارد نشده است";
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          colorFilter: const ColorFilter.mode(
                            CustomColors.kLightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.0),
                TextFormField(
                  controller: educationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'میزان تحصیلات را وارد کنید';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'تحصیلات'),
                ),
                SizedBox(height: 18.0),
                TextFormField(
                  controller: addressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'آدرس محل سکونت را وارد کنید';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'آدرس محل سکونت'),
                ),
                SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا شماره تلفن همراه را وارد کنید";
                    } else if (!value.startsWith('09')) {
                      return 'شماره تلفن باید با "09" شروع شود';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: "شماره تلفن"),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا مبلغ را وارد کنید";
                    }
                    return null;
                  },
                  // inputFormatters: [CustomFormatter()],
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "مبلغ شهریه"),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا تاریخ ثبت نام را وارد کنید";
                    }
                    return null;
                  },
                  controller: registerDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "تاریخ ثبت نام",
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () async {
                          registerDate = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1380, 1),
                            lastDate: Jalali(1420, 1),
                            holidayConfig: PersianHolidayConfig(
                              weekendDays: {7},
                            ),
                            initialDatePickerMode: PersianDatePickerMode.day,
                            initialEntryMode:
                                PersianDatePickerEntryMode.calendar,
                            fieldHintText: 'روز/ماه/سال',
                          );
                          registerDateController.text =
                              registerDate?.formatCompactDate() ??
                              'تاریخ به درستی وارد نشده است';

                          switch (registerType.value) {
                            case 1:
                              endDate = endDateCalculator(registerDate!, 1);
                              break;
                            case 2:
                              endDate = endDateCalculator(registerDate!, 3);
                              break;
                            case 3:
                              endDate = endDateCalculator(registerDate!, 6);
                              break;
                            default:
                          }

                          endDateController.text =
                              endDate?.formatCompactDate() ?? '';
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          colorFilter: const ColorFilter.mode(
                            CustomColors.kLightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                ValueListenableBuilder(
                  valueListenable: registerType,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              value: 1,
                              groupValue: registerType.value,
                              onChanged: (value) {
                                registerType.value = 1;

                                endDate = endDateCalculator(registerDate!, 1);
                                endDateController.text = endDate!
                                    .formatCompactDate();
                              },
                            ),
                            Text(
                              "1 ماه ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              value: 2,
                              groupValue: registerType.value,
                              onChanged: (value) {
                                registerType.value = 2;

                                endDate = endDateCalculator(registerDate!, 3);
                                endDateController.text = endDate!
                                    .formatCompactDate();
                              },
                            ),
                            Text(
                              "3 ماه ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              value: 3,
                              groupValue: registerType.value,
                              onChanged: (value) {
                                registerType.value = 3;

                                endDate = endDateCalculator(registerDate!, 6);
                                endDateController.text = endDate!
                                    .formatCompactDate();
                              },
                            ),
                            Text(
                              "6 ماه",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "لطفا تاریخ پایان را وارد کنید";
                    }
                    return null;
                  },
                  controller: endDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "تاریخ پایان",
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () async {
                          endDate = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1380, 1),
                            lastDate: Jalali(1420, 1),
                            holidayConfig: PersianHolidayConfig(
                              weekendDays: {7},
                            ),
                            initialDatePickerMode: PersianDatePickerMode.day,
                            initialEntryMode:
                                PersianDatePickerEntryMode.calendar,
                            fieldHintText: 'روز/ماه/سال',
                          );
                          endDateController.text =
                              endDate?.formatCompactDate() ??
                              'تاریخ به درستی وارد نشده است';
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          colorFilter: const ColorFilter.mode(
                            CustomColors.kLightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        widget.user.fullname = fullNameController.text.trim();
                        widget.user.price = int.parse(
                          priceController.text.replaceAll(",", ''),
                        );
                        widget.user.phone = phoneController.text;
                        widget.user.registerdate = registerDateController.text;
                        widget.user.enddate = endDateController.text;
                        widget.user.registertype = registerType.value;
                        Navigator.pop(context);
                        if (widget.user.id != null) {
                          await UserService.updateUser(
                            user: widget.user,
                            userid: widget.user.id!,
                          );
                        } else {
                          await UserService.adduser(widget.user);
                        }
                      }
                    },
                    child: Text(
                      style: Theme.of(context).textTheme.bodyLarge,
                      "ذخیره",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
