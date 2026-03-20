<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ page import="java.util.ArrayList,java.sql.Timestamp" %>
<%@ page import="ServicesAndFeedbacks.Cart_item" %>
<%@ page import="java.sql.*, java.net.*, java.io.*, java.util.Scanner" %> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <%
    
	if (session.getAttribute("memId") == null || session.getAttribute("sessionCart") == null || session.getAttribute("transactionId") ==  null) {
		response.sendRedirect("home.jsp");
		return;
	}

	int customerId = (int) session.getAttribute("memId");
    @SuppressWarnings("unchecked")
    ArrayList<Cart_item> Cart = (ArrayList<Cart_item>) session.getAttribute("sessionCart");
    int transactionId = (int) session.getAttribute("transactionId");
    
    // testing 
    for (Cart_item item: Cart){
		System.out.println(item.toJson());
	}
    
 	// Call API to create transaction
    URL url = new URL("http://localhost:8082/shinshin/processPaymentAndCart");
    HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
    httpConn.setRequestMethod("POST");
    httpConn.setRequestProperty("Content-Type", "application/json");
    httpConn.setDoOutput(true);
    
    // Construct Cart JSON Array
    StringBuilder cartJsonBuilder = new StringBuilder("[");
    for (Cart_item item : Cart) {
        cartJsonBuilder.append(item.toJson()).append(",");
    }
    
    // Remove last comma if there are items in the cart
    if (!Cart.isEmpty()) {
        cartJsonBuilder.deleteCharAt(cartJsonBuilder.length() - 1);
    }
    cartJsonBuilder.append("]");
    
    // Create JSON payload
    String jsonString = "{"
        + "\"CustomerID\": " + customerId + ","
        + "\"TransactionID\": " + transactionId + ","
        + "\"CartItems\": " + cartJsonBuilder.toString()
        + "}";

    // Send JSON request
    try (OutputStream os = httpConn.getOutputStream()) {
        byte[] input = jsonString.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        os.write(input, 0, input.length);
    }
    
 	// Get the response
    String responseMessage = "";
    if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
        try (Scanner scanner = new Scanner(httpConn.getInputStream(), "UTF-8")) {
            if (scanner.hasNext()) {
                responseMessage = scanner.nextLine().trim();  // Read full response
            }
        }
    }

    // Log or display response message
    System.out.println("Response from API: " + responseMessage);

    session.removeAttribute("sessionCart");
    session.removeAttribute("transactionId");
    %>
    <!-- Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="successModalLabel">Booking Successful</h5>
                </div>
                <div class="modal-body text-center">
                    <p>Your items has been successfully booked.</p>
                    <p>What would you like to do next?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="redirectToBrowse()">Browse Other Services</button>
                    <button type="button" class="btn btn-primary" onclick="redirectToHome()">Back To Home</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Show the modal immediately when the page loads
            $('#successModal').modal('show');
        });

        function redirectToBrowse() {
            window.location.href = "available_services.jsp"; // Update with your JSP for browsing services
        }

        function redirectToHome() {
            window.location.href = "home.jsp"; // Update with your JSP for checkout
        }
    </script>
</body>
</html>
