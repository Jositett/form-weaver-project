# FormWeaver

A powerful, embeddable form builder built on Cloudflare's global edge network. Create beautiful forms with drag-and-drop, collect responses, and embed them anywhere with <50ms latency worldwide.

## 🚀 Quick Start

### Prerequisites

- **Node.js** >= 18.x
- **npm** >= 9.x (or **bun** >= 1.0)
- **Git**
- **Cloudflare account** (for deployment)

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd formweaver

# Install dependencies (root level - optional, for shared types)
npm install

# Setup frontend
cd frontend
npm install
npm run dev

# Setup backend (in a new terminal)
cd backend
npm install
npm run d1:migrate
npm run dev
```

### Development URLs

- **Frontend:** <http://localhost:8080> (or <http://localhost:5173>)
- **Backend API:** <http://localhost:8787>

## 📁 Project Structure

```
formweaver/
├── frontend/              # React + Vite frontend application
│   ├── src/
│   │   ├── components/    # React components
│   │   │   ├── formweaver/ # Form builder components
│   │   │   └── ui/        # shadcn/ui components
│   │   ├── pages/         # Route pages
│   │   ├── hooks/         # Custom React hooks
│   │   ├── types/         # TypeScript type definitions
│   │   └── lib/           # Utility functions
│   ├── public/            # Static assets
│   └── package.json
│
├── backend/               # Cloudflare Workers + Hono API
│   ├── src/
│   │   ├── index.ts       # Main application entry
│   │   ├── routes/        # API route handlers
│   │   ├── middleware/    # Hono middleware
│   │   ├── db/            # Database schema and migrations
│   │   ├── types/         # TypeScript types
│   │   └── utils/         # Utility functions
│   ├── wrangler.toml      # Cloudflare Workers configuration
│   └── package.json
│
├── shared/                 # Shared TypeScript types
│   └── types/
│       └── index.ts
│
├── docs/                   # Project documentation
│   ├── PRD.md             # Product Requirements Document
│   ├── DEV_RULES.md       # Development rules and standards
│   ├── BACKEND.md         # Backend API documentation
│   ├── EMBEDDING_GUIDE.md # Embedding integration guide
│   ├── MVP_ROADMAP.md     # MVP feature roadmap
│   ├── PRICING.md         # Pricing strategy
│   ├── PROGRESS_CHECKLIST.md  # Overall progress tracking
│   ├── FRONTEND_CHECKLIST.md  # Frontend implementation checklist
│   └── BACKEND_CHECKLIST.md   # Backend implementation checklist
│
├── PROJECT_RULES.md        # Project-specific rules and conventions
└── README.md              # This file
```

## 🛠️ Tech Stack

### Frontend

- **React 18** + **TypeScript** - UI framework
- **Vite** - Build tool and dev server
- **Tailwind CSS** - Utility-first CSS framework
- **shadcn/ui** - High-quality component library
- **React Router** - Client-side routing
- **TanStack Query** - Server state management
- **React Hook Form** + **Zod** - Form handling and validation

### Backend

- **Cloudflare Workers** - Serverless edge compute
- **Hono** - Fast, lightweight web framework
- **D1 Database** - SQLite at the edge (globally replicated)
- **Workers KV** - Low-latency key-value storage
- **R2 Storage** - S3-compatible object storage (for file uploads)
- **TypeScript** - Type-safe development

## 🚢 Deployment

### Frontend (Cloudflare Pages)

```bash
cd frontend
npm run build
wrangler pages deploy dist
```

Or connect your GitHub repository to Cloudflare Pages for automatic deployments.

### Backend (Cloudflare Workers)

```bash
cd backend
npm run deploy
```

### Database Setup

```bash
# Create D1 database (first time only)
cd backend
npm run d1:create

# Run migrations (local)
npm run d1:migrate

