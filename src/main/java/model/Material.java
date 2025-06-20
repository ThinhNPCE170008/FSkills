/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Duy - CE180230 - SE1815
 */
public class Material {
    private int materialId;
    private String materialName;
    private Module module;
    private String type;
    private Timestamp materialLastUpdate;
    private int materialOrder;
    private int time;
    private String materialDescription;
    private String materialLocation;

    public Material() {
    }

    public Material(int materialId, String materialName, Module module, String type, Timestamp materialLastUpdate, int materialOrder, int time, String materialDescription, String materialLocation) {
        this.materialId = materialId;
        this.materialName = materialName;
        this.module = module;
        this.type = type;
        this.materialLastUpdate = materialLastUpdate;
        this.materialOrder = materialOrder;
        this.time = time;
        this.materialDescription = materialDescription;
        this.materialLocation = materialLocation;
    }

    public int getMaterialId() {
        return materialId;
    }

    public void setMaterialId(int materialId) {
        this.materialId = materialId;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public Module getModule() {
        return module;
    }

    public void setModule(Module module) {
        this.module = module;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getMaterialLastUpdate() {
        return materialLastUpdate;
    }

    public void setMaterialLastUpdate(Timestamp materialLastUpdate) {
        this.materialLastUpdate = materialLastUpdate;
    }

    public int getMaterialOrder() {
        return materialOrder;
    }

    public void setMaterialOrder(int materialOrder) {
        this.materialOrder = materialOrder;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public String getMaterialDescription() {
        return materialDescription;
    }

    public void setMaterialDescription(String materialDescription) {
        this.materialDescription = materialDescription;
    }

    public String getMaterialLocation() {
        return materialLocation;
    }

    public void setMaterialLocation(String materialLocation) {
        this.materialLocation = materialLocation;
    }

    @Override
    public String toString() {
        return "Material{" + "materialId=" + materialId + ", materialName=" + materialName + ", module=" + module + ", type=" + type + ", materialLastUpdate=" + materialLastUpdate + ", materialOrder=" + materialOrder + ", time=" + time + ", materialDescription=" + materialDescription + ", materialLocation=" + materialLocation + '}';
    }

    

}