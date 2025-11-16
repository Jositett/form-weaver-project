# FormWeaver - Post-Setup Guide

## Issues Found & Fixes

### 1. ✅ Zod Version Conflict (FIXED)

**Problem:** The `@hono/zod-validator` package requires a specific zod version that conflicts with the one Wrangler uses.

**Solution:** Run the fix script:

```powershell
# From project root (C:\Self_Projects\formweaver)
.\fix-dependencies.ps1
```

Or manually:
```powershell
cd backend
npm uninstall zod @hono/zod-validator
npm install zod@^3.23.8
npm install @hono/zod-validator
cd ..
```

### 2. ⚠️ Frontend Git Repository (ACTION NEEDED)

**Problem:** The frontend was cloned as a separate git repository inside your main repo. This creates an "embedded repository" which git doesn't handle well.

**You have two options:**

#### Option A: Convert to Submodule (Recommended if you want to sync with original repo)

```powershell
.\fix-git-submodule.ps1
# Choose option 1
```

This keeps the frontend connected to the original GitHub repo, allowing you to pull updates.

#### Option B: Integrate into Monorepo (Recommended if you want independent control)

```powershell
.\fix-git-submodule.ps1
# Choose option 2
```

This removes the frontend's `.git` folder and makes it part of your main repository.

**I recommend Option B** for this project since you'll be customizing the frontend heavily.

---

## Quick Start Commands

### 1. Fix Dependencies & Git
```powershell
# From C:\Self_Projects\formweaver
.\fix-dependencies.ps1
.\fix-git-submodule.ps1  # Choose option 2
```

### 2. Initialize D1 Database
```powershell
cd backend
npm run d1:create
npm run d1:migrate
cd ..
```

Expected output:
```
✅ Successfully created DB 'formweaver-dev'
✅ Successfully applied 1 migration
```

### 3. Set JWT Secret
```powershell
cd backend
wrangler secret put JWT_SECRET
# When prompted, enter a strong secret (e.g., generate one online or use: openssl rand -base64 32)
cd ..
```

### 4. Start Development Servers

**Terminal 1 - Frontend:**
```powershell
cd frontend
npm run dev
```
Open: http://localhost:5173

**Terminal 2 - Backend:**
```powershell
cd backend
npm run dev
```
Open: http://localhost:8787

---

## Verify Everything Works

### 1. Test Backend API
Open http://localhost:8787 in your browser. You should see:
```json
{
  "status": "ok",
  "message": "FormWeaver API - Cloudflare Workers + Hono",
  "version": "1.0.0",
  "environment": "development"
}
```

### 2. Test Health Endpoint
Open http://localhost:8787/api/health
```json
{
  "status": "healthy",
  "timestamp": "2025-11-16T20:45:00.000Z"
}
```

### 3. Test D1 Database
```powershell
cd backend
npm run d1:query "SELECT name FROM sqlite_master WHERE type='table'"
```

You should see tables: `users`, `workspaces`, `forms`, `submissions`, etc.

---

## Project Structure

```
C:\Self_Projects\formweaver/
├── frontend/              # React + Vite
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
│
├── backend/               # Cloudflare Workers + Hono
│   ├── src/
│   │   ├── index.ts      # Main entry
│   │   ├── routes/       # API routes (to be created)
│   │   ├── middleware/   # Auth, CORS, etc.
│   │   ├── db/
│   │   │   └── schema.sql
│   │   ├── types/
│   │   └── utils/
│   ├── wrangler.toml
│   ├── package.json
│   └── tsconfig.json
│
├── shared/                # Shared TypeScript types
│   └── types/
│       └── index.ts
│
├── docs/                  # Documentation
│   ├── MVP_ROADMAP.md
│   ├── DEV_RULES.md
│   ├── PRD.md
│   ├── PRICING.md
│   ├── EMBEDDING_GUIDE.md
│   └── BACKEND.md
│
├── README.md
├── SETUP_INFO.txt
└── .gitignore
```

---

## Common Issues & Solutions

### Issue: "npm run dev" fails in backend

**Solution:**
```powershell
cd backend
npm install --legacy-peer-deps
npm run dev
```

### Issue: "wrangler: command not found"

**Solution:**
```powershell
npm install -g wrangler
# Or use npx:
npx wrangler dev
```

### Issue: D1 database not found

**Solution:**
```powershell
cd backend
npm run d1:create
npm run d1:migrate
```

### Issue: Frontend shows "Failed to fetch"

