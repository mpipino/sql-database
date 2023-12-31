CREATE ROLE ReadExecute AUTHORIZATION dbo
GRANT EXECUTE TO [ReadExecute]
GRANT SELECT TO [ReadExecute]
GRANT CREATE TABLE TO [ReadExecute]
GRANT CREATE FUNCTION TO [ReadExecute]
GRANT CREATE PROCEDURE TO [ReadExecute]
GRANT CREATE SCHEMA TO [ReadExecute]
GRANT EXECUTE ON SCHEMA::[dbo] TO [ReadExecute]
GRANT ALTER ON SCHEMA::[dbo] TO [ReadExecute]
GRANT SELECT ON SCHEMA::[dbo] TO [ReadExecute]
GRANT CONTROL ON SCHEMA::[dbo] TO [ReadExecute]
GRANT CREATE TYPE TO [ReadExecute]
GRANT CREATE VIEW TO [ReadExecute]
GRANT CREATE EXTERNAL LIBRARY TO [ReadExecute]
GRANT SHOWPLAN TO [ReadExecute]
GRANT VIEW DEFINITION TO [ReadExecute]
GRANT SELECT ON OBJECT::sys.sql_expression_dependencies TO [ReadExecute];