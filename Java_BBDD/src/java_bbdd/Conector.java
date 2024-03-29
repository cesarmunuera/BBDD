package java_bbdd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.Scanner;

public class Conector {

    Connection conn = null;
    private final String url = "jdbc:postgresql://localhost/PECL3";
    private String user, entradaTeclado;
    boolean correcto = false;
    Scanner entradaEscaner = new Scanner(System.in);
    private final String password = "BBDD";

    public Connection connect() {
        System.out.println("Antes de establecer la conexion, debe elegir el usuario:");
        System.out.println("Administrador = 1, Gestor = 2, Recepcionista = 3");

        while (!correcto) {

            entradaTeclado = entradaEscaner.nextLine();
            //entradaTeclado = "1"; //Esto es para asignar por fuerza el valor de Administrador.

            if (entradaTeclado.equals("1")) {
                user = "Administrador";
                correcto = true;
            } else if (entradaTeclado.equals("2")) {
                user = "Gestor";
                correcto = true;
            } else if (entradaTeclado.equals("3")) {
                user = "Recepcionista";
                correcto = true;
            } else {
                System.out.println("Introduzca un numero valido");
            }
        }

        try {
            Class.forName("org.postgresql.Driver").newInstance();
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Conectado!!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex) {
            System.out.println("Driver no conectado");
        }
        return conn;
    }

    public void disconnect() {
        try {
            conn.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q1() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Primera consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("Mostrar el nombre de los clientes que no han contratado ningún casting." + "\n");
            System.out.println("Código_cliente" + "\t" + "Nombre");

            String query = "SELECT \"Código_cliente\", \"Nombre\"\n"
                    + "	FROM \"Cliente\"\n"
                    + "		WHERE \"Cliente\".\"Código_cliente\" NOT IN (SELECT \"Casting_presencial\".\"Código_cliente_Cliente\" FROM \"Casting_presencial\")\n"
                    + "INTERSECT SELECT \"Código_cliente\", \"Nombre\"\n"
                    + "	FROM \"Cliente\"\n"
                    + "		WHERE \"Cliente\".\"Código_cliente\" NOT IN (SELECT \"Casting_online\".\"Código_cliente_Cliente\" FROM \"Casting_online\")";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q2() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Segunda consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NOMBRE DE LOS CANDIDATOS QUE HAYAN SUPERADO TODAS LAS PRUEBAS" + "\n");
            System.out.println("Nombre");

            String query = "SELECT \"Candidato_adulto\".\"Nombre\"\n"
                    + "	FROM \"Candidato_adulto\"\n"
                    + "		WHERE \"Candidato_adulto\".\"Código candidato\" IN (SELECT \"Código candidato_Candidato_adulto\" FROM \"Candidato_adulto_realiza_Prueba_individual\" WHERE \"Valido\" = True)\n"
                    + "UNION SELECT \"Candidato_ninio\".\"Nombre\"\n"
                    + "	FROM \"Candidato_ninio\"\n"
                    + "		WHERE \"Candidato_ninio\".\"Código candidato\" IN (SELECT \"Código candidato_Candidato_ninio\" FROM \"Candidato_ninio_realiza_Prueba_individual\" WHERE \"Valido\" = True)";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q3() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Tercera consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NÚMERO DE CANDIDATOS QUE HAY ASOCIADOS A CADA PERFIL" + "\n");
            System.out.println("Numero_Candidatos" + "\t" + "Codigo_perfil_Perfil");

            String query = "SELECT COUNT(\"Codigo_perfil_Perfil\") AS \"Numero_Candidatos\", \"Codigo_perfil_Perfil\"\n"
                    + "	FROM \"Candidato_adulto\"\n"
                    + "	GROUP BY \"Codigo_perfil_Perfil\"\n"
                    + "UNION\n"
                    + "SELECT COUNT(\"Codigo_perfil_Perfil\") AS \"Numero_Candidatos\", \"Codigo_perfil_Perfil\"\n"
                    + "	FROM \"Candidato_ninio\"\n"
                    + "	GROUP BY \"Codigo_perfil_Perfil\"\n"
                    + "ORDER BY \"Codigo_perfil_Perfil\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q5() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Quinta consulta ----------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NÚMERO DE CANDIDATOS QUE SE HAN PRESENTADO A CADA CASTING (QUE AL MENOS HAYAN REALIZADO UNA PRUEBA)." + "\n");
            System.out.println("Numero_Candidatos" + "\t" + "Codigo_candidato");

            String query = "SELECT COUNT(\"Código_prueba_Prueba_individual\") AS \"Numero_Candidatos\", \"Código candidato_Candidato_adulto\" AS \"Codigo_candidato\"\n"
                    + "	FROM \"Candidato_adulto_realiza_Prueba_individual\"\n"
                    + "	GROUP BY \"Código candidato_Candidato_adulto\"\n"
                    + "UNION\n"
                    + "SELECT COUNT(\"Código_prueba_Prueba_individual\") AS \"Numero_Candidatos\", \"Código candidato_Candidato_ninio\" AS \"Codigo_candidato\"\n"
                    + "	FROM \"Candidato_ninio_realiza_Prueba_individual\"\n"
                    + "	GROUP BY \"Código candidato_Candidato_ninio\"\n"
                    + "ORDER BY \"Codigo_candidato\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q6() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Sexta consulta -----------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NOMBRE Y LA DIRECCÓN DE LAS CANDIDADATAS QUE TENGAN PELO RUBIO Y SEAN DE MADRID." + "\n");
            System.out.println("Nombre" + "\t" + "Ciudad" + "\t" + "Calle" + "\t" + "\t" + "\t" + "Portal" + "\t" + "Piso");

