<%-- 
    Document   : homePage_Guest
    Created on : Jun 3, 2025, 2:47:19 PM
    Author     : NgoThinh1902
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Homepage</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <header class="header">
            <div class="container d-flex align-items-center justify-content-between">
                <a href="#" class="logo d-flex align-items-center">
                    <img src="img/logo.png" alt="Logo" class="logo-img me-2">
                    <span class="logo-text"></span>
                </a>
                <nav class="navbar navbar-expand-lg">
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav">
                            <li class="nav-item"><a class="nav-link" href="#home">Home</a></li>
                            <li class="nav-item"><a class="nav-link" href="#blog">Blog</a></li>
                            <li class="nav-item"><a class="nav-link" href="#courses">All Courses</a></li>
                        </ul>
                    </div>
                </nav>
                <div class="d-flex">
                    <div class="search-bar">
                        <label for="search" class="visually-hidden">Search</label>
                        <input id="search" class="form-control" type="search" placeholder="Search" aria-label="Search">
                    </div>
                    <a href="login.html" class="btn btn-primary btn-custom">Login</a>
                    <a href="register.html" class="btn btn-primary btn-custom">Register</a>
                </div>
            </div>
        </header>

        <section class="welcome-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h1>WELCOME To F–Skill</h1>
                        <div class="line"></div>
                        <p>Every course is a step closer to your dream. From foreign languages, technology to soft skills – we accompany you on your journey of continuous learning and development.</p>
                        <</div>

                    <div class="col-lg-6">
                        <img src="img/pic1.png" alt="Illustration of a girl learning" class="img-fluid">
                    </div>
                </div>
            </div>
        </section>
        <section class="subject-section py-5">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold">Subject</h4>
                    <a href="#" class="see-all">See All</a>
                </div>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="subject-box ">
                            <img src="img/codeic.png" alt="SE" class="codeic">
                            <p class="fw-bold mt-3 mb-0">SE</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="subject-box">
                            <img src="img/math1.png" alt="Math"> 
                            <p class="fw-bold mt-3 mb-0">Math</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="subject-box">
                            <img src="img/lang.png" alt="Language">
                            <p class="fw-bold mt-3 mb-0">Language</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="section">
            <div class="section-header">
                <div class="section-title">Javascript</div>
                <div class="see-all">See All Article</div>
            </div>
            <div class="articles-grid">
                <!-- Article Card Example -->
                <div class="card">
                    <div class="card-img"></div> <!-- Placeholder for image -->
                    <div class="card-body">
                        <div class="card-title">Array In Javascript - Learn JS #3</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lặp các card khác như mẫu -->
                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">Fundamental Of Javascript</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">7 Project With Javascript You Must Try For Your Portfolio</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">Make Simple Calculator With Javascript</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- React JS Section -->
        <section class="section">
            <div class="section-header">
                <div class="section-title">React JS</div>
                <div class="see-all">See All Article</div>
            </div>
            <div class="articles-grid">
                <!-- Article Card Example -->
                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">First Month Of Leaning React JS</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Các card khác như mẫu -->
                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">Build Markdown Editor With React JS</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">Getting Started With React JS</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-img"></div>
                    <div class="card-body">
                        <div class="card-title">Make Tic Tac Toe Games With React JS</div>
                        <div class="author">
                            <div class="avatar"></div>
                            <div class="author-info">
                                <div class="author-name">Dasteen</div>
                                <div>
                                    <span class="publish-date">Jan 10, 2022</span> · <span class="read-time">3 Min Read</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Button -->
        <div class="more-articles">
            <button class="more-button">More Article</button>
        </div>
        <section class="subscribe-section">
            <div class="subscribe-box">
                <img src="img/submail.png" alt="Submail Icon" class="icon" />
                <h2>Subscribe For The Lastest Updates</h2>
                <p>Subscribe to newsletter and never miss the new post every week.</p>
                <form class="subscribe-form">
                    <input type="email" placeholder="Enter your email here..." required />
                    <button type="submit">Subscribe</button>
                </form>
            </div>
        </section>
        <footer class="custom-footer">
            <div class="container py-4">
                <div class="row align-items-start">
                    <!-- Logo -->
                    <div class="col-md-4 mb-4">
                        <img src="img/logo.png" alt="F-Skill Logo" class="footer-logo mb-2">
                    </div>

                    <!-- Contact Info -->
                    <div class="col-md-4 mb-4">
                        <h6 class="fw-bold">GET IN TOUCH</h6>
                        <p><a href="tel:+62800000000" class="footer-link">+62–8XXX–XXX–XX</a></p>
                        <p><a href="mailto:demo@gmail.com" class="footer-link">demo@gmail.com</a></p>
                    </div>

                    <!-- Social Links -->
                    <div class="col-md-4 mb-4">
                        <h6 class="fw-bold">FOLLOW US</h6>
                        <p><a href="#" class="footer-link">Instagram</a></p>
                        <p><a href="#" class="footer-link">Twitter</a></p>
                        <p><a href="#" class="footer-link">Facebook</a></p>
                    </div>
                </div>

                <hr>
                <div class="d-flex justify-content-between small">
                    <p class="mb-0">© 2025 F–Skill. All rights reserved.</p>
                    <p class="mb-0">From Group 3 With ❤️</p>
                </div>
            </div>
        </footer>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>