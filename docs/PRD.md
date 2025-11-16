# Product Requirements Document (PRD)
## FormWeaver SaaS (Cloudflare Workers Edition)

**Version:** 2.0  
**Last Updated:** 2025-11-16  
**Product Owner:** TBD  
**Status:** In Development  
**Infrastructure:** Cloudflare Workers + Hono + D1

---

## 1. Executive Summary

### 1.1 Product Vision
A powerful, embeddable FormWeaver built on Cloudflare's global edge network, allowing SaaS companies and developers to integrate a no-code form creation tool directly into their applications with <50ms latency worldwide. Users can design forms with drag-and-drop, collect responses, and extend functionality with custom input elements.

### 1.2 Target Users
- **Primary:** SaaS developers who need form building capabilities in their apps
- **Secondary:** Enterprise teams building internal tools
- **Tertiary:** Agencies managing multiple client forms

### 1.3 Key Differentiators
- **Edge-first architecture** - <50ms global latency via Cloudflare Workers
- **Embeddable widget** with white-label options
- **Custom element plugin system** for unlimited extensibility
- **Multi-tenant architecture** with workspace isolation
- **React, Vue, and vanilla JS SDKs**
- **Usage-based pricing** that scales with customer needs
- **99.99% uptime** on Cloudflare's global network

---

## 2. Core Features

### 2.1 MVP Features (v1.0) - Weeks 1-4

#### Form Designer (Frontend)
- ✅ Drag-and-drop interface with 4-panel layout
- ✅ Support for 12 standard HTML5 input types
- ✅ Real-time preview pane
- ✅ Property editor for field configuration
- ✅ JSON schema export/import
- ✅ Required field validation
- ✅ Min/max length validation
- [ ] Form templates (Blank, Contact, Survey, Registration)
- [ ] Undo/redo functionality (Ctrl+Z, Ctrl+Y)
- [ ] Keyboard shortcuts for power users (Delete, Duplicate)
- [ ] Field duplication
- [ ] Form title/description editor

#### Field Types (Standard)
- ✅ Text, Email, Password, Number, Tel, URL
- ✅ Date, Time, Textarea
- ✅ Select (single/multiple)
- ✅ Radio buttons, Checkboxes
- [ ] File upload (single/multiple) - Using R2 Storage
- [ ] Range slider
- [ ] Color picker

#### Validation (Backend: Cloudflare Workers)
- ✅ Required fields (client-side)
- ✅ Min/max length (client-side)
- ✅ Min/max value (client-side)
- [ ] Pattern matching (regex) - Server-side validation
- [ ] Email validation (server-side)
- [ ] Phone number validation (server-side)
- [ ] URL validation (server-side)
- [ ] Custom error messages per validation rule
- [ ] Cross-field validation (e.g., password confirmation)

#### Form Management (Hono API)
- [ ] Save forms to D1 database
- [ ] Auto-save every 30 seconds
- [ ] Manual save button (Ctrl+S)
- [ ] Save status indicator ("Saving...", "Saved", "Error")
- [ ] Load existing form in designer
- [ ] List all forms (table view with pagination)
- [ ] Edit existing forms
- [ ] Delete forms (with confirmation)
- [ ] Duplicate forms
- [ ] Form status toggle (Draft/Published)
- [ ] Search/filter forms

#### Data Collection (Cloudflare Workers)
- [ ] Public form page (`/f/:formId`) served from edge
- [ ] Submit form responses to Workers API
- [ ] Store submissions in D1 database
- [ ] Rate limiting (10 submissions per IP per 10 minutes)
- [ ] Capture metadata (IP, user agent, timestamp)
- [ ] Handle large text fields (10,000+ chars)
- [ ] View submissions table (paginated)
- [ ] Export submissions (CSV) - Generated via Workers Streams
- [ ] Export submissions (JSON) - Gzipped for large datasets
- [ ] Delete submissions
- [ ] Filter by date range
- [ ] Search submissions

#### Embedding
- [ ] Generate embeddable iframe code
- [ ] iframe URL with query params (theme, colors, etc.)
- [ ] Copy to clipboard button
- [ ] Auto-resize iframe script
- [ ] JavaScript SDK (vanilla) - Hosted on Workers
- [ ] React component SDK
- [ ] Vue component SDK
- [ ] CORS configuration via Workers middleware
- [ ] Webhook configuration for submissions

