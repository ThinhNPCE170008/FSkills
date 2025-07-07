/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Comment;
import model.Material;
import model.Report;
import model.ReportCategory;
import model.User;
import util.DBContext;

/**
 *
 * @author huakh
 */
public class ReportCategoryDAO extends DBContext{
    
    public ReportCategoryDAO(){
        super();
    }
    
    public List<ReportCategory> getAll() {
    List<ReportCategory> list = new ArrayList<>();
        String sql = "select * from ReportCategory";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int categoryId = rs.getInt("ReportCategoryID");
                String reportCategoryName = rs.getString("ReportName");
                list.add(new ReportCategory(categoryId, reportCategoryName));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

}
