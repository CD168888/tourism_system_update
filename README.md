# Readme.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a full-stack Tourism Information System (旅游信息系统) built with:
- **Backend**: Spring Boot 3.2.0 with Java 17
- **Frontend**: Vue 3 with Element Plus UI framework
- **Database**: MySQL with MyBatis-Plus ORM
- **Authentication**: JWT-based authentication
- **Caching**: Redis with custom AOP-based caching
- **Payment**: Alipay sandbox integration
- **AI**: Spring AI Alibaba with DashScope (通义千问) for intelligent chat

## Architecture

### Backend Structure (Spring Boot)

The backend follows a standard layered architecture:

- **Controller Layer** (`org.example.springboot.controller`): REST API endpoints using Spring MVC
- **Service Layer** (`org.example.springboot.service`): Business logic implementation
- **Mapper Layer** (`org.example.springboot.mapper`): MyBatis-Plus data access interfaces
- **Entity Layer** (`org.example.springboot.entity`): Database entity models with Lombok annotations
- **Config Layer** (`org.example.springboot.config`): Configuration classes for security, Redis, Alipay, AI, etc.
- **Exception Layer** (`org.example.springboot.exception`): Custom exceptions and global exception handler
- **DTO Layer** (`org.example.springboot.DTO`): Data transfer objects
- **Util Layer** (`org.example.springboot.util`): Utility classes for JWT, Redis, file operations, etc.

### Frontend Structure (Vue 3)

The frontend is organized by feature:

- **Layouts**: `BackendLayout.vue` (admin panel) and `FrontendLayout.vue` (user-facing)
- **Views**: Split into `backend/` (admin management) and `frontend/` (public pages)
- **Components**: Reusable UI components including `WangEditor.vue` for rich text editing
- **Router**: Vue Router with route guards for authentication
- **Store**: Pinia/Vuex for state management (user state, app state)
- **Utils**: Axios-based HTTP client with interceptors

### Key Architectural Patterns

1. **Authentication Flow**:
   - JWT tokens issued on login and stored in localStorage
   - `JwtInterceptor` validates tokens on backend requests
   - Frontend axios interceptor attaches token to all requests via `token` header (NOT `Authorization: Bearer`)
   - Token is signed with user's password as secret

2. **Redis Caching**:
   - Custom `@RedisCache` annotation with AOP aspect (`RedisCacheAspect`)
   - Supports SpEL expressions for dynamic cache keys
   - Cache refresh capability and configurable expiration
   - Located in `aspect/RedisCacheAspect.java` and `annotation/RedisCache.java`

3. **File Management**:
   - Uploads stored in local filesystem at path defined in `FileUtil.FILE_BASE_PATH`
   - Static file serving via `/img/**` and `/api/img/**` endpoints
   - Controller: `FileController.java`

4. **Security Configuration**:
   - Spring Security configured in `SecurityConfig` with BCrypt password encoding (strength 10)
   - CSRF disabled for API usage
   - Most endpoints currently permit all (development mode)

5. **AI Chat Integration**:
   - Spring AI Alibaba with DashScope API (通义千问)
   - SSE (Server-Sent Events) for streaming chat responses
   - ChatMemory for conversation context retention
   - Supports multi-user isolation and session management
   - Configuration in `AiConfig.java`
   - Controller: `AiChatController.java`
   - Test page: `/ai-test.html`

## Common Development Commands

### Backend (Spring Boot)

Navigate to the `springboot/` directory for all backend commands.

**Build and run:**
```bash
cd springboot
mvn clean install
mvn spring-boot:run
```

**Run tests:**
```bash
mvn test
```

**Package:**
```bash
mvn package
```

**Server configuration:**
- Default port: 1236
- Database: `tourism_system_update` on localhost:3306
- Redis: localhost:6379
- API documentation: http://localhost:1236/doc.html (Knife4j/Swagger)
- AI Chat test page: http://localhost:1236/ai-test.html

### Frontend (Vue 3)

Navigate to the `vue3/` directory for all frontend commands.

**Install dependencies:**
```bash
cd vue3
npm install
```

**Development server:**
```bash
npm run serve
```
- Runs in development mode
- Default port: 8080 (configured in vue.config.js or uses Vue CLI default)

**Build for production:**
```bash
npm run build
```

**Build for staging:**
```bash
npm run build:staging
```

**Lint:**
```bash
npm run lint
```

## Important Configuration Files

### Backend Configuration

