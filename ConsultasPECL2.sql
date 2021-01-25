-- 1. MOSTRAR LOS NOMBRES DE LOS CLIENTES QUE NO HAN CONTRATADO NINGUN CASTING

SELECT "Código_cliente", "Nombre"
	FROM "Cliente"
		WHERE "Cliente"."Código_cliente" NOT IN (SELECT "Casting_presencial"."Código_cliente_Cliente" FROM "Casting_presencial")
INTERSECT SELECT "Código_cliente", "Nombre"
	FROM "Cliente"
		WHERE "Cliente"."Código_cliente" NOT IN (SELECT "Casting_online"."Código_cliente_Cliente" FROM "Casting_online")
								
-- 2. MOSTRAR EL NOMBRE DE LOS CANDIDATOS QUE HAYAN SUPERADO TODAS LAS PRUEBAS

SELECT "Candidato_adulto"."Nombre"
	FROM "Candidato_adulto"
		WHERE "Candidato_adulto"."Código candidato" IN (SELECT "Código candidato_Candidato_adulto" 
														FROM "Candidato_adulto_realiza_Prueba_individual" WHERE "Valido" = True)
UNION SELECT "Candidato_ninio"."Nombre"
	FROM "Candidato_ninio"
		WHERE "Candidato_ninio"."Código candidato" IN (SELECT "Código candidato_Candidato_ninio" 
													   FROM "Candidato_ninio_realiza_Prueba_individual" WHERE "Valido" = True)

-- 3. MOSTRAR EL NÚMERO DE CANDIDATOS QUE HAY ASOCIADOS A CADA PERFIL

SELECT COUNT("Codigo_perfil_Perfil") AS "Numero_Candidatos", "Codigo_perfil_Perfil"
	FROM "Candidato_adulto"
	GROUP BY "Codigo_perfil_Perfil"
UNION
SELECT COUNT("Codigo_perfil_Perfil") AS "Numero_Candidatos", "Codigo_perfil_Perfil"
	FROM "Candidato_ninio"
	GROUP BY "Codigo_perfil_Perfil"
ORDER BY "Codigo_perfil_Perfil"


-- 4. MOSTRAR EL NOMBRE DEL EMPLEADO QUE MÁS CASTINGS HA DIRIGIDO (DADO NUESTRO MODELO, ESTA CONSULTA NO SE PUEDE REALIZAR).

SELECT "Nombre", COUNT("Código_casting_Casting_presencial") AS "numero_codigos"
	FROM "Agente de casting"
		WHERE "numero_codigos" = (SELECT MAX("numero_codigos") FROM "Agente de casting")
GROUP BY "Nombre"
ORDER BY "Nombre"

-- 5. MOSTRAR EL NÚMERO DE CANDIDATOS QUE SE HAN PRESENTADO A CADA CASTING (QUE AL MENOS HAYAN REALIZADO UNA PRUEBA).

SELECT COUNT("Código_prueba_Prueba_individual") AS "Numero_Candidatos", "Código candidato_Candidato_adulto" AS "Codigo_candidato"
	FROM "Candidato_adulto_realiza_Prueba_individual"
	GROUP BY "Código candidato_Candidato_adulto"
UNION
SELECT COUNT("Código_prueba_Prueba_individual") AS "Numero_Candidatos", "Código candidato_Candidato_ninio" AS "Codigo_candidato"
	FROM "Candidato_ninio_realiza_Prueba_individual"
	GROUP BY "Código candidato_Candidato_ninio"
ORDER BY "Codigo_candidato"

-- 6. MOSTRAR EL NOMBRE Y LA DIRECCÓN DE LAS CANDIDADATAS QUE TENGAN PELO RUBIO Y SEAN DE MADRID.

SELECT "Nombre", "Ciudad", "Calle", "Portal", "Piso"
	FROM "Candidato_adulto" INNER JOIN "Perfil" ON "Candidato_adulto"."Codigo_perfil_Perfil" = "Perfil"."Codigo_perfil"
		WHERE ("Ciudad" = 'Madrid') and ("Color_de_pelo" = 'Rubio') and ("Sexo" = False)
