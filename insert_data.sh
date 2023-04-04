#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPP GW GO
do
  if [[ $YEAR != year ]]
  then
    
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $TEAM_ID
    TEAM_ID_TWO=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    echo $TEAM_ID_TWO
    if [[ -z $TEAM_ID && -z $TEAM_ID_TWO ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      echo $INSERT_TEAM
      INSERT_TEAM_TOW=$($PSQL "INSERT INTO teams(name) VALUES ('$OPP')")
      echo $INSERT_TEAM_TOW
    elif [[ -z $TEAM_ID && ! -z $TEAM_ID_TWO ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      echo $INSERT_TEAM
    elif [[ ! -z $TEAM_ID && -z $TEAM_ID_TWO ]]
    then
      INSERT_TEAM_TOW=$($PSQL "INSERT INTO teams(name) VALUES ('$OPP')")
      echo $INSERT_TEAM_TOW
    fi
  fi
done 

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPP GW GO
do
  if [[ $YEAR != year ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_TWO=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$TEAM_ID,$TEAM_ID_TWO,$GW,$GO)")
  fi

done