**application.properties** (`springboot/src/main/resources/application.properties`):
- Database connection settings (update username/password as needed)
- Mail server configuration (QQ mail SMTP)
- Redis connection settings
- Alipay sandbox configuration
- File upload limits (max 10MB)

**pom.xml**:
- Spring Boot 3.2.0
- MyBatis-Plus 3.5.7
- Knife4j 4.3.0 (API documentation)
- Alipay SDK 4.35.79
- Hutool utilities 5.8.25
- Java JWT 4.4.0

### Frontend Configuration

**package.json**:
- Vue 3.2.13
- Element Plus 2.9.4
- Axios 1.10.0
- Pinia 3.0.0
- WangEditor 5.1.23 (rich text editor)

**Environment Variables**:
- `VUE_APP_BASE_API`: Backend API base URL (defaults to `/api` in request.js)
- `AI_DASHSCOPE_API_KEY`: DashScope API key for AI chat (backend)

## Domain Model

Core entities in the system:

- **User**: User accounts with roles (admin/regular user)
- **ScenicSpot**: Tourist attractions with categories, location, pricing, images
- **ScenicCategory**: Categories for scenic spots
- **TravelGuide**: User-generated travel guides
- **Comment**: Comments on scenic spots and guides
- **CommentLike**: Like system for comments
- **Collection/ScenicCollection**: User's favorite items
- **Ticket**: Available tickets for scenic spots
- **TicketOrder**: Ticket purchase orders with Alipay integration
- **Accommodation**: Lodging information
- **AccommodationReview**: Reviews for accommodations
- **Carousel**: Homepage carousel images

## AI Chat Features

The system integrates Spring AI Alibaba for intelligent chat functionality:

### Setup

1. **Get DashScope API Key**: 
   - Visit https://bailian.console.aliyun.com/
   - Create an API key in the console

2. **Set Environment Variable**:
   ```bash
   # Windows
   set AI_DASHSCOPE_API_KEY=sk-your-api-key
   
   # Linux/Mac
   export AI_DASHSCOPE_API_KEY=sk-your-api-key
   ```

3. **Or configure directly in application.properties** (not recommended for production):
   ```properties
   spring.ai.dashscope.api-key=sk-your-actual-api-key
   ```

### API Endpoints

- **Stream Chat** (SSE): `GET /api/chat/ai/generateStream?message=xxx&sessionId=xxx&userId=xxx`
- **Sync Chat**: `GET /api/chat/ai/generate?message=xxx&sessionId=xxx&userId=xxx`
- **Cancel Stream**: `POST /api/chat/ai/cancelStream?sessionId=xxx&userId=xxx`
- **Clear Memory**: `DELETE /api/chat/ai/clearMemory?sessionId=xxx&userId=xxx`

### Quick Test

1. Start the backend with API key configured
2. Open browser: http://localhost:1236/ai-test.html
3. Start chatting with the AI assistant!

### Frontend Integration

See `vue3/src/views/frontend/ai/AiChat.vue` for a complete Vue 3 component example.

For detailed documentation, see `springboot/AI_INTEGRATION_GUIDE.md`.

## Development Notes

1. **MyBatis-Plus**: All mappers extend `BaseMapper<T>` with built-in CRUD methods. Custom SQL goes in `/mapper/*.xml` files (if any).

2. **API Documentation**: Backend uses Knife4j (enhanced Swagger). Access at `/doc.html` after starting the server. Controllers use `@Tag` and `@Operation` annotations.

3. **Error Handling**:
   - Backend: Global exception handler in `GlobalExceptionHandler.java`
   - Frontend: Axios response interceptor handles all HTTP errors and business errors

4. **Pagination**: Uses MyBatis-Plus `Page<T>` class. Configured in `MybatisPlusConfig.java`.

5. **Date Handling**:
   - Backend: `LocalDateTime` with custom Jackson configuration
   - Timezone: GMT+8 (China)

6. **Email Service**: Uses QQ mail SMTP on port 587/465 for sending emails (verification codes, notifications).

7. **Payment Integration**: Alipay sandbox mode configured. Production requires updating `alipay.gateway` and credentials in application.properties.

8. **CORS**: Configured via `WebConfig.java` if needed for development.

## Security Considerations

- Default admin credentials are in application.properties (change in production)
- JWT secret is based on user password (consider using a separate app secret in production)
- CSRF is disabled (enable for production if serving web pages)
- Spring Security currently permits all requests (configure proper authorization rules)
- Email password is exposed in application.properties (use environment variables in production)
- Alipay keys should be externalized to environment variables
