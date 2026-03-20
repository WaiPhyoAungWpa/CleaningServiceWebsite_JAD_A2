<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Log In</title>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet">
</head>
<body style="background-color: #b3d7f1;">
  <%@ include file="header.jsp"%>
  <%
  String errCode = request.getParameter("errCode");
  String errMsg = null;
  String userEmail = null;
  if (errCode != null) {
  	userEmail = (String) session.getAttribute("emailInput");
  	if (errCode.equals("invalidPassword")) {
  		errMsg = "Wrong Password! Please Try Again!";
  	} else if (errCode.equals("userNotFound")) {
  		errMsg = "User Not Found! Please Try Again!";
  	} else if (errCode.equals("invalidLogin")) {
  		errMsg = "Login Failed! Please Try Again!";
  	}
  }
  String userExists = request.getParameter("userExists");
  if (userExists != null && userExists.equals("true")) {
  	userEmail = (String) session.getAttribute("existingUser");
  }
  %>

  <div class="container mt-5 d-flex justify-content-center">
    <div class="card" style="width: 100%; max-width: 400px;">
      <div class="card-header text-center">
        <h4>Login</h4>
      </div>
      <div class="card-body">
        <form action="verifyMember.jsp" method="post">
          <!-- Email -->
          <div class="mb-3">
            <label for="email" class="form-label">Email</label> <input
              type="email" class="form-control" id="email" name="email"
              placeholder="Enter your email"
              <%if (userEmail != null) {%> value="<%=userEmail%>" <%}%>
              required>
          </div>

          <!-- Password -->
          <div class="mb-3">
            <label for="password" class="form-label">Password</label> <input
              type="password" class="form-control" id="password"
              name="password" placeholder="Enter your password" required>
          </div>

          <div class="<%if (errMsg == null) {%>d-none<%}%> mb-3">
            <p class="text-danger"><%=errMsg%></p>
          </div>

          <!-- Submit Button -->
          <div class="text-center">
            <button type="submit" class="btn btn-primary">Login</button>
          </div>
        </form>
      </div>
      <div class="card-footer text-center">
        <a href="registrationPage.jsp">Don't have an account? Sign
          up</a>
      </div>
    </div>
  </div>
  <script
    src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
    crossorigin="anonymous"></script>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
    integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    crossorigin="anonymous"></script>
</body>
</html>