<%@ page import="shop.Product,
                 java.util.Collection,
                 java.util.Iterator,
                 java.text.DecimalFormat"
%>

<jsp:useBean id='db'
             scope='session'
             class='shop.ShopDB' />

<%
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");

    // Initialize variables
    int minPrice = 0;
    int maxPrice = Integer.MAX_VALUE;
    boolean validInput = true;
    String errorMessage = "";

    // Server-side validation in case JavaScript is disabled
    try {
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            minPrice = Integer.parseInt(minPriceStr);
            if (minPrice < 0) {
                validInput = false;
                errorMessage = "Minimum price cannot be negative";
            }
        }

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            maxPrice = Integer.parseInt(maxPriceStr);
            if (maxPrice < 0) {
                validInput = false;
                errorMessage = "Maximum price cannot be negative";
            }
        }

        if (minPrice > maxPrice) {
            validInput = false;
            errorMessage = "Minimum price must be less than or equal to maximum price";
        }
    } catch (NumberFormatException e) {
        validInput = false;
        errorMessage = "Invalid price values. Please enter numbers only.";
    }

    // Only perform search if input is valid
    Collection<Product> searchResults = null;
    if (validInput) {
        searchResults = db.searchByPriceRange(minPrice, maxPrice);
    }
%>

<html>
<head>
    <title>Art Gallery Shop - Price Search Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="am_styles.css">
</head>
<body>
<div class="am_container">
    <!-- Include common header -->
    <jsp:include page="header.jsp" />

    <h2>Search Results</h2>

    <div class="am_search_results_header">
        <h3>Products between &pound;<%= minPrice %> and &pound;<%= maxPrice %></h3>
    </div>

    <% if (!validInput) { %>
    <div class="am_error_message">
        <p><%= errorMessage %></p>
        <a href="search.jsp" class="am_button">Back to Search</a>
    </div>
    <% } else if (searchResults == null || searchResults.isEmpty()) { %>
    <div class="am_empty_message">
        <p>No products found in the price range &pound;<%= minPrice %> to &pound;<%= maxPrice %>.</p>
        <a href="search.jsp" class="am_button">Back to Search</a>
    </div>
    <% } else { %>
    <table class="am_products_table">
        <tr>
            <th>Title</th>
            <th>Artist</th>
            <th>Price</th>
            <th>Preview</th>
        </tr>
        <%
            DecimalFormat df = new DecimalFormat("0.00");
            Iterator<Product> iterator = searchResults.iterator();
            while (iterator.hasNext()) {
                Product product = iterator.next();
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
        <a href="search.jsp" class="am_button">New Search</a>
        <a href="products.jsp" class="am_button">View All Products</a>
    </div>
    <% } %>
</div>
</body>
</html>