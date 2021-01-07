import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/notifications/notification_service.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  UserModel _user;

  NotificationsSettingsScreen(this._user);

  @override
  _NotificationsSettingsScreenState createState() =>
      _NotificationsSettingsScreenState(_user);
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  final notify = NotificationServices();
  bool isActivated = false;
  final scafoldKey = GlobalKey<ScaffoldState>();
  var _maskController = TextEditingController();

  UserModel user;
  List weekDays;

  _NotificationsSettingsScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: Scaffold(
        key: scafoldKey,
        appBar: AppBar(
          title: Text("Notificações"),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Wrap(
              children: <Widget>[
                Text(
                  "Ativar as notificações ",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
                Switch(
                  value: isActivated,
                  onChanged: (newValue) {
                    if (isActivated) {
                      notify.desactiveNotifications();
                      setState(() {
                        isActivated = newValue;
                      });
                    } else {
                      Map<String, dynamic> dataNotify = Map();
                      dataNotify = {
                        "user_UID": user.firebaseUser.uid,
                        "selectedDaysWeek": weekDays,
                      };
                      notify.activeNotifications(user, dataNotify);
                      setState(() {
                        isActivated = newValue;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(!isActivated
                          ? "Notificações desativadas"
                          : "Notificações ativadas"),
                      duration: Duration(seconds: 3),
                    ));
                    isActivated = newValue;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _schedulingNotifications() {
    if (isActivated) {
      return Container(
        child: Column(
          children: <Widget>[
            Text("Escolha os dias da semana:"),
            SizedBox(
              height: 34.0,
              child: GridView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5),
                  children: <Widget>[
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Seg"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Ter"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Qua"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Quin"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Sex"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Sab"),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      selected: false,
                      autofocus: false,
                      label: Text("Dom"),
                      onSelected: (selected) {},
                    ),
                  ]),
            ),
            Text("Escolha a melhor hora para receber as notificações: "),
            MaskedTextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              maskedTextFieldController: _maskController,
              mask: 'xx:xx',
            ),
          ],
        ),
      );
    } else
      return Center(
        child: Text(
          "Ative as notificações, para configura-las",
          softWrap: true,
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      );
  }
}
