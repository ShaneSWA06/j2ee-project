<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Create Caregiver"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Create New Caregiver</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<form method="post" action="${pageContext.request.contextPath}/admin/caregiver?action=create" class="form" enctype="multipart/form-data">
<div class="form-group">
<label for="name">Name</label>
<input type="text" id="name" name="name" required>
</div>
<div class="form-group">
<label for="qualifications">Qualifications (comma separated)</label>
<textarea id="qualifications" name="qualifications" rows="2"></textarea>
</div>
<div class="form-group">
<label for="specialties">Specialties (comma separated)</label>
<input type="text" id="specialties" name="specialties" placeholder="e.g. Dementia Care, Mobility Assistance">
</div>
<div class="form-group">
<label for="experience_years">Experience (Years)</label>
<input type="number" id="experience_years" name="experience_years" min="0">
</div>
<div class="form-group">
<label for="bio">Bio</label>
<textarea id="bio" name="bio" rows="4"></textarea>
</div>
<div class="form-group" style="display:none;">
<label for="image">Profile Image</label>
<input type="hidden" name="image_default" value="true">
</div>
<div class="form-group">
<label for="phone">Phone</label>
<input type="tel" id="phone" name="phone">
</div>
<div class="form-group">
<label for="email">Email</label>
<input type="email" id="email" name="email">
</div>
<div class="form-group">
<label><input type="checkbox" name="is_available" value="true" checked> Available</label>
</div>
<button type="submit" class="btn btn-primary">Create Caregiver</button>
<a href="${pageContext.request.contextPath}/admin/caregiver" class="btn btn-secondary">Cancel</a>
</form>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
