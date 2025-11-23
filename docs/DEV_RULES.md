# Development Rules & Standards

**Project:** FormWeaver SaaS (Cloudflare Workers + Hono)  
**Last Updated:** 2025-11-16  
**Enforcement:** All PRs must pass these checks

---

## 1. Code Style & Formatting

### 1.1 TypeScript Standards

```typescript
// ✅ GOOD: Explicit types, interfaces for objects
interface FormField {
  id: string;
  type: FieldType;
  label: string;
}

const createField = (config: Partial<FormField>): FormField => {
  return { ...defaultField, ...config };
};

// ❌ BAD: Implicit any, unclear types
const createField = (config) => {
  return { ...defaultField, ...config };
};
```

**Rules:**

- **No implicit `any`** - Enable `strict` mode in tsconfig
- **Prefer `interface` over `type`** for object shapes
- **Use `const` by default**, `let` only when reassigning
- **Avoid `enum`** - Use string union types instead
- **Export types** from dedicated `types/` folder

### 1.2 React Component Structure (Frontend)

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

**Rules:**

- **Functional components only** - No class components
- **Named exports** for components (except pages)
- **Props interface** above component definition
- **Destructure props** in function signature
- **Default values** in destructuring, not inside component

### 1.3 Hono API Route Structure (Backend)

```typescript
// ✅ GOOD: Typed routes with middleware
import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';

const forms = new Hono<{ Bindings: Env }>();

const createFormSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().optional(),
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

**Rules:**

- **Group routes by resource** - Separate Hono apps for `/forms`, `/auth`, etc.
- **Use zod-validator** - Validate all input with Zod
- **Type context** - Extend Hono context with custom variables (must use `Env` from [`backend/src/types/Env.ts`](backend/src/types/Env.ts))
- **Return typed responses** - Use `c.json<ResponseType>(data)`
- **HTTP status codes** - Use correct codes (201 for created, 204 for no content)

### 1.4 File Naming

```
Frontend (src/):
  components/
    FieldPalette.tsx          # PascalCase for components
    FormWeaver/
      index.ts                # Barrel exports
      FieldPalette.tsx
      PropertyEditor.tsx

  hooks/
    useFormValidation.ts      # camelCase with 'use' prefix

  utils/
    formatDate.ts             # camelCase for utilities

  types/
    FormWeaver.ts            # camelCase for type files

Backend (backend/):
  routes/
    forms.ts                  # camelCase for route files
    submissions.ts
    auth.ts

  middleware/
    auth.ts                   # camelCase for middleware
    cors.ts
    errorHandler.ts

  db/
    schema.sql                # snake_case for SQL files
    migrations/
      001_initial.sql
      002_add_custom_elements.sql

  utils/
    jwt.ts                    # camelCase for utilities
    validation.ts
```

---

## 2. Architecture Patterns

### 2.1 Project Structure

```
project-root/
├── frontend/                # React app (Vite)
│   ├── src/
│   │   ├── components/      # Reusable UI components
│   │   │   ├── ui/          # shadcn components (don't edit directly)
│   │   │   ├── FormWeaver/
│   │   │   └── common/
│   │   ├── hooks/           # Custom React hooks
│   │   ├── lib/             # Third-party library configs
│   │   ├── pages/           # Route components
│   │   ├── types/           # TypeScript type definitions
│   │   └── utils/           # Helper functions
│   └── package.json
│
├── backend/                 # Cloudflare Worker (Hono API)
│   ├── src/
│   │   ├── index.ts         # Main Hono app entry
│   │   ├── routes/          # API route handlers
│   │   │   ├── auth.ts
│   │   │   ├── forms.ts
│   │   │   ├── submissions.ts
│   │   │   └── billing.ts
│   │   ├── middleware/      # Hono middleware
│   │   │   ├── auth.ts
│   │   │   ├── cors.ts
│   │   │   └── rateLimiter.ts
│   │   ├── db/              # D1 database
│   │   │   ├── db.ts        # D1 utility function (getDb)
│   │   │   ├── schema.sql
│   │   │   └── migrations/  # Migration files
│   │   ├── types/           # TypeScript types (including Env.ts)
│   │   └── utils/           # Helper functions
│   ├── wrangler.toml        # Cloudflare config
│   └── package.json
│
└── shared/                  # Shared types between frontend/backend
    └── types/
        └── api.ts           # API request/response types
```

### 2.2 State Management Rules

**Frontend:**

```tsx
// ✅ GOOD: Local state for UI, context for app-wide
const FormCanvas = () => {
  const [fields, setFields] = useState<FormField[]>([]); // Local
  const { workspace } = useWorkspace(); // Context

  return <div>...</div>;
};
```

**When to use each:**

- **`useState`** - Component-local UI state (toggles, inputs)
- **Context API** - App-wide state (auth, theme, workspace)
- **TanStack Query** - Server state (forms, submissions)
- **Zustand** - Complex client state (form designer state)

### 2.3 Data Fetching

**Frontend (React Query):**

```tsx
// ✅ GOOD: TanStack Query for server state
import { useQuery } from '@tanstack/react-query';

const useForm = (formId: string) => {
  return useQuery({
    queryKey: ['form', formId],
    queryFn: async () => {
      const res = await fetch(`/api/forms/${formId}`, {
        headers: {
          'Authorization': `Bearer ${getToken()}`,
        },
      });
      if (!res.ok) throw new Error('Failed to fetch form');
      return res.json();
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};
```

**Backend (D1 Queries):**

```typescript
// ✅ GOOD: Prepared statements with D1
const getFormById = async (db: D1Database | D1Database, formId: string) => { // Use getDb(env)
  const stmt = db.prepare(
    'SELECT * FROM forms WHERE id = ? AND deleted_at IS NULL'
  );
  return await stmt.bind(formId).first<Form>();
};

// ❌ BAD: String interpolation (SQL injection risk)
const query = `SELECT * FROM forms WHERE id = '${formId}'`; // NEVER DO THIS
```

**Rules:**

- **Use TanStack Query** for all server data fetching (frontend)
- **Use D1 prepared statements** for all database queries (backend)
- **All D1 access** must be done via the `getDb(env: Env)` utility function from [`backend/src/db/db.ts`](backend/src/db/db.ts).
- **Invalidate queries** on mutations
- **Optimistic updates** for instant feedback
- **Error boundaries** to catch rendering errors

---

## 3. Styling Guidelines

### 3.1 Tailwind CSS Usage

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

**Rules:**

- **Use semantic tokens** from `index.css` (--background, --foreground, etc.)
- **No hardcoded colors** - All colors in HSL format in design system
- **Responsive by default** - Use `md:`, `lg:` prefixes
- **Hover states** - Always add hover effects to interactive elements
- **Dark mode** - Use `dark:` prefix for dark mode styles

### 3.2 Design Tokens (index.css)

```css
:root {
  /* Core colors - ALWAYS use these */
  --background: 220 15% 97%;
  --foreground: 220 10% 10%;
  --primary: 215 85% 55%;
  --primary-foreground: 0 0% 100%;
  
  /* Feature-specific colors */
  --palette: 220 12% 94%;
  --canvas: 0 0% 100%;
  --drop-zone: 215 85% 55%;
  
  /* Shadows & gradients */
  --shadow-elegant: 0 10px 30px -10px hsl(var(--primary) / 0.15);
  --gradient-primary: linear-gradient(135deg, hsl(var(--primary)), hsl(var(--primary) / 0.8));
}
```

### 3.3 Component Variants (shadcn)

```tsx
// button.tsx - Add custom variants
const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md transition-colors",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        outline: "border border-input bg-background hover:bg-accent",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        // Custom variant for FormWeaver
        canvas: "bg-canvas border border-border hover:bg-palette",
      },
    },
  }
);
```

---

## 4. Security Rules (CRITICAL)

### 4.1 Authentication & Authorization (Cloudflare Workers)

**JWT Token Management:**

```typescript
// ✅ GOOD: Verify JWT with Workers
import { verify } from '@tsndr/cloudflare-worker-jwt';

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

// ❌ BAD: Trusting client-side data
const userId = c.req.query('userId'); // NEVER DO THIS
```

**D1 Row-Level Security:**

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

**CRITICAL RULES:**

- **NEVER trust client headers** - Always verify JWT signature
- **Always check workspace membership** before allowing access
- **Use prepared statements** - Prevent SQL injection
- **Hash passwords with bcrypt** - Never store plaintext
- **Use KV for session tokens** - Set appropriate TTLs
- **Rate limit all endpoints** - Use Cloudflare Rate Limiting API

### 4.2 Input Validation (Zod)

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

// Frontend validation (same schema)
const result = createFormSchema.safeParse(formData);
if (!result.success) {
  return { error: result.error.format() };
}
```

**Rules:**

- **Share Zod schemas** between frontend and backend (`/shared/types`)
- **Validate ALL inputs** on both client and server
- **Sanitize HTML** if rendering user content (use DOMPurify)
- **Use prepared statements** - Never concatenate SQL
- **Rate limit by IP** - Use Workers KV for tracking

### 4.3 Custom Element Sandboxing

```tsx
// ✅ GOOD: Isolated iframe with CSP
<iframe
  srcDoc={customElementCode}
  sandbox="allow-scripts allow-same-origin"
  style={{ border: 'none', width: '100%', height: '100%' }}
  title="Custom Element Preview"
/>

// Add Content Security Policy in Worker
app.use('*', async (c, next) => {
  await next();
  c.header('Content-Security-Policy', "script-src 'self' 'unsafe-inline'; object-src 'none';");
});
```

**Rules:**

- **Always sandbox custom elements** in iframes
- **Use Content Security Policy** headers in Workers
- **Validate custom element code** before saving (AST parsing)
- **Limit execution time** - Use Workers CPU time limits
- **No external script loading** - Only allow inline code

### 4.4 CORS Configuration

```typescript
// ✅ GOOD: Strict CORS with Hono
import { cors } from 'hono/cors';

app.use('/api/*', cors({
  origin: ['https://FormWeaver.app', 'http://localhost:5173'],
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowHeaders: ['Authorization', 'Content-Type'],
  credentials: true,
  maxAge: 86400, // 24 hours
}));

// ❌ BAD: Wildcard CORS
app.use('*', cors({ origin: '*' })); // NEVER DO THIS
```

---

## 5. Performance Rules

### 5.1 Frontend Optimization

**Lazy Loading:**

```tsx
// ✅ GOOD: Code splitting for heavy components
const FormPreview = lazy(() => import('./FormPreview'));
const PropertyEditor = lazy(() => import('./PropertyEditor'));

<Suspense fallback={<Skeleton />}>
  <FormPreview />
</Suspense>
```

**Memoization:**

```tsx
// ✅ GOOD: Memoize expensive computations
const validationErrors = useMemo(() => {
  return validateForm(fields, schema);
}, [fields, schema]);

// ✅ GOOD: Memoize callbacks passed to children
const handleFieldUpdate = useCallback((id: string, field: FormField) => {
  setFields(fields.map(f => f.id === id ? field : f));
}, [fields]);
```

### 5.2 Backend Optimization (Workers + D1)

**D1 Query Optimization:**

```sql
-- ✅ GOOD: Add indexes for common queries
CREATE INDEX idx_forms_workspace_id ON forms(workspace_id);
CREATE INDEX idx_submissions_form_id ON submissions(form_id);
CREATE INDEX idx_submissions_created_at ON submissions(created_at DESC);

-- ✅ GOOD: Use partial indexes for filtered queries
CREATE INDEX idx_published_forms 
ON forms(workspace_id, created_at) 
WHERE status = 'published';

-- ✅ GOOD: Composite indexes for multi-column queries
CREATE INDEX idx_forms_workspace_status 
ON forms(workspace_id, status, created_at DESC);
```

**Workers KV Caching:**

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

// Invalidate cache on update
await env.FORM_CACHE.delete(`form:${formId}`);
```

**Workers Performance Rules:**

- **Use KV for caching** - Cache frequently accessed data (forms, user profiles)
- **Prepare statements** - D1 prepared statements are faster
- **Limit result sets** - Always paginate (max 100 rows)
- **Select only needed columns** - Avoid `SELECT *`
- **Use Workers Analytics** - Monitor CPU time and request duration
- **Set cache headers** - Use `Cache-Control` for public endpoints

### 5.3 Workers Resource Limits

```typescript
// Monitor CPU time
const start = Date.now();
// ... do work
const duration = Date.now() - start;
if (duration > 50) {
  console.warn(`Slow request: ${duration}ms`);
}

// Respect limits:
// - CPU time: 50ms (free), 30s (paid)
// - Request size: 100MB
// - Response size: 100MB
// - Subrequests: 50 (free), 1000 (paid)
```

---

## 6. Testing Requirements

### 6.1 Unit Tests (Frontend & Backend)

```tsx
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
// Backend: Test Hono routes with Vitest
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

**Coverage Requirements:**

- **Utils:** 100% coverage
- **Hooks:** 80% coverage
- **Components:** 60% coverage (focus on logic)
- **API Routes:** 80% coverage

### 6.2 Integration Tests (Frontend)

```tsx
// Test user flows with React Testing Library
import { render, screen, fireEvent } from '@testing-library/react';

test('user can create a form field', async () => {
  render(<FormWeaver />);
  
  // Drag field from palette
  const textField = screen.getByText('Text Input');
  fireEvent.dragStart(textField);
  
  const canvas = screen.getByTestId('form-canvas');
  fireEvent.drop(canvas);
  
  // Verify field appears
  expect(screen.getByText('Untitled Field')).toBeInTheDocument();
});
```

### 6.3 E2E Tests (Critical Paths)

```typescript
// Use Playwright for E2E tests
import { test, expect } from '@playwright/test';

test('user can create and publish form', async ({ page }) => {
  // Login
  await page.goto('/login');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password');
  await page.click('button[type="submit"]');

  // Create form
  await page.click('text=New Form');
  await page.fill('[name="formName"]', 'Contact Form');
  
  // Add field
  await page.dragAndDrop('.field-palette >> text=Email', '.form-canvas');
  
  // Publish
  await page.click('text=Publish');
  await expect(page.locator('.toast')).toContainText('Form published');
});
```

**Critical E2E Paths:**

- User signup → Create form → Publish → Submit
- User creates custom element → Uses in form → Receives submission
- User upgrades plan → Creates more forms → Billing updates

---

## 7. Git Workflow

### 7.1 Branch Naming

```bash
feature/add-file-upload       # New features
fix/submission-validation     # Bug fixes
refactor/form-canvas          # Code improvements
docs/api-documentation        # Documentation
perf/optimize-d1-queries      # Performance improvements
```

### 7.2 Commit Messages

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

### 7.3 Pull Request Rules

- **Title:** Clear, descriptive (matches branch name)
- **Description:** What, why, how (use PR template)
- **Screenshots:** For UI changes
- **Tests:** All tests passing (frontend + backend)
- **Review:** Requires 1 approval for features, 2 for security changes
- **Size:** Max 400 lines changed (split large PRs)
- **Wrangler check:** Run `wrangler deploy --dry-run` before merging

