/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author huakh
 */
public class Report {
    private int reportId;
    private String reportDetail;
    private Timestamp reportDate;
    private User userId;
    private ReportCategory reportCategoryId;
    private Comment commentId;
    private Material materialId;

    public Report() {
    }

    public Report(int reportId, String reportDetail, Timestamp reportDate, User userId, ReportCategory reportCategoryId, Comment commentId, Material materialId) {
        this.reportId = reportId;
        this.reportDetail = reportDetail;
        this.reportDate = reportDate;
        this.userId = userId;
        this.reportCategoryId = reportCategoryId;
        this.commentId = commentId;
        this.materialId = materialId;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getReportDetail() {
        return reportDetail;
    }

    public void setReportDetail(String reportDetail) {
        this.reportDetail = reportDetail;
    }

    public Timestamp getReportDate() {
        return reportDate;
    }

    public void setReportDate(Timestamp reportDate) {
        this.reportDate = reportDate;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    public ReportCategory getReportCategoryId() {
        return reportCategoryId;
    }

    public void setReportCategoryId(ReportCategory reportCategoryId) {
        this.reportCategoryId = reportCategoryId;
    }

    public Comment getCommentId() {
        return commentId;
    }

    public void setCommentId(Comment commentId) {
        this.commentId = commentId;
    }

    public Material getMaterialId() {
        return materialId;
    }

    public void setMaterialId(Material materialId) {
        this.materialId = materialId;
    }

    @Override
    public String toString() {
        return "Report{" + "reportId=" + reportId + ", reportDetail=" + reportDetail + ", reportDate=" + reportDate + ", userId=" + userId + ", reportCategoryId=" + reportCategoryId + ", commentId=" + commentId + ", materialId=" + materialId + '}';
    }

    
    
}
