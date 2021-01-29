PGDMP     /                      y            PECL3    13.0    13.0 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16468    PECL3    DATABASE     c   CREATE DATABASE "PECL3" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "PECL3";
                postgres    false            �           0    0    DATABASE "PECL3"    ACL     �   GRANT ALL ON DATABASE "PECL3" TO "Administrador";
GRANT CONNECT ON DATABASE "PECL3" TO "Gestor";
GRANT CONNECT ON DATABASE "PECL3" TO "Recepcionista";
                   postgres    false    3207            �           0    0    SCHEMA public    ACL     Q   REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �            1255    50935 "   Comprobar_contrataciones_adultos()    FUNCTION     �  CREATE FUNCTION public."Comprobar_contrataciones_adultos"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 ;   DROP FUNCTION public."Comprobar_contrataciones_adultos"();
       public          postgres    false            �           0    0 -   FUNCTION "Comprobar_contrataciones_adultos"()    COMMENT     u  COMMENT ON FUNCTION public."Comprobar_contrataciones_adultos"() IS 'Al insertar un candidato adulto en la tabla “contrata” se debe comprobar si para ese casting en particular ya se han contratado suficientes personas. Para ello, se deberá comparar el número de candidatos seleccionados para ese casting con el número de personas requerido al contratar el casting.';
          public          postgres    false    244            �            1255    50936 !   Comprobar_contrataciones_ninios()    FUNCTION     �  CREATE FUNCTION public."Comprobar_contrataciones_ninios"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 :   DROP FUNCTION public."Comprobar_contrataciones_ninios"();
       public          postgres    false            �           0    0 ,   FUNCTION "Comprobar_contrataciones_ninios"()    COMMENT     s  COMMENT ON FUNCTION public."Comprobar_contrataciones_ninios"() IS 'Al insertar un candidato ninio en la tabla “contrata” se debe comprobar si para ese casting en particular ya se han contratado suficientes personas. Para ello, se deberá comparar el número de candidatos seleccionados para ese casting con el número de personas requerido al contratar el casting.';
          public          postgres    false    245            �            1255    50937    Comprobar_perfil_adultos()    FUNCTION       CREATE FUNCTION public."Comprobar_perfil_adultos"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 3   DROP FUNCTION public."Comprobar_perfil_adultos"();
       public          postgres    false            �           0    0 %   FUNCTION "Comprobar_perfil_adultos"()    COMMENT     �   COMMENT ON FUNCTION public."Comprobar_perfil_adultos"() IS 'Cuando un candidato adulto realiza una prueba de un determinado casting, se debe comprobar si su perfil encaja en alguno de los perfiles requeridos por en dicho casting.';
          public          postgres    false    246            �            1255    50938    Comprobar_perfil_ninios()    FUNCTION       CREATE FUNCTION public."Comprobar_perfil_ninios"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 2   DROP FUNCTION public."Comprobar_perfil_ninios"();
       public          postgres    false            �           0    0 $   FUNCTION "Comprobar_perfil_ninios"()    COMMENT     �   COMMENT ON FUNCTION public."Comprobar_perfil_ninios"() IS 'Cuando un candidato ninio realiza una prueba de un determinado casting, se debe comprobar si su perfil encaja en alguno de los perfiles requeridos por en dicho casting.';
          public          postgres    false    247            �            1255    50933    ContadorPruebas_adultos()    FUNCTION     {  CREATE FUNCTION public."ContadorPruebas_adultos"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 2   DROP FUNCTION public."ContadorPruebas_adultos"();
       public          postgres    false            �           0    0 $   FUNCTION "ContadorPruebas_adultos"()    COMMENT     N  COMMENT ON FUNCTION public."ContadorPruebas_adultos"() IS 'Cuando un candidato adulto supera una prueba de un casting, se debe calcular el número de pruebas superadas por dicho candidato. Si ese número coincide con el número de pruebas totales de dicho casting, se mostrará un mensaje y se insertará en la tabla “contrata”';
          public          postgres    false    242            �            1255    50934    ContadorPruebas_ninios()    FUNCTION     q  CREATE FUNCTION public."ContadorPruebas_ninios"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 1   DROP FUNCTION public."ContadorPruebas_ninios"();
       public          postgres    false            �           0    0 #   FUNCTION "ContadorPruebas_ninios"()    COMMENT     M  COMMENT ON FUNCTION public."ContadorPruebas_ninios"() IS 'Cuando un candidato ninio supera una prueba de un casting, se debe calcular el número de pruebas superadas por dicho candidato. Si ese número coincide con el número de pruebas totales de dicho casting, se mostrará un mensaje y se insertará en la tabla “contrata”.';
          public          postgres    false    243            �            1255    50931    Importe_total_adultos()    FUNCTION     7  CREATE FUNCTION public."Importe_total_adultos"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "Candidato_adulto"
	SET "Coste_total" = (SELECT SUM("Coste") FROM "Prueba_individual", "Candidato_adulto_realiza_Prueba_individual" WHERE "Candidato_adulto_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba" AND NEW."Código candidato_Candidato_adulto" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")
	WHERE "Candidato_adulto"."Código candidato" = NEW."Código candidato_Candidato_adulto";

RAISE NOTICE 'Se ha actualizado el importe total a pagar por el candidato %', NEW."Código candidato_Candidato_adulto"; -- No muestro el nombre del candidato porque puede haber dos candidatos con el mismo nombre

RETURN NULL;
END;
$$;
 0   DROP FUNCTION public."Importe_total_adultos"();
       public          postgres    false            �           0    0 "   FUNCTION "Importe_total_adultos"()    COMMENT     �   COMMENT ON FUNCTION public."Importe_total_adultos"() IS 'Calcular el importe total que ha pagado cada candidato adulto teniendo en cuenta todas las pruebas que ha realizado.';
          public          postgres    false    240            �            1255    50932    Importe_total_ninios()    FUNCTION     -  CREATE FUNCTION public."Importe_total_ninios"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "Candidato_ninio"
	SET "Coste_total" = (SELECT SUM("Coste") FROM "Prueba_individual", "Candidato_ninio_realiza_Prueba_individual" WHERE "Candidato_ninio_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba" AND NEW."Código candidato_Candidato_ninio" = "Candidato_ninio_realiza_Prueba_individual"."Código candidato_Candidato_ninio")
	WHERE "Candidato_ninio"."Código candidato" = NEW."Código candidato_Candidato_ninio";

RAISE NOTICE 'Se ha actualizado el importe total a pagar por el candidato %', NEW."Código candidato_Candidato_ninio"; -- No muestro el nombre del candidato porque puede haber dos candidatos con el mismo nombre

RETURN NULL;
END;
$$;
 /   DROP FUNCTION public."Importe_total_ninios"();
       public          postgres    false            �           0    0 !   FUNCTION "Importe_total_ninios"()    COMMENT     �   COMMENT ON FUNCTION public."Importe_total_ninios"() IS 'Calcular el importe total que ha pagado cada candidato ninio teniendo en cuenta todas las pruebas que ha realizado.';
          public          postgres    false    241            �           2753    16469    bgfd    OPERATOR FAMILY     0   CREATE OPERATOR FAMILY public.bgfd USING btree;
 .   DROP OPERATOR FAMILY public.bgfd USING btree;
       public          postgres    false            �            1259    16470    Agente de casting    TABLE       CREATE TABLE public."Agente de casting" (
    "numEmpleado" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "DNI" character(9) NOT NULL,
    "Código_casting_Casting_presencial" integer NOT NULL,
    "Calle" character varying(20) NOT NULL,
    "Ciudad" character varying(20) NOT NULL,
    piso character varying(20) NOT NULL,
    "Portal" character varying(20)
);
 '   DROP TABLE public."Agente de casting";
       public         heap    postgres    false            �           0    0     COLUMN "Agente de casting"."DNI"    COMMENT     M   COMMENT ON COLUMN public."Agente de casting"."DNI" IS '8 numeros y 1 letra';
          public          postgres    false    200            �           0    0 #   COLUMN "Agente de casting"."Portal"    COMMENT     �   COMMENT ON COLUMN public."Agente de casting"."Portal" IS 'Si su lugar de residencia no es en un bloque comunitario, este campo seria NULL';
          public          postgres    false    200            �           0    0    TABLE "Agente de casting"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Agente de casting" TO "Gestor";
GRANT SELECT ON TABLE public."Agente de casting" TO "Recepcionista";
          public          postgres    false    200            �            1259    16504    Candidato_adulto    TABLE     �  CREATE TABLE public."Candidato_adulto" (
    "Código candidato" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "Fecha nacimiento" date NOT NULL,
    "DNI" character(9) NOT NULL,
    "NIF_Representante" character(9),
    "Codigo_perfil_Perfil" integer NOT NULL,
    "Calle" character varying(20) NOT NULL,
    "Piso" character varying(20) NOT NULL,
    "Ciudad" character varying(20) NOT NULL,
    "Portal" character varying(20),
    "Coste_total" double precision
);
 &   DROP TABLE public."Candidato_adulto";
       public         heap    postgres    false            �           0    0    COLUMN "Candidato_adulto"."DNI"    COMMENT     L   COMMENT ON COLUMN public."Candidato_adulto"."DNI" IS '8 numeros y 1 letra';
          public          postgres    false    206            �           0    0 "   COLUMN "Candidato_adulto"."Portal"    COMMENT     �   COMMENT ON COLUMN public."Candidato_adulto"."Portal" IS 'Si su lugar de residencia no es en un bloque comunitario, este campo seria NULL';
          public          postgres    false    206            �           0    0    TABLE "Candidato_adulto"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Candidato_adulto" TO "Gestor";
GRANT SELECT ON TABLE public."Candidato_adulto" TO "Recepcionista";
          public          postgres    false    206            �            1259    16473 *   Candidato_adulto_realiza_Prueba_individual    TABLE     `  CREATE TABLE public."Candidato_adulto_realiza_Prueba_individual" (
    "Código_prueba_Prueba_individual" integer NOT NULL,
    "Código_de_fase_Fase_Prueba_individual" integer NOT NULL,
    "Código_casting_Casting_presencial_Fase_Prueba_individual" integer NOT NULL,
    "Código candidato_Candidato_adulto" integer NOT NULL,
    "Valido" boolean
);
 @   DROP TABLE public."Candidato_adulto_realiza_Prueba_individual";
       public         heap    postgres    false            �           0    0 <   COLUMN "Candidato_adulto_realiza_Prueba_individual"."Valido"    COMMENT     Y   COMMENT ON COLUMN public."Candidato_adulto_realiza_Prueba_individual"."Valido" IS 'S/N';
          public          postgres    false    201            �           0    0 2   TABLE "Candidato_adulto_realiza_Prueba_individual"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Candidato_adulto_realiza_Prueba_individual" TO "Gestor";
GRANT SELECT ON TABLE public."Candidato_adulto_realiza_Prueba_individual" TO "Recepcionista";
          public          postgres    false    201            �            1259    16507    Candidato_adulto_realiza    VIEW     �  CREATE VIEW public."Candidato_adulto_realiza" AS
 SELECT "Candidato_adulto"."Nombre" AS nombre_candidato_adulto,
    "Candidato_adulto_realiza_Prueba_individual"."Código_casting_Casting_presencial_Fase_Prueba_individual" AS "Código_casting"
   FROM (public."Candidato_adulto"
     JOIN public."Candidato_adulto_realiza_Prueba_individual" ON (("Candidato_adulto"."Código candidato" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")));
 -   DROP VIEW public."Candidato_adulto_realiza";
       public          postgres    false    206    201    201    206            �            1259    16511    Candidato_adulto_realiza2    VIEW       CREATE VIEW public."Candidato_adulto_realiza2" AS
 SELECT "Candidato_adulto"."Nombre" AS nombre_candidato_adulto,
    "Candidato_adulto_realiza_Prueba_individual"."Código_casting_Casting_presencial_Fase_Prueba_individual" AS "Código_casting",
    "Candidato_adulto_realiza_Prueba_individual"."Valido"
   FROM (public."Candidato_adulto"
     JOIN public."Candidato_adulto_realiza_Prueba_individual" ON (("Candidato_adulto"."Código candidato" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")));
 .   DROP VIEW public."Candidato_adulto_realiza2";
       public          postgres    false    201    201    201    206    206            �            1259    16519    Candidato_adulto_realiza_prueba    VIEW     \  CREATE VIEW public."Candidato_adulto_realiza_prueba" AS
 SELECT "Candidato_adulto"."Nombre" AS nombre_candidato_adulto
   FROM (public."Candidato_adulto"
     JOIN public."Candidato_adulto_realiza_Prueba_individual" ON (("Candidato_adulto"."Código candidato" = "Candidato_adulto_realiza_Prueba_individual"."Código candidato_Candidato_adulto")));
 4   DROP VIEW public."Candidato_adulto_realiza_prueba";
       public          postgres    false    201    206    206            �            1259    16523    Candidato_ninio    TABLE     �  CREATE TABLE public."Candidato_ninio" (
    "Código candidato" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "Fecha nacimiento" date NOT NULL,
    "Nombre_tutor" character varying(40) NOT NULL,
    "NIF_Representante" character(9),
    "Codigo_perfil_Perfil" integer NOT NULL,
    "Calle" character varying(20) NOT NULL,
    "Piso" character varying(20) NOT NULL,
    "Ciudad" character varying(20) NOT NULL,
    "Portal" character varying(20),
    "Coste_total" double precision
);
 %   DROP TABLE public."Candidato_ninio";
       public         heap    postgres    false            �           0    0 !   COLUMN "Candidato_ninio"."Portal"    COMMENT     �   COMMENT ON COLUMN public."Candidato_ninio"."Portal" IS 'Si su lugar de residencia no es en un bloque comunitario, este campo seria NULL';
          public          postgres    false    210            �           0    0    TABLE "Candidato_ninio"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Candidato_ninio" TO "Gestor";
GRANT SELECT ON TABLE public."Candidato_ninio" TO "Recepcionista";
          public          postgres    false    210            �            1259    16476 )   Candidato_ninio_realiza_Prueba_individual    TABLE     ^  CREATE TABLE public."Candidato_ninio_realiza_Prueba_individual" (
    "Código_prueba_Prueba_individual" integer NOT NULL,
    "Código_de_fase_Fase_Prueba_individual" integer NOT NULL,
    "Código_casting_Casting_presencial_Fase_Prueba_individual" integer NOT NULL,
    "Código candidato_Candidato_ninio" integer NOT NULL,
    "Valido" boolean
);
 ?   DROP TABLE public."Candidato_ninio_realiza_Prueba_individual";
       public         heap    postgres    false            �           0    0 ;   COLUMN "Candidato_ninio_realiza_Prueba_individual"."Valido"    COMMENT     X   COMMENT ON COLUMN public."Candidato_ninio_realiza_Prueba_individual"."Valido" IS 'S/N';
          public          postgres    false    202            �           0    0 1   TABLE "Candidato_ninio_realiza_Prueba_individual"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Candidato_ninio_realiza_Prueba_individual" TO "Gestor";
GRANT SELECT ON TABLE public."Candidato_ninio_realiza_Prueba_individual" TO "Recepcionista";
          public          postgres    false    202            �            1259    16479    Casting_online    TABLE     |  CREATE TABLE public."Casting_online" (
    "Código_casting" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "Descripción" character varying(50) NOT NULL,
    "Coste" double precision NOT NULL,
    "NumPersonas" integer NOT NULL,
    "Fecha" date NOT NULL,
    "Código_cliente_Cliente" integer NOT NULL,
    "Plataforma_web" character varying(75) NOT NULL
);
 $   DROP TABLE public."Casting_online";
       public         heap    postgres    false            �           0    0 )   COLUMN "Casting_online"."Código_casting"    COMMENT     K   COMMENT ON COLUMN public."Casting_online"."Código_casting" IS '0 < 9999';
          public          postgres    false    203            �           0    0    COLUMN "Casting_online"."Fecha"    COMMENT     C   COMMENT ON COLUMN public."Casting_online"."Fecha" IS 'dd/mm/aaaa';
          public          postgres    false    203            �           0    0 (   COLUMN "Casting_online"."Plataforma_web"    COMMENT     E   COMMENT ON COLUMN public."Casting_online"."Plataforma_web" IS 'URL';
          public          postgres    false    203            �           0    0    TABLE "Casting_online"    ACL     �   GRANT SELECT ON TABLE public."Casting_online" TO "Recepcionista";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Casting_online" TO "Gestor";
          public          postgres    false    203            �            1259    16530    Casting_online_necesita_Perfil    TABLE     �   CREATE TABLE public."Casting_online_necesita_Perfil" (
    "Código_casting_Casting_online" integer NOT NULL,
    "Codigo_perfil_Perfil" integer NOT NULL
);
 4   DROP TABLE public."Casting_online_necesita_Perfil";
       public         heap    postgres    false            �           0    0 &   TABLE "Casting_online_necesita_Perfil"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Casting_online_necesita_Perfil" TO "Gestor";
GRANT SELECT ON TABLE public."Casting_online_necesita_Perfil" TO "Recepcionista";
          public          postgres    false    211            �            1259    16482    Casting_presencial    TABLE     K  CREATE TABLE public."Casting_presencial" (
    "Código_casting" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "Descripción" character varying(50) NOT NULL,
    "Coste" double precision NOT NULL,
    "NumPersonas" integer NOT NULL,
    "Fecha" date NOT NULL,
    "Código_cliente_Cliente" integer NOT NULL
);
 (   DROP TABLE public."Casting_presencial";
       public         heap    postgres    false            �           0    0 -   COLUMN "Casting_presencial"."Código_casting"    COMMENT     O   COMMENT ON COLUMN public."Casting_presencial"."Código_casting" IS '0 < 9999';
          public          postgres    false    204            �           0    0 #   COLUMN "Casting_presencial"."Fecha"    COMMENT     G   COMMENT ON COLUMN public."Casting_presencial"."Fecha" IS 'dd/mm/aaaa';
          public          postgres    false    204            �           0    0    TABLE "Casting_presencial"    ACL     �   GRANT SELECT ON TABLE public."Casting_presencial" TO "Recepcionista";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Casting_presencial" TO "Gestor";
          public          postgres    false    204            �            1259    16533 "   Casting_presencial_necesita_Perfil    TABLE     �   CREATE TABLE public."Casting_presencial_necesita_Perfil" (
    "Código_casting_Casting_presencial" integer NOT NULL,
    "Codigo_perfil_Perfil" integer NOT NULL
);
 8   DROP TABLE public."Casting_presencial_necesita_Perfil";
       public         heap    postgres    false            �           0    0 *   TABLE "Casting_presencial_necesita_Perfil"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Casting_presencial_necesita_Perfil" TO "Gestor";
GRANT SELECT ON TABLE public."Casting_presencial_necesita_Perfil" TO "Recepcionista";
          public          postgres    false    212            �            1259    16536    Cliente    TABLE     w  CREATE TABLE public."Cliente" (
    "Código_cliente" integer NOT NULL,
    "Nombre" character varying(40) NOT NULL,
    "Calle" character varying(20) NOT NULL,
    "Portal" character varying(20),
    "Piso" character varying(20) NOT NULL,
    "Ciudad" character varying(20) NOT NULL,
    "Persona_de_contacto" character varying(40),
    "Tipo_actividad" boolean NOT NULL
);
    DROP TABLE public."Cliente";
       public         heap    postgres    false            �           0    0 "   COLUMN "Cliente"."Código_cliente"    COMMENT     D   COMMENT ON COLUMN public."Cliente"."Código_cliente" IS '0 < 9999';
          public          postgres    false    213            �           0    0    COLUMN "Cliente"."Portal"    COMMENT     �   COMMENT ON COLUMN public."Cliente"."Portal" IS 'Si su lugar de residencia no es en un bloque comunitario, este campo seria NULL';
          public          postgres    false    213            �           0    0 &   COLUMN "Cliente"."Persona_de_contacto"    COMMENT     h   COMMENT ON COLUMN public."Cliente"."Persona_de_contacto" IS 'Puede o no tener una persona de contacto';
          public          postgres    false    213            �           0    0 !   COLUMN "Cliente"."Tipo_actividad"    COMMENT     m   COMMENT ON COLUMN public."Cliente"."Tipo_actividad" IS '- True: Empresa de moda
- False: Publicidad y cine';
          public          postgres    false    213            �           0    0    TABLE "Cliente"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Cliente" TO "Gestor";
GRANT SELECT ON TABLE public."Cliente" TO "Recepcionista";
          public          postgres    false    213            �            1259    16539 !   Cliente_Contrata_Candidato_adulto    TABLE     �   CREATE TABLE public."Cliente_Contrata_Candidato_adulto" (
    "Código_cliente_Cliente" integer NOT NULL,
    "Código candidato_Candidato_adulto" integer NOT NULL,
    "Casting" integer
);
 7   DROP TABLE public."Cliente_Contrata_Candidato_adulto";
       public         heap    postgres    false            �           0    0 )   TABLE "Cliente_Contrata_Candidato_adulto"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Cliente_Contrata_Candidato_adulto" TO "Gestor";
GRANT SELECT ON TABLE public."Cliente_Contrata_Candidato_adulto" TO "Recepcionista";
          public          postgres    false    214            �            1259    16542     Cliente_Contrata_Candidato_ninio    TABLE     �   CREATE TABLE public."Cliente_Contrata_Candidato_ninio" (
    "Código_cliente_Cliente" integer NOT NULL,
    "Código candidato_Candidato_ninio" integer NOT NULL,
    "Casting" integer
);
 6   DROP TABLE public."Cliente_Contrata_Candidato_ninio";
       public         heap    postgres    false            �           0    0 (   TABLE "Cliente_Contrata_Candidato_ninio"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Cliente_Contrata_Candidato_ninio" TO "Gestor";
GRANT SELECT ON TABLE public."Cliente_Contrata_Candidato_ninio" TO "Recepcionista";
          public          postgres    false    215            �            1259    16545    Fase    TABLE     �   CREATE TABLE public."Fase" (
    "Código_de_fase" integer NOT NULL,
    "Fecha" date NOT NULL,
    "Código_casting_Casting_presencial" integer NOT NULL
);
    DROP TABLE public."Fase";
       public         heap    postgres    false            �           0    0    COLUMN "Fase"."Fecha"    COMMENT     9   COMMENT ON COLUMN public."Fase"."Fecha" IS 'dd/mm/aaaa';
          public          postgres    false    216            �           0    0    TABLE "Fase"    ACL     ~   GRANT SELECT ON TABLE public."Fase" TO "Recepcionista";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Fase" TO "Gestor";
          public          postgres    false    216            �            1259    16548     Num_fases_por_casting_presencial    VIEW     �   CREATE VIEW public."Num_fases_por_casting_presencial" AS
 SELECT count("Fase"."Código_de_fase") AS count,
    "Fase"."Código_casting_Casting_presencial"
   FROM public."Fase"
  GROUP BY "Fase"."Código_casting_Casting_presencial";
 5   DROP VIEW public."Num_fases_por_casting_presencial";
       public          postgres    false    216    216            �            1259    16552 !   Num_fases_por_casting_presencial1    VIEW     �   CREATE VIEW public."Num_fases_por_casting_presencial1" AS
 SELECT count("Fase"."Código_de_fase") AS numero,
    "Fase"."Código_casting_Casting_presencial"
   FROM public."Fase"
  GROUP BY "Fase"."Código_casting_Casting_presencial";
 6   DROP VIEW public."Num_fases_por_casting_presencial1";
       public          postgres    false    216    216            �            1259    16556 !   Num_fases_por_casting_presencial2    VIEW     �   CREATE VIEW public."Num_fases_por_casting_presencial2" AS
 SELECT count("Fase"."Código_de_fase") AS "Numero_de_fases",
    "Fase"."Código_casting_Casting_presencial"
   FROM public."Fase"
  GROUP BY "Fase"."Código_casting_Casting_presencial";
 6   DROP VIEW public."Num_fases_por_casting_presencial2";
       public          postgres    false    216    216            �            1259    16564    Numero_candidatos    VIEW       CREATE VIEW public."Numero_candidatos" AS
 SELECT count("Candidato_adulto"."Código candidato") AS numero_candidatos_adultos
   FROM public."Candidato_adulto"
UNION
 SELECT count("Candidato_ninio"."Código candidato") AS numero_candidatos_adultos
   FROM public."Candidato_ninio";
 &   DROP VIEW public."Numero_candidatos";
       public          postgres    false    206    210            �            1259    16568    Perfil    TABLE     �  CREATE TABLE public."Perfil" (
    "Codigo_perfil" integer NOT NULL,
    "Provincia" character varying(40) NOT NULL,
    "Sexo" boolean NOT NULL,
    "Altura" double precision NOT NULL,
    "Edad" integer NOT NULL,
    "Especialidad" boolean NOT NULL,
    "Experiencia" boolean NOT NULL,
    "Color_de_pelo" character varying(10) NOT NULL,
    "Color_de_ojos" character varying(10) NOT NULL
);
    DROP TABLE public."Perfil";
       public         heap    postgres    false            �           0    0    COLUMN "Perfil"."Sexo"    COMMENT     M   COMMENT ON COLUMN public."Perfil"."Sexo" IS '- True: Hombre
- False: Mujer';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Altura"    COMMENT     >   COMMENT ON COLUMN public."Perfil"."Altura" IS 'Rango: [0-3]';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Edad"    COMMENT     =   COMMENT ON COLUMN public."Perfil"."Edad" IS 'Rango: [0-95]';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Especialidad"    COMMENT     U   COMMENT ON COLUMN public."Perfil"."Especialidad" IS '- True: Modelo
- False: Actor';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Experiencia"    COMMENT     @   COMMENT ON COLUMN public."Perfil"."Experiencia" IS '- Si
- No';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Color_de_pelo"    COMMENT     g   COMMENT ON COLUMN public."Perfil"."Color_de_pelo" IS 'Restricciones: (Castaño, Rubio, Negro, Otros)';
          public          postgres    false    221            �           0    0    COLUMN "Perfil"."Color_de_ojos"    COMMENT     d   COMMENT ON COLUMN public."Perfil"."Color_de_ojos" IS 'Restricciones: (Marron, Azul, Verde, Otros)';
          public          postgres    false    221            �           0    0    TABLE "Perfil"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Perfil" TO "Gestor";
GRANT SELECT ON TABLE public."Perfil" TO "Recepcionista";
          public          postgres    false    221            �            1259    16485    Prueba_individual    TABLE     \  CREATE TABLE public."Prueba_individual" (
    "Código_prueba" integer NOT NULL,
    "Fecha" date NOT NULL,
    "Descripción" character varying(50) NOT NULL,
    "Coste" double precision NOT NULL,
    "Código_de_fase_Fase" integer NOT NULL,
    "Código_casting_Casting_presencial_Fase" integer NOT NULL,
    "Sala" character varying NOT NULL
);
 '   DROP TABLE public."Prueba_individual";
       public         heap    postgres    false            �           0    0 +   COLUMN "Prueba_individual"."Código_prueba"    COMMENT     M   COMMENT ON COLUMN public."Prueba_individual"."Código_prueba" IS '0 - 9999';
          public          postgres    false    205            �           0    0 "   COLUMN "Prueba_individual"."Fecha"    COMMENT     F   COMMENT ON COLUMN public."Prueba_individual"."Fecha" IS 'dd/mm/aaaa';
          public          postgres    false    205            �           0    0    TABLE "Prueba_individual"    ACL     �   GRANT SELECT ON TABLE public."Prueba_individual" TO "Recepcionista";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Prueba_individual" TO "Gestor";
          public          postgres    false    205            �            1259    16571    Recaudacion_por_candidatos    VIEW       CREATE VIEW public."Recaudacion_por_candidatos" AS
 SELECT t1."Código candidato_Candidato_adulto",
    ("Casting_presencial"."Coste" + t1."Coste") AS coste_total
   FROM (public."Candidato_adulto_realiza_Prueba_individual"
     JOIN public."Prueba_individual" ON (("Candidato_adulto_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba"))) t1,
    public."Casting_presencial"
  WHERE ("Casting_presencial"."Código_casting" = t1."Código_casting_Casting_presencial_Fase")
UNION
 SELECT t1."Código candidato_Candidato_ninio" AS "Código candidato_Candidato_adulto",
    ("Casting_presencial"."Coste" + t1."Coste") AS coste_total
   FROM (public."Candidato_ninio_realiza_Prueba_individual"
     JOIN public."Prueba_individual" ON (("Candidato_ninio_realiza_Prueba_individual"."Código_prueba_Prueba_individual" = "Prueba_individual"."Código_prueba"))) t1,
    public."Casting_presencial"
  WHERE ("Casting_presencial"."Código_casting" = t1."Código_casting_Casting_presencial_Fase")
  ORDER BY 1;
 /   DROP VIEW public."Recaudacion_por_candidatos";
       public          postgres    false    202    201    201    204    205    205    205    204    202            �            1259    16576    Representante    TABLE     v   CREATE TABLE public."Representante" (
    "NIF" character(9) NOT NULL,
    "Nombre" character varying(40) NOT NULL
);
 #   DROP TABLE public."Representante";
       public         heap    postgres    false            �           0    0    TABLE "Representante"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Representante" TO "Gestor";
GRANT SELECT ON TABLE public."Representante" TO "Recepcionista";
          public          postgres    false    223            �            1259    16579    Telefono_representante    TABLE     �   CREATE TABLE public."Telefono_representante" (
    "Telefono" integer NOT NULL,
    "NIF_Representente" character(9) NOT NULL
);
 ,   DROP TABLE public."Telefono_representante";
       public         heap    postgres    false            �           0    0    TABLE "Telefono_representante"    COMMENT     g   COMMENT ON TABLE public."Telefono_representante" IS 'Se guardaran los telefonos de un representante.';
          public          postgres    false    224            �           0    0 *   COLUMN "Telefono_representante"."Telefono"    COMMENT     �   COMMENT ON COLUMN public."Telefono_representante"."Telefono" IS 'Empieza por 6, 7 o 9 /pues podría tratarse tambien de un numero fijo)
No puede tener nulos (Cliente mínimo deberá tener un teléfono asociado)';
          public          postgres    false    224            �           0    0    TABLE "Telefono_representante"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Telefono_representante" TO "Gestor";
GRANT SELECT ON TABLE public."Telefono_representante" TO "Recepcionista";
          public          postgres    false    224            �            1259    16594    Representante_con_telefono    VIEW     0  CREATE VIEW public."Representante_con_telefono" AS
 SELECT "Representante"."NIF",
    "Representante"."Nombre",
    "Telefono_representante"."Telefono"
   FROM (public."Representante"
     JOIN public."Telefono_representante" ON (("Representante"."NIF" = "Telefono_representante"."NIF_Representente")));
 /   DROP VIEW public."Representante_con_telefono";
       public          postgres    false    223    224    224    223            �            1259    16598    Telefono_Candidato_adulto    TABLE     �   CREATE TABLE public."Telefono_Candidato_adulto" (
    "Telefono" integer NOT NULL,
    "Codigo_candidato_Candidato_adulto" integer NOT NULL
);
 /   DROP TABLE public."Telefono_Candidato_adulto";
       public         heap    postgres    false            �           0    0 !   TABLE "Telefono_Candidato_adulto"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Telefono_Candidato_adulto" TO "Gestor";
GRANT SELECT ON TABLE public."Telefono_Candidato_adulto" TO "Recepcionista";
          public          postgres    false    226            �            1259    16601    Telefono_Candidato_ninio    TABLE     �   CREATE TABLE public."Telefono_Candidato_ninio" (
    "Telefono" integer NOT NULL,
    "Código candidato_Candidato_ninio" integer NOT NULL
);
 .   DROP TABLE public."Telefono_Candidato_ninio";
       public         heap    postgres    false            �           0    0 ,   COLUMN "Telefono_Candidato_ninio"."Telefono"    COMMENT     �   COMMENT ON COLUMN public."Telefono_Candidato_ninio"."Telefono" IS 'Empieza por 6, 7 o 9 (pues podría tratarse tambien de un numero fijo)
No puede tener nulos (Cliente mínimo deberá tener un teléfono asociado)';
          public          postgres    false    227            �           0    0     TABLE "Telefono_Candidato_ninio"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Telefono_Candidato_ninio" TO "Gestor";
GRANT SELECT ON TABLE public."Telefono_Candidato_ninio" TO "Recepcionista";
          public          postgres    false    227            �            1259    16604    Telefono_cliente    TABLE     |   CREATE TABLE public."Telefono_cliente" (
    "Telefono" integer NOT NULL,
    "Código_cliente_Cliente" integer NOT NULL
);
 &   DROP TABLE public."Telefono_cliente";
       public         heap    postgres    false            �           0    0 $   COLUMN "Telefono_cliente"."Telefono"    COMMENT     �   COMMENT ON COLUMN public."Telefono_cliente"."Telefono" IS 'Empieza por 6, 7 o 9 /pues podría tratarse tambien de un numero fijo)
No puede tener nulos (Cliente mínimo deberá tener un teléfono asociado)';
          public          postgres    false    228            �           0    0    TABLE "Telefono_cliente"    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Telefono_cliente" TO "Gestor";
GRANT SELECT ON TABLE public."Telefono_cliente" TO "Recepcionista";
          public          postgres    false    228            n          0    16470    Agente de casting 
   TABLE DATA           �   COPY public."Agente de casting" ("numEmpleado", "Nombre", "DNI", "Código_casting_Casting_presencial", "Calle", "Ciudad", piso, "Portal") FROM stdin;
    public          postgres    false    200   �:      t          0    16504    Candidato_adulto 
   TABLE DATA           �   COPY public."Candidato_adulto" ("Código candidato", "Nombre", "Fecha nacimiento", "DNI", "NIF_Representante", "Codigo_perfil_Perfil", "Calle", "Piso", "Ciudad", "Portal", "Coste_total") FROM stdin;
    public          postgres    false    206   m<      o          0    16473 *   Candidato_adulto_realiza_Prueba_individual 
   TABLE DATA             COPY public."Candidato_adulto_realiza_Prueba_individual" ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto", "Valido") FROM stdin;
    public          postgres    false    201   ,>      u          0    16523    Candidato_ninio 
   TABLE DATA           �   COPY public."Candidato_ninio" ("Código candidato", "Nombre", "Fecha nacimiento", "Nombre_tutor", "NIF_Representante", "Codigo_perfil_Perfil", "Calle", "Piso", "Ciudad", "Portal", "Coste_total") FROM stdin;
    public          postgres    false    210   �>      p          0    16476 )   Candidato_ninio_realiza_Prueba_individual 
   TABLE DATA           �   COPY public."Candidato_ninio_realiza_Prueba_individual" ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio", "Valido") FROM stdin;
    public          postgres    false    202   �?      q          0    16479    Casting_online 
   TABLE DATA           �   COPY public."Casting_online" ("Código_casting", "Nombre", "Descripción", "Coste", "NumPersonas", "Fecha", "Código_cliente_Cliente", "Plataforma_web") FROM stdin;
    public          postgres    false    203   �?      v          0    16530    Casting_online_necesita_Perfil 
   TABLE DATA           t   COPY public."Casting_online_necesita_Perfil" ("Código_casting_Casting_online", "Codigo_perfil_Perfil") FROM stdin;
    public          postgres    false    211   �@      r          0    16482    Casting_presencial 
   TABLE DATA           �   COPY public."Casting_presencial" ("Código_casting", "Nombre", "Descripción", "Coste", "NumPersonas", "Fecha", "Código_cliente_Cliente") FROM stdin;
    public          postgres    false    204   A      w          0    16533 "   Casting_presencial_necesita_Perfil 
   TABLE DATA           |   COPY public."Casting_presencial_necesita_Perfil" ("Código_casting_Casting_presencial", "Codigo_perfil_Perfil") FROM stdin;
    public          postgres    false    212   �B      x          0    16536    Cliente 
   TABLE DATA           �   COPY public."Cliente" ("Código_cliente", "Nombre", "Calle", "Portal", "Piso", "Ciudad", "Persona_de_contacto", "Tipo_actividad") FROM stdin;
    public          postgres    false    213   �B      y          0    16539 !   Cliente_Contrata_Candidato_adulto 
   TABLE DATA           �   COPY public."Cliente_Contrata_Candidato_adulto" ("Código_cliente_Cliente", "Código candidato_Candidato_adulto", "Casting") FROM stdin;
    public          postgres    false    214   �D      z          0    16542     Cliente_Contrata_Candidato_ninio 
   TABLE DATA           �   COPY public."Cliente_Contrata_Candidato_ninio" ("Código_cliente_Cliente", "Código candidato_Candidato_ninio", "Casting") FROM stdin;
    public          postgres    false    215   �D      {          0    16545    Fase 
   TABLE DATA           b   COPY public."Fase" ("Código_de_fase", "Fecha", "Código_casting_Casting_presencial") FROM stdin;
    public          postgres    false    216   E      |          0    16568    Perfil 
   TABLE DATA           �   COPY public."Perfil" ("Codigo_perfil", "Provincia", "Sexo", "Altura", "Edad", "Especialidad", "Experiencia", "Color_de_pelo", "Color_de_ojos") FROM stdin;
    public          postgres    false    221   �E      s          0    16485    Prueba_individual 
   TABLE DATA           �   COPY public."Prueba_individual" ("Código_prueba", "Fecha", "Descripción", "Coste", "Código_de_fase_Fase", "Código_casting_Casting_presencial_Fase", "Sala") FROM stdin;
    public          postgres    false    205   �F      }          0    16576    Representante 
   TABLE DATA           :   COPY public."Representante" ("NIF", "Nombre") FROM stdin;
    public          postgres    false    223   XH                0    16598    Telefono_Candidato_adulto 
   TABLE DATA           f   COPY public."Telefono_Candidato_adulto" ("Telefono", "Codigo_candidato_Candidato_adulto") FROM stdin;
    public          postgres    false    226   I      �          0    16601    Telefono_Candidato_ninio 
   TABLE DATA           e   COPY public."Telefono_Candidato_ninio" ("Telefono", "Código candidato_Candidato_ninio") FROM stdin;
    public          postgres    false    227   CI      �          0    16604    Telefono_cliente 
   TABLE DATA           S   COPY public."Telefono_cliente" ("Telefono", "Código_cliente_Cliente") FROM stdin;
    public          postgres    false    228   �I      ~          0    16579    Telefono_representante 
   TABLE DATA           S   COPY public."Telefono_representante" ("Telefono", "NIF_Representente") FROM stdin;
    public          postgres    false    224   J      �           2606    16612 &   Agente de casting Agente de casting_pk 
   CONSTRAINT     s   ALTER TABLE ONLY public."Agente de casting"
    ADD CONSTRAINT "Agente de casting_pk" PRIMARY KEY ("numEmpleado");
 T   ALTER TABLE ONLY public."Agente de casting" DROP CONSTRAINT "Agente de casting_pk";
       public            postgres    false    200            �           2606    16614    Candidato_ninio Candidato_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public."Candidato_ninio"
    ADD CONSTRAINT "Candidato_pk" PRIMARY KEY ("Código candidato");
 J   ALTER TABLE ONLY public."Candidato_ninio" DROP CONSTRAINT "Candidato_pk";
       public            postgres    false    210            �           2606    16616     Candidato_adulto Candidato_pk_cp 
   CONSTRAINT     s   ALTER TABLE ONLY public."Candidato_adulto"
    ADD CONSTRAINT "Candidato_pk_cp" PRIMARY KEY ("Código candidato");
 N   ALTER TABLE ONLY public."Candidato_adulto" DROP CONSTRAINT "Candidato_pk_cp";
       public            postgres    false    206            �           2606    16618 @   Casting_online_necesita_Perfil Casting_online_necesita_Perfil_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Casting_online_necesita_Perfil"
    ADD CONSTRAINT "Casting_online_necesita_Perfil_pk" PRIMARY KEY ("Código_casting_Casting_online", "Codigo_perfil_Perfil");
 n   ALTER TABLE ONLY public."Casting_online_necesita_Perfil" DROP CONSTRAINT "Casting_online_necesita_Perfil_pk";
       public            postgres    false    211    211            �           2606    16620    Casting_online Casting_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public."Casting_online"
    ADD CONSTRAINT "Casting_pk" PRIMARY KEY ("Código_casting");
 G   ALTER TABLE ONLY public."Casting_online" DROP CONSTRAINT "Casting_pk";
       public            postgres    false    203            �           2606    16622     Casting_presencial Casting_pk_cp 
   CONSTRAINT     q   ALTER TABLE ONLY public."Casting_presencial"
    ADD CONSTRAINT "Casting_pk_cp" PRIMARY KEY ("Código_casting");
 N   ALTER TABLE ONLY public."Casting_presencial" DROP CONSTRAINT "Casting_pk_cp";
       public            postgres    false    204            �           2606    16624 H   Casting_presencial_necesita_Perfil Casting_presencial_necesita_Perfil_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil"
    ADD CONSTRAINT "Casting_presencial_necesita_Perfil_pk" PRIMARY KEY ("Código_casting_Casting_presencial", "Codigo_perfil_Perfil");
 v   ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil" DROP CONSTRAINT "Casting_presencial_necesita_Perfil_pk";
       public            postgres    false    212    212            �           2606    16626 >   Cliente_Contrata_Candidato_ninio Cliente_Contrata_Candidato_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio"
    ADD CONSTRAINT "Cliente_Contrata_Candidato_pk" PRIMARY KEY ("Código_cliente_Cliente", "Código candidato_Candidato_ninio");
 l   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio" DROP CONSTRAINT "Cliente_Contrata_Candidato_pk";
       public            postgres    false    215    215            �           2606    16628    Cliente Cliente_pk 
   CONSTRAINT     c   ALTER TABLE ONLY public."Cliente"
    ADD CONSTRAINT "Cliente_pk" PRIMARY KEY ("Código_cliente");
 @   ALTER TABLE ONLY public."Cliente" DROP CONSTRAINT "Cliente_pk";
       public            postgres    false    213            �           2606    16630    Fase Fase_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Fase"
    ADD CONSTRAINT "Fase_pk" PRIMARY KEY ("Código_de_fase", "Código_casting_Casting_presencial");
 :   ALTER TABLE ONLY public."Fase" DROP CONSTRAINT "Fase_pk";
       public            postgres    false    216    216            �           2606    16632    Perfil Perfil1_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public."Perfil"
    ADD CONSTRAINT "Perfil1_pk" PRIMARY KEY ("Codigo_perfil");
 ?   ALTER TABLE ONLY public."Perfil" DROP CONSTRAINT "Perfil1_pk";
       public            postgres    false    221            �           2606    16634 &   Prueba_individual Prueba_individual_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Prueba_individual"
    ADD CONSTRAINT "Prueba_individual_pk" PRIMARY KEY ("Código_prueba", "Código_de_fase_Fase", "Código_casting_Casting_presencial_Fase");
 T   ALTER TABLE ONLY public."Prueba_individual" DROP CONSTRAINT "Prueba_individual_pk";
       public            postgres    false    205    205    205            �           2606    16636 X   Candidato_adulto_realiza_Prueba_individual Prueba_individual_realiza_Candidato_adulto_pk 
   CONSTRAINT     G  ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual"
    ADD CONSTRAINT "Prueba_individual_realiza_Candidato_adulto_pk" PRIMARY KEY ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_adulto");
 �   ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual" DROP CONSTRAINT "Prueba_individual_realiza_Candidato_adulto_pk";
       public            postgres    false    201    201    201    201            �           2606    16638 V   Candidato_ninio_realiza_Prueba_individual Prueba_individual_realiza_Candidato_ninio_pk 
   CONSTRAINT     D  ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual"
    ADD CONSTRAINT "Prueba_individual_realiza_Candidato_ninio_pk" PRIMARY KEY ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual", "Código candidato_Candidato_ninio");
 �   ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual" DROP CONSTRAINT "Prueba_individual_realiza_Candidato_ninio_pk";
       public            postgres    false    202    202    202    202            �           2606    16640    Representante Representente_pk 
   CONSTRAINT     c   ALTER TABLE ONLY public."Representante"
    ADD CONSTRAINT "Representente_pk" PRIMARY KEY ("NIF");
 L   ALTER TABLE ONLY public."Representante" DROP CONSTRAINT "Representente_pk";
       public            postgres    false    223            �           2606    16642 8   Telefono_Candidato_adulto Telefono_Candidato_adulto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_Candidato_adulto"
    ADD CONSTRAINT "Telefono_Candidato_adulto_pkey" PRIMARY KEY ("Telefono", "Codigo_candidato_Candidato_adulto");
 f   ALTER TABLE ONLY public."Telefono_Candidato_adulto" DROP CONSTRAINT "Telefono_Candidato_adulto_pkey";
       public            postgres    false    226    226            �           2606    16644 4   Telefono_Candidato_ninio Telefono_Candidato_ninio_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_Candidato_ninio"
    ADD CONSTRAINT "Telefono_Candidato_ninio_pk" PRIMARY KEY ("Telefono", "Código candidato_Candidato_ninio");
 b   ALTER TABLE ONLY public."Telefono_Candidato_ninio" DROP CONSTRAINT "Telefono_Candidato_ninio_pk";
       public            postgres    false    227    227            �           2606    16646 $   Telefono_cliente Telefono_cliente_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_cliente"
    ADD CONSTRAINT "Telefono_cliente_pk" PRIMARY KEY ("Telefono", "Código_cliente_Cliente");
 R   ALTER TABLE ONLY public."Telefono_cliente" DROP CONSTRAINT "Telefono_cliente_pk";
       public            postgres    false    228    228            �           2606    16648 0   Telefono_representante Telefono_representante_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_representante"
    ADD CONSTRAINT "Telefono_representante_pk" PRIMARY KEY ("Telefono", "NIF_Representente");
 ^   ALTER TABLE ONLY public."Telefono_representante" DROP CONSTRAINT "Telefono_representante_pk";
       public            postgres    false    224    224            �           2606    16650 K   Cliente_Contrata_Candidato_adulto many_Cliente_has_many_Candidato_adulto_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto"
    ADD CONSTRAINT "many_Cliente_has_many_Candidato_adulto_pk" PRIMARY KEY ("Código_cliente_Cliente", "Código candidato_Candidato_adulto");
 y   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto" DROP CONSTRAINT "many_Cliente_has_many_Candidato_adulto_pk";
       public            postgres    false    214    214            �           2620    50939 H   Candidato_adulto_realiza_Prueba_individual Calcula_importe_total_adultos    TRIGGER     �   CREATE TRIGGER "Calcula_importe_total_adultos" AFTER INSERT OR UPDATE ON public."Candidato_adulto_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."Importe_total_adultos"();
 e   DROP TRIGGER "Calcula_importe_total_adultos" ON public."Candidato_adulto_realiza_Prueba_individual";
       public          postgres    false    201    240            �           0    0 W   TRIGGER "Calcula_importe_total_adultos" ON "Candidato_adulto_realiza_Prueba_individual"    COMMENT     �   COMMENT ON TRIGGER "Calcula_importe_total_adultos" ON public."Candidato_adulto_realiza_Prueba_individual" IS 'Calcular el importe total que ha pagado cada candidato teniendo en cuenta todas las pruebas que ha realizado.';
          public          postgres    false    3035            �           2620    50942 E   Candidato_ninio_realiza_Prueba_individual Calcula_importe_total_ninio    TRIGGER     �   CREATE TRIGGER "Calcula_importe_total_ninio" AFTER INSERT OR UPDATE ON public."Candidato_ninio_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."Importe_total_ninios"();
 b   DROP TRIGGER "Calcula_importe_total_ninio" ON public."Candidato_ninio_realiza_Prueba_individual";
       public          postgres    false    202    241            �           0    0 T   TRIGGER "Calcula_importe_total_ninio" ON "Candidato_ninio_realiza_Prueba_individual"    COMMENT     �   COMMENT ON TRIGGER "Calcula_importe_total_ninio" ON public."Candidato_ninio_realiza_Prueba_individual" IS 'Calcular el importe total que ha pagado cada candidato ninio teniendo en cuenta todas las pruebas que ha realizado.';
          public          postgres    false    3038            �           2620    50940 I   Candidato_adulto_realiza_Prueba_individual Candidato_adulto_supera_prueba    TRIGGER     �   CREATE TRIGGER "Candidato_adulto_supera_prueba" AFTER INSERT OR UPDATE ON public."Candidato_adulto_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."ContadorPruebas_adultos"();
 f   DROP TRIGGER "Candidato_adulto_supera_prueba" ON public."Candidato_adulto_realiza_Prueba_individual";
       public          postgres    false    242    201            �           0    0 X   TRIGGER "Candidato_adulto_supera_prueba" ON "Candidato_adulto_realiza_Prueba_individual"    COMMENT     �  COMMENT ON TRIGGER "Candidato_adulto_supera_prueba" ON public."Candidato_adulto_realiza_Prueba_individual" IS 'Cuando un candidato adulto supera una prueba de un casting, se debe calcular el número de pruebas superadas por dicho candidato. Si ese número coincide con el número de pruebas totales de dicho casting, se mostrará
un mensaje y se insertará en la tabla “contrata”.';
          public          postgres    false    3036            �           2620    50943 G   Candidato_ninio_realiza_Prueba_individual Candidato_ninio_supera_prueba    TRIGGER     �   CREATE TRIGGER "Candidato_ninio_supera_prueba" AFTER INSERT OR UPDATE ON public."Candidato_ninio_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."ContadorPruebas_ninios"();
 d   DROP TRIGGER "Candidato_ninio_supera_prueba" ON public."Candidato_ninio_realiza_Prueba_individual";
       public          postgres    false    202    243            �           0    0 V   TRIGGER "Candidato_ninio_supera_prueba" ON "Candidato_ninio_realiza_Prueba_individual"    COMMENT     �  COMMENT ON TRIGGER "Candidato_ninio_supera_prueba" ON public."Candidato_ninio_realiza_Prueba_individual" IS 'Cuando un candidato ninio supera una prueba de un casting, se debe calcular el número de pruebas superadas por dicho candidato. Si ese número coincide con el número de pruebas totales de dicho casting, se mostrará un mensaje y se insertará en la tabla “contrata”.';
          public          postgres    false    3039            �           2620    50945 B   Cliente_Contrata_Candidato_adulto Comprobar_contrataciones_adultos    TRIGGER     �   CREATE TRIGGER "Comprobar_contrataciones_adultos" AFTER INSERT ON public."Cliente_Contrata_Candidato_adulto" FOR EACH ROW EXECUTE FUNCTION public."Comprobar_contrataciones_adultos"();
 _   DROP TRIGGER "Comprobar_contrataciones_adultos" ON public."Cliente_Contrata_Candidato_adulto";
       public          postgres    false    244    214            �           0    0 Q   TRIGGER "Comprobar_contrataciones_adultos" ON "Cliente_Contrata_Candidato_adulto"    COMMENT     �  COMMENT ON TRIGGER "Comprobar_contrataciones_adultos" ON public."Cliente_Contrata_Candidato_adulto" IS 'Al insertar un candidato adulto en la tabla “contrata” se debe comprobar si para ese casting en particular ya se han contratado suficientes personas. Para ello, se deberá comparar el número de candidatos seleccionados para ese
casting con el número de personas requerido al contratar el casting.';
          public          postgres    false    3041            �           2620    50946 @   Cliente_Contrata_Candidato_ninio Comprobar_contrataciones_ninios    TRIGGER     �   CREATE TRIGGER "Comprobar_contrataciones_ninios" AFTER INSERT ON public."Cliente_Contrata_Candidato_ninio" FOR EACH ROW EXECUTE FUNCTION public."Comprobar_contrataciones_ninios"();
 ]   DROP TRIGGER "Comprobar_contrataciones_ninios" ON public."Cliente_Contrata_Candidato_ninio";
       public          postgres    false    215    245            �           0    0 O   TRIGGER "Comprobar_contrataciones_ninios" ON "Cliente_Contrata_Candidato_ninio"    COMMENT     �  COMMENT ON TRIGGER "Comprobar_contrataciones_ninios" ON public."Cliente_Contrata_Candidato_ninio" IS 'Al insertar un candidato ninio en la tabla “contrata” se debe comprobar si para ese casting en particular ya se han contratado suficientes personas. Para ello, se deberá comparar el número de candidatos seleccionados para ese casting con el número de personas requerido al contratar el casting.';
          public          postgres    false    3042            �           2620    50941 L   Candidato_adulto_realiza_Prueba_individual Comprueba_perfil_candidato_adulto    TRIGGER     �   CREATE TRIGGER "Comprueba_perfil_candidato_adulto" AFTER INSERT OR UPDATE ON public."Candidato_adulto_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."Comprobar_perfil_adultos"();
 i   DROP TRIGGER "Comprueba_perfil_candidato_adulto" ON public."Candidato_adulto_realiza_Prueba_individual";
       public          postgres    false    246    201            �           0    0 [   TRIGGER "Comprueba_perfil_candidato_adulto" ON "Candidato_adulto_realiza_Prueba_individual"    COMMENT       COMMENT ON TRIGGER "Comprueba_perfil_candidato_adulto" ON public."Candidato_adulto_realiza_Prueba_individual" IS 'Cuando un candidato adulto realiza una prueba de un determinado casting, se debe comprobar si su perfil encaja en alguno de los perfiles requeridos por en dicho casting.';
          public          postgres    false    3037            �           2620    50944 J   Candidato_ninio_realiza_Prueba_individual Comprueba_perfil_candidato_ninio    TRIGGER     �   CREATE TRIGGER "Comprueba_perfil_candidato_ninio" AFTER INSERT OR UPDATE ON public."Candidato_ninio_realiza_Prueba_individual" FOR EACH ROW EXECUTE FUNCTION public."Comprobar_perfil_ninios"();
 g   DROP TRIGGER "Comprueba_perfil_candidato_ninio" ON public."Candidato_ninio_realiza_Prueba_individual";
       public          postgres    false    247    202            �           0    0 Y   TRIGGER "Comprueba_perfil_candidato_ninio" ON "Candidato_ninio_realiza_Prueba_individual"    COMMENT       COMMENT ON TRIGGER "Comprueba_perfil_candidato_ninio" ON public."Candidato_ninio_realiza_Prueba_individual" IS 'Cuando un candidato ninio realiza una prueba de un determinado casting, se debe comprobar si su perfil encaja en alguno de los perfiles requeridos por en dicho casting.';
          public          postgres    false    3040            �           2606    16651 5   Cliente_Contrata_Candidato_adulto Candidato_adulto_fk    FK CONSTRAINT       ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto"
    ADD CONSTRAINT "Candidato_adulto_fk" FOREIGN KEY ("Código candidato_Candidato_adulto") REFERENCES public."Candidato_adulto"("Código candidato") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 c   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto" DROP CONSTRAINT "Candidato_adulto_fk";
       public          postgres    false    214    206    2984            �           2606    16656 >   Candidato_adulto_realiza_Prueba_individual Candidato_adulto_fk    FK CONSTRAINT       ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual"
    ADD CONSTRAINT "Candidato_adulto_fk" FOREIGN KEY ("Código candidato_Candidato_adulto") REFERENCES public."Candidato_adulto"("Código candidato") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 l   ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual" DROP CONSTRAINT "Candidato_adulto_fk";
       public          postgres    false    206    201    2984            �           2606    16661 3   Cliente_Contrata_Candidato_ninio Candidato_ninio_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio"
    ADD CONSTRAINT "Candidato_ninio_fk" FOREIGN KEY ("Código candidato_Candidato_ninio") REFERENCES public."Candidato_ninio"("Código candidato") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 a   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio" DROP CONSTRAINT "Candidato_ninio_fk";
       public          postgres    false    2986    210    215            �           2606    16666 <   Candidato_ninio_realiza_Prueba_individual Candidato_ninio_fk    FK CONSTRAINT       ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual"
    ADD CONSTRAINT "Candidato_ninio_fk" FOREIGN KEY ("Código candidato_Candidato_ninio") REFERENCES public."Candidato_ninio"("Código candidato") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 j   ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual" DROP CONSTRAINT "Candidato_ninio_fk";
       public          postgres    false    202    210    2986            �           2606    16671 +   Telefono_Candidato_ninio Candidato_ninio_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_Candidato_ninio"
    ADD CONSTRAINT "Candidato_ninio_fk" FOREIGN KEY ("Código candidato_Candidato_ninio") REFERENCES public."Candidato_ninio"("Código candidato") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 Y   ALTER TABLE ONLY public."Telefono_Candidato_ninio" DROP CONSTRAINT "Candidato_ninio_fk";
       public          postgres    false    227    210    2986            �           2606    16676 0   Casting_online_necesita_Perfil Casting_online_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Casting_online_necesita_Perfil"
    ADD CONSTRAINT "Casting_online_fk" FOREIGN KEY ("Código_casting_Casting_online") REFERENCES public."Casting_online"("Código_casting") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 ^   ALTER TABLE ONLY public."Casting_online_necesita_Perfil" DROP CONSTRAINT "Casting_online_fk";
       public          postgres    false    211    203    2978            �           2606    16681 8   Casting_presencial_necesita_Perfil Casting_presencial_fk    FK CONSTRAINT       ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil"
    ADD CONSTRAINT "Casting_presencial_fk" FOREIGN KEY ("Código_casting_Casting_presencial") REFERENCES public."Casting_presencial"("Código_casting") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 f   ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil" DROP CONSTRAINT "Casting_presencial_fk";
       public          postgres    false    2980    212    204            �           2606    16686 '   Agente de casting Casting_presencial_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Agente de casting"
    ADD CONSTRAINT "Casting_presencial_fk" FOREIGN KEY ("Código_casting_Casting_presencial") REFERENCES public."Casting_presencial"("Código_casting") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 U   ALTER TABLE ONLY public."Agente de casting" DROP CONSTRAINT "Casting_presencial_fk";
       public          postgres    false    2980    204    200            �           2606    16691    Fase Casting_presencial_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Fase"
    ADD CONSTRAINT "Casting_presencial_fk" FOREIGN KEY ("Código_casting_Casting_presencial") REFERENCES public."Casting_presencial"("Código_casting") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."Fase" DROP CONSTRAINT "Casting_presencial_fk";
       public          postgres    false    204    216    2980            �           2606    16696    Casting_online Cliente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Casting_online"
    ADD CONSTRAINT "Cliente_fk" FOREIGN KEY ("Código_cliente_Cliente") REFERENCES public."Cliente"("Código_cliente") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 G   ALTER TABLE ONLY public."Casting_online" DROP CONSTRAINT "Cliente_fk";
       public          postgres    false    2992    213    203            �           2606    16701 +   Cliente_Contrata_Candidato_ninio Cliente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio"
    ADD CONSTRAINT "Cliente_fk" FOREIGN KEY ("Código_cliente_Cliente") REFERENCES public."Cliente"("Código_cliente") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 Y   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_ninio" DROP CONSTRAINT "Cliente_fk";
       public          postgres    false    2992    215    213            �           2606    16706    Casting_presencial Cliente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Casting_presencial"
    ADD CONSTRAINT "Cliente_fk" FOREIGN KEY ("Código_cliente_Cliente") REFERENCES public."Cliente"("Código_cliente") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 K   ALTER TABLE ONLY public."Casting_presencial" DROP CONSTRAINT "Cliente_fk";
       public          postgres    false    2992    213    204            �           2606    16711 ,   Cliente_Contrata_Candidato_adulto Cliente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto"
    ADD CONSTRAINT "Cliente_fk" FOREIGN KEY ("Código_cliente_Cliente") REFERENCES public."Cliente"("Código_cliente") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public."Cliente_Contrata_Candidato_adulto" DROP CONSTRAINT "Cliente_fk";
       public          postgres    false    214    2992    213            �           2606    16716    Telefono_cliente Cliente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_cliente"
    ADD CONSTRAINT "Cliente_fk" FOREIGN KEY ("Código_cliente_Cliente") REFERENCES public."Cliente"("Código_cliente") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 I   ALTER TABLE ONLY public."Telefono_cliente" DROP CONSTRAINT "Cliente_fk";
       public          postgres    false    228    213    2992            �           2606    16721    Prueba_individual Fase_fk    FK CONSTRAINT       ALTER TABLE ONLY public."Prueba_individual"
    ADD CONSTRAINT "Fase_fk" FOREIGN KEY ("Código_de_fase_Fase", "Código_casting_Casting_presencial_Fase") REFERENCES public."Fase"("Código_de_fase", "Código_casting_Casting_presencial") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public."Prueba_individual" DROP CONSTRAINT "Fase_fk";
       public          postgres    false    205    205    216    216    2998            �           2606    16726 ,   Casting_presencial_necesita_Perfil Perfil_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil"
    ADD CONSTRAINT "Perfil_fk" FOREIGN KEY ("Codigo_perfil_Perfil") REFERENCES public."Perfil"("Codigo_perfil") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public."Casting_presencial_necesita_Perfil" DROP CONSTRAINT "Perfil_fk";
       public          postgres    false    3000    221    212            �           2606    16731 (   Casting_online_necesita_Perfil Perfil_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Casting_online_necesita_Perfil"
    ADD CONSTRAINT "Perfil_fk" FOREIGN KEY ("Codigo_perfil_Perfil") REFERENCES public."Perfil"("Codigo_perfil") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 V   ALTER TABLE ONLY public."Casting_online_necesita_Perfil" DROP CONSTRAINT "Perfil_fk";
       public          postgres    false    221    3000    211            �           2606    16736    Candidato_adulto Perfil_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Candidato_adulto"
    ADD CONSTRAINT "Perfil_fk" FOREIGN KEY ("Codigo_perfil_Perfil") REFERENCES public."Perfil"("Codigo_perfil") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 H   ALTER TABLE ONLY public."Candidato_adulto" DROP CONSTRAINT "Perfil_fk";
       public          postgres    false    206    221    3000            �           2606    16741    Candidato_ninio Perfil_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Candidato_ninio"
    ADD CONSTRAINT "Perfil_fk" FOREIGN KEY ("Codigo_perfil_Perfil") REFERENCES public."Perfil"("Codigo_perfil") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 G   ALTER TABLE ONLY public."Candidato_ninio" DROP CONSTRAINT "Perfil_fk";
       public          postgres    false    210    221    3000            �           2606    16746 ?   Candidato_adulto_realiza_Prueba_individual Prueba_individual_fk    FK CONSTRAINT     �  ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual"
    ADD CONSTRAINT "Prueba_individual_fk" FOREIGN KEY ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual") REFERENCES public."Prueba_individual"("Código_prueba", "Código_de_fase_Fase", "Código_casting_Casting_presencial_Fase") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 m   ALTER TABLE ONLY public."Candidato_adulto_realiza_Prueba_individual" DROP CONSTRAINT "Prueba_individual_fk";
       public          postgres    false    201    201    201    205    205    205    2982            �           2606    16751 >   Candidato_ninio_realiza_Prueba_individual Prueba_individual_fk    FK CONSTRAINT     �  ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual"
    ADD CONSTRAINT "Prueba_individual_fk" FOREIGN KEY ("Código_prueba_Prueba_individual", "Código_de_fase_Fase_Prueba_individual", "Código_casting_Casting_presencial_Fase_Prueba_individual") REFERENCES public."Prueba_individual"("Código_prueba", "Código_de_fase_Fase", "Código_casting_Casting_presencial_Fase") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;
 l   ALTER TABLE ONLY public."Candidato_ninio_realiza_Prueba_individual" DROP CONSTRAINT "Prueba_individual_fk";
       public          postgres    false    202    202    205    2982    202    205    205            �           2606    16756 !   Candidato_adulto Representente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Candidato_adulto"
    ADD CONSTRAINT "Representente_fk" FOREIGN KEY ("NIF_Representante") REFERENCES public."Representante"("NIF") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
 O   ALTER TABLE ONLY public."Candidato_adulto" DROP CONSTRAINT "Representente_fk";
       public          postgres    false    223    3002    206            �           2606    16761     Candidato_ninio Representente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Candidato_ninio"
    ADD CONSTRAINT "Representente_fk" FOREIGN KEY ("NIF_Representante") REFERENCES public."Representante"("NIF") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
 N   ALTER TABLE ONLY public."Candidato_ninio" DROP CONSTRAINT "Representente_fk";
       public          postgres    false    223    210    3002            �           2606    16766 '   Telefono_representante Representente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Telefono_representante"
    ADD CONSTRAINT "Representente_fk" FOREIGN KEY ("NIF_Representente") REFERENCES public."Representante"("NIF") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
 U   ALTER TABLE ONLY public."Telefono_representante" DROP CONSTRAINT "Representente_fk";
       public          postgres    false    3002    223    224            '           826    49545    DEFAULT PRIVILEGES FOR TABLES    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO "Administrador" WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO "Gestor";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT ON TABLES  TO "Recepcionista";
                   postgres    false            n   �  x�e�ώ�0�ϓ�����sL�mWU��jAB�2$�b�ڋ�\x-n9�c�M�o����7��U�w�˾MP�JT��*ظ1w�..���=l��A̈́��l1W~�xb��օq&��xK�#0ƹR������˝����]��i�M��o�q!�6�J���硿P��fj�.��xz�F+)8;�\�O>GzM�-ƛ�zw4���6�P��Ԋ<����X�H0��&���\���^�4>��j2���h���*�'��@6�rf��3���Ed�2r@��m���9}����6��G0o��Z[�#���{��W�x�7�>�%��54W�R�������{?��S��~����o�z�8�R�f\���#f�cp4b#�m�Mv暂18b��To�5�	�����986��yq8-a�/�T5Y�����J�-��������wEQ�����      t   �  x�M�Mn�0�����
r����@�i�U��X�B+��T�=��>YG
md'
�7�D!<��{ꨍ@^�k�`���x��Aa�Q{���b��*Qu�����u�'j)�O���qŘ�C�wW��ZH��X�]�,.'��ɩ[�5<S;t-�.�ܯ�ka�
�0�!��Z���;P�|���L-��dp�)��kk�z�3k�: l����P?���]�35qd�Ps���G6�����w�С*ܮo� N9�6�13���Sf��H)����r|]�#�s�p�>��S��,��\nUx� �(�zʩ�P�0�Z�6D=��u_�ts.m����DK,õר�/Q;��	\��?��Dc��8S�9�9&~���&���1�A���@ŏ�lx�c�}LS��"��������#7����O���? >�:      o   D   x�%���0C���0(I	��p��_$ ��dy0p\u�E��0�܍`��o����oK��jx�9D�<�%      u   �   x���MN�0����@�=��,i�"
t��[��ؕ*�jY�dĀ(l�y���pht�֌�8�8ϐ��@Oڦ��?YK^�Ρ!ku��(,�<]��)�o�Y�
�m��μ��ќt���p�\�V�_)|��g\�:/c`%�
l.��]��yZ�6��T%;����Vd���z��(��������t�V�qV[�v�q�c�SX�JQ��x��w����p4��u�eW� ��_%I��?s�      p   /   x�3�4�4�4�,�24�!CN �(d�ię�e�	1�b���� ��      q   �   x�mпn� �?/�}��������2u���K��p���V�.�n@����3  �ڣ�O��EY�����8c��e��B�}�`���9'~�5d�)y<s;ĩ1 ���7#\���.a����_��5�%���T��0�t�?���g�w�曚�y��sM�"�
�"�˷�9Lx�� B��h����1�uN��*�-�(_K5��Uj��*O�X����m=(�+}+�&L�La��U���i�_C�x�      v   &   x�3200�4�2Q� ʐ�Dq�(cN�=... }[�      r   �  x���An�0E��S�8�hIK#�.P$FV�Ld�e!�Imo�3�bҊ[4�Z��Q�]{%8�$g�'w�\^C���XOqjGЊ����
d�h)��/����'I���.x�Tk ��`�A�w����rfٙ�D��f�Zd���V�c��_=���-�K�mR��VZlݵ��pc	׋��>�OJｮ�8��8I)�djPC'L)|�q��"�x�2ZZܯ�~��}�'˫�teM�j�5�*I��I��k�@�CZ�`�G�3���s8�4�(��`d��"�÷ �%��Z�� ƺ�l=u<$�3��&��T��`(�t�1��+��G�X�B�=],��<�}G��󰻵R#���m� �_���rצ�]�*��
�M�����7�O��'�*      w   )   x��� ��L0�r��?�E<L/װ�$�t���Psm      x   �  x�e��N1��g��O��\ ]N�%
JPDR�"6ƞ���l�x�.�Y��q�*�k��}���욟F�����	h@�㡢%t���&�1Y�)��T�Y;��3�V�'�dن��L�=�Ȃ�)p���lC5�3�r����0�Y-���^9��ׁ���w0/"ӕ���Q�8U)9qCwp�7tk�a�}RqA+�o�왪6�4���pO�~��/C�fת��g��i��2jƠa��i*w����	��=�f�^M>/�
�z���(_h�uS�2g�������,�,Gtӛg�,o����E8�k��h����M?��U�;s�����\p����z!�L|���R���KH��m��sZJ���A^��mo|듮�0p�����94����YQ�^��      y   .   x�3�4200�\F`
Dq��(aarp�B��b���� 5�	|      z   )   x�3�4�4200�2�4�4�2�4q���98�b���� [M�      {   l   x�=���0�7�	����08r~,&nN��6��?iE?5bR☇��@n���մN�%���ϡ%���n.���!�:�.[��ۦ)SX�g̷A|? n_O!8      |   �   x�m����0D���Dց�Q��H���6��DD��"_�~��<DCq|f�d�I��3Y�_m�g���kl{��mԌ�&i{��� �V�tTNE��HȎ.�O�d�X���4Q4%uw�QV*�1�U�"��B�>����Y��Vi�+r�(��ʇB��\~�N��;Y���K��R���Hd����@*;�ʧ)R.ϖW�OSL���#��/\@��w���b~�      s   �  x�m�͎�0F��S�D6	�U��f�.�����g�Mm3�>}?�i�Ċs�߇��t�N�:��ь�|,��X
䊸�"�wE}����j}��Nj�']W0�7F���fo)�j��RU{�L&���!zG���L)p�Q7Z��~�]�0N,p��Vt���qL1��i��/�?ٍ66�q�g�'^(|p2�*��J�����O�y�^T 3�b���yΘ�U�'JdQ�#�s4*ts����w1�e@?�d���k5{Z���b ��j(f�5W���g�@��ld/��j ���8ӛ�3
���2D�;��� �<R���ӑF�ф�XE4%�$��o�ݣ��[r��V���(.o�L���ַ5hU��Yq�B82,��.����-n0�3$9���_B����:�Jx� ��9*���Y��8�m�TX*}2Vb��DF}z6گ���/ٴ�      }   �   x��A�0@���)<�ig:-]5�D�;�h�X�^_���Y��ª�=��kCV�3��4�iP9r1UP�]Dv왔n�	�+L)G$�I�S���6���y[.���o,	a��4��V����9t)�+L��q�1��0��������ۆ�5�e��?B+/�         (   x�332�4461��4200�23�043720q�b���� tN      �   F   x����@�7.&�3�%�ב˾FZu���P������9�T':=���d�w���h�|yKZ�} |���      �   [   x����@�jk�@���%��_T����P)D����(���)��i˘����6����w�m���Hbh��R�W7U�1+=����w#J�����      ~   �   x�M�1N@��cP��qR���(���w�GEg[K��8:�eL��1d��F�T�h���ߦR�H4W<.�����r{���A-���4+��ޒ]�~7�(l�y��5��q���)zM�S�i�>���x��~���P�+8     