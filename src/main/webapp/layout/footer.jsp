<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>F-Skill Footer</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    // Define a custom primary color to match the design (e.g., a blue shade)
                    colors: {
                        primary: '#0284c7', // Tailwind's sky-600, or a custom blue
                    },
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'], // Set Inter as the default font
                    }
                }
            }
        }
    </script>
    <!-- Font Awesome CDN for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" xintegrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        /* Apply Inter font globally for better consistency */
        body {
            font-family: 'Inter', sans-serif;
        }

        footer {
            margin-top: 2%;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-end">
    <!-- Footer content -->
    <footer class="bg-white text-gray-900 rounded-t-lg shadow-lg mt-0">
        <div class="mx-auto px-4 pt-12 pb-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-8"> 
                <!-- About F-Skill -->
                <div class="lg:col-span-1">
                    <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="flex items-center space-x-2">
                        <!-- Using a slightly adjusted placeholder text for better clarity -->
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-Skill Logo" class="w-auto h-16" /> 
                        <span class="text-xl font-bold text-gray-900"></span> <!-- Adjusted text size -->
                    </a>
                    <p class="text-gray-700 text-sm mt-2">An online learning platform, helping you access knowledge anytime,
                        anywhere.</p> <!-- Adjusted text size and margin -->
                </div>
                <!-- Quick Links -->
                <div>
                    <h4 class="font-bold text-gray-900 text-base mb-3">Quick Links</h4> 
                    <ul class="space-y-2 text-sm"> <!-- Adjusted text size and space-y -->
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/AllCourses" class="hover:text-primary transition-colors duration-200">All Courses</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">Privacy Policy</a></li>
                    </ul>
                </div>
                <!-- Contact Info -->
                <div>
                    <h4 class="font-bold text-gray-900 text-base mb-3">Contact</h4> 
                    <ul class="space-y-2 text-sm"> 
                        <li class="flex items-start space-x-2"> 
                            <i class="fa-solid fa-phone mt-1 text-primary"></i>
                            <span>+62?8XXX?XXX?XX</span>
                        </li>
                        <li class="flex items-start space-x-2"> 
                            <i class="fa-solid fa-envelope mt-1 text-primary"></i>
                            <span>demo@gmail.com</span>
                        </li>
                        <li class="flex items-start space-x-2"> 
                            <i class="fa-solid fa-map-marker-alt mt-1 text-primary"></i>
                            <span>Khu II, ?. 3/2, Xuan Khanh, Ninh Kieu, Can Tho</span>
                        </li>
                    </ul>
                </div>
                <!-- Follow Us -->
                <div>
                    <h4 class="font-bold text-gray-900 text-base mb-3">Follow Us</h4> 
                    <div class="flex space-x-3"> 
                        <a href="#"
                           class="h-9 w-9 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-base"> <!-- Adjusted size and text size -->
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#"
                           class="h-9 w-9 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-base"> <!-- Adjusted size and text size -->
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#"
                           class="h-9 w-9 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-base"> <!-- Adjusted size and text size -->
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>
            </div>

            <div class="border-t border-gray-200 pt-6 text-center text-gray-600 text-sm"> 
                <p>&copy; 2025 F-Skills. All rights reserved. | From Group 3 With <i class="bi bi-heart-fill text-danger text-xs"></i></p> 
            </div>
        </div>
    </footer>
</body>
</html>