# Run migrations (production)
npm run d1:migrate:prod
```

### Environment Variables

Set secrets using Wrangler CLI:

```bash
cd backend
wrangler secret put JWT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put STRIPE_WEBHOOK_SECRET
```

## 📚 Documentation

### Getting Started

- [Frontend README](frontend/README.md) - Frontend setup and development guide
- [Backend README](backend/README.md) - Backend API and setup guide

### Project Rules & Standards

- [Project Rules](PROJECT_RULES.md) - **Project-specific rules and conventions** (start here!)
- [Development Rules](docs/DEV_RULES.md) - Detailed code standards and best practices

### Implementation Checklists

- [Overall Progress](docs/PROGRESS_CHECKLIST.md) - **Track overall project progress**
- [Frontend Checklist](docs/FRONTEND_CHECKLIST.md) - Frontend feature implementation status
- [Backend Checklist](docs/BACKEND_CHECKLIST.md) - Backend API implementation status
- [How to Continue Work](docs/HOW_TO_CONTINUE_WORK.md) - **Guide for continuing work in new chat sessions**

### Project Documentation

- [Product Requirements Document](docs/PRD.md) - Complete product specification
- [Backend API Documentation](docs/BACKEND.md) - API endpoints and architecture
- [Embedding Guide](docs/EMBEDDING_GUIDE.md) - How to embed forms in your app
- [MVP Roadmap](docs/MVP_ROADMAP.md) - Feature roadmap and milestones
- [Pricing Strategy](docs/PRICING.md) - Pricing tiers and monetization

## 🏗️ Architecture

### Frontend Architecture

- **Component-based** - Reusable React components
- **Type-safe** - Full TypeScript coverage
- **State management** - TanStack Query for server state, React Context for app state
- **Form builder** - Drag-and-drop interface with real-time preview
- **Responsive design** - Mobile-first approach with Tailwind CSS

### Backend Architecture

- **Edge-first** - All requests served from Cloudflare's global network
- **Serverless** - Cloudflare Workers for zero cold starts
- **Database** - D1 (SQLite) with global replication
- **Caching** - Workers KV for low-latency caching
- **Multi-tenant** - Workspace-based isolation

### Data Flow

1. User creates form in frontend → Saved to D1 via Workers API
2. Form published → Schema cached in Workers KV
3. User submits form → Stored in D1, webhook triggered
4. Submissions viewed → Fetched from D1 with pagination

## 🔐 Security

- **Authentication** - JWT tokens with refresh tokens
- **Authorization** - Role-based access control (RBAC)
- **Input validation** - Zod schemas on client and server
- **SQL injection prevention** - D1 prepared statements only
- **Rate limiting** - IP-based and user-based limits
- **CORS** - Configurable allowed origins
- **HTTPS** - Automatic TLS via Cloudflare

## 🧪 Testing

```bash
# Frontend tests
cd frontend
npm run test

# Backend tests
cd backend
npm run test

# Type checking
cd frontend && npm run type-check
cd backend && npm run type-check
```

## 📝 Contributing

1. Read [Development Rules](docs/DEV_RULES.md)
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and type checks
5. Commit using conventional commits (`feat:`, `fix:`, `docs:`, etc.)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style

- TypeScript strict mode enabled
- ESLint + Prettier for code formatting
- Follow [DEV_RULES.md](docs/DEV_RULES.md) for detailed standards

## 🐛 Troubleshooting

### Frontend Issues

- **Port already in use**: Change port in `vite.config.ts` or kill process using port
- **Module not found**: Run `npm install` in `frontend/` directory
- **Type errors**: Run `npm run type-check` to see detailed errors

### Backend Issues

- **D1 database not found**: Run `npm run d1:create` first
- **Migration errors**: Check `backend/src/db/migrations/` for SQL syntax
- **Wrangler errors**: Ensure you're logged in with `wrangler login`

### Common Solutions

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Reset D1 database (local only)
cd backend
wrangler d1 execute formweaver-dev --command "DELETE FROM forms"
wrangler d1 execute formweaver-dev --command "DELETE FROM submissions"

# View logs
cd backend
npm run tail
```

## 📊 Performance

### Frontend

- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Bundle Size**: < 200 KB (gzipped)

### Backend

- **API Latency (p50)**: < 50ms globally
- **API Latency (p99)**: < 200ms globally
- **D1 Query Time**: < 10ms
- **Uptime**: 99.99%+ (Cloudflare SLA)

## 🗺️ Roadmap

See [MVP_ROADMAP.md](docs/MVP_ROADMAP.md) for detailed feature roadmap.

### Current Phase: MVP (v1.0)

- ✅ Drag-and-drop form builder
- ✅ Standard field types
- ✅ Form preview
- ✅ Form persistence
- 🔄 Form submissions (in progress)
- 🔄 Authentication (in progress)
- ⏳ Embedding SDKs (planned)

### Next Phase: v2.0

- Custom elements system
- Advanced form logic
- Theme editor
- Webhook integrations

## 📄 License

MIT License - see LICENSE file for details

## 🤝 Support

- **Documentation**: [docs/](docs/)
- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Email**: <support@formweaver.app> (when available)

## 🙏 Acknowledgments

- Built with [Cloudflare Workers](https://workers.cloudflare.com/)
- UI components from [shadcn/ui](https://ui.shadcn.com/)
- Form handling with [React Hook Form](https://react-hook-form.com/)

---

**Version:** 1.0.0  
**Last Updated:** 2025-01-16  
**Status:** In Active Development
