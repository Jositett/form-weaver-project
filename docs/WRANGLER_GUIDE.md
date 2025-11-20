# FormWeaver Backend

Cloudflare Workers API built with Hono framework, D1 database, and Workers KV for edge-first performance.

## 🚀 Quick Start

### Prerequisites

- **Node.js >= 16.17.0** (required for Wrangler)
- npm, pnpm, or bun
- Cloudflare account

### Installation

```bash
# Clone and install
git clone <repository-url>
cd backend
npm install

# Authenticate with Cloudflare (one-time only)
npx wrangler login

# Set up local environment variables
# Create a .dev.vars file in the backend/ directory for local secrets.
# This file is NOT committed to git.
```

### Environment Setup

Create a `.dev.vars` file in the **`backend/`** directory (automatically gitignored):

```bash
# backend/.dev.vars
JWT_SECRET=your-local-jwt-secret-for-testing
STRIPE_SECRET_KEY=sk_test_your-stripe-test-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
ACCOUNT_ID=your-account-id  # From `wrangler whoami`
```

### Database & Resource Setup

```bash
# Create D1 database (one-time)
npm run d1:create

# Run database migrations (local)
npm run d1:migrate

# Deploy secrets (one-time per environment)
npx wrangler secret put JWT_SECRET
npx wrangler secret put STRIPE_SECRET_KEY
npx wrangler secret put STRIPE_WEBHOOK_SECRET

# Start development server
npm run dev
```

The API will be available at **<http://localhost:8787>**.

## 📁 Project Structure

```text
backend/
├── src/
│   ├── index.ts           # Main Hono application entry
│   ├── routes/            # API route handlers
│   │   ├── auth.ts        # Authentication routes
│   │   ├── forms.ts       # Form CRUD routes
│   │   └── submissions.ts # Submission routes
│   │
│   ├── middleware/        # Hono middleware
│   │   ├── auth.ts        # JWT authentication
│   │   ├── cors.ts        # CORS configuration
│   │   └── rateLimiter.ts # Rate limiting
│   │
│   ├── db/                # Database
│   │   ├── db.ts          # D1 utility function (getDb)
│   │   ├── schema.sql     # Database schema
│   │   └── migrations/    # Migration files
│   │
│   ├── types/             # TypeScript types
│   │   └── index.ts       # Shared types and Bindings
│   │
│   └── utils/             # Utility functions
│       ├── jwt.ts         # JWT helpers
│       └── validation.ts  # Zod schemas
│
├── wrangler.toml           # Cloudflare Workers configuration
├── .dev.vars              # Local secrets (NEVER commit)
├── tsconfig.json          # TypeScript configuration
└── package.json           # Dependencies
```

## 🛠️ Development

### Available Scripts

```bash
# Start local development server with emulators
npm run dev

# TypeScript type checking
npm run type-check

# Deploy to production
npm run deploy

# Database operations
npm run d1:create          # Create new D1 database
npm run d1:list            # List all D1 databases
npm run d1:migrate         # Run migrations (local)
npm run d1:migrate:prod    # Run migrations (production)
npm run d1:query           # Execute SQL query locally

# View logs
npm run tail               # Live tail production logs
```

### Local Development Features

- **Hot reload** - Automatic restart on file changes
- **Local D1** - SQLite database for local development
- **Local KV** - In-memory KV store for local development
- **Local R2** - Emulated object storage
- **TypeScript** - Full type checking with Workers types

**Change port** (if 8787 is occupied):

```bash
npm run dev -- --port 3000
```

Or add to `wrangler.toml`:

```toml
[dev]
port = 3000
```

### Database Setup

#### Create Database

```bash
npm run d1:create
```

This creates a local D1 database named `formweaver-dev`.

#### Run Migrations

```bash
# Local development (uses emulator)
npm run d1:migrate

# Production (apply to remote DB)
npm run d1:migrate:prod
```

Migrations are applied automatically when deploying with GitHub Actions.

#### Query Database

```bash
# Query local DB
npm run d1:query "SELECT * FROM forms LIMIT 5"
```

## 📊 Database Schema

See `src/db/schema.sql` for complete schema.

### Core Tables

- **users** - User accounts
- **workspaces** - Multi-tenant workspaces
- **forms** - Form definitions
- **submissions** - Form submissions
- **workspace_members** - Workspace access control

