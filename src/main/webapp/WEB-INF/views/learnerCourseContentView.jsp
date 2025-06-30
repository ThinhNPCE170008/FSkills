<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.MaterialDAO"%>
<%@page import="model.Material"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Module"%>
<%@page import="dao.ModuleDAO"%>
<%@page import="model.Course"%>
<%@page import="dao.CourseDAO"%>
<%@page import="dao.StudyDAO"%>
<%@page import="model.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%
    System.out.println("A");
    Course cou = (Course) request.getAttribute("Course");
    System.out.println("B");
    User u = (User) request.getAttribute("User");
    ArrayList<Module> molList = (ArrayList) request.getAttribute("ModuleList");
    ArrayList<Material> matList;
    StudyDAO stuDAO = new StudyDAO();
    CourseDAO couDAO = new CourseDAO();
    ModuleDAO molDAO = new ModuleDAO();
    MaterialDAO matDAO = new MaterialDAO();
    int progress = stuDAO.returnStudyProgress(u.getUserId(), cou.getCourseID());
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=cou.getCourseName()%> Content</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    </head>
    <style>
        #main-body{
            background-color: white;
            padding: 0;
            min-height: 100vh;
            box-sizing: border-box;
            padding-bottom: 50px;
        }
        #siteContent{
            width: 100%;
        }
        #matList{
            flex: 1 1 0;
            min-width: 0;
            margin-top: 5vh;
            border-radius: 10px;
            overflow-y: auto;
            max-height: 100%;
        }
        #courseDetail{
            margin-left: 2vw;
            width: 65%;
        }
        #rightside{
            width: 35%;
        }

        #courseImage{
            width: 70%;
            height: auto;
        }
        #courseText{
            padding: 10px 30px 30px 30px;
            font-size: 22px;
            width: 100%;

        }
        #courseName{
            text-align: left;
            font-size: 48px;
            font-weight: 600;
            margin-bottom: 30px
        }
        #courseSum{
            margin-bottom: 15px;
        }
        #courseHighlight{
        }
        .contentBox{
            display: block;
            margin: 0 7vh;
            width: 80%;
        }
        .eachMat{
            display: grid;
            grid-template-columns: 50px auto;
            padding: 10px;
            padding-left: 50px;
            font-size: 16px;
        }
        .eachMat:hover{
            background-color: lightgray;
        }
        .listheader{
            display:block;
            font-size: 24px;
            width: 100%;
            background-color: lightgray;
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
        .collapse.show {
            visibility: visible;
        }
        .collapse {
            transition: height 0.35s ease;
            overflow: hidden;
        }
        .arrow-icon {
            transition: transform 0.3s ease;
            margin: 0 10px;
        }

        .listheader[aria-expanded="true"] .arrow-icon {
            transform: rotate(180deg);
        }
        .text{
            font-size: 18px;
            margin-left: 100px;
        }


    </style>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp"%>
        <main id="main-body" class="main d-flex">
            <div id="courseDetail" class="mt-5 flex-fill">
                <div id="courseText">
                    <p id="courseName"><%=cou.getCourseName()%></p>
                    <p id="courseSum">
                        <%=cou.getCourseSummary()%>
                    </p>
                    <p id="courseHighlight">
                        <%=cou.getCourseHighlight()%>
                    </p>
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
                            <a class="listheader" data-bs-toggle="collapse" href="#list<%=i%>" role="button" aria-expanded="false" aria-controls="list<%=i%>">
                                <i class="fa-solid fa-chevron-down arrow-icon"></i>
                                <span class="flex-grow-1"><%=mol.getModuleName()%></span>
                                <span class="check-icon"><%= stuDAO.returnTotalStudy(u.getUserId(), mol.getModuleID()) == matList.size() ? "<i class=\"fa-solid fa-circle-check\"></i>" : ""%></span>
                            </a>
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
            <div id="rightside">
                <img id="courseImage" class="mx-auto mt-5" src="<%=cou.getCourseImageLocation()%>" alt="alt"/>
                <div class="mt-5 text-start text">
                    <p><b>Author:</b> <%=cou.getUser().getUserName()%></p>
                    <p><b>Category:</b> <%=cou.getCategory().getName()%></p>
                    <p><b>Last update:</b> <%=new SimpleDateFormat("dd/MM/yyyy").format(cou.getCourseLastUpdate())%></p>
                    <p><b>Progress:</b></p>
                    <div class="progress w-75" style="height: 20px">
                        <div class="progress-bar bg-success" role="progressbar" style="width: <%=progress%>%" aria-valuenow="<%=progress%>" aria-valuemin="0" aria-valuemax="100"><b><%=progress%>%</b></div>
                    </div>
                    
                </div>
            </div>
        </main>


        <%@include file="../../layout/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
