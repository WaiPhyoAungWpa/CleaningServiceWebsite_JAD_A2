<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@page import="MembersAndServices.*"%>
<%@page import="java.sql.*, java.util.ArrayList, java.util.HashMap"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
try {
	Class.forName("org.postgresql.Driver");
	String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

	Connection conn = DriverManager.getConnection(connURL);

	String serviceIdParam = request.getParameter("serviceId"); //actual one
	if (serviceIdParam != null) {
		try {
	int service_id = Integer.parseInt(serviceIdParam);
	// 	int service_id = 1; //dummy service
	String sqlStr = "SELECT * FROM services WHERE service_id = ?";
	PreparedStatement pstmt1 = conn.prepareStatement(sqlStr);
	pstmt1.setInt(1, service_id);
	ResultSet service = pstmt1.executeQuery();

	while (service.next()) {
		String service_name = service.getString("service_name");
		int service_img_id = service.getInt("service_img_id");
%>

<title><%=service_name%></title>
<!-- CSS file -->
<link rel="stylesheet" href="./css/serviceDetailsStyle.css">

<!-- Bootstrap CSS -->
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet"
  integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
  crossorigin="anonymous">
<link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
  <%@ include file="header.jsp"%>
  <%
  sqlStr = "SELECT * FROM service_categories WHERE service_category_id = ?";
  PreparedStatement pstmt2 = conn.prepareStatement(sqlStr);
  pstmt2.setInt(1, service.getInt("service_category_id"));
  ResultSet s_category = pstmt2.executeQuery();
  String category_name = "";
  while (s_category.next()) {
  	category_name = s_category.getString("category_name");
  }
  sqlStr = "SELECT * FROM service_images WHERE service_img_id = ?";
  PreparedStatement pstmtImgName = conn.prepareStatement(sqlStr);
  pstmtImgName.setInt(1, service.getInt("service_img_id"));
  ResultSet serviceImgName = pstmtImgName.executeQuery();
  String service_img_name = "";
  while(serviceImgName.next()){
	  service_img_name = serviceImgName.getString("service_img_name");
  }
  %>
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
    <path fill="#b3d7f1" fill-opacity="1"
      d="M0,288L20,282.7C40,277,80,267,120,266.7C160,267,200,277,240,266.7C280,256,320,224,360,197.3C400,171,440,149,480,149.3C520,149,560,171,600,181.3C640,192,680,192,720,176C760,160,800,128,840,133.3C880,139,920,181,960,176C1000,171,1040,117,1080,112C1120,107,1160,149,1200,154.7C1240,160,1280,128,1320,122.7C1360,117,1400,139,1420,149.3L1440,160L1440,0L1420,0C1400,0,1360,0,1320,0C1280,0,1240,0,1200,0C1160,0,1120,0,1080,0C1040,0,1000,0,960,0C920,0,880,0,840,0C800,0,760,0,720,0C680,0,640,0,600,0C560,0,520,0,480,0C440,0,400,0,360,0C320,0,280,0,240,0C200,0,160,0,120,0C80,0,40,0,20,0L0,0Z"></path></svg>
  <div class="w-100 pb-5 text-primary position-relative">
    <div class="container d-flex flex-column align-items-end text-end">
      <!-- Service Details -->
      <div>
        <h1 class="display-5 fw-bold text-uppercase"><%=service_name%></h1>
        <h3 class="fw-normal text-dark mb-3"><%=category_name%></h3>
      </div>
      <!-- Call-to-Action -->
      <div>
        <a class="btn btn-primary btn-lg px-4 py-2 rounded-pill"
          href="<%=(memId == null) ? "loginPage.jsp" : "booking_page.jsp?serviceId=" + service_id%>">
          Book Now </a>
      </div>
    </div>
  </div>


  <!-- Service -->
  <div class="container my-5 py-5">
    <div class="row align-items-center">
      <!-- Card Column -->
      <div class="col-md-8">
        <div class="card-service shadow-lg border-primary">
          <div class="card-body">
            <!-- Title -->
            <h5 class="card-title fw-bold display-6"><%=service_name%></h5>
            <!-- Description -->
            <p class="card-text text-muted mt-3"><%=service.getString("service_description")%></p>
          </div>
        </div>
      </div>
      <!-- Image Column -->
      <div class="col-md-4 text-center">
        <img src="./service_images/<%=service_img_name%>"
          alt="<%=service_name%> Image"
          class="rounded-circle shadow-lg img-fluid"
          style="max-width: 200px; height: auto;">
      </div>
    </div>
  </div>


  <!-- Services Details -->
  <%
  sqlStr = "SELECT * FROM service_pricing WHERE pricing_id = ?";
  PreparedStatement pstmt3 = conn.prepareStatement(sqlStr);
  pstmt3.setInt(1, service_id);
  ResultSet pricing = pstmt3.executeQuery();
  double base_price = 0;
  double base_duration = 0;
  if (pricing.next()) {
  	base_price = pricing.getDouble("base_price");
  	base_duration = pricing.getDouble("base_duration");
  }
  sqlStr = "SELECT * FROM included_service_items AS isi INNER JOIN service_items AS si ON isi.service_item_id = si.service_item_id WHERE service_id = ?";
  PreparedStatement pstmt4 = conn.prepareStatement(sqlStr);
  pstmt4.setInt(1, service_id);
  ResultSet s_items = pstmt4.executeQuery();
  ArrayList<String> service_items = new ArrayList<String>();
  while (s_items.next()) {
  	service_items.add(s_items.getString("item_name"));
  }
  %>
  <div
    class="container-fluid my-5 py-5 d-flex justify-content-center align-items-center bg-white">
    <div class="card card-details text-center p-4" style="width: 80%; background-color: #b3d7f1;">
      <div class="row">
        <div class="col-lg-6 p-3">
          <h5>Starting from</h5>
          <p><%=String.format("$ %.2f", base_price)%></p>
          <h5>Service Duration</h5>
          <p><%=String.format("%.2f hr(s)", base_duration)%></p>
        </div>
        <div class="col-lg-1 d-none d-lg-block border-end"></div>
        <div class="col-lg-5 p-3">
          <h5>What's included:</h5>
          <ul>
            <%
            for (String item : service_items) {
            %>
            <li><%=item%></li>
            <%
            }
            %>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <%-- Customer Service --%>
  <%
  //Get the Reviews
  sqlStr = "SELECT first_name,last_name,rating,feedback FROM feedbacks AS f INNER JOIN bookings AS b ON f.booking_id = b.booking_id INNER JOIN customers AS c ON b.customer_id = c.customer_id INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id WHERE bd.services_id = ?";
  PreparedStatement pstmt5 = conn.prepareStatement(sqlStr);
  pstmt5.setInt(1, service_id);
  ResultSet feedbacks = pstmt5.executeQuery();
  ArrayList<CustomerReview> reviews = new ArrayList<CustomerReview>();
  while (feedbacks.next()) {
  	String name = feedbacks.getString("first_name") + " " + feedbacks.getString("last_name");
  	int rating = Integer.parseInt(feedbacks.getString("rating"));
  	String feedback = feedbacks.getString("feedback");
  	CustomerReview review = new CustomerReview(name, rating, feedback);
  	reviews.add(review);
  }
  %>
  <div class="container mb-5 pb-5">
    <div class="row mb-3">
      <div class="col text-center">
        <h3>Customer Reviews</h3>
      </div>
    </div>

    <div class="row">
      <%
      if (reviews.size() <= 3) {
      %>
      <div class="col-md-1">
        <button type="button" data-bs-target="#customerReviews"
          data-bs-slide="prev">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30"
            fill="#615d5d" class="bi bi-caret-left-fill"
            viewBox="0 0 16 16">
  <path
              d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z" />
</svg>
          <span class="visually-hidden">Previous</span>
        </button>
      </div>

      <div class="col">
        <div id="customerReviews" class="carousel slide"
          data-bs-ride="carousel">
          <div class="carousel-inner">
            <div class="row">
              <div class="col-md-2"></div>
              <%
              for (int j = 0; j < reviews.size(); j++) {
              	CustomerReview currentReview = reviews.get(j);
              %>
              <div class="carousel-item <%=(j == 0) ? "active" : ""%>">

                <div class="col-md-8">
                  <div class="card text-center">
                    <div class="card-header text-white" style="background-color: #b3d7f1;">
                      <h5 class="card-title"><%=currentReview.getName()%></h5>
                    </div>
                    <div class="card-body">
                      <p class="card-text">
                        Rating:
                        <%=StarRatingUtil.generateStarRating(currentReview.getRating())%>
                      </p>

                      <p class="card-text"><%=currentReview.getFeedback()%></p>
                    </div>
                  </div>


                </div>

              </div>
              <%
              }
              %>
              <div class="col-md-2"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-1">
        <button type="button" data-bs-target="#customerReviews"
          data-bs-slide="next">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30"
            fill="#615d5d" class="bi bi-caret-right-fill"
            viewBox="0 0 16 16">
              <path
              d="m12.14 8.753-5.482 4.796c-.646.566-1.658.106-1.658-.753V3.204a1 1 0 0 1 1.659-.753l5.48 4.796a1 1 0 0 1 0 1.506z" />
</svg>
          <span class="visually-hidden">Next</span>
        </button>
      </div>
      <%
      } else {
      %>
      <div class="col-md-1">
        <button type="button" data-bs-target="#customerReviews"
          data-bs-slide="prev">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30"
            fill="#615d5d" class="bi bi-caret-left-fill"
            viewBox="0 0 16 16">
  <path
              d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z" />
</svg>
          <span class="visually-hidden">Previous</span>
        </button>
      </div>

      <div class="col">
        <div id="customerReviews"
          class="carousel slide position-relative"
          data-bs-ride="carousel">
          <div class="carousel-inner">
            <%
            for (int i = 0; i < (reviews.size() - 2); i++) {
            %>
            <div class="carousel-item <%=(i == 0) ? "active" : ""%>">
              <div class="row">
                <%
                for (int j = i; j < i + 3 && j < reviews.size(); j++) {
                	CustomerReview currentReview = reviews.get(j);
                %>
                <div class="col-md-4">
                  <div class="card text-center">
                    <div class="card-header bg-primary text-white">
                      <h5 class="card-title"><%=currentReview.getName()%></h5>
                    </div>
                    <div class="card-body">
                      <p class="card-text">
                        Rating:
                        <%=StarRatingUtil.generateStarRating(currentReview.getRating())%></p>
                      <p class="card-text"><%=currentReview.getFeedback()%></p>
                    </div>
                  </div>
                </div>
                <%
                }
                %>
              </div>
            </div>
            <%
            }
            for (int i = (reviews.size() - 2); i < reviews.size(); i++) {
            %>
            <div class="carousel-item">
              <div class="row">
                <%
                for (int j = 0; j < 3; j++) {
                	CustomerReview currentReview = reviews.get((i + j) % reviews.size());
                %>
                <div class="col-md-4">
                  <div class="card text-center">
                    <div class="card-header bg-primary text-white">
                      <h5 class="card-title"><%=currentReview.getName()%></h5>
                    </div>
                    <div class="card-body">
                      <p class="card-text">
                        Rating:
                        <%=StarRatingUtil.generateStarRating(currentReview.getRating())%></p>
                      <p class="card-text"><%=currentReview.getFeedback()%></p>
                    </div>
                  </div>
                </div>
                <%
                }
                %>
              </div>
            </div>
            <%
            }
            %>
          </div>
        </div>
      </div>

      <%-- Next Button --%>
      <div class="col-md-1">
        <button type="button" data-bs-target="#customerReviews"
          data-bs-slide="next">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30"
            fill="#615d5d" class="bi bi-caret-right-fill"
            viewBox="0 0 16 16">
              <path
              d="m12.14 8.753-5.482 4.796c-.646.566-1.658.106-1.658-.753V3.204a1 1 0 0 1 1.659-.753l5.48 4.796a1 1 0 0 1 0 1.506z" />
</svg>
          <span class="visually-hidden">Next</span>
        </button>
      </div>

      <%
      }
      %>
    </div>

  </div>

  <%
  //get other services from category
  sqlStr = "SELECT * FROM services INNER JOIN service_images ON services.service_img_id = service_images.service_img_id WHERE service_category_id = ? AND service_id != ?";
  PreparedStatement pstmt6 = conn.prepareStatement(sqlStr);
  pstmt6.setInt(1, service.getInt("service_category_id"));
  pstmt6.setInt(2, service_id);
  ResultSet services = pstmt6.executeQuery();
  HashMap<Integer, String> related_services = new HashMap<>();
  HashMap<Integer, String> services_img = new HashMap<>();
  while (services.next()) {
  	related_services.put(services.getInt("service_id"), services.getString("service_name"));
  	services_img.put(services.getInt("service_id"), services.getString("service_img_name"));
  }
  %>

  <!-- Related Services -->
  <div style="background-color: #b3d7f1;">
  <div class="container py-4 mt-4" >
    <div class="row mb-4">
      <div class="col text-center">
        <h3 class="fw-bold">Related Services</h3>
      </div>
    </div>

    <div class="row">
      <div class="col-1">
        <button class="carousel-control" type="button"
          data-bs-target="#carouselRelatedServices" data-bs-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Previous</span>
        </button>
      </div>
      <div class="col">
        <div id="carouselRelatedServices" class="carousel slide"
          data-bs-ride="carousel">
          <div class="carousel-inner">
            <%
            int itemCount = 0; // Counter to track active items
            for (Integer i : related_services.keySet()) {
            	if (itemCount % 4 == 0) { // Group 3 cards per carousel-item
            %>
            <div
              class="carousel-item <%=(itemCount == 0) ? "active" : ""%>">
              <div class="row justify-content-center">
                <%
                }
                %>
                <div class="col-md-3">
                  <div class="card shadow-sm py-3"
                    style="width: 100%; height: auto;">
                    <img class="card-img-top rounded-circle"
                      src="./service_images/<%=services_img.get(i)%>"
                      alt="Service Image"
                      style="width: 150px; height: 150px; object-fit: cover; margin: auto;">
                    <div class="card-body d-flex flex-column">
                      <h5 class="card-title text-center"><%=related_services.get(i)%></h5>
                      <a href="servicePage.jsp?serviceId=<%=i%>"
                        class="btn btn-primary mt-auto">See More</a>
                    </div>
                  </div>
                </div>
                <%
                itemCount++;
                if (itemCount % 4 == 0 || itemCount == related_services.size()) {
                %>
              </div>
            </div>
            <%
            }
            }
            %>
          </div>
        </div>
      </div>
      <div class="col-1">
        <button class="carousel-control" type="button"
          data-bs-target="#carouselRelatedServices" data-bs-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Next</span>
        </button>
      </div>
    </div>
</div>
  </div>

  <%
  conn.close();
  }
  } catch (Exception e) {
  out.println("Error" + e);
  }
  } else {
  response.sendRedirect("available_services.jsp"); 
  }
  } catch (Exception e) {
  out.println("Error" + e);
  }
  %>

  <!-- Bootstrap JS, Popper.js, and jQuery (required for some Bootstrap components) -->
  <script
    src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
    crossorigin="anonymous"></script>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
    integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    crossorigin="anonymous"></script>
    <%@ include file="footer.html"%>
</body>
</html>