### Indexes

All tables have appropriate indexes for performance:

- User email lookups
- Workspace-based queries
- Form status filtering
- Submission pagination

## 🔐 Environment Variables & Secrets

### Secrets Management

**The project relies solely on `wrangler secret put` for production secrets and `.dev.vars` for local development.**

**The use of `.env.example` has been removed to enforce a clear separation between committed code and environment configuration.**

#### Production Secrets

Set secrets for each environment (production, staging) using the Wrangler CLI:

```bash
npx wrangler secret put JWT_SECRET
npx wrangler secret put STRIPE_SECRET_KEY
npx wrangler secret put STRIPE_WEBHOOK_SECRET

# For staging environment
npx wrangler secret put JWT_SECRET --env staging
```

**Verify secrets are set**:

```bash
npx wrangler secret list
```

#### Local Development Secrets

For local development, create a `.dev.vars` file in the **`backend/`** directory. This file is automatically loaded by `wrangler dev`.

```bash
# backend/.dev.vars
JWT_SECRET=your-local-jwt-secret-for-testing
STRIPE_SECRET_KEY=sk_test_your-stripe-test-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
ACCOUNT_ID=your-account-id
```

### Type-Safe Bindings

Define your environment in `src/types/Env.ts`:

```typescript
export interface Env {
  // Cloudflare Services
  DB: D1Database
  FORM_CACHE: KVNamespace
  SESSION_STORE: KVNamespace
  EMAIL_TOKENS: KVNamespace
  RATE_LIMIT: KVNamespace
  BUCKET: R2Bucket
  
  // Secrets
  JWT_SECRET: string
  STRIPE_SECRET_KEY: string
  STRIPE_WEBHOOK_SECRET: string
  
  // Optional: Cloudflare metadata
  CF_VERSION_METADATA?: { id: string }
}
```

### Using in Hono

```typescript
import { Hono } from 'hono'
import { Env } from './types/Env'

const app = new Hono<{ Bindings: Env }>()

app.get('/api/forms', async (c) => {
  const forms = await c.env.DB.prepare(
    'SELECT * FROM forms WHERE workspace_id = ?'
  ).bind(c.get('workspaceId')).all()
  
  return c.json(forms.results)
})
```

## 🔌 API Endpoints

### Health Check

```text
GET  /              # API status
GET  /api/health    # Health check
```

### Authentication

```text
POST /api/auth/signup
POST /api/auth/login
POST /api/auth/verify-email
POST /api/auth/reset-password
POST /api/auth/refresh
```

### Forms

```text
GET    /api/forms              # List forms
POST   /api/forms              # Create form
GET    /api/forms/:id          # Get form
PUT    /api/forms/:id          # Update form
DELETE /api/forms/:id          # Delete form
```

### Submissions

```text
POST   /api/f/:formId/submit   # Submit form (public)
GET    /api/forms/:id/submissions  # List submissions
GET    /api/forms/:id/submissions/:subId  # Get submission
DELETE /api/forms/:id/submissions/:subId  # Delete submission
```

## 💾 Workers KV & Caching

### KV Namespaces

Configured in `wrangler.toml`:

- **FORM_CACHE** - Form schema caching
- **SESSION_STORE** - JWT refresh tokens
- **EMAIL_TOKENS** - Email verification tokens
- **RATE_LIMIT** - Rate limiting counters

### Caching Forms

```typescript
// Cache form schema for 10 minutes
const cacheKey = `form:${formId}`
const cached = await c.env.FORM_CACHE.get(cacheKey, 'json')

if (cached) {
  return c.json({ data: cached })
}

// Fetch from D1
const form = await getFormFromDB(c.env.DB, formId)

// Cache result
await c.env.FORM_CACHE.put(cacheKey, JSON.stringify(form), {
  expirationTtl: 600
})

return c.json({ data: form })
```

## 🔒 Security

### CORS Configuration

```typescript
// middleware/cors.ts
app.use('/api/*', cors({
  origin: ['http://localhost:5173', 'http://localhost:8080'],
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
}))
```

### Rate Limiting

