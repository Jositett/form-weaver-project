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

const forms = new Hono();

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
- **Type context** - Extend Hono context with custom variables
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

Backend (worker/):
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
├── worker/                  # Cloudflare Worker (Hono API)
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
│   │   │   ├── schema.sql
│   │   │   ├── migrations/
│   │   │   └── queries.ts   # Prepared statements
│   │   ├── types/           # Shared types
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
const getFormById = async (db: D1Database, formId: string) => {
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
cd worker
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
  return await env.DB.prepare(
    'SELECT * FROM forms WHERE id = ?'
  ).bind(formId).first();
};

// ❌ BAD: Creating new connections
// D1 doesn't require connection pooling - use bindings
```

**Batch Operations:**
```typescript
// ✅ GOOD: Use batch() for multiple queries
const results = await env.DB.batch([
  env.DB.prepare('SELECT * FROM forms WHERE workspace_id = ?').bind(workspaceId),
  env.DB.prepare('SELECT COUNT(*) FROM submissions WHERE form_id = ?').bind(formId),
]);

const [forms, submissionCount] = results;
```

**Transaction Support:**
```typescript
// ✅ GOOD: Use transactions for related operations
await env.DB.prepare(
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
  const form = await env.DB.prepare(
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
- Email: dev@FormWeaver.app
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
  let query = env.DB.prepare(`
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
  
  return await env.DB.prepare(
    `DELETE FROM forms WHERE id IN (${placeholders})`
  ).bind(...formIds).run();
};
```

### 19.3 Search
```typescript
// ✅ GOOD: Full-text search with D1
const searchForms = async (env: Env, workspaceId: string, query: string) => {
  return await env.DB.prepare(`
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
  await env.DB.prepare(
    'UPDATE forms SET deleted_at = ? WHERE id = ?'
  ).bind(Date.now(), formId).run();
  
  // Invalidate cache
  await env.FORM_CACHE.delete(`form:${formId}`);
};

// Exclude deleted in queries
const getActiveForms = async (env: Env, workspaceId: string) => {
  return await env.DB.prepare(
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

**Version:** 2.0  
**Last Updated:** 2025-11-16  
**Next Review:** 2025-12-16
