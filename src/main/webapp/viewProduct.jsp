<%@ page import="shop.Product"%>
<%@ page import="java.text.DecimalFormat"%>

<jsp:useBean id='db'
             scope='session'
             class='shop.ShopDB' />

<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket' />

<%
    // Handle adding item to basket with PRG pattern to prevent duplicates on refresh
    String addItem = request.getParameter("addToBasket");
    if (addItem != null) {
        basket.addItem(addItem);
        response.sendRedirect("basket.jsp");
        return; // Stop further processing
    }
%>

<html>
<head>
    <title>Art Gallery Shop - Product Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="am_styles.css">
</head>
<body>
<div class="am_container">
    <!-- Include common header -->
    <jsp:include page="header.jsp" />

    <%
        String pid = request.getParameter("pid");
        Product product = db.getProduct(pid);

        if (product == null) {
    %>
    <div class="am_empty_message">
        <h2>Product not found</h2>
        <p><a href="products.jsp" class="am_button">Return to product list</a></p>
    </div>
    <%
    }
    else {
        DecimalFormat df = new DecimalFormat("0.00");
        double priceInPounds = product.price / 100.0;
    %>
    <div class="am_product_view">
        <h2><%= product.title %></h2>
        <h3>by <%= product.artist %></h3>

        <img src="<%= product.fullimage %>" class="am_product_image" alt="<%= product.title %>" />

        <div class="am_product_info">
            <p class="am_product_description"><%= product.description %></p>
            <p class="am_product_price">Price: &pound;<%= df.format(priceInPounds) %></p>

            <!-- Use form with POST to avoid URL parameters that can cause double-adds on refresh -->
            <form method="post" action="viewProduct.jsp">
                <input type="hidden" name="pid" value="<%= product.PID %>">
                <input type="hidden" name="addToBasket" value="<%= product.PID %>">
                <input type="submit" value="Add to basket" class="am_button primary">
            </form>

            <div class="am_action_buttons">
                <a href="products.jsp" class="am_button">Back to products</a>
                <a href="basket.jsp" class="am_button">View basket</a>
            </div>
        </div>
    </div>
    <%
        }
    %>
</div>
</body>
</html>