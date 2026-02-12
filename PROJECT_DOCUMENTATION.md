# SilverCare Home Support Portal - Project Documentation

## Project Overview

A full-stack Java EE (Jakarta EE) web application for a home caregiving service platform. Customers can browse services, book caregivers, make payments, and leave feedback. Includes an admin dashboard and caregiver portal.

**Architecture**: MVC pattern with DAO layer (Server-side rendered JSP)

---

## Technology Stack

### Backend

| Technology | Version | Purpose |
|---|---|---|
| Java | SE 21 | Core programming language |
| Apache Tomcat | 10.1 | Application server |
| Jakarta Servlet API | 6.0.0 | HTTP request/response handling |
| Jakarta JSP API | 3.1.1 | Server-side page rendering |
| Jakarta JSTL | 3.0.1 | JSP Standard Tag Library |
| Jakarta EL | 5.0.0 | Expression Language |
| PostgreSQL JDBC | 42.7.8 | Database driver |
| Stripe Java SDK | 24.13.0 | Payment processing |
| Jakarta Mail | 2.0.1 | Email (SMTP via Gmail) |
| Jakarta Activation | 2.0.1 | MIME type handling |
| Google Gson | 2.10.1 | JSON serialization |
| jBCrypt | 0.4 | Password hashing |

**Total: 12 JAR libraries** (manually managed in `WEB-INF/lib/`)

### Frontend

| Technology | Version | Purpose |
|---|---|---|
| HTML5 / CSS3 / JavaScript | - | Core frontend (no framework) |
| Font Awesome | 6.5.2 | Icon library (CDN) |
| Google Fonts (Inter) | - | Typography (CDN) |

### Database

| Service | Details |
|---|---|
| PostgreSQL | Hosted on **Neon** (AWS ap-southeast-1) |
| Database Name | `neondb` |
| Connection | SSL required, connection pooling via `DBUtil.java` |

### External Services

| Service | Purpose |
|---|---|
| **Stripe** | Payment gateway (test mode) |
| **Gmail SMTP** | Email verification & password reset |
| **Neon PostgreSQL** | Cloud database |
| **Spring Boot Microservice** | Booking & Caregiver REST APIs (hosted on Render) |

---

## Project Structure

```
j2ee-project/
├── src/main/java/
│   ├── controller/          # Servlet controllers (admin, caregiver, customer)
│   ├── dao/                 # Data Access Object interfaces
│   ├── dao/impl/            # DAO implementations
│   ├── db/                  # Database utilities (DBUtil, schema migrations)
│   ├── model/               # Entity POJOs (User, Caregiver, Booking, etc.)
│   ├── service/             # Business logic & API clients
│   ├── servlet/             # Additional servlets
│   └── util/                # Helper utilities
├── src/main/webapp/
│   ├── assets/css/          # Stylesheets (app.css, ambient-blobs.css)
│   ├── assets/js/           # JavaScript (theme.js)
│   ├── includes/            # Shared JSP components (header, footer, navbar)
│   ├── admin/               # Admin dashboard pages
│   ├── customer/            # Customer portal pages
│   ├── public/              # Public-facing pages
│   ├── auth/                # Login & registration pages
│   ├── error/               # Error pages (404, 500)
│   └── WEB-INF/
│       ├── lib/             # JAR dependencies (12 files)
│       └── web.xml          # Servlet configuration
├── src/main/resources/
│   ├── stripe.properties    # Stripe API keys
│   └── mail.properties      # Gmail SMTP config
└── database/
    └── complete_schema_reset.sql  # Full database schema + seed data
```

---

## Spring Boot Microservice (AssignmentTwo)

The J2EE app communicates with a Spring Boot REST API for booking and caregiver management.

| Detail | Value |
|---|---|
| Framework | Spring Boot 4.0.2 |
| Language | Java 17 |
| Database | Same Neon PostgreSQL instance |
| ORM | Spring Data JPA / Hibernate |
| Deployed At | `https://assignmenttwo-fljm.onrender.com/user-ws` |

### API Endpoints Used

| Endpoint | Method | Description |
|---|---|---|
| `/api/bookings` | GET | List all bookings |
| `/api/bookings/{id}` | GET | Get booking by ID |
| `/api/bookings` | POST | Create booking |
| `/api/bookings/{id}` | PUT | Update booking |
| `/api/bookings/{id}` | DELETE | Delete booking |
| `/api/caregivers` | GET | List all caregivers |
| `/api/caregivers/{id}` | GET | Get caregiver by ID |
| `/api/caregivers/search` | GET | Search caregivers |

---

## Deploying the Spring Boot Microservice on Render (Docker)

### Prerequisites

- A [Render](https://render.com) account
- Project pushed to a GitHub repository
- A `Dockerfile` in the project root

### Dockerfile

```dockerfile
# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", \
  "-XX:+UseSerialGC", \
  "-Xss512k", \
  "-Xmx256m", \
  "-XX:MaxMetaspaceSize=128m", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-jar", "app.jar"]
```

**JVM Flags Explained:**

| Flag | Purpose |
|---|---|
| `-XX:+UseSerialGC` | Lower memory usage (better for small containers) |
| `-Xss512k` | Reduced thread stack size |
| `-Xmx256m` | Max heap capped at 256MB |
| `-XX:MaxMetaspaceSize=128m` | Limits metaspace memory |
| `-Djava.security.egd=file:/dev/./urandom` | Faster startup (non-blocking random) |

### Step-by-Step Deployment

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push origin main
   ```

2. **Create a New Web Service on Render**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click **New** → **Web Service**
   - Connect your GitHub repository
   - Select the repository containing the Spring Boot project

3. **Configure the Service**

   | Setting | Value |
   |---|---|
   | Name | `assignmenttwo` (or your choice) |
   | Region | Singapore (Southeast Asia) |
   | Branch | `main` |
   | Runtime | **Docker** |
   | Instance Type | Free (or Starter for no cold starts) |

4. **Set Environment Variables** (optional but recommended)
   - `PORT` = `8081`
   - Move sensitive values from `application.properties` to env vars:
     ```
     DB_URL=jdbc:postgresql://...
     DB_USERNAME=neondb_owner
     DB_PASSWORD=your_password
     ```

5. **Deploy**
   - Click **Create Web Service**
   - Render will automatically build the Docker image and deploy
   - First build takes ~5 minutes

6. **Verify**
   - Once deployed, your API will be available at:
     ```
     https://your-service-name.onrender.com/user-ws/api/bookings
     ```

### Important Notes

- **Free tier cold starts**: The service spins down after 15 minutes of inactivity. First request after idle takes ~30-60 seconds. Use [UptimeRobot](https://uptimerobot.com) to ping every 14 minutes to keep it alive.
- **Auto-deploy**: Render automatically redeploys when you push to the `main` branch.
- **Logs**: Check deployment logs at Render Dashboard → Your Service → Logs.
