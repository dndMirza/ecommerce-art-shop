package shop;

import java.sql.*;
import java.util.Collection;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.Map;

public class ShopDB {

    Connection con;
    static int nOrders = 0;
    static ShopDB singleton;

    // Keep your original connection string here
    public ShopDB() {
        try {
            Class.forName("org.hsqldb.jdbc.JDBCDriver");
            System.out.println("loaded class");
            con = DriverManager.getConnection("jdbc:hsqldb:file:\\\\tomcat\\\\webapps\\\\ass2\\\\shopdb", "sa", "");
            System.out.println("created con");
        } catch (Exception e) {
            System.out.println("Exception: " + e);
            e.printStackTrace();
        }
    }

    public static ShopDB getSingleton() {
        if (singleton == null) {
            singleton = new ShopDB();
        }
        return singleton;
    }

    public Collection<Product> getAllProducts() {
        return getProductCollection("Select * from Product");
    }

    public Product getProduct(String pid) {
        try {
            // re-use the getProductCollection method
            // even though we only expect to get a single Product Object
            String query = "Select * from Product where PID = '" + pid + "'";
            Collection<Product> c = getProductCollection(query);
            Iterator<Product> i = c.iterator();
            return i.next();
        }
        catch(Exception e) {
            // unable to find the product matching that pid
            return null;
        }
    }

    public Collection<Product> getProductCollection(String query) {
        LinkedList<Product> list = new LinkedList<Product>();
        try {
            Statement s = con.createStatement();

            ResultSet rs = s.executeQuery(query);
            while (rs.next()) {
                Product product = new Product(
                        rs.getString("PID"),
                        rs.getString("Artist"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getInt("price"),
                        rs.getString("thumbnail"),
                        rs.getString("fullimage")
                );
                list.add(product);
            }
            return list;
        }
        catch(Exception e) {
            System.out.println("Exception in getProductCollection(): " + e);
            e.printStackTrace();
            return null;
        }
    }

    public void order(Basket basket, String customerName) {
        try {
            // create a unique order id
            String orderId = System.currentTimeMillis() + ":" + nOrders++;

            // Get the quantities map from basket
            Map<String, Integer> quantities = basket.getQuantities();

            // Process each product with its quantity
            for (String pid : quantities.keySet()) {
                Product product = getProduct(pid);
                int quantity = quantities.get(pid);

                // Place the order for this product with its quantity
                order(con, product, orderId, customerName, quantity);
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }

    private void order(Connection con, Product p, String orderId, String customerName, int quantity) throws Exception {
        // Using prepared statement to prevent SQL injection
        String sql = "INSERT INTO Orders (OrderID, PID, CustomerName, Quantity, Price) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, orderId);
        pstmt.setString(2, p.PID);
        pstmt.setString(3, customerName);
        pstmt.setInt(4, quantity);
        pstmt.setInt(5, p.price); // Store the individual product price

        pstmt.executeUpdate();
        pstmt.close();
    }

    /**
     * Search for products within a price range
     * @param minPricePounds Minimum price in pounds (will be converted to pence)
     * @param maxPricePounds Maximum price in pounds (will be converted to pence)
     * @return Collection of Product objects in the price range
     */
    public Collection<Product> searchByPriceRange(int minPricePounds, int maxPricePounds) {
        try {
            // Convert pounds to pence for database query
            int minPricePence = minPricePounds * 100;
            int maxPricePence = maxPricePounds * 100;

            // Create prepared statement with parameters
            String query = "SELECT * FROM Product WHERE price >= ? AND price <= ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setInt(1, minPricePence);
            pstmt.setInt(2, maxPricePence);

            // Execute query and get results
            ResultSet rs = pstmt.executeQuery();

            // Create collection to hold products
            LinkedList<Product> list = new LinkedList<Product>();

            // Process results
            while (rs.next()) {
                Product product = new Product(
                        rs.getString("PID"),
                        rs.getString("Artist"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getInt("price"),
                        rs.getString("thumbnail"),
                        rs.getString("fullimage")
                );
                list.add(product);
            }

            // Close resources
            rs.close();
            pstmt.close();

            return list;
        }
        catch(Exception e) {
            System.out.println("Exception in searchByPriceRange(): " + e);
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Search for products whose title contains a given string (case-insensitive)
     * @param searchTerm The string to search for in product titles
     * @return Collection of Product objects matching the search
     */
    public Collection<Product> searchByTitle(String searchTerm) {
        try {
            // Create prepared statement with LIKE operator for case-insensitive substring search
            String query = "SELECT * FROM Product WHERE LOWER(title) LIKE ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, "%" + searchTerm.toLowerCase() + "%");

            // Execute query and get results
            ResultSet rs = pstmt.executeQuery();

            // Create collection to hold products
            LinkedList<Product> list = new LinkedList<Product>();

            // Process results
            while (rs.next()) {
                Product product = new Product(
                        rs.getString("PID"),
                        rs.getString("Artist"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getInt("price"),
                        rs.getString("thumbnail"),
                        rs.getString("fullimage")
                );
                list.add(product);
            }

            // Close resources
            rs.close();
            pstmt.close();

            return list;
        }
        catch(Exception e) {
            System.out.println("Exception in searchByTitle(): " + e);
            e.printStackTrace();
            return null;
        }
    }
}