UNION SELECT "Nombre", "Ciudad", "Calle", "Portal", "Piso"
	FROM "Candidato_ninio" INNER JOIN "Perfil" ON "Candidato_ninio"."Codigo_perfil_Perfil" = "Perfil"."Codigo_perfil"
		WHERE ("Ciudad" = 'Madrid') and ("Color_de_pelo" = 'Rubio') and ("Sexo" = False)
		
-- 7. MOSTRAR EL CÓDIGO DE PERFIL DE LOS PERFILES REQUERIDOS EN LOS CASTING QUE INCLUYEN LA SUBCADENA 'ANUNCIO TV' EN SU DESCRIPCIÓN.

SELECT "Codigo_perfil_Perfil", "Descripción"
	FROM "Casting_presencial_necesita_Perfil" INNER JOIN "Casting_presencial" 
	ON "Casting_presencial_necesita_Perfil"."Código_casting_Casting_presencial" = "Casting_presencial"."Código_casting"
		WHERE "Casting_presencial"."Descripción" LIKE '%Anuncio TV%'
UNION SELECT "Codigo_perfil_Perfil", "Descripción"
	FROM "Casting_online_necesita_Perfil" INNER JOIN "Casting_online" 
	ON "Casting_online_necesita_Perfil"."Código_casting_Casting_online" = "Casting_online"."Código_casting"
		WHERE "Casting_online"."Descripción" LIKE '%Anuncio TV%'

-- 8. MOSTRAR EL CÓDIGO DE LOS CANDIDATOS QUE TIENEN REPRESENTANTE Y TIENEN PELO 'Castanio'

SELECT "Código candidato"
	FROM "Candidato_adulto" INNER JOIN "Perfil" 
	ON "Candidato_adulto"."Codigo_perfil_Perfil" = "Perfil"."Codigo_perfil"
		WHERE ("NIF_Representante" IS NULL) AND ("Color_de_pelo" = 'Castanio')
UNION SELECT "Código candidato"
	FROM "Candidato_ninio" INNER JOIN "Perfil" 
	ON "Candidato_ninio"."Codigo_perfil_Perfil" = "Perfil"."Codigo_perfil"
		WHERE ("NIF_Representante" IS NULL) AND ("Color_de_pelo" = 'Castanio')
		
-- 9. MOSTRAR EL PRECIO TOTAL QUE HA DE PAGAR CADA CANDIDATO. 

/*CREAMOS UNA VISTA QUE AGRUPE LOS CODIGOS DE LOS CANDIDATOS CON LO QUE TIENEN QUE PAGAR POR CADA UNA DE LAS PRUEBAS QUE HAN REALIZADO*/
CREATE VIEW "Pagos_candidatos" AS
SELECT "Código candidato_Candidato_adulto", T1."Coste"
	FROM ("Candidato_adulto_realiza_Prueba_individual" INNER JOIN "Prueba_individual" 
	ON "Candidato_adulto_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba") as T1
UNION SELECT "Código candidato_Candidato_ninio", T1."Coste" as Coste_total
	FROM ("Candidato_ninio_realiza_Prueba_individual" INNER JOIN "Prueba_individual" 
	ON "Candidato_ninio_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba") as T1
			ORDER BY "Código candidato_Candidato_adulto"	
			
/*CONSULTA*/
SELECT T1."Código candidato_Candidato_adulto" AS "Codigo_candidatos", T1."Coste_total"
FROM (SELECT "Código candidato_Candidato_adulto", SUM("Coste") AS "Coste_total" 
	  FROM "Pagos_candidatos" WHERE "Código candidato_Candidato_adulto" = "Código candidato_Candidato_adulto" 
	  GROUP BY "Código candidato_Candidato_adulto") AS T1

			
