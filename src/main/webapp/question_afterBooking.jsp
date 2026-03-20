<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    
    <!-- Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="successModalLabel">Adding to Cart Successful</h5>
                </div>
                <div class="modal-body text-center">
                    <p>Your booking has been added to the cart.</p>
                    <p>What would you like to do next?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="redirectToBrowse()">Browse Other Services</button>
                    <button type="button" class="btn btn-primary" onclick="redirectToCheckout()">Go to Checkout</button>
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

        function redirectToCheckout() {
            window.location.href = "checkout_page.jsp"; // Update with your JSP for checkout
        }
    </script>
</body>
</html>
