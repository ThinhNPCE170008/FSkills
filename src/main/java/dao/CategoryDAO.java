package dao;

import model.Category;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class CategoryDAO extends DBContext {
    public CategoryDAO() {
        super();
    }

    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();

        String sql = "SELECT * FROM Category";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("category_id"));
                cat.setName(rs.getString("category_name"));
                cat.setDescription(rs.getNString("description"));
                cat.setCreated_at(rs.getTimestamp("created_at"));
                cat.setUpdated_at(rs.getTimestamp("updated_at"));

                list.add(cat);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }
}
