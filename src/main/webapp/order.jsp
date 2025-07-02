<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
/>

<jsp:useBean id='db'
             scope='page'
             class='shop.ShopDB' />

<html>
<head>
    <title>Art Gallery Shop - Order Confirmation</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="am_styles.css">
</head>
<body>
<div class="am_container">
    <!-- Include common header -->
    <jsp:include page="header.jsp" />

    <% String custName = request.getParameter("name");

        if (custName != null && !custName.trim().isEmpty()) {
            // order the basket of items!
            db.order(basket, custName);
            // then empty the basket
            basket.clearBasket();
    %>
    <div class="am_confirmation">
        <h2>Order Confirmation</h2>
        <p>Dear <%= custName %>, thank you for your order!</p>
        <p>Your order has been successfully placed and will be processed shortly.</p>

        <div class="am_action_buttons">
            <a href="products.jsp" class="am_button primary">Continue shopping</a>
        </div>
    </div>
    <%
    }
    else {
    %>
    <div class="am_confirmation">
        <h2>Error</h2>
        <p>Please go back and supply your name to complete the order.</p>
        <a href="basket.jsp" class="am_button">Return to basket</a>
    </div>
    <%
        }
    %>
</div>
</body>
</html>