#### Authentication & Multi-tenancy (JWT + D1)
- [ ] User authentication (email/password) - JWT tokens
- [ ] Password hashing with bcrypt
- [ ] Email verification tokens (stored in KV with TTL)
- [ ] Password reset tokens (stored in KV with TTL)
- [ ] Create first workspace automatically on signup
- [ ] Workspace creation
- [ ] Workspace switching UI
- [ ] Team member invitations
- [ ] Role-based access control (Owner, Admin, Editor, Viewer)
- [ ] Security definer functions for role checks

---

### 2.2 Phase 2 Features (v2.0) - Weeks 5-10

#### Custom Elements System (Sandboxed in Workers)
- [ ] Custom element registry UI
- [ ] Upload custom JavaScript components
- [ ] Web Components sandbox (iframe isolation + CSP)
- [ ] AST validation before saving custom code
- [ ] Element configuration schema builder
- [ ] Public marketplace for custom elements
- [ ] Element versioning and updates
- [ ] Store custom elements in D1

#### Advanced Form Logic
- [ ] Conditional logic (show/hide fields based on values)
- [ ] Calculated fields (e.g., auto-calculate totals)
- [ ] Multi-step/wizard forms
- [ ] Progress indicators
- [ ] Save and resume later functionality (store in KV)
- [ ] Pre-fill fields from URL parameters

#### Styling & Branding
- [ ] Theme editor (colors, fonts, spacing)
- [ ] CSS injection for advanced customization
- [ ] White-label options (remove branding)
- [ ] Custom CSS classes per field
- [ ] Responsive design preview (mobile/tablet/desktop)
- [ ] Dark mode support

#### Integrations (Workers Webhooks)
- [ ] Webhook endpoints (submit, update, delete events)
- [ ] Workers can send POST to user webhook URLs
- [ ] Webhook signature verification
- [ ] Retry logic for failed webhooks
- [ ] Zapier integration
- [ ] Google Sheets sync
- [ ] Airtable sync
- [ ] Email notifications (Resend, SendGrid)
- [ ] Slack notifications

---

### 2.3 Phase 3 Features (v3.0) - Weeks 11-16

#### Enterprise Features
- [ ] SAML/SSO authentication
- [ ] Audit logs (stored in D1)
- [ ] Custom data retention policies
- [ ] Field-level encryption (encrypt in D1)
- [ ] GDPR compliance tools (data export, deletion)
- [ ] SLA guarantees (99.99% uptime via Cloudflare)
- [ ] Custom domains (forms.yourdomain.com)

#### Advanced Analytics (Durable Objects)
- [ ] Form completion rates
- [ ] Time spent per field
- [ ] Drop-off analysis
- [ ] A/B testing forms
- [ ] Conversion funnel visualization
- [ ] Custom event tracking
- [ ] Real-time analytics with Durable Objects

#### Collaboration (Durable Objects + WebSockets)
- [ ] Real-time collaborative editing via WebSockets
- [ ] Comments on forms (stored in D1)
- [ ] Change history with diffs (stored in D1)
- [ ] Form approval workflows
- [ ] Notifications for team updates

#### Developer Tools
- [ ] REST API for CRUD operations (Hono routes)
- [ ] GraphQL API (via Hono middleware)
- [ ] CLI tool for deployments (Wrangler-based)
- [ ] Terraform provider for Cloudflare
- [ ] SDKs for Python, PHP, Ruby
- [ ] Headless mode (API-only)
- [ ] OpenAPI spec generation

---

## 3. Technical Architecture

### 3.1 Frontend Stack
- **Framework:** React 18 + TypeScript
- **UI Components:** shadcn/ui + Radix UI
- **Styling:** Tailwind CSS with custom design tokens
- **Drag-and-Drop:** dnd-kit
- **Form Handling:** React Hook Form + Zod validation
- **State Management:** TanStack Query + Zustand
- **Build Tool:** Vite
- **Deployment:** Cloudflare Pages (static frontend)

