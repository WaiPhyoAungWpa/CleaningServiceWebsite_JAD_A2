<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="adminController.*"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Management</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css">
</head>
<body>
	<%
	request.setAttribute("page", "memberManagement");
	%>
	<%@ include file="header.jsp"%>
	<%
	if (adminId == null) {
		response.sendRedirect("loginPage.jsp");
	}
	%>

	<!-- Main Content -->
	<div class="container-fluid px-0">

		<!-- --------------------------------Members Section-------------------------------- -->
		<section id="members-section"
			style="padding: 50px 0; background-color: #ffffff;">
			<div class="container py-4">
				<h2
					style="font-weight: bold; text-align: center; margin-bottom: 20px;">Member
					Management</h2>

				<div class="d-flex justify-content-between mb-3">
					<button class="btn btn-primary"
						style="margin-bottom: 10px; border-radius: 12px;"
						data-bs-toggle="modal" data-bs-target="#createMemberModal">
						<i class="bi bi-plus-circle"></i>
					</button>
					<input type="text" id="searchBar" class="form-control"
						placeholder="Search by Name, Email, or Contact..."
						style="width: 300px;">
					<button type="button" class="btn btn-primary"
						style="margin-bottom: 10px; border-radius: 12px;"
						data-bs-toggle="modal" data-bs-target="#ListModalTabs">
						View Report</button>
				</div>

				<div style="overflow: hidden; border-radius: 12px;">
					<!-- Wrapper for rounded border -->
					<table class="table table-bordered" id="membersTable"
						style="border-radius: 12px; overflow: hidden;">
						<thead class="table-light">
							<tr>
								<th
									style="border-top-left-radius: 12px; background-color: #b3d7f1;">ID</th>
								<th style="background-color: #b3d7f1;">Name</th>
								<th style="background-color: #b3d7f1;">Email</th>
								<th style="background-color: #b3d7f1;">Gender</th>
								<th style="background-color: #b3d7f1;">DOB</th>
								<th style="background-color: #b3d7f1;">Contact</th>
								<th style="background-color: #b3d7f1;">View</th>
								<th style="background-color: #b3d7f1;">Edit</th>
								<th
									style="border-top-right-radius: 12px; background-color: #b3d7f1;">Delete</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="member" items="${members}">
								<tr>
									<td style="background-color: #e8f4fa;">${member.customerId}</td>
									<td style="background-color: #e8f4fa;">${member.firstName}
										${member.lastName}</td>
									<td style="background-color: #e8f4fa;">${member.email}</td>
									<td style="background-color: #e8f4fa;">${member.gender}</td>
									<td style="background-color: #e8f4fa;">${member.getDobString()}</td>
									<td style="background-color: #e8f4fa;">${member.phNumber}</td>
									<td style="background-color: #e8f4fa;">
										<button class="btn btn-info btn-sm"
											style="border-radius: 12px;"
											data-name="${member.firstName} ${member.lastName}"
											data-email="${member.email}" data-gender="${member.gender}"
											data-dob="${member.dob}" data-contact="${member.phNumber}"
											data-booking-details='${member.bookingDetails}'
											onclick="viewMemberDetails(this)" data-bs-toggle="modal"
											data-bs-target="#viewMemberModal">
											<i class="bi bi-eye"></i>
										</button>
									</td>
									<td style="background-color: #e8f4fa;">
										<button class="btn btn-warning btn-sm"
											style="border-radius: 12px;" data-id="${member.customerId}"
											data-firstname="${member.firstName}"
											data-lastname="${member.lastName}"
											data-email="${member.email}" data-gender="${member.gender}"
											data-dob="${member.dob}" data-contact="${member.phNumber}"
											onclick="editMemberDetails(this)" data-bs-toggle="modal"
											data-bs-target="#editMemberModal">
											<i class="bi bi-pencil"></i>
										</button>
									</td>
									<td style="background-color: #e8f4fa;">
										<button class="btn btn-danger btn-sm"
											style="border-radius: 12px;" data-id="${member.customerId}"
											data-name="${member.firstName} ${member.lastName}"
											onclick="openDeleteMemberModal(this)" data-bs-toggle="modal"
											data-bs-target="#deleteMemberModal">
											<i class="bi bi-trash"></i>
										</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</section>
		<!-- Create Member Modal -->
		<div class="modal fade" id="createMemberModal" tabindex="-1"
			aria-labelledby="createMemberModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #007BFF; color: white;">
						<h5 class="modal-title" id="createMemberModalLabel">Create
							New Member</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<form id="createMemberForm"
						action="<%=request.getContextPath()%>/CreateMemberServlet"
						method="post">
						<input type="hidden" name="action" value="createMember">
						<div class="modal-body">
							<!-- First Name -->
							<div class="mb-3">
								<label for="createMemberFirstName" class="form-label">First
									Name</label> <input type="text" class="form-control"
									id="createMemberFirstName" name="firstName" required>
							</div>
							<!-- Last Name -->
							<div class="mb-3">
								<label for="createMemberLastName" class="form-label">Last
									Name</label> <input type="text" class="form-control"
									id="createMemberLastName" name="lastName" required>
							</div>
							<!-- Email -->
							<div class="mb-3">
								<label for="createMemberEmail" class="form-label">Email</label>
								<input type="email" class="form-control" id="createMemberEmail"
									name="email" required>
							</div>
							<!-- Password -->
							<div class="mb-3">
								<label for="createMemberPassword" class="form-label">Password</label>
								<div class="input-group">
									<input type="password" class="form-control"
										id="createMemberPassword" name="password" required
										minlength="6">
									<button class="btn btn-outline-secondary" type="button"
										onclick="generatePassword()">Generate</button>
									<button class="btn btn-outline-secondary" type="button"
										onclick="togglePasswordVisibility('createMemberPassword')">
										<i class="bi bi-eye"></i>
									</button>
								</div>
							</div>
							<!-- Confirm Password -->
							<div class="mb-3">
								<label for="createMemberConfirmPassword" class="form-label">Confirm
									Password</label> <input type="password" class="form-control"
									id="createMemberConfirmPassword" name="confirmPassword"
									required>
							</div>
							<!-- Gender -->
							<div class="mb-3">
								<label class="form-label">Gender</label><br>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										id="createGenderMale" name="gender" value="M" required>
									<label class="form-check-label" for="createGenderMale">Male</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										id="createGenderFemale" name="gender" value="F" required>
									<label class="form-check-label" for="createGenderFemale">Female</label>
								</div>
							</div>
							<!-- DOB -->
							<div class="mb-3">
								<label for="createMemberDob" class="form-label">Date of
									Birth</label> <input type="date" class="form-control"
									id="createMemberDob" name="dob" required>
							</div>
							<!-- Contact -->
							<div class="mb-3">
								<label for="createMemberContact" class="form-label">Contact</label>
								<input type="text" class="form-control" id="createMemberContact"
									name="contact" required>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-primary">Create
								Member</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<script>
		// Function to generate a random password
	    function generatePassword() {
	        const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
	        let password = "";
	        for (let i = 0; i < 10; i++) {
	            password += chars.charAt(Math.floor(Math.random() * chars.length));
	        }
	        document.getElementById("createMemberPassword").value = password;
	        document.getElementById("createMemberConfirmPassword").value = password;
	    }

	    // Function to toggle password visibility
	    function togglePasswordVisibility(inputId) {
	        const passwordField = document.getElementById(inputId);
	        if (passwordField.type === "password") {
	            passwordField.type = "text";
	        } else {
	            passwordField.type = "password";
	        }
	    }

	    // Form validation
	    document.getElementById("createMemberForm").addEventListener("submit", function(event) {
	        const firstName = document.getElementById("createMemberFirstName").value.trim();
	        const lastName = document.getElementById("createMemberLastName").value.trim();
	        const email = document.getElementById("createMemberEmail").value.trim();
	        const password = document.getElementById("createMemberPassword").value.trim();
	        const confirmPassword = document.getElementById("createMemberConfirmPassword").value.trim();
	        const dob = document.getElementById("createMemberDob").value.trim();
	        const contact = document.getElementById("createMemberContact").value.trim();
	        const genderSelected = document.querySelector('input[name="gender"]:checked');

	        // Check if any field is empty
	        if (!firstName || !lastName || !email || !password || !confirmPassword || !dob || !contact || !genderSelected) {
	            event.preventDefault();
	            alert("Please fill out all fields before submitting.");
	            return;
	        }

	        // Check password length
	        if (password.length < 6) {
	            event.preventDefault();
	            alert("Password must be at least 6 characters long.");
	            return;
	        }

	        // Check if passwords match
	        if (password !== confirmPassword) {
	            event.preventDefault();
	            alert("Passwords do not match. Please re-enter.");
	            return;
	        }
	    });
	    </script>

		<!-- Listing Modal -->
		<div class="modal fade" id="ListModalTabs" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<!-- Modal Header -->
					<div class="modal-header">
						<h5 class="modal-title">List By:</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<!-- Modal Body with Tabs -->
					<div class="modal-body">
						<!-- Tab Navigation -->
						<ul class="nav nav-tabs" id="modalTabs" role="tablist">
							<li class="nav-item" role="presentation">
								<button class="nav-link active" id="general-tab"
									data-bs-toggle="tab" data-bs-target="#TopTenCustomerTab"
									type="button" role="tab" aria-controls="TopTenCustomerTab"
									aria-selected="true">Top 10 Customers</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="booking-tab" data-bs-toggle="tab"
									data-bs-target="#CustomerByServiceTab" type="button" role="tab"
									aria-controls="CustomerByServiceTab" aria-selected="false">Customers
									By Service</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="address-tab" data-bs-toggle="tab"
									data-bs-target="#CustomerByAddressTab" type="button" role="tab"
									aria-controls="CustomerByAddressTab" aria-selected="false">
									Customers By Addresses</button>
							</li>
						</ul>

						<!-- Tab Content -->
						<div class="tab-content p-3">
							<!-- Top Ten Customers Tab -->
							<div class="tab-pane fade show active" id="TopTenCustomerTab"
								role="tabpanel" aria-labelledby="general-tab">
								<div class="table-responsive mt-3">
									<table class="table table-bordered table-hover">
										<thead class="table-dark">
											<tr>
												<th>#</th>
												<th>ID</th>
												<th>Name</th>
												<th>Total Amount ($)</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="customer" items="${topcustomers}"
												varStatus="status">
												<tr>
													<td>${status.index + 1}</td>
													<td>${customer.customerId}</td>
													<td>${customer.firstName} ${customer.lastName}</td>
													<td>${customer.totalAmount}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>

							<!-- Customers By Service Tab -->
							<div class="tab-pane fade" id="CustomerByServiceTab"
								role="tabpanel" aria-labelledby="booking-tab">
								<!-- Service Filter Container -->
								<div class="card mb-4">
									<div class="card-body">
										<div class="row align-items-center">
											<div class="col-md-4">
												<label for="serviceFilter" class="form-label fw-semibold">
													Filter by Service </label> <select id="serviceFilter"
													class="form-select">
													<option value="">Select Services</option>
													<c:forEach items="${services}" var="service">
														<option value="${service.serviceId}">${service.serviceName}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									</div>
								</div>

								<!-- Customer Bookings Table -->
								<div class="table-responsive">
									<table class="table table-hover align-middle">
										<thead class="table-dark">
											<tr>
												<th scope="col" style="width: 15%">ID</th>
												<th scope="col" style="width: 60%">Customer Name</th>
												<th scope="col" style="width: 20%">Total Bookings</th>
											</tr>
										</thead>
										<tbody id="modalMemberBookingsByService">
											<c:forEach items="${customersbyservice}" var="customer"
												varStatus="status">
												<tr data-service-id="${customer.serviceId}">
													<td>${customer.customerId}</td>
													<td><span class="fw-medium">${customer.firstName}
															${customer.lastName}</span></td>
													<td class="text-center">${customer.totalBookings}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>

							<!-- Customers By Addresses Tab -->
							<div class="tab-pane fade" id="CustomerByAddressTab"
								role="tabpanel" aria-labelledby="address-tab">

								<!-- Search and Filter Controls -->
								<div class="row mb-3">
									<!-- Search Bar -->
									<div class="col-md-6">
										<input type="text" id="searchAddressBar" class="form-control"
											placeholder="Search by Address Name, Address, or Postal Code"
											style="width: 100%;">
									</div>

									<!-- Address Name Filter -->
									<div class="col-md-4">
										<select id="addressNameFilter" class="form-select">
											<option value="">Filter by Address Name</option>
											<option value="Home">Home</option>
											<option value="Office">Office</option>
											<option value="Others">Others</option>
										</select>
									</div>

									<!-- Record Count Display -->
									<div class="col-md-2 text-end">
										<span id="recordCount" class="fw-bold">Records: 0</span>
									</div>
								</div>
								
								<div class="table-responsive mt-3">
									<table class="table table-bordered table-hover"
										id="addressTable">
										<thead class="table-dark">
											<tr>
												<th>Address ID</th>
												<th>Customer ID</th>
												<th>Customer Name</th>
												<th>Address Name</th>
												<th>Address</th>
												<th>Postal Code</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${customersbyaddress}" var="address">
												<tr>
													<td>${address.addressId}</td>
													<td>${address.customerId}</td>
													<td>${address.customerName}</td>
													<td>${address.addressName}</td>
													<td>${address.address}</td>
													<td>${address.postalCode}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
						</div>

						<!-- Modal Footer -->
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- View Member Modal -->
		<div class="modal fade" id="viewMemberModal" tabindex="-1"
			aria-labelledby="viewMemberModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #17A2B8; color: white;">
						<h5 class="modal-title" id="viewMemberModalLabel">Member
							Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<!-- Default profile image -->
						<div class="text-center mb-4">
							<img src="profile.jpeg" alt="Profile Image"
								class="img-fluid rounded-circle"
								style="width: 150px; height: 150px; object-fit: cover;">
						</div>
						<p>
							<strong>Name:</strong> <span id="modalMemberName"></span>
						</p>
						<p>
							<strong>Email:</strong> <span id="modalMemberEmail"></span>
						</p>
						<p>
							<strong>Gender:</strong> <span id="modalMemberGender"></span>
						</p>
						<p>
							<strong>DOB:</strong> <span id="modalMemberDob"></span>
						</p>
						<p>
							<strong>Contact:</strong> <span id="modalMemberContact"></span>
						</p>
						<hr>
						<h5>Booking Details</h5>
						<!-- Filters Section -->
						<div class="row g-2 mb-4">
							<div class="col-md-3">
								<label for="filterByDate" class="form-label">Filter by
									Date:</label> <input type="date" id="filterByDate" class="form-control">
							</div>
							<div class="col-md-3">
								<label for="filterByPeriod" class="form-label">Filter by
									Period:</label> <select id="filterByPeriod" class="form-select">
									<option value="">Select Period</option>
									<option value="week">This Week</option>
									<option value="month">This Month</option>
									<option value="year">This Year</option>
								</select>
							</div>
							<div class="col-md-3">
								<label for="filterByMonth" class="form-label">Filter by
									Month:</label> <select id="filterByMonth" class="form-select">
									<option value="">Select Month</option>
									<option value="1">January</option>
									<option value="2">February</option>
									<option value="3">March</option>
									<option value="4">April</option>
									<option value="5">May</option>
									<option value="6">June</option>
									<option value="7">July</option>
									<option value="8">August</option>
									<option value="9">September</option>
									<option value="10">October</option>
									<option value="11">November</option>
									<option value="12">December</option>
								</select>
							</div>
							<div class="col-md-3">
								<label for="filterByYear" class="form-label">Filter by
									Year:</label> <select id="filterByYear" class="form-select">
									<option value="">Select Year</option>
									<script>
      // Dynamically generate year options for the past 10 years
      const currentYear = new Date().getFullYear();
      const yearSelect = document.getElementById("filterByYear");
      for (let year = currentYear; year >= currentYear - 10; year--) {
        const option = document.createElement("option");
        option.value = year;
        option.textContent = year;
        yearSelect.appendChild(option);
      }
    </script>
								</select>
							</div>
							<div class="col-md-3 d-flex align-items-end">
								<button id="applyFilters" class="btn btn-primary w-100 me-2">Apply
									Filters</button>
								<button id="resetFilters" class="btn btn-secondary w-100 ms-2">Reset
									Filters</button>
							</div>
						</div>

						<!-- Table section -->
						<div class="card-body d-flex flex-column justify-content-center">
							<div class="table-responsive">
								<table class="table table-hover">
									<thead class="table-primary">
										<tr>
											<th>#</th>
											<th>Service</th>
											<th>Service Category</th>
											<th>Feedback</th>
											<th>Booking Status</th>
											<th>Date</th>
											<th>Change Status</th>
											<th>Change Booking Time</th>
											<th>Cancel</th>
										</tr>
									</thead>
									<tbody id="modalMemberBookings"></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="updateBookingStatusModal" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<!-- Modal Header -->
					<div class="modal-header">
						<h5 class="modal-title">Update Booking Status</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<!-- Modal Body -->
					<div class="modal-body">
						<form id="updateStatusForm"
							action="<%=request.getContextPath()%>/UpdateBookingStatusServlet"
							method="POST">
							<!-- Hidden input for booking ID -->
							<input type="hidden" name="bookingStatusId" id="bookingStatusId"
								value="">

							<p>Select a new status for the booking:</p>

							<!-- Radio buttons for status -->
							<div class="form-check">
								<input class="form-check-input" type="radio" name="statusId"
									id="Completed" value="1"> <label
									class="form-check-label" for="status1">Completed</label>
							</div>

							<div class="form-check">
								<input class="form-check-input" type="radio" name="statusId"
									id="Ongoing" value="2"> <label class="form-check-label"
									for="status2">Ongoing</label>
							</div>

							<div class="form-check">
								<input class="form-check-input" type="radio" name="statusId"
									id="AwaitingPayment" value="3"> <label
									class="form-check-label" for="status3">Awaiting Payment</label>
							</div>

							<div class="form-check">
								<input class="form-check-input" type="radio" name="statusId"
									id="Cancelled" value="4"> <label
									class="form-check-label" for="status4">Cancelled</label>
							</div>

							<div class="form-check">
								<input class="form-check-input" type="radio" name="statusId"
									id="Booked" value="5"> <label class="form-check-label"
									for="status5">Booked</label>
							</div>
						</form>
					</div>

					<!-- Modal Footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
						<button type="submit" form="updateStatusForm"
							class="btn btn-primary">Save Changes</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Update Booking Time Modal -->
		<div class="modal fade" id="updateBookingModal" tabindex="-1"
			aria-labelledby="updateBookingModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #17A2B8; color: white;">
						<h5 class="modal-title" id="updateBookingModalLabel">Update
							Booking Time</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<form
							action="<%=request.getContextPath()%>/UpdateBookingTimeServlet"
							method="post" id="updateBookingForm">
							<div class="mb-3">
								<label for="bookingId" class="form-label">Booking ID</label> <input
									type="text" class="form-control" id="bookingTimeId"
									name="bookingTimeId" readonly>
							</div>
							<div class="mb-3">
								<label for="newBookingTime" class="form-label">New
									Booking Time</label> <input type="datetime-local" class="form-control"
									id="newBookingTime" name="newBookingTime" required>
							</div>
							<button type="submit" class="btn btn-primary">Update
								Booking Time</button>
						</form>
					</div>
				</div>
			</div>
		</div>

		<!-- Cancel Booking Modal -->
		<div class="modal fade" id="cancelBookingModal" tabindex="-1"
			aria-labelledby="cancelBookingModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #dc3545; color: white;">
						<h5 class="modal-title" id="cancelBookingModalLabel">Cancel
							Booking</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<p>Are you sure you want to cancel this booking?</p>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
						<form action="<%=request.getContextPath()%>/CancelBookingServlet"
							method="post">
							<!-- You can add hidden fields if necessary -->
							<input type="hidden" name="cancelBookingId" id="cancelBookingId" />
							<button type="submit" class="btn btn-danger">Confirm
								Cancellation</button>
						</form>
					</div>
				</div>
			</div>
		</div>

		<!-- Edit Member Modal -->
		<div class="modal fade" id="editMemberModal" tabindex="-1"
			aria-labelledby="editMemberModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #FFC107; color: white;">
						<h5 class="modal-title" id="editMemberModalLabel">Edit Member
							Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<form id="editMemberForm"
						action="<%=request.getContextPath()%>/UpdateMemberServlet"
						method="post">
						<!-- Include hidden input to specify the action type -->
						<input type="hidden" name="action" value="editMember">
						<!-- Hidden field to store Service ID -->
						<input type="hidden" id="editedMemberId" name="customerId">
						<div class="modal-body">
							<!-- Name -->
							<div class="mb-3">
								<label for="editMemberFirstName" class="form-label">First
									Name</label> <input type="text" class="form-control"
									id="editMemberFirstName" name="firstName" required>
							</div>
							<div class="mb-3">
								<label for="editMemberLastName" class="form-label">Last
									Name</label> <input type="text" class="form-control"
									id="editMemberLastName" name="lastName" required>
							</div>
							<!-- Email -->
							<div class="mb-3">
								<label for="editMemberEmail" class="form-label">Email</label> <input
									type="email" class="form-control" id="editMemberEmail"
									name="email" required>
							</div>
							<!-- Gender -->
							<div class="mb-3">
								<label class="form-label">Gender</label><br>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										id="editGenderMale" name="gender" value="M" required>
									<label class="form-check-label" for="editGenderMale">Male</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										id="editGenderFemale" name="gender" value="F" required>
									<label class="form-check-label" for="editGenderFemale">Female</label>
								</div>
							</div>
							<!-- DOB -->
							<div class="mb-3">
								<label for="editMemberDob" class="form-label">Date of
									Birth</label> <input type="date" class="form-control"
									id="editMemberDob" name="dob" required>
							</div>
							<!-- Contact -->
							<div class="mb-3">
								<label for="editMemberContact" class="form-label">Contact</label>
								<input type="text" class="form-control" id="editMemberContact"
									name="contact" required>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-warning">Save
								Changes</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- Delete Member Confirmation Modal -->
		<div class="modal fade" id="deleteMemberModal" tabindex="-1"
			aria-labelledby="deleteMemberModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<form action="<%=request.getContextPath()%>/DeleteMemberServlet"
						method="POST">
						<!-- Include hidden input to specify the action type -->
						<input type="hidden" name="action" value="deleteMember">
						<!-- Hidden field to store Member ID -->
						<input type="hidden" id="deleteCustomerId" name="customerId">

						<div class="modal-header bg-danger text-white">
							<h5 class="modal-title" id="deleteMemberModalLabel">Delete
								Member</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body">
							Are you sure you want to delete the member "<span
								id="deleteMemberName"></span>"?
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Cancel</button>
							<!-- Submit button to trigger form submission -->
							<button type="submit" class="btn btn-danger">Delete</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<script>
		  
		   // Wait for DOM to be fully loaded
		      document.addEventListener('DOMContentLoaded', function() {
		          const serviceFilter = document.getElementById('serviceFilter');
		          const tableBody = document.getElementById('modalMemberBookingsByService');
		          const allRows = Array.from(tableBody.getElementsByTagName('tr'));
		          
		          // Hide all rows initially
		          allRows.forEach(row => row.style.display = 'none');
		          
		          // Add no selection message initially
		          showMessage('Please select a service to view customer bookings');
		          
		          // Add event listener to service filter
		          serviceFilter.addEventListener('change', function() {
		              const selectedServiceId = this.value;
		              filterTableByService(selectedServiceId);
		          });
		          
		          function filterTableByService(serviceId) {
		              // Clear any existing messages
		              clearMessage();
		              
		              if (!serviceId) {
		                  // If "All Services" is selected, show all rows
		                  allRows.forEach(row => row.style.display = 'none');
		                  showMessage('Please select a service to view customer bookings');
		                  
		                  if (allRows.length === 0) {
		                      showMessage('No booking data available');
		                  }
		                  return;
		              }
		              
		              // Filter rows based on service ID
		              const filteredRows = allRows.filter(row => 
		                  row.getAttribute('data-service-id') === serviceId
		              );
		              
		              // Hide all rows first
		              allRows.forEach(row => row.style.display = 'none');
		              
		              if (filteredRows.length === 0) {
		                  showMessage(`No bookings found for this service`);
		              } else {
		                  // Show filtered rows
		                  filteredRows.forEach(row => row.style.display = '');
		              }
		          }
		          
		          function showMessage(message) {
		              clearMessage();
		              const messageRow = document.createElement('tr');
		              const messageCell = document.createElement('td');
		              messageCell.colSpan = 4; // Span all columns
		              messageCell.className = 'text-center p-3';
		              messageCell.textContent = message;
		              messageRow.appendChild(messageCell);
		              tableBody.appendChild(messageRow);
		          }
		          
		          function clearMessage() {
		              const existingMessage = tableBody.querySelector('tr td[colspan="4"]');
		              if (existingMessage) {
		                  existingMessage.parentElement.remove();
		              }
		          }
		      });
		      
		 // Function to display booking details with filters applied
		    function displayFilteredBookings(bookings) {
		      const bookingTable = document.getElementById('modalMemberBookings');
		      bookingTable.innerHTML = '';
		      
		      if (bookings.length > 0) {
		        bookings.forEach((booking, index) => {
		          const bookingId = booking.booking_id || "N/A";
		          const bookingTime = booking.booking_time ? new Date(booking.booking_time).toLocaleString() : "N/A";
		          const serviceName = booking.service_name || "N/A";
		          const serviceCategory = booking.service_category || "N/A";
		          const status = booking.status || "N/A";
		          const rating = booking.rating || "N/A";
		          const feedback = booking.feedback || "N/A";
		          
		          const feedbackInfo = (rating === "N/A" && feedback === "N/A") 
		            ? "No feedback given." 
		            : "<p><strong>Rating:</strong>" +rating+"</p><p><strong>Feedback:</strong>"+feedback+"</p>";

		            const bookingInfo = 
		                "<tr class=\"booking-row\">" +
		                "<td>" + bookingId + "</td>" +
		                "<td>" + serviceName + "</td>" +
		                "<td>" + serviceCategory + "</td>" +
		                "<td>" + feedbackInfo + "</td>" +
		                "<td>" + status + "</td>" +
		                "<td>" + bookingTime + "</td>" +
		                "<td>" +
		                ((status === "Completed" || status === "Cancelled") ? 
		                    ""
		                    : "<button class=\"btn btn-info btn-sm\""+
		                    "style=\"border-radius: 12px;\"" +
		                    "data-id=\"" + bookingId + "\"" +
		                    " data-status=\"" + status + "\"" +
		                    " onclick=\"updateBookingStatus(this)\"" +
		                    " data-bs-toggle=\"modal\"" +
		                    " data-bs-target=\"#updateBookingStatusModal\">" +
		                    "<i class=\"bi bi-pencil\"></i>" +
		                    "</button>") +
		                "<td>" +
		                (status === "Booked" ? 
		                    "<button class=\"btn btn-info btn-sm\""+
		                    "style=\"border-radius: 12px;\"" +
		                    "data-id=\"" + bookingId + "\"" +
		                    " data-time=\"" + bookingTime + "\"" +
		                    " onclick=\"updateBooking(this)\"" +
		                    " data-bs-toggle=\"modal\"" +
		                    " data-bs-target=\"#updateBookingModal\">" +
		                    "<i class=\"bi bi-calendar-week\"></i>" +
		                    "</button>" 
		                : "") +
		                "</td>" +
		                "<td>"+
		                (status === "Booked" ? 
		                        "<button class=\"btn btn-danger btn-sm\""+
		                        "style=\"border-radius: 12px;\"" +
		                        "data-id=\"" + bookingId + "\"" +
		                        " onclick=\"cancelBooking(this)\"" +
		                        " data-bs-toggle=\"modal\"" +
		                        " data-bs-target=\"#cancelBookingModal\">" +
		                        "<i class=\"bi bi-x-circle\"></i>" +
		                        "</button>" 
		                    : "") +"</td>" +
		                "</tr>";

		          bookingTable.innerHTML += bookingInfo;
		        });
		      } else {
		        bookingTable.innerHTML = `
		          <tr>
		            <td colspan="8" class="text-center">No bookings found.</td>
		          </tr>`;
		      }
		    }
		 
		 // Function to handle the View Member button click
		    function viewMemberDetails(button) {
		      // Retrieve data attributes
		      const name = button.dataset.name || "N/A";
		      const email = button.dataset.email || "N/A";
		      const gender = button.dataset.gender || "N/A";
		      const dob = button.dataset.dob ? button.dataset.dob.split(" ")[0] : "N/A";
		      const contact = button.dataset.contact || "N/A";
		      const bookingDetails = button.dataset.bookingDetails ? JSON.parse(button.dataset.bookingDetails) : [];

		      // Populate modal fields
		      document.getElementById("modalMemberName").textContent = name;
		      document.getElementById("modalMemberEmail").textContent = email;
		      document.getElementById("modalMemberGender").textContent = gender;
		      document.getElementById("modalMemberDob").textContent = dob;
		      document.getElementById("modalMemberContact").textContent = contact;

		      displayFilteredBookings(bookingDetails);

		      
		      // Apply Filters Button Event
		      document.getElementById('applyFilters').addEventListener('click', function () {
		        const dateFilter = document.getElementById('filterByDate').value;
		        const periodFilter = document.getElementById('filterByPeriod').value;
		        const monthFilter = document.getElementById('filterByMonth').value;
		        const yearFilter = document.getElementById("filterByYear").value;

		        let filteredBookings = bookingDetails;

		        if (dateFilter) {
		          filteredBookings = filteredBookings.filter(booking => 
		            booking.booking_time && new Date(booking.booking_time).toISOString().split('T')[0] === dateFilter
		          );
		        }

		        if (periodFilter === "week") {
		          const now = new Date();
		          const startOfWeek = new Date(now);
		          startOfWeek.setDate(now.getDate() - now.getDay());
		          filteredBookings = filteredBookings.filter(booking => {
		            const bookingDate = new Date(booking.booking_time);
		            return bookingDate >= startOfWeek && bookingDate <= now;
		          });
		        }
		        if (periodFilter === "month") {
		            const now = new Date();
		            const currentMonth = now.getMonth();
		            const currentYear = now.getFullYear();
		            filteredBookings = filteredBookings.filter(booking => {
		              const bookingDate = new Date(booking.booking_time);
		              return (
		                bookingDate.getMonth() === currentMonth &&
		                bookingDate.getFullYear() === currentYear
		              );
		            });
		          }

		          if (periodFilter === "year") {
		            const currentYear = new Date().getFullYear();
		            filteredBookings = filteredBookings.filter(booking => {
		              const bookingDate = new Date(booking.booking_time);
		              return bookingDate.getFullYear() === currentYear;
		            });
		          }

		        if (monthFilter) {
		          filteredBookings = filteredBookings.filter(booking => 
		            new Date(booking.booking_time).getMonth() + 1 === parseInt(monthFilter)
		          );
		        }
		        
		        if (yearFilter) {
		            filteredBookings = filteredBookings.filter(booking => {
		              const bookingDate = new Date(booking.booking_time);
		              return bookingDate.getFullYear() === parseInt(yearFilter);
		            });
		          }

		        displayFilteredBookings(filteredBookings);
		      });
		      
		    //RESET Filters
		      document.getElementById('resetFilters').addEventListener('click', function () {
		          document.getElementById('filterByPeriod').value = "";
		          document.getElementById('filterByMonth').value = "";
		          document.getElementById('filterByYear').value = "";
		          
		          displayFilteredBookings(bookingDetails);
		        });
		    }
		    
		    function updateBookingStatus(button) {
				  const bookingStatusId = button.dataset.id || "";
				  const bookingStatus = button.dataset.status || "";
				  
				  // Set the values inside the modal
				  document.getElementById('bookingStatusId').value = bookingStatusId;
				  const radioButton = document.getElementById(bookingStatus.trim());
				  if (radioButton) {
				    radioButton.checked = true;
				  }
				}
				
				function updateBooking(button) {
					  const bookingTimeId = button.dataset.id || "";
					  const bookingTime = button.dataset.time || "";
					  
					  // Set the values inside the modal
					  document.getElementById('bookingTimeId').value = bookingTimeId;
					  document.getElementById('newBookingTime').value = bookingTime;
					}
				
				function cancelBooking(button){
					const bookingId = button.dataset.id || "";
					
					document.getElementById('cancelBookingId').value = bookingId;
				}
		
		function editMemberDetails(button) {
		    // Retrieve data attributes
		    const id = button.dataset.id || "";
		    const firstName = button.dataset.firstname || "";
		    const lastName = button.dataset.lastname || "";
		    const email = button.dataset.email || "";
		    const gender = button.dataset.gender || "M";
		    const dob = button.dataset.dob || "";
		    const contact = button.dataset.contact || "";

		    // Populate modal form fields
		    document.getElementById("editMemberFirstName").value = firstName;
		    document.getElementById("editMemberLastName").value = lastName;
		    document.getElementById("editMemberEmail").value = email;
		    document.getElementById("editMemberDob").value = dob.split(" ")[0];
		    document.getElementById("editMemberContact").value = contact;
		    document.getElementById("editedMemberId").value = id;
		    
		    if (gender === "M") {
		        document.getElementById("editGenderMale").checked = true;
		    } else if (gender === "F") {
		        document.getElementById("editGenderFemale").checked = true;
		    }
		}
		
		function openDeleteMemberModal(button) {
		    // Retrieve data attributes from the clicked button
		    const id = button.dataset.id || "";
		    const name = button.dataset.name || "N/A";

		    // Populate modal fields
		    document.getElementById("deleteCustomerId").value = id; // Set the hidden input for member ID
		    document.getElementById("deleteMemberName").textContent = name; // Display member name in modal
		}
		</script>
		<script>
	    document.addEventListener('DOMContentLoaded', function () {
	        const searchBar = document.getElementById('searchBar');
	        const table = document.getElementById('membersTable');
	        const rows = Array.from(table.querySelectorAll('tbody tr'));

	        searchBar.addEventListener('input', function () {
	            const searchTerm = searchBar.value.toLowerCase();

	            rows.forEach(row => {
	                const rowText = Array.from(row.children)
	                    .slice(1, 6) // Include only Name, Email, Gender, DOB, and Contact columns
	                    .map(cell => cell.textContent.toLowerCase())
	                    .join(' ');

	                // Show or hide row based on search term
	                row.style.display = rowText.includes(searchTerm) ? '' : 'none';
	            });
	        });
	    });
	</script>
	<!-- JavaScript for Filtering and Record Count -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const searchBar = document.getElementById('searchAddressBar');
        const filterDropdown = document.getElementById('addressNameFilter');
        const table = document.getElementById('addressTable');
        const rows = Array.from(table.querySelectorAll('tbody tr'));
        const recordCount = document.getElementById('recordCount');

        function filterTable() {
            const searchTerm = searchBar.value.toLowerCase();
            const selectedFilter = filterDropdown.value.toLowerCase();
            let visibleCount = 0;

            rows.forEach(row => {
                const rowText = Array.from(row.children)
                    .map(cell => cell.textContent.toLowerCase())
                    .join(' ');

                const addressName = row.children[3].textContent.toLowerCase(); // Column index for Address Name
                
                // Apply both search and dropdown filter
                const matchesSearch = searchTerm === "" || rowText.includes(searchTerm);
                const matchesFilter = selectedFilter === "" || addressName === selectedFilter;

                if (matchesSearch && matchesFilter) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Update record count
            recordCount.textContent = "Records: " + visibleCount;
            console.log("Checking if recordCount element exists:", visibleCount);
            console.log("Checking if recordCount element exists:", recordCount);
        }

        // Add event listeners
        searchBar.addEventListener('input', filterTable);
        filterDropdown.addEventListener('change', filterTable);

        // Initialize record count
        filterTable();
    });
</script>

	</div>

	<!-- Bootstrap JS and dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<%@ include file="adminFooter.html"%>
</body>


</html>