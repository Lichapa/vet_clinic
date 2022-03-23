/*Queries that provide answers to the questions from all projects.*/
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-12-31';
SELECT * FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT name, date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg = 10.4 AND weight_kg = 17.3;

UPDATE animals SET species = 'unspecified';

/*  Unspecified Rollback */

-- To start the transaction
BEGIN;

-- Updating the table
UPDATE animals SET species = 'unspecified';

-- Checking the Records
SELECT * FROM animals;

-- Rollback to Earlier state
ROLLBACK;

-- Verify the changes have been reverted
SELECT * FROM animals; 

/* Setting Species */
BEGIN; -- Starting Transaction
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon'; 
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

/* Delete all records then Rollback */
BEGIN;
DELETE FROM animals; --Delete all records
SELECT * FROM  animals; -- Verify if records have been deleted
ROLLBACK; -- RollBack
SELECT * FROM  animals; -- Verify if records have been restored

/*BEGIN new Tranction */
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT born2022;
UPDATE animals SET weight_kg = (weight_kg * -1);
ROLLBACK TO born2022;
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 1;

/* Write queries to answer the following questions */

-- How many animals are there?
  SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
  SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
  SELECT ROUND(AVG(weight_kg), 2) AS average_weight FROM animals;
-- Who escapes the most, neutered or not neutered animals?
  SELECT MAX(escape_attempts) FROM animals;
  SELECT * FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals);
-- What is the minimum and maximum weight of each type of animal?
  SELECT species, MAX(weight_kg) AS max_weight, MIN(weight_kg) AS min_Weight FROM animals GROUP BY species;
--What is the average number of escape attempts per animal type of those born between 1990 and 2000?
 SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-12-31' GROUP BY species;

 /* Write queries (using JOIN) to answer the following questions */

-- What animals belong to Melody Pond?
SELECT full_name, name FROM owners JOIN animals ON owners.id = owners_id WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT species.name, animals.name FROM species JOIN animals ON species.id = species_id WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name, name FROM owners LEFT JOIN animals ON owners.id = owners_id;

-- How many animals are there per species?
SELECT species.name, COUNT(species_id) FROM species JOIN animals ON species.id = species_id GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, species.name AS Species FROM animals JOIN species ON species.id = species_id WHERE owners_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell') AND species.name = 'Digimon';

SELECT owners.full_name AS Owner, animals.name AS Animal, species.name AS Species 
FROM animals JOIN species ON species.id = species_id JOIN owners
ON owners.id = owners_id WHERE owners_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell') 
AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, full_name FROM animals JOIN owners ON owners_id = owners.id WHERE escape_attempts = 0 AND full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT full_name, COUNT(owners_id) FROM owners JOIN animals ON owners.id = owners_id 
  GROUP BY full_name HAVING COUNT (owners_id)=(
    SELECT MAX(mycount) FROM (
      SELECT full_name, COUNT(owners_id) 
      AS mycount FROM  animals 
      JOIN owners ON owners_id = owners.id 
      GROUP BY full_name
    ) as Owner
  );

-- Who was the last animal seen by William Tatcher?
SELECT vets.name, animals.name, date_of_visit
  FROM visits JOIN vets ON visits.vets_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
  WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'William Tatcher') 
  ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT vets.name, COUNT(date_of_visit)
  FROM visits JOIN vets ON visits.vets_id = vets.id
  WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez') 
  GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name 
  FROM vets
  LEFT JOIN specializations ON vets.id = vets_id
  LEFT JOIN species ON  species.id = specializations.species_id
  GROUP BY vets.name, species.name;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name, animals.name, date_of_visit
  FROM visits JOIN vets ON visits.vets_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
  WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez') AND date_of_visit >= '2020-04-01' AND date_of_visit <= '2020-08-30'
  GROUP BY vets.name, animals.name, date_of_visit;
  
-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id) FROM visits JOIN animals ON animals.id = visits.animal_id
  GROUP BY animals.name HAVING COUNT (animal_id)=(
    SELECT MAX(mycount) FROM (
      SELECT animals.name, COUNT(animal_id) 
      AS mycount FROM  animals 
      JOIN visits ON visits.animal_id = animals.id 
      GROUP BY animals.name
    ) as Animal
  );

-- Who was Maisy Smith's first visit?
SELECT vets.name, animals.name, date_of_visit
  FROM visits JOIN vets ON visits.vets_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
  WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'Maisy Smith') AND date_of_visit = (SELECT MIN(date_of_visit) FROM visits) 
  ORDER BY visits.date_of_visit  ;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT vets.name, animals.name, date_of_visit
  FROM visits JOIN vets ON visits.vets_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
  WHERE date_of_visit = (SELECT MAX(date_of_visit) FROM visits) 
  ORDER BY visits.date_of_visit ;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name, animals.name
  FROM visits
  JOIN animals ON animals.id = visits.animal_id
  JOIN vets ON vets.id = visits.vets_id
  JOIN specializations ON specializations.vets_id = visits.vets_id
  WHERE animals.species_id != specializations.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most. 
SELECT species.name as specialization , COUNT(visits.animal_id) from visits
  JOIN vets ON vets.id = visits.vets_id
  JOIN animals ON animals.id = visits.animal_id
  JOIN species ON species.id = animals.species_id
  WHERE vets.name = 'Maisy Smith'
  GROUP BY species.name;