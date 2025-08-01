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
//    public DBContext() {
//        try {
//            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//            String dbURL = "jdbc:sqlserver://localhost:1433;"
//                    + "databaseName=FLearn;"
//                    + "user=sa;"
//                    + "password=123456;"
//                    + "encrypt=false;trustServerCertificate=true;loginTimeout=30;";
//            conn = DriverManager.getConnection(dbURL);
//
//            if (conn != null) {
//                DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//                System.out.println("Driver name: " + dm.getDriverName());
//                System.out.println("Driver version: " + dm.getDriverVersion());
//                System.out.println("Product name: "
//                        + dm.getDatabaseProductName());
//                System.out.println("Product version: "
//                        + dm.getDatabaseProductVersion());
//            }
//        } catch (SQLException ex) {
//        } catch (ClassNotFoundException ex) {
//            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }
    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String dbURL = "jdbc:sqlserver://148.230.96.68:1433;"
                    + "databaseName=FLearn;"
                    + "user=sa;"
                    + "password=FPT-SPRING2025-Group3;"
                    + "encrypt=false;"
                    + "trustServerCertificate=true;"
                    + "loginTimeout=30;";

            conn = DriverManager.getConnection(dbURL);

            if (conn != null) {
                DatabaseMetaData dm = conn.getMetaData();
                System.out.println("Connected to DB");
                System.out.println("Driver name: " + dm.getDriverName());
                System.out.println("Driver version: " + dm.getDriverVersion());
                System.out.println("Product name: " + dm.getDatabaseProductName());
                System.out.println("Product version: " + dm.getDatabaseProductVersion());
            } else {
                System.err.println("conn == null");
            }

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Not Found JDBC Driver", ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error Connect DB", ex);
        }
    }

    public void close() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error: Close DB", ex);
        }
    }
}
