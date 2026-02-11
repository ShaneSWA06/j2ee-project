<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Caregiver"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Edit Caregiver</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<c:if test="${not empty caregiver}">
<form method="post" action="${pageContext.request.contextPath}/admin/caregiver?action=edit" class="form" enctype="multipart/form-data">
<input type="hidden" name="caregiverId" value="${caregiver.caregiverId}">
<div class="form-group"><label for="name">Name</label><input type="text" id="name" name="name" value="${caregiver.name}" required></div>
<div class="form-group"><label for="qualifications">Qualifications (comma separated)</label>
<textarea id="qualifications" name="qualifications" rows="2">${caregiver.qualifications}</textarea></div>
<div class="form-group"><label for="specialties">Specialties (comma separated)</label>
<input type="text" id="specialties" name="specialties" placeholder="e.g. Dementia Care, Mobility Assistance" value="${caregiver.specialties}"></div>
<div class="form-group"><label for="experience_years">Experience (Years)</label>
<input type="number" id="experience_years" name="experience_years" min="0" value="${caregiver.experienceYears}"></div>
<div class="form-group"><label for="bio">Bio</label>
<textarea id="bio" name="bio" rows="4">${caregiver.bio}</textarea></div>
<div class="form-group">
<label for="image">Profile Image</label>
<c:if test="${not empty caregiver.profileImage}">
    <div class="mb-2">
        <img src="${pageContext.request.contextPath}/${caregiver.profileImage}" alt="Current Image" style="max-width: 200px; max-height: 200px; border: 1px solid #ccc; padding: 5px;">
    </div>
</c:if>
<input type="file" id="image" name="image" accept="image/*" class="form-control">
<small class="text-muted">Leave empty to keep current image</small>
</div>
<div class="form-group"><label for="phone">Phone</label><input type="tel" id="phone" name="phone" value="${caregiver.phone}"></div>
<div class="form-group"><label for="email">Email</label><input type="email" id="email" name="email" value="${caregiver.email}"></div>
<div class="form-group"><label><input type="checkbox" name="is_available" value="true" ${caregiver.available ? 'checked' : ''}> Available</label></div>
<button type="submit" class="btn btn-primary">Update</button>
<a href="${pageContext.request.contextPath}/admin/caregiver" class="btn btn-secondary">Cancel</a>
</form>
</c:if>
<c:if test="${empty caregiver}"><div class="alert alert-danger">Not found.</div><a href="${pageContext.request.contextPath}/admin/caregiver" class="btn">Back</a></c:if>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
