import 'package:e_tutoring/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({
    Key key,
    this.color = const Color(0xFF2DBD3A),
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).privacy_policy_title),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1),
          // actions: [LanguagePickerWidget()]
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: <Widget>[
          SafeArea(
              child: ListView(children: [
            Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(children: <Widget>[
                        Container(
                            child: Card(
                                // color: Color.fromRGBO(205, 205, 205, 1),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 20.0),
                                    child: Row(children: [
                                      Expanded(
                                          child: Column(children: [
                                        Text("Modalità di trattamento dei dati",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        ListTile(
                                            title: new Text(
                                              "Il Titolare adotta le opportune misure di sicurezza volte ad impedire l’accesso, la divulgazione, la modifica o la distruzione non autorizzate dei Dati Personali;",
                                            ),
                                            leading: Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ))),
                                        ListTile(
                                            title: new Text(
                                              "il trattamento viene effettuato mediante strumenti informatici e/o telematici, con modalità organizzative e con logiche strettamente correlate alle finalità indicate;",
                                            ),
                                            leading: Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ))),
                                        ListTile(
                                            title: new Text(
                                                "oltre al Titolare, in alcuni casi, potrebbero avere accesso ai Dati altri soggetti coinvolti nell’organizzazione di questa Applicazione (personale amministrativo, commerciale, marketing, legali, amministratori di sistema) ovvero soggetti esterni nominati anche, se necessario, Responsabili del Trattamento da parte del Titolare;"),
                                            leading: Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ))),
                                        Divider(
                                            height: 4,
                                            thickness: 0,
                                            color: ArgonColors.muted),
                                        Text("Periodo di conservazione",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        ListTile(
                                            title: new Text(
                                              "Quando il trattamento è basato sul consenso dell’Utente, il Titolare può conservare i Dati Personali più a lungo sino a quando detto consenso non venga revocato. Inoltre, il Titolare potrebbe essere obbligato a conservare i Dati Personali per un periodo più lungo in ottemperanza ad un obbligo di legge o per ordine di un’autorità.",
                                            ),
                                            leading: Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ))),
                                        ListTile(
                                            title: new Text(
                                              "Al termine del periodo di conservazione i Dati Personali saranno cancellati. Pertanto, allo spirare di tale termine il diritto di accesso, cancellazione, rettificazione ed il diritto alla portabilità dei Dati non potranno più essere esercitati.",
                                            ),
                                            leading: Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ))),
                                      ]))
                                    ]))))
                      ])
                    ]))
          ]))
        ]));
  }
}
