#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

DB_QUERY=$(psql -d periodic_table -t -c "SELECT atomic_number, name, symbol, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = '$1' OR symbol = '$1' OR name = '$1';")

if [[ -z "$DB_QUERY" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

echo "$DB_QUERY" | while IFS="|" read -r atomic_number name symbol atomic_mass type melting_point boiling_point; do
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
done
