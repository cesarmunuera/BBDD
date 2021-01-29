/*CÓDIGO DE COMPROBACIÓN TRIGGER 1 CON CANDIDATO ADULTO*/

-- EL TRIGGER NO FUNCIONA CORRECTAMENTE PUESTO QUE EL OBJETIVO ERA INSERTAR EL IMPORTE TOTAL A PAGAR
-- POR CADA CANDIDATO TRAS REALIZAR LA INSERCIÓN EN LA TABLA "Candidato_adulto_realiza_Prueba_individual" O  
-- "Candidato_ninio_realiza_Prueba_individual", PERO SOLO SE MUESTRA EL RAISE NOTICE,
-- EN CUALQUIER CASO, CON UNA NUEVA INSERCIÓN EN LA TABLA "Candidato_adulto_realiza_Prueba_individual"
-- O "Candidato_ninio_realiza_Prueba_individual", COMO LA COMPROBACIÓN DEL TRIGGER 2, SE PUEDE OBSERVAR LA ACCIÓN QUE 
-- EJECUTA EL DISPARADOR.

INSERT INTO public."Candidato_adulto_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto", "Valido")
	VALUES 
	(6, 6, 5, 2008, True);
	
	
/*CÓDIGO DE COMPROBACIÓN TRIGGER 1 CON CANDIDATO NINIO*/

INSERT INTO public."Candidato_ninio_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio", "Valido")
	VALUES 
	(6, 6, 5, 1, True);


/*CÓDIGO DE COMPROBACIÓN TRIGGER 2 CON CANDIDATO ADULTO*/

-- CUANDO EL CANDIDATO REALICE TODAS LAS PRUEBAS DE UN MISMO CASTING, COMO ES EN ESTE CASO (PRUEBAS 1 Y 0 DEL CASTING 0),
-- SE LANZARÁ EL TRIGGER 2

INSERT INTO public."Candidato_adulto_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto", "Valido")
	VALUES 
	(0, 0, 0, 2004, True),
	(1, 1, 0, 2004, True); 
	
/*CÓDIGO DE COMPROBACIÓN TRIGGER 2 CON CANDIDATO NINIO*/

INSERT INTO public."Candidato_ninio_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio", "Valido")
	VALUES 
	(0, 0, 0, 2, True),
	(1, 1, 0, 2, True); 
	
/*CÓDIGO DE COMPROBACIÓN TRIGGER 3 CON CANDIDATO ADULTO*/

-- CUANDO UN CANDIDATO SEA CONTRATADO (O INSERTADO EN LA TABLA "Cliente_Contrata_Candidato_adulto" O "Cliente_Contrata_Candidato_ninio")
-- SE LANZARÁ EL TRIGGER 3, PARA ELLO, REALIZAMOS UNA INSERCIÓN DE UNA NUEVA TUPLA EN CADA UNA DE DICHAS TABLAS.

INSERT INTO public."Cliente_Contrata_Candidato_adulto"(
	"Código_cliente_Cliente", "Código candidato_Candidato_adulto", "Casting")
	VALUES (0, 2005, 10);
	
/*CÓDIGO DE COMPROBACIÓN TRIGGER 3 CON CANDIDATO NINIO*/

INSERT INTO public."Cliente_Contrata_Candidato_ninio"(
	"Código_cliente_Cliente", "Código candidato_Candidato_ninio", "Casting")
	VALUES (4, 3, 10);

/*CÓDIGO DE COMPROBACIÓN TRIGGER 4 CON CANDIDATO ADULTO*/

-- 1º: INSERTAMOS UNA PRUEBA REALIZADA POR UN CANDIDATO QUE CUMPLE CON EL PERFIL QUE SE DEMANDA DESDE EL CASTING QUE HA PROPUESTO DICHA PRUEBA.
INSERT INTO public."Candidato_adulto_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto", "Valido")
	VALUES 
	(3, 3, 2, 2008, True); 

-- 2º: INSERTAMOS UNA PRUEBA REALIZADA POR UN CANDIDATO QUE NO CUMPLE CON EL PERFIL QUE SE DEMANDA DESDE EL CASTING QUE HA PROPUESTO DICHA PRUEBA.
INSERT INTO public."Candidato_adulto_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto", "Valido")
	VALUES 
	(9, 9, 8, 2008, True); 
	
/*CÓDIGO DE COMPROBACIÓN TRIGGER 4 CON CANDIDATO NINIO*/

-- 1º: INSERTAMOS UNA PRUEBA REALIZADA POR UN CANDIDATO QUE CUMPLE CON EL PERFIL QUE SE DEMANDA DESDE EL CASTING QUE HA PROPUESTO DICHA PRUEBA.
INSERT INTO public."Candidato_ninio_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio", "Valido")
	VALUES 
	(7, 7, 6, 1, True); 

-- 2º: INSERTAMOS UNA PRUEBA REALIZADA POR UN CANDIDATO QUE NO CUMPLE CON EL PERFIL QUE SE DEMANDA DESDE EL CASTING QUE HA PROPUESTO DICHA PRUEBA.
INSERT INTO public."Candidato_ninio_realiza_Prueba_individual"(
	"Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio", "Valido")
	VALUES 
	(7, 7, 6, 2, True); 
	
	