```typescript
// middleware/rateLimiter.ts
const rateLimitMiddleware = (limit: number, window: number) => {
  return async (c, next) => {
    const ip = c.req.header('CF-Connecting-IP') || 'unknown'
    const key = `ratelimit:${ip}:${c.req.path}`
    
    const count = await c.env.RATE_LIMIT.get(key)
    if (count && parseInt(count) >= limit) {
      return c.json({ error: 'Too many requests' }, 429)
    }
    
    await c.env.RATE_LIMIT.put(key, String((parseInt(count || '0') + 1)), {
      expirationTtl: window,
    })
    
    await next()
  }
}
```

### Webhook Verification (Stripe)

```typescript
app.post('/webhooks/stripe', async (c) => {
  const signature = c.req.header('stripe-signature')
  const body = await c.req.text()
  
  try {
    const event = Stripe.webhooks.constructEvent(
      body,
      signature,
      c.env.STRIPE_WEBHOOK_SECRET
    )
    // Process webhook...
  } catch (err) {
    return c.text('Invalid signature', 400)
  }
})
```

## 📦 Dependencies

### Core

- **hono** ^4.10.6 - Web framework
- **@hono/zod-validator** ^0.7.4 - Request validation
- **zod** ^3.25.76 - Schema validation
- **jose** ^6.1.2 - JWT handling
- **bcryptjs** ^3.0.3 - Password hashing

### Development

- **wrangler** ^4.47.0 - Cloudflare CLI
- **typescript** ^5.9.3 - Type checking
- **@cloudflare/workers-types** ^4.20251115.0 - TypeScript types

## 🚢 Deployment

### Deploy to Production

```bash
npm run deploy
```

### Deploy to Staging

```bash
npx wrangler deploy --env staging
```

### GitHub Actions CI/CD

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Worker
on:
  push:
    branches: [main]
    
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install dependencies
        run: npm ci
      
      - name: Apply database migrations
        run: npm run d1:migrate:prod
        
      - name: Deploy to Cloudflare Workers
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          secrets: |
            JWT_SECRET
            STRIPE_SECRET_KEY
            STRIPE_WEBHOOK_SECRET
        env:
          JWT_SECRET: ${{ secrets.JWT_SECRET }}
          STRIPE_SECRET_KEY: ${{ secrets.STRIPE_SECRET_KEY }}
          STRIPE_WEBHOOK_SECRET: ${{ secrets.STRIPE_WEBHOOK_SECRET }}
```

### View Logs

```bash
# Live tail production logs
npm run tail

# Filter errors only
npx wrangler tail --status error

# Search logs
npx wrangler tail --search "form_123"
```

### Rollback

```bash
npx wrangler rollback
```

## 🦺 Troubleshooting

### Database Not Found

```bash
# Create database
npm run d1:create

# Verify it exists
npm run d1:list
```

### Migration Errors

```bash
# Check migration files
ls backend/src/db/migrations/

# Run locally first to test
npm run d1:migrate
```

### Wrangler Authentication

```bash
# Re-authenticate
npx wrangler login

# Check current account
npx wrangler whoami

# Verify account_id in wrangler.toml matches
```

### Type Errors

```bash
# Run type check
npm run type-check

# Restart TypeScript language server in VS Code
```

### Port Already in Use

```bash
# Kill process on port 8787
lsof -ti:8787 | xargs kill -9

# Or use different port
npm run dev -- --port 3000
```

## 📚 Additional Resources

- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [Hono Documentation](https://hono.dev/)
- [D1 Database Documentation](https://developers.cloudflare.com/d1/)
- [Workers KV Documentation](https://developers.cloudflare.com/kv/)
- [Wrangler CLI Documentation](https://developers.cloudflare.com/workers/wrangler/)

## 🎯 Best Practices

1. **Always use prepared statements** with D1 to prevent SQL injection
2. **Cache frequently accessed data** in KV
3. **Set environment-specific secrets** for staging/production
4. **Use `.dev.vars` for local secrets only** - never commit it
5. **Test migrations locally** before deploying
6. **Monitor logs after deployment** with `npm run tail`
7. **Use Wrangler environments** for staging/production separation
8. **Keep Wrangler updated** - `npm update wrangler`
9. **Lock Node version** in `package.json` for CI/CD consistency
10. **Use D1 batch operations** for multiple queries in one request

---

**Version:** 1.0.0  
**Last Updated:** 2025-01-16  
**Compatibility:** Wrangler 4.x, Node.js 16.17.0+
