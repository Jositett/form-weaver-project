# 📋 FormWeaver Project Rules

**Version:** 1.0.0  
**Last Updated:** 2025-01-16  
**Project:** FormWeaver - Embeddable Form Builder SaaS  
**Platform:** Cloudflare Workers + React + TypeScript  
**Status:** Active Development

---

## 🎯 Project Overview

FormWeaver is a powerful, embeddable form builder built on Cloudflare's global edge network. This document defines project-specific rules, conventions, and standards that override or supplement the [Unified AI Agent Rules](https://github.com/user/custom_instructions.md).

### Core Principles

1. **Edge-first architecture** - All code optimized for Cloudflare Workers edge network
2. **Type safety** - Full TypeScript coverage with strict mode enabled
3. **Performance** - <50ms API latency globally, <200ms form load time
4. **Security** - Zero-trust architecture, input validation on all endpoints
5. **Developer experience** - Clear documentation, consistent patterns, fast feedback

---

## 🏗️ Architecture Rules

### Technology Stack (MANDATORY)

#### Frontend

- **Framework:** React 18+ (functional components only, no class components)
- **Language:** TypeScript 5.8+ (strict mode required)
- **Build Tool:** Vite 5.4+
- **Styling:** Tailwind CSS 3.4+ (semantic tokens only, no hardcoded colors)
- **UI Components:** shadcn/ui (Radix UI primitives)
- **State Management:** TanStack Query (server state), React Context (app state)
- **Form Handling:** React Hook Form + Zod validation
- **Routing:** React Router 6.30+

#### Backend

- **Runtime:** Cloudflare Workers (V8 isolates)
- **Framework:** Hono 4.10+ (lightweight, fast)
- **Language:** TypeScript 5.9+ (strict mode required)
- **Database:** D1 (SQLite at edge, globally replicated)
- **Cache:** Workers KV (low-latency key-value store)
- **Storage:** R2 (S3-compatible, for file uploads)
- **Authentication:** JWT tokens (jose library)
- **Validation:** Zod 3.25+ (shared schemas between frontend/backend)

#### Shared

- **Types:** Shared TypeScript types in `/shared/types/`
- **Validation:** Zod schemas shared between frontend and backend

### Project Structure (MANDATORY)

```text
formweaver/
├── frontend/              # React application
│   ├── src/
│   │   ├── components/   # React components
│   │   │   ├── formweaver/  # Form builder components
│   │   │   └── ui/          # shadcn/ui (don't edit directly)
│   │   ├── pages/        # Route pages
│   │   ├── hooks/        # Custom React hooks
│   │   ├── types/        # TypeScript types
│   │   ├── lib/          # Utility functions
│   │   └── contexts/     # React contexts
│   └── package.json
│
├── backend/               # Cloudflare Workers API
│   ├── src/
│   │   ├── index.ts      # Main Hono app
│   │   ├── routes/       # API route handlers
│   │   ├── middleware/   # Hono middleware
│   │   ├── db/           # Database schema & migrations
│   │   ├── types/        # TypeScript types
│   │   └── utils/        # Utility functions
│   └── wrangler.toml     # Cloudflare config
│
├── shared/                # Shared code
│   └── types/            # Shared TypeScript types
│
└── docs/                   # Documentation
```

**Rules:**

- **NO** business logic in `shared/` - only types and validation schemas
- **NO** direct database access from frontend - all via API
- **NO** hardcoded API URLs - use environment variables
- **YES** shared Zod schemas for validation consistency

---

## 💻 Code Style & Standards

### TypeScript Rules (STRICT)

```typescript
// ✅ GOOD: Explicit types, interfaces for objects
interface FormField {
  id: string;
  type: FieldType;
  label: string;
  required?: boolean;
}

const createField = (config: Partial<FormField>): FormField => {
  return { ...defaultField, ...config };
};

// ❌ BAD: Implicit any, unclear types
const createField = (config) => {
  return { ...defaultField, ...config };
};
```

**Mandatory Rules:**

