package model;

import java.sql.Timestamp;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class Module {
    private int moduleID;
    private String moduleName;
    private Course course;
    private Timestamp moduleLastUpdate;

    public Module() {
    }
    
    public Module(int moduleID, String moduleName, Course course) {
        this.moduleID = moduleID;
        this.moduleName = moduleName;
        this.course = course;
    }
    

    public Module(int moduleID, String moduleName, Course course, Timestamp moduleLastUpdate) {
        this.moduleID = moduleID;
        this.moduleName = moduleName;
        this.course = course;
        this.moduleLastUpdate = moduleLastUpdate;
    }

    // Using Insert Module
    public Module(String moduleName, Course course) {
        this.moduleName = moduleName;
        this.course = course;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Timestamp getModuleLastUpdate() {
        return moduleLastUpdate;
    }

    public void setModuleLastUpdate(Timestamp moduleLastUpdate) {
        this.moduleLastUpdate = moduleLastUpdate;
    }

    @Override
    public String toString() {
        return "Module{" +
                "moduleID:" + moduleID +
                ", moduleName='" + moduleName + '\'' +
                ", course=" + course +
                ", moduleLastUpdate=" + moduleLastUpdate +
                '}';
    }
}