            String query = "SELECT \"Nombre\", \"Ciudad\", \"Calle\", \"Portal\", \"Piso\"\n"
                    + "	FROM \"Candidato_adulto\" INNER JOIN \"Perfil\" ON \"Candidato_adulto\".\"Codigo_perfil_Perfil\" = \"Perfil\".\"Codigo_perfil\"\n"
                    + "		WHERE (\"Ciudad\" = 'Madrid') and (\"Color_de_pelo\" = 'Rubio') and (\"Sexo\" = False)\n"
                    + "UNION SELECT \"Nombre\", \"Ciudad\", \"Calle\", \"Portal\", \"Piso\"\n"
                    + "	FROM \"Candidato_ninio\" INNER JOIN \"Perfil\" ON \"Candidato_ninio\".\"Codigo_perfil_Perfil\" = \"Perfil\".\"Codigo_perfil\"\n"
                    + "		WHERE (\"Ciudad\" = 'Madrid') and (\"Color_de_pelo\" = 'Rubio') and (\"Sexo\" = False)";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" + rs.getString(4) + "\t" + rs.getString(5) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q7() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Septima consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL CÓDIGO DE PERFIL DE LOS PERFILES REQUERIDOS EN LOS CASTING QUE INCLUYEN LA SUBCADENA 'ANUNCIO TV' EN SU DESCRIPCIÓN." + "\n");
            System.out.println("Codigo_perfil_Perfil" + "\t" + "Descripcion");

            String query = "SELECT \"Codigo_perfil_Perfil\", \"Descripción\"\n"
                    + "	FROM \"Casting_presencial_necesita_Perfil\" INNER JOIN \"Casting_presencial\" \n"
                    + "	ON \"Casting_presencial_necesita_Perfil\".\"Código_casting_Casting_presencial\" = \"Casting_presencial\".\"Código_casting\"\n"
                    + "		WHERE \"Casting_presencial\".\"Descripción\" LIKE '%Anuncio TV%'\n"
                    + "UNION SELECT \"Codigo_perfil_Perfil\", \"Descripción\"\n"
                    + "	FROM \"Casting_online_necesita_Perfil\" INNER JOIN \"Casting_online\" \n"
                    + "	ON \"Casting_online_necesita_Perfil\".\"Código_casting_Casting_online\" = \"Casting_online\".\"Código_casting\"\n"
                    + "		WHERE \"Casting_online\".\"Descripción\" LIKE '%Anuncio TV%'";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q8() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Octava consulta ----------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL CÓDIGO DE LOS CANDIDATOS QUE TIENEN REPRESENTANTE Y TIENEN PELO 'Castanio'" + "\n");
            System.out.println("Codigo candidato");

            String query = "SELECT \"Código candidato\"\n"
                    + "	FROM \"Candidato_adulto\" INNER JOIN \"Perfil\" \n"
                    + "	ON \"Candidato_adulto\".\"Codigo_perfil_Perfil\" = \"Perfil\".\"Codigo_perfil\"\n"
                    + "		WHERE (\"NIF_Representante\" IS NULL) AND (\"Color_de_pelo\" = 'Castanio')\n"
                    + "UNION SELECT \"Código candidato\"\n"
                    + "	FROM \"Candidato_ninio\" INNER JOIN \"Perfil\" \n"
                    + "	ON \"Candidato_ninio\".\"Codigo_perfil_Perfil\" = \"Perfil\".\"Codigo_perfil\"\n"
                    + "		WHERE (\"NIF_Representante\" IS NULL) AND (\"Color_de_pelo\" = 'Castanio')";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q9() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "----------------------------- Novena consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL PRECIO TOTAL QUE HA DE PAGAR CADA CANDIDATO. " + "\n");
            System.out.println("Codigo_candidatos" + "\t" + "Coste_total");

            String query1 = "CREATE VIEW \"Pagos_candidatos\" AS\n"
                    + "SELECT \"Código candidato_Candidato_adulto\", T1.\"Coste\"\n"
                    + "	FROM (\"Candidato_adulto_realiza_Prueba_individual\" INNER JOIN \"Prueba_individual\" \n"
                    + "	ON \"Candidato_adulto_realiza_Prueba_individual\".\"Código_prueba_Prueba_individual\" = \"Prueba_individual\".\"Código_prueba\") as T1\n"
                    + "UNION SELECT \"Código candidato_Candidato_ninio\", T1.\"Coste\" as Coste_total\n"
                    + "	FROM (\"Candidato_ninio_realiza_Prueba_individual\" INNER JOIN \"Prueba_individual\" \n"
                    + "	ON \"Candidato_ninio_realiza_Prueba_individual\".\"Código_prueba_Prueba_individual\" = \"Prueba_individual\".\"Código_prueba\") as T1\n"
                    + "			ORDER BY \"Código candidato_Candidato_adulto\"	";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);//Este metodo ejecuta la query y refresca la BBDD (sino, con vistas no funciona)

            String query2 = "SELECT T1.\"Código candidato_Candidato_adulto\" AS \"Codigo_candidatos\", T1.\"Coste_total\"\n"
                    + "FROM (SELECT \"Código candidato_Candidato_adulto\", SUM(\"Coste\") AS \"Coste_total\" \n"
                    + "	  FROM \"Pagos_candidatos\" WHERE \"Código candidato_Candidato_adulto\" = \"Código candidato_Candidato_adulto\" \n"
                    + "	  GROUP BY \"Código candidato_Candidato_adulto\") AS T1";
            ResultSet rs = st.executeQuery(query2);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }

            String query3 = "DROP VIEW \"Pagos_candidatos\" CASCADE";
            st.executeUpdate(query3);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q10() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "----------------------------- Decima consulta ---------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NÚMERO DE CANDIDATOS ADULTOS Y EL NÚMERO DE CANDIDATOS NINIOS QUE HAY EN LA BASE DE DATOS." + "\n");
            System.out.println("numero_candidatos_adultos" + "\t" + "numero_candidatos_ninios");

            String query = "SELECT COUNT (\"Candidato_adulto\".\"Código candidato\") \n"
                    + "AS Numero_candidatos_adultos, (SELECT COUNT (\"Candidato_ninio\".\"Código candidato\") as Numero_candidatos_ninios \n"
                    + "							   		FROM \"Candidato_ninio\")\n"
                    + "	FROM \"Candidato_adulto\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q11() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "------------------------- Decimoprimera consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL DNI DE LA GENTE QUE HA DIRIGIDO EL CASTING EN EL QUE ALGUNA PRUEBA INDIVIDUAL SE HA LLEVADO A CABO EN LA SALA 'flor'" + "\n");
            System.out.println("DNI");

            String query = "SELECT \"DNI\"\n"
                    + "	FROM (\"Agente de casting\" INNER JOIN \"Prueba_individual\" \n"
                    + "	ON \"Agente de casting\".\"Código_casting_Casting_presencial\" = \"Prueba_individual\".\"Código_casting_Casting_presencial_Fase\")\n"
                    + "		WHERE \"Prueba_individual\".\"Sala\" = 'flor'";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q12() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "------------------------- Decimosegunda consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR LA PLATAFORMA WEB QUE SE HA USADO EN EL CASTING ONLINE MÁS CARO, ASÍ COMO EL NOMBRE DEL CLIENTE QUE HA CONTRATADO DICHO CASTING" + "\n");
            System.out.println("Plataforma_web" + "\t" + "\t" + "\t" + "\t" + "Nombre");

            String query = "SELECT \"Plataforma_web\", \"Cliente\".\"Nombre\"\n"
                    + "	FROM (\"Casting_online\" INNER JOIN \"Cliente\" \n"
                    + "	ON \"Casting_online\".\"Código_cliente_Cliente\" = \"Cliente\".\"Código_cliente\")\n"
                    + "	WHERE \"Casting_online\".\"Coste\" = (SELECT MAX(\"Coste\") FROM \"Casting_online\")";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q13() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "-------------------------- Decimotercera consulta -----------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("Mostrar el porcentaje de clientes que hay de cada tipo" + "\n");
            System.out.println("Porcentaje_empresas_moda" + "\t" + "Porcentaje_empresas_publicidad");

            String query1 = "CREATE VIEW \"Total_clientes\"\n"
                    + " 	AS SELECT (SELECT COUNT (\"Tipo_actividad\") FROM \"Cliente\") as \"Clientes_totales\",\n"
                    + "	(SELECT COUNT (\"Tipo_actividad\") FROM \"Cliente\" WHERE \"Cliente\".\"Tipo_actividad\" = True) as \"Clientes_Empresa_de_moda\", \n"
                    + "		(SELECT COUNT (\"Tipo_actividad\") FROM \"Cliente\" WHERE \"Cliente\".\"Tipo_actividad\" = False) as \"Clientes_Empresa_de_publicidad_y_cine\"";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);

            String query2 = "SELECT (((SELECT CAST(\"Clientes_Empresa_de_moda\" AS FLOAT) FROM \"Total_clientes\") / (SELECT \"Clientes_totales\" FROM \"Total_clientes\"))*100)\n"
                    + "AS \"Porcentaje_empresas_moda\", (((SELECT CAST(\"Clientes_Empresa_de_publicidad_y_cine\" AS FLOAT) \n"
                    + "								  FROM \"Total_clientes\") / (SELECT \"Clientes_totales\" FROM \"Total_clientes\"))*100) AS \"Porcentaje_empresas_publicidad\"";
            ResultSet rs = st.executeQuery(query2);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + rs.getString(2) + "\n");
            }

            String query3 = "DROP VIEW \"Total_clientes\"";
            st.executeUpdate(query3);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q14() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "-------------------------- Decimocuarta consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NOMBRE DE LOS CANDIDATOS QUE HAN SUPERADO ALGUNA PRUEBA DE ALGÚN CASTING, ASÍ COMO EL NOMBRE DEL CASTING" + "\n");
            System.out.println("mombre_candidatos" + "\t" + "nombre_casting");

            String query1 = "CREATE VIEW \"Candidato_adulto_realiza3\"(Nombre_candidato_adulto, \"Código_casting\", \"Es_valido\")\n"
                    + " 	AS SELECT \"Nombre\", \"Código_casting_Casting_presencial_Fase_Prueba_individual\", \"Valido\"\n"
                    + "	FROM (\"Candidato_adulto\" INNER JOIN \"Candidato_adulto_realiza_Prueba_individual\"\n"
                    + "	  ON \"Candidato_adulto\".\"Código candidato\" = \"Candidato_adulto_realiza_Prueba_individual\".\"Código candidato_Candidato_adulto\")";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);

            String query2 = "CREATE VIEW \"Candidato_ninio_realiza\"(Nombre_candidato_ninio, \"Código_casting\", \"Es_valido\")\n"
                    + " 	AS SELECT \"Nombre\", \"Código_casting_Casting_presencial_Fase_Prueba_individual\", \"Valido\"\n"
                    + "	FROM (\"Candidato_ninio\" INNER JOIN \"Candidato_ninio_realiza_Prueba_individual\"\n"
                    + "	  ON \"Candidato_ninio\".\"Código candidato\" = \"Candidato_ninio_realiza_Prueba_individual\".\"Código candidato_Candidato_ninio\")";
            st.executeUpdate(query2);

            String query3 = "SELECT nombre_candidato_adulto AS Nombre_candidatos, \"Nombre\" AS Nombre_casting\n"
                    + "	FROM (\"Candidato_adulto_realiza3\" NATURAL INNER JOIN \"Casting_presencial\")\n"
                    + "	WHERE \"Es_valido\" = True\n"
                    + "UNION\n"
                    + "SELECT nombre_candidato_ninio, \"Nombre\"\n"
                    + "	FROM (\"Candidato_ninio_realiza\" NATURAL INNER JOIN \"Casting_presencial\")\n"
                    + "	WHERE \"Es_valido\" = True";
            ResultSet rs = st.executeQuery(query3);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + rs.getString(2) + "\n");
            }

            String query4 = "DROP VIEW \"Candidato_adulto_realiza3\"";
            st.executeUpdate(query4);

            String query5 = "DROP VIEW \"Candidato_ninio_realiza\"";
            st.executeUpdate(query5);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q15() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "-------------------------- Decimoquinta consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL DINERO TOTAL RECAUDADO POR LA EMPRESA" + "\n");
            System.out.println("Dinero_total");

            String query1 = "CREATE VIEW \"Pagos_candidatos\" AS\n"
                    + "SELECT \"Código candidato_Candidato_adulto\", T1.\"Coste\"\n"
                    + "	FROM (\"Candidato_adulto_realiza_Prueba_individual\" INNER JOIN \"Prueba_individual\" \n"
                    + "	ON \"Candidato_adulto_realiza_Prueba_individual\".\"Código_prueba_Prueba_individual\" = \"Prueba_individual\".\"Código_prueba\") as T1\n"
                    + "UNION SELECT \"Código candidato_Candidato_ninio\", T1.\"Coste\" as Coste_total\n"
                    + "	FROM (\"Candidato_ninio_realiza_Prueba_individual\" INNER JOIN \"Prueba_individual\" \n"
                    + "	ON \"Candidato_ninio_realiza_Prueba_individual\".\"Código_prueba_Prueba_individual\" = \"Prueba_individual\".\"Código_prueba\") as T1\n"
                    + "			ORDER BY \"Código candidato_Candidato_adulto\"";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);

            String query2 = "CREATE VIEW \"Pagos_clientes\" AS\n"
                    + "SELECT \"Código_cliente_Cliente\", \"Coste\"\n"
                    + "	FROM \"Casting_online\"\n"
                    + "UNION SELECT \"Código_cliente_Cliente\", \"Coste\"\n"
                    + "	FROM \"Casting_presencial\"";
            st.executeUpdate(query2);

            String query3 = "CREATE VIEW \"COSTE_TOTAL_CLIENTES_CANDIDATOS\" AS\n"
                    + "SELECT SUM(\"Coste\") FROM \"Pagos_clientes\" UNION SELECT SUM(\"Coste\") FROM \"Pagos_candidatos\"";
            st.executeUpdate(query3);

            String query4 = "SELECT SUM(\"sum\") FROM \"COSTE_TOTAL_CLIENTES_CANDIDATOS\"";
            ResultSet rs = st.executeQuery(query4);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\n");
            }

            String query5 = "DROP VIEW \"COSTE_TOTAL_CLIENTES_CANDIDATOS\"";
            st.executeUpdate(query5);

            String query6 = "DROP VIEW \"Pagos_candidatos\"";
            st.executeUpdate(query6);

            String query7 = "DROP VIEW \"Pagos_clientes\"";
            st.executeUpdate(query7);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q16() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "-------------------------- Decimosexta consulta -------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NOMBRE Y EL TELEFONO DE LOS REPRESENTANTES QUE REPRESENTEN A DOS CANDIDATOS COMO MINIMO " + "\n");
            System.out.println("Nombre_representante" + "\t" + "Telefono" + "\t" + "count");

            String query1 = "CREATE VIEW \"Representante_con_telefono1\" (\"NIF\", \"Nombre_representante\", \"Telefono\")AS \n"
                    + "SELECT \"NIF\", \"Nombre\", \"Telefono\"\n"
                    + "FROM \"Representante\" INNER JOIN \"Telefono_representante\" ON \"Representante\".\"NIF\" = \"Telefono_representante\".\"NIF_Representente\"";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);

            String query2 = "SELECT DISTINCT \"Nombre_representante\", \"Telefono\", COUNT(\"Código candidato\")\n"
                    + "	FROM \"Representante_con_telefono1\" INNER JOIN \"Candidato_adulto\" ON\n"
                    + "	\"Candidato_adulto\".\"NIF_Representante\" = \"Representante_con_telefono1\".\"NIF\"\n"
                    + "		GROUP BY \"Representante_con_telefono1\".\"Nombre_representante\", \"Representante_con_telefono1\".\"Telefono\"\n"
                    + "		HAVING COUNT(\"Código candidato\") >= 2\n"
                    + "UNION\n"
                    + "SELECT DISTINCT \"Nombre_representante\", \"Telefono\", COUNT(\"Código candidato\")\n"
                    + "	FROM \"Representante_con_telefono1\" INNER JOIN \"Candidato_ninio\" ON\n"
                    + "	\"Candidato_ninio\".\"NIF_Representante\" = \"Representante_con_telefono1\".\"NIF\"\n"
                    + "		GROUP BY \"Representante_con_telefono1\".\"Nombre_representante\", \"Representante_con_telefono1\".\"Telefono\"\n"
                    + "		HAVING COUNT(\"Código candidato\") >= 2\n"
                    + "ORDER BY \"Nombre_representante\"";
            ResultSet rs2 = st.executeQuery(query2);

            while (rs2.next()) {
                System.out.println(rs2.getString(1) + "\t" + "\t" + "\t" + rs2.getString(2) + "\t" + rs2.getString(3) + "\n");
            }

            String query3 = "DROP VIEW \"Representante_con_telefono1\" CASCADE";
            st.executeUpdate(query3);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q17() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "------------------------- Decimoseptima consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL DNI DE LOS ADULTOS QUE NO TENGAN REPRESENTANTE." + "\n");
            System.out.println("DNI");

            String query = "SELECT \"DNI\"\n"
                    + "FROM \"Candidato_adulto\"\n"
                    + "WHERE \"Candidato_adulto\".\"NIF_Representante\" IS NULL";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

