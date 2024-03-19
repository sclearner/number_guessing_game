#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=users -t -c"
# Enter username
echo "Enter your username:"
read USERNAME
# Check appearance of user before
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
# If new user
if [[ -z $USER_ID ]]
then
  CREATE_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  if [[ $CREATE_USER_RESULT == "INSERT 0 1" ]]
  then
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    echo $($PSQL "SELECT games_played, best_game FROM users WHERE user_id=$USER_ID") | while read games_played bar best_game
    do
      echo "Welcome, $USERNAME! It looks like this is your first time here."
    done
  fi
else
  echo $($PSQL "SELECT games_played, best_game FROM users WHERE user_id=$USER_ID") | while read games_played bar best_game
  do
    if [[ $best_game ]]
    then
    echo "Welcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."
    else
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    fi
  done
fi
# THE GAME
FINAL_ANSWER=$(( RANDOM % 1000 + 1 ))
TURN=0
echo "Guess the secret number between 1 and 1000:"
while [[ $ANSWER != $FINAL_ANSWER ]]
do
  (( TURN++ ))
  read ANSWER
  if [[ ! $ANSWER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $ANSWER < $FINAL_ANSWER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $ANSWER > $FINAL_ANSWER ]]
  then
    echo "It's lower than that, guess again:"
  fi
done
# Update data
UPDATE_RESULT=$( $PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID" )
if [[ -z $best_game || $best_game > $TURN ]]
then
  UPDATE_RESULT2=$( $PSQL "UPDATE users SET best_game=$TURN WHERE user_id=$USER_ID" )
fi
echo "You guessed it in $TURN tries. The secret number was $FINAL_ANSWER. Nice job!"