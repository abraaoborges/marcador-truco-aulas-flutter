class Player {
  String name;
  int score;
  int victories;

  Player({this.name, this.score, this.victories});

  String printPlayerName(name){
    if(name == "Eles"){
      return "$name ganharam :(";
    }if(name == "Nós"){
      return "$name ganhamos!";
    }else{
      return "A equipe $name ganhou!";
    }
  }

  int addScore(score, points){
    if(score >= 12){
      return score = 0;
    }
    return score += points;
  }

  int removeScore(score, points){
    if(score == 0){
      return score = 0;
    }
    print("remove Score");
    return score = score - points;
  }

  int victory(victories){
    return victories += 1;
  }

  String addName(name){
    return name = name;
  }

}