- **Strict mode enabled** - `"strict": true` in tsconfig.json
- **No implicit `any`** - All types must be explicit
- **Prefer `interface` over `type`** for object shapes
- **Use `const` by default** - `let` only when reassigning
- **Avoid `enum`** - Use string union types: `type Status = 'draft' | 'published'`
- **Export types** from dedicated `types/` folders

### React Component Rules

```tsx
// ✅ GOOD: Props interface, named export, clear structure
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export const Button = ({ label, onClick, variant = 'primary' }: ButtonProps) => {
  return (
    <button 
      onClick={onClick}
      className={cn('btn', `btn-${variant}`)}
    >
      {label}
    </button>
  );
};
```

**Mandatory Rules:**

- **Functional components only** - No class components
- **Named exports** for components (except pages)
- **Props interface** above component definition
- **Destructure props** in function signature
- **Default values** in destructuring, not inside component
- **Hooks at top** - All hooks before any conditional logic

### Hono API Route Rules

```typescript
// ✅ GOOD: Typed routes with middleware
import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';

const forms = new Hono<{ Bindings: Env }>();

const createFormSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
});

forms.post(
  '/',
  zValidator('json', createFormSchema),
  async (c) => {
    const { name, description } = c.req.valid('json');
    const userId = c.get('userId'); // From auth middleware
    
    // Implementation
    return c.json({ id: 'form_123' }, 201);
  }
);

export default forms;
```

**Mandatory Rules:**

- **Group routes by resource** - Separate Hono apps for `/forms`, `/auth`, etc.
- **Use zod-validator** - Validate ALL input with Zod
- **Type context** - Extend Hono context with custom variables
- **Return typed responses** - Use `c.json<ResponseType>(data)`
- **Type Safety (Hono)** - All Hono handlers must use the `Env` interface from [`backend/src/types/Env.ts`](backend/src/types/Env.ts) for environment access.
- **Database Access (D1)** - All D1 access must be done via the `getDb(env: Env)` utility function from [`backend/src/db/db.ts`](backend/src/db/db.ts). Direct access via `c.env.DB` is forbidden.
- **HTTP status codes** - Use correct codes (201 for created, 204 for no content)
- **Prepared statements only** - Never string concatenation in SQL

### File Naming Conventions

**Frontend:**

- Components: `PascalCase.tsx` (e.g., `FormCanvas.tsx`)
- Hooks: `camelCase` with `use` prefix (e.g., `useFormValidation.ts`)
- Utils: `camelCase.ts` (e.g., `formatDate.ts`)
- Types: `camelCase.ts` (e.g., `formweaver.ts`)

**Backend:**

- Routes: `camelCase.ts` (e.g., `forms.ts`)
- Middleware: `camelCase.ts` (e.g., `auth.ts`)
- SQL files: `snake_case.sql` (e.g., `schema.sql`)
- Migrations: `001_description.sql`

---

## 🎨 Styling Rules

### Tailwind CSS (MANDATORY)

```tsx
// ✅ GOOD: Semantic tokens, no direct colors
<div className="bg-background text-foreground border-border">
  <h1 className="text-2xl font-semibold">Title</h1>
</div>

// ❌ BAD: Direct colors, magic values
<div className="bg-white text-black border-gray-200">
  <h1 className="text-[24px] font-[600]">Title</h1>
</div>
```

**Mandatory Rules:**

- **Use semantic tokens** from `index.css` (--background, --foreground, etc.)
- **NO hardcoded colors** - All colors in HSL format in design system
- **Responsive by default** - Use `md:`, `lg:` prefixes
- **Hover states** - Always add hover effects to interactive elements
- **Dark mode** - Use `dark:` prefix for dark mode styles

### Design Tokens

All colors must use CSS variables defined in `frontend/src/index.css`:

- `--background`, `--foreground` - Base colors
- `--primary`, `--primary-foreground` - Primary action colors
- `--palette`, `--canvas`, `--drop-zone` - Form builder specific

---

## 🔒 Security Rules (CRITICAL)

### Authentication & Authorization

```typescript
// ✅ GOOD: Verify JWT with Workers
import { verify } from 'jose';

const authMiddleware = async (c: Context, next: Next) => {
  const token = c.req.header('Authorization')?.replace('Bearer ', '');
  
  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401);
  }

  try {
    const payload = await verify(token, c.env.JWT_SECRET);
    c.set('userId', payload.sub);
    c.set('workspaceId', payload.workspaceId);
    await next();
  } catch (error) {
    return c.json({ error: 'Invalid token' }, 401);
  }
};
```

