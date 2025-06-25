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
    ArrayList<Material> matList = (ArrayList) request.getAttribute("Material");
    MaterialDAO matDAO = new MaterialDAO();
    StudyDAO stuDAO = new StudyDAO();

    User u = (User) request.getAttribute("User");
    Material mat = matDAO.getMaterialById(materialID);
    Module mol = mat.getModule();
    Course cou = mol.getCourse();
    String type = mat.getType().toLowerCase();
    String matLocate = mat.getMaterialLocation();
    String path;
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
            display: grid;
            grid-template-columns: 50px auto;
            padding: 20px;
            font-size: 18px;
            background-color: #dae3f1;
        }
        a.material{
            background-color: #ffffff;
        }
        a.material:hover{
            background-color: #dae3f1;
        }

        #material-list{
            border-right: grey solid 1px;
            height: 80vh;
            overflow-y: scroll;
            margin: 10vh 0 10vh 0;
        }

        #material-list::-webkit-scrollbar {
            display: none;
        }

        #material-list {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        #material-content{
            overflow-y: scroll;
            height: 80vh;
            margin: 10vh 0;
        }
        
        #material-content::-webkit-scrollbar {
            display: none;
        }

        #material-content {
            -ms-overflow-style: none;  
            scrollbar-width: none;  
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

        .headlink{
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 200px;
        }

        #listOfLink{
            height: 5vh;
            padding-top: 3vh;
        }
        .arrow{
            padding: 0 15px;
        }
        .check-icon{
            color: #009900;
            font-size: 22px;
            grid-row: 1 / span 2;
            align-self: center;
            text-align: center;
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
                    <li>
                        <a class="material" href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + courseID + "&ModuleID=" + moduleID + "&MaterialID=" + m.getMaterialId()%>">
                            <span class="check-icon"><%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>                        
                            <span><%=m.getMaterialName()%></span>
                        </a>
                    </li>
                    <%
                    } else {
                    %>
                    <li>
                        <span class="material">
                            <span class="check-icon"><%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>                        
                            <span><%=m.getMaterialName()%></span>
                        </span>
                    </li>
                    <%
                            }
                        }
                    %>
                </ul>
            </div>
            <div id="material-content" class="w-75">
                <div id="listOfLink" class="ms-5">
                    <a class="headlink link-primary"href="<%=request.getContextPath() + "/Learner/Course?CourseID=" + courseID%>">
                        <%=cou.getCourseName()%>
                    </a>
                    <span class="arrow">></span>
                    <a class="headlink link-primary"href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + courseID + "&ModuleID=" + moduleID + "&MaterialID=" + mat.getMaterialId()%>">
                        <%=mol.getModuleName()%>/<%=mat.getMaterialName()%>
                    </a>
                </div>
                <p class="h1 text-center mt-5"><%=mat.getMaterialName()%></p>
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
                    %>
                <p class="h6 ms-5 mat-des"><%=mat.getMaterialDescription()%></p>
                <%
                    if (!stuDAO.checkStudy(u.getUserId(), mat.getMaterialId())) {
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
