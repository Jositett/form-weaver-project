# FormWeaver

A powerful, embeddable form builder built on Cloudflare's global edge network.

## 🚀 Quick Start

### Prerequisites
- Node.js >= 18
- npm >= 9
- Git

### Setup
\\\ash
# Clone and setup (automated)
./setup.ps1

# Or manual setup:
git clone <repo-url>
cd formweaver

# Setup frontend
cd frontend
npm install
npm run dev

# Setup backend (in new terminal)
cd backend
npm install
npm run d1:migrate
npm run dev
\\\

## 📁 Project Structure

\\\
formweaver/
├── frontend/          # React + Vite frontend
├── backend/           # Cloudflare Workers + Hono API
├── shared/            # Shared TypeScript types
├── docs/              # Documentation
└── README.md
\\\

## 🛠️ Tech Stack

### Frontend
- React 18 + TypeScript
- Vite
- Tailwind CSS
- shadcn/ui components
- TanStack Query

### Backend
- Cloudflare Workers
- Hono framework
- D1 Database (SQLite)
- Workers KV
- R2 Storage

## 📚 Documentation

- [MVP Roadmap](docs/MVP_ROADMAP.md)
- [Development Rules](docs/DEV_RULES.md)
- [Product Requirements](docs/PRD.md)
- [Pricing Strategy](docs/PRICING.md)
- [Embedding Guide](docs/EMBEDDING.md)
- [Backend API](docs/BACKEND.md)
- [Branding Guidelines](docs/BRANDING.md)

## 🌐 Development URLs

- Frontend: http://localhost:5173
- Backend API: http://localhost:8787

## 🚢 Deployment

### Frontend (Cloudflare Pages)
\\\ash
cd frontend
npm run build
wrangler pages deploy dist
\\\

### Backend (Cloudflare Workers)
\\\ash
cd backend
npm run deploy
\\\

## 📝 License

MIT

## 🤝 Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md)
