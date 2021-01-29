/*
Creación del rol Administrador
*/

CREATE ROLE "Administrador" WITH
    LOGIN
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    REPLICATION
    CONNECTION LIMIT -1
    PASSWORD 'xxxxxx';
COMMENT ON ROLE "Administrador" IS 'Debe de poder ejecutar cualquier operación sobre la base de datos';

---------------------------------------------------------------------------------------------------------
/*
Creación del rol Gestor
*/

CREATE ROLE "Gestor" WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1
    PASSWORD 'xxxxxx';
COMMENT ON ROLE "Gestor" IS 'Debe de poder manejar los datos de la base de datos (inserción, actualización, borrado y consulta), pero no debe de poder crear nuevas tablas ni elementos que afecten a la estructura de la base de datos.';

---------------------------------------------------------------------------------------------------------
/*
Creación del rol Recepcionista
*/

CREATE ROLE "Recepcionista" WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1
    PASSWORD 'xxxxxx';
COMMENT ON ROLE "Recepcionista" IS 'Solo podrá consultar los datos almacenados en cada una de las tablas.';

---------------------------------------------------------------------------------------------------------
/*
Se conceden privilegios al usuario Administrador, desde el usuario postgres.
Tiene todos los privilegios, incluyendo el privilegio de conceder sus privilegios a otros usuarios o roles.
*/

ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO "Administrador" WITH GRANT OPTION;

---------------------------------------------------------------------------------------------------------
/*
Se conceden privilegios al usuario Gestor, desde el usuario postgres.
Posee los privilegios de insercción, selección, actualización y borrado.
*/

ALTER DEFAULT PRIVILEGES
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO "Gestor";

---------------------------------------------------------------------------------------------------------
/*
Se conceden privilegios al usuario Recepcionista, desde el usuario postgres.
Solo posee el privilegio de selección.
*/

ALTER DEFAULT PRIVILEGES
GRANT SELECT ON TABLES TO "Recepcionista";

---------------------------------------------------------------------------------------------------------
/*
Se revoca el privilegio de creación de tablas a todos los usuarios, excepto al usuario Administrador
(El usuario Administrador lo conserva porque asi se lo hemos especificado al sistema gestor de nuestra
BBDD, mediante una de sus interfaces)
*/
REVOKE CREATE ON SCHEMA public FROM PUBLIC;