-- 10. MOSTRAR EL NÚMERO DE CANDIDATOS ADULTOS Y EL NÚMERO DE CANDIDATOS NINIOS QUE HAY EN LA BASE DE DATOS.

SELECT COUNT ("Candidato_adulto"."Código candidato") 
AS Numero_candidatos_adultos, (SELECT COUNT ("Candidato_ninio"."Código candidato") as Numero_candidatos_ninios 
							   		FROM "Candidato_ninio")
	FROM "Candidato_adulto"

-- 11. MOSTRAR EL DNI DE LA GENTE QUE HA DIRIGIDO EL CASTING EN EL QUE ALGUNA PRUEBA INDIVIDUAL SE HA LLEVADO A CABO EN LA SALA 'flor'

SELECT "DNI"
	FROM ("Agente de casting" INNER JOIN "Prueba_individual" 
	ON "Agente de casting"."Código_casting_Casting_presencial" = "Prueba_individual"."Código_casting_Casting_presencial_Fase")
		WHERE "Prueba_individual"."Sala" = 'flor'


-- 12. MOSTRAR LA PLATAFORMA WEB QUE SE HA USADO EN EL CASTING ONLINE MÁS CARO, ASÍ COMO EL NOMBRE DEL CLIENTE QUE HA CONTRATADO DICHO CASTING

SELECT "Plataforma_web", "Cliente"."Nombre"
	FROM ("Casting_online" INNER JOIN "Cliente" 
	ON "Casting_online"."Código_cliente_Cliente" = "Cliente"."Código_cliente")
	WHERE "Casting_online"."Coste" = (SELECT MAX("Coste") FROM "Casting_online")

-- 13. Mostrar el porcentaje de clientes que hay de cada tipo

CREATE VIEW "Total_clientes"
 	AS SELECT (SELECT COUNT ("Tipo_actividad") FROM "Cliente") as "Clientes_totales",
	(SELECT COUNT ("Tipo_actividad") FROM "Cliente" WHERE "Cliente"."Tipo_actividad" = True) as "Clientes_Empresa_de_moda", 
		(SELECT COUNT ("Tipo_actividad") FROM "Cliente" WHERE "Cliente"."Tipo_actividad" = False) as "Clientes_Empresa_de_publicidad_y_cine"

SELECT (((SELECT CAST("Clientes_Empresa_de_moda" AS FLOAT) FROM "Total_clientes") / (SELECT "Clientes_totales" FROM "Total_clientes"))*100)
AS "Porcentaje_empresas_moda", (((SELECT CAST("Clientes_Empresa_de_publicidad_y_cine" AS FLOAT) 
								  FROM "Total_clientes") / (SELECT "Clientes_totales" FROM "Total_clientes"))*100) AS "Porcentaje_empresas_publicidad"
--UN SEGUNDO CAST EN LA OPERACIÓN DE LA DIVISIÓN NO SERÍA NECESARIO REALIZARLO PORQUE SQL LO CASTEA AUTOMÁTICAMENTE SI UNO DE LOS OPERADORES DE TIPO FLOAT.

-- 14. MOSTRAR EL NOMBRE DE LOS CANDIDATOS QUE HAN SUPERADO ALGUNA PRUEBA DE ALGÚN CASTING, ASÍ COMO EL NOMBRE DEL CASTING

