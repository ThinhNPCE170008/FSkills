
package util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    public Connection conn = null;

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=FLearn;"
                    + "user=sa;"
                    + "password=123456;"
                    + "encrypt=true;trustServerCertificate=true;";
            conn = DriverManager.getConnection(dbURL);

            // Kiem tra viec ket noi co thanh cong hay khong
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
}

//    // Thêm method này để lấy connection
//    public Connection getConnection() {
//        return conn;
//    }
//
//    // Thêm method này để đóng connection
//    public void close() {
//        if (conn != null) {
//            try {
//                conn.close();
//            } catch (SQLException e) {
//                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, e);
//            }
//        }
//    }
//}