---

## 8. Error Handling

### 8.1 User-Facing Errors (Frontend)

```tsx
// ✅ GOOD: Helpful error messages
try {
  await saveForm(formData);
  toast.success('Form saved successfully!');
} catch (error) {
  if (error.code === 'FORM_NAME_EXISTS') {
    toast.error('A form with this name already exists. Please choose a different name.');
  } else {
    toast.error('Failed to save form. Please try again.');
    console.error('Save form error:', error);
  }
}

// ❌ BAD: Technical jargon
toast.error('D1 error: UNIQUE constraint failed');
```

### 8.2 API Error Handling (Backend)

```typescript
// ✅ GOOD: Structured error responses
app.onError((err, c) => {
  console.error('[API Error]', {
    path: c.req.path,
    method: c.req.method,
    error: err.message,
    stack: err.stack,
    userId: c.get('userId'),
  });

  if (err instanceof ZodError) {
    return c.json({ error: 'Validation failed', details: err.errors }, 400);
  }

  if (err.message.includes('UNIQUE constraint')) {
    return c.json({ error: 'Resource already exists', code: 'DUPLICATE' }, 409);
  }

  // Generic error
  return c.json({ error: 'Internal server error' }, 500);
});
```

### 8.3 Logging (Workers)

```typescript
// ✅ GOOD: Structured logging with context
console.error('[FormCanvas] Failed to add field', {
  fieldType: draggedField.type,
  workspaceId,
  userId: c.get('userId'),
  error: error.message,
  timestamp: new Date().toISOString(),
});

// Use Workers Logpush for production logs
// Configure in wrangler.toml:
// [observability]
// enabled = true
```

---

## 9. Accessibility (a11y)

### 9.1 Required Standards

- **WCAG 2.1 Level AA** compliance
- **Keyboard navigation** - All interactions accessible via keyboard
- **Screen reader support** - Proper ARIA labels
- **Color contrast** - Minimum 4.5:1 for normal text
- **Focus indicators** - Visible focus states on all interactive elements

### 9.2 Implementation

```tsx
// ✅ GOOD: Accessible form field
<label htmlFor="email" className="sr-only">Email</label>
<input
  id="email"
  type="email"
  aria-required="true"
  aria-invalid={hasError}
  aria-describedby={hasError ? "email-error" : undefined}
/>
{hasError && (
  <span id="email-error" role="alert" className="text-destructive">
    Please enter a valid email address
  </span>
)}
```

---

## 10. Documentation Requirements

### 10.1 Code Comments

```tsx
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

```typescript
// ✅ GOOD: Document Hono routes
/**
 * Create a new form
 * @route POST /forms
 * @auth Required
 * @body { name: string, description?: string }
 * @returns { id: string, name: string, createdAt: string }
 */
forms.post('/', zValidator('json', createFormSchema), async (c) => {
  // Implementation
});
```

### 10.2 README Files

Every feature folder must have a README:

```markdown
# Forms API

## Purpose
CRUD operations for form management.

## Endpoints
- `POST /forms` - Create form
- `GET /forms` - List forms
- `GET /forms/:id` - Get form by ID
- `PUT /forms/:id` - Update form
- `DELETE /forms/:id` - Delete form

## Authentication
All endpoints require Bearer token in Authorization header.

## Example
\`\`\`bash
curl -X POST https://api.FormWeaver.app/forms \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Contact Form"}'
\`\`\`
```

---

## 11. Environment Variables

### 11.1 Frontend (.env)

```bash
# Public (exposed to browser)
VITE_API_URL=https://api.FormWeaver.app
VITE_APP_URL=https://FormWeaver.app
```

### 11.2 Backend (wrangler.toml)

```toml
name = "FormWeaver-api"
main = "src/index.ts"
compatibility_date = "2025-01-01"

[vars]
ENVIRONMENT = "production"

# Secrets (set with wrangler secret put)
# JWT_SECRET
# STRIPE_SECRET_KEY
# STRIPE_WEBHOOK_SECRET

[[d1_databases]]
binding = "DB"
database_name = "FormWeaver"
database_id = "xxx"

[[kv_namespaces]]
binding = "FORM_CACHE"
id = "xxx"

[[kv_namespaces]]
binding = "SESSION_STORE"
id = "xxx"

[[r2_buckets]]
binding = "FILE_UPLOADS"
bucket_name = "FormWeaver-uploads"
```

### 11.3 Setting Secrets

```bash
# Set secrets with Wrangler CLI
wrangler secret put JWT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put STRIPE_WEBHOOK_SECRET

# List secrets
wrangler secret list

# Delete secret
wrangler secret delete JWT_SECRET
```

---

## 12. Code Review Checklist

Before approving any PR, verify:

**Frontend:**

- [ ] TypeScript strict mode passes with no errors
- [ ] All semantic tokens used (no direct colors)
- [ ] Error messages are user-friendly
- [ ] Loading states shown for async operations
- [ ] Responsive design tested on mobile
- [ ] Keyboard navigation works

**Backend:**

- [ ] All endpoints have Zod validation
- [ ] D1 queries use prepared statements
- [ ] JWT tokens verified in auth middleware
- [ ] Workspace membership checked before access
- [ ] Rate limiting applied to public endpoints
- [ ] CORS headers configured correctly
- [ ] Error handling with structured responses

**Both:**

- [ ] Tests added for new functionality
- [ ] Documentation updated
- [ ] No console.log in production code
- [ ] Performance tested (no slow queries/renders)

---

## 13. Deployment

### 13.1 Pre-Deployment Checks

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

### 13.2 Database Migrations (D1)

```bash
# Create migration
wrangler d1 migrations create FormWeaver add_custom_elements

# Apply migration (local)
wrangler d1 migrations apply FormWeaver --local

# Apply migration (production)
wrangler d1 migrations apply FormWeaver --remote

# List migrations
wrangler d1 migrations list FormWeaver
```

```sql
-- migrations/0001_add_custom_elements.sql
CREATE TABLE custom_elements (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL,
  name TEXT NOT NULL,
  code TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE
);

CREATE INDEX idx_custom_elements_workspace 
ON custom_elements(workspace_id);
```

### 13.3 Deployment Commands

```bash
# Deploy Worker (production)
wrangler deploy

# Deploy Worker (staging)
wrangler deploy --env staging

# Rollback to previous version
wrangler rollback

# View deployment logs
wrangler tail

# View live logs with filters
wrangler tail --format pretty --status error
```

### 13.4 Rollback Plan

- **Worker Code:** Use `wrangler rollback` to revert to previous deployment
- **Database:** Keep migration backups before applying to production
- **KV Data:** Backup critical KV data before major updates
- **Feature Flags:** Use environment variables to toggle features
- **Monitor:** Set up alerts for error spike (>1% error rate)

```bash
# Rollback worker deployment
wrangler rollback

# View deployment history
wrangler deployments list

# Rollback to specific version
wrangler rollback --version <version-id>
```

### 13.5 Monitoring & Alerts

**Workers Analytics Dashboard:**

- Monitor request count, error rate, CPU time
- Set up email alerts for:
  - Error rate > 1%
  - P99 latency > 100ms
  - Request volume spike (>10x normal)

**Custom Metrics:**

```typescript
// Track custom metrics with Workers Analytics Engine
app.use('*', async (c, next) => {
  const start = Date.now();
  await next();
  const duration = Date.now() - start;
  
  // Log slow requests
  if (duration > 50) {
    c.env.ANALYTICS.writeDataPoint({
      blobs: ['slow_request', c.req.path],
      doubles: [duration],
      indexes: [c.get('userId') || 'anonymous'],
    });
  }
});
```

**Sentry Integration:**

```typescript
import * as Sentry from '@sentry/browser';

Sentry.init({
  dsn: 'YOUR_SENTRY_DSN',
  environment: c.env.ENVIRONMENT,
  beforeSend(event) {
    // Filter sensitive data
    delete event.request?.cookies;
    return event;
  },
});
```

---

## 14. Cloudflare-Specific Best Practices

### 14.1 D1 Database Best Practices

**Connection Management:**

```typescript
// ✅ GOOD: Access D1 via environment bindings
const getForm = async (env: Env, formId: string) => {
  const db = getDb(env); // Use the utility function
  return await db.prepare(
    'SELECT * FROM forms WHERE id = ?'
  ).bind(formId).first();
};

// ❌ BAD: Direct access to c.env.DB
// All D1 access must be done via getDb(env)
```

**Batch Operations:**

```typescript
// ✅ GOOD: Use batch() for multiple queries
const db = getDb(env);
const results = await db.batch([
  db.prepare('SELECT * FROM forms WHERE workspace_id = ?').bind(workspaceId),
  db.prepare('SELECT COUNT(*) FROM submissions WHERE form_id = ?').bind(formId),
]);

const [forms, submissionCount] = results;
```

**Transaction Support:**

```typescript
// ✅ GOOD: Use transactions for related operations
const db = getDb(env);
await db.prepare(
  `BEGIN TRANSACTION;
   INSERT INTO forms (id, name, workspace_id) VALUES (?, ?, ?);
   INSERT INTO form_audit (form_id, action) VALUES (?, 'created');
   COMMIT;`
).bind(formId, formName, workspaceId, formId).run();
```

### 14.2 KV Storage Best Practices

**Cache Patterns:**

```typescript
// ✅ GOOD: Cache-aside pattern
const getCachedForm = async (env: Env, formId: string) => {
  const cacheKey = `form:${formId}`;
  
  // Try cache first
  const cached = await env.FORM_CACHE.get(cacheKey, 'json');
  if (cached) {
    console.log('Cache hit:', formId);
    return cached;
  }
  
  // Fetch from D1
  const db = getDb(env);
  const form = await db.prepare(
    'SELECT * FROM forms WHERE id = ?'
  ).bind(formId).first();
  
  if (form) {
    // Cache for 10 minutes
    await env.FORM_CACHE.put(cacheKey, JSON.stringify(form), {
      expirationTtl: 600,
    });
  }
  
  return form;
};

// Invalidate on update
await env.FORM_CACHE.delete(`form:${formId}`);
```

**KV Limits:**

- Key size: 512 bytes max
- Value size: 25 MB max
- Metadata: 1 KB max
- List operations: 1000 keys max per request

### 14.3 R2 Storage Best Practices

**File Upload Pattern:**

```typescript
// ✅ GOOD: Upload to R2 with metadata
forms.post('/upload', async (c) => {
  const formData = await c.req.formData();
  const file = formData.get('file') as File;
  
  const fileKey = `uploads/${crypto.randomUUID()}-${file.name}`;
  
  await c.env.FILE_UPLOADS.put(fileKey, file.stream(), {
    httpMetadata: {
      contentType: file.type,
    },
    customMetadata: {
      uploadedBy: c.get('userId'),
      uploadedAt: new Date().toISOString(),
    },
  });
  
  return c.json({ url: `/files/${fileKey}` });
});

// Serve file with signed URL
forms.get('/files/:key', async (c) => {
  const key = c.req.param('key');
  const object = await c.env.FILE_UPLOADS.get(key);
  
  if (!object) {
    return c.json({ error: 'File not found' }, 404);
  }
  
  return new Response(object.body, {
    headers: {
      'Content-Type': object.httpMetadata.contentType || 'application/octet-stream',
      'Cache-Control': 'public, max-age=31536000',
    },
  });
});
```

### 14.4 Rate Limiting

**IP-based Rate Limiting:**

```typescript
// ✅ GOOD: Rate limit using KV
const rateLimitMiddleware = (limit: number, window: number) => {
  return async (c: Context, next: Next) => {
    const ip = c.req.header('CF-Connecting-IP') || 'unknown';
    const key = `ratelimit:${ip}:${c.req.path}`;
    
    const current = await c.env.RATE_LIMIT.get(key);
    const count = current ? parseInt(current) : 0;
    
    if (count >= limit) {
      return c.json({ error: 'Too many requests' }, 429);
    }
    
    await c.env.RATE_LIMIT.put(key, String(count + 1), {
      expirationTtl: window,
    });
    
    await next();
  };
};

// Apply to public endpoints
app.post('/f/:formId/submit', rateLimitMiddleware(10, 60), async (c) => {
  // Handle submission
});
```

**Use Cloudflare Rate Limiting Rules:**

```typescript
// For production, use Cloudflare dashboard to set up rate limiting rules:
// - Public form submissions: 10 req/min per IP
// - API endpoints: 100 req/min per user
// - Authentication: 5 req/min per IP
```

### 14.5 Edge Caching

**Cache-Control Headers:**

```typescript
// ✅ GOOD: Set appropriate cache headers
app.get('/f/:formId', async (c) => {
  const form = await getForm(c.env, c.req.param('formId'));
  
  return c.json(form, 200, {
    'Cache-Control': 'public, max-age=300, s-maxage=600',
    'CDN-Cache-Control': 'max-age=600',
  });
});

// Never cache authenticated requests
app.get('/forms', authMiddleware, async (c) => {
  const forms = await getUserForms(c.env, c.get('userId'));
  
  return c.json(forms, 200, {
    'Cache-Control': 'private, no-cache',
  });
});
```

**Workers Cache API:**

```typescript
// ✅ GOOD: Use Workers Cache API for dynamic content
const cache = caches.default;

app.get('/public/forms/:id', async (c) => {
  const cacheKey = new Request(c.req.url, c.req.raw);
  const cachedResponse = await cache.match(cacheKey);
  
  if (cachedResponse) {
    return cachedResponse;
  }
  
  const form = await getPublicForm(c.env, c.req.param('id'));
  const response = c.json(form);
  
  // Cache for 5 minutes
  c.executionCtx.waitUntil(
    cache.put(cacheKey, response.clone())
  );
  
  return response;
});
```

### 14.6 Durable Objects (Post-MVP)

**Use Cases:**

- Real-time collaboration (WebSocket connections)
- Rate limiting with state
- Distributed locks
- Session management

```typescript
// ✅ GOOD: Durable Object for real-time collaboration
export class FormEditor {
  state: DurableObjectState;
  sessions: Set<WebSocket>;
  
  constructor(state: DurableObjectState) {
    this.state = state;
    this.sessions = new Set();
  }
  
  async fetch(request: Request) {
    if (request.headers.get('Upgrade') === 'websocket') {
      const [client, server] = Object.values(new WebSocketPair());
      
      this.sessions.add(server);
      server.accept();
      
      server.addEventListener('message', (event) => {
        // Broadcast to all sessions
        this.sessions.forEach(session => {
          if (session !== server && session.readyState === 1) {
            session.send(event.data);
          }
        });
      });
      
      return new Response(null, { status: 101, webSocket: client });
    }
    
    return new Response('Expected WebSocket', { status: 400 });
  }
}
```

---

## 15. API Versioning

### 15.1 Version Strategy

