<%@page import="dao.MaterialDAO"%>
<%@page import="model.Material"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Module"%>
<%@page import="dao.ModuleDAO"%>
<%@page import="model.Course"%>
<%@page import="dao.CourseDAO"%>
<%@page import="dao.StudyDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Course cou = (Course) request.getAttribute("Course");
    User u = (User) request.getAttribute("User");
    ArrayList<Module> molList = (ArrayList) request.getAttribute("ModuleList");
    ArrayList<Material> matList;
    StudyDAO stuDAO = new StudyDAO();
    CourseDAO couDAO = new CourseDAO();
    ModuleDAO molDAO = new ModuleDAO();
    MaterialDAO matDAO = new MaterialDAO();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=cou.getCourseName()%> Content</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    </head>
    <style>
        #siteContent{
            width: 100vw;
            margin-left: 13vw;
        }
        #matList{
            width: 60vw;
            margin-top: 10vh;
            border-radius: 10px;
            overflow-y: auto;
            max-height: 100%;
        }
        #courseDetail{
            background-color: white;
            width: 60vw;
            margin-left: 2vw;
        }

        #courseImage{
            width: 15vw;
            height: auto;
        }
        #courseText{
            padding-left: 30px;
            width: 100%;
        }
        #courseName{
            text-align: left;
            font-size: 24px;
            font-weight: 600;
        }
        .contentBox{
            display: block;
            background-color: white;
            margin: 1vh 0;
        }
        .eachMat{
            display: grid;
            grid-template-columns: 50px auto;
            padding: 10px;
            padding-left: 50px;
            font-size: 16px;
        }
        .eachMat:hover{
            background-color: #dae3f1;
        }
        .listheader{
            display:block;
            font-size: 24px;
            width: 100%;
            border-bottom: 1px solid #7c8ca6;
            padding: 3vh 5vh 10px 3vh;
            text-decoration: none;
            color: black;
        }
        .check-icon{
            color: #009900;
            font-size: 22px;
            grid-row: 1 / span 2;
            align-self: center;
            text-align: center;
        }
        .mat-type{
            color: gray;
        }

        a.link{
            color: black;
        }

        ul.list{
            margin: 0;
            padding: 0;
        }

        .headlink{
            display: block;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 200px;
        }
        .arrow{
            padding: 0 15px;
        }
        #main-body{
            min-height: 100vh;
        }
        .collapse.show {
            visibility: visible;
        }
        .collapse {
            transition: height 0.35s ease;
            overflow: hidden;
        }

    </style>
    <body>
        <%@include file="../../layout/sidebar_user.jsp"%>
        <div id="main-body">
            <div id="courseDetail" class="d-flex mx-auto mt-5">
                <img id="courseImage" src="<%=cou.getCourseImageLocation()%>" alt="alt"/>
                <div id="courseText">
                    <p id="courseName"><%=cou.getCourseName()%></p>
                    <p id="courseSum">
                        
                    </p>
                </div>
            </div>
            <div id ="siteContent" class="d-flex mx-auto">
                <div id="matList" class="d-flex flex-column overflow-auto mx-auto">
                    <%
                        int i = 0;
                        for (Module mol : molList) {
                            i++;
                            matList = (ArrayList) matDAO.getAllMaterial(cou.getCourseID(), mol.getModuleID());
                    %>
                    <div class="contentBox">
                        <a class="listheader" data-bs-toggle="collapse" href="#list<%=i%>" role="button" aria-expanded="false" aria-controls="list<%=i%>"><%=mol.getModuleName()%></a>
                        <div id="list<%=i%>" class="collapse">
                            <div class="list">
                                <%
                                    for (Material mat : matList) {
                                %>
                                <a class="link link-offset-2 link-underline link-underline-opacity-0 eachMat w-100" href="<%=request.getContextPath() + "/Learner/Course/Module/Material?CourseID=" + cou.getCourseID() + "&ModuleID=" + mol.getModuleID() + "&MaterialID=" + mat.getMaterialId()%>">
                                    <span class="check-icon"><%=stuDAO.checkStudy(u.getUserId(), mat.getMaterialId()) ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>                        
                                    <span class="flex-grow-1"><%=mat.getMaterialName()%></span>
                                    <span class="mat-type"><%=mat.getType()%></span>
                                </a>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

        <%@include file="../../layout/footer.jsp" %>
    </body>
</html>
