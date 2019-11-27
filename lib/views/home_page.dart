import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';
import 'package:screen/screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _playerOne = Player(name: 'Nós', score: 0, victories: 0);
  var _playerTwo = Player(name: 'Eles', score: 0, victories: 0);

  String textFieldValue = '';

  void _resetScore(Player player, bool resetVictories){
    setState(() {
      player.score = 0;
    });
  }
  
  void _resetAllGame(Player player, bool resetVictories){
    setState(() {
      player.score = 0;
      player.victories = resetVictories ? 0 : player.victories;
    });
  }

  void _changeName(Player player, String string){
    if(string != ''){
      setState(() {
        player.name = string;
      });
    }else{
      setState(() {
        player.name = "(Vazio)";
      });
    }
  }

  void _resetPlayers(bool resetVictories){
    _resetScore(_playerOne, resetVictories);
    _resetScore(_playerTwo, resetVictories);
  }

  void _resetGame(bool resetVictories){
    _resetAllGame(_playerOne, resetVictories);
    _resetAllGame(_playerTwo, resetVictories);
  }

  @override
  void initState(){
    Screen.keepOn(true);
    super.initState();
    _resetPlayers(true);
  }

  @override
  Widget _showPlayerName(Player player) {
    return GestureDetector(
      child: Text(player.name.toUpperCase(),
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          color: Colors.green, 
      )),
      onTap: () {
        _showDialogChangeName(
          title: 'Alterar nome do time',
          confirm: () {
            _changeName(player, textFieldValue);
            textFieldValue = '';
          },
        );
      },
    );
  }

  Widget _showPlayerVictories(int victories) {
    return Text("vitórias ( $victories )",
    style: TextStyle(
      fontWeight: FontWeight.w300,
    ));
  }

  Widget _showPlayerScore(int score) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 52.0),
      child: Text("$score", style: TextStyle(fontSize: 120.0)),
    );
  }

  Widget _buildRoundedButton(
    {String label, Color color, Color textColor, Function onTap, double size = 52.0}){

      //Detecta gestos na tela
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child:Container(
          height: size,
          width: size,
          color: color,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: textColor,
            ),
          ),
        ),
      ),)
    );
  }

  Widget _showAlert11(bool status){
    print("ShowAlert");
    if(status == true){
      return Positioned(
       left: 30.0,
       top: 200.0,
       child: Container(
        color: Colors.white,
        child: Text("Mão de Ferro!!!", style: TextStyle(color: Colors.yellow[600]),)
        )
      );
    }
  }

  Widget _showScoreButton(Player player){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildRoundedButton(
          label: "-1",
          color: Colors.grey[200],
          textColor: Colors.green,
          onTap: () {
            setState(() {
             player.score = player.removeScore(player.score, 1); 
            });
          }
        ),
        _buildRoundedButton(
          label: "+1",
          color: Colors.green,
          textColor: Colors.white,
          onTap: () {
            setState(() {
             player.score = player.addScore(player.score, 1);
             if((_playerOne.score == 11) || (_playerTwo.score == 11)){
               if(_playerOne.score == _playerTwo.score){
                 setState(() {
                   print('MÃO DE FERRO');
                   _showDialog(
                      title: 'Atenção!',
                      message: 'Todos devem jogar com as cartas fechadas agora',
                      confirm: () {
                        print("Confirmar");
                        setState(() {
                         _showAlert11(true); 
                        });
                      },
                      cancel: () {
                        setState(() {
                          player.score = player.removeScore(player.score, 1);
                        });
                      } 
                   );
                 });
               }
             }
             if(player.score >= 12){
               _showDialog(
                title: 'Fim de jogo',
                message: player.printPlayerName(player.name),
                confirm: () {
                  setState(() {
                    _resetPlayers(true);
                    player.victories = player.victory(player.victories);
                  });
                },
                cancel: () {
                  setState(() {
                    player.score = player.removeScore(player.score, 1);
                  });
                  
                }
               );
             }
            });
          }
        ),
      ],
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      title: Text('Marcador de truco', style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white,),
          onPressed: () {
            _showDialogResetGame(
              title: 'Zerar placar',
              message: 'Deseja alterar o resultado do jogo?',
              resetGame: () {
                _resetGame(true);
              },
              resetScore: () {
                _resetPlayers(true);
              },
            );
          },
        )
      ],
    );
  }


  Widget _buildBoardPlayers(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildBoardPlayer(_playerOne),
        _buildBoardPlayer(_playerTwo),
      ],
    );
  }

  Widget _buildBoardPlayer(Player player){
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButton(player)
        ],
      ),
    );
  }

  void _showDialog(
    {String title, String message, Function confirm, Function cancel}){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? ""),
            content: Text(message ?? ""),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(cancel != null) cancel();
                },
              ),
              FlatButton(
                child: Text("CONFIRMAR"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(confirm != null) confirm();
                },
              ),
            ],
          );
        }
      );
    }

    void _showDialogChangeName(
    {String title, Function confirm, Function cancel}){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? ""),
            content: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome do time',
              ),
              onChanged: (text) {
                textFieldValue = text;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(cancel != null) cancel();
                },
              ),
              FlatButton(
                child: Text("CONFIRMAR"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(confirm != null) confirm();
                },
              ),
            ],
          );
        }
      );
    }

    void _showDialogResetGame(
    {String title, String message, Function resetScore, Function resetGame, Function cancel}){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? ""),
            content: Text(message ?? ""),
            actions: <Widget>[
              FlatButton(
                child: Text("RESETAR GAME"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(resetGame != null) resetGame();
                },
              ),
              FlatButton(
                child: Text("ZERAR PLACAR"),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(resetScore != null) resetScore();
                },
              ),
            ],
          );
        }
      );
    }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBoardPlayers(), 
    );
  }

}