**Mandatory Rules:**

- **NEVER trust client headers** - Always verify JWT signature
- **Always check workspace membership** before allowing access
- **Use prepared statements** - Prevent SQL injection (D1 prepared statements only)
- **Hash passwords with bcrypt** - Never store plaintext
- **Use KV for session tokens** - Set appropriate TTLs (30 days for refresh tokens)

### Input Validation

```typescript
// ✅ GOOD: Zod schemas on both client and server
import { z } from 'zod';

const createFormSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
  fields: z.array(z.object({
    type: z.enum(['text', 'email', 'number']),
    label: z.string().min(1).max(100),
    required: z.boolean().optional(),
  })),
});

// Backend validation
forms.post('/', zValidator('json', createFormSchema), async (c) => {
  const data = c.req.valid('json'); // Already validated
  // ... save to D1
});
```

**Mandatory Rules:**

- **Share Zod schemas** between frontend and backend (`/shared/types`)
- **Validate ALL inputs** on both client and server
- **Sanitize HTML** if rendering user content (use DOMPurify)
- **Use prepared statements** - Never concatenate SQL
- **Rate limit by IP** - Use Workers KV for tracking

### Database Security

```sql
-- ✅ GOOD: Check permissions in queries
SELECT * FROM forms 
WHERE id = ? 
AND workspace_id IN (
  SELECT workspace_id 
  FROM workspace_members 
  WHERE user_id = ?
);

-- ❌ BAD: No permission checks
SELECT * FROM forms WHERE id = ?; -- Anyone can access any form
```

**Mandatory Rules:**

- **Row-level security** - All queries check workspace membership
- **Prepared statements only** - Never string interpolation
- **Index all foreign keys** - Performance and data integrity
- **Soft deletes** - Use `deleted_at` column, never hard delete

---

## 🚀 Performance Rules

### Frontend Optimization

```tsx
// ✅ GOOD: Code splitting for heavy components
const FormPreview = lazy(() => import('./FormPreview'));
const PropertyEditor = lazy(() => import('./PropertyEditor'));

<Suspense fallback={<Skeleton />}>
  <FormPreview />
</Suspense>

// ✅ GOOD: Memoize expensive computations
const validationErrors = useMemo(() => {
  return validateForm(fields, schema);
}, [fields, schema]);
```

**Performance Targets:**

- **First Contentful Paint (FCP):** < 1.5s
- **Largest Contentful Paint (LCP):** < 2.5s
- **Time to Interactive (TTI):** < 3.5s
- **Total Bundle Size:** < 200 KB (gzipped)

### Backend Optimization

```typescript
// ✅ GOOD: Cache form schemas in KV
const getFormWithCache = async (env: Env, formId: string) => {
  // Try KV cache first
  const cached = await env.FORM_CACHE.get(`form:${formId}`, 'json');
  if (cached) return cached;

  // Fetch from D1
  const form = await env.DB.prepare(
    'SELECT * FROM forms WHERE id = ?'
  ).bind(formId).first();

  // Cache for 10 minutes
  await env.FORM_CACHE.put(`form:${formId}`, JSON.stringify(form), {
    expirationTtl: 600,
  });

  return form;
};
```

**Performance Targets:**

- **API Latency (p50):** < 50ms globally
- **API Latency (p99):** < 200ms globally
- **D1 Query Time:** < 10ms
- **KV Lookup Time:** < 5ms
- **Workers CPU Time:** < 10ms (per request)

**Optimization Rules:**

- **Use KV for caching** - Cache frequently accessed data (forms, user profiles)
- **Add indexes** - Ensure all queries use indexes
- **Batch operations** - Use `DB.batch()` for multiple queries
- **Limit result sets** - Always paginate (max 100 rows)
- **Select only needed columns** - Avoid `SELECT *`

---

## 🧪 Testing Rules

### Coverage Requirements

