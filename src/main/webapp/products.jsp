<%@ page import="shop.Product"%>
<%@ page import="java.text.DecimalFormat"%>

<jsp:useBean id='db'
             scope='session'
             class='shop.ShopDB' />

<html>
<head>
    <title>Art Gallery Shop - Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="am_styles.css">
</head>
<body>
<div class="am_container">
    <!-- Include common header -->
    <jsp:include page="header.jsp" />

    <h2>Browse Our Collection</h2>

    <table class="am_products_table">
        <tr>
            <th>Title</th>
            <th>Artist</th>
            <th>Price</th>
            <th>Preview</th>
        </tr>
        <%
            DecimalFormat df = new DecimalFormat("0.00");
            for (Product product : db.getAllProducts()) {
                // Format the price from pence to pounds with 2 decimal places
                double pricePounds = product.price / 100.0;
                String formattedPrice = df.format(pricePounds);

        %>
        <tr>
            <td><a href="viewProduct.jsp?pid=<%= product.PID %>"><%= product.title %></a></td>
            <td><%= product.artist %></td>
            <td class="am_price">&pound;<%= formattedPrice %></td>
            <td><a href="viewProduct.jsp?pid=<%= product.PID %>">
                <img src="<%= product.thumbnail %>" alt="<%= product.title %>" /></a>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <div class="am_action_buttons">
        <a href="basket.jsp" class="am_button">View Basket</a>
    </div>
</div>
</body>
</html>