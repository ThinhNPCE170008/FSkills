/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author huakh
 */
public class ReportCategory {
    private int reportCategoryId;
    private String reportCategoryName;

    public ReportCategory() {
    }

    public ReportCategory(int reportCategoryId, String reportCategoryName) {
        this.reportCategoryId = reportCategoryId;
        this.reportCategoryName = reportCategoryName;
    }

    public int getReportCategoryId() {
        return reportCategoryId;
    }

    public void setReportCategoryId(int reportCategoryId) {
        this.reportCategoryId = reportCategoryId;
    }

    public String getReportCategoryName() {
        return reportCategoryName;
    }

    public void setReportCategoryName(String reportCategoryName) {
        this.reportCategoryName = reportCategoryName;
    }

    @Override
    public String toString() {
        return "ReportCategory{" + "reportCategoryId=" + reportCategoryId + ", reportCategoryName=" + reportCategoryName + '}';
    }
    
    
}
