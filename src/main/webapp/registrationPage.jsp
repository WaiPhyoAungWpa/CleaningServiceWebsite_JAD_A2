<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign Up</title>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet">
</head>
<body style="background-color: #b3d7f1;">
  <script>
			
		<%String errCode = request.getParameter("errCode");
if (errCode != null) {
	if (errCode.equals("invalidInput")) {%>
			alert("There was an error when Registering. Please Try Again.");
		<%
}
}
%>
			function validateForm() {
				// Get form elements
				const firstName = document.getElementById("firstName").value
						.trim();
				const lastName = document.getElementById("lastName").value
						.trim();
				const phone = document.getElementById("phone").value.trim();
				const email = document.getElementById("email").value.trim();
				const password = document.getElementById("password").value
						.trim();
				const confirmPassword = document
						.getElementById("confirmPassword").value.trim();

				// Regex patterns
				const namePattern = /^[A-Za-z]{2,}$/; // Only letters, at least 2 characters
				const phonePattern = /^[0-9]*$/;
				const emailPattern = /^[^@\s]+@[^@\s]+\.[^@\s]+$/; // Valid email format

				// Validate first name
				if (!namePattern.test(firstName)) {
					alert("First name must contain only letters and be at least 2 characters long.");
					return false;
				}

				// Validate last name
				if (!namePattern.test(lastName)) {
					alert("Last name must contain only letters and be at least 2 characters long.");
					return false;
				}

				// Validate phone number
				if (!phonePattern.test(phone)) {
					alert("Phone number must contain only digits.");
					return false;
				}

				// Validate email
				if (!emailPattern.test(email)) {
					alert("Please enter a valid email address.");
					return false;
				}

				// Validate password confirmation
				if (password !== confirmPassword) {
					alert("Passwords do not match. Please confirm your password.");
					return false;
				}

				return true;
			}
		</script>
  <div
    class="container d-flex justify-content-center align-items-center py-5">
    <!-- Registration Card -->
    <div class="card w-50">
      <div class="card-header text-center">
        <h2 class="card-title text-center">Registration Form</h2>
      </div>
      <div class="card-body">
        <form action="submitRegistration.jsp" method="post"
          onsubmit="return validateForm()">
          <!-- First Name and Last Name in the same row -->
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="firstName" class="form-label">First
                Name</label> <input type="text" class="form-control"
                id="firstName" name="firstName" placeholder="First Name" required>
            </div>
            <div class="col-md-6">
              <label for="lastName" class="form-label">Last Name</label>
              <input type="text" class="form-control" id="lastName"
                name="lastName" placeholder="Last Name"  required>
            </div>
          </div>

          <!-- Gender, DOB and Phone Number in the same row -->
          <div class="row mb-3">
            <div class="col-md-3">
              <label for="gender" class="form-label">Gender</label> <select
                id="gender" name="gender" class="form-select">
                <option value="" selected disabled></option>
                <option value="M">Male</option>
                <option value="F">Female</option>
              </select>
            </div>

            <div class="col-md-3">
              <label for="dob" class="form-label">Date of Birth</label>
              <input type="date" class="form-control" id="dob"
                name="dob" value="">
            </div>

            <div class="col-md-6">
              <label for="phone" class="form-label">Phone Number</label>
              <input type="text" class="form-control" id="phone"
                name="phone" placeholder="Phone Number" >
            </div>
          </div>

          <!-- Email -->
          <div class="mb-3">
            <label for="email" class="form-label">Email</label> <input
              type="email" class="form-control" id="email" name="email" placeholder="Enter your email" 
              required>
          </div>

          <!-- Password -->
          <div class="mb-3">
            <label for="password" class="form-label">Password</label> <input
              type="password" class="form-control" id="password"
              name="password" placeholder="Enter password"  required>
          </div>

          <!-- Confirm Password -->
          <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm
              Password</label> <input type="password" class="form-control"
              id="confirmPassword" name="confirmPassword"  placeholder="Confirm Password" required>
          </div>

          <!-- Submit Button -->
          <div class="text-center">
            <button type="submit" class="btn btn-primary">Register</button>
          </div>
        </form>
      </div>
      <div class="card-footer text-center">
        <a href="loginPage.jsp">Already have an account? Log in</a>
      </div>
    </div>
  </div>
  <!-- Bootstrap JS, Popper.js, and jQuery (required for some Bootstrap components) -->
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