/*CREAMOS UNA VISTA QUE RECOJA LOS DATOS DE LOS CANDIDATOS ADULTOS QUE NECESITAMOS*/
CREATE VIEW "Candidato_adulto_realiza3"(Nombre_candidato_adulto, "Código_casting", "Es_valido")
 	AS SELECT "Nombre", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Valido"
	FROM ("Candidato_adulto" INNER JOIN "Candidato_adulto_realiza_Prueba_individual"
	  ON "Candidato_adulto"."Código candidato" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")	  
	  
/*CREAMOS UNA VISTA QUE RECOJA LOS DATOS DE LOS CANDIDATOS NINIOS QUE NECESITAMOS*/
CREATE VIEW "Candidato_ninio_realiza"(Nombre_candidato_ninio, "Código_casting", "Es_valido")
 	AS SELECT "Nombre", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Valido"
	FROM ("Candidato_ninio" INNER JOIN "Candidato_ninio_realiza_Prueba_individual"
	  ON "Candidato_ninio"."Código candidato" = "Candidato_ninio_realiza_Prueba_individual"."Código candidato_Candidato_ninio")
	  
/*CONSULTA*/
SELECT nombre_candidato_adulto AS Nombre_candidatos, "Nombre" AS Nombre_casting
	FROM ("Candidato_adulto_realiza3" NATURAL INNER JOIN "Casting_presencial")
	WHERE "Es_valido" = True
UNION
SELECT nombre_candidato_ninio, "Nombre"
	FROM ("Candidato_ninio_realiza" NATURAL INNER JOIN "Casting_presencial")
	WHERE "Es_valido" = True

-- 15. MOSTRAR EL DINERO TOTAL RECAUDADO POR LA EMPRESA

/*REUTILIZAMOS LA VISTA CREADA EN LA CONSULTA 9. CON EL PRECIO QUE TIENE QUE PAGAR CADA 
CANDIDATO (PARA SABER LO QUE LA EMPRESA RECAUDA POR LOS CANDIDATOS)*/
CREATE VIEW "Pagos_candidatos" AS
SELECT "Código candidato_Candidato_adulto", T1."Coste"
	FROM ("Candidato_adulto_realiza_Prueba_individual" INNER JOIN "Prueba_individual" 
	ON "Candidato_adulto_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba") as T1
UNION SELECT "Código candidato_Candidato_ninio", T1."Coste" as Coste_total
	FROM ("Candidato_ninio_realiza_Prueba_individual" INNER JOIN "Prueba_individual" 
	ON "Candidato_ninio_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba") as T1
			ORDER BY "Código candidato_Candidato_adulto"	

/*CREAMOS UNA TABLA CON LOS COSTES QUE TIENEN QUE PAGAR LOS CLIENTES POR LOS CASTINGS ONLINE Y PRESENCIALES*/
CREATE VIEW "Pagos_clientes" AS
SELECT "Código_cliente_Cliente", "Coste"
	FROM "Casting_online"
UNION SELECT "Código_cliente_Cliente", "Coste"
	FROM "Casting_presencial"

/*CREAMOS OTRA VISTA CON LOS COSTES EN UNA ÚNICA COLUMNA PARA PODER UTILIZAR 
FUNCIONES AGREGADAS SOBRE EL RESULTADO DE OTRAS FUNCIONES AGREGADAS*/
CREATE VIEW "COSTE_TOTAL_CLIENTES_CANDIDATOS" AS
SELECT SUM("Coste") FROM "Pagos_clientes" UNION SELECT SUM("Coste") FROM "Pagos_candidatos"

/*CONSULTA*/
SELECT SUM("sum") FROM "COSTE_TOTAL_CLIENTES_CANDIDATOS"
		
-- 16. MOSTRAR EL NOMBRE Y EL TELEFONO DE LOS REPRESENTANTES QUE REPRESENTEN A DOS CANDIDATOS COMO MINIMO 

/*CREAMOS UNA VISTA PARA GUARDAR EL INNER JOIN ENTRE Representante Y SU Telefono (ATRIBUTO MULTIVALUADO)*/
CREATE VIEW "Representante_con_telefono1" ("NIF", "Nombre_representante", "Telefono")AS 
SELECT "NIF", "Nombre", "Telefono"
FROM "Representante" INNER JOIN "Telefono_representante" ON "Representante"."NIF" = "Telefono_representante"."NIF_Representente"
-- "NIF_Representente es una errata arrastrada desde PGModeler"

/*CONSULTA*/
SELECT DISTINCT "Nombre_representante", "Telefono", COUNT("Código candidato")
	FROM "Representante_con_telefono1" INNER JOIN "Candidato_adulto" ON
	"Candidato_adulto"."NIF_Representante" = "Representante_con_telefono1"."NIF"
		GROUP BY "Representante_con_telefono1"."Nombre_representante", "Representante_con_telefono1"."Telefono"
		HAVING COUNT("Código candidato") >= 2
UNION
SELECT DISTINCT "Nombre_representante", "Telefono", COUNT("Código candidato")
	FROM "Representante_con_telefono1" INNER JOIN "Candidato_ninio" ON
	"Candidato_ninio"."NIF_Representante" = "Representante_con_telefono1"."NIF"
		GROUP BY "Representante_con_telefono1"."Nombre_representante", "Representante_con_telefono1"."Telefono"
		HAVING COUNT("Código candidato") >= 2
ORDER BY "Nombre_representante"


-- 17. MOSTRAR EL DNI DE LOS ADULTOS QUE NO TENGAN REPRESENTANTE.

SELECT "DNI"
FROM "Candidato_adulto"
WHERE "Candidato_adulto"."NIF_Representante" IS NULL

-- 18. MOSTRAR LOS DATOS DEL PERFIL MÁS DEMANDADO ASÍ COMO EL NOMBRE DEL CLIENTE QUE LO HA REQUERIDO PARA SU CASTING (INCOMPLETO).

CREATE VIEW "Perfil_mas_demandado_casting_online" ("Nombre_cliente", "Código_casting", "Codigo_perfil_Perfil") AS
SELECT "Nombre", "Código_casting", "Codigo_perfil_Perfil"
FROM "Cliente" INNER JOIN "Casting_online" ON "Cliente"."Código_cliente" = "Casting_online"."Código_cliente_Cliente" AS T1
INNER JOIN "Casting_online_necesita_Perfil" ON T1."Código_casting" = "Casting_online_necesita_Perfil"."Código_casting_Casting_online"

/*CREAMOS VISTA PARA AGRUPAR EL NÚMERO DE FASES QUE TIENE CADA CASTING 
CON SU CÓDIGO DE CASTING PRESENCIAL Y ASÍ PODER USAR LAS FUNCIONES AGREGADAS*/
CREATE VIEW "Cliente_casting_online_necesita_perfil" AS 
SELECT COUNT("Código_de_fase") "Numero_de_fases", "Código_casting_Casting_presencial" 
FROM "Fase"
GROUP BY "Código_casting_Casting_presencial" 

/*CONSULTA*/
SELECT "Código_casting_Casting_presencial", "Numero_de_fases" 
FROM "Num_fases_por_casting_presencial3"
WHERE "Numero_de_fases" = (SELECT MAX("Numero_de_fases")FROM "Num_fases_por_casting_presencial3") 

-- 19. MOSTRAR EL NÚMERO DE PRUEBAS SUPERADAS POR CADA NIÑO.

SELECT COUNT("Valido"), "Código candidato_Candidato_ninio" 
FROM "Candidato_ninio_realiza_Prueba_individual"
WHERE "Candidato_ninio_realiza_Prueba_individual"."Valido" = True
GROUP BY "Código candidato_Candidato_ninio" 

-- 20. MOSTRAR EL CÓDIGO DEL CASTING QUE MÁS FASES TIENE.

/*CREAMOS VISTA PARA AGRUPAR EL NÚMERO DE FASES QUE TIENE CADA CASTING 
CON SU CÓDIGO DE CASTING PRESENCIAL Y ASÍ PODER USAR LAS FUNCIONES AGREGADAS*/
CREATE VIEW "Num_fases_por_casting_presencial3" AS 
SELECT COUNT("Código_de_fase") "Numero_de_fases", "Código_casting_Casting_presencial" 
FROM "Fase"
GROUP BY "Código_casting_Casting_presencial" 

/*CONSULTA*/
SELECT "Código_casting_Casting_presencial", "Numero_de_fases" 
FROM "Num_fases_por_casting_presencial3"
WHERE "Numero_de_fases" = (SELECT MAX("Numero_de_fases")FROM "Num_fases_por_casting_presencial3") 