- **Utils:** 100% coverage
- **Hooks:** 80% coverage
- **Components:** 60% coverage (focus on logic)
- **API Routes:** 80% coverage

### Test Structure

```typescript
// Frontend: Every utility function must have tests
// utils/validation.test.ts
import { validateEmail } from './validation';

describe('validateEmail', () => {
  it('should accept valid emails', () => {
    expect(validateEmail('user@example.com')).toBe(true);
  });

  it('should reject invalid emails', () => {
    expect(validateEmail('invalid')).toBe(false);
  });
});
```

```typescript
// Backend: Test Hono routes
import { describe, it, expect } from 'vitest';
import app from '../src/index';

describe('POST /forms', () => {
  it('should create a form', async () => {
    const res = await app.request('/forms', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer test-token',
      },
      body: JSON.stringify({ name: 'Test Form' }),
    });

    expect(res.status).toBe(201);
    const data = await res.json();
    expect(data).toHaveProperty('id');
  });
});
```

---

## 📝 Git Workflow Rules

### Branch Naming

```bash
feature/add-file-upload       # New features
fix/submission-validation     # Bug fixes
refactor/form-canvas          # Code improvements
docs/api-documentation        # Documentation
perf/optimize-d1-queries      # Performance improvements
```

### Commit Messages (Conventional Commits)

```bash
# ✅ GOOD: Conventional commits
feat(worker): add file upload endpoint
fix(forms): prevent duplicate field IDs
refactor(db): extract D1 queries to separate file
docs(api): update embedding guide
perf(cache): add KV caching for form schemas

# ❌ BAD: Vague messages
update stuff
fix bug
changes
```

### Pull Request Rules

- **Title:** Clear, descriptive (matches branch name)
- **Description:** What, why, how (use PR template)
- **Screenshots:** For UI changes
- **Tests:** All tests passing (frontend + backend)
- **Review:** Requires 1 approval for features, 2 for security changes
- **Size:** Max 400 lines changed (split large PRs)
- **Wrangler check:** Run `wrangler deploy --dry-run` before merging

---

## 🚢 Deployment Rules

### Pre-Deployment Checks

```bash
# Frontend
cd frontend
npm run type-check       # TypeScript errors
npm run lint             # ESLint warnings
npm run test             # Unit tests
npm run build            # Production build

# Backend
cd backend
npm run type-check       # TypeScript errors
npm run lint             # ESLint warnings
npm run test             # Unit tests
wrangler deploy --dry-run  # Validate deployment
```

### Database Migrations

```bash
# Create migration
wrangler d1 migrations create formweaver-dev add_custom_elements

# Apply migration (local)
wrangler d1 migrations apply formweaver-dev --local

# Apply migration (production)
wrangler d1 migrations apply formweaver-dev --remote
```

**Migration Rules:**

- **Never modify existing migrations** - Create new ones
- **Test locally first** - Always test migrations locally
- **Backup before production** - Keep migration backups
- **Rollback plan** - Document rollback steps

### Deployment Commands

```bash
# Deploy Worker (production)
cd backend
npm run deploy

# Deploy Frontend (Cloudflare Pages)
cd frontend
npm run build
wrangler pages deploy dist

# View logs
wrangler tail
```

---

## 🔧 Environment Variables

### Frontend (.env.local)

```bash
# Public (exposed to browser)
VITE_API_URL=https://api.formweaver.app
VITE_APP_URL=https://formweaver.app
```

### Backend (wrangler.toml + secrets)

```toml
[vars]
ENVIRONMENT = "production"
JWT_EXPIRES_IN = "1h"
REFRESH_TOKEN_EXPIRES_IN = "30d"
```

```bash
# Set secrets with Wrangler CLI
wrangler secret put JWT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put STRIPE_WEBHOOK_SECRET
```

**Rules:**

- **NO secrets in code** - Use Wrangler secrets
- **NO secrets in git** - All `.env*` files in `.gitignore`
- **Document required vars** - List in README.md

---

## 📚 Documentation Rules

### Code Comments

```typescript
// ✅ GOOD: JSDoc for public APIs
/**
 * Validates a form field against its schema
 * @param field - The form field to validate
 * @param value - The current value of the field
 * @returns Validation error message or null if valid
 */
export const validateField = (field: FormField, value: unknown): string | null => {
  // Implementation
};
```

