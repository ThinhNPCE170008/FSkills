<%-- Footer Component - No HTML/HEAD/BODY tags as this is included in other pages --%>
<!-- Tailwind CSS Config for Footer -->
<script>
    if (typeof tailwind === 'undefined') {
        document.write('<script src="https://cdn.tailwindcss.com"><\/script>');
    }

    if (typeof tailwind !== 'undefined') {
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#0284c7',
                    },
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                    }
                }
            }
        }
    }
</script>
<!-- Font Awesome for icons (only loaded if not already present) -->
<script>
    if (!document.querySelector('link[href*="font-awesome"]')) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css';
        document.head.appendChild(link);
    }
</script>
<style>
    /* Footer specific styles */
    .footer-container {
        margin-top: 2rem;
        width: 100%;
        overflow-x: hidden;
        max-width: 100%;
        box-sizing: border-box;
        clear: both;
    }

    .footer-content {
        font-family: 'Inter', sans-serif;
    }

    /* Ensure footer is properly aligned and doesn't get pushed to the right */
    footer {
        width: 100% !important;
        max-width: 100% !important;
        margin-left: 0 !important;
        box-sizing: border-box;
        overflow-x: hidden;
    }
</style>

<div class="footer-container">
    <!-- Footer content -->
    <footer class="bg-white text-gray-900 rounded-t-lg shadow-lg">
        <!-- Main footer content area, adjusted padding -->
        <div class="mx-auto px-4 py-6 md:px-6">
            <!-- Increased gap-y for vertical spacing on small screens and gap-x for horizontal spacing on larger screens -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-y-8 md:gap-y-0 md:gap-x-6 mb-4">
                <!-- About F-Skill -->
                <!-- Adjusted classes to center the content horizontally -->
                <div class="lg:col-span-1 flex flex-col items-center text-center">
                    <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="flex items-center space-x-2">
                        <!-- Placeholder image in case the logo path is not found -->
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-Skill Logo" class="w-auto h-12"
                             onerror="this.onerror=null; this.src='https://placehold.co/100x48/CCCCCC/333333?text=F-Skill';" />
                        <span class="text-lg font-bold text-gray-900"></span>
                    </a>
                    <!-- Adjusted text size for description -->
                    <p class="text-gray-700 text-sm mt-1">An online learning platform,<br>helping you access knowledge<br>anytime, anywhere.</p>
                </div>
                <!-- Quick Links -->
                <div>
                    <!-- Adjusted heading size -->
                    <h4 class="font-bold text-gray-900 text-base mb-2">Quick Links</h4>
                    <!-- Adjusted text size and space-y -->
                    <ul class="space-y-1.5 text-sm">
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/AllCourses" class="hover:text-primary transition-colors duration-200">All Courses</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors duration-200">Privacy Policy</a></li>
                    </ul>
                </div>
                <!-- Contact Info -->
                <div>
                    <!-- Adjusted heading size -->
                    <h4 class="font-bold text-gray-900 text-base mb-2">Contact</h4>
                    <!-- Adjusted text size and space-y -->
                    <ul class="space-y-1.5 text-sm">
                        <li class="flex items-start space-x-2">
                            <i class="fa-solid fa-phone mt-0.5 text-primary"></i>
                            <span>+62?8XXX?XXX?XX</span>
                        </li>
                        <li class="flex items-start space-x-2">
                            <i class="fa-solid fa-envelope mt-0.5 text-primary"></i>
                            <span>demo@gmail.com</span>
                        </li>
                        <li class="flex items-start space-x-2">
                            <i class="fa-solid fa-map-marker-alt mt-0.5 text-primary"></i>
                            <span>Khu II, ?. 3/2, Xuan Khanh, Ninh Kieu, Can Tho</span>
                        </li>
                    </ul>
                </div>
                <!-- Follow Us -->
                <div>
                    <!-- Adjusted heading size -->
                    <h4 class="font-bold text-gray-900 text-base mb-2">Follow Us</h4>
                    <!-- Adjusted icon size and spacing -->
                    <div class="flex space-x-2">
                        <a href="#"
                           class="h-8 w-8 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-sm">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#"
                           class="h-8 w-8 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-sm">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#"
                           class="h-8 w-8 bg-gray-200 hover:bg-primary rounded-full flex items-center justify-center transition-colors duration-200 text-gray-700 hover:text-white text-sm">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Copyright section, adjusted padding -->
            <div class="border-t border-gray-200 pt-4 text-center text-gray-600 text-sm">
                <p>&copy; 2025 F-Skills. All rights reserved. | From Group 3 With <i class="bi bi-heart-fill text-danger text-xs"></i></p>
            </div>
        </div>
    </footer>
</div>
