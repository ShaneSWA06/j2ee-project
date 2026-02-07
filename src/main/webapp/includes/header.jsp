<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title><%= request.getParameter("title") != null ? request.getParameter("title") : "SilverCare Home Support Portal" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb1BNE6iqCP1K+ehbD7Fxk1R6f0w8+0+4kL6B0A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=15" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ambient-blobs.css?v=15" />
    <script src="${pageContext.request.contextPath}/assets/js/theme.js?v=15"></script>
  </head>
  <body>
    <!-- Ambient Gradient Blobs -->
    <div class="ambient-blob ambient-blob-1"></div>
    <div class="ambient-blob ambient-blob-2"></div>
    <div class="ambient-blob ambient-blob-3"></div>
