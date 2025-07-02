package shop;

import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.text.DecimalFormat;

/**
 * This version of Basket uses a HashMap to store product quantities
 * but avoids using inner classes that can cause deployment issues
 */
public class Basket {

    private Map<String, Integer> quantities; // Map of PID to quantity
    private ShopDB db;

    public Basket() {
        db = ShopDB.getSingleton();
        quantities = new HashMap<String, Integer>();
    }

    /**
     * @return Collection of Product items that are stored in the basket
     */
    public Collection<Product> getItems() {
        ArrayList<Product> items = new ArrayList<Product>();

        for (String pid : quantities.keySet()) {
            Product p = db.getProduct(pid);
            // Add the product multiple times based on quantity
            int qty = quantities.get(pid);
            for (int i = 0; i < qty; i++) {
                items.add(p);
            }
        }

        return items;
    }

    /**
     * Get a map of product IDs to quantities
     * @return Map with product ID keys and quantity values
     */
    public Map<String, Integer> getQuantities() {
        return quantities;
    }

    /**
     * Get the quantity of a specific product
     * @param pid - the product ID
     * @return the quantity, or 0 if not in basket
     */
    public int getQuantity(String pid) {
        Integer qty = quantities.get(pid);
        return (qty == null) ? 0 : qty;
    }

    /**
     * Get total price for a specific product based on quantity
     * @param pid - the product ID
     * @return total price in pence for this product
     */
    public int getProductTotal(String pid) {
        Product p = db.getProduct(pid);
        if (p == null) return 0;

        int qty = getQuantity(pid);
        return p.price * qty;
    }

    /**
     * Format product total as pounds/pence string
     * @param pid - the product ID
     * @return formatted price string
     */
    public String getProductTotalString(String pid) {
        double totalPounds = getProductTotal(pid) / 100.0;
        DecimalFormat df = new DecimalFormat("0.00");
        return df.format(totalPounds);
    }

    /**
     * Empty the basket - the basket should contain no items after calling this method
     */
    public void clearBasket() {
        quantities.clear();
    }

    /**
     * Adds an item specified by its product code to the shopping basket
     * @param pid - the product code
     */
    public void addItem(String pid) {
        if (pid != null) {
            Product p = db.getProduct(pid);
            if (p != null) {
                Integer currentQty = quantities.get(pid);
                if (currentQty == null) {
                    quantities.put(pid, 1);
                } else {
                    quantities.put(pid, currentQty + 1);
                }
            }
        }
    }

    /**
     * Add a product to the basket
     * @param p - the product to add
     */
    public void addItem(Product p) {
        if (p != null) {
            addItem(p.PID);
        }
    }

    /**
     * Remove an item from the basket
     * @param pid - the product ID to remove
     */
    public void removeItem(String pid) {
        if (pid != null) {
            quantities.remove(pid);
        }
    }

    /**
     * Update the quantity of an item in the basket
     * @param pid - the product ID to update
     * @param quantity - the new quantity
     */
    public void updateQuantity(String pid, int quantity) {
        if (pid != null) {
            if (quantity <= 0) {
                // Remove item if quantity is zero or negative
                quantities.remove(pid);
            } else {
                // Only update if product exists
                Product p = db.getProduct(pid);
                if (p != null) {
                    quantities.put(pid, quantity);
                }
            }
        }
    }

    /**
     * @return the total value of items in the basket in pence
     */
    public int getTotal() {
        int total = 0;

        for (String pid : quantities.keySet()) {
            Product p = db.getProduct(pid);
            int qty = quantities.get(pid);
            total += p.price * qty;
        }

        return total;
    }

    /**
     * @return the total value of items in the basket as
     * a pounds and pence String with exactly two decimal places
     */
    public String getTotalString() {
        double totalPounds = getTotal() / 100.0;
        DecimalFormat df = new DecimalFormat("0.00");
        return df.format(totalPounds);
    }
}