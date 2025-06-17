<%--
  Created by IntelliJ IDEA.
  User: NgoThinh1902
  Date: 6/18/2025
  Time: 1:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome for Icons -->
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
                            light: '#03a9f4',   // sky-500
                            dark: '#075985',   // sky-800
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
<body>
<footer class="bg-slate-800 text-slate-300">
    <div class="container mx-auto px-4 pt-16 pb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
            <!-- About F-Skill -->
            <div class="lg:col-span-1">
                <a href="#" class="flex items-center space-x-2 mb-4">
                    <img src="https://placehold.co/40x40/ffffff/0284c7?text=FS" alt="Logo" class="rounded-lg">
                    <span class="text-2xl font-bold text-white">F-Skill</span>
                </a>
                <p class="text-slate-400">An online learning platform, helping you access knowledge anytime,
                    anywhere.</p>
            </div>
            <!-- Quick Links -->
            <div>
                <h4 class="font-bold text-white text-lg mb-4">Quick Links</h4>
                <ul class="space-y-3">
                    <li><a href="#" class="hover:text-primary transition-colors">About Us</a></li>
                    <li><a href="#" class="hover:text-primary transition-colors">All Courses</a></li>
                    <li><a href="#" class="hover:text-primary transition-colors">Terms of Service</a></li>
                    <li><a href="#" class="hover:text-primary transition-colors">Privacy Policy</a></li>
                </ul>
            </div>
            <!-- Contact Info -->
            <div>
                <h4 class="font-bold text-white text-lg mb-4">Contact</h4>
                <ul class="space-y-3">
                    <li class="flex items-start space-x-3"><i class="fa-solid fa-phone mt-1 text-primary"></i><span>+62–8XXX–XXX–XX</span>
                    </li>
                    <li class="flex items-start space-x-3"><i class="fa-solid fa-envelope mt-1 text-primary"></i><span>demo@gmail.com</span>
                    </li>
                    <li class="flex items-start space-x-3"><i
                            class="fa-solid fa-map-marker-alt mt-1 text-primary"></i><span>Khu II, Đ. 3/2, Xuan Khanh, Ninh Kieu, Can Tho</span>
                    </li>
                </ul>
            </div>
            <!-- Social Media -->
            <div>
                <h4 class="font-bold text-white text-lg mb-4">Follow Us</h4>
                <div class="flex space-x-4">
                    <a href="#"
                       class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i
                            class="fab fa-facebook-f"></i></a>
                    <a href="#"
                       class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i
                            class="fab fa-twitter"></i></a>
                    <a href="#"
                       class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i
                            class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>

        <div class="border-t border-slate-700 pt-8 text-center text-slate-500">
            <p>© 2025 F–Skill. All rights reserved. | From Group 3 With ❤️</p>
        </div>
    </div>
</footer>
</body>
</html>
