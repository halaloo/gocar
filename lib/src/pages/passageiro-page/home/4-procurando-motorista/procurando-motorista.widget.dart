import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/provider/blocs/blocs.dart';
import 'package:intl/intl.dart';

class ProcurandoMotoristaWidget extends StatefulWidget {
  @override
  _ProcurandoMotoristaWidgetState createState() =>
      _ProcurandoMotoristaWidgetState();
}

class _ProcurandoMotoristaWidgetState extends State<ProcurandoMotoristaWidget> {
  Timer _timeProcuraMotorista;
  final DateTime now = DateTime.parse("2019-09-09 00:00:00.00");
  HomePassageiroBloc _homeBloc = BlocProvider.getBloc<HomePassageiroBloc>();

  @override
  void dispose() {
    _timeProcuraMotorista?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    _timeProcuraMotorista?.cancel();

    _timeProcuraMotorista = Timer.periodic(Duration(seconds: 1), (Timer t) {
      i++;
      DateTime resultTim = now.add(new Duration(seconds: i));
      final String formattedDateTime = _formatDateTime(resultTim);
      print('Time  radar procura viagem está ativo $i');
      _homeBloc.timeEvent.add(formattedDateTime);
    });

    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 150),
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width * 0.75,
          child: MaterialButton(
            onPressed: () {},
            color: Colors.white,
            minWidth: 50,
            height: 50,
            child: Row(
              children: <Widget>[
                SizedBox(width: 5),
                //CircularProgressIndicator(),
                StreamBuilder(
                    stream: _homeBloc.timeFlux,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData)
                        return CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.black,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Text('00:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14))
                              ],
                            ));;

                      return CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.black,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Text(snapshot.data,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14))
                            ],
                          ));
                    }),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Procurando Motorista',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 10.0,
            padding: const EdgeInsets.all(1.0),
          )),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('mm:ss').format(dateTime);
  }
}
