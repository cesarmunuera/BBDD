
package java_bbdd;

import java.sql.Connection; //
import java.sql.DriverManager; //
import java.sql.SQLException; //
import java.util.logging.Level; //
import java.util.logging.Logger; //
import java.sql.Statement;
import java.sql.ResultSet;

public class Front extends javax.swing.JFrame {

    
    public Front() {
        initComponents();
    }


    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTextField1 = new javax.swing.JTextField();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTextField1.setEditable(false);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(177, 177, 177)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 191, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(411, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(116, 116, 116)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(280, Short.MAX_VALUE))
        );

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

 
    Connection conn = null;
    private final String url = "jdbc:postgresql://localhost/PECL3";
    private final String user = "postgres";
    private final String password = "BBDD";


public Connection connect(){
    try {
        Class.forName("org.postgresql.Driver").newInstance();
        conn = DriverManager.getConnection(url, user, password);
        System.out.println("Conectado!!");
    } catch (SQLException e) {
        System.out.println(e.getMessage());
    } catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex){
        System.out.println("Driver no conectado");
    }
return conn;
}

    
public void disconnect(){
    try {
        conn.close();
    } catch (SQLException ex) {
        System.out.println(ex.getMessage());
    } catch (Exception ex){
        System.out.println(ex.getMessage());
    }
}

    
    
    
    
    public static void main(String args[]) throws InstantiationException, IllegalAccessException {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Front.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Front.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Front.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Front.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Front().setVisible(true);
            }
        });
 
        Front conector = new Front();
        conector.connect();
    
        conector.q1();
    
        conector.disconnect();  
    }
    
    public void q1(){
    try {
        System.out.println("Primera consulta -----------------------");
        
        String query = "SELECT \"Código_cliente\", \"Nombre\"\n" +
"	FROM \"Cliente\"\n" +
"		WHERE \"Cliente\".\"Código_cliente\" NOT IN (SELECT \"Casting_presencial\".\"Código_cliente_Cliente\" FROM \"Casting_presencial\")\n" +
"INTERSECT SELECT \"Código_cliente\", \"Nombre\"\n" +
"	FROM \"Cliente\"\n" +
"		WHERE \"Cliente\".\"Código_cliente\" NOT IN (SELECT \"Casting_online\".\"Código_cliente_Cliente\" FROM \"Casting_online\")";
        
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(query);


        while(rs.next()){
            System.out.println(""+rs.getString("nombre"));
        }
        //jTextField1.setText("gegetheth");

    } catch (SQLException ex) { 
        System.out.println(ex.getMessage()); 
    }
}
 
    
    
    
    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextField jTextField1;
    // End of variables declaration//GEN-END:variables
}

