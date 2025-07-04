package util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class DBContext {

    public Connection conn = null;

    // Connect Local
    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=FLearn;"
                    + "user=sa;"
                    + "password=123456;"
                    + "encrypt=false;trustServerCertificate=true;loginTimeout=30;";

            conn = DriverManager.getConnection(dbURL);
            if (conn != null) {
                DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
                System.out.println("Driver name: " + dm.getDriverName());
                System.out.println("Driver version: " + dm.getDriverVersion());
                System.out.println("Product name: "
                        + dm.getDatabaseProductName());
                System.out.println("Product version: "
                        + dm.getDatabaseProductVersion());
            }
        } catch (SQLException ex) {
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Conect JDBC
//    public DBContext() {
//        try {
//            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//
//            // Lấy thông tin từ biến môi trường (set trên Render)
//            String host = System.getenv("DB_HOST");
//            String port = System.getenv("DB_PORT");
//            String dbName = System.getenv("DB_NAME");
//            String user = System.getenv("DB_USER");
//            String pass = System.getenv("DB_PASS");
//
//            String dbURL = "jdbc:sqlserver://" + host + ":" + port + ";"
//                    + "databaseName=" + dbName + ";"
//                    + "encrypt=true;"
//                    + "trustServerCertificate=false;"
//                    + "loginTimeout=30;";
//
//            System.out.println("✅ DEBUG JDBC START");
//            System.out.println("🔸 DB_HOST = " + host);
//            System.out.println("🔸 DB_USER = " + user);
//            System.out.println("🔸 DB_NAME = " + dbName);
//            System.out.println("🔸 JDBC URL = " + dbURL);
//            System.out.println("✅ DEBUG JDBC END");
//
//            conn = DriverManager.getConnection(dbURL, user, pass);
//
//            if (conn != null) {
//                DatabaseMetaData dm = conn.getMetaData();
//                System.out.println("Driver name: " + dm.getDriverName());
//                System.out.println("Driver version: " + dm.getDriverVersion());
//                System.out.println("Product name: " + dm.getDatabaseProductName());
//                System.out.println("Product version: " + dm.getDatabaseProductVersion());
//            }
//        } catch (SQLException ex) {
//            ex.printStackTrace();
//        } catch (ClassNotFoundException ex) {
//            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }
}