//    public void q18() {
//        try {
//            System.out.println("-------------------------------------------------------------------------"
//                    + "\n" + "-------------------------- Decimoctava consulta ------------------------"
//                    + "\n" + "-------------------------------------------------------------------------");
//            System.out.println("MOSTRAR LOS DATOS DEL PERFIL MÁS DEMANDADO ASÍ COMO EL NOMBRE DEL CLIENTE QUE LO HA REQUERIDO PARA SU CASTING (INCOMPLETO).");
//
//            String query1 = "CREATE VIEW \"Perfil_mas_demandado_casting_online\" (\"Nombre_cliente\", \"Código_casting\", \"Codigo_perfil_Perfil\") AS\n"
//                    + "SELECT \"Nombre\", \"Código_casting\", \"Codigo_perfil_Perfil\"\n"
//                    + "FROM \"Cliente\" INNER JOIN \"Casting_online\" ON \"Cliente\".\"Código_cliente\" = \"Casting_online\".\"Código_cliente_Cliente\" AS T1\n"
//                    + "INNER JOIN \"Casting_online_necesita_Perfil\" ON T1.\"Código_casting\" = \"Casting_online_necesita_Perfil\".\"Código_casting_Casting_online\"\n"
//                    + "\n"
//                    + "CREATE VIEW \"Cliente_casting_online_necesita_perfil\" AS \n"
//                    + "SELECT COUNT(\"Código_de_fase\") \"Numero_de_fases\", \"Código_casting_Casting_presencial\" \n"
//                    + "FROM \"Fase\"\n"
//                    + "GROUP BY \"Código_casting_Casting_presencial\"";
//            Statement st = conn.createStatement();
//            st.executeUpdate(query1);
//
//            String query2 = "CREATE VIEW \"Cliente_casting_online_necesita_perfil\" AS \n"
//                    + "SELECT COUNT(\"Código_de_fase\") \"Numero_de_fases\", \"Código_casting_Casting_presencial\" \n"
//                    + "FROM \"Fase\"\n"
//                    + "GROUP BY \"Código_casting_Casting_presencial\" ";
//            st.executeUpdate(query2);
//
//            String query3 = "SELECT \"Código_casting_Casting_presencial\", \"Numero_de_fases\" \n"
//                    + "FROM \"Num_fases_por_casting_presencial3\"\n"
//                    + "WHERE \"Numero_de_fases\" = (SELECT MAX(\"Numero_de_fases\")FROM \"Num_fases_por_casting_presencial3\") ";
//            ResultSet rs = st.executeQuery(query3);
//
//            while (rs.next()) {
//                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\n");
//            }
//        } catch (SQLException ex) {
//            System.out.println(ex.getMessage());
//        }
//    }
    public void q19() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "-------------------------- Decimonovena consulta ------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR EL NÚMERO DE PRUEBAS SUPERADAS POR CADA NIÑO." + "\n");
            System.out.println("Numero_pruebas (count)" + "\t" + "\t" + "Codigo candidato_Candidato_ninio");

            String query = "SELECT COUNT(\"Valido\"), \"Código candidato_Candidato_ninio\" \n"
                    + "FROM \"Candidato_ninio_realiza_Prueba_individual\"\n"
                    + "WHERE \"Candidato_ninio_realiza_Prueba_individual\".\"Valido\" = True\n"
                    + "GROUP BY \"Código candidato_Candidato_ninio\" ";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void q20() {
        try {
            System.out.println("-------------------------------------------------------------------------"
                    + "\n" + "---------------------------- Vigesima consulta --------------------------"
                    + "\n" + "-------------------------------------------------------------------------");
            System.out.println("MOSTRAR LOS DATOS DEL PERFIL MÁS DEMANDADO ASÍ COMO EL NOMBRE DEL CLIENTE QUE LO HA REQUERIDO PARA SU CASTING (INCOMPLETO)." + "\n");
            System.out.println("Código_casting_Casting_presencial" + "\t" + "Numero_de_fases");

            String query1 = "CREATE VIEW \"Num_fases_por_casting_presencial3\" AS \n"
                    + "SELECT COUNT(\"Código_de_fase\") \"Numero_de_fases\", \"Código_casting_Casting_presencial\" \n"
                    + "FROM \"Fase\"\n"
                    + "GROUP BY \"Código_casting_Casting_presencial\" ";
            Statement st = conn.createStatement();
            st.executeUpdate(query1);

            String query2 = "SELECT \"Código_casting_Casting_presencial\", \"Numero_de_fases\" \n"
                    + "FROM \"Num_fases_por_casting_presencial3\"\n"
                    + "WHERE \"Numero_de_fases\" = (SELECT MAX(\"Numero_de_fases\")FROM \"Num_fases_por_casting_presencial3\") ";
            ResultSet rs = st.executeQuery(query2);

            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + "\t" + "\t" + "\t" + "\t" + rs.getString(2) + "\n");
            }

            String query3 = "DROP VIEW \"Num_fases_por_casting_presencial3\" ";
            st.executeUpdate(query3);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public static void main(String args[]) throws InstantiationException, IllegalAccessException {
        String entradaTeclado2;
        Scanner entradaEscaner = new Scanner(System.in);
        boolean condition = false;
        while (!condition) {
            Conector conector = new Conector();
            conector.connect();

            conector.q1();
            conector.q2();
            conector.q3();
            conector.q5();
            conector.q6();
            conector.q7();
            conector.q8();
            conector.q9();
            conector.q10();
            conector.q11();
            conector.q12();
            conector.q13();
            conector.q14();
            conector.q15();
            conector.q16();
            conector.q17();
//            conector.q18();
            conector.q19();
            conector.q20();

            System.out.println("Si desea salir, introduzca 0");
            entradaTeclado2 = entradaEscaner.nextLine();
            if (entradaTeclado2.equals("0")) {
                condition = true;
            }

            conector.disconnect();
        }
    }

}
