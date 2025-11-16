# Backend API Documentation

## Architecture

This backend is built with:
- **Cloudflare Workers**: Serverless edge compute
- **Hono**: Lightweight, fast web framework
- **D1**: SQLite database at the edge
- **KV**: Key-value storage for caching
- **TypeScript**: Type-safe development

## Project Structure

\\\
backend/
├── src/
│   ├── index.ts              # Main application entry
│   ├── routes/               # API route handlers
│   │   ├── auth.ts          # Authentication routes
│   │   ├── forms.ts         # Form CRUD routes
│   │   └── submissions.ts   # Submission routes
│   ├── middleware/           # Hono middleware
│   │   ├── auth.ts          # JWT authentication
│   │   ├── cors.ts          # CORS configuration
│   │   └── rateLimiter.ts   # Rate limiting
│   ├── db/                   # Database
│   │   ├── schema.sql       # Database schema
│   │   ├── migrations/      # Migration files
│   │   └── queries.ts       # Prepared statements
│   ├── types/                # TypeScript types
│   └── utils/                # Utility functions
│       ├── jwt.ts           # JWT helpers
│       └── validation.ts    # Zod schemas
├── wrangler.toml             # Cloudflare configuration
├── tsconfig.json             # TypeScript configuration
└── package.json              # Dependencies
\\\

## Development

### Start local development server:
\\\ash
cd backend
npm run dev
\\\

The API will be available at: \http://localhost:8787\

### Initialize D1 database:
\\\ash
npm run d1:create
npm run d1:migrate
\\\

### Check database:
\\\ash
npm run d1:query "SELECT * FROM users LIMIT 5"
\\\

## API Endpoints

### Health Check
\\\
GET /
GET /api/health
\\\

### Authentication (TODO)
\\\
POST /api/auth/signup
POST /api/auth/login
POST /api/auth/verify-email
POST /api/auth/reset-password
\\\

### Forms (TODO)
\\\
GET    /api/forms
POST   /api/forms
GET    /api/forms/:id
PUT    /api/forms/:id
DELETE /api/forms/:id
\\\

### Submissions (TODO)
\\\
POST /api/f/:formId/submit
GET  /api/forms/:id/submissions
\\\

## Environment Variables

Set secrets with Wrangler:
\\\ash
wrangler secret put JWT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put STRIPE_WEBHOOK_SECRET
\\\

## Deployment

### Deploy to production:
\\\ash
npm run deploy
\\\

### View live logs:
\\\ash
npm run tail
\\\

## Testing

Run type checks:
\\\ash
npm run type-check
\\\

## Next Steps

1. Implement authentication routes (\src/routes/auth.ts\)
2. Implement forms routes (\src/routes/forms.ts\)
3. Implement submissions routes (\src/routes/submissions.ts\)
4. Add middleware for auth, CORS, rate limiting
5. Create D1 migration files
6. Write tests

Refer to the main project documentation in \/docs\ for full details.
