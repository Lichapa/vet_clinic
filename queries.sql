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