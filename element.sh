#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


RANDOM_NUMBER=$[ RANDOM % 1000 + 0 ]
echo $RANDOM_NUMBER

echo Enter your username:

read USERNAME

# check if username is in database

USERNAME_SEARCH_RESULT=$($PSQL "SELECT username FROM usernames WHERE username = '$USERNAME'")
USER_ID_RESULT=$($PSQL "SELECT user_id FROM usernames WHERE username = '$USERNAME'")

if [[ -z $USERNAME_SEARCH_RESULT ]]

then
echo "Welcome, $USERNAME! It looks like this is your first time here."
INSERT=$($PSQL "INSERT INTO usernames(username) VALUES('$USERNAME')")

else

GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID_RESULT")
LOWEST_SCORE=$($PSQL "SELECT score FROM games WHERE user_id=$USER_ID_RESULT ORDER BY SCORE LIMIT 1")

echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $LOWEST_SCORE guesses."
fi

COUNT=0

echo "Guess the secret number between 1 and 1000:"
MAIN_GAME()  {

read SECRET_NUMBER


if [[ ! "$SECRET_NUMBER" =~ ^(1000|[0-9]{1,3})$ ]]
then
echo "That is not an integer, guess again:"
((COUNT++))
MAIN_GAME "That is not an integer, guess again:"
fi

if [[ $SECRET_NUMBER -gt $RANDOM_NUMBER ]]
then
echo "It's lower than that, guess again:"
((COUNT++))
MAIN_GAME
fi

if [[ $SECRET_NUMBER -lt $RANDOM_NUMBER ]]
then
echo "It's higher than that, guess again:"
((COUNT++))
MAIN_GAME
fi

if [[ $SECRET_NUMBER -eq $RANDOM_NUMBER ]]
then
((COUNT++))
USER_ID_RESULT=$($PSQL "SELECT user_id FROM usernames WHERE username = '$USERNAME'")
INSERT=$($PSQL "INSERT INTO games(score, user_id) VALUES($COUNT, $USER_ID_RESULT)")
echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
exit
fi
}

MAIN_GAME