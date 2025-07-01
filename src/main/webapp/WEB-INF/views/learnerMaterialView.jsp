<%@page import="model.Course"%>
<%@page import="model.Module"%>
<%@page import="dao.StudyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Material"%>
<%@page import="model.User"%>
<%@page import="dao.MaterialDAO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%
    int courseID = (int) request.getAttribute("CourseID");
    int moduleID = (int) request.getAttribute("ModuleID");
    int materialID = (int) request.getAttribute("MaterialID");
    ArrayList<Module> molList = (ArrayList) request.getAttribute("Module");
    ArrayList<Material> matList;
    MaterialDAO matDAO = new MaterialDAO();
    StudyDAO stuDAO = new StudyDAO();
    User u = (User) request.getAttribute("User");
    Material mat = matDAO.getMaterialById(materialID);
    Module mol = mat.getModule();
    Course cou = mol.getCourse();
    String type = mat.getType().toLowerCase();
    String matLocate = mat.getMaterialLocation();
    String path;
    int i = 0;
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
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    </head>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        #content{
            display: flex;
            align-items: flex-start;
            flex-direction: row;
            padding-left: 3vw;
            min-height: 100vh;
            box-sizing: border-box;
            width: 100%;
            overflow: hidden;
        }
        .material{
            display: grid;
            width: 100%;
            grid-template-columns: 50px auto;
            padding: 10px;
            font-size: 16px;
            background-color: #dae3f1;
            padding-right: 10%;
        }
        a.material{
            text-decoration: none;
            color: black;
            background-color: #ffffff;
        }
        a.material:hover{
            background-color: #dae3f1;
        }

        #material-content{
            overflow-y: scroll;
            flex: 5 1 0;
            height: 100vh;
            padding: 3vh 0 10vh 0;
            min-width: 0;
        }

        #material-content::-webkit-scrollbar {
            display: none;
        }

        #material-content {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        #material-list{
            border-left: grey solid 1px;
            height: 100vh;
            flex: 1 1 0;
            overflow-y: scroll;
            padding: 3vh 0 10vh 0;
            min-width: 0;
        }

        #material-list::-webkit-scrollbar {
            display: none;
        }

        #material-list {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .mat-des{
            margin: 50px 80px 0 80px;
        }

        iframe{
            margin-top: 30px;
            width: 90%;
            height: 80%;
        }
        #completeButton{
            padding: 10px;
            margin: 30px;
            font-size: 18px;
        }

        .linkoverflow{
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        #listOfLink.linkoverflow{
            max-width: 100px;
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
        #molName{
            display:block;
            font-size: 18px;
            padding-left: 5%;
            padding-right: 10%;
            font-weight: 600;
            text-decoration: none;
            color: black;
            padding-top: 10px;
            padding-bottom: 10px;
            background-color: lightgray;
        }
    </style>
    <body>
        <%@include file="../../layout/sidebar_user.jsp"%>
        <div id="content" class=" w-100">
            <div id="material-content" class="main">
                <div id="listOfLink" class="ms-5">
                    <a class="linkoverflow link-primary"href="<%=request.getContextPath() + "/Learner/Course?CourseID=" + courseID%>">
                        <%=cou.getCourseName()%>
                    </a>
                    <span class="arrow">></span>
                    <a class="linkoverflow link-primary"href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + courseID + "&ModuleID=" + moduleID + "&MaterialID=" + mat.getMaterialId()%>">
                        <%=mol.getModuleName()%>/<%=mat.getMaterialName()%>
                    </a>
                </div>
                <p class="h1 text-center mt-3"><%=mat.getMaterialName()%></p>
                <%
                    if (matLocate.endsWith("docx")) {
                %>
                <p class="h6 ms-5 mt-5">Download Word Document:</p>
                <a class="h6 ms-5 link-primary" href="<%=path%>" download><%=matLocate.replace("materialUpload/", "")%></a>
                <%
                } else {
                %>
                <iframe class="d-block mx-auto" src="<%=path%>"></iframe>
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
            <div id="material-list">
                <%
                    for (Module mo : molList) {
                        matList = (ArrayList) matDAO.getAllMaterial(courseID, mo.getModuleID());
                        i++;
                %>
                <a id="molName" class="linkoverflow" data-bs-toggle="collapse" href="#list<%=i%>" role="button" aria-expanded="false" aria-controls="list<%=i%>"><%=mo.getModuleName()%></a>
                <div id="list<%=i%>" class="collapse<%=mo.getModuleID() == moduleID ? ".show" : ""%>">
                    <%  for (Material m : matList) {
                            if (m.getMaterialId() != materialID) {
                    %>
                    <a class="material linkoverflow" href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + courseID + "&ModuleID=" + moduleID + "&MaterialID=" + m.getMaterialId()%>">
                        <span class="check-icon"><%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>                        
                        <span class="linkoverflow"><%=m.getMaterialName()%></span>
                    </a>
                    <%
                    } else {
                    %>
                    <span class="material">
                        <span class="check-icon"><%=stuDAO.checkStudy(u.getUserId(), m.getMaterialId()) ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>                        
                        <span class="linkoverflow"><%=m.getMaterialName()%></span>
                    </span>
                    <%
                            }
                        }
                    %>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
