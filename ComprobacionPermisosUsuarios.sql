/* A continuación, se mostrará el código de las consultas que prueban que los usuarios efectivamente están 
creados correctamente, y los permisos funcionan como deben.
*/

---------------------------------------------------------------------------------------------------------
/*Usuario Administrador  --> INSERT*/ 
INSERT INTO public."Agente de casting"(
	"numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal")
	VALUES (65, 'Pepe', '07618435T', 0, 'Calle Vargas Llosa', 'Menorca', '5ºE', '3' );
	
/*Usuario Administrador  --> UPDATE*/	
UPDATE public."Agente de casting"
	SET "Nombre"= 'Jose', "DNI"='19706598Y', "Código_casting_Casting_presencial"=0, "Calle"='Calle Rivera', "Ciudad"='Albacete', piso='4ºA', "Portal"='5'
	WHERE "numEmpleado"= 65;
	
/*Usuario Administrador  --> CREATE TABLE*/	
CREATE TABLE public."Caracol"
{
	"Nº_bastidor" bigint NOT NULL,
	PRIMARY KEY ("Nº_bastidor")
};
ALTER TABLE public."Caracol"
	OWNER to "Administrador";

/*Usuario Administrador  --> SELECT*/
SELECT "numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal"
	FROM public."Agente de casting";
	
/*Usuario Administrador  --> DELETE*/
DELETE FROM public."Agente de casting"
WHERE "numEmpleado" = 65;


---------------------------------------------------------------------------------------------------------
/*Usuario Gestor  --> INSERT*/ 
INSERT INTO public."Agente de casting"(
	"numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal")
	VALUES (65, 'Paco', '94318169P', 0, 'Calle calle', 'Madrid', '3ºD', '3' );

/*Usuario Gestor  --> UPDATE*/	
UPDATE public."Agente de casting"
	SET "Nombre"= 'Juanjo', "DNI"='946704891I', "Código_casting_Casting_presencial"=1, "Calle"='Calle Miguel Maldonado', "Ciudad"='Malaga', piso='6ºB', "Portal"='6'
	WHERE "numEmpleado"= 65;
	
/*Usuario Gestor  --> DELETE*/
DELETE FROM public."Agente de casting"
WHERE "numEmpleado" = 65;

/*Usuario Gestor  --> SELECT*/
SELECT "numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal"
	FROM public."Agente de casting";

/*Usuario Gestor  --> CREATE TABLE*/	
CREATE TABLE public."Caracol"
{
	"Nº_bastidor" bigint NOT NULL,
	PRIMARY KEY ("Nº_bastidor")
};
ALTER TABLE public."Caracol"
	OWNER to "Administrador";
	
	
---------------------------------------------------------------------------------------------------------
/*Usuario Recepcionista  --> SELECT*/
SELECT "numEmpleado" FROM "Agente de casting"

/*Usuario Recepcionista  --> INSERT*/
INSERT INTO public."Agente de casting"(
	"numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal")
	VALUES (20, 'Paco', '94318169P', 0, 'Ferraz', 'Moscú', '6ºB', 'A' );
	
/*Usuario Recepcionista  --> DELETE*/
DELETE FROM public."Agente de casting"
WHERE "numEmpleado" = 20;

/*Usuario Recepcionista  --> UPDATE*/	
UPDATE public."Agente de casting"
	SET "Nombre"= 'Pedro', "DNI"='94670481I', "Código_casting_Casting_presencial"=1, "Calle"='Calle Maldonado', 
	"Ciudad"='Malaga', piso='6ºB', "Portal"='6'
	WHERE "numEmpleado"= 0;
	
/*Usuario Recepcionista  --> CREATE TABLE*/	
CREATE TABLE public."Caracol"
{
	"Nº_bastidor" bigint NOT NULL,
	PRIMARY KEY ("Nº_bastidor")
};
ALTER TABLE public."Caracol"
	OWNER to "Recepcionista";