### 3.2 Backend Stack (Cloudflare Workers)
- **Runtime:** Cloudflare Workers (V8 isolates)
- **Framework:** Hono (lightweight, fast, TypeScript-first)
- **Database:** D1 (SQLite at the edge, globally replicated)
- **Cache:** Workers KV (low-latency key-value store)
- **File Storage:** R2 (S3-compatible object storage)
- **Authentication:** JWT tokens + KV for sessions
- **Real-time:** Durable Objects + WebSockets (Phase 3)
- **API:** RESTful via Hono routes

### 3.3 Database Schema (D1 - SQLite)

#### Core Tables
```sql
-- Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT,
  email_verified INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE INDEX idx_users_email ON users(email);

-- Workspaces (multi-tenancy)
CREATE TABLE workspaces (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  owner_id TEXT NOT NULL,
  plan_type TEXT CHECK(plan_type IN ('free', 'pro', 'business', 'enterprise')) DEFAULT 'free',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_workspaces_owner ON workspaces(owner_id);
CREATE INDEX idx_workspaces_slug ON workspaces(slug);

-- Forms
CREATE TABLE forms (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  schema TEXT NOT NULL, -- JSON stored as TEXT
  status TEXT CHECK(status IN ('draft', 'published', 'archived')) DEFAULT 'draft',
  version INTEGER DEFAULT 1,
  created_by TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE INDEX idx_forms_workspace ON forms(workspace_id, created_at DESC);
CREATE INDEX idx_forms_status ON forms(workspace_id, status, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_forms_created_by ON forms(created_by);

-- Submissions
CREATE TABLE submissions (
  id TEXT PRIMARY KEY,
  form_id TEXT NOT NULL,
  data TEXT NOT NULL, -- JSON stored as TEXT
  ip_address TEXT,
  user_agent TEXT,
  referrer TEXT,
  submitted_at INTEGER NOT NULL,
  FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE
);

CREATE INDEX idx_submissions_form ON submissions(form_id, submitted_at DESC);
CREATE INDEX idx_submissions_ip ON submissions(ip_address, submitted_at DESC);

-- Custom Elements
CREATE TABLE custom_elements (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL,
  name TEXT NOT NULL,
  element_id TEXT UNIQUE NOT NULL,
  code TEXT NOT NULL,
  config_schema TEXT, -- JSON stored as TEXT
  is_public INTEGER DEFAULT 0,
  downloads INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE
);

CREATE INDEX idx_custom_elements_workspace ON custom_elements(workspace_id);
CREATE INDEX idx_custom_elements_public ON custom_elements(is_public, downloads DESC);

-- User Roles (for workspace access)
CREATE TABLE workspace_members (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  workspace_id TEXT NOT NULL,
  role TEXT CHECK(role IN ('owner', 'admin', 'editor', 'viewer')) DEFAULT 'viewer',
  invited_at INTEGER NOT NULL,
  joined_at INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE,
  UNIQUE(user_id, workspace_id)
);

CREATE INDEX idx_workspace_members_user ON workspace_members(user_id);
CREATE INDEX idx_workspace_members_workspace ON workspace_members(workspace_id);

-- Audit Logs (for compliance)
CREATE TABLE audit_logs (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id TEXT NOT NULL,
  metadata TEXT, -- JSON stored as TEXT
  ip_address TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_audit_logs_workspace ON audit_logs(workspace_id, created_at DESC);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id, created_at DESC);
```

### 3.4 Workers KV Namespaces

```toml
# wrangler.toml
[[kv_namespaces]]
binding = "FORM_CACHE"
id = "xxx"
# Usage: Cache form schemas, 10 min TTL

[[kv_namespaces]]
binding = "SESSION_STORE"
id = "xxx"
# Usage: JWT refresh tokens, 30 day TTL

[[kv_namespaces]]
binding = "EMAIL_TOKENS"
id = "xxx"
# Usage: Email verification, password reset tokens, 24h TTL

[[kv_namespaces]]
binding = "RATE_LIMIT"
id = "xxx"
# Usage: Rate limiting counters, 60s TTL
```

### 3.5 Security

