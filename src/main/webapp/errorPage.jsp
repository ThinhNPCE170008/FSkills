<%@ page isErrorPage="true" %>
<html>
<head>
    <title>Debug Error Page</title>
    <style>
        body { font-family: monospace; background: #fefefe; color: #333; padding: 2rem; }
        .error-box { border-left: 5px solid red; background: #fff0f0; padding: 1rem; margin-bottom: 2rem; }
        pre { background: #f4f4f4; padding: 1rem; overflow-x: auto; border-radius: 5px; }
    </style>
</head>
<body>
    <h2>Process: </h2>

    <div class="error-box">
        <strong>Error:</strong>
        <p>${errorMessage}</p>
    </div>

    <div>
        <strong>Error detail (Stack Trace):</strong>
        <pre>${stackTrace}</pre>
    </div>
</body>
</html>
