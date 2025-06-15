# 📚 Online Course Platform - FSkills

A modern web-based application that enables users to access and manage online courses. The system allows students to learn and track progress, while instructors can create and deliver course content with ease.

---

## 🔍 Overview

This project provides a foundational platform for online education with the following capabilities:

* Course browsing and enrollment
* Secure login system (with email/password and Google OAuth)
* CAPTCHA verification using Cloudflare Turnstile
* Role-based user access (student/instructor/admin)
* Session management with optional "remember me" functionality

---

## 🚀 Features

### 👩‍🎓 Student Functionality

* Register, login, and enroll in courses
* View video lectures and download course materials
* Take quizzes and view scores
* Track course progress
* Earn completion certificates (optional)

### 👨‍🏫 Instructor Functionality

* Create and manage courses
* Upload videos, documents, and quizzes
* View student engagement
* Edit or remove course content

### 🔒 Security

* Password hashing (MD5 or stronger recommended)
* Google login integration
* CAPTCHA validation with Cloudflare
* Token-based login with secure HTTP-only cookies

---

## 🛠️ Technologies Used

* **Language:** Java (JDK 8)
* **Web Framework:** JSP & Servlets
* **Build Tool:** Maven
* **Database:** MySQL
* **JSON Processing:** Gson
* **Authentication:** Google OAuth2
* **Anti-bot:** Cloudflare Turnstile

---

## 📁 Project Structure

```
src/
├── controller/        // Servlets for handling web logic
├── dao/               // Data access layer (e.g., UserDAO, CourseDAO)
├── model/             // Entity classes (User, Course, etc.)
├── view/              // JSP files
└── util/              // Utilities and configuration
```

---

## ⚙️ Setup Instructions

1. Clone the project
2. Import the database schema from the provided SQL script
3. Set environment variables:

   * `CLOUDFLARE_SECRET_KEY`
   * `GOOGLE_CLIENT_ID`
   * `GOOGLE_CLIENT_SECRET`
4. Build the project with:

   ```bash
   mvn clean install
   ```
5. Deploy to Apache Tomcat or another Java EE-compatible servlet container

---

## ✅ Future Enhancements

* Instructor dashboard with analytics
* Student messaging system
* Course ratings and reviews
* Payment system for paid courses
* Responsive UI for mobile devices

---

## 👨‍💻 Author

Developed 1: **Ngo Phuoc Thinh**
Contact: ThinhNPCE170008@fpt.edu.vn

Developed 2: **Hong Tuan Nguyen**
Contact: NguyenHTCE181325@fpt.edu.vn

Developed 3: **Hua Khanh Duy**
Contact: DuyHKCE180230@fpt.edu.vn

Developed 4: **Nguyen Ngoc Khoi**
Contact: khoinn.ce190686@gmail.com

Developed 5: **Phuong Gia Lac**
Contact: lacpg.ce191059@gmail.com

Developed 6: **Nguyen Thanh Huy**
Contact: HuyNTCE182349@fpt.edu.vn

---

## 📄 License

This project is licensed under the MIT License.
