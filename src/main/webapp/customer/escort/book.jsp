<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Book Medical Escort"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="form-container">
        <h1>Book Service</h1>
        <p class="form-subtitle">Please select your preferred date and time.</p>
        
        <form action="${pageContext.request.contextPath}/customer/medical-escort" method="get">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="serviceId" value="${param.id}">
            <input type="hidden" name="name" value="${param.name}">
            <input type="hidden" name="price" value="${param.price}">
            
            <div class="card" style="margin-bottom: 1.5rem; background: var(--bg-soft);">
                <h3>Selected: ${param.name}</h3>
                <p>Base Fee: $${param.price} / session</p>
            </div>

            <div class="form-group">
                <label>Appointment Date</label>
                <input type="date" name="bookingDate" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
            </div>

            <div class="form-group">
                <label>Pickup Time</label>
                <input type="time" name="bookingTime" required>
            </div>

            <div class="form-group">
                <label>Pickup Address</label>
                <select name="pickupAddress" required class="form-control">
                    <option value="">-- Select Pickup Location --</option>
                    <optgroup label="Central Region">
                        <option value="Blk 123 Orchard Road, #01-01, Singapore 238858">Blk 123 Orchard Road, #01-01</option>
                        <option value="Blk 456 Somerset Road, #05-12, Singapore 238163">Blk 456 Somerset Road, #05-12</option>
                        <option value="Blk 789 Bukit Timah Road, #03-45, Singapore 269738">Blk 789 Bukit Timah Road, #03-45</option>
                        <option value="Blk 321 River Valley Road, #02-08, Singapore 238325">Blk 321 River Valley Road, #02-08</option>
                    </optgroup>
                    <optgroup label="East Region">
                        <option value="Blk 234 Bedok North Street 1, #04-123, Singapore 460234">Blk 234 Bedok North Street 1, #04-123</option>
                        <option value="Blk 567 Tampines Street 21, #06-234, Singapore 522567">Blk 567 Tampines Street 21, #06-234</option>
                        <option value="Blk 890 Pasir Ris Drive 1, #08-456, Singapore 510890">Blk 890 Pasir Ris Drive 1, #08-456</option>
                        <option value="Blk 432 Simei Street 1, #03-78, Singapore 520432">Blk 432 Simei Street 1, #03-78</option>
                    </optgroup>
                    <optgroup label="North Region">
                        <option value="Blk 345 Yishun Ring Road, #05-234, Singapore 760345">Blk 345 Yishun Ring Road, #05-234</option>
                        <option value="Blk 678 Woodlands Drive 16, #07-345, Singapore 730678">Blk 678 Woodlands Drive 16, #07-345</option>
                        <option value="Blk 901 Sembawang Drive, #04-123, Singapore 750901">Blk 901 Sembawang Drive, #04-123</option>
                        <option value="Blk 543 Admiralty Drive, #06-89, Singapore 730543">Blk 543 Admiralty Drive, #06-89</option>
                    </optgroup>
                    <optgroup label="West Region">
                        <option value="Blk 456 Jurong West Street 41, #08-234, Singapore 640456">Blk 456 Jurong West Street 41, #08-234</option>
                        <option value="Blk 789 Clementi Avenue 2, #05-123, Singapore 120789">Blk 789 Clementi Avenue 2, #05-123</option>
                        <option value="Blk 234 Bukit Batok West Avenue 6, #03-45, Singapore 650234">Blk 234 Bukit Batok West Avenue 6, #03-45</option>
                        <option value="Blk 567 Choa Chu Kang Avenue 3, #07-234, Singapore 680567">Blk 567 Choa Chu Kang Avenue 3, #07-234</option>
                    </optgroup>
                    <optgroup label="North-East Region">
                        <option value="Blk 890 Hougang Avenue 8, #04-567, Singapore 530890">Blk 890 Hougang Avenue 8, #04-567</option>
                        <option value="Blk 123 Serangoon North Avenue 1, #06-234, Singapore 550123">Blk 123 Serangoon North Avenue 1, #06-234</option>
                        <option value="Blk 654 Punggol Drive, #05-123, Singapore 820654">Blk 654 Punggol Drive, #05-123</option>
                        <option value="Blk 321 Sengkang East Way, #08-45, Singapore 540321">Blk 321 Sengkang East Way, #08-45</option>
                    </optgroup>
                </select>
                <small style="color: var(--text-muted); display: block; margin-top: 0.5rem;">
                    Select the address where we should pick you up
                </small>
            </div>
            
            <div class="form-group">
                <label>Destination (Hospital/Clinic)</label>
                <select name="destinationAddress" required class="form-control">
                    <option value="">-- Select Destination --</option>
                    <optgroup label="Major Hospitals">
                        <option value="Singapore General Hospital, Outram Road, Singapore 169608">Singapore General Hospital (SGH)</option>
                        <option value="National University Hospital, 5 Lower Kent Ridge Road, Singapore 119074">National University Hospital (NUH)</option>
                        <option value="Tan Tock Seng Hospital, 11 Jalan Tan Tock Seng, Singapore 308433">Tan Tock Seng Hospital (TTSH)</option>
                        <option value="Changi General Hospital, 2 Simei Street 3, Singapore 529889">Changi General Hospital (CGH)</option>
                        <option value="KK Women's and Children's Hospital, 100 Bukit Timah Road, Singapore 229899">KK Women's and Children's Hospital (KKH)</option>
                        <option value="National Cancer Centre Singapore, 11 Hospital Crescent, Singapore 169610">National Cancer Centre Singapore (NCCS)</option>
                        <option value="Mount Elizabeth Hospital, 3 Mount Elizabeth, Singapore 228510">Mount Elizabeth Hospital</option>
                        <option value="Raffles Hospital, 585 North Bridge Road, Singapore 188770">Raffles Hospital</option>
                        <option value="Gleneagles Hospital, 6A Napier Road, Singapore 258500">Gleneagles Hospital</option>
                    </optgroup>
                    <optgroup label="Polyclinics">
                        <option value="Ang Mo Kio Polyclinic, 21 Ang Mo Kio Central 2, Singapore 569666">Ang Mo Kio Polyclinic</option>
                        <option value="Bedok Polyclinic, 11 Bedok North Street 1, Singapore 469662">Bedok Polyclinic</option>
                        <option value="Clementi Polyclinic, 451 Clementi Avenue 3, Singapore 120451">Clementi Polyclinic</option>
                        <option value="Jurong Polyclinic, 190 Jurong East Avenue 1, Singapore 609788">Jurong Polyclinic</option>
                        <option value="Woodlands Polyclinic, 10 Woodlands Street 31, Singapore 738579">Woodlands Polyclinic</option>
                    </optgroup>
                    <optgroup label="Specialist Centres">
                        <option value="National Heart Centre Singapore, 5 Hospital Drive, Singapore 169609">National Heart Centre Singapore</option>
                        <option value="Singapore National Eye Centre, 11 Third Hospital Avenue, Singapore 168751">Singapore National Eye Centre</option>
                        <option value="National Neuroscience Institute, 11 Jalan Tan Tock Seng, Singapore 308433">National Neuroscience Institute</option>
                    </optgroup>
                </select>
                <small style="color: var(--text-muted); display: block; margin-top: 0.5rem;">
                    Select your medical appointment destination
                </small>
            </div>

            <div class="form-group">
                <label>Select Caregiver</label>
                <select name="caregiverId" class="form-control">
                    <option value="">-- Select a Caregiver (Optional) --</option>
                    <c:forEach var="caregiver" items="${caregivers}">
                        <option value="${caregiver.caregiverId}">
                            ${caregiver.name} - ${caregiver.specialties}
                        </option>
                    </c:forEach>
                </select>
                <small style="color: var(--text-muted); display: block; margin-top: 0.5rem;">
                    Choose a caregiver to assist you during your medical escort service
                </small>
            </div>

            <div class="form-footer">
                <button type="submit" class="btn btn-primary" style="width: 100%;">Proceed to Confirmation</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
