<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>F-Skill | Enhance Your Skills</title>

    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <script>
      // Custom configuration for Tailwind CSS
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: {
              inter: ['Inter', 'sans-serif'],
            },
            colors: {
              primary: {
                DEFAULT: '#0284c7', // sky-600
                light: '#03a9f4',    // sky-500
                dark: '#075985',    // sky-800
              },
              secondary: '#475569', // slate-600
            }
          }
        }
      }
    </script>

    <style>
      /* Additional custom styles */
      .hero-gradient {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
      }
      .card-hover {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }
      .card-hover:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
      }
    </style>
</head>

<body class="font-inter bg-white text-gray-800">
    <jsp:include page="/layout/sidebar_user.jsp" />

    <header class="bg-white/80 backdrop-blur-lg sticky top-0 z-50 shadow-sm">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between h-20">
<%--                <div class="flex items-center space-x-2">--%>
<%--                    <img src="img/logo.png" alt="F-SKILL Logo" class="w-20 h-auto" />--%>
<%--                    <span class="text-2xl font-bold text-gray-800"></span>--%>
<%--                </div>--%>

<%--                <nav class="hidden lg:flex items-center space-x-8">--%>
<%--                    <a href="#home" class="text-gray-600 hover:text-primary font-medium transition-colors">Home</a>--%>
<%--                    <a href="#subjects" class="text-gray-600 hover:text-primary font-medium transition-colors">Subjects</a>--%>
<%--                    <a href="#courses" class="text-gray-600 hover:text-primary font-medium transition-colors">Courses</a>--%>
<%--                    <a href="${pageContext.request.contextPath}/announcements" class="text-gray-600 hover:text-primary font-medium transition-colors">Announcement</a>--%>
<%--                </nav>--%>

    <div class="flex-grow flex justify-center">
        <div class="relative w-full max-w-xl"> <input type="search" placeholder="Search for courses..."
                                                      class="w-full pl-4 pr-10 py-2.5 border border-gray-200 rounded-full focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all duration-300 ease-in-out">
            <i class="fa-solid fa-magnifying-glass absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
        </div>
    </div>

    <div class="flex items-center space-x-4">
        <a href="login" class="hidden sm:inline-block text-secondary hover:text-primary font-semibold transition-colors">Sign In</a>
        <a href="signup.jsp" class="px-5 py-2.5 rounded-full font-semibold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-md hover:shadow-lg">
            Sign Up
        </a>
    </div>
            </div>
        </div>
    </header>

    <main>

        <section id="home" class="hero-gradient">
            <div class="container mx-auto px-4 py-20 lg:py-32">
                <div class="grid lg:grid-cols-2 gap-12 items-center">
                    <div class="text-center lg:text-left">
                        <h1 class="text-4xl lg:text-6xl font-extrabold text-primary-dark leading-tight mb-6">Unlock Your Potential, Conquer the Future</h1>
                        <p class="text-lg lg:text-xl text-secondary mb-8">
                            Every course is a step towards your dream. From languages and technology to soft skills – we accompany you on your journey of continuous development.
                        </p>
                        <a href="#courses" class="inline-block px-8 py-4 rounded-full font-bold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-xl hover:shadow-2xl text-lg">
                            Explore Now <i class="fa-solid fa-arrow-right ml-2"></i>
                        </a>
                    </div>
                    <div>
                        <img src="https://placehold.co/600x500/dbeafe/3b82f6?text=Modern+Learning" alt="Illustration of a girl learning" class="rounded-2xl shadow-2xl w-full">
                    </div>
                </div>
            </div>
        </section>

        <section id="subjects" class="py-16 lg:py-24">
            <div class="container mx-auto px-4">
                <div class="text-center mb-12">
                    <h2 class="text-3xl lg:text-4xl font-bold mb-3">Explore by Subject</h2>
                    <p class="text-lg text-secondary max-w-2xl mx-auto">Find the educational path that best suits your passion and goals.</p>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div class="card-hover bg-sky-50 border border-sky-100 p-8 rounded-2xl text-center flex flex-col items-center">
                        <div class="bg-sky-200 text-sky-700 h-16 w-16 rounded-full flex items-center justify-center mb-5">
                            <i class="fa-solid fa-code fa-2x"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Programming (SE)</h3>
                        <p class="text-secondary">From Python and Java to Web and Mobile development. Master the technology of the future.</p>
                    </div>
                    <div class="card-hover bg-amber-50 border border-amber-100 p-8 rounded-2xl text-center flex flex-col items-center">
                        <div class="bg-amber-200 text-amber-700 h-16 w-16 rounded-full flex items-center justify-center mb-5">
                           <i class="fa-solid fa-calculator fa-2x"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Mathematics</h3>
                        <p class="text-secondary">Strengthen fundamental knowledge, prepare for exams, and conquer challenging problems.</p>
                    </div>
                    <div class="card-hover bg-violet-50 border border-violet-100 p-8 rounded-2xl text-center flex flex-col items-center">
                        <div class="bg-violet-200 text-violet-700 h-16 w-16 rounded-full flex items-center justify-center mb-5">
                            <i class="fa-solid fa-language fa-2x"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Languages</h3>
                        <p class="text-secondary">Confidently communicate in English, Japanese, Korean... Open the door to the world.</p>
                    </div>
                </div>
            </div>
        </section>

        <section id="courses" class="py-16 lg:py-24 bg-slate-50">
             <div class="container mx-auto px-4">
                 <div class="flex justify-between items-center mb-12">
                     <h2 class="text-3xl lg:text-4xl font-bold">Featured Courses</h2>
                     <a href="#" class="font-semibold text-primary hover:text-primary-dark transition-colors">
                         View All <i class="fa-solid fa-angle-right ml-1"></i>
                     </a>
                 </div>
                 <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                     <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden group">
                         <div class="overflow-hidden">
                            <img src="https://placehold.co/600x400/38bdf8/ffffff?text=JavaScript" alt="Course thumbnail" class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                         </div>
                         <div class="p-6">
                            <h3 class="text-lg font-bold leading-tight mb-3 h-14">Array In Javascript - Learn JS #3</h3>
                            <div class="flex items-center space-x-3">
                                <img src="https://i.pravatar.cc/40?u=dasteen" alt="Author avatar" class="w-10 h-10 rounded-full">
                                <div>
                                    <p class="font-semibold">Dasteen</p>
                                    <p class="text-sm text-gray-500">Jan 10, 2022 · 3 Min Read</p>
                                </div>
                            </div>
                         </div>
                     </div>
                     <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden group">
                         <div class="overflow-hidden">
                            <img src="https://placehold.co/600x400/fbbf24/ffffff?text=JS+Fundamental" alt="Course thumbnail" class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                         </div>
                         <div class="p-6">
                            <h3 class="text-lg font-bold leading-tight mb-3 h-14">Fundamental Of Javascript</h3>
                            <div class="flex items-center space-x-3">
                                <img src="https://i.pravatar.cc/40?u=dasteen" alt="Author avatar" class="w-10 h-10 rounded-full">
                                <div>
                                    <p class="font-semibold">Dasteen</p>
                                    <p class="text-sm text-gray-500">Jan 10, 2022 · 5 Min Read</p>
                                </div>
                            </div>
                         </div>
                     </div>
                     <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden group">
                         <div class="overflow-hidden">
                            <img src="https://placehold.co/600x400/a855f7/ffffff?text=ReactJS" alt="Course thumbnail" class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                         </div>
                         <div class="p-6">
                            <h3 class="text-lg font-bold leading-tight mb-3 h-14">First Month Of Learning React JS</h3>
                            <div class="flex items-center space-x-3">
                                <img src="https://i.pravatar.cc/40?u=dasteen" alt="Author avatar" class="w-10 h-10 rounded-full">
                                <div>
                                    <p class="font-semibold">Dasteen</p>
                                    <p class="text-sm text-gray-500">Jan 10, 2022 · 8 Min Read</p>
                                </div>
                            </div>
                         </div>
                     </div>
                     <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden group">
                         <div class="overflow-hidden">
                            <img src="https://placehold.co/600x400/ec4899/ffffff?text=Tic+Tac+Toe" alt="Course thumbnail" class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                         </div>
                         <div class="p-6">
                            <h3 class="text-lg font-bold leading-tight mb-3 h-14">Make Tic Tac Toe Games With React JS</h3>
                            <div class="flex items-center space-x-3">
                                <img src="https://i.pravatar.cc/40?u=dasteen" alt="Author avatar" class="w-10 h-10 rounded-full">
                                <div>
                                    <p class="font-semibold">Dasteen</p>
                                    <p class="text-sm text-gray-500">Jan 10, 2022 · 10 Min Read</p>
                                </div>
                            </div>
                         </div>
                     </div>
                 </div>
             </div>
        </section>

        <section class="py-16 lg:py-24">
            <div class="container mx-auto px-4">
                <div class="bg-primary-dark rounded-2xl p-8 md:p-12 lg:p-16 text-center relative overflow-hidden">
                    <div class="absolute -top-10 -left-10 w-32 h-32 bg-white/10 rounded-full"></div>
                    <div class="absolute -bottom-16 -right-5 w-48 h-48 bg-white/10 rounded-full"></div>

                    <div class="relative z-10 flex flex-col items-center">
                        <div class="bg-white/20 h-16 w-16 rounded-full flex items-center justify-center mb-5">
                            <i class="fa-solid fa-envelope-open-text fa-2x text-white"></i>
                        </div>
                        <h2 class="text-3xl lg:text-4xl font-bold text-white mb-4">Get The Latest Updates</h2>
                        <p class="text-lg text-sky-200 max-w-xl mx-auto mb-8">Subscribe to our newsletter and never miss a new post every week.</p>
                        <form class="w-full max-w-lg flex flex-col sm:flex-row gap-3">
                            <input type="email" placeholder="Enter your email..." required class="flex-grow w-full px-5 py-4 rounded-full border-none outline-none text-gray-800" />
                            <button type="submit" class="px-8 py-4 rounded-full font-semibold bg-white text-primary hover:bg-sky-100 transition-colors">Subscribe</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

    </main>

    <footer class="bg-slate-800 text-slate-300">
        <div class="container mx-auto px-4 pt-16 pb-8">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
                <div class="lg:col-span-1">
                     <a href="#" class="flex items-center space-x-2 mb-4">
                         <img src="https://placehold.co/40x40/ffffff/0284c7?text=FS" alt="Logo" class="rounded-lg">
                         <span class="text-2xl font-bold text-white">F-Skill</span>
                     </a>
                     <p class="text-slate-400">An online learning platform, helping you access knowledge anytime, anywhere.</p>
                </div>
                <div>
                    <h4 class="font-bold text-white text-lg mb-4">Quick Links</h4>
                    <ul class="space-y-3">
                        <li><a href="#" class="hover:text-primary transition-colors">About Us</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">All Courses</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Privacy Policy</a></li>
                    </ul>
                </div>
                <div>
                     <h4 class="font-bold text-white text-lg mb-4">Contact</h4>
                     <ul class="space-y-3">
                         <li class="flex items-start space-x-3"><i class="fa-solid fa-phone mt-1 text-primary"></i><span>+62–8XXX–XXX–XX</span></li>
                         <li class="flex items-start space-x-3"><i class="fa-solid fa-envelope mt-1 text-primary"></i><span>demo@gmail.com</span></li>
                         <li class="flex items-start space-x-3"><i class="fa-solid fa-map-marker-alt mt-1 text-primary"></i><span>Khu II, Đ. 3/2, Xuan Khanh, Ninh Kieu, Can Tho</span></li>
                     </ul>
                </div>
                <div>
                     <h4 class="font-bold text-white text-lg mb-4">Follow Us</h4>
                     <div class="flex space-x-4">
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-instagram"></i></a>
                     </div>
                 </div>
            </div>

            <div class="border-t border-slate-700 pt-8 text-center text-slate-500">
                <p>© 2025 F–Skill. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" xintegrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
</body>

</html>
