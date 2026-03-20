<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="memberModel.*"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Profile</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body style="background-color: #b3d7f1;">
	<%
	request.setAttribute("page", "memberPage");
	%>
	<%@ include file="header.jsp"%>
	<%
	if (memId == null) {
		response.sendRedirect("home.jsp");
		return;
	}

	int customerId = (int) memId;

	try {
		Member user = (Member) request.getAttribute("user");
		List<Booking> bookingHistory = (List<Booking>) request.getAttribute("bookingHistory");
		String errCode = request.getParameter("errCode");
		String errMsg = null;

		if (user == null) {
			errMsg = "User not found error";
		}

		if (errCode != null) {
			switch (errCode) {
		case "invalidPassword" :
			errMsg = "Wrong Password! Please Try Again!";
			break;
		case "userNotFound" :
			errMsg = "User Not Found! Please Try Again!";
			break;
		case "serverError" :
			errMsg = "Unknown error occurred. Please Try Again!";
			break;
		default :
			errMsg = "Unknown error occurred.";
			}
		}
	%>
	<!-- Error Message Modal -->
	<div class="modal fade" id="errorModal" tabindex="-1"
		aria-labelledby="errorModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header bg-danger text-white">
					<h5 class="modal-title" id="errorModalLabel">Error</h5>
					<a href="memberPage.jsp">
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</a>
				</div>
				<div class="modal-body">
					<!-- Error message will be injected here -->
					<p id="errMsg"><%=errMsg != null ? errMsg : ""%></p>
				</div>
				<div class="modal-footer">
					<a href="memberPage.jsp">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
					</a>
				</div>
			</div>
		</div>
	</div>
	<%
	if (errMsg != null) {
	%>
	<script>
  const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
  errorModal.show();
</script>
	<%
	}
	%>

	<div class="container my-5">
		<!-- User Account Card -->
		<div class="card mx-auto mb-4" style="max-width: 1000px;">
			<div class="card-header">
				<h4>User Account</h4>
			</div>
			<div class="card-body">
				<div class="row mb-3"></div>
				<form id="userAccountForm">
					<!-- Name -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Name:</strong></label>
						<div class="col-sm-8">
							<div class="input-group">
								<input type="text" class="form-control" id="name"
									value="<%=user.getName()%>" disabled>
								<button type="button" class="btn btn-outline-secondary"
									data-bs-toggle="modal" data-bs-target="#nameModal">
									<i class="bi bi-pencil"></i>
								</button>
							</div>
						</div>
					</div>

					<!-- Customer ID -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Customer
								ID:</strong></label>
						<div class="col-sm-8">
							<div class="input-group">
								<input type="text" class="form-control" id="customerId"
									value="<%=user.getId()%>" disabled readonly>
							</div>
						</div>
					</div>

					<!-- Email -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Email:</strong></label>
						<div class="col-sm-8">
							<div class="input-group">
								<input type="email" class="form-control" id="email"
									value="<%=user.getEmail()%>" disabled>
								<button type="button" class="btn btn-outline-secondary"
									data-bs-toggle="modal" data-bs-target="#emailModal">
									<i class="bi bi-pencil"></i>
								</button>
							</div>
						</div>
					</div>

					<!-- Password -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Password:</strong></label>
						<div class="col-sm-8">
							<div class="input-group">
								<input type="password" class="form-control" id="password"
									value="<%=user.getPassword()%>" disabled>
								<button type="button" class="btn btn-outline-secondary"
									id="changePasswordBtn" data-bs-toggle="modal"
									data-bs-target="#pwdModal">
									<i class="bi bi-pencil"></i>
								</button>
							</div>
						</div>
					</div>
				</form>

			</div>
		</div>

		<!-- Personal Info Card -->
		<div class="card mx-auto mb-4" style="max-width: 1000px;">
			<div
				class="card-header d-flex justify-content-between align-items-center">
				<h4>Personal Info</h4>
				<button id="editBtn" class="btn btn-link-secondary">
					<i class="bi bi-pencil-square"></i>
				</button>
			</div>
			<form action="changeInfo.jsp" method="post" id="personalInfoForm"
				onsubmit="return validatePhNo()">
				<div class="card-body">

					<!-- Phone Number -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Phone
								Number:</strong></label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="phone" id="phone"
								value="<%=(user.getPhNo() == null) ? "" : user.getPhNo()%>"
								disabled>
						</div>
					</div>

					<!-- Gender -->
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Gender:</strong></label>
						<div class="col-sm-8">
							<select class="custom-select form-control" name="gender"
								id="gender" disabled>
								<option value=""
									<%=(user.getGender() == null || user.getGender().isEmpty()) ? "selected" : ""%>></option>
								<option value="M"
									<%=(user.getGender() != null && user.getGender().equals("M")) ? "selected" : ""%>>Male</option>
								<option value="F"
									<%=(user.getGender() != null && user.getGender().equals("F")) ? "selected" : ""%>>Female</option>
							</select>
						</div>
					</div>

					<!-- Date of Birth -->
					<%
					java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
					String formattedDate = (user.getDOB() != null) ? dateFormat.format(user.getDOB()) : "";
					%>
					<div class="row mb-3">
						<label class="col-sm-4 col-form-label"><strong>Date
								of Birth:</strong></label>
						<div class="col-sm-8">
							<input type="date" class="form-control" name="dob" id="dob"
								value="<%=formattedDate%>" disabled>
						</div>
					</div>

				</div>
				<div class="card-footer text-center" id="cardFooter"
					style="display: none;">
					<button type="submit" class="btn btn-success">Save Changes</button>
					<button type="button" class="btn btn-secondary" id="cancelBtn">Cancel</button>
				</div>
			</form>
		</div>

		<!-- Address Card -->
		<div class="card mx-auto mb-4" style="max-width: 1000px;">
			<div
				class="card-header d-flex justify-content-between align-items-center">
				<h4>Addresses</h4>
				<button class="btn btn-success" data-bs-toggle="modal"
					data-bs-target="#addressModal">Add Address</button>
			</div>
			<div class="container card-body">
				<div id="addressList" class="row">Loading address...</div>
				<!-- Addresses will be dynamically inserted here -->
			</div>
		</div>

		<!-- Address Modal -->
		<div class="modal fade" id="addressModal" tabindex="-1"
			aria-labelledby="addressModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="addressModalLabel">Add / Update
							Address</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<form id="addressForm">
							<input type="hidden" id="addressIdForUpdate">
							<!-- Hidden field for addressId -->
							<div class="mb-3">
								<label for="addressName" class="form-label">Address Name</label>
								<input type="text" class="form-control" id="addressName"
									required>
							</div>
							<div class="mb-3">
								<label for="fullAddress" class="form-label">Full Address</label>
								<input type="text" class="form-control" id="fullAddress"
									required>
							</div>
							<div class="mb-3">
								<label for="postalCode" class="form-label">Postal Code</label> <input
									type="text" class="form-control" id="postalCode" required>
							</div>
							<button type="submit" class="btn btn-success">Save
								Address</button>
						</form>
					</div>
				</div>
			</div>
		</div>

		<!-- Booking History -->
		<div class="card mx-auto mb-4" style="max-width: 1000px;">
			<div class="card-header">
				<h4 class="card-title">Booking History</h4>
			</div>
			<div class="card-body d-flex flex-column justify-content-center">
				<div class="table-responsive">
					<table class="table table-hover">
						<thead class="table-primary">
							<tr>
								<th>#</th>
								<th>Service</th>
								<th>Date</th>
								<th>Booking Status</th>
								<th>Cost($)</th>
								<th>Payment Status</th>
								<th>Book Again</th>
								<th>Feedback</th>
							</tr>
						</thead>
						<tbody id="bookingTable">
							<%
							if (bookingHistory.size() != 0) {
								for (int i = 0; i < bookingHistory.size(); i++) {
									Booking booking = bookingHistory.get(i);
									if (i < 3) { // Initially show only 3 rows
							%>
							<tr class="booking-row">
								<td><%=i + 1%></td>
								<td><%=booking.getServiceName()%></td>
								<td><%=booking.getBookingTime()%></td>
								<td><%=booking.getBookingStatus()%></td>
								<td><%=booking.getCost()%></td>
								<td><%=booking.getPaymentStatus()%></td>
								<!-- To be done next time -->
								<td><a class="btn btn-outline-secondary"
									href="<%=(memId == null) ? "loginPage.jsp" : "booking_page.jsp?serviceId=" + booking.getServiceId()%>">
										<i class="bi bi-calendar-plus"></i>
								</a></td>
								<td>
									<%
									if ("Completed".equals(booking.getBookingStatus())) {
									%> <a class="btn btn-outline-secondary"
									href="<%=(memId == null) ? "loginPage.jsp" : "createFeedback.jsp?bookingId=" + booking.getBookingId()%>">
										<i class="bi bi-chat-right-quote"></i>
								</a> <%
 }
 %>
								</td>
							</tr>
							<%
							} else {
							%>
							<tr class="booking-row d-none">
								<!-- Hidden rows by default -->
								<td><%=i + 1%></td>
								<td><%=booking.getServiceName()%></td>
								<td><%=booking.getBookingTime()%></td>
								<td><%=booking.getBookingStatus()%></td>
								<td><%=booking.getCost()%></td>
								<td><%=booking.getPaymentStatus()%></td>
								<td><a class="btn btn-outline-secondary"
									href="<%=(memId == null) ? "loginPage.jsp" : "booking_page.jsp?serviceId=" + booking.getServiceId()%>">
										<i class="bi bi-calendar-plus"></i>
								</a></td>
								<td>
									<%
									if ("Completed".equals(booking.getBookingStatus())) {
									%> <a class="btn btn-outline-secondary"
									href="<%=(memId == null) ? "loginPage.jsp" : "createFeedback.jsp?bookingId=" + booking.getBookingId()%>">
										<i class="bi bi-chat-right-quote"></i>
								</a> <%
 }
 %>
								</td>
							</tr>
							<%
							}
							}
							} else {
							%>
							<tr>
								<td colspan="6" class="text-center">No bookings found.</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
				<%
				if (bookingHistory.size() > 3) { // Show toggle button if more than 3 bookings
				%>
				<button class="btn btn-link" id="toggleButton">See More</button>
				<%
				}
				%>
			</div>
		</div>

		<!-- Delete Card -->
		<div class="card mx-auto mb-4" style="max-width: 1000px;">
			<div class="card-header">
				<h4 class="card-title">Delete Account</h4>
			</div>
			<div class="card-body">
				<p class="card-text">Deleting your account is a permanent action
					and cannot be undone. All your data will be lost.</p>
				<button class="btn btn-danger" data-bs-toggle="modal"
					data-bs-target="#deleteAccountModal">Delete My Account</button>
			</div>
		</div>

	</div>

	<!-- Modals for Edits -->
	<!-- Name Modal-->
	<div class="modal fade" id="nameModal" tabindex="-1" role="dialog"
		aria-labelledby="nameModal" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="emailModalLabel">Change Name</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form action="changeName.jsp" method="post" id="updateNameForm">
						<!-- New Email -->
						<div class="row mb-3">
							<div class="col-md-6">
								<label for="firstName" class="form-label">First Name</label> <input
									type="text" class="form-control" id="firstName"
									name="firstName" placeholder="First Name" required>
							</div>
							<div class="col-md-6">
								<label for="lastName" class="form-label">Last Name</label> <input
									type="text" class="form-control" id="lastName" name="lastName"
									placeholder="Last Name" required>
							</div>
						</div>

						<!-- Confirm Password -->
						<div class="mb-3">
							<label for="confirmPasswordName" class="form-label"><strong>Password:</strong></label>
							<input type="password" class="form-control"
								id="confirmPasswordName" name="confirmPasswordName"
								placeholder="Password to confirm changes" required>
						</div>
						<div class="mb-3">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-primary" id="saveChangesBtn">Confirm</button>
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>

	<!-- Email Modal-->
	<div class="modal fade" id="emailModal" tabindex="-1" role="dialog"
		aria-labelledby="emailModal" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="emailModalLabel">Change Email</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form action="changeEmail.jsp" method="post" id="updateForm"
						onsubmit="return validateEmail()">
						<!-- New Email -->
						<div class="mb-3">
							<label for="newEmail" class="form-label"><strong>New
									Email:</strong></label> <input type="email" class="form-control" id="newEmail"
								name="newEmail" placeholder="Enter new email" required>
						</div>

						<!-- Confirm Password -->
						<div class="mb-3">
							<label for="confirmPasswordEmail" class="form-label"><strong>Password:</strong></label>
							<input type="password" class="form-control"
								id="confirmPasswordEmail" name="confirmPasswordEmail"
								placeholder="Password to confirm changes" required>
						</div>
						<div class="mb-3">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-primary" id="saveChangesBtn">Confirm</button>
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>

	<!-- Password Modal -->
	<div class="modal fade" id="pwdModal" tabindex="-1" role="dialog"
		aria-labelledby="pwdModal" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="pwdModalLabel">Change Password</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form action="changePassword.jsp" method="post" id="updatePwdForm"
						onsubmit="return validatePwd()">
						<!-- New Email -->
						<div class="mb-3">
							<label for="currentPassword" class="form-label"><strong>Password:</strong></label>
							<input type="password" class="form-control" id="currentPassword"
								name="currentPassword" placeholder="Enter Current Password"
								required>
						</div>

						<!-- New Password -->

						<div class="input-group mb-3">
							<input type="password" class="form-control" id="newPassword"
								name="newPassword" placeholder="Enter New password" required>
							<button type="button" class="btn btn-outline-secondary"
								id="toggleNewPassword">
								<i class="bi bi-eye"></i>
								<!-- Use an icon for better UX -->
							</button>
						</div>

						<!-- Confirm Password -->
						<div class="input-group mb-3">
							<input type="password" class="form-control" id="confirmPassword"
								name="confirmPassword" placeholder="Enter your password"
								required>
							<button type="button" class="btn btn-outline-secondary"
								id="toggleConfirmPassword">
								<i class="bi bi-eye"></i>
								<!-- Use an icon for better UX -->
							</button>
						</div>
						<div class="mb-3">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-primary" id="saveChangesBtn">Confirm</button>
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>

	<!-- Modal for Delete Confirmation -->
	<div class="modal fade" id="deleteAccountModal" tabindex="-1"
		aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title text-danger" id="deleteAccountModalLabel">Confirm
						Account Deletion</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="deleteAccount.jsp" method="post">
					<div class="modal-body">
						Are you sure you want to delete your account? This action cannot
						be undone.
						<div class="mb-3">
							<label for="confirmPasswordDelete" class="form-label"><strong>
									Password:</strong></label> <input type="password" class="form-control"
								id="confirmPasswordDelete" name="confirmPasswordDelete"
								placeholder="Enter your Password to confirm this action"
								required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-danger">Yes, Delete
							My Account</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<%
	} catch (NullPointerException e) {
	out.print(e);
	//response.sendRedirect("loginPage.jsp");
	}
	%>
	<script>
  const formInputs = document.querySelectorAll('#personalInfoForm input');
  const formSelects = document.querySelectorAll('#personalInfoForm select');
  const editBtn = document.getElementById('editBtn');
  const cancelBtn = document.getElementById('cancelBtn');
  const cardFooter = document.getElementById('cardFooter');

  // Enable only personal info inputs for editing
  editBtn.addEventListener('click', () => {
    formInputs.forEach(input => input.disabled = false);
    formSelects.forEach(select => select.disabled = false);
    cardFooter.style.display = 'block';
    editBtn.style.display = 'none';
  });

  // Disable all inputs and hide save/cancel buttons
  cancelBtn.addEventListener('click', () => {
    formInputs.forEach(input => input.disabled = true);
    formSelects.forEach(select => select.disabled = true);
    cardFooter.style.display = 'none';
    editBtn.style.display = 'block';
  });
  
  document.getElementById('toggleNewPassword').addEventListener('click', function () {
	  const passwordField = document.getElementById('newPassword');
	  const passwordFieldType = passwordField.getAttribute('type');
	  
	  // Toggle between 'password' and 'text' field types
	  if (passwordFieldType === 'password') {
	    passwordField.setAttribute('type', 'text');
	    this.innerHTML = '<i class="bi bi-eye-slash"></i>'; // Change icon to 'eye-slash'
	  } else {
	    passwordField.setAttribute('type', 'password');
	    this.innerHTML = '<i class="bi bi-eye"></i>'; // Change icon back to 'eye'
	  }
	});
  
  document.getElementById('toggleConfirmPassword').addEventListener('click', function () {
	  const passwordField = document.getElementById('confirmPassword');
	  const passwordFieldType = passwordField.getAttribute('type');
	  
	  // Toggle between 'password' and 'text' field types
	  if (passwordFieldType === 'password') {
	    passwordField.setAttribute('type', 'text');
	    this.innerHTML = '<i class="bi bi-eye-slash"></i>'; // Change icon to 'eye-slash'
	  } else {
	    passwordField.setAttribute('type', 'password');
	    this.innerHTML = '<i class="bi bi-eye"></i>'; // Change icon back to 'eye'
	  }
	});

  // JavaScript to toggle rows visibility for Booking History
const toggleButton = document.getElementById('toggleButton');
const bookingRows = document.querySelectorAll('.booking-row');

if (toggleButton) {
  toggleButton.addEventListener('click', () => {
    // Check current state of the button text
    const isExpanded = toggleButton.textContent.trim() === 'See More';

    // Update visibility for rows beyond the first 3
    bookingRows.forEach((row, index) => {
      if (index >= 3) {
        row.classList.toggle('d-none', !isExpanded); // Show rows if "See More", hide if "See Less"
      }
    });

    // Update button text
    toggleButton.textContent = isExpanded ? 'See Less' : 'See More';
  });
}

  
function validatePwd(){
	const password = document.getElementById("newPassword").value.trim();
	const confirmPassword = document.getElementById("confirmPassword").value.trim();
	
	if (password !== confirmPassword) {
		alert("Passwords do not match. Please confirm your password.");
		return false;
	}

	return true;
}

function validateEmamil(){
	const email = document.getElementById("email").value.trim();
	const emailPattern = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
	
	if (!emailPattern.test(email)) {
		alert("Please enter a valid email address.");
		return false;
	}
	return true;
} 

function validatePhNo(){
	const phone = document.getElementById("phone").value.trim();
	const phonePattern = /^[0-9]*$/;
	
	if (!phonePattern.test(phone)) {
		alert("Phone number must contain only digits.");
		return false;
	}
	return true;
} 

document.addEventListener("DOMContentLoaded", function () {
    var customerId = "<%=customerId%>";
    var urlString = "https://shinshin-cleaning-service.azurewebsites.net/getAllAddress/" + customerId;

    fetch(urlString)
        .then(response => response.json())
        .then(data => {
            const addressList = document.getElementById("addressList");
            addressList.innerText = "";  // Clear existing content
            
            if (data.length === 0) {
                addressList.innerText = "No address found"; // Display message if no data
                return;
            }

            data.forEach((address) => {
                const displayItem = document.createElement("div");
                displayItem.className = "p-3";
                displayItem.innerHTML =
                    '<div class="card">' +
                    '<div class="card-body">' +
                    '<h5 class="card-title">' + address.address_name + '</h5>' +
                    '<p class="card-text">' +
                    'Address: ' + address.address + '<br>' +
                    'Postal Code: ' + address.postal_code + '<br>' +
                    '</p>' +
                    // Add update and delete buttons
                    '<button class="btn btn-primary" onclick="openUpdateForm(' + address.address_id + ')">Update</button>' +
                    '<button class="btn btn-danger" onclick="confirmDelete(' + address.address_id + ')">Delete</button>' +
                    '</div>' +
                    '</div>';

                addressList.appendChild(displayItem);
            });
        })
        .catch(error => {
            console.error("Error fetching address:", error);
            document.getElementById("addressBlock").innerText = "Failed to load address";
        });
});

// Function to open the update form and populate it with existing address data
function openUpdateForm(addressId) {
    // Fetch the address details for the given addressId
    fetch("https://shinshin-cleaning-service.azurewebsites.net/getAddressByID/" + addressId)
        .then(response => response.json())
        .then(address => {
            // Fill the form with current address data
            document.getElementById("addressName").value = address[0].address_name;
            document.getElementById("fullAddress").value = address[0].address;
            document.getElementById("postalCode").value = address[0].postal_code;
            document.getElementById("addressIdForUpdate").value = address[0].address_id;

            // Show the modal for updating address
            let modal = new bootstrap.Modal(document.getElementById("addressModal"));
            modal.show();
        })
        .catch(error => {
            console.error("Error fetching address data for update:", error);
        });
}

// Function to confirm the deletion and proceed if confirmed
function confirmDelete(addressId) {
    // Show confirmation modal (this can be a Bootstrap modal)
    const confirmation = confirm("Are you sure you want to delete this address?");
    if (confirmation) {
        // Proceed with the delete API call
        deleteAddress(addressId);
    }
}

// Function to delete an address
function deleteAddress(addressId) {
	var customerId = "<%=customerId%>";
	 // Prepare data object
	let deleteIDs = {
	   customer_id: customerId,
	   address_id: addressId
	 };
    fetch("https://shinshin-cleaning-service.azurewebsites.net/deleteAddress", {
        method: "DELETE", //need body
        headers: {
  	      "Content-Type": "application/json",
  	    },
  	    body: JSON.stringify(deleteIDs),
    })
    .then(response => response.text())
    .then(data => {
        console.log(data);
        location.reload();  // Reload the page to update the address list
    })
    .catch(error => {
        console.error("Error deleting address:", error);
    });
}

document.getElementById("addressForm").addEventListener("submit", function (event) {
	  var customerId = "<%=customerId%>";
	  event.preventDefault(); // Prevent default form submission

	  // Get form values
	  let addressName = document.getElementById("addressName").value;
	  let fullAddress = document.getElementById("fullAddress").value;
	  let postalCode = document.getElementById("postalCode").value;
	  let addressId = document.getElementById("addressIdForUpdate").value;

	  let addressData = {
		customer_id: customerId,
	    address_name: addressName,
	    address: fullAddress,
	    postal_code: postalCode,
	  };

	  let method = "POST";
	  let url = "https://shinshin-cleaning-service.azurewebsites.net/createAddress";  // Default Add URL

	  if (addressId) {
	    // Update request (PUT) if addressId exists
	    method = "PUT";  // Use PUT for update
	    url = "https://shinshin-cleaning-service.azurewebsites.net/updateAddress";

	    // Add the addressId to the data for update
	    addressData.address_id = addressId;  // Include the addressId for PUT request
	  }

	  // Send the data to the API with the appropriate method
	  fetch(url, {
	    method: method,
	    headers: {
	      "Content-Type": "application/json",
	    },
	    body: JSON.stringify(addressData),  // Send the appropriate data body
	  })
	    .then(response => response.text())
	    .then(data => {
	      console.log(data);

	      // Close modal
	      let modal = new bootstrap.Modal(document.getElementById("addressModal"));
	      modal.hide();

	      // Optionally, refresh address list
	      location.reload();
	    })
	    .catch(error => {
	      console.error("Error saving/updating address:", error);
	    });
	});

</script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
	<%@ include file="footer.html"%>
</body>
</html>