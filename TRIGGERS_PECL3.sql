/*
1º. TRIGGER 
DEFINICIÓN: Calcular el importe total que ha pagado cada candidato teniendo en
cuenta todas las pruebas que ha realizado.
*/

------------------------------------------------------------------------
/*PARA CANDIDATO ADULTO Función: "Importe_total_adultos()" */  
------------------------------------------------------------------------

CREATE TRIGGER "Calcula_importe_total"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_adulto_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Importe_total"();

COMMENT ON TRIGGER "Calcula_importe_total" ON public."Candidato_adulto_realiza_Prueba_individual"
    IS 'Calcular el importe total que ha pagado cada candidato teniendo en cuenta todas las pruebas que ha realizado.';

/*SE HARÁ CUANDO SE INSERTE UNA NUEVA PRUEBA INDIVIDUAL REALIZADA
EN LA TABLA CANDIDATO_ADULTO_REALIZA_PRUEBA_INDIVIDUAL*/

BEGIN

UPDATE "Candidato_adulto"
	SET "Coste_total" = (SELECT SUM("Coste") FROM "Prueba_individual", "Candidato_adulto_realiza_Prueba_individual" WHERE "Candidato_adulto_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba" AND NEW."Código candidato_Candidato_adulto" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")
	WHERE "Candidato_adulto"."Código candidato" = NEW."Código candidato_Candidato_adulto";

RAISE NOTICE 'Se ha actualizado el importe total a pagar por el candidato %', NEW."Código candidato_Candidato_adulto"; -- No muestro el nombre del candidato porque puede haber dos candidatos con el mismo nombre

RETURN NULL;
END;

-----------------------------------------------------------------------
/*PARA CANDIDATO NINIO Función: "Importe_total_ninios()" */ 
-----------------------------------------------------------------------

CREATE TRIGGER "Calcula_importe_total_ninio"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_ninio_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Importe_total_ninios"();

COMMENT ON TRIGGER "Calcula_importe_total_ninio" ON public."Candidato_ninio_realiza_Prueba_individual"
    IS 'Calcular el importe total que ha pagado cada candidato (ninio) teniendo en cuenta todas las pruebas que ha realizado.';

/*SE HARÁ CUANDO SE INSERTE UNA NUEVA PRUEBA INDIVIDUAL REALIZADA
EN LA TABLA CANDIDATO_NINIO_REALIZA_PRUEBA_INDIVIDUAL*/

BEGIN

UPDATE "Candidato_ninio"
	SET "Coste_total" = (SELECT SUM("Coste") FROM "Prueba_individual", "Candidato_ninio_realiza_Prueba_individual" WHERE "Candidato_ninio_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba" AND NEW."Código candidato_Candidato_ninio" = "Candidato_ninio_realiza_Prueba_individual"."Código candidato_Candidato_ninio")
	WHERE "Candidato_ninio"."Código candidato" = NEW."Código candidato_Candidato_ninio";

RAISE NOTICE 'Se ha actualizado el importe total a pagar por el candidato %', NEW."Código candidato_Candidato_ninio"; -- No muestro el nombre del candidato porque puede haber dos candidatos con el mismo nombre

RETURN NULL;
END;


------------------------------------------------------------------------------------------------------------------
/*
2º. TRIGGER
DEFINICIÓN: Cuando un candidato supera una prueba de un casting, se debe calcular el
número de pruebas superadas por dicho candidato. Si ese número
coincide con el número de pruebas totales de dicho casting, se mostrará
un mensaje y se insertará en la tabla “contrata”.
*/

------------------------------------------------------------
/*PARA CANDIDATO ADULTO Función: ContadorPruebas_adultos()*/ 
------------------------------------------------------------

CREATE TRIGGER "Candidato_supera_prueba"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_adulto_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."ContadorPruebas"();

COMMENT ON TRIGGER "Candidato_supera_prueba" ON public."Candidato_adulto_realiza_Prueba_individual"
    IS 'Cuando un candidato supera una prueba de un casting, 
	se debe calcular el número de pruebas superadas por dicho candidato. 
	Si ese número coincide con el número de pruebas totales de dicho casting, 
	se mostrará un mensaje y se insertará en la tabla “contrata”.'
	
/*SE HARÁ CUANDO SE INSERTE UNA NUEVA PRUEBA INDIVIDUAL REALIZADA
EN LA TABLA "Candidato_adulto_realiza_Prueba_individual"*/

DECLARE

numero_pruebas_superadas integer;
numero_pruebas_totales_casting integer;

BEGIN

SELECT COUNT(*) INTO numero_pruebas_superadas FROM "Candidato_adulto_realiza_Prueba_individual"
WHERE ("Candidato_adulto_realiza_Prueba_individual"."Valido" = True) 
	AND (NEW."Código candidato_Candidato_adulto" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto");

SELECT COUNT(*) INTO numero_pruebas_totales_casting FROM "Prueba_individual"
WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Prueba_individual"."Código_casting_Casting_presencial_Fase";

IF numero_pruebas_superadas = numero_pruebas_totales_casting THEN
RAISE NOTICE 'El candidato adulto ha superado todas las pruebas del casting';
INSERT INTO "Cliente_Contrata_Candidato_adulto" ("Código_cliente_Cliente", "Código candidato_Candidato_adulto", "Casting")
VALUES ((SELECT "Código_cliente_Cliente" FROM "Casting_presencial" WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial"."Código_casting"), NEW."Código candidato_Candidato_adulto", (SELECT "Código_casting" FROM "Casting_presencial" WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial"."Código_casting"));
END IF;

RETURN NEW;
RETURN NULL;
END;

------------------------------------------------------------
/*PARA CANDIDATO NINIO Función: ContadorPruebas_ninios()*/ 
------------------------------------------------------------

CREATE TRIGGER "Candidato_ninio_supera_prueba"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_ninio_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."ContadorPruebas_ninio"();

COMMENT ON TRIGGER "Candidato_ninio_supera_prueba" ON public."Candidato_ninio_realiza_Prueba_individual"
    IS 'Cuando un candidato (ninio) supera una prueba de un casting, se debe calcular el
número de pruebas superadas por dicho candidato. Si ese número
coincide con el número de pruebas totales de dicho casting, se mostrará
un mensaje y se insertará en la tabla “contrata”';


/*SE HARÁ CUANDO SE INSERTE UNA NUEVA PRUEBA INDIVIDUAL REALIZADA
EN LA TABLA "Candidato_ninio_realiza_Prueba_individual"*/

DECLARE

numero_pruebas_superadas integer;
numero_pruebas_totales_casting integer;

BEGIN

SELECT COUNT(*) INTO numero_pruebas_superadas FROM "Candidato_ninio_realiza_Prueba_individual"
WHERE ("Candidato_ninio_realiza_Prueba_individual"."Valido" = True) 
	AND (NEW."Código candidato_Candidato_ninio" = "Candidato_ninio_realiza_Prueba_individual"."Código candidato_Candidato_ninio");

SELECT COUNT(*) INTO numero_pruebas_totales_casting FROM "Prueba_individual"
WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Prueba_individual"."Código_casting_Casting_presencial_Fase";

IF numero_pruebas_superadas = numero_pruebas_totales_casting THEN
RAISE NOTICE 'El candidato ninio ha superado todas las pruebas del casting';
INSERT INTO "Cliente_Contrata_Candidato_ninio" ("Código_cliente_Cliente", "Código candidato_Candidato_ninio", "Casting")
VALUES ((SELECT "Código_cliente_Cliente" FROM "Casting_presencial" WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial"."Código_casting"), NEW."Código candidato_Candidato_ninio", (SELECT "Código_casting" FROM "Casting_presencial" WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial"."Código_casting"));
END IF;

RETURN NEW;
RETURN NULL;
END;

------------------------------------------------------------------------------------------------------------------

/* 
3º. TRIGGER 
DEFINICIÓN: Al insertar un candidato en la tabla “contrata” se debe comprobar si para
ese casting en particular ya se han contratado suficientes personas. Para
ello, se deberá comparar el número de candidatos seleccionados para ese
casting con el número de personas requerido al contratar el casting.
*/

---------------------------------------------------------------------
/*PARA CANDIDATO ADULTO Función: Comprobar_contrataciones_adultos()*/ 
---------------------------------------------------------------------

CREATE TRIGGER "Comprobar_contrataciones_adultos"
    AFTER INSERT
    ON public."Cliente_Contrata_Candidato_adulto"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Comprobar_contrataciones"();

COMMENT ON TRIGGER "Comprobar_contrataciones_adultos" ON public."Cliente_Contrata_Candidato_adulto"
    IS 'Al insertar un candidato en la tabla “contrata” se debe comprobar si para
ese casting en particular ya se han contratado suficientes personas. Para
ello, se deberá comparar el número de candidatos seleccionados para ese
casting con el número de personas requerido al contratar el casting.';

/*SE HARÁ CUANDO SE INSERTE UN NUEVO CANDIDATO CONTRATADO 
EN LA TABLA "Cliente_Contrata_Candidato_adulto".*/

DECLARE

candidatos_adultos_contratados_para_un_mismo_casting integer;

numero_personas_necesita_casting integer;

BEGIN

candidatos_adultos_contratados_para_un_mismo_casting = (SELECT COUNT ("Código candidato_Candidato_adulto") FROM "Cliente_Contrata_Candidato_adulto" WHERE "Cliente_Contrata_Candidato_adulto"."Casting" = NEW."Casting");

numero_personas_necesita_casting = (SELECT "NumPersonas" FROM "Casting_presencial" WHERE NEW."Casting" = "Casting_presencial"."Código_casting");

IF candidatos_adultos_contratados_para_un_mismo_casting = numero_personas_necesita_casting THEN
RAISE NOTICE 'Se acaba de contratar a todas las personas del casting.';

ELSEIF candidatos_adultos_contratados_para_un_mismo_casting < numero_personas_necesita_casting THEN
RAISE NOTICE 'Se han contratado % personas de % personas que tiene el casting.',candidatos_adultos_contratados_para_un_mismo_casting, numero_personas_necesita_casting;   

ELSE
RAISE EXCEPTION 'SE HA PRODUCIDO UN ERROR: NO SE PUEDE CONTRATAR A MÁS PERSONAS DE LAS QUE HAY EN UN CASTING.';

END IF;
RETURN NULL;
END;

-------------------------------------------------------------------
/*PARA CANDIDATO NINIO Función: Comprobar_contrataciones_ninios()*/ 
-------------------------------------------------------------------

CREATE TRIGGER "Comprobar_contrataciones_ninios"
    AFTER INSERT
    ON public."Cliente_Contrata_Candidato_ninio"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Comprobar_contrataciones_ninios"();

COMMENT ON TRIGGER "Comprobar_contrataciones_ninios" ON public."Cliente_Contrata_Candidato_ninio"
    IS 'Al insertar un candidato (ninio) en la tabla “Cliente_Contrata_Candidato_ninio” se debe comprobar si para
ese casting en particular ya se han contratado suficientes personas. Para
ello, se deberá comparar el número de candidatos seleccionados para ese
casting con el número de personas requerido al contratar el casting.
';
/*SE HARÁ CUANDO SE INSERTE UN NUEVO CANDIDATO CONTRATADO 
EN LA TABLA "Cliente_Contrata_Candidato_ninio".*/

DECLARE

candidatos_ninios_contratados_para_un_mismo_casting integer;

numero_personas_necesita_casting integer;

BEGIN

candidatos_ninios_contratados_para_un_mismo_casting = (SELECT COUNT ("Código candidato_Candidato_ninio") FROM "Cliente_Contrata_Candidato_ninio" WHERE "Cliente_Contrata_Candidato_ninio"."Casting" = NEW."Casting");

numero_personas_necesita_casting = (SELECT "NumPersonas" FROM "Casting_presencial" WHERE NEW."Casting" = "Casting_presencial"."Código_casting");

IF candidatos_ninios_contratados_para_un_mismo_casting = numero_personas_necesita_casting THEN
RAISE NOTICE 'Se acaba de contratar a todas las personas del casting.';

ELSEIF candidatos_ninios_contratados_para_un_mismo_casting < numero_personas_necesita_casting THEN
RAISE NOTICE 'Se han contratado % personas de % personas que tiene el casting.',candidatos_ninios_contratados_para_un_mismo_casting, numero_personas_necesita_casting;   

ELSE
RAISE EXCEPTION 'SE HA PRODUCIDO UN ERROR: NO SE PUEDE CONTRATAR A MÁS PERSONAS DE LAS QUE HAY EN UN CASTING.';

END IF;
RETURN NULL;
END;

------------------------------------------------------------------------------------------------------------------

/*
4º. TRIGGER
DEFINICIÓN: Cuando un candidato realiza una prueba de un determinado casting, se
debe comprobar si su perfil encaja en alguno de los perfiles requeridos
por en dicho casting.
*/

-------------------------------------------------------------
/*PARA CANDIDATO ADULTO Función: Comprobar_perfil_adultos()*/ 
-------------------------------------------------------------

CREATE TRIGGER "Comprueba_perfil_candidato_adulto"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_adulto_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Comprobar_perfil"();

COMMENT ON TRIGGER "Comprueba_perfil_candidto_adulto" ON public."Candidato_adulto_realiza_Prueba_individual"
    IS 'Cuando un candidato realiza una prueba de un determinado casting, se comprobará si su perfil encaja en alguno de los perfiles requeridos por dicho casting.
';


/*

SE HARÁ CUANDO SE INSERTE O MODIFIQUE UNA NUEVA PRUEBA INDIVIDUAL (Esta última condición la añadimos para cuando se produzca un error por parte de los calificadores,
de manera que den por válida una prueba a un candidato que previamente no la había superado, de esta manera se podrían subsanar esos errores y el trigger podría saltar igual)
EN LA TABLA CANDIDATO_ADULTO_REALIZA_PRUEBA_INDIVIDUAL

*/

BEGIN 

IF (SELECT "Codigo_perfil_Perfil" FROM "Candidato_adulto" 
	WHERE NEW."Código candidato_Candidato_adulto" = "Candidato_adulto"."Código candidato") = (SELECT "Codigo_perfil_Perfil" FROM "Casting_presencial_necesita_Perfil" 
																							  WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial_necesita_Perfil"."Código_casting_Casting_presencial") 
THEN 
	RAISE NOTICE 'El Candidato que acaba de hacer la prueba tiene el perfil que necesita el casting que las propone.';
ELSE 
	RAISE NOTICE 'El Candidato que acaba de hacer la prueba NO tiene el perfil que necesita el casting que las propone.';

END IF;
RETURN NULL;
END;

-----------------------------------------------------------
/*PARA CANDIDATO NINIO Función: Comprobar_perfil_ninios()*/ 
-----------------------------------------------------------

CREATE TRIGGER "Comprueba_perfil_candidto_ninio"
    AFTER INSERT OR UPDATE 
    ON public."Candidato_ninio_realiza_Prueba_individual"
    FOR EACH ROW
    EXECUTE PROCEDURE public."Comprobar_perfil_ninios"();

COMMENT ON TRIGGER "Comprueba_perfil_candidto_ninio" ON public."Candidato_ninio_realiza_Prueba_individual"
    IS 'Cuando un candidato (ninio) realiza una prueba de un determinado casting, se
debe comprobar si su perfil encaja en alguno de los perfiles requeridos
por en dicho casting.';

/*

SE HARÁ CUANDO SE INSERTE O MODIFIQUE UNA NUEVA PRUEBA INDIVIDUAL (Esta última condición la añadimos para cuando se produzca un error por parte de los calificadores,
de manera que den por válida una prueba a un candidato que previamente no la había superado, de esta manera se podrían subsanar esos errores y el trigger podría saltar igual)
EN LA TABLA CANDIDATO_NINIO_REALIZA_PRUEBA_INDIVIDUAL

*/

BEGIN 

IF (SELECT "Codigo_perfil_Perfil" FROM "Candidato_ninio" 
	WHERE NEW."Código candidato_Candidato_ninio" = "Candidato_ninio"."Código candidato") = (SELECT "Codigo_perfil_Perfil" FROM "Casting_presencial_necesita_Perfil" 
																							  WHERE NEW."Código_casting_Casting_presencial_Fase_Prueba_individual" = "Casting_presencial_necesita_Perfil"."Código_casting_Casting_presencial") 
THEN 
	RAISE NOTICE 'El Candidato que acaba de hacer la prueba tiene el perfil que necesita el casting que las propone.';
ELSE 
	RAISE NOTICE 'El Candidato que acaba de hacer la prueba NO tiene el perfil que necesita el casting que las propone.';

END IF;
RETURN NULL;
END;


------------------------------------------------------------------------------------------------------------------
