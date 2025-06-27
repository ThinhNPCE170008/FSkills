<%@page import="model.Course"%>
<%@page import="model.Module"%>
<%@page import="dao.StudyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Material"%>
<%@page import="model.User"%>
<%@page import="dao.MaterialDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int courseID = (int) request.getAttribute("CourseID");
    int moduleID = (int) request.getAttribute("ModuleID");
    int materialID = (int) request.getAttribute("MaterialID");
    MaterialDAO matDAO = new MaterialDAO();
    StudyDAO stuDAO = new StudyDAO();

    User u = (User) request.getAttribute("User");
    Material mat = matDAO.getMaterialById(materialID);
    Module mol = mat.getModule();
    Course cou = mol.getCourse();
    String type = mat.getType().toLowerCase();
    String matLocate = mat.getMaterialLocation();
    String path;
    ArrayList<Material> matList = (ArrayList) matDAO.getAllMaterial(courseID, moduleID);
    if (matLocate.startsWith("materialUpload")) {
        path = request.getContextPath() + "/" + matLocate;
    } else {
        path = matLocate;
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=mat.getMaterialName()%></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    </head>
    <style>
        .material{
            display: block;
            padding: 20px;
            font-size: 18px;
            border-bottom: grey solid 1px;
            justify-content: center;
        }
        a.material:hover{
            background-color: #f1f1f1;
        }

        .completedMaterial{
            display: block;
            padding: 20px;
            font-size: 18px;
            border-bottom: grey solid 1px;
            justify-content: center;
            background-color: #007bff;
            color: white;
        }

        a.completedMaterial:hover{
            background-color: #0066cc;
        }

        #material-list{
            border-right: grey solid 1px;
            height: 90vh;
            overflow-y: scroll;
            margin: 5vh 0;
        }

        #material-content{
            overflow-y: scroll;
        }

        .mat-des{
            margin-top: 50px;
            margin-left: 30px;
        }

        iframe{
            margin-top: 50px;
            height: 60%;
            width: 75%;
        }
        #completeButton{
            padding: 10px;
            margin: 30px;
            font-size: 18px;
        }
    </style>
    <body>
        <%@include file="../../layout/sidebar_user.jsp"%>
        <div class="d-flex w-75 mx-auto">
            <div id="material-list" class="w-25">
                <ul>
                    <%  for (Material m : matList) {
                            if (m.getMaterialId() != materialID) {
                    %>
                    <li><a class="<%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "completedMaterial" : "material"%>" href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + courseID + "&ModuleID=" + moduleID + "&MaterialID=" + m.getMaterialId()%>"><%=m.getMaterialName()%></a></li>
                    <%
                            } else {
                    %>
                    <li><span class="<%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "completedMaterial" : "material"%>"><%=m.getMaterialName()%><span></li>
                    <%
                                }
                        }
                    %>
                </ul>
            </div>
            <div id="material-content" class="w-75">
                <p class="h1 text-center mt-5"><%=mat.getMaterialName()%></p>
                <p class="h6 ms-5 mat-des"><%=mat.getMaterialDescription()%></p>
                    <%
                        if (matLocate.endsWith("docx")) {
                    %>
                <p class="h6 ms-5 mt-5">Download Word Document:</p>
                <a class="h6 ms-5 link-primary" href="<%=path%>" download><%=matLocate.replace("materialUpload/", "")%></a>
                    <%
                        } else {
                    %>
                <iframe class="mx-auto" src="<%=path%>"></iframe>
                    <%
                        }
                        if (!stuDAO.checkStudy(u.getUserId(), mat.getMaterialId())){
                    %>
                <form method="POST" action="<%= request.getContextPath()%>/Learner/Course/Module/Material">
                    <button type="submit" name="completeMaterial" value="1" id="completeButton" class="btn btn-primary">Complete</button>
                    <input type="hidden" name="courseID" value="<%=cou.getCourseID()%>">
                    <input type="hidden" name="moduleID" value="<%=mol.getModuleID()%>">
                    <input type="hidden" name="materialID" value="<%=mat.getMaterialId()%>">
                </form>
                    <%}%>
            </div>
        </div>
    </body>
</html>
