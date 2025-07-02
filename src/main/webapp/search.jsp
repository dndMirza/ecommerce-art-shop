<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Art Gallery Shop - Search</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="am_styles.css">
    <script type="text/javascript">
        function validatePriceSearch() {
            var minPrice = document.forms["priceSearchForm"]["minPrice"].value;
            var maxPrice = document.forms["priceSearchForm"]["maxPrice"].value;

            // Check if values are numbers
            if (isNaN(minPrice) || isNaN(maxPrice)) {
                alert("Please enter valid numbers for price range");
                return false;
            }

            // Check if min is less than max
            if (parseInt(minPrice) > parseInt(maxPrice)) {
                alert("Minimum price must be less than or equal to maximum price");
                return false;
            }

            // Check if values are positive
            if (parseInt(minPrice) < 0 || parseInt(maxPrice) < 0) {
                alert("Prices cannot be negative");
                return false;
            }

            return true;
        }

        function validateTitleSearch() {
            var searchTerm = document.forms["titleSearchForm"]["searchTerm"].value;

            if (searchTerm.trim().length < 3) {
                alert("Search term must be at least 3 characters long");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
<div class="am_container">
    <!-- Include common header -->
    <jsp:include page="header.jsp" />

    <h2>Search Our Artwork Collection</h2>

    <div class="am_search_section">
        <h3>Search by Price Range</h3>
        <form name="priceSearchForm" action="searchByPrice.jsp" method="get" onsubmit="return validatePriceSearch()">
            <div class="am_search_form">
                <label for="minPrice">Minimum Price (£):</label>
                <input type="number" id="minPrice" name="minPrice" min="0" required class="am_search_input">

                <label for="maxPrice">Maximum Price (£):</label>
                <input type="number" id="maxPrice" name="maxPrice" min="0" required class="am_search_input">

                <input type="submit" value="Search by Price" class="am_button">
            </div>
        </form>
    </div>

    <div class="am_search_section">
        <h3>Search by Title</h3>
        <form name="titleSearchForm" action="searchByTitle.jsp" method="get" onsubmit="return validateTitleSearch()">
            <div class="am_search_form">
                <label for="searchTerm">Title contains:</label>
                <input type="text" id="searchTerm" name="searchTerm" required class="am_search_input">
                <p class="am_search_hint">(Minimum 3 characters)</p>

                <input type="submit" value="Search by Title" class="am_button">
            </div>
        </form>
    </div>

    <div class="am_action_buttons">
        <a href="products.jsp" class="am_button">View All Products</a>
    </div>
</div>
</body>
</html>