<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Account Settings"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card" style="margin-top: 20px; padding: 20px;">
                <h2 class="text-center mb-4">Account Settings</h2>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/settings" method="post">
                    
                    <div class="form-group mb-3">
                        <label>Username</label>
                        <input type="text" class="form-control" value="${user.username}" readonly disabled style="background-color: #e9ecef;">
                        <small class="text-muted">Username cannot be changed.</small>
                    </div>

                    <div class="form-group mb-3">
                        <label for="name">Full Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="${user.name}" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="email">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="phone">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}">
                    </div>

                    <div class="form-group mb-3">
                        <label for="address">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="2">${user.address}</textarea>
                    </div>

                    <div class="form-group mb-3">
                        <label for="relationship">Relationship to Care Recipient</label>
                        <select class="form-control" id="relationship" name="relationship">
                            <option value="Self" ${user.relationship == 'Self' ? 'selected' : ''}>Self</option>
                            <option value="Child" ${user.relationship == 'Child' ? 'selected' : ''}>Child</option>
                            <option value="Parent" ${user.relationship == 'Parent' ? 'selected' : ''}>Parent</option>
                            <option value="Spouse" ${user.relationship == 'Spouse' ? 'selected' : ''}>Spouse</option>
                            <option value="Other" ${user.relationship == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="care_notes">Care Notes</label>
                        <textarea class="form-control" id="care_notes" name="care_notes" rows="3" placeholder="Any special needs or instructions...">${user.careNotes}</textarea>
                    </div>

                    <hr>
                    
                    <div class="form-group mb-3">
                        <label for="password">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="********">
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
                        <a href="${pageContext.request.contextPath}/customer/customerHome.jsp" class="btn btn-secondary btn-block">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