**Cause:** Backend not running or wrong API URL

**Solution:**
1. Make sure backend is running on port 8787
2. Check `frontend/.env`:
   ```
   VITE_API_URL=http://localhost:8787/api
   ```
3. Restart frontend dev server

### Issue: CORS errors in browser console

**Solution:** The backend already has CORS middleware configured for localhost. Make sure:
- Backend is running
- Frontend is on http://localhost:5173 (not 127.0.0.1)

---

## Next Development Steps

### Week 1: Authentication
1. Create `backend/src/routes/auth.ts`
2. Implement signup, login, verify-email
3. Test with Postman/Thunder Client
4. Create login page in frontend

### Week 2: Forms CRUD
1. Create `backend/src/routes/forms.ts`
2. Implement create, read, update, delete
3. Connect frontend form builder to API
4. Test save/load forms

### Week 3: Submissions
1. Create `backend/src/routes/submissions.ts`
2. Implement public form submission
3. Create submissions viewer in frontend
4. Add CSV export

### Week 4: Polish & Launch
1. Add rate limiting
2. Implement webhooks
3. Create landing page
4. Deploy to production

---

## Useful Commands Reference

### Frontend
```powershell
cd frontend

npm run dev          # Start dev server (port 5173)
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
npm run type-check   # TypeScript check
```

### Backend
```powershell
cd backend

npm run dev              # Start Workers dev server (port 8787)
npm run deploy           # Deploy to Cloudflare
npm run tail             # View live logs
npm run tail --format=pretty  # Pretty logs
npm run type-check       # TypeScript check

# D1 Database
npm run d1:create        # Create database
npm run d1:migrate       # Apply migrations (local)
npm run d1:migrate:prod  # Apply migrations (production)
npm run d1:query "SELECT * FROM users"  # Run SQL query
npm run d1:list          # List all databases

# Secrets
wrangler secret put JWT_SECRET
wrangler secret list
wrangler secret delete JWT_SECRET
```

### Git
```powershell
# From project root
git status
git add .
git commit -m "Your commit message"
git push

# If using frontend as submodule (Option A):
cd frontend
git pull origin main
cd ..
git add frontend
git commit -m "Update frontend submodule"
```

---

## Environment Variables

### Frontend (.env)
```bash
VITE_API_URL=http://localhost:8787/api
VITE_APP_URL=http://localhost:5173
```

### Backend (Wrangler Secrets)
```bash
# Set with: wrangler secret put SECRET_NAME
JWT_SECRET=your-super-secret-key-here
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

---

## Testing

### Test Backend API with curl
```powershell
# Health check
curl http://localhost:8787/api/health

# Test CORS
curl -X OPTIONS http://localhost:8787/api/forms -H "Origin: http://localhost:5173"
```

### Test Backend API with PowerShell
```powershell
# Health check
Invoke-RestMethod -Uri http://localhost:8787/api/health

# Test with headers
$headers = @{ "Content-Type" = "application/json" }
Invoke-RestMethod -Uri http://localhost:8787/api/health -Headers $headers
```

---

## Resources

- **Cloudflare Workers:** https://developers.cloudflare.com/workers/
- **Hono Framework:** https://hono.dev
- **D1 Database:** https://developers.cloudflare.com/d1/
- **Wrangler CLI:** https://developers.cloudflare.com/workers/wrangler/
- **React + Vite:** https://vitejs.dev/guide/

---

## Getting Help

1. **Documentation:** Check `/docs` folder
2. **Discord:** Join Cloudflare Discord
3. **GitHub Issues:** Report bugs on GitHub
4. **Stack Overflow:** Tag `cloudflare-workers` + `hono`

---

## Summary Checklist

After setup, you should have:

- [x] ✅ Project created at `C:\Self_Projects\formweaver`
- [ ] ⚠️ Dependencies fixed (run `fix-dependencies.ps1`)
- [ ] ⚠️ Git submodule issue resolved (run `fix-git-submodule.ps1`)
- [ ] ⏳ D1 database initialized (run `npm run d1:create`)
- [ ] ⏳ Database migrated (run `npm run d1:migrate`)
- [ ] ⏳ JWT secret set (run `wrangler secret put JWT_SECRET`)
- [ ] ⏳ Frontend running on http://localhost:5173
- [ ] ⏳ Backend running on http://localhost:8787

Once all checkboxes are marked, you're ready to start development! 🚀

---

**Last Updated:** 2025-11-16
**Version:** 1.0
