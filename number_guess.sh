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
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  fi
else
  echo $($PSQL "SELECT games_played, best_game FROM users WHERE user_id=$USER_ID" | while read games_played bar best_game
  do
    echo Welcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses.
  done
fi
