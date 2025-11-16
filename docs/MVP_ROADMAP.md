# MVP Roadmap
## FormWeaver SaaS - Weeks 1-4
### Cloudflare Workers + Hono Backend

**Goal:** Launch a functional, embeddable FormWeaver that delivers core value  
**Success Criteria:** 100 signups, 50 forms created, 10 paying customers

---

## Week 1: Foundation (Nov 18-24)

### Backend Infrastructure (Cloudflare + Hono)
- [ ] Cloudflare Workers setup
  - [ ] Initialize Wrangler project
  - [ ] Configure `wrangler.toml` (routes, environment)
  - [ ] Set up local development with `wrangler dev`
- [ ] Hono API setup
  - [ ] Create main Hono app instance
  - [ ] Configure CORS middleware
  - [ ] Add logging middleware
  - [ ] Set up error handling middleware
- [ ] D1 Database (Cloudflare's SQLite)
  - [ ] Create D1 database
  - [ ] Schema migrations:
    - [ ] `users` table
    - [ ] `workspaces` table
    - [ ] `workspace_members` table
    - [ ] `forms` table
    - [ ] `submissions` table
  - [ ] Database indexes for performance
- [ ] Authentication with Workers
  - [ ] JWT token generation/validation
  - [ ] Password hashing with bcrypt
  - [ ] POST `/auth/signup` endpoint
  - [ ] POST `/auth/login` endpoint
  - [ ] POST `/auth/verify-email` endpoint
  - [ ] POST `/auth/reset-password` endpoint
  - [ ] Auth middleware for protected routes
- [ ] KV Storage setup (session management)
  - [ ] Store refresh tokens in KV
  - [ ] Email verification tokens in KV (24hr TTL)
  - [ ] Password reset tokens in KV (1hr TTL)
- [ ] Create first workspace automatically on signup
- [ ] Workspace switching UI

### Form Designer Enhancements
- [x] Drag-and-drop for 12 field types
- [x] Property editor for field configuration
- [x] Live preview pane
- [ ] Undo/redo functionality (Ctrl+Z, Ctrl+Y)
- [ ] Keyboard shortcuts (Delete to remove field, etc.)
- [ ] Field duplication
- [ ] Form title/description editor

**API Endpoints:**
```
POST   /auth/signup
POST   /auth/login
POST   /auth/verify-email
POST   /auth/reset-password
GET    /workspaces
POST   /workspaces
GET    /workspaces/:id
```

**Testing:**
- [ ] E2E test: Create account → Create form → Add 5 fields → Preview
- [ ] Test auth endpoints with Hoppscotch/Insomnia
- [ ] Verify JWT tokens work correctly

**Deliverable:** Working form designer with auth powered by Cloudflare Workers

---

## Week 2: Form Management & Persistence (Nov 25-Dec 1)

### Form CRUD Operations (Hono API)
- [ ] Forms API endpoints
  - [ ] POST `/forms` - Create form
  - [ ] GET `/forms` - List all forms (paginated)
  - [ ] GET `/forms/:id` - Get single form
  - [ ] PUT `/forms/:id` - Update form
  - [ ] DELETE `/forms/:id` - Delete form
  - [ ] POST `/forms/:id/duplicate` - Duplicate form
  - [ ] PATCH `/forms/:id/status` - Toggle draft/published
- [ ] Auto-save implementation
  - [ ] Client debounces saves (30 seconds)
  - [ ] Manual save button with keyboard shortcut (Ctrl+S)
  - [ ] Save status indicator ("Saving...", "Saved", "Error")
- [ ] Form list with D1 queries
  - [ ] Pagination (20 forms per page)
  - [ ] Filter by status (draft/published)
  - [ ] Search by name (LIKE query)
  - [ ] Sort by created_at, name, submissions_count
- [ ] D1 prepared statements for performance
- [ ] Query optimization with indexes

### Form Validation
- [x] Required field validation
- [x] Min/max length validation
- [ ] Pattern matching (regex)
  - [ ] Email validation
  - [ ] Phone number validation
  - [ ] URL validation
- [ ] Custom error messages per validation rule
- [ ] Real-time validation in preview
- [ ] Server-side validation in Hono endpoints

### Caching Strategy
- [ ] Cache form schemas in KV (10 min TTL)
- [ ] Cache-Control headers on GET endpoints
- [ ] Invalidate cache on form updates

### UI Polish
- [ ] Loading states for all async operations
- [ ] Error handling with toast notifications
- [ ] Empty states ("No forms yet")
- [ ] Skeleton loaders
- [ ] Optimistic UI updates

**API Endpoints:**
```
POST   /forms
GET    /forms?page=1&search=&sort=created_at
GET    /forms/:id
PUT    /forms/:id
DELETE /forms/:id
POST   /forms/:id/duplicate
PATCH  /forms/:id/status
```

**Testing:**
- [ ] Create 10 forms via API
- [ ] Verify auto-save with network throttling
- [ ] Test delete and list pagination
- [ ] Load test: 100 concurrent form creates

**Deliverable:** Forms persist in D1 and can be managed via Hono API

---

## Week 3: Submission Collection & Embedding (Dec 2-8)

### Form Renderer (Public View)
- [ ] Public form endpoint: GET `/f/:formId`
  - [ ] Fetch form schema from D1/KV cache
  - [ ] Return HTML or JSON based on Accept header
  - [ ] Handle form not found (404)
  - [ ] Track form views in D1
- [ ] Static HTML form rendering (optional)
- [ ] Client-side validation
- [ ] Submit form: POST `/f/:formId/submit`
  - [ ] Validate submission against form schema
  - [ ] Store in D1 `submissions` table
  - [ ] Return success/error response
  - [ ] Rate limiting (10 submissions/min per IP)
- [ ] Success/error messages
- [ ] Redirect after submission (optional)
- [ ] Pre-fill fields from URL params

### Submission Storage
- [ ] D1 submissions table
  - [ ] Store submission data as JSON
  - [ ] Capture metadata (IP, user agent, timestamp)
  - [ ] Index on form_id and created_at
- [ ] Handle large text fields (10,000+ chars)
- [ ] Compress large submissions with gzip

### Submission Management API
- [ ] GET `/forms/:id/submissions`
  - [ ] Paginated results (50 per page)
  - [ ] Filter by date range
  - [ ] Search submissions (JSON search)
  - [ ] Sort by submitted_at
- [ ] GET `/forms/:id/submissions/:submissionId`
- [ ] DELETE `/forms/:id/submissions/:submissionId`
- [ ] GET `/forms/:id/submissions/export?format=csv`
- [ ] GET `/forms/:id/submissions/export?format=json`

### Export Functionality
- [ ] CSV export using Workers Streams API
- [ ] JSON export (gzipped for large datasets)
- [ ] Generate download URLs with signed tokens
- [ ] Expire download links after 1 hour

### iframe Embedding
- [ ] Generate embeddable iframe code
- [ ] Copy to clipboard button
- [ ] iframe URL: `https://forms.your-domain.com/f/:formId`
- [ ] Query params:
  - [ ] `theme` (light/dark/auto)
  - [ ] `hideHeader` (true/false)
  - [ ] `hideFooter` (true/false)
  - [ ] `primaryColor` (hex)
- [ ] Auto-resize iframe script (postMessage)
- [ ] CORS headers for cross-origin embeds
- [ ] CSP headers for security

**API Endpoints:**
```
GET    /f/:formId (public form page)
POST   /f/:formId/submit (public submission)
GET    /forms/:id/submissions
GET    /forms/:id/submissions/:submissionId
DELETE /forms/:id/submissions/:submissionId
GET    /forms/:id/submissions/export
```

**Cloudflare Features Used:**
- [ ] Workers Analytics for form views
- [ ] Rate Limiting API for submission throttling
- [ ] R2 Storage for large file exports (optional)

**Testing:**
- [ ] Submit form 50 times
- [ ] Export 1000 submissions as CSV
- [ ] Embed form in test website (CORS test)
- [ ] Verify rate limiting works

**Deliverable:** Forms are embeddable and collect data via Cloudflare Workers

---

## Week 4: JavaScript SDK & Launch Prep (Dec 9-15)

### JavaScript SDK (Vanilla)
- [ ] Build SDK library
- [ ] API client for Hono backend
  - [ ] `FormWeaver.render(config)`
  - [ ] Fetch form schema: GET `/f/:formId`
  - [ ] Submit form: POST `/f/:formId/submit`
- [ ] Configuration options:
  - [ ] `formId`, `container`, `apiKey`
  - [ ] `theme`, `primaryColor`
  - [ ] `onSubmit`, `onError`, `onLoad` callbacks
- [ ] Programmatic methods:
  - [ ] `getValues()`, `setValues()`, `reset()`
  - [ ] `validate()`, `submit()`
- [ ] Build with esbuild (minified <10 KB gzipped)
- [ ] Host on Cloudflare Workers (serve via CDN)
- [ ] NPM package

### API Documentation
- [ ] API reference site (hosted on Workers)
  - [ ] GET `/forms/:id` - Fetch form schema
  - [ ] POST `/f/:formId/submit` - Submit form data
  - [ ] GET `/submissions` - List submissions
  - [ ] Authentication guide (Bearer tokens)
- [ ] Code examples (curl, JavaScript, Python)
- [ ] Rate limits documentation
- [ ] OpenAPI spec generation

### Marketing Site (Workers Static Site)
- [ ] Landing page (HTML/CSS hosted on Workers)
  - [ ] Hero section with live demo embed
  - [ ] Features section (3 key benefits)
  - [ ] Pricing table
  - [ ] CTA buttons ("Start Free")
- [ ] Documentation site
  - [ ] Getting Started guide
  - [ ] Embedding Guide
  - [ ] API Reference (generated from OpenAPI)
  - [ ] FAQ
- [ ] Blog (launch announcement post)
- [ ] Host on Workers Sites or Pages

### Billing Integration
- [ ] Stripe Webhook handler in Workers
  - [ ] POST `/webhooks/stripe`
  - [ ] Verify webhook signatures
  - [ ] Handle checkout.session.completed
  - [ ] Handle customer.subscription.updated
  - [ ] Handle invoice.payment_failed
- [ ] Store subscription data in D1
- [ ] Plan selection on signup
- [ ] Upgrade/downgrade flow
- [ ] Usage tracking (submissions, storage) in D1
- [ ] Billing page API:
  - [ ] GET `/billing/subscription`
  - [ ] POST `/billing/create-checkout-session`
  - [ ] POST `/billing/create-portal-session`

### Monitoring & Analytics
- [ ] Workers Analytics (built-in)
- [ ] Custom metrics with Durable Objects (optional)
- [ ] Error tracking with Sentry (or Cloudflare's built-in)
- [ ] Set up Cloudflare Web Analytics

### Polish & QA
- [ ] Responsive design (mobile/tablet)
- [ ] Dark mode support
- [ ] Accessibility audit (keyboard nav, screen readers)
- [ ] Performance optimization
  - [ ] Use Workers Cache API
  - [ ] Optimize D1 queries (prepared statements)
  - [ ] Edge caching for static assets
- [ ] Security audit
  - [ ] SQL injection prevention (prepared statements)
  - [ ] XSS protection (sanitize inputs)
  - [ ] CSRF tokens for forms
  - [ ] Rate limiting on all endpoints
- [ ] Browser testing (Chrome, Firefox, Safari, Edge)

**API Endpoints:**
```
POST   /webhooks/stripe
GET    /billing/subscription
POST   /billing/create-checkout-session
POST   /billing/create-portal-session
GET    /sdk/FormWeaver.min.js (serve SDK)
```

**Testing:**
- [ ] Full user journey test (signup → create → embed → submit)
- [ ] Load testing (100 concurrent submissions)
- [ ] Test Workers performance (p99 latency <50ms)
- [ ] Security penetration test

**Deliverable:** MVP launched to Cloudflare Workers

---

## Cloudflare Architecture

```
┌─────────────────────────────────────────────┐
│         Cloudflare Global Network           │
├─────────────────────────────────────────────┤
│  Workers (Hono API) - 300+ Edge Locations  │
│  ├── Authentication (/auth/*)               │
│  ├── Forms API (/forms/*)                   │
│  ├── Submissions API (/f/*)                 │
│  ├── Billing Webhooks (/webhooks/*)         │
│  └── SDK Hosting (/sdk/*)                   │
├─────────────────────────────────────────────┤
│  D1 Database (SQLite at Edge)               │
│  ├── users, workspaces, forms, submissions  │
│  └── Auto-replicated globally               │
├─────────────────────────────────────────────┤
│  KV Storage (Low-latency Key-Value)         │
│  ├── Session tokens                         │
│  ├── Email verification tokens              │
│  └── Form schema cache                      │
├─────────────────────────────────────────────┤
│  R2 Storage (Optional - for large files)    │
│  └── CSV/JSON exports                       │
├─────────────────────────────────────────────┤
│  Workers Analytics (Built-in)               │
│  ├── Request metrics                        │
│  ├── Error tracking                         │
│  └── Custom events                          │
└─────────────────────────────────────────────┘
```

---

## Launch Day Checklist (Dec 16)

### Pre-Launch (1 Week Before)
- [ ] Set up Cloudflare Analytics
- [ ] Configure custom domain on Cloudflare
- [ ] Set up Workers monitoring (alerts)
- [ ] Create support email (support@FormWeaver.app)
- [ ] Write launch blog post (host on Workers)
- [ ] Prepare social media posts
- [ ] Email 20 beta testers for feedback
- [ ] Set up Plausible/Fathom (via Workers proxy)

### Launch Day
- [ ] Deploy to production Workers
  - [ ] `wrangler deploy --env production`
  - [ ] Verify D1 migrations ran
  - [ ] Test all API endpoints
- [ ] Post on Product Hunt
- [ ] Post on Hacker News (Show HN)
- [ ] Post on Reddit (r/SideProject, r/Entrepreneur)
- [ ] Tweet launch announcement
- [ ] Post in Discord/Slack communities
- [ ] Email waitlist (if any)

### Post-Launch (First Week)
- [ ] Monitor Workers Analytics dashboard
- [ ] Monitor error rates (target: <0.1%)
- [ ] Respond to user feedback within 4 hours
- [ ] Fix critical bugs and redeploy (instant with Workers)
- [ ] Daily standup to review metrics
- [ ] Publish case study (first paying customer)

---

## MVP Feature Scope (What's IN)

✅ **Must Have:**
- User authentication (JWT with Workers)
- Form designer with 12 field types
- Drag-and-drop interface
- Form validation (required, min/max, regex)
- Save/load forms (D1 database)
- Form list with search (D1 queries)
- Public form page for submissions (Workers endpoint)
- Submission storage (D1) and viewing
- Export submissions (CSV, JSON via Workers Streams)
- iframe embedding (CORS configured)
- JavaScript SDK (vanilla, served from Workers)
- API for fetching forms and submitting data (Hono)
- Free and Pro pricing plans
- Stripe billing integration (Workers webhooks)

---

## MVP Feature Scope (What's OUT)

❌ **Post-MVP (v2.0):**
- Custom elements plugin system
- Conditional logic (show/hide fields)
- Multi-step forms
- File uploads (R2 storage)
- React/Vue SDKs
- Webhooks (Workers can send to user URLs)
- White-label options
- Team collaboration
- Custom CSS injection
- A/B testing
- Advanced analytics (Durable Objects)
- Zapier integration
- SSO/SAML

---

## Success Metrics (Week 4)

| Metric | Target | Actual |
|--------|--------|--------|
| **Signups** | 100 | TBD |
| **Forms created** | 50 | TBD |
| **Submissions** | 500 | TBD |
| **Paying customers** | 10 | TBD |
| **Conversion rate** | 10% | TBD |
| **MRR** | $290 | TBD |
| **Churn** | <10% | TBD |
| **Uptime** | 99.99%+ | TBD |
| **API latency (p99)** | <50ms | TBD |
| **Edge cache hit rate** | >80% | TBD |

---

## Cloudflare Advantages

✅ **Why Cloudflare Workers + Hono:**
- **Global edge deployment**: <50ms latency worldwide
- **Auto-scaling**: Handle traffic spikes without config
- **No cold starts**: Workers are instant
- **Cost-effective**: 100k requests/day free tier
- **Built-in DDoS protection**: Enterprise-grade security
- **D1 Database**: SQLite at the edge, globally replicated
- **KV Storage**: Low-latency key-value cache
- **Workers Analytics**: Built-in monitoring
- **Hono framework**: Fast, lightweight, TypeScript-first

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Scope creep** | Miss launch date | Use feature flags in Workers |
| **Security vulnerability** | Data breach | SQL injection protection, rate limiting |
| **Performance issues** | Poor UX | Use Workers Cache API, optimize D1 queries |
| **Low signups** | No revenue | Prep launch on 3+ channels |
| **Critical bug** | User churn | Instant rollback with `wrangler rollback` |
| **D1 limitations** | Scale issues | Plan migration to R2 + Durable Objects |

---

## Daily Standups (15 min)

**Format:**
1. What did you ship yesterday?
2. What will you ship today?
3. Any blockers?

**Metrics to Review:**
- Signups today (from Workers Analytics)
- Forms created today (D1 query)
- Submissions today (D1 query)
- Workers error rate
- API latency (p50, p99)

---

## Weekly Review (Friday 4pm)

**Agenda:**
1. Review week's goals vs actual
2. Demo new features
3. User feedback discussion
4. Review Workers Analytics dashboard
5. Plan next week's priorities
6. Celebrate wins 🎉

---

## Post-MVP (v2.0) Preview

**Week 5-8 Focus:**
- File uploads with R2 Storage
- Custom elements plugin system
- Conditional logic (complex D1 queries)
- React SDK
- Webhooks (Workers send POST to user URLs)

**Week 9-12 Focus:**
- Multi-step forms
- White-label options (custom domains)
- Advanced analytics (Durable Objects)
- Zapier integration (webhook receiver)
- Team collaboration (real-time with Durable Objects)

---

## Tech Stack Summary

| Component | Technology |
|-----------|-----------|
| **Backend API** | Cloudflare Workers + Hono |
| **Database** | D1 (SQLite at edge) |
| **Cache** | Workers KV |
| **File Storage** | R2 (post-MVP) |
| **Authentication** | JWT + KV (sessions) |
| **Payments** | Stripe (webhooks in Workers) |
| **Hosting** | Workers Sites / Pages |
| **CDN** | Cloudflare CDN (built-in) |
| **Analytics** | Workers Analytics |
| **Monitoring** | Sentry / Cloudflare Logs |

---

## Resources

**Wrangler CLI:** `npm install -g wrangler`  
**Hono Docs:** https://hono.dev  
**D1 Docs:** https://developers.cloudflare.com/d1  
**Project Board:** GitHub Projects  
**Roadmap:** Public roadmap.FormWeaver.app  
**Slack:** #engineering channel  
**Meetings:** Daily standup at 10am, Weekly review Friday 4pm  

---

**Next Step:** Initialize Wrangler project and set up Hono! 🚀

```bash
npm create cloudflare@latest my-formweaver
cd my-formweaver
npm install hono
wrangler d1 create formweaver-db
wrangler dev
```
