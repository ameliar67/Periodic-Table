PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


INPUT=$1


INPUT_TO_LOWER_CASE=${INPUT,,?}


if [[ -z $INPUT ]]
then
echo "Please provide an element as an argument."
exit
fi

# check if input is number
if [[ $INPUT =~ ^[0-9]{1}$ ]] 

then
#check if input is an atomic_number 
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$INPUT")

# check if input is single letter
elif [[ $INPUT =~ ^[A-Z]{1}$ ]]  

then

#check if input is a symbol and matches an atomic number
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'")

# check if input is two letters
elif [[ $INPUT_TO_LOWER_CASE =~ ^[a-z]{2}$ ]]  

then

#check if input is a symbol and matches an atomic number
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'")

else

#check if input is a name and matches an atomic number
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT'")

fi



#if it isn't any of the above

if [[ -z $ATOMIC_NUMBER ]]

then
echo "I could not find that element in the database."
exit
fi


ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$ATOMIC_NUMBER")


NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")


SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")


ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")


MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")


BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."


