<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<%
// Check if user is logged in
if (session.getAttribute("sessUserId") == null) {
    response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
    return;
}

// Get the item ID to remove
String itemId = request.getParameter("itemId");

if (itemId == null || itemId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=invalid_item");
    return;
}

// Get cart from session
@SuppressWarnings("unchecked")
ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");

if (cart != null) {
    // Find and remove the item
    boolean removed = false;
    Iterator<CartItem> iterator = cart.iterator();
    while (iterator.hasNext()) {
        CartItem item = iterator.next();
        if (item.getCartItemId().equals(itemId)) {
            iterator.remove();
            removed = true;
            break;
        }
    }

    // Update session
    session.setAttribute("shoppingCart", cart);

    if (removed) {
        response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?success=removed");
    } else {
        response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=item_not_found");
    }
} else {
    response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=cart_empty");
}
%>