#### Row-Level Security (D1 Queries)
```sql
-- All queries check workspace membership
SELECT * FROM forms 
WHERE workspace_id IN (
  SELECT workspace_id 
  FROM workspace_members 
  WHERE user_id = ?
);
```

#### Custom Element Sandboxing
- **CSP Headers:** `script-src 'self'; object-src 'none';`
- **iframe Sandbox:** `allow-scripts allow-same-origin`
- **AST Validation:** Parse custom code, reject malicious patterns
- **Execution Timeout:** Kill scripts after 10ms CPU time

#### Rate Limiting (Workers KV)
```typescript
// 10 submissions per IP per 10 minutes
const key = `ratelimit:${ip}:${formId}`;
const count = await env.RATE_LIMIT.get(key);
if (count && parseInt(count) >= 10) {
  return c.json({ error: 'Too many requests' }, 429);
}
await env.RATE_LIMIT.put(key, String((parseInt(count || '0') + 1)), {
  expirationTtl: 600
});
```

#### Data Encryption
- **At Rest:** D1 encryption (managed by Cloudflare)
- **In Transit:** TLS 1.3 (automatic with Workers)
- **Secrets:** Wrangler secrets (JWT_SECRET, API_KEYS)

#### Input Validation
- **Client-side:** Zod schemas in React
- **Server-side:** Zod validation in Hono routes (zValidator middleware)
- **SQL Injection:** D1 prepared statements only (never string concatenation)

---

## 4. Embedding Architecture

### 4.1 Embedding Methods

#### Method 1: iframe Embed
```html
<iframe 
  src="https://forms.FormWeaver.app/f/form_abc123?theme=dark"
  width="100%"
  height="600"
  frameborder="0"
  allow="clipboard-write"
  sandbox="allow-scripts allow-same-origin allow-forms"
></iframe>
```

**Served from:** Cloudflare Workers edge locations (300+)

#### Method 2: JavaScript SDK
```html
<script src="https://cdn.FormWeaver.app/sdk.min.js"></script>
<div id="form-container"></div>
<script>
  FormWeaver.render({
    formId: 'form_abc123',
    container: '#form-container',
    apiUrl: 'https://api.FormWeaver.app/v1', // Workers endpoint
    onSubmit: (data) => console.log(data),
    theme: 'light'
  });
</script>
```

**SDK served from:** Cloudflare Workers CDN with edge caching

#### Method 3: React Component
```jsx
import { FormWeaverEmbed } from '@FormWeaver/react';

<FormWeaverEmbed 
  formId="form_abc123"
  apiKey="pk_live_..."
  apiUrl="https://api.FormWeaver.app/v1"
  onSubmit={(data) => handleSubmit(data)}
/>
```

### 4.2 White-Label Options
- Custom domain (forms.yourdomain.com) - Via Cloudflare Workers custom domains
- Remove "Powered by FormWeaver" badge
- Custom loading screens
- Custom error messages
- Custom CSS injection

---

## 5. Cloudflare Infrastructure

### 5.1 Architecture Diagram

```
┌─────────────────────────────────────────────┐
│         Cloudflare Global Network           │
│         300+ Edge Locations Worldwide       │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Cloudflare Pages (Frontend)       │   │
│  │   - React app (static assets)       │   │
│  │   - Edge cached (1 year)            │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Cloudflare Workers (Hono API)     │   │
│  │   - /api/v1/* endpoints             │   │
│  │   - JWT authentication              │   │
│  │   - Rate limiting                   │   │
│  │   - <10ms CPU time per request      │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   D1 Database (SQLite at Edge)      │   │
│  │   - Auto-replicated globally        │   │
│  │   - <10ms query latency             │   │
│  │   - Prepared statements only        │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Workers KV (Key-Value Store)      │   │
│  │   - Form schema cache (10 min)      │   │
│  │   - Session tokens (30 days)        │   │
│  │   - Rate limit counters (60s)       │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   R2 Storage (Object Storage)       │   │
│  │   - File uploads                    │   │
│  │   - CSV/JSON exports                │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Durable Objects (Phase 3)         │   │
│  │   - WebSocket connections           │   │
│  │   - Real-time collaboration         │   │
│  └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘
           │
           │ (External integrations)
           ▼
    ┌──────────────────┐
    │  Stripe API      │  (Billing)
    ├──────────────────┤
    │  SendGrid/Resend │  (Emails)
    ├──────────────────┤
    │  User Webhooks   │  (Integrations)
    └──────────────────┘
```