### README Files

Every feature folder must have a README:

- Purpose
- Endpoints/API
- Authentication requirements
- Example usage

---

## ⚠️ Forbidden Patterns

### NEVER Do These

1. **SQL Injection** - Never use string concatenation in SQL

   ```typescript
   // ❌ NEVER
   const query = `SELECT * FROM forms WHERE id = '${formId}'`;
   
   // ✅ ALWAYS
   const stmt = c.env.DB.prepare('SELECT * FROM forms WHERE id = ?');
   const form = await stmt.bind(formId).first();
   ```

2. **Client-Side Auth** - Never trust client-side authentication

   ```typescript
   // ❌ NEVER
   const userId = c.req.query('userId');
   
   // ✅ ALWAYS
   const userId = c.get('userId'); // From verified JWT
   ```

3. **Hardcoded Secrets** - Never commit secrets

   ```typescript
   // ❌ NEVER
   const JWT_SECRET = 'my-secret-key';
   
   // ✅ ALWAYS
   const JWT_SECRET = c.env.JWT_SECRET; // From Wrangler secrets
   ```

4. **Direct Database Access from Frontend** - Always use API

   ```typescript
   // ❌ NEVER (frontend)
   const forms = await db.query('SELECT * FROM forms');
   
   // ✅ ALWAYS
   const forms = await fetch('/api/forms').then(r => r.json());
   ```

5. **Bypass Validation** - Never skip validation

   ```typescript
   // ❌ NEVER
   const data = await c.req.json(); // No validation
   
   // ✅ ALWAYS
   const data = c.req.valid('json'); // Zod validated
   ```

---

## 🎯 Project-Specific Constraints

### Cloudflare Workers Limits

- **CPU Time:** 50ms (free), 30s (paid) - Monitor and optimize
- **Request Size:** 100MB max
- **Response Size:** 100MB max
- **Subrequests:** 50 (free), 1000 (paid)

### D1 Database Limits

- **Database Size:** 1GB per database (beta)
- **Query Timeout:** 30 seconds
- **Concurrent Queries:** Limited by Workers CPU time

**Mitigation:**

- Plan to shard across multiple D1 databases if needed
- Use KV caching to reduce D1 queries
- Optimize queries with proper indexes

### KV Consistency

- **Eventually consistent** - Not immediate
- **Use D1 for critical data** - KV only for caching
- **Cache invalidation** - Delete cache on updates

---

## 📊 Success Metrics

### Technical Metrics

- **Uptime:** 99.99% availability (Cloudflare SLA)
- **Performance:** Form render time < 200ms (p95)
- **API Latency:** < 50ms (p99, measured globally)
- **Error Rate:** < 0.1% of requests
- **CPU Time:** < 10ms per request

### Business Metrics

- **Activation:** % users who create first form within 7 days (Target: 60%)
- **Engagement:** Forms created per workspace per month (Target: 5+)
- **Retention:** % workspaces active month-over-month (Target: 80%)
- **Conversion:** Free to paid conversion rate (Target: 10%)

---

## 🔄 Rule Updates

### Review Cycle

- **Weekly:** Quick scan for outdated best practices
- **Monthly:** Comprehensive review of all sections
- **Quarterly:** Full overhaul based on feedback and industry changes
- **As-needed:** Immediate updates for critical security vulnerabilities

### Change Process

1. Propose changes via PR to `PROJECT_RULES.md`
2. Requires team approval (2+ votes)
3. Update version and last updated date
4. Announce changes in team channel

---

## 📞 Support & Questions

**Questions about these rules?**

- Check [DEV_RULES.md](docs/DEV_RULES.md) for detailed examples
- Ask in team channel or GitHub Discussions
- Propose changes via PR

**Rule Conflicts:**

- Project rules override global AI agent rules
- Always explain WHY project rules override global standards
- Document exceptions and rationale

---

**Version:** 1.0.0  
**Last Updated:** 2025-01-16  
**Next Review:** 2025-02-16  
**Maintained By:** FormWeaver Development Team
