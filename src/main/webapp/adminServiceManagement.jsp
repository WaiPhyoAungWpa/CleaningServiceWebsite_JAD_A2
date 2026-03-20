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
<style>
/* Style for highlighting the sorted column */
.sorted-column {
	background-color: #D9EAFD !important;
}
/* Increase modal width */
#reportStatisticsModal .modal-dialog {
	max-width: 90vw; /* Set modal width to 90% of the viewport */
}

/* Ensure table takes full width */
#reportTable {
	width: 100%;
}
</style>
<body>
	<%
	request.setAttribute("page", "serviceManagement");
	%>
	<%@ include file="header.jsp"%>
	<%
	if (adminId == null) {
		response.sendRedirect("loginPage.jsp");
	}
	%>

	<!-- Main Content -->
	<div class="container-fluid px-0">

		<!-- -------------------------------Services Section------------------------------- -->
		<section id="services-section"
			style="padding: 50px 0; background-color: #b3d7f1;">
			<div class="container py-4">
				<h2
					style="font-weight: bold; text-align: center; margin-bottom: 20px;">Service
					Management</h2>
				<button class="btn btn-primary"
					style="margin-bottom: 10px; border-radius: 12px;"
					data-bs-toggle="modal" data-bs-target="#createServiceModal">
					<i class="bi bi-plus-circle"></i>
				</button>
				<!-- Add Report Statistics Button -->
				<button class="btn btn-info"
					style="margin-bottom: 10px; border-radius: 12px;"
					data-bs-toggle="modal" data-bs-target="#reportStatisticsModal">
					<i class="bi bi-bar-chart"></i> Report Statistics
				</button>
				<div style="overflow: hidden; border-radius: 12px;">
					<!-- Wrapper for rounded border -->
					<table class="table table-bordered"
						style="border-radius: 12px; overflow: hidden;">
						<thead class="table-light">
							<tr>
								<th style="border-top-left-radius: 12px;">ID</th>
								<th>Name</th>
								<th>Category</th>
								<th>View</th>
								<th>Edit</th>
								<th style="border-top-right-radius: 12px;">Delete</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="service" items="${services}">
								<tr>
									<td>${service.getServiceId()}</td>
									<td>${service.getServiceName()}</td>
									<td>${service.getServiceCategory()}</td>
									<td>
										<button class="btn btn-info btn-sm"
											style="border-radius: 12px;"
											onclick="viewServiceDetails(
									            '${service.serviceId}',
									            '${service.serviceName}',
									            '${service.serviceCategory}',
									            '${service.serviceDescription}',
									            '${service.basePrice}',
									            '${service.baseDuration}',
									            '${service.addOnRate}',
									            '${service.includedServiceItems}',
									            'service_images/${service.serviceImgName}'
									        )"
											data-bs-toggle="modal" data-bs-target="#serviceModal">
											<i class="bi bi-eye"></i>
										</button>
									</td>
									<td>
										<button class="btn btn-warning btn-sm"
											style="border-radius: 12px;"
											onclick="openEditModal(
									            '${service.getServiceId()}',
									            '${service.getServiceName()}',
									            '${service.getServiceDescription()}',
									            '${service.getServiceCategory()}',
									            '${service.getServiceImgName()}',
									            '${service.getBasePrice()}',
									            '${service.getBaseDuration()}',
									            '${service.getAddOnRate()}',
									            '${service.getIncludedServiceItems()}'
									        )"
											data-bs-toggle="modal" data-bs-target="#editServiceModal">
											<i class="bi bi-pencil"></i>
										</button>
									</td>
									<td>
										<button class="btn btn-danger btn-sm"
											style="border-radius: 12px;"
											onclick="openDeleteModal('${service.getServiceId()}', '${service.getServiceName()}')"
											data-bs-toggle="modal" data-bs-target="#deleteServiceModal">
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
		<!-- View Service Detail Modal -->
		<div class="modal fade" id="serviceModal" tabindex="-1"
			aria-labelledby="serviceModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header"
						style="background-color: #17A2B8; color: white;">
						<h5 class="modal-title" id="serviceModalLabel">View Services</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body d-flex">
						<!-- Service Image -->
						<div style="flex: 1; text-align: center;">
							<img src="" alt="Service Image" id="modalServiceImage"
								style="width: 200px; height: 200px; border-radius: 12px; border: 2px solid #ddd; object-fit: cover;">
						</div>

						<!-- Service Details -->
						<div style="flex: 2; padding-left: 20px;">
							<p>
								<strong>Name:</strong> <span id="modalServiceName"></span>
							</p>
							<p>
								<strong>Category:</strong> <span id="modalServiceCategory"></span>
							</p>
							<p>
								<strong>About:</strong> <span id="modalServiceDescription"></span>
							</p>
							<p>
								<strong>Base Price:</strong> <span id="modalBasePrice"></span>
							</p>
							<p>
								<strong>Base Duration:</strong> <span id="modalBaseDuration"></span>
							</p>
							<p>
								<strong>Add-on Rate:</strong> <span id="modalAddOnRate"></span>
							</p>
							<p>
								<strong>Included Services:</strong>
							</p>
							<ul id="modalIncludedItems" style="padding-left: 20px;"></ul>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Create Service Modal -->
		<div class="modal fade" id="createServiceModal" tabindex="-1"
			aria-labelledby="createServiceModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<!-- Modal Header -->
					<div class="modal-header text-white"
						style="background-color: #007BFF">
						<h5 class="modal-title" id="createServiceModalLabel">Add New
							Service</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<!-- Modal Body -->
					<div class="modal-body">
						<form id="createServiceForm"
							action="<%=request.getContextPath()%>/CreateServiceServlet"
							method="POST" enctype="multipart/form-data">
							<!-- Hidden input to specify action type -->
							<input type="hidden" name="action" value="create">
							<!-- Service Name -->
							<div class="mb-3">
								<label for="serviceName" class="form-label">Name:</label> <input
									type="text" class="form-control" id="serviceName"
									name="serviceName" required>
							</div>

							<!-- Service Category -->
							<div class="mb-3">
								<label for="serviceCategory" class="form-label">Category:</label><br>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="residential" value="Residential"
										required> <label class="form-check-label"
										for="residential">Residential</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="commercial" value="Commercial">
									<label class="form-check-label" for="commercial">Commercial</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="others" value="Others"> <label
										class="form-check-label" for="others">Others</label>
								</div>
							</div>

							<!-- Service Image Upload -->
							<div class="mb-3">
								<label for="serviceImg" class="form-label">Upload Image:</label>
								<input type="file" class="form-control" id="serviceImg"
									name="serviceImg" accept=".jpg,.jpeg,.png,.gif,.webp" required>
							</div>

							<!-- Service Description -->
							<div class="mb-3">
								<label for="serviceDescription" class="form-label">About:</label>
								<textarea class="form-control" id="serviceDescription"
									name="serviceDescription" rows="3" required></textarea>
							</div>

							<!-- Base Price -->
							<div class="mb-3">
								<label for="basePrice" class="form-label">Base Price
									($):</label> <input type="number" step="0.01" class="form-control"
									id="basePrice" name="basePrice" required>
							</div>

							<!-- Base Duration -->
							<div class="mb-3">
								<label for="baseDuration" class="form-label">Base
									Duration (hours):</label> <input type="number" step="0.1"
									class="form-control" id="baseDuration" name="baseDuration"
									required>
							</div>

							<!-- Add-on Rate -->
							<div class="mb-3">
								<label for="addOnRate" class="form-label">Add-on Rate ($
									per hour):</label> <input type="number" step="0.01"
									class="form-control" id="addOnRate" name="addOnRate" required>
							</div>

							<!-- Included Services -->
							<div class="mb-3">
								<label class="form-label">Included Services:</label>
								<div id="includedServicesCheckboxes">
									<!-- Dynamically populate checkboxes from the serviceItems list -->
									<c:forEach var="serviceItem" items="${serviceItems}">
										<div class="form-check">
											<input class="form-check-input" type="checkbox"
												id="${serviceItem}" name="includedServices"
												value="${serviceItem}" /> <label class="form-check-label"
												for="${serviceItem}"> ${serviceItem} </label>
										</div>
									</c:forEach>
								</div>
							</div>
							<!-- Modal Footer -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal">Cancel</button>
								<input type="submit" class="btn btn-primary" value="Create">
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<!-- Edit Service Modal -->
		<div class="modal fade" id="editServiceModal" tabindex="-1"
			aria-labelledby="editServiceModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<!-- Modal Header -->
					<div class="modal-header bg-warning text-white">
						<h5 class="modal-title" id="editServiceModalLabel">Edit
							Service</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<!-- Modal Body -->
					<div class="modal-body">
						<form id="editServiceForm"
							action="<%=request.getContextPath()%>/UpdateServiceServlet"
							method="POST" enctype="multipart/form-data">
							<!-- Hidden input to specify action type -->
							<input type="hidden" name="action" value="edit">
							<!-- Hidden field to store Service ID -->
							<input type="hidden" id="editServiceId" name="serviceId">
							<!-- Hidden field to store Image Name -->
							<input type="hidden" id="editImageName" name="editImageName">

							<!-- Service Name -->
							<div class="mb-3">
								<label for="editServiceName" class="form-label">Name:</label> <input
									type="text" class="form-control" id="editServiceName"
									name="serviceName" required>
							</div>

							<!-- Service Category -->
							<div class="mb-3">
								<label class="form-label">Category:</label>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="editResidential"
										value="Residential" required> <label
										class="form-check-label" for="editResidential">Residential</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="editCommercial" value="Commercial">
									<label class="form-check-label" for="editCommercial">Commercial</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio"
										name="serviceCategory" id="editOthers" value="Others">
									<label class="form-check-label" for="editOthers">Others</label>
								</div>
							</div>

							<!-- Current Service Image Preview -->
							<div class="mb-3">
								<label class="form-label">Current Image:</label>
								<div>
									<img id="currentServiceImage" src=""
										alt="Current Service Image" class="img-thumbnail" width="150">
								</div>
							</div>

							<!-- Upload New Image -->
							<div class="mb-3">
								<label for="serviceImgUpload" class="form-label">Upload
									New Image:</label> <input type="file" class="form-control"
									id="serviceImgUpload" name="serviceImgUpload"
									accept=".jpg,.jpeg,.png,.gif,.webp"> <small
									class="text-muted">Uploading a new image will replace
									the current one.</small>
							</div>

							<!-- Service Description -->
							<div class="mb-3">
								<label for="editServiceDescription" class="form-label">Description:</label>
								<textarea class="form-control" id="editServiceDescription"
									name="serviceDescription" rows="3" required></textarea>
							</div>

							<!-- Base Price -->
							<div class="mb-3">
								<label for="editBasePrice" class="form-label">Base Price
									($):</label> <input type="number" step="0.01" class="form-control"
									id="editBasePrice" name="basePrice" required>
							</div>

							<!-- Base Duration -->
							<div class="mb-3">
								<label for="editBaseDuration" class="form-label">Base
									Duration (hours):</label> <input type="number" step="0.1"
									class="form-control" id="editBaseDuration" name="baseDuration"
									required>
							</div>

							<!-- Add-on Rate -->
							<div class="mb-3">
								<label for="editAddOnRate" class="form-label">Add-on
									Rate ($ per hour):</label> <input type="number" step="0.01"
									class="form-control" id="editAddOnRate" name="addOnRate"
									required>
							</div>

							<!-- Included Services -->
							<div class="mb-3">
								<label class="form-label">Included Services:</label>
								<div id="editIncludedServicesCheckboxes">
									<!-- Dynamically populate checkboxes -->
									<c:forEach var="serviceItem" items="${serviceItems}">
										<div class="form-check">
											<input class="form-check-input" type="checkbox"
												id="edit${serviceItem}" name="includedServices"
												value="${serviceItem}"> <label
												class="form-check-label" for="edit${serviceItem}">${serviceItem}</label>
										</div>
									</c:forEach>
								</div>
							</div>


							<!-- Modal Footer -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal">Cancel</button>
								<button type="reset" class="btn btn-danger">Reset</button>
								<button type="submit" class="btn btn-warning">Save
									Changes</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>

		<!-- Delete Service Confirmation Modal -->
		<div class="modal fade" id="deleteServiceModal" tabindex="-1"
			aria-labelledby="deleteServiceModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<form action="<%=request.getContextPath()%>/DeleteServiceServlet"
						method="POST">
						<!-- Include hidden input to specify the action type -->
						<input type="hidden" name="action" value="delete">
						<!-- Hidden field to store Service ID -->
						<input type="hidden" id="deleteServiceId" name="serviceId">

						<div class="modal-header bg-danger text-white">
							<h5 class="modal-title" id="deleteServiceModalLabel">Delete
								Service</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body">
							Are you sure you want to delete the service "<span
								id="deleteServiceName"></span>"?
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
		function viewServiceDetails(serviceId, serviceName, serviceCategory, serviceDescription, basePrice, baseDuration, addOnRate, includedItems, imagePath) {
		    // Populate modal fields
		    document.getElementById('modalServiceName').textContent = serviceName || 'N/A';
		    document.getElementById('modalServiceCategory').textContent = serviceCategory || 'N/A';
		    document.getElementById('modalServiceDescription').textContent = serviceDescription || 'N/A';

		    // Handle base price, duration, and add-on rate using concatenation
		    document.getElementById('modalBasePrice').textContent = basePrice ? "$" + basePrice : 'N/A';
		    document.getElementById('modalBaseDuration').textContent = baseDuration ? baseDuration + " hours" : 'N/A';
		    document.getElementById('modalAddOnRate').textContent = addOnRate ? "$" + addOnRate + " per hour" : 'N/A';

		    // Generate the included items list dynamically
	        const includedItemsList = document.getElementById('modalIncludedItems');
	        includedItemsList.innerHTML = ''; // Clear previous content
	        if (includedItems) {
	            // Split included items using the custom delimiter (|)
	            includedItems.split('|').forEach(item => {
	                const li = document.createElement('li');
	                li.textContent = item.trim(); // Trim whitespace
	                includedItemsList.appendChild(li);
	            });
	        } else {
	            includedItemsList.innerHTML = '<li>N/A</li>';
	        }

		    // Set the service image
		    const serviceImage = document.getElementById('modalServiceImage');
		    serviceImage.src = imagePath || 'default_image.webp';
		    serviceImage.alt = serviceName || 'Service Image';
		}
		
		function openEditModal(serviceId, serviceName, serviceDescription, serviceCategory, serviceImgName, basePrice, baseDuration, addOnRate, includedServiceItems ) {
		    // Populate form fields
		    document.getElementById('editImageName').value = serviceImgName;
		    document.getElementById('editServiceId').value = serviceId;
		    document.getElementById('editServiceName').value = serviceName;
		    document.getElementById('editServiceDescription').value = serviceDescription;
		    document.getElementById('editBasePrice').value = basePrice;
		    document.getElementById('editBaseDuration').value = baseDuration;
		    document.getElementById('editAddOnRate').value = addOnRate;

		    // Set current image
		    let imagePath = `service_images/`+ serviceImgName;
		    document.getElementById('currentServiceImage').src = imagePath;
		    document.getElementById('currentServiceImage').alt = serviceName || "Service Image";

		    // Select service category radio button
		    document.querySelectorAll('input[name="serviceCategory"]').forEach(radio => {
		        radio.checked = radio.value === serviceCategory;
		    });
		    
		    // Reset file input
		    document.getElementById('serviceImgUpload').value = "";
		 
		    // Populate included service items checkboxes
		    const includedServicesCheckboxes = document.querySelectorAll('#editIncludedServicesCheckboxes .form-check-input');
		    includedServicesCheckboxes.forEach(checkbox => {
		        checkbox.checked = includedServiceItems.includes(checkbox.value);
		    });

		    // Store the serviceId for later use
		    document.getElementById('editServiceForm').dataset.serviceId = serviceId;

		    // Save initial state
		    const initialState = {
		        serviceName,
		        serviceDescription,
		        serviceCategory,
		        serviceImgName,
		        basePrice,
		        baseDuration,
		        addOnRate,
		        includedServiceItems: [...includedServiceItems] // Clone array to avoid mutation
		    };
		    document.getElementById('editServiceForm').dataset.initialState = JSON.stringify(initialState);

		}
		
		// Function to preview new uploaded image before submission
		document.getElementById('serviceImgUpload').addEventListener('change', function (event) {
		    const file = event.target.files[0];
		    if (file) {
		        const reader = new FileReader();
		        reader.onload = function (e) {
		            document.getElementById('currentServiceImage').src = e.target.result;
		        };
		        reader.readAsDataURL(file);
		    }
		});

		function resetEditForm() {
		    const form = document.getElementById('editServiceForm');
		    const initialState = JSON.parse(form.dataset.initialState);

		    // Restore values
		    document.getElementById('editServiceName').value = initialState.serviceName;
		    document.getElementById('editServiceDescription').value = initialState.serviceDescription;
		    document.getElementById('editBasePrice').value = initialState.basePrice;
		    document.getElementById('editBaseDuration').value = initialState.baseDuration;
		    document.getElementById('editAddOnRate').value = initialState.addOnRate;

		    // Restore included service items checkboxes
		    const includedServicesCheckboxes = document.querySelectorAll('#editIncludedServicesCheckboxes .form-check-input');
		    includedServicesCheckboxes.forEach(checkbox => {
		        checkbox.checked = initialState.includedServiceItems.includes(checkbox.value);
		    });

		    // Reset image preview to the original image
		    let imagePath = `service_images/` + initialState.serviceImgName;
		    document.getElementById('currentServiceImage').src = imagePath;

		    // Clear file input
		    document.getElementById('serviceImgUpload').value = "";
		}

		// Reset form when closing modal
		document.querySelector('#editServiceModal .btn-close').addEventListener('click', resetEditForm);
		
	    function openDeleteModal(serviceId, serviceName) {
	        document.getElementById('deleteServiceId').value = serviceId; // Set the service ID
	        document.getElementById('deleteServiceName').textContent = serviceName; // Set the service name
	    }
	    
	    document.getElementById("createServiceForm").addEventListener("submit", function(event) {
	        var fileInput = document.getElementById("serviceImg");
	        var filePath = fileInput.value;
	        
	        // Allowed extensions
	        var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif|\.webp)$/i;
	        
	        if (!allowedExtensions.exec(filePath)) {
	            alert("Invalid file type! Please upload a JPG, JPEG, PNG, GIF, or WebP.");
	            fileInput.value = ""; // Clear the input field
	            event.preventDefault(); // Stop form submission
	            return false;
	        }
	    });
	    </script>

		<!-- Report Statistics Modal -->
		<div class="modal fade" id="reportStatisticsModal" tabindex="-1"
			aria-labelledby="reportStatisticsModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header bg-info text-white">
						<h5 class="modal-title" id="reportStatisticsModalLabel">Service
							Report Statistics</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<!-- Sorting and Filtering Controls -->
						<div
							class="d-flex justify-content-between align-items-center mb-3 p-3 bg-light rounded shadow-sm">
							<div>
								<label for="sortOptions" class="fw-bold me-2">Sort By:</label> <select
									id="sortOptions"
									class="form-select d-inline-block w-auto border-info"
									onchange="sortReportTable()">
									<option value="idLow">Earliest Services</option>
									<option value="idHigh">Latest Services</option>
									<option value="ratingHigh">Highest Rated</option>
									<option value="ratingLow">Lowest Rated</option>
									<option value="demandHigh">Most Booked</option>
									<option value="demandLow">Least Booked</option>
									<option value="priceHigh">Highest Price</option>
									<option value="priceLow">Lowest Price</option>
									<option value="durationHigh">Longest Duration</option>
									<option value="durationLow">Shortest Duration</option>
									<option value="addonHigh">Highest Add-on Rate</option>
									<option value="addonLow">Lowest Add-on Rate</option>
								</select>
							</div>
							<div>
								<label for="statusFilter" class="fw-bold me-2">Status:</label> <select
									id="statusFilter"
									class="form-select d-inline-block w-auto border-info"
									onchange="filterReportTable()">
									<option value="all">All</option>
									<option value="active">Active</option>
									<option value="inactive">Inactive</option>
								</select>
							</div>
							<div>
								<label for="categoryFilter" class="fw-bold me-2">Category:</label>
								<select id="categoryFilter"
									class="form-select d-inline-block w-auto border-info"
									onchange="filterReportTable()">
									<option value="all">All</option>
									<option value="Residential">Residential</option>
									<option value="Commercial">Commercial</option>
									<option value="Others">Others</option>
								</select>
							</div>
							<!-- Refresh Button -->
							<button type="button" class="btn btn-light btn-sm me-2"
								onclick="refreshReportTable()">
								<i class="bi bi-arrow-clockwise"></i> Refresh
							</button>
						</div>
						<!-- Records Count Display -->
                <div class="text-end fw-bold mb-2">
                    Records Found: <span id="recordCount">0</span>
                </div>
						<div style="overflow: hidden; border-radius: 12px;">
							<table
								class="table table-bordered table-hover table-striped text-center shadow-sm"
								style="width: 100%; border-radius: 12px; overflow: hidden;"
								id="reportTable">
								<thead class="table-light text-black">
									<tr>
										<th style="border-top-left-radius: 12px;">ID</th>
										<th>Service Name</th>
										<th>Category</th>
										<th>Base Price ($)</th>
										<th>Base Duration (hrs)</th>
										<th>Add-on Rate ($/hr)</th>
										<th>Calculated Rating</th>
										<th>Booking Count</th>
										<th style="border-top-right-radius: 12px;">Status</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="sr" items="${serviceReports}">
										<tr>
											<td>${sr.serviceId}</td>
											<td>${sr.serviceName}</td>
											<td>${sr.serviceCategory}</td>
											<td>${sr.basePrice}</td>
											<td>${sr.baseDuration}</td>
											<td>${sr.addOnRate}</td>
											<td>${sr.calculatedRating}</td>
											<td>${sr.bookingCount}</td>
											<td>${sr.status}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>

		<script>
		document.addEventListener("DOMContentLoaded", function () {
		    let tableBody = document.querySelector("#reportTable tbody");
		    allRows = Array.from(tableBody.rows); // Store original rows on page load
		    document.getElementById("recordCount").textContent = allRows.length;
		});
		
		function updateRecordCount() {
	        let visibleRows = document.querySelectorAll("#reportTable tbody tr:not([style*='display: none'])");
	        document.getElementById("recordCount").textContent = visibleRows.length;
	    }

		// Function to sort the report table
		function sortReportTable() {
		    let tableBody = document.querySelector("#reportTable tbody");
		    let sortOption = document.getElementById("sortOptions").value;

		    let rows = Array.from(tableBody.rows).filter(row => row.style.display !== "none");

		    // Correct column indices mapping
		    let columnIndex;
		    switch (sortOption) {
		    case "idHigh":
	        case "idLow":
	            columnIndex = 0; // Correct index for "Calculated Rating"
	            break;
		        case "ratingHigh":
		        case "ratingLow":
		            columnIndex = 6; // Correct index for "Calculated Rating"
		            break;
		        case "demandHigh":
		        case "demandLow":
		            columnIndex = 7; // Correct index for "Booking Count"
		            break;
		        case "priceHigh":
		        case "priceLow":
		            columnIndex = 3; // Correct index for "Base Price"
		            break;
		        case "durationHigh":
		        case "durationLow":
		            columnIndex = 4; // Correct index for "Base Duration"
		            break;
		        case "addonHigh":
		        case "addonLow":
		            columnIndex = 5; // Correct index for "Add-on Rate"
		            break;
		        default:
		            columnIndex = null;
		    }

		    // Ensure correct numeric conversion
		    const getValue = (row, index) => parseFloat(row.cells[index]?.innerText.trim()) || 0;

		    // Sorting logic
		    rows.sort((a, b) => {
		        switch (sortOption) {
		        case "idHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
	            case "idLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            case "ratingHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
		            case "ratingLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            case "demandHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
		            case "demandLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            case "priceHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
		            case "priceLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            case "durationHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
		            case "durationLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            case "addonHigh": return getValue(b, columnIndex) - getValue(a, columnIndex);
		            case "addonLow": return getValue(a, columnIndex) - getValue(b, columnIndex);
		            default: return 0;
		        }
		    });

		    // Append sorted rows back to table
		    rows.forEach(row => tableBody.appendChild(row));
		    
		    updateRecordCount();

		    // Remove previous column highlights
		    document.querySelectorAll("#reportTable tbody td").forEach(td => td.classList.remove("sorted-column"));

		    // Apply highlight to the sorted column
		    if (columnIndex !== null) {
		        rows.forEach(row => {
		            row.cells[columnIndex]?.classList.add("sorted-column");
		        });
		    }
		}

		// Function to filter the report table
		function filterReportTable() {
		    let statusFilter = document.getElementById("statusFilter").value.toLowerCase();
		    let categoryFilter = document.getElementById("categoryFilter").value.toLowerCase();
		    let tableBody = document.querySelector("#reportTable tbody");

		    // Clear table before applying filters
		    tableBody.innerHTML = "";

		    allRows.forEach(row => {
		        let status = row.cells[8]?.innerText.trim().toLowerCase(); // Corrected status column index
		        let category = row.cells[2]?.innerText.trim().toLowerCase(); // Corrected category column index

		        let statusMatch = (statusFilter === "all" || status === statusFilter);
		        let categoryMatch = (categoryFilter === "all" || category === categoryFilter);

		        if (statusMatch && categoryMatch) {
		            tableBody.appendChild(row);
		        }
		    });

		    // Reapply sorting after filtering
		    sortReportTable();
		    updateRecordCount();
		}
		
		function refreshReportTable() {
		    // Reset dropdowns to default values
		    document.getElementById("sortOptions").selectedIndex = 0; // Reset sorting
		    document.getElementById("statusFilter").value = "all"; // Reset status filter
		    document.getElementById("categoryFilter").value = "all"; // Reset category filter

		    let tableBody = document.querySelector("#reportTable tbody");

		    // Clear the table and restore original data
		    tableBody.innerHTML = "";
		    allRows.forEach(row => tableBody.appendChild(row));
		    updateRecordCount();

		    // Remove all sorted column highlights
		    document.querySelectorAll("#reportTable tbody td").forEach(td => td.classList.remove("sorted-column"));
		}
	    </script>

	</div>

	<!-- Bootstrap JS and dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<%@ include file="adminFooter.html"%>
</body>


</html>