```typescript
// ✅ GOOD: Version in URL path
const api = new Hono().basePath('/api/v1');

api.get('/forms', async (c) => {
  // v1 implementation
});

// v2 with breaking changes
const apiV2 = new Hono().basePath('/api/v2');

apiV2.get('/forms', async (c) => {
  // v2 implementation with new response format
});

// Mount both versions
app.route('/', api);
app.route('/', apiV2);
```

### 15.2 Deprecation Policy

- **Announce deprecation** - 90 days before removal
- **Add deprecation header** - `X-API-Deprecated: true`
- **Update documentation** - Mark deprecated endpoints
- **Provide migration guide** - Clear upgrade path

```typescript
// Add deprecation warning
app.get('/api/v1/forms', async (c) => {
  c.header('X-API-Deprecated', 'true');
  c.header('X-API-Sunset', '2025-06-01');
  c.header('Link', '</api/v2/forms>; rel="successor-version"');
  
  // Implementation
});
```

---

## 16. Security Checklist

Before launching, verify:

**Authentication:**

- [ ] JWT tokens have expiration (1 hour for access, 30 days for refresh)
- [ ] Passwords hashed with bcrypt (cost factor 10+)
- [ ] Email verification required before accessing app
- [ ] Password reset tokens expire after 1 hour
- [ ] Rate limiting on auth endpoints (5 attempts/min)

**Authorization:**

- [ ] All D1 queries check workspace membership
- [ ] API endpoints verify user has required role
- [ ] File uploads restricted to authenticated users
- [ ] Public form submissions rate limited

**Input Validation:**

- [ ] All endpoints use Zod validation
- [ ] HTML sanitized before rendering (DOMPurify)
- [ ] SQL injection prevented (prepared statements only)
- [ ] XSS prevented (proper escaping)
- [ ] File upload types restricted (.jpg, .png, .pdf only)

**Headers:**

- [ ] Content-Security-Policy configured
- [ ] X-Frame-Options: DENY (except embed endpoint)
- [ ] X-Content-Type-Options: nosniff
- [ ] Strict-Transport-Security (HSTS)
- [ ] CORS restricted to known origins

**Secrets:**

- [ ] All secrets stored in Wrangler secrets (not in code)
- [ ] JWT secret is strong (32+ characters)
- [ ] Stripe webhook secret verified
- [ ] API keys rotated regularly

---

## 17. Performance Budget

### 17.1 Frontend Metrics

- **First Contentful Paint (FCP):** < 1.5s
- **Largest Contentful Paint (LCP):** < 2.5s
- **Time to Interactive (TTI):** < 3.5s
- **Total Bundle Size:** < 200 KB (gzipped)
- **Lighthouse Score:** > 90

### 17.2 Backend Metrics

- **API Response Time (p50):** < 50ms
- **API Response Time (p99):** < 200ms
- **D1 Query Time:** < 10ms
- **KV Lookup Time:** < 5ms
- **Workers CPU Time:** < 10ms (per request)

### 17.3 Monitoring

```typescript
// Track performance metrics
app.use('*', async (c, next) => {
  const start = Date.now();
  await next();
  const duration = Date.now() - start;
  
  c.header('Server-Timing', `total;dur=${duration}`);
  
  // Alert if slow
  if (duration > 100) {
    console.warn('Slow request', {
      path: c.req.path,
      duration,
      userId: c.get('userId'),
    });
  }
});
```

---

## 18. Contact & Support

**Questions about these rules?**

- Slack: #engineering channel
- Email: <dev@FormWeaver.app>
- GitHub Discussions: Technical debates

**Rule Changes:**

- Propose changes via RFC (Request for Comments) PR
- Requires team approval (4+ votes)
- Update DEV_RULES.md version and last updated date

**Cloudflare Resources:**

- [Workers Documentation](https://developers.cloudflare.com/workers/)
- [Hono Documentation](https://hono.dev)
- [D1 Documentation](https://developers.cloudflare.com/d1/)
- [KV Documentation](https://developers.cloudflare.com/kv/)
- [R2 Documentation](https://developers.cloudflare.com/r2/)

---

## 19. Common Patterns & Recipes

### 19.1 Pagination

```typescript
// ✅ GOOD: Cursor-based pagination with D1
const listForms = async (env: Env, workspaceId: string, cursor?: string, limit = 20) => {
  let query = getDb(env).prepare(`
    SELECT * FROM forms 
    WHERE workspace_id = ? 
    AND (? IS NULL OR created_at < ?)
    ORDER BY created_at DESC 
    LIMIT ?
  `);
  
  const forms = await query
    .bind(workspaceId, cursor, cursor, limit + 1)
    .all();
  
  const hasMore = forms.results.length > limit;
  const items = hasMore ? forms.results.slice(0, -1) : forms.results;
  const nextCursor = hasMore ? items[items.length - 1].created_at : null;
  
  return { items, nextCursor, hasMore };
};
```

### 19.2 Bulk Operations

```typescript
// ✅ GOOD: Batch delete with D1
const deleteForms = async (env: Env, formIds: string[]) => {
  const placeholders = formIds.map(() => '?').join(',');
  
  return await getDb(env).prepare(
    `DELETE FROM forms WHERE id IN (${placeholders})`
  ).bind(...formIds).run();
};
```

### 19.3 Search

```typescript
// ✅ GOOD: Full-text search with D1
const searchForms = async (env: Env, workspaceId: string, query: string) => {
  return await getDb(env).prepare(`
    SELECT * FROM forms 
    WHERE workspace_id = ? 
    AND (name LIKE ? OR description LIKE ?)
    ORDER BY created_at DESC
    LIMIT 50
  `).bind(workspaceId, `%${query}%`, `%${query}%`).all();
};
```

### 19.4 Soft Delete

```typescript
// ✅ GOOD: Soft delete pattern
const softDeleteForm = async (env: Env, formId: string) => {
  await getDb(env).prepare(
    'UPDATE forms SET deleted_at = ? WHERE id = ?'
  ).bind(Date.now(), formId).run();
  
  // Invalidate cache
  await env.FORM_CACHE.delete(`form:${formId}`);
};

// Exclude deleted in queries
const getActiveForms = async (env: Env, workspaceId: string) => {
  return await getDb(env).prepare(
    'SELECT * FROM forms WHERE workspace_id = ? AND deleted_at IS NULL'
  ).bind(workspaceId).all();
};
```

---

## 20. Troubleshooting Guide

### 20.1 Common Issues

**"Worker exceeded CPU time limit"**

- **Cause:** Expensive computation or slow D1 query
- **Solution:** Optimize queries, add indexes, use KV caching

**"D1 query timeout"**

- **Cause:** Missing index or large result set
- **Solution:** Add index, paginate results, use LIMIT

**"KV namespace not found"**

- **Cause:** Binding not configured in wrangler.toml
- **Solution:** Add KV binding and redeploy

**"CORS error in browser"**

- **Cause:** Missing or incorrect CORS headers
- **Solution:** Configure CORS middleware with correct origins

**"JWT verification failed"**

- **Cause:** Token expired or wrong secret
- **Solution:** Check JWT_SECRET, verify token expiration

### 20.2 Debugging Tips

**Local Development:**

```bash
# Run with detailed logging
wrangler dev --log-level debug

# View D1 database
wrangler d1 execute FormWeaver --command "SELECT * FROM forms LIMIT 5"

# View KV data
wrangler kv:key get --binding=FORM_CACHE "form:123"
```

**Production Debugging:**

```bash
# Live tail logs
wrangler tail --format pretty

# Filter for errors
wrangler tail --status error

# Search logs
wrangler tail --search "form_123"
```

---

## 21. Marketplace Development Standards

### 21.1 Template Marketplace API Development Patterns

```typescript
// ✅ GOOD: Marketplace API with proper validation and security
interface TemplateMetadata {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
  creatorId: string;
  version: string;
  features: string[];
  rating: number;
  salesCount: number;
}

const templates = new Hono<{ Bindings: Env }>();

// Template listing with filtering and search
templates.get(
  '/',
  zValidator('query', z.object({
    category: z.string().optional(),
    minPrice: z.number().optional(),
    maxPrice: z.number().optional(),
    search: z.string().optional(),
    sortBy: z.enum(['price', 'rating', 'sales', 'newest']).optional(),
    limit: z.number().max(50).optional(),
    offset: z.number().optional(),
  })),
  async (c) => {
    const filters = c.req.valid('query');
    const templates = await searchTemplates(c.env, filters);
    return c.json({ templates, total: templates.length });
  }
);

// Template purchase endpoint
templates.post(
  '/:templateId/purchase',
  authMiddleware,
  zValidator('json', z.object({
    useCase: z.string().max(200).optional(),
    customizations: z.record(z.any()).optional(),
  })),
  async (c) => {
    const { templateId } = c.req.param();
    const { useCase, customizations } = c.req.valid('json');
    const userId = c.get('userId');
    
    const purchase = await createTemplatePurchase(
      c.env,
      templateId,
      userId,
      useCase,
      customizations
    );
    return c.json(purchase, 201);
  }
);
```

**Rules:**

- **Template categorization** - Use consistent taxonomy: `/category/industry/complexity/`
- **Search functionality** - Implement full-text search with filters for price, rating, features
- **Template validation** - All templates must pass security and functionality validation before listing
- **Version management** - Support template versioning with rollback capabilities
- **Pricing tiers** - Follow established pricing structure (Free, $19, $49, $149)
- **Creator attribution** - Always include creator information and links

### 21.2 Creator Dashboard Component Architecture

```tsx
// ✅ GOOD: Creator dashboard with proper state management
interface CreatorDashboardProps {
  creatorId: string;
}

export const CreatorDashboard = ({ creatorId }: CreatorDashboardProps) => {
  const { data: analytics, isLoading } = useQuery({
    queryKey: ['creator-analytics', creatorId],
    queryFn: () => fetchCreatorAnalytics(env, creatorId),
    refetchInterval: 5 * 60 * 1000, // Refetch every 5 minutes
  });

  const { data: templates } = useQuery({
    queryKey: ['creator-templates', creatorId],
    queryFn: () => fetchCreatorTemplates(env, creatorId),
  });

  return (
    <div className="creator-dashboard">
      <CreatorAnalytics analytics={analytics} />
      <TemplateManagement templates={templates} />
      <EarningsOverview analytics={analytics} />
    </div>
  );
};

// Creator earnings component
const EarningsOverview = ({ analytics }) => {
  const [payoutMethod, setPayoutMethod] = useState('stripe');
  
  return (
    <Card>
      <CardHeader>
        <CardTitle>Earnings Summary</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-3 gap-4">
          <EarningCard title="This Month" amount={analytics.monthlyEarnings} />
          <EarningCard title="Total Sales" amount={analytics.totalSales} />
          <EarningCard title="Pending Payout" amount={analytics.pendingPayout} />
        </div>
        <PayoutSettings
          method={payoutMethod}
          onMethodChange={setPayoutMethod}
        />
      </CardContent>
    </Card>
  );
};
```

**Architecture Requirements:**

- **Real-time analytics** - Live sales, views, conversion rates
- **Template management** - Create, edit, version, and retire templates
- **Earnings tracking** - Detailed breakdown of commissions and fees
- **Payout management** - Stripe Connect integration for automated payments
- **Support system** - Ticket management for customer inquiries

### 21.3 Commission and Payout System Development Rules

```typescript
// ✅ GOOD: Commission calculation with tiered structure
interface CommissionStructure {
  tier: 'basic' | 'verified' | 'elite' | 'pro';
  creatorPercentage: number;
  platformPercentage: number;
  requirements: string[];
}

const COMMISSION_TIERS: CommissionStructure[] = [
  {
    tier: 'basic',
    creatorPercentage: 50,
    platformPercentage: 50,
    requirements: ['1+ templates published']
  },
  {
    tier: 'verified',
    creatorPercentage: 55,
    platformPercentage: 45,
    requirements: ['Identity verification', '3+ templates', '4.0+ rating']
  },
  {
    tier: 'elite',
    creatorPercentage: 65,
    platformPercentage: 35,
    requirements: ['10+ templates sold', '4.5+ rating', '100+ sales']
  },
  {
    tier: 'pro',
    creatorPercentage: 73,
    platformPercentage: 27,
    requirements: ['$199/year subscription', '5+ active templates']
  }
];

// Commission calculation
const calculateCommissions = (amount: number, creatorTier: string) => {
  const tier = COMMISSION_TIERS.find(t => t.tier === creatorTier);
  if (!tier) throw new Error('Invalid creator tier');
  
  return {
    creatorEarnings: amount * (tier.creatorPercentage / 100),
    platformFee: amount * (tier.platformPercentage / 100),
    tier
  };
};

// Payout processing
const processPayout = async (env: Env, creatorId: string) => {
  const earnings = await getCreatorEarnings(env, creatorId);
  
  if (earnings.balance < 50) {
    throw new Error('Minimum payout threshold not met ($50)');
  }
  
  // Process via Stripe Connect
  const payout = await stripe.payouts.create({
    amount: Math.round(earnings.balance * 100), // Convert to cents
    currency: 'usd',
    destination: earnings.stripeAccountId,
  });
  
  // Record payout
  await recordPayout(env, creatorId, payout);
  
  return payout;
};
```

**Development Rules:**

- **Accurate calculations** - Commissions must be calculated to 4 decimal places
- **Payout thresholds** - $50 minimum, net 30 days processing
- **Multi-currency support** - USD, EUR, GBP with market rate conversion
- **Tax compliance** - 1099-K generation for US creators > $600/year
- **Dispute handling** - 30-day refund window affects commission calculations

### 21.4 Template Review and Approval Workflow Implementation

```typescript
// ✅ GOOD: Template review system with automated and manual checks
interface TemplateReview {
  templateId: string;
  status: 'pending' | 'approved' | 'rejected' | 'needs_changes';
  reviewerId?: string;
  reviewNotes?: string;
  automatedChecks: {
    security: boolean;
    functionality: boolean;
    accessibility: boolean;
    performance: boolean;
  };
  submittedAt: string;
  reviewedAt?: string;
}

// Automated template validation
const validateTemplate = async (env: Env, templateId: string) => {
  const template = await getTemplate(env, templateId);
  
  const checks = {
    security: await runSecurityScan(template),
    functionality: await testTemplateFunctionality(template),
    accessibility: await testAccessibility(template),
    performance: await testPerformance(template),
  };
  
  return {
    allPassed: Object.values(checks).every(Boolean),
    results: checks
  };
};

// Template submission workflow
const submitTemplateForReview = async (env: Env, templateId: string) => {
  const validation = await validateTemplate(env, templateId);
  
  if (validation.allPassed) {
    // Auto-approve if all checks pass
    await approveTemplate(env, templateId, 'automated');
  } else {
    // Send to manual review
    await createReviewRequest(env, templateId, validation.results);
  }
  
  return validation;
};
```

**Review Requirements:**

- **Security scanning** - Check for XSS, injection vulnerabilities, malicious code
- **Functionality testing** - Verify all form fields, logic, and integrations work
- **Accessibility audit** - WCAG 2.1 AA compliance verification
- **Performance testing** - Load time and resource usage validation
- **Design quality** - Professional appearance and user experience review

### 21.5 Student Verification and Discount System Development

```typescript
// ✅ GOOD: Student verification with educational email validation
interface StudentVerification {
  userId: string;
  email: string;
  institution: string;
  verificationStatus: 'pending' | 'verified' | 'rejected';
  verifiedAt?: string;
  expiresAt: string;
}

// Student email validation
const validateStudentEmail = (email: string): boolean => {
  const eduDomains = [
    '@edu', '@ac.uk', '@student.',
    '@university.', '@college.'
  ];
  
  return eduDomains.some(domain =>
    email.toLowerCase().includes(domain) ||
    email.endsWith(domain)
  );
};

// Student discount application
const applyStudentDiscount = (price: number, isStudent: boolean) => {
  if (!isStudent) return price;
  
  const discountRate = 0.3; // 30% discount
  const discountedPrice = Math.max(0, price * (1 - discountRate));
  
  return Math.round(discountedPrice * 100) / 100; // Round to 2 decimals
};

// Educational institution verification
const verifyStudentStatus = async (env: Env, userId: string, email: string) => {
  if (!validateStudentEmail(email)) {
    throw new Error('Invalid educational email address');
  }
  
  // Send verification email with unique code
  const verificationCode = generateVerificationCode();
  await sendVerificationEmail(email, verificationCode);
  
  // Store pending verification
  await env.STUDENT_VERIFICATIONS.put(userId, JSON.stringify({
    email,
    verificationCode,
    status: 'pending',
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
  }));
  
  return { verificationSent: true };
};
```

**Student System Rules:**

- **Email verification** - Must use valid educational domain
- **Discount application** - 30% off all paid templates for verified students
- **Annual re-verification** - Student status expires after 12 months
- **Institution tracking** - Maintain list of recognized educational institutions
- **Fraud prevention** - Monitor for abuse of student discount system

---

## 22. Student Creator Experience Guidelines

### 22.1 Low-Barrier Entry Development Practices

```tsx
// ✅ GOOD: Progressive onboarding for new creators
const CreatorOnboardingFlow = () => {
  const [currentStep, setCurrentStep] = useState(0);
  const [creatorProfile, setCreatorProfile] = useState<Partial<CreatorProfile>>({});
  
  const onboardingSteps = [
    {
      title: "Create Your Profile",
      component: ProfileSetup,
      description: "Tell us about yourself and your expertise"
    },
    {
      title: "Learn the Basics",
      component: TemplateCreationTutorial,
      description: "Interactive guide to building your first template"
    },
    {
      title: "Build Your First Template",
      component: TemplateBuilder,
      description: "Start with a simple template and grow from there"
    },
    {
      title: "Get Feedback",
      component: MentorReview,
      description: "Get expert feedback before publishing"
    },
    {
      title: "Go Live",
      component: TemplatePublishing,
      description: "Publish your template and start earning"
    }
  ];
  
  return (
    <div className="onboarding-flow">
      <ProgressBar
        current={currentStep}
        total={onboardingSteps.length}
      />
      <OnboardingStep
        step={onboardingSteps[currentStep]}
        data={creatorProfile}
        onComplete={(data) => {
          setCreatorProfile({...creatorProfile, ...data});
          setCurrentStep(currentStep + 1);
        }}
      />
    </div>
  );
};
```

**Development Guidelines:**

- **Progressive disclosure** - Reveal features gradually as users become more proficient
- **Scaffolded learning** - Provide templates and examples for common use cases
- **Instant feedback** - Real-time validation and suggestions during template creation
- **Low-stakes experimentation** - Allow testing without publishing
- **Clear success metrics** - Show progress and achievements clearly

### 22.2 Mentorship Program Integration Standards

```typescript
// ✅ GOOD: Mentorship matching and communication system
interface MentorMatch {
  menteeId: string;
  mentorId: string;
  matchDate: string;
  status: 'pending' | 'active' | 'completed' | 'cancelled';
  lastInteraction: string;
  goals: string[];
}

// Mentor matching algorithm
const matchMentor = async (env: Env, menteeId: string) => {
  const mentee = await getCreatorProfile(env, menteeId);
  const availableMentors = await getAvailableMentors(env);
  
  // Match based on expertise, availability, and preferences
  const matches = availableMentors
    .filter(mentor => mentor.expertise.some(exp =>
      mentee.interests.includes(exp)
    ))
    .filter(mentor => mentor.maxMentees > mentor.currentMentees)
    .sort((a, b) => b.rating - a.rating); // Prioritize higher-rated mentors
  
  if (matches.length === 0) {
    throw new Error('No suitable mentor available');
  }
  
  const mentor = matches[0];
  await createMentorMatch(env, menteeId, mentor.id);
  
  return mentor;
};

// Mentorship communication tools
const MentorshipCommunication = ({ matchId }: { matchId: string }) => {
  const [messages, setMessages] = useState<MentorshipMessage[]>([]);
  const [newMessage, setNewMessage] = useState('');
  
  const sendMessage = async () => {
    const message = await sendMentorshipMessage(env, matchId, newMessage);
    setMessages([...messages, message]);
    setNewMessage('');
  };
  
  return (
    <div className="mentorship-chat">
      <MessageList messages={messages} />
      <MessageInput
        value={newMessage}
        onChange={setNewMessage}
        onSend={sendMessage}
      />
    </div>
  );
};
```

**Mentorship Standards:**

- **Expert matching** - Algorithm-based matching by expertise and goals
- **Structured guidance** - Clear milestones and learning objectives
- **Communication tools** - Integrated messaging and feedback systems
- **Progress tracking** - Monitor mentee development and mentor effectiveness
- **Quality assurance** - Regular reviews of mentorship outcomes

### 22.3 Portfolio Building Feature Development

```tsx
// ✅ GOOD: Portfolio showcase with analytics
interface CreatorPortfolio {
  creatorId: string;
  templates: TemplatePortfolioItem[];
  skills: CreatorSkill[];
  achievements: CreatorAchievement[];
  testimonials: Testimonial[];
  metrics: PortfolioMetrics;
}

const CreatorPortfolio = ({ creatorId }: { creatorId: string }) => {
  const { data: portfolio } = useQuery({
    queryKey: ['creator-portfolio', creatorId],
    queryFn: () => fetchCreatorPortfolio(env, creatorId),
  });
  
  return (
    <div className="creator-portfolio">
      <PortfolioHeader creator={portfolio.creator} />
      
      <div className="portfolio-sections">
        <TemplateShowcase templates={portfolio.templates} />
        <SkillsDisplay skills={portfolio.skills} />
        <AchievementsDisplay achievements={portfolio.achievements} />
        <TestimonialsDisplay testimonials={portfolio.testimonials} />
      </div>
      
      <PortfolioAnalytics metrics={portfolio.metrics} />
    </div>
  );
};

// Template portfolio item with performance metrics
const TemplatePortfolioItem = ({ template }: { template: TemplatePortfolioItem }) => {
  return (
    <Card className="template-portfolio-item">
      <CardHeader>
        <div className="flex justify-between">
          <div>
            <CardTitle>{template.name}</CardTitle>
            <CardDescription>{template.category}</CardDescription>
          </div>
          <div className="text-right">
            <div className="text-2xl font-bold">${template.price}</div>
            <div className="text-sm text-muted-foreground">
              {template.salesCount} sales
            </div>
          </div>
        </div>
      </CardHeader>
      
      <CardContent>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <div className="text-lg font-semibold">{template.rating}</div>
            <div className="text-sm text-muted-foreground">Rating</div>
          </div>
          <div>
            <div className="text-lg font-semibold">{template.viewCount}</div>
            <div className="text-sm text-muted-foreground">Views</div>
          </div>
          <div>
            <div className="text-lg font-semibold">{template.conversionRate}%</div>
            <div className="text-sm text-muted-foreground">Conversion</div>
          </div>
        </div>
        
        <TemplatePreview template={template} />
      </CardContent>
    </Card>
  );
};
```

**Portfolio Features:**

- **Template showcase** - Highlight best-performing and most innovative templates
- **Skill demonstration** - Show expertise through completed projects
- **Social proof** - Display testimonials, ratings, and user feedback
- **Performance analytics** - Detailed metrics on template success
- **Career progression** - Track growth from beginner to expert creator

### 22.4 Educational Resource Integration

```tsx
// ✅ GOOD: Integrated learning resources
const TemplateCreationStudio = () => {
  const [learningMode, setLearningMode] = useState(false);
  const [currentLesson, setCurrentLesson] = useState<Lesson | null>(null);
  
  return (
    <div className="template-studio">
      <div className="studio-toolbar">
        <Button onClick={() => setLearningMode(!learningMode)}>
          {learningMode ? 'Exit Learning Mode' : 'Start Learning'}
        </Button>
      </div>
      
      <div className="studio-content">
        {learningMode && currentLesson && (
          <LearningPanel
            lesson={currentLesson}
            onLessonComplete={handleLessonComplete}
          />
        )}
        
        <TemplateCanvas />
        
        {learningMode && (
          <ResourceSidebar
            lessons={availableLessons}
            currentLesson={currentLesson}
            onLessonSelect={setCurrentLesson}
          />
        )}
      </div>
    </div>
  );
};

// Interactive learning lessons
const InteractiveLesson = ({ lesson }: { lesson: Lesson }) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [userProgress, setUserProgress] = useState<LessonProgress>({
    completedSteps: [],
    score: 0,
    timeSpent: 0
  });
  
  const currentStepData = lesson.steps[currentStep];
  
  return (
    <div className="interactive-lesson">
      <LessonHeader
        title={lesson.title}
        progress={currentStep / lesson.steps.length}
      />
      
      <LessonStep
        step={currentStepData}
        onComplete={() => {
          setUserProgress({
            ...userProgress,
            completedSteps: [...userProgress.completedSteps, currentStep],
            timeSpent: userProgress.timeSpent + 300 // seconds
          });
          setCurrentStep(currentStep + 1);
        }}
      />
      
      <ProgressTracker progress={userProgress} />
    </div>
  );
};
```

**Educational Integration:**

- **Contextual learning** - Resources appear when users encounter challenges
- **Hands-on practice** - Interactive exercises within the template creation flow
- **Progressive complexity** - Lessons build from basic to advanced concepts
- **Skill assessment** - Quizzes and practical evaluations
- **Community learning** - Peer feedback and collaborative projects

### 22.5 Progressive Skill Development Features

```typescript
// ✅ GOOD: Skill progression system with milestones
interface CreatorSkillLevel {
  skill: string;
  level: 1 | 2 | 3 | 4 | 5;
  experiencePoints: number;
  nextLevelThreshold: number;
  completedMilestones: Milestone[];
  unlockedFeatures: string[];
}

// Skill progression tracking
const trackSkillProgress = async (
  env: Env,
  creatorId: string,
  skill: string,
  activity: CreatorActivity
) => {
  const currentProgress = await getCreatorSkillLevel(env, creatorId, skill);
  const xpGained = calculateXpGained(activity, skill);
  
  const newExperiencePoints = currentProgress.experiencePoints + xpGained;
  const newLevel = calculateLevel(newExperiencePoints);
  
  const levelUp = newLevel > currentProgress.level;
  
  await updateCreatorSkillLevel(env, creatorId, skill, {
    ...currentProgress,
    experiencePoints: newExperiencePoints,
    level: newLevel,
    ...(levelUp && { unlockedFeatures: getUnlockedFeatures(skill, newLevel) })
  });
  
  if (levelUp) {
    await awardMilestone(env, creatorId, skill, newLevel);
  }
  
  return { levelUp, newLevel, xpGained };
};

// Milestone-based achievements
const MILESTONE_ACHIEVEMENTS = {
  'template-creator': [
    { level: 1, name: 'First Template', requirement: 'Create first template' },
    { level: 2, name: 'Getting Started', requirement: '5 templates created' },
    { level: 3, name: 'Popular Creator', requirement: '100 total sales' },
    { level: 4, name: 'Template Master', requirement: '1000 total sales' },
    { level: 5, name: 'Industry Leader', requirement: '10k total sales' }
  ],
  'design-expert': [
    { level: 1, name: 'Design Basics', requirement: 'Complete design tutorial' },
    { level: 2, name: 'User Experience', requirement: 'Templates with 4.5+ rating' },
    { level: 3, name: 'Accessibility Pro', requirement: 'WCAG 2.1 AA compliance' },
    { level: 4, name: 'Design System', requirement: 'Reusable component library' },
    { level: 5, name: 'Design Visionary', requirement: 'Industry recognition' }
  ]
};

// Skill-based feature unlocking
const getUnlockedFeatures = (skill: string, level: number): string[] => {
  const skillTree = SKILL_TREES[skill];
  return skillTree.features.filter(feature => feature.unlockLevel <= level);
};

const SKILL_TREES = {
  'template-design': {
    features: [
      { id: 'advanced-logic', name: 'Advanced Conditional Logic', unlockLevel: 2 },
      { id: 'custom-css', name: 'Custom CSS Styling', unlockLevel: 3 },
      { id: 'api-integrations', name: 'API Integrations', unlockLevel: 4 },
      { id: 'white-label', name: 'White Label Templates', unlockLevel: 5 }
    ]
  }
};
```

**Skill Development Rules:**

- **Gamified progression** - Experience points, levels, and achievements
- **Milestone rewards** - Unlock features and capabilities as skills grow
- **Personalized learning paths** - Adapt to individual learning styles and goals
- **Social recognition** - Badges and public recognition for accomplishments
- **Real-world application** - Skills transferable to professional opportunities

---

## 23. Legal Compliance Development Requirements

### 23.1 Data Retention Policy Implementation (30-90 Day TTL)

```typescript
// ✅ GOOD: TTL-based data retention with automatic deletion
interface DataRetentionConfig {
  dataType: 'submission' | 'template' | 'user_data' | 'analytics';
  retentionDays: number;
  autoDelete: boolean;
  legalHold: boolean;
  industry?: 'healthcare' | 'financial' | 'general';
}

const RETENTION_POLICIES: Record<string, DataRetentionConfig> = {
  'contact_form': { dataType: 'submission', retentionDays: 30, autoDelete: true },
  'lead_generation': { dataType: 'submission', retentionDays: 365, autoDelete: true },
  'event_registration': { dataType: 'submission', retentionDays: 30, autoDelete: true },
  'job_application': { dataType: 'submission', retentionDays: 180, autoDelete: true },
  'medical_form': { dataType: 'submission', retentionDays: 2190, autoDelete: false }, // 6 years
  'payment_form': { dataType: 'submission', retentionDays: 2555, autoDelete: false }, // 7 years
  'template_data': { dataType: 'template', retentionDays: 3650, autoDelete: false }, // 10 years
  'user_analytics': { dataType: 'analytics', retentionDays: 90, autoDelete: true },
};

// Automatic deletion implementation
const scheduleDataDeletion = async (env: Env) => {
  const policy = RETENTION_POLICIES;
  
  // Process submissions for deletion
  const submissionsToDelete = await env.SUBMISSIONS.list({
    prefix: 'submission:',
    limit: 1000
  });
  
  const deletionPromises = submissionsToDelete.keys
    .filter(key => shouldDeleteSubmission(key, policy))
    .map(key => env.SUBMISSIONS.delete(key.name));
  
  await Promise.all(deletionPromises);
  
  // Log deletion activity for compliance
  await env.COMPLIANCE_LOGS.put(`deletion:${Date.now()}`, JSON.stringify({
    deletedCount: deletionPromises.length,
    timestamp: new Date().toISOString(),
    processedBy: 'automated-retention-policy'
  }));
};

// TTL calculation for new submissions
const calculateSubmissionTtl = (formType: string): number | null => {
  const policy = RETENTION_POLICIES[formType];
  if (!policy) return 30 * 86400; // Default 30 days
  
  if (!policy.autoDelete) return null; // No auto-deletion for regulated data
  
  return policy.retentionDays * 86400; // Convert days to seconds
};

// Store submission with appropriate TTL
const storeSubmission = async (
  env: Env,
  submissionId: string,
  data: any,
  formType: string
) => {
  const ttl = calculateSubmissionTtl(formType);
  
  const submissionData = {
    ...data,
    storedAt: new Date().toISOString(),
    retentionPolicy: formType,
    expiresAt: ttl ? new Date(Date.now() + ttl * 1000).toISOString() : null
  };
  
  const storageOptions: any = { metadata: { formType, retentionPolicy: formType } };
  
  if (ttl) {
    storageOptions.expirationTtl = ttl;
  }
  
  await env.SUBMISSIONS.put(submissionId, JSON.stringify(submissionData), storageOptions);
  
  return { submissionId, expiresAt: submissionData.expiresAt };
};
```

**Retention Implementation Rules:**

- **Purpose-based retention** - Different periods based on form type and legal requirements
- **TTL enforcement** - Automatic deletion using Cloudflare KV expiration
- **Legal hold support** - Suspend deletion for litigation or regulatory requirements
- **Audit logging** - Track all deletion activities for compliance verification
- **User notification** - Email users 7 days before automatic deletion

### 23.2 GDPR Compliance Development Standards

```typescript
// ✅ GOOD: GDPR-compliant data processing
interface GDPRCompliance {
  lawfulBasis: 'consent' | 'contract' | 'legal_obligation' | 'legitimate_interest';
  dataMinimization: boolean;
  purposeLimitation: string[];
  storageLimitation: number;
  userRights: {
    access: boolean;
    rectification: boolean;
    erasure: boolean;
    portability: boolean;
    objection: boolean;
  };
}

// GDPR-compliant form handling
const processFormSubmission = async (
  env: Env,
  formData: any,
  gdprCompliance: GDPRCompliance
) => {
  // Data minimization check
  const minimizedData = minimizeDataCollection(formData, gdprCompliance);
  
  // Lawful basis verification
  if (!verifyLawfulBasis(gdprCompliance.lawfulBasis, formData)) {
    throw new Error('Invalid lawful basis for data processing');
  }
  
  // Purpose limitation check
  if (!validatePurposeLimitation(formData, gdprCompliance.purposeLimitation)) {
    throw new Error('Data collection exceeds stated purposes');
  }
  
  // Store with consent tracking
  const consentRecord = {
    userId: formData.userId,
    lawfulBasis: gdprCompliance.lawfulBasis,
    purposes: gdprCompliance.purposeLimitation,
    consentGivenAt: new Date().toISOString(),
    dataProcessed: Object.keys(minimizedData)
  };
  
  await env.CONSENT_RECORDS.put(
    `consent:${formData.userId}:${Date.now()}`,
    JSON.stringify(consentRecord)
  );
  
  // Store submission with retention policy
  return await storeSubmission(env, formData.submissionId, minimizedData, formData.formType);
};

// Right to erasure implementation
const handleErasureRequest = async (env: Env, userId: string, requestData: string[]) => {
  const startTime = Date.now();
  
  // Find all data related to user
  const userKeys = await findAllUserKeys(env, userId);
  
  // Verify request within 30 days (GDPR requirement)
  if (Date.now() - startTime > 30 * 24 * 60 * 60 * 1000) {
    throw new Error('Erasure request must be processed within 30 days');
  }
  
  // Delete user data
  const deletionResults = await Promise.allSettled(
    userKeys.map(key => env.USER_DATA.delete(key))
  );
  
  // Log deletion for audit
  await env.AUDIT_LOGS.put(`erasure:${Date.now()}`, JSON.stringify({
    userId,
    requestData,
    deletedKeys: userKeys.length,
    successfulDeletions: deletionResults.filter(r => r.status === 'fulfilled').length,
    timestamp: new Date().toISOString()
  }));
  
  return {
    success: true,
    deletedItems: userKeys.length,
    processingTime: Date.now() - startTime
  };
};

// Data portability implementation
const handleDataPortability = async (env: Env, userId: string) => {
  const userKeys = await findAllUserKeys(env, userId);
  
  // Collect all user data
  const userData = await Promise.all(
    userKeys.map(async key => {
      const data = await env.USER_DATA.get(key);
      return { key, data, collectedAt: new Date().toISOString() };
    })
  );
  
  // Create portable format (JSON)
  const portableData = {
    userId,
    exportDate: new Date().toISOString(),
    data: userData,
    format: 'json',
    version: '1.0'
  };
  
  // Store export for download
  const exportId = `export:${userId}:${Date.now()}`;
  await env.DATA_EXPORTS.put(
    exportId,
    JSON.stringify(portableData),
    { expirationTtl: 7 * 24 * 60 * 60 } // 7 days
  );
  
  return {
    exportId,
    downloadUrl: `/api/exports/${exportId}`,
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
  };
};
```

**GDPR Compliance Rules:**

- **Lawful basis documentation** - Record and verify legal basis for all data processing
- **Data minimization** - Only collect data necessary for stated purposes
- **Purpose limitation** - Use data only for specified, legitimate purposes
- **User rights fulfillment** - Implement access, erasure, portability, and objection rights
- **30-day response time** - Process user requests within GDPR-mandated timeframe
- **Record keeping** - Maintain processing activities documentation

### 23.3 Automatic Deletion System Development Rules

```typescript
// ✅ GOOD: Comprehensive deletion scheduling system
const DELETION_SCHEDULER = {
  // Daily deletion batch processing
  dailyCleanup: async (env: Env) => {
    const batchSize = 1000;
    
    // Find submissions ready for deletion
    const readyForDeletion = await env.SUBMISSIONS.list({
      prefix: 'submission:',
      limit: batchSize
    });
    
    const now = Date.now();
    const deletions = [];
    
    for (const key of readyForDeletion.keys) {
      const data = await env.SUBMISSIONS.get(key.name, 'json');
      
      if (data && data.expiresAt && new Date(data.expiresAt).getTime() < now) {
        // Check for legal holds
        const holdKey = `hold:${key.name}`;
        const legalHold = await env.LEGAL HOLDS.get(holdKey);
        
        if (!legalHold) {
          deletions.push(env.SUBMISSIONS.delete(key.name));
        }
      }
    }
    
    await Promise.all(deletions);
    
    // Log cleanup activity
    await env.SYSTEM_LOGS.put(`cleanup:${Date.now()}`, JSON.stringify({
      type: 'daily_deletion',
      deletedCount: deletions.length,
      timestamp: new Date().toISOString()
    }));
  },
  
  // Weekly compliance report generation
  weeklyComplianceReport: async (env: Env) => {
    const weekAgo = Date.now() - (7 * 24 * 60 * 60 * 1000);
    
    // Generate deletion summary
    const deletions = await env.SYSTEM_LOGS.list({
      prefix: 'cleanup:',
      cursor: weekAgo.toString()
    });
    
    const report = {
      period: {
        start: new Date(weekAgo).toISOString(),
        end: new Date().toISOString()
      },
      totalDeletions: deletions.keys.length,
      dataTypes: await categorizeDeletedData(env, weekAgo),
      complianceStatus: 'compliant'
    };
    
    // Store report
    await env.COMPLIANCE_REPORTS.put(
      `weekly:${Date.now()}`,
      JSON.stringify(report)
    );
    
    return report;
  }
};

// Pre-deletion notification system
const sendDeletionNotifications = async (env: Env) => {
  const notificationPeriod = 7 * 24 * 60 * 60 * 1000; // 7 days
  
  // Find data expiring in next 7 days
  const expiringData = await findExpiringData(env, notificationPeriod);
  
  for (const item of expiringData) {
    await sendNotificationEmail(env, item.userId, {
      type: 'data_expiration',
      dataId: item.dataId,
      expiresAt: item.expiresAt,
      actionUrl: `/dashboard/data-management/${item.dataId}`
    });
    
    // Log notification
    await env.NOTIFICATION_LOGS.put(`notification:${Date.now()}`, JSON.stringify({
      userId: item.userId,
      dataId: item.dataId,
      type: 'deletion_warning',
      sentAt: new Date().toISOString()
    }));
  }
};

// Legal hold system
const applyLegalHold = async (
  env: Env,
  dataId: string,
  caseId: string,
  reason: string
) => {
  const holdData = {
    dataId,
    caseId,
    reason,
    appliedAt: new Date().toISOString(),
    appliedBy: 'legal_team',
    expiresAt: null // Manual review required
  };
  
  await env.LEGAL_HOLDS.put(`hold:${dataId}`, JSON.stringify(holdData));
  
  // Log legal hold
  await env.COMPLIANCE_LOGS.put(`legal_hold:${Date.now()}`, JSON.stringify({
    ...holdData,
    action: 'apply_hold'
  }));
  
  return holdData;
};
```

**Deletion System Rules:**

- **Batch processing** - Handle deletions in manageable batches to avoid system overload
- **Legal hold checks** - Always verify for litigation holds before deletion
- **Notification requirements** - Email users 7 days before automatic deletion
- **Audit trails** - Log all deletion activities with timestamps and reasons
- **Compliance reporting** - Generate weekly/monthly reports for regulatory review
- **Error handling** - Retry failed deletions with exponential backoff

### 23.4 Right to Erasure Implementation Guidelines

```typescript
// ✅ GOOD: Comprehensive erasure request handling
interface ErasureRequest {
  userId: string;
  reason: string;
  requestData: string[];
  submittedAt: string;
  status: 'pending' | 'processing' | 'completed' | 'rejected';
  completedAt?: string;
  rejectedReason?: string;
}

// Erasure request submission and validation
const submitErasureRequest = async (
  env: Env,
  userId: string,
  requestData: ErasureRequestData
) => {
  // Validate request
  const validation = await validateErasureRequest(env, userId, requestData);
  
  if (!validation.valid) {
    throw new Error(`Erasure request validation failed: ${validation.reason}`);
  }
  
  // Create erasure request record
  const erasureRequest: ErasureRequest = {
    userId,
    reason: requestData.reason,
    requestData: requestData.types,
    submittedAt: new Date().toISOString(),
    status: 'pending'
  };
  
  const requestId = `erasure:${userId}:${Date.now()}`;
  await env.ERASURE_REQUESTS.put(requestId, JSON.stringify(erasureRequest));
  
  // Start processing immediately
  await processErasureRequest(env, requestId);
  
  return { requestId, estimatedCompletion: 'within 30 days' };
};

// Comprehensive data location search
const findAllUserData = async (env: Env, userId: string) => {
  const dataLocations = [
    'USER_DATA',
    'SUBMISSIONS',
    'TEMPLATE_USAGE',
    'ANALYTICS',
    'CHAT_MESSAGES',
    'NOTIFICATIONS'
  ];
  
  const foundData: UserDataLocation[] = [];
  
  for (const location of dataLocations) {
    const namespace = env[location];
    if (!namespace) continue;
    
    try {
      const userKeys = await namespace.list({
        prefix: `user:${userId}:`,
        limit: 1000
      });
      
      foundData.push(...userKeys.keys.map(key => ({
        location,
        key: key.name,
        size: key.metadata?.size || 0,
        lastModified: key.metadata?.lastModified || key.uploaded
      })));
    } catch (error) {
      console.error(`Error searching ${location}:`, error);
    }
  }
  
  return foundData;
};

// Selective data erasure with preservation requirements
const eraseUserData = async (
  env: Env,
  userId: string,
  requestData: string[],
  preservationRules: PreservationRule[]
) => {
  const allUserData = await findAllUserData(env, userId);
  
  const erasures = [];
  const preserved = [];
  
  for (const userData of allUserData) {
    // Check preservation rules
    const shouldPreserve = preservationRules.some(rule =>
      rule.appliesTo(userData, requestData)
    );
    
    if (shouldPreserve) {
      preserved.push(userData);
      continue;
    }
    
    // Perform erasure
    try {
      const namespace = env[userData.location];
      await namespace.delete(userData.key);
      
      erasures.push({
        location: userData.location,
        key: userData.key,
        success: true,
        erasedAt: new Date().toISOString()
      });
    } catch (error) {
      console.error(`Failed to erase ${userData.key}:`, error);
    }
  }
  
  return { erasures, preserved };
};
```

**Erasure Implementation Rules:**

- **30-day deadline** - Complete all erasure requests within 30 days of receipt
- **Comprehensive search** - Find data across all storage locations and systems
- **Selective preservation** - Maintain data required by law (tax, legal obligations)
- **Verification process** - Confirm user identity before processing erasure
- **Documentation requirement** - Log all erasure activities for audit purposes
- **Third-party coordination** - Handle data stored with external services

### 23.5 Industry-Specific Compliance (HIPAA, SOX) Requirements

```typescript
// ✅ GOOD: HIPAA-compliant healthcare form handling
interface HIPAACompliance {
  businessAssociateAgreement: boolean;
  encryptionAtRest: boolean;
  encryptionInTransit: boolean;
  accessControls: AccessControl[];
  auditLogs: boolean;
  breachNotification: boolean;
  minimumNecessary: boolean;
}

// HIPAA form validation and processing
const processHIPAAForm = async (
  env: Env,
  formData: MedicalFormData,
  compliance: HIPAACompliance
) => {
  // Verify BAA in place
  if (!compliance.businessAssociateAgreement) {
    throw new Error('Business Associate Agreement required for PHI processing');
  }
  
  // Minimum necessary standard
  const necessaryData = applyMinimumNecessaryStandard(formData);
  
  // Access control verification
  const authorizedUsers = await getAuthorizedUsers(env, 'phi_access');
  if (!authorizedUsers.includes(formData.processedBy)) {
    throw new Error('User not authorized for PHI access');
  }
  
  // Encrypt PHI before storage
  const encryptedData = await encryptPHI(env, necessaryData);
  
  // Store with audit trail
  const phiRecord = {
    patientId: formData.patientId,
    encryptedData,
    accessLevel: 'phi',
    storedAt: new Date().toISOString(),
    processedBy: formData.processedBy,
    retentionPeriod: '2190 days' // 6 years minimum
  };
  
  await env.PHI_DATA.put(
    `phi:${formData.patientId}:${Date.now()}`,
    JSON.stringify(phiRecord),
    { metadata: { encrypted: true, phi: true } }
  );
  
  // Log access for audit
  await env.AUDIT_LOGS.put(`phi_access:${Date.now()}`, JSON.stringify({
    action: 'phi_storage',
    patientId: formData.patientId,
    processedBy: formData.processedBy,
    timestamp: new Date().toISOString(),
    dataElements: Object.keys(necessaryData)
  }));
  
  return { success: true, phiId: phiRecord.patientId };
};

// SOX compliance for financial data
const processSOXForm = async (
  env: Env,
  formData: FinancialFormData,
  compliance: SOXCompliance
) => {
  // Data integrity verification
  const hash = await calculateDataHash(formData);
  
  // Immutable audit trail
  const auditRecord = {
    formId: formData.formId,
    submissionId: formData.submissionId,
    dataHash: hash,
    submittedAt: new Date().toISOString(),
    submittedBy: formData.submittedBy,
    financialPeriod: formData.financialPeriod,
    soxCompliant: true
  };
  
  // Store in immutable log
  await env.SOX_AUDIT_LOG.put(
    `audit:${formData.formId}:${Date.now()}`,
    JSON.stringify(auditRecord)
  );
  
  // Store financial data with 7-year retention
  const financialRecord = {
    ...formData,
    auditHash: hash,
    retentionPeriod: '2555 days', // 7 years
    immutable: true
  };
  
  await env.FINANCIAL_DATA.put(
    `financial:${formData.formId}`,
    JSON.stringify(financialRecord),
    {
      metadata: {
        sox_compliant: true,
        immutable: true,
        retention_years: 7
      }
    }
  );
  
  return { success: true, auditId: auditRecord.formId };
};

// Breach notification system
const handleDataBreach = async (
  env: Env,
  breachDetails: DataBreach,
  affectedUsers: string[]
) => {
  // Immediate containment
  await containBreach(env, breachDetails);
  
  // Assessment and documentation
  const assessment = await assessBreachImpact(env, breachDetails, affectedUsers);
  
  // Notification within 60 days (HIPAA requirement)
  const notifications = await Promise.all(
    affectedUsers.map(userId =>
      sendBreachNotification(env, userId, assessment)
    )
  );
  
  // Regulatory reporting
  if (assessment.affectedCount > 500) {
    // Report to HHS within 60 days
    await reportToRegulator(env, 'HHS', breachDetails, assessment);
  } else {
    // Report to HHS within 60 days of discovery
    await reportToRegulator(env, 'HHS', breachDetails, assessment);
  }
  
  // Log all actions
  await env.BREACH_LOGS.put(`breach:${Date.now()}`, JSON.stringify({
    breachDetails,
    assessment,
    notifications: notifications.length,
    regulatoryReports: 1,
    timestamp: new Date().toISOString()
  }));
  
  return {
    breachId: breachDetails.id,
    notificationsSent: notifications.length
  };
};
```

**Industry Compliance Rules:**

- **HIPAA requirements** - BAA, encryption, access controls, 6-year retention for medical data
- **SOX requirements** - Immutable audit logs, data integrity, 7-year retention for financial data
- **Breach notification** - HIPAA: 60 days, GDPR: 72 hours, CCPA: immediate
- **Access logging** - Comprehensive audit trails for regulated data access
- **Data classification** - Tag data by sensitivity level (public, internal, confidential, regulated)
- **Retention overrides** - Legal holds can override automatic deletion for regulated data

---

## 24. Creator Experience Standards

### 24.1 Creator Analytics Implementation Patterns

```typescript
// ✅ GOOD: Real-time creator analytics with performance optimization
interface CreatorAnalytics {
  creatorId: string;
  timePeriod: 'day' | 'week' | 'month' | 'year' | 'lifetime';
  metrics: {
    views: number;
    previews: number;
    purchases: number;
    conversionRate: number;
    avgRating: number;
    totalEarnings: number;
    pendingEarnings: number;
    refundRate: number;
  };
  trends: {
    viewsTrend: TrendData[];
    purchasesTrend: TrendData[];
    earningsTrend: TrendData[];
  };
  insights: {
    topPerformingTemplates: TemplatePerformance[];
    seasonalPatterns: SeasonalPattern[];
    audienceDemographics: AudienceDemographic[];
  };
}

// Real-time analytics aggregation
const aggregateCreatorAnalytics = async (
  env: Env,
  creatorId: string,
  timePeriod: string
) => {
  const cacheKey = `analytics:${creatorId}:${timePeriod}`;
  
  // Try cache first
  const cached = await env.ANALYTICS_CACHE.get(cacheKey, 'json');
  if (cached) return cached;
  
  // Aggregate from multiple data sources
  const [
    templateViews,
    templatePurchases,
    templateRatings,
    templateEarnings
  ] = await Promise.all([
    getTemplateViews(env, creatorId, timePeriod),
    getTemplatePurchases(env, creatorId, timePeriod),
    getTemplateRatings(env, creatorId, timePeriod),
    getTemplateEarnings(env, creatorId, timePeriod)
  ]);
  
  // Calculate derived metrics
  const analytics: CreatorAnalytics = {
    creatorId,
    timePeriod,
    metrics: {
      views: templateViews.reduce((sum, v) => sum + v.count, 0),
      previews: templateViews.filter(v => v.type === 'preview').reduce((sum, v) => sum + v.count, 0),
      purchases: templatePurchases.reduce((sum, p) => sum + p.count, 0),
      conversionRate: calculateConversionRate(templateViews, templatePurchases),
      avgRating: calculateAverageRating(templateRatings),
      totalEarnings: templateEarnings.reduce((sum, e) => sum + e.amount, 0),
      pendingEarnings: templateEarnings.filter(e => e.status === 'pending').reduce((sum, e) => sum + e.amount, 0),
      refundRate: calculateRefundRate(templatePurchases)
    },
    trends: await calculateTrends(env, creatorId, timePeriod),
    insights: await generateInsights(env, creatorId, templateViews, templatePurchases)
  };
  
  // Cache for 5 minutes
  await env.ANALYTICS_CACHE.put(
    cacheKey,
    JSON.stringify(analytics),
    { expirationTtl: 300 }
  );
  
  return analytics;
};

// Performance-optimized analytics queries
const getTemplateViews = async (
  env: Env,
  creatorId: string,
  timePeriod: string
) => {
  // Use pre-aggregated data for performance
  const startDate = getStartDate(timePeriod);
  const endDate = new Date().toISOString();
  
  const views = await env.ANALYTICS_DATA.prepare(
    `SELECT template_id, view_type, COUNT(*) as count
     FROM template_views
     WHERE creator_id = ? AND viewed_at BETWEEN ? AND ?
     GROUP BY template_id, view_type`
  ).bind(creatorId, startDate, endDate).all();
  
  return views.results;
};

// Conversion rate calculation
const calculateConversionRate = (
  views: ViewData[],
  purchases: PurchaseData[]
): number => {
  const totalViews = views.reduce((sum, v) => sum + v.count, 0);
  const totalPurchases = purchases.reduce((sum, p) => sum + p.count, 0);
  
  return totalViews > 0 ? (totalPurchases / totalViews) * 100 : 0;
};

// Template performance insights
const generateInsights = async (
  env: Env,
  creatorId: string,
  views: ViewData[],
  purchases: PurchaseData[]
) => {
  const templatePerformance = views.map(view => {
    const purchasesForTemplate = purchases.find(p => p.templateId === view.templateId) || { count: 0 };
    
    return {
      templateId: view.templateId,
      views: view.count,
      purchases: purchasesForTemplate.count,
      conversionRate: (purchasesForTemplate.count / view.count) * 100,
      revenue: purchasesForTemplate.revenue || 0,
      category: view.category,
      price: view.price
    };
  });
  
  // Find top performers
  const topPerformers = templatePerformance
    .sort((a, b) => b.revenue - a.revenue)
    .slice(0, 10);
  
  // Calculate seasonal patterns
  const seasonalPatterns = await calculateSeasonalPatterns(env, creatorId);
  
  // Audience demographics
  const demographics = await calculateDemographics(env, creatorId);
  
  return {
    topPerformingTemplates: topPerformers,
    seasonalPatterns,
    audienceDemographics: demographics
  };
};
```

**Analytics Standards:**

- **Real-time updates** - Refresh key metrics every 5 minutes
- **Performance optimization** - Use pre-aggregated data for large datasets
- **Trend analysis** - Show week-over-week and month-over-month comparisons
- **Actionable insights** - Provide specific recommendations based on data
- **Data export** - Allow creators to download their analytics data
- **Privacy compliance** - Anonymize sensitive user data in analytics

### 24.2 Earnings Tracking Development Guidelines

```typescript
// ✅ GOOD: Comprehensive earnings tracking system
interface EarningsTracking {
  creatorId: string;
  currentBalance: number;
  pendingBalance: number;
  availableForPayout: number;
  totalLifetimeEarnings: number;
  recentTransactions: Transaction[];
  commissionBreakdown: CommissionBreakdown;
  taxInformation: TaxInformation;
}

// Earnings calculation with multiple revenue streams
const calculateCreatorEarnings = async (env: Env, creatorId: string) => {
  const [
    templateSales,
    subscriptionRevenue,
    affiliateEarnings,
    refunds,
    fees
  ] = await Promise.all([
    getTemplateSales(env, creatorId),
    getSubscriptionRevenue(env, creatorId),
    getAffiliateEarnings(env, creatorId),
    getRefunds(env, creatorId),
    getPlatformFees(env, creatorId)
  ]);
  
  // Calculate gross earnings
  const grossEarnings = {
    templateSales: templateSales.reduce((sum, sale) => sum + sale.grossAmount, 0),
    subscriptionRevenue: subscriptionRevenue.reduce((sum, rev) => sum + rev.amount, 0),
    affiliateEarnings: affiliateEarnings.reduce((sum, aff) => sum + aff.amount, 0)
  };
  
  // Calculate net earnings
  const totalGross = Object.values(grossEarnings).reduce((sum, amount) => sum + amount, 0);
  const totalRefunds = refunds.reduce((sum, refund) => sum + refund.amount, 0);
  const totalFees = fees.reduce((sum, fee) => sum + fee.amount, 0);
  
  const netEarnings = totalGross - totalRefunds - totalFees;
  
  // Determine available for payout
  const pendingTransactions = templateSales
    .filter(sale => sale.status === 'pending')
    .reduce((sum, sale) => sum + sale.netAmount, 0);
  
  const availableForPayout = netEarnings - pendingTransactions;
  
  return {
    currentBalance: netEarnings,
    pendingBalance: pendingTransactions,
    availableForPayout,
    totalLifetimeEarnings: await getLifetimeEarnings(env, creatorId),
    grossBreakdown: grossEarnings,
    deductions: { refunds: totalRefunds, fees: totalFees }
  };
};

// Real-time transaction processing
const processTemplateSale = async (
  env: Env,
  saleData: TemplateSale
) => {
  const template = await getTemplate(env, saleData.templateId);
  const creator = await getCreator(env, template.creatorId);
  
  // Calculate commission based on creator tier
  const commission = calculateCommission(
    saleData.amount,
    creator.tier
  );
  
  // Create transaction record
  const transaction: Transaction = {
    id: `txn:${Date.now()}:${saleData.buyerId}`,
    type: 'template_sale',
    amount: saleData.amount,
    creatorEarnings: commission.creatorEarnings,
    platformFee: commission.platformFee,
    templateId: saleData.templateId,
    buyerId: saleData.buyerId,
    sellerId: template.creatorId,
    status: 'pending', // 30-day refund window
    createdAt: new Date().toISOString(),
    completedAt: null
  };
  
  // Store transaction
  await env.TRANSACTIONS.put(
    transaction.id,
    JSON.stringify(transaction)
  );
  
  // Update creator balance (pending)
  await updateCreatorBalance(env, template.creatorId, {
    pendingBalance: commission.creatorEarnings,
    transactionId: transaction.id
  });
  
  // Process affiliate commission if applicable
  if (saleData.referralCode) {
    await processAffiliateCommission(env, saleData);
  }
  
  return transaction;
};

// Payout processing and tracking
const processPayout = async (env: Env, creatorId: string) => {
  const creator = await getCreator(env, creatorId);
  const earnings = await calculateCreatorEarnings(env, creatorId);
  
  // Verify payout threshold
  if (earnings.availableForPayout < 50) {
    throw new Error('Minimum payout threshold not met ($50)');
  }
  
  // Verify Stripe Connect setup
  if (!creator.stripeAccountId) {
    throw new Error('Stripe Connect account required for payouts');
  }
  
  // Create payout record
  const payout: Payout = {
    id: `payout:${creatorId}:${Date.now()}`,
    creatorId,
    amount: earnings.availableForPayout,
    currency: 'USD',
    method: 'stripe_connect',
    status: 'processing',
    createdAt: new Date().toISOString(),
    expectedDelivery: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // Net 30
    fee: 0, // Stripe fees covered by FormWeaver
    taxWithheld: 0
  };
  
  // Process via Stripe
  try {
    const stripePayout = await stripe.payouts.create({
      amount: Math.round(earnings.availableForPayout * 100), // Convert to cents
      currency: 'usd',
      destination: creator.stripeAccountId,
    });
    
    payout.status = 'completed';
    payout.stripePayoutId = stripePayout.id;
    payout.completedAt = new Date().toISOString();
    
    // Update all pending transactions to completed
    await finalizeTransactions(env, creatorId);
    
    // Reset pending balance
    await resetPendingBalance(env, creatorId);
    
  } catch (error) {
    payout.status = 'failed';
    payout.errorMessage = error.message;
  }
  
  // Store payout record
  await env.PAYOUTS.put(payout.id, JSON.stringify(payout));
  
  return payout;
};
```

**Earnings Tracking Rules:**

- **Real-time updates** - Process transactions immediately upon completion
- **Multi-tier commissions** - Calculate based on creator status and subscription level
- **Refund protection** - Hold earnings for 30 days to cover potential refunds
- **Tax compliance** - Generate 1099-K forms for US creators > $600/year
- **Multi-currency support** - Handle USD, EUR, GBP with automatic conversion
- **Detailed breakdown** - Show gross, net, fees, and commission calculations

### 24.3 Template Management System Architecture

```tsx
// ✅ GOOD: Comprehensive template management interface
interface TemplateManagementSystem {
  templates: TemplateMetadata[];
  categories: TemplateCategory[];
  workflows: TemplateWorkflow[];
  integrations: Integration[];
  compliance: ComplianceSettings;
}

const TemplateManagementDashboard = ({ creatorId }: { creatorId: string }) => {
  const { data: templates, refetch } = useQuery({
    queryKey: ['creator-templates', creatorId],
    queryFn: () => fetchCreatorTemplates(env, creatorId),
  });
  
  const { data: categories } = useQuery({
    queryKey: ['template-categories'],
    queryFn: () => fetchTemplateCategories(env),
  });
  
  return (
    <div className="template-management">
      <TemplateLibrary
        templates={templates}
        onTemplateUpdate={refetch}
      />
      
      <TemplateCreationWorkflow
        categories={categories}
        creatorId={creatorId}
      />
      
      <TemplateAnalytics
        templates={templates}
        creatorId={creatorId}
      />
    </div>
  );
};

// Template creation workflow with validation
const TemplateCreationWorkflow = ({ categories, creatorId }) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [templateData, setTemplateData] = useState<TemplateDraft>({});
  
  const workflowSteps = [
    {
      title: "Basic Information",
      component: BasicInfoStep,
      validation: validateBasicInfo
    },
    {
      title: "Form Design",
      component: FormDesignStep,
      validation: validateFormDesign
    },
    {
      title: "Pricing & Category",
      component: PricingStep,
      validation: validatePricing
    },
    {
      title: "Compliance Settings",
      component: ComplianceStep,
      validation: validateCompliance
    },
    {
      title: "Review & Publish",
      component: ReviewStep,
      validation: validateFinalReview
    }
  ];
  
  const currentStepConfig = workflowSteps[currentStep];
  
  const handleNext = async () => {
    const validation = currentStepConfig.validation(templateData);
    if (!validation.valid) {
      toast.error(validation.errors.join(', '));
      return;
    }
    
    if (currentStep < workflowSteps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      // Final validation and publish
      const publishResult = await publishTemplate(env, creatorId, templateData);
      if (publishResult.success) {
        toast.success('Template published successfully!');
      } else {
        toast.error('Template validation failed. Please review and try again.');
      }
    }
  };
  
  return (
    <div className="workflow-container">
      <WorkflowHeader
        currentStep={currentStep}
        totalSteps={workflowSteps.length}
        title={currentStepConfig.title}
      />
      
      <currentStepConfig.component
        data={templateData}
        onUpdate={setTemplateData}
      />
      
      <WorkflowActions
        onPrevious={() => setCurrentStep(Math.max(0, currentStep - 1))}
        onNext={handleNext}
        canProceed={currentStepConfig.validation(templateData).valid}
        isLastStep={currentStep === workflowSteps.length - 1}
      />
    </div>
  );
};

// Template compliance validation
const validateTemplateCompliance = async (
  env: Env,
  templateData: TemplateDraft
): Promise<ValidationResult> => {
  const validations = await Promise.all([
    validateAccessibility(templateData),
    validateSecurity(templateData),
    validateDataRetention(templateData),
    validateIndustryCompliance(templateData)
  ]);
  
  const errors = validations
    .filter(result => !result.valid)
    .flatMap(result => result.errors);
  
  return {
    valid: errors.length === 0,
    errors
  };
};

// Template versioning and rollback
const TemplateVersioning = ({ templateId }) => {
  const { data: versions } = useQuery({
    queryKey: ['template-versions', templateId],
    queryFn: () => fetchTemplateVersions(env, templateId),
  });
  
  const handleRollback = async (versionId: string) => {
    const result = await rollbackTemplateVersion(env, templateId, versionId);
    if (result.success) {
      toast.success('Template rolled back successfully');
    } else {
      toast.error('Failed to rollback template');
    }
  };
  
  return (
    <Card>
      <CardHeader>
        <CardTitle>Version History</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {versions.map(version => (
            <div key={version.id} className="flex justify-between items-center p-3 border rounded">
              <div>
                <div className="font-medium">Version {version.versionNumber}</div>
                <div className="text-sm text-muted-foreground">
                  {new Date(version.createdAt).toLocaleDateString()}
                </div>
                <div className="text-sm">{version.changelog}</div>
              </div>
              <div className="space-x-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => previewTemplateVersion(templateId, version.id)}
                >
                  Preview
                </Button>
                <Button
                  size="sm"
                  disabled={version.isActive}
                  onClick={() => handleRollback(version.id)}
                >
                  Rollback
                </Button>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
};
```

**Template Management Standards:**

- **Guided creation workflow** - Step-by-step process with validation at each stage
- **Version control** - Full version history with rollback capabilities
- **Compliance validation** - Automated checks for accessibility, security, and legal requirements
- **Category management** - Hierarchical categorization system
- **Template analytics** - Performance metrics for each template
- **Bulk operations** - Manage multiple templates simultaneously

### 24.4 Review and Rating System Development

```typescript
// ✅ GOOD: Comprehensive review and rating system
interface TemplateReview {
  id: string;
  templateId: string;
  userId: string;
  rating: number; // 1-5 stars
  title: string;
  comment: string;
  pros: string[];
  cons: string[];
  verifiedPurchase: boolean;
  helpfulVotes: number;
  createdAt: string;
  updatedAt: string;
  status: 'pending' | 'approved' | 'rejected' | 'flagged';
  moderationNotes?: string;
}

// Review submission with fraud detection
const submitTemplateReview = async (
  env: Env,
  reviewData: Omit<TemplateReview, 'id' | 'createdAt' | 'updatedAt' | 'status' | 'helpfulVotes'>
) => {
  // Verify purchase before allowing review
  const purchase = await getTemplatePurchase(env, reviewData.templateId, reviewData.userId);
  if (!purchase || !purchase.completedAt) {
    throw new Error('Must purchase template before reviewing');
  }
  
  // Fraud detection
  const fraudScore = await calculateFraudScore(env, reviewData);
  if (fraudScore > 0.8) {
    throw new Error('Review flagged as potential fraud');
  }
  
  // Sentiment analysis
  const sentiment = await analyzeReviewSentiment(reviewData.comment);
  
  const review: TemplateReview = {
    id: `review:${reviewData.templateId}:${Date.now()}`,
    ...reviewData,
    helpfulVotes: 0,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    status: sentiment.score < 0.3 ? 'pending' : 'approved' // Flag very negative reviews
  };
  
  // Store review
  await env.REVIEWS.put(review.id, JSON.stringify(review));
  
  // Update template rating
  await updateTemplateRating(env, reviewData.templateId);
  
  return review;
};

// Rating calculation with weighting
const calculateWeightedRating = async (env: Env, templateId: string) => {
  const reviews = await getApprovedReviews(env, templateId);
  
  const weightedRating = reviews.reduce((acc, review) => {
    const weight = calculateReviewWeight(review);
    return {
      weightedSum: acc.weightedSum + (review.rating * weight),
      totalWeight: acc.totalWeight + weight
    };
  }, { weightedSum: 0, totalWeight: 0 });
  
  const averageRating = weightedRating.totalWeight > 0
    ? weightedRating.weightedSum / weightedWeight.totalWeight
    : 0;
  
  return {
    rating: Math.round(averageRating * 10) / 10, // Round to 1 decimal
    reviewCount: reviews.length,
    distribution: calculateRatingDistribution(reviews)
  };
};

// Review weight calculation
const calculateReviewWeight = (review: TemplateReview): number => {
  let weight = 1.0;
  
  // Verified purchase bonus
  if (review.verifiedPurchase) weight *= 1.5;
  
  // Review depth bonus
  if (review.comment.length > 100) weight *= 1.2;
  if (review.pros.length > 0 && review.cons.length > 0) weight *= 1.3;
  
  // Helpful votes bonus
  weight *= 1 + (review.helpfulVotes * 0.1); // 10% boost per helpful vote
  
  // Recent review bonus (last 90 days)
  const daysSinceReview = (Date.now() - new Date(review.createdAt).getTime()) / (1000 * 60 * 60 * 24);
  if (daysSinceReview < 90) weight *= 1.1;
  
  return weight;
};

// Automated review moderation
const moderateReview = async (env: Env, reviewId: string) => {
  const review = await env.REVIEWS.get(reviewId, 'json');
  if (!review) return;
  
  const moderation = {
    profanityCheck: await checkProfanity(review.comment),
    spamCheck: await checkSpamPatterns(review),
    sentimentAnalysis: await analyzeSentiment(review.comment),
    lengthCheck: review.comment.length > 10
  };
  
  let status: 'approved' | 'rejected' | 'pending' = 'approved';
  let notes = '';
  
  if (moderation.profanityCheck.hasProfanity) {
    status = 'rejected';
    notes = 'Review contains profanity';
  } else if (moderation.spamCheck.isSpam) {
    status = 'rejected';
    notes = 'Review flagged as spam';
  } else if (moderation.sentimentAnalysis.negativity > 0.8 && !moderation.lengthCheck) {
    status = 'pending';
    notes = 'Very negative review requires manual review';
  }
  
  // Update review status
  await env.REVIEWS.put(reviewId, JSON.stringify({
    ...review,
    status,
    moderationNotes: notes,
    updatedAt: new Date().toISOString()
  }));
  
  return { status, notes };
};

// Review analytics for creators
const getReviewAnalytics = async (env: Env, templateId: string) => {
  const reviews = await getApprovedReviews(env, templateId);
  
  const analytics = {
    averageRating: calculateAverageRating(reviews),
    ratingDistribution: calculateRatingDistribution(reviews),
    sentimentTrend: calculateSentimentTrend(reviews),
    commonKeywords: extractCommonKeywords(reviews),
    responseRate: await calculateResponseRate(env, templateId),
    reviewQualityScore: calculateReviewQualityScore(reviews)
  };
  
  return analytics;
};
```

**Review System Rules:**

- **Purchase verification** - Only paying customers can leave reviews
- **Fraud detection** - Automated systems to detect fake reviews
- **Weighted ratings** - More weight given to verified, detailed reviews
- **Automated moderation** - AI-powered content filtering and spam detection
- **Creator response** - Allow creators to respond to reviews
- **Review analytics** - Insights into review patterns and sentiment

### 24.5 Creator Community Feature Development

```tsx
// ✅ GOOD: Creator community platform
const CreatorCommunity = ({ creatorId }: { creatorId: string }) => {
  const { data: communityFeed } = useQuery({
    queryKey: ['creator-community', creatorId],
    queryFn: () => fetchCommunityFeed(env, creatorId),
  });
  
  const { data: mentorshipPrograms } = useQuery({
    queryKey: ['mentorship-programs'],
    queryFn: () => fetchMentorshipPrograms(env),
  });
  
  return (
    <div className="creator-community">
      <CommunityFeed feed={communityFeed} />
      <CommunityFeatures
        creatorId={creatorId}
        mentorshipPrograms={mentorshipPrograms}
      />
    </div>
  );
};

// Community feed with engagement features
const CommunityFeed = ({ feed }: { feed: CommunityPost[] }) => {
  const [newPost, setNewPost] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  
  const handleSubmitPost = async () => {
    if (!newPost.trim()) return;
    
    const post: CommunityPost = {
      id: `post:${Date.now()}`,
      authorId: creatorId,
      content: newPost,
      category: selectedCategory,
      createdAt: new Date().toISOString(),
      likes: 0,
      comments: 0,
      shares: 0
    };
    
    await submitCommunityPost(env, post);
    setNewPost('');
  };
  
  return (
    <Card>
      <CardHeader>
        <CardTitle>Creator Community</CardTitle>
        <PostComposer
          content={newPost}
          onContentChange={setNewPost}
          category={selectedCategory}
          onCategoryChange={setSelectedCategory}
          onSubmit={handleSubmitPost}
        />
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {feed.map(post => (
            <CommunityPostItem
              key={post.id}
              post={post}
              onLike={handleLikePost}
              onComment={handleCommentPost}
              onShare={handleSharePost}
            />
          ))}
        </div>
      </CardContent>
    </Card>
  );
};

// Mentorship matching and community learning
const MentorshipMatching = ({ mentorshipPrograms }: { mentorshipPrograms: MentorshipProgram[] }) => {
  const [mentorshipInterest, setMentorshipInterest] = useState<MentorshipInterest | null>(null);
  
  const handleFindMentor = async (goals: string[]) => {
    const matching = await findMentorMatch(env, creatorId, goals);
    setMentorshipInterest({
      goals,
      matchedMentor: matching.mentor,
      matchDate: new Date().toISOString(),
      status: 'pending'
    });
  };
  
  const handleJoinStudyGroup = async (topic: string) => {
    const studyGroup = await joinStudyGroup(env, creatorId, topic);
    toast.success(`Joined study group: ${topic}`);
  };
  
  return (
    <div className="mentorship-section">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Find a Mentor</CardTitle>
            <CardDescription>
              Get matched with experienced creators in your field
            </CardDescription>
          </CardHeader>
          <CardContent>
            <MentorshipGoalsSelector
              onGoalsSelected={handleFindMentor}
            />
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Study Groups</CardTitle>
            <CardDescription>
              Join or create study groups for collaborative learning
            </CardDescription>
          </CardHeader>
          <CardContent>
            <StudyGroupSelector
              programs={mentorshipPrograms}
              onJoinGroup={handleJoinStudyGroup}
            />
          </CardContent>
        </Card>
      </div>
      
      {mentorshipInterest && (
        <MentorshipDetails
          interest={mentorshipInterest}
          onAccept={handleAcceptMentor}
          onDecline={handleDeclineMentor}
        />
      )}
    </div>
  );
};

// Creator collaboration tools
const CreatorCollaboration = ({ creatorId }: { creatorId: string }) => {
  const [collaborationRequests, setCollaborationRequests] = useState<CollaborationRequest[]>([]);
  const [activeCollaborations, setActiveCollaborations] = useState<Collaboration[]>([]);
  
  const handleStartCollaboration = async (templateId: string, collaboratorId: string) => {
    const collaboration = await createCollaboration(env, templateId, creatorId, collaboratorId);
    setActiveCollaborations([...activeCollaborations, collaboration]);
  };
  
  const handleSplitEarnings = async (collaborationId: string, splitPercentages: Record<string, number>) => {
    await updateEarningsSplit(env, collaborationId, splitPercentages);
    toast.success('Earnings split updated successfully');
  };
  
  return (
    <div className="collaboration-section">
      <Card>
        <CardHeader>
          <CardTitle>Collaborations</CardTitle>
          <CardDescription>
            Work with other creators on joint template projects
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {activeCollaborations.map(collab => (
              <CollaborationItem
                key={collab.id}
                collaboration={collab}
                onSplitEarnings={handleSplitEarnings}
                onEndCollaboration={handleEndCollaboration}
              />
            ))}
            
            <CollaborationRequestList
              requests={collaborationRequests}
              onAccept={handleAcceptRequest}
              onDecline={handleDeclineRequest}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
};
```

**Community Features:**

- **Social feed** - Posts, discussions, and announcements
- **Mentorship matching** - Algorithm-based mentor-mentee pairing
- **Study groups** - Topic-based learning communities
- **Collaboration tools** - Joint template creation and earnings splitting
- **Knowledge sharing** - Best practices, tutorials, and resource sharing
- **Recognition system** - Badges, leaderboards, and achievement displays

---

## 25. Updated Security Guidelines (Marketplace-Specific)

### 25.1 Marketplace-Specific Security Considerations

```typescript
// ✅ GOOD: Marketplace security with template validation
const validateTemplateSecurity = async (templateCode: string): Promise<SecurityValidationResult> => {
  const validations = await Promise.all([
    checkForXSS(templateCode),
    checkForSQLInjection(templateCode),
    checkForMaliciousScripts(templateCode),
    checkForUnsafeAPIs(templateCode),
    checkForDataExfiltration(templateCode)
  ]);
  
  const securityIssues = validations
    .filter(result => !result.safe)
    .flatMap(result => result.issues);
  
  return {
    safe: securityIssues.length === 0,
    issues: securityIssues,
    riskLevel: calculateRiskLevel(securityIssues)
  };
};

// Template sandboxing and execution
const executeTemplateSandboxed = async (
  env: Env,
  templateId: string,
  formData: any
): Promise<TemplateExecutionResult> => {
  // Validate template is approved
  const template = await getApprovedTemplate(env, templateId);
  if (!template) {
    throw new Error('Template not found or not approved');
  }
  
  // Execute in isolated environment
  const executionResult = await env.TEMPLATE_SANDBOX.fetch('https://sandbox.formweaver.com/execute', {
    method: 'POST',
    body: JSON.stringify({
      templateCode: template.code,
      formData,
      executionTimeout: 5000 // 5 second timeout
    }),
    headers: {
      'Content-Type': 'application/json'
    }
  });
  
  if (!executionResult.ok) {
    throw new Error('Template execution failed');
  }
  
  return await executionResult.json();
};

// Creator account security
const validateCreatorAccount = async (env: Env, creatorId: string): Promise<boolean> => {
  const creator = await getCreatorProfile(env, creatorId);
  
  // Check for suspicious activity
  const recentActivity = await getRecentCreatorActivity(env, creatorId);
  const suspiciousPatterns = detectSuspiciousPatterns(recentActivity);
  
  if (suspiciousPatterns.length > 0) {
    // Flag account for review
    await flagCreatorAccount(env, creatorId, 'suspicious_activity', suspiciousPatterns);
    return false;
  }
  
  // Verify identity documents if required
  if (creator.tier === 'verified' && !creator.identityVerified) {
    return false;
  }
  
  return true;
};

// Marketplace fraud detection
const detectMarketplaceFraud = async (
  env: Env,
  transactionData: TransactionData
): Promise<FraudDetectionResult> => {
  const fraudSignals = await Promise.all([
    checkVelocityAnomalies(env, transactionData.userId),
    checkPaymentMethodAnomalies(transactionData.paymentMethod),
    checkGeolocationAnomalies(transactionData),
    checkTemplateAbusePatterns(env, transactionData.templateId),
    checkReviewManipulation(transactionData)
  ]);
  
  const totalRiskScore = fraudSignals.reduce((sum, signal) => sum + signal.riskScore, 0);
  
  return {
    riskScore: totalRiskScore,
    isFraudulent: totalRiskScore > 0.7,
    riskFactors: fraudSignals.filter(signal => signal.riskScore > 0.3),
    recommendedAction: determineRecommendedAction(totalRiskScore)
  };
};
```

**Marketplace Security Rules:**

- **Template validation** - Automated security scanning for all submitted templates
- **Code sandboxing** - Execute templates in isolated environments
- **Creator verification** - Identity verification for high-tier creators
- **Fraud detection** - Real-time monitoring of transactions and behavior
- **Payment security** - PCI compliance for all payment processing
- **Data protection** - Encryption of sensitive creator and buyer information

---

## 26. Updated Performance Requirements for Marketplace Features

### 26.1 Marketplace Performance Standards

```typescript
// ✅ GOOD: Performance-optimized marketplace queries
const getMarketplaceTemplates = async (
  env: Env,
  filters: TemplateFilters,
  pagination: Pagination
): Promise<MarketplaceTemplateResponse> => {
  const cacheKey = `marketplace:${hashFilters(filters)}:${pagination.page}`;
  
  // Try cache first
  const cached = await env.MARKETPLACE_CACHE.get(cacheKey, 'json');
  if (cached) return cached;
  
  // Optimized query with proper indexing
  const query = `
    SELECT t.*,
           c.rating,
           c.reviewCount,
           s.salesCount,
           u.displayName as creatorName
    FROM templates t
    JOIN template_categories tc ON t.id = tc.templateId
    JOIN creator_ratings c ON t.creatorId = c.creatorId
    JOIN template_sales s ON t.id = s.templateId
    JOIN users u ON t.creatorId = u.id
    WHERE t.status = 'active'
    AND tc.category = ?
    AND t.price BETWEEN ? AND ?
    AND t.rating >= ?
    ORDER BY ${filters.sortBy} ${filters.sortOrder}
    LIMIT ? OFFSET ?
  `;
  
  const stmt = env.DB.prepare(query);
  const results = await stmt.bind(
    filters.category,
    filters.minPrice,
    filters.maxPrice,
    filters.minRating,
    pagination.limit,
    pagination.offset
  ).all();
  
  const response: MarketplaceTemplateResponse = {
    templates: results.results,
    total: await getTemplateCount(env, filters),
    facets: await getSearchFacets(env, filters)
  };
  
  // Cache for 10 minutes
  await env.MARKETPLACE_CACHE.put(
    cacheKey,
    JSON.stringify(response),
    { expirationTtl: 600 }
  );
  
  return response;
};

// Real-time analytics aggregation
const getRealTimeAnalytics = async (env: Env, creatorId: string) => {
  const cacheKey = `analytics:realtime:${creatorId}`;
  
  // Try fast cache first (1 minute TTL)
  const fastCache = await env.REALTIME_CACHE.get(cacheKey, 'json');
  if (fastCache) return fastCache;
  
  // Aggregate from recent data
  const analytics = await aggregateRealTimeData(env, creatorId);
  
  // Store in fast cache
  await env.REALTIME_CACHE.put(
    cacheKey,
    JSON.stringify(analytics),
    { expirationTtl: 60 } // 1 minute
  );
  
  return analytics;
};

// Performance monitoring for marketplace
const monitorMarketplacePerformance = async (env: Env) => {
  const metrics = {
    apiResponseTime: await measureApiResponseTime(env),
    templateLoadTime: await measureTemplateLoadTime(env),
    searchResponseTime: await measureSearchResponseTime(env),
    checkoutCompletionTime: await measureCheckoutTime(env),
    errorRate: await measureErrorRate(env)
  };
  
  // Alert if performance degrades
  if (metrics.apiResponseTime > 200) {
    await sendPerformanceAlert(env, 'API response time degraded', metrics);
  }
  
  if (metrics.errorRate > 0.01) { // 1% error rate
    await sendPerformanceAlert(env, 'Error rate exceeded threshold', metrics);
  }
  
  return metrics;
};
```

**Performance Requirements:**

- **API response time** - Marketplace APIs must respond within 200ms (p95)
- **Template loading** - Individual templates must load within 1.5 seconds
- **Search performance** - Search results must appear within 300ms
- **Checkout flow** - Complete checkout process within 3 seconds
- **Real-time updates** - Analytics refresh every 60 seconds maximum
- **Cache optimization** - 95% cache hit rate for popular templates

---

## 27. Accessibility and Internationalization for Global Marketplace

### 27.1 Global Marketplace Accessibility Standards

```tsx
// ✅ GOOD: Internationalized marketplace interface
const InternationalizedMarketplace = () => {
  const { locale, t } = useInternationalization();
  const { data: templates } = useQuery({
    queryKey: ['marketplace-templates', locale],
    queryFn: () => fetchLocalizedTemplates(env, locale),
  });
  
  return (
    <div className="marketplace" lang={locale}>
      <MarketplaceHeader
        title={t('marketplace.title')}
        locale={locale}
      />
      
      <TemplateGrid
        templates={templates}
        locale={locale}
        currency={getCurrencyForLocale(locale)}
      />
      
      <AccessibilityControls />
    </div>
  );
};

// Multi-language template support
const localizeTemplate = async (
  env: Env,
  templateId: string,
  targetLocale: string
): Promise<LocalizedTemplate> => {
  // Get base template
  const template = await getTemplate(env, templateId);
  
  // Get existing translations
  const existingTranslation = await env.TEMPLATE_TRANSLATIONS.get(
    `${templateId}:${targetLocale}`
  );
  
  if (existingTranslation) {
    return JSON.parse(existingTranslation);
  }
  
  // Generate translation using AI
  const translation = await generateTemplateTranslation(
    template,
    targetLocale
  );
  
  // Store translation
  await env.TEMPLATE_TRANSLATIONS.put(
    `${templateId}:${targetLocale}`,
    JSON.stringify(translation),
    { expirationTtl: 86400 * 30 } // 30 days
  );
  
  return translation;
};

// Accessibility compliance for global users
const AccessibilityCompliance = () => {
  const [screenReaderMode, setScreenReaderMode] = useState(false);
  const [highContrastMode, setHighContrastMode] = useState(false);
  const [reducedMotion, setReducedMotion] = useState(false);
  
  return (
    <div
      className={`marketplace ${highContrastMode ? 'high-contrast' : ''}`}
      style={{
        animation: reducedMotion ? 'none' : undefined,
        transition: reducedMotion ? 'none' : undefined
      }}
    >
      <AccessibilityToolbar
        screenReaderMode={screenReaderMode}
        onScreenReaderToggle={setScreenReaderMode}
        highContrastMode={highContrastMode}
        onHighContrastToggle={setHighContrastMode}
        reducedMotion={reducedMotion}
        onReducedMotionToggle={setReducedMotion}
      />
      
      <InternationalizedTemplateList
        screenReaderMode={screenReaderMode}
        aria-label="Template marketplace"
      />
    </div>
  );
};

// Currency and pricing localization
const localizePricing = (
  price: number,
  targetCurrency: string,
  locale: string
): LocalizedPrice => {
  const exchangeRate = getExchangeRate('USD', targetCurrency);
  const localizedPrice = price * exchangeRate;
  
  const formattedPrice = new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: targetCurrency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 2
  }).format(localizedPrice);
  
  return {
    amount: localizedPrice,
    currency: targetCurrency,
    formatted: formattedPrice,
    exchangeRate,
    includesVAT: isVATIncluded(targetCurrency)
  };
};
```

**Internationalization Rules:**

- **Multi-language support** - English, Spanish, French, German, Japanese
- **Currency localization** - USD, EUR, GBP with automatic conversion
- **Cultural adaptation** - Date formats, number formats, measurement units
- **Accessibility compliance** - WCAG 2.1 AA for all locales
- **RTL support** - Right-to-left language support
- **Content moderation** - Localized content review and moderation

---

## 28. Updated Code Review Checklist

### 28.1 Marketplace Feature Code Review

**Frontend (Marketplace):**

- [ ] Template marketplace API calls use proper authentication
- [ ] Creator dashboard follows accessibility guidelines
- [ ] Earnings calculations are accurate to 4 decimal places
- [ ] Student discount system validates educational emails
- [ ] Template preview functionality works correctly
- [ ] Review and rating system prevents fraud
- [ ] Multi-language support implemented correctly
- [ ] Performance optimized for large template lists

**Backend (Marketplace):**

- [ ] Template validation includes security scanning
- [ ] Commission calculations follow tiered structure
- [ ] Data retention policies implemented correctly
- [ ] GDPR compliance features work as specified
- [ ] Payout processing integrates with Stripe Connect
- [ ] Fraud detection algorithms are effective
- [ ] Legal hold system prevents data deletion
- [ ] API rate limiting protects marketplace endpoints

**Legal Compliance:**

- [ ] Data retention TTL set correctly for form types
- [ ] User consent tracking implemented
- [ ] Right to erasure requests processed within 30 days
- [ ] HIPAA/SOX compliance for regulated forms
- [ ] Privacy policy disclosures are accurate
- [ ] Cross-border data transfer compliance
- [ ] Industry-specific regulation adherence

---

## 29. Updated Deployment and Monitoring

### 29.1 Marketplace Deployment Requirements

```bash
# Pre-deployment checks for marketplace
cd backend
npm run type-check
npm run lint
npm run test
npm run test:marketplace     # Marketplace-specific tests
wrangler deploy --dry-run

# Frontend marketplace checks
cd frontend
npm run type-check
npm run lint
npm run test:marketplace     # Creator dashboard tests
npm run build:marketplace    # Marketplace bundle optimization
npm run test:e2e:marketplace # End-to-end marketplace tests

# Database migration for marketplace
wrangler d1 migrations create FormWeaver marketplace_tables
wrangler d1 migrations apply FormWeaver --remote

# KV namespace setup
wrangler kv:namespace create MARKETPLACE_DATA
wrangler kv:namespace create CREATOR_ANALYTICS
wrangler kv:namespace create TEMPLATE_REVIEWS
wrangler kv:namespace create COMPLIANCE_LOGS
```

### 29.2 Marketplace Monitoring Dashboard

```typescript
// Marketplace-specific monitoring
const marketplaceMetrics = {
  // Revenue metrics
  dailyRevenue: await getDailyRevenue(env),
  creatorPayouts: await getDailyPayouts(env),
  commissionRevenue: await getDailyCommissions(env),
  
  // Marketplace health
  activeCreators: await getActiveCreatorsCount(env),
  newTemplates: await getNewTemplatesCount(env),
  templateApprovals: await getTemplateApprovalRate(env),
  
  // Legal compliance
  retentionDeletions: await getTodayRetentionDeletions(env),
  erasureRequests: await getTodayErasureRequests(env),
  legalHolds: await getActiveLegalHolds(env),
  
  // Performance
  marketplaceResponseTime: await getMarketplaceResponseTime(env),
  templateLoadTime: await getTemplateLoadTime(env),
  searchResponseTime: await getSearchResponseTime(env)
};

// Compliance monitoring
const complianceAlerts = {
  'gdpr_erasure_deadline': {
    condition: (metrics) => metrics.erasureRequests.pending > 30,
    message: 'GDPR erasure requests pending超过 30天',
    severity: 'critical'
  },
  'data_retention_failure': {
    condition: (metrics) => metrics.retentionDeletions.failed > 0,
    message: 'Automatic data deletion failures detected',
    severity: 'high'
  },
  'commission_calculation_error': {
    condition: (metrics) => metrics.commissionReconciliation.errorRate > 0.01,
    message: 'Commission calculation errors exceed 1%',
    severity: 'high'
  }
};
```

**Version:** 3.0
**Last Updated:** 2025-11-23
**Next Review:** 2025-12-23