### 5.2 Performance Characteristics

| Metric | Target | Cloudflare Reality |
|--------|--------|-------------------|
| **API Latency (p50)** | <50ms | ✅ <10ms (edge compute) |
| **API Latency (p99)** | <200ms | ✅ <50ms (global network) |
| **Form Load Time** | <500ms | ✅ <200ms (edge cache) |
| **Uptime** | 99.9% | ✅ 99.99%+ (Cloudflare SLA) |
| **Global Coverage** | Worldwide | ✅ 300+ edge locations |
| **Cold Starts** | N/A | ✅ Zero (V8 isolates) |

### 5.3 Scaling Strategy

**Automatic Scaling:**
- Workers automatically scale to millions of requests
- D1 auto-replicates to nearest edge locations
- KV provides global low-latency access
- No manual scaling configuration needed

**Cost Structure:**
- Free: 100k requests/day, 25 GB storage
- Paid: $5/month for 10M requests, scales linearly
- D1: $0.001 per 1M reads, $5 per 1M writes

---

## 6. Monetization Strategy

See `docs/PRICING.md` for detailed pricing tiers.

**Revenue Streams:**
1. **Subscription fees** (monthly/annual plans)
2. **Usage overage charges** (submissions, storage)
3. **Custom element marketplace** (20% commission)
4. **Professional services** (custom integrations, training)
5. **Enterprise contracts** (custom SLAs, dedicated support)

**Pricing Based on Cloudflare Costs:**
- Free tier: Covered by Cloudflare free plan
- Pro tier: $29/mo (10k submissions, margins >80%)
- Business tier: $99/mo (100k submissions, margins >85%)
- Enterprise: Custom (margins >90% due to Cloudflare's economics)

---

## 7. Success Metrics

### 7.1 Product Metrics
- **Activation:** % users who create first form within 7 days (Target: 60%)
- **Engagement:** Forms created per workspace per month (Target: 5+)
- **Retention:** % workspaces active month-over-month (Target: 80%)
- **Conversion:** Free to paid conversion rate (Target: 10%)

### 7.2 Technical Metrics (Cloudflare Workers)
- **Uptime:** 99.99% availability (Cloudflare SLA)
- **Performance:** Form render time < 200ms (p95)
- **API Latency:** < 50ms (p99, measured globally)
- **Error Rate:** < 0.1% of requests
- **CPU Time:** < 10ms per request (Workers limit: 50ms free, 30s paid)
- **Cache Hit Rate:** > 80% for form schemas (KV cache)

### 7.3 Business Metrics
- **MRR:** Monthly Recurring Revenue (Target: $10k by month 3)
- **CAC:** Customer Acquisition Cost (Target: <$50)
- **LTV:** Lifetime Value (Target: >$500)
- **Churn Rate:** < 5% monthly
- **Gross Margin:** > 85% (Cloudflare's low infrastructure costs)

---

## 8. Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Custom element security exploits | High | Medium | Strict sandboxing, AST validation, CSP headers |
| D1 database performance at scale | High | Low | Prepared statements, indexes, KV caching |
| Cloudflare Workers limits hit | Medium | Low | Monitor CPU time, optimize queries, upgrade plan |
| Competitor pricing pressure | Medium | High | Focus on edge performance, unique features |
| GDPR/compliance violations | High | Low | Automated compliance checks, legal review |
| SDK breaking changes | Medium | Medium | Semantic versioning, deprecation warnings |
| Cloudflare outage | High | Very Low | Cloudflare 99.99%+ uptime, graceful degradation |

**Cloudflare-Specific Risks:**
- **D1 Limitations:** Currently in beta, limited to 1GB per database
  - *Mitigation:* Plan to shard across multiple D1 databases if needed
- **Workers CPU Limits:** 50ms free tier, 30s paid tier
  - *Mitigation:* Optimize code, use Durable Objects for long-running tasks
- **KV Consistency:** Eventually consistent (not immediate)
  - *Mitigation:* Use D1 for critical data, KV only for caching

---

## 9. Launch Checklist

### Pre-Launch (2 weeks before)
- [ ] Complete security audit (OWASP Top 10)
- [ ] Load testing (10k concurrent users via Workers)
- [ ] Test D1 query performance (all queries <10ms)
- [ ] Test KV cache hit rates (>80%)
- [ ] Documentation complete (API docs, tutorials, FAQs)
- [ ] Support system ready (help desk, live chat)
- [ ] Stripe billing integration tested
- [ ] Marketing site live (on Cloudflare Pages)
- [ ] Early access user feedback incorporated
- [ ] Wrangler deployment pipeline tested
- [ ] Monitoring setup (Workers Analytics, Sentry)

### Launch Day
- [ ] Deploy to production (`wrangler deploy`)
- [ ] Verify D1 migrations applied
- [ ] Test all API endpoints in production
- [ ] Enable Workers Analytics
- [ ] Enable rate limiting
- [ ] Announce on Product Hunt, HN, Reddit
- [ ] Send emails to waitlist
- [ ] Activate paid ads campaigns
- [ ] Monitor error rates (target: <0.1%)

### Post-Launch (First 30 days)
- [ ] Daily monitoring of Workers Analytics
- [ ] Monitor D1 query performance
- [ ] Monitor KV cache hit rates
- [ ] Collect user feedback via in-app surveys
- [ ] Weekly feature prioritization meetings
- [ ] Publish 2 case studies
- [ ] Hit 100 paid workspaces milestone
- [ ] Optimize slow queries (if any >10ms)
- [ ] Scale D1 if approaching limits

---

## 10. Appendix

### 10.1 Competitor Analysis
- **Typeform:** Strong design, limited extensibility, expensive, slower (no edge)
- **Jotform:** Feature-rich, dated UI, not embeddable, slower performance
- **Google Forms:** Free, limited customization, no white-label, no edge
- **Tally:** Modern, limited enterprise features, no edge compute
- **Reform:** Developer-focused, lacks no-code interface, no edge

**Our Edge:** Literally edge computing - <50ms global latency vs 200ms+ for competitors

### 10.2 User Personas

**Persona 1: SaaS Founder (Alex)**
- Needs FormWeaver for customer feedback in SaaS app
- Wants white-label solution with fast loading
- Budget: $50-200/month
- Technical: Can integrate via API
- **Pain Point:** Slow form loading hurting conversions
- **Our Solution:** Edge-first <50ms latency worldwide

**Persona 2: Enterprise Developer (Maya)**
- Building internal HR portal
- Requires SAML SSO and audit logs
- Budget: $500-2000/month
- Technical: Needs React SDK
- **Pain Point:** Complex infrastructure management
- **Our Solution:** Serverless, zero-ops Cloudflare infrastructure

**Persona 3: Agency Owner (Jordan)**
- Manages 20+ client websites
- Needs multi-workspace management
- Budget: $100-500/month
- Technical: Prefers iframe embeds
- **Pain Point:** Performance varies by client location
- **Our Solution:** Global edge network, consistent performance everywhere

### 10.3 Technical References
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Hono Framework](https://hono.dev)
- [D1 Database Guide](https://developers.cloudflare.com/d1/)
- [Workers KV](https://developers.cloudflare.com/kv/)
- [R2 Storage](https://developers.cloudflare.com/r2/)
- [Durable Objects](https://developers.cloudflare.com/durable-objects/)
- [Web Components Best Practices](https://web.dev/custom-elements-best-practices/)

### 10.4 Cloudflare Ecosystem Benefits
- **Cloudflare Pages:** Static frontend hosting
- **Cloudflare Analytics:** Built-in analytics (privacy-friendly)
- **Cloudflare Zaraz:** Tag management without performance hit
- **Cloudflare Turnstile:** Free CAPTCHA alternative
- **Cloudflare Email Routing:** Email forwarding
- **Cloudflare Access:** Zero-trust security (Enterprise)

---

**Next Review:** 2025-12-16 (monthly cadence)
