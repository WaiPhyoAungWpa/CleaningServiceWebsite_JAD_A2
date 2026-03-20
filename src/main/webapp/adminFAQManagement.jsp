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
	request.setAttribute("page", "faqManagement");
	%>
	<%@ include file="header.jsp"%>
<% 
       if(adminId == null){
		    	response.sendRedirect("loginPage.jsp");
		    }
		    %>
		    
	<!-- Main Content -->
	<div class="container-fluid px-0">

		<!-- --------------------------FAQs Section-------------------------- -->
		<section id="faqs-section"
			style="padding: 50px 0; background-color: #b3d7f1;">
			<div class="container py-4">
				<h2
					style="font-weight: bold; text-align: center; margin-bottom: 20px;">FAQs</h2>
				<button class="btn btn-primary"
					style="margin-bottom: 10px; border-radius: 12px;"
					data-bs-toggle="modal" data-bs-target="#addFaqModal">
					<i class="bi bi-plus-circle"></i>
				</button>
				<div style="overflow: hidden; border-radius: 12px;">
					<!-- Wrapper for rounded border -->
					<table class="table table-bordered"
						style="border-radius: 12px; overflow: hidden;">
						<thead class="table-light">
							<tr>
								<th style="border-top-left-radius: 12px;">ID</th>
								<th>Question</th>
								<th>View</th>
								<th>Edit</th>
								<th style="border-top-right-radius: 12px;">Delete</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="faq" items="${faqs}">
								<tr>
									<td>${faq.id}</td>
									<td>${faq.question}</td>
									<td>
										<button class="btn btn-info btn-sm"
											style="border-radius: 12px;" data-id="${faq.id}"
											data-question="${faq.question}" data-answer="${faq.answer}"
											data-createdat="${faq.createdAt}"
											data-updatedat="${faq.updatedAt}"
											onclick="viewFaqDetails(this)" data-bs-toggle="modal"
											data-bs-target="#viewFaqModal">
											<i class="bi bi-eye"></i>
										</button>
									</td>
									<td>
										<button class="btn btn-warning btn-sm"
											style="border-radius: 12px;" data-id="${faq.id}"
											data-question="${faq.question}" data-answer="${faq.answer}"
											onclick="editFaqDetails(this)" data-bs-toggle="modal"
											data-bs-target="#editFaqModal">
											<i class="bi bi-pencil"></i>
										</button>
									</td>
									<td>
										<button class="btn btn-danger btn-sm"
											style="border-radius: 12px;" data-id="${faq.id}"
											data-question="${faq.question}"
											onclick="deleteFaqDetails(this)" data-bs-toggle="modal"
											data-bs-target="#deleteFaqModal">
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
		<!-- Add FAQ Modal -->
		<div class="modal fade" id="addFaqModal" tabindex="-1"
			aria-labelledby="addFaqModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<form action="<%=request.getContextPath()%>/AddFAQServlet"  method="POST">
						<input type="hidden" name="action" value="addFaq">
						<div class="modal-header bg-primary text-white">
							<h5 class="modal-title" id="addFaqModalLabel">Add FAQ</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						</div>
						<div class="modal-body">
							<div class="mb-3">
								<label for="faqQuestion" class="form-label">Question</label> <input
									type="text" class="form-control" id="faqQuestion"
									name="question" required>
							</div>
							<div class="mb-3">
								<label for="faqAnswer" class="form-label">Answer</label>
								<textarea class="form-control" id="faqAnswer" name="answer"
									rows="3" required></textarea>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-primary">Add FAQ</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- View FAQ Modal -->
		<div class="modal fade" id="viewFaqModal" tabindex="-1"
			aria-labelledby="viewFaqModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header bg-info text-white">
						<h5 class="modal-title" id="viewFaqModalLabel">FAQ Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<p>
							<strong>Question:</strong> <span id="viewFaqQuestion"></span>
						</p>
						<p>
							<strong>Answer:</strong> <span id="viewFaqAnswer"></span>
						</p>
						<p>
							<strong>Created at:</strong> <span id="viewFaqCreatedAt"></span>
						</p>
						<p>
							<strong>Updated at:</strong> <span id="viewFaqUpdatedAt"></span>
						</p>
					</div>
				</div>
			</div>
		</div>
		<!-- Edit FAQ Modal -->
		<div class="modal fade" id="editFaqModal" tabindex="-1"
			aria-labelledby="editFaqModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<form action="<%=request.getContextPath()%>/UpdateFAQServlet" method="POST">
						<input type="hidden" name="action" value="editFaq"> <input
							type="hidden" id="editFaqId" name="id">
						<div class="modal-header bg-warning text-white">
							<h5 class="modal-title" id="editFaqModalLabel">Edit FAQ</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						</div>
						<div class="modal-body">
							<div class="mb-3">
								<label for="editFaqQuestion" class="form-label">Question</label>
								<input type="text" class="form-control" id="editFaqQuestion"
									name="question" required>
							</div>
							<div class="mb-3">
								<label for="editFaqAnswer" class="form-label">Answer</label>
								<textarea class="form-control" id="editFaqAnswer" name="answer"
									rows="3" required></textarea>
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
		<!-- Delete FAQ Modal -->
		<div class="modal fade" id="deleteFaqModal" tabindex="-1"
			aria-labelledby="deleteFaqModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<form action="<%=request.getContextPath()%>/DeleteFAQServlet" method="POST">
						<input type="hidden" name="action" value="deleteFaq"> <input
							type="hidden" id="deleteFaqId" name="id">
						<div class="modal-header bg-danger text-white">
							<h5 class="modal-title" id="deleteFaqModalLabel">Delete FAQ</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						</div>
						<div class="modal-body">
							Are you sure you want to delete the FAQ "<span
								id="deleteFaqQuestion"></span>"?
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-danger">Delete</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<script>
		function viewFaqDetails(button) {
	        const question = button.dataset.question || "N/A";
	        const answer = button.dataset.answer || "N/A";
	        const createdAt = button.dataset.createdat || "N/A";
	        const updatedAt = button.dataset.updatedat || "N/A";

	        document.getElementById("viewFaqQuestion").textContent = question;
	        document.getElementById("viewFaqAnswer").textContent = answer;
	        document.getElementById("viewFaqCreatedAt").textContent = createdAt;
	        document.getElementById("viewFaqUpdatedAt").textContent = updatedAt;
	    }

	    function editFaqDetails(button) {
	        const id = button.dataset.id;
	        const question = button.dataset.question || "";
	        const answer = button.dataset.answer || "";

	        document.getElementById("editFaqId").value = id;
	        document.getElementById("editFaqQuestion").value = question;
	        document.getElementById("editFaqAnswer").value = answer;
	    }

	    function deleteFaqDetails(button) {
	        const id = button.dataset.id;
	        const question = button.dataset.question || "";

	        document.getElementById("deleteFaqId").value = id;
	        document.getElementById("deleteFaqQuestion").textContent = question;
	    }
	    </script>
	</div>

	<!-- Bootstrap JS and dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<%@ include file="adminFooter.html"%>
</body>


</html>