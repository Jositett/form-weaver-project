# Quick Start Prompts for New Chat Sessions

## 🎨 Frontend Development Prompt

```markdown
I'm working on the FormWeaver project. Continue frontend development in sprints.

**Your Task:**
1. Read docs/FRONTEND_CHECKLIST.md to understand pending tasks
2. Read docs/PROGRESS_CHECKLIST.md to see overall status
3. Read PROJECT_RULES.md for coding standards
4. Determine the highest priority pending feature from the checklist
5. Break it into a 2-3 hour sprint
6. Implement the first sprint task following project conventions
7. Run type checks, lint checks, and resolve all errors/warnings in the frontend codebase.
8. Update the checklist as you complete items

**Work Autonomously:**
- Use the checklist to determine what to do next
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the checklist
- Update checklists after completing work
- After completing the sprint, run: git -C frontend add . && git -C frontend commit -m "FEAT: [brief description]" && git -C frontend push
- Check backend/README.md for any new API endpoints or R2 storage capabilities

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/FRONTEND_CHECKLIST.md - Frontend task list (your primary guide)
- docs/PROGRESS_CHECKLIST.md - Overall progress
- docs/BACKEND_CHECKLIST.md - Backend status (check for API dependencies)
- frontend/README.md - Frontend architecture
- backend/README.md - Backend architecture (check for R2/file upload APIs)

Start working now. Determine the next task from the checklist and begin implementation.
```

---

## ⚙️ Backend Development Prompt

```markdown
I'm working on the FormWeaver project. Continue backend development in sprints.

**Your Task:**
1. Read docs/BACKEND_CHECKLIST.md to understand pending tasks
2. Read docs/PROGRESS_CHECKLIST.md to see overall status
3. Read PROJECT_R ULES.md for coding standards
4. Read backend/README.md - Note the new secrets/R2 setup sections
5. Determine the highest priority pending feature from the checklist
6. Break it into a 2-3 hour sprint
7. Implement the first sprint task following project conventions
8. Run type checks, lint checks, and resolve all errors/warnings in the backend codebase.
9. Update the checklist as you complete items

**Work Autonomously:**
- Use the checklist to determine what to do next
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the checklist
- Update checklists after completing work
- After completing the sprint, run: git -C backend add . && git -C backend commit -m "FEAT: [brief description]" && git -C backend push
- Check docs/FRONTEND_CHECKLIST.md for API requirements frontend needs
- Ensure type safety using the Bindings pattern in src/types/index.ts

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/BACKEND_CHECKLIST.md - Backend task list (your primary guide)
- docs/PROGRESS_CHECKLIST.md - Overall progress
- docs/FRONTEND_CHECKLIST.md - Frontend status (check for API dependencies)
- backend/README.md - Backend architecture (updated with secrets/R2 setup)

**Important:** The backend README now includes:
- `.dev.vars` setup for local secrets
- Detailed secrets management (JWT_SECRET, STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET)
- R2 bucket configuration
- Type-safe Bindings pattern

Start working now. Determine the next task from the checklist and begin implementation.
```

---

## 📊 Overall Project Development Prompt

```markdown
I'm working on the FormWeaver project. Continue development in sprints.

**Your Task:**
1. Read docs/PROGRESS_CHECKLIST.md to understand overall project status
2. Determine which component (Frontend/Backend) needs work based on progress
3. Read the appropriate checklist:
   - docs/FRONTEND_CHECKLIST.md for frontend work
   - docs/BACKEND_CHECKLIST.md for backend work
4. Read PROJECT_RULES.md for coding standards
5. Review backend/README.md for new R2 & secrets setup patterns
6. Determine the highest priority pending feature from the relevant checklist
7. Break it into a 2-3 hour sprint
8. Implement the first sprint task following project conventions
9. Update both the specific checklist and PROGRESS_CHECKLIST.md as you complete items
10. Run type checks, lint checks, and resolve all errors/warnings in the relevant codebase (Frontend or Backend).

**Work Autonomously:**
- Use PROGRESS_CHECKLIST.md to determine which component to work on
- Use the specific checklist (Frontend/Backend) to determine what to do
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the relevant checklist
- Update checklists after completing work
- After completing the sprint, run git commands to sync the relevant submodule (e.g., git -C frontend commit) or the main repository.
- Coordinate between frontend and backend when dependencies exist

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/PROGRESS_CHECKLIST.md - Overall project status (start here)
- docs/FRONTEND_CHECKLIST.md - Frontend task list
- docs/BACKEND_CHECKLIST.md - Backend task list
- frontend/README.md - Frontend architecture
- backend/README.md - Backend architecture (updated with R2/secrets)

**Important:** Recent updates to backend README include:
- Node.js >= 16.17.0 requirement
- `.dev.vars` setup workflow
- Production secrets setup
- R2 bucket storage configuration
- Type-safe environment Bindings

Start working now. Review the overall progress, determine which component needs work, then begin implementation.
```

---

## 🛒 Marketplace Development Prompt

```markdown
I'm working on the FormWeaver template marketplace. Continue marketplace development in sprints.

**Your Task:**
1. Read docs/BACKEND_CHECKLIST.md → "Template Marketplace Backend" section
2. Read docs/FRONTEND_CHECKLIST.md → "Creator Dashboard Frontend" section
3. Read docs/DEV_RULES.md → "Marketplace Development Standards" section
4. Read docs/IMPLEMENTATION_GUIDE.md → "Marketplace Implementation Patterns" section
5. Determine the highest priority marketplace feature from the checklists
6. Break it into a 2-3 hour sprint with clear deliverables
7. Implement following marketplace development standards:
   - Creator dashboard component architecture
   - Commission and payout system logic
   - Template review workflow integration
   - Student verification system
8. Run type checks, lint checks, and resolve all errors/warnings
9. Update both specific checklists and PROGRESS_CHECKLIST.md with marketplace progress

**Marketplace-Specific Requirements:**
- Implement 50-73% creator commission structure
- Add student verification with 30% discount system
- Include legal compliance for data retention (30-90 days)
- Add creator analytics and earnings tracking
- Implement template marketplace API endpoints

**Context Files:**
- docs/BACKEND_CHECKLIST.md - Template marketplace backend tasks
- docs/FRONTEND_CHECKLIST.md - Creator dashboard frontend tasks
- docs/DEV_RULES.md - Marketplace development standards
- docs/IMPLEMENTATION_GUIDE.md - Marketplace implementation patterns
- docs/POST_MVP_GUIDE.md - Complete marketplace strategy guide
```

---

## 👨‍🎓 Student Creator Experience Prompt

```markdown
I'm working on student creator experience features for FormWeaver. Continue student-focused development.

**Your Task:**
1. Read docs/FRONTEND_CHECKLIST.md → "Student Creator Experience" section
2. Read docs/DEV_RULES.md → "Student Creator Experience Guidelines" section
3. Read docs/IMPLEMENTATION_GUIDE.md → "Student Creator Implementation" section
4. Read docs/POST_MVP_GUIDE.md → "Student Employment Strategy" section
5. Implement student verification system with multiple methods
6. Add progressive onboarding flow for new student creators
7. Implement mentorship program matching and management
8. Add portfolio building features with analytics
9. Include educational resource integration
10. Run type checks, lint checks, and resolve all errors/warnings
11. Update student creator experience checklist items

**Student-Specific Requirements:**
- Low-barrier entry with simple verification
- Educational discounts (30% off) for verified students
- Mentorship program with algorithmic matching
- Portfolio building with performance analytics
- Skill development tracking and gamification
```

---

## ⚖️ Legal Compliance Development Prompt

```markdown
I'm working on legal compliance implementation for FormWeaver marketplace. Continue compliance development.

**Your Task:**
1. Read docs/DEV_RULES.md → "Legal Compliance Development Requirements" section
2. Read docs/IMPLEMENTATION_GUIDE.md → "Legal Compliance Implementation" section
3. Read docs/POST_MVP_GUIDE.md → "Legal Compliance Framework" section
4. Implement data retention system with 30-90 day TTL
5. Add automatic deletion with legal hold support
6. Implement GDPR compliance features:
   - Right to erasure (30-day processing)
   - Data portability export
   - Consent management
7. Add industry-specific compliance (HIPAA, SOX)
8. Implement audit logging and compliance dashboard
9. Run type checks, lint checks, and resolve all errors/warnings
10. Update legal compliance checklist items

**Compliance-Specific Requirements:**
- Automatic data deletion with configurable retention periods
- Legal hold system for litigation scenarios
- GDPR compliance with user rights implementation
- Industry-specific requirements for healthcare/financial forms
- Comprehensive audit trails and compliance monitoring
```

---

## 📊 Creator Dashboard Development Prompt

```markdown
I'm working on the creator dashboard for FormWeaver marketplace. Continue dashboard development.

**Your Task:**
1. Read docs/FRONTEND_CHECKLIST.md → "Creator Dashboard" section
2. Read docs/BACKEND_CHECKLIST.md → "Creator Management API" section
3. Read docs/DEV_RULES.md → "Creator Experience Standards" section
4. Implement creator analytics with real-time data
5. Add earnings tracking with multi-revenue streams
6. Implement template management with versioning
7. Add review and rating system with fraud detection
8. Include creator community features
9. Run type checks, lint checks, and resolve all errors/warnings
10. Update creator dashboard checklist items

**Dashboard-Specific Requirements:**
- Real-time analytics with caching strategies
- Earnings tracking with commission calculations
- Template management with approval workflows
- Creator community with collaboration tools
- Mobile-responsive design for all creator features
```

---

## 🛠️ Utility Prompts

These prompts are for specific, non-sprint tasks like code quality checks or project synchronization.

### Run Code Quality Checks

```markdown
Run type checks, lint checks, and resolve all errors/warnings in the [Frontend/Backend] codebase.
```

### Sync Git Submodules

```markdown
git -C [frontend/backend] add . && git -C [frontend/backend] commit -m "FEAT: [brief description]" && git -C [frontend/backend] push
```

### Sync Main Repository

```markdown
After completing the sprint, run git commands to sync the main repository.
```

## 🎯 For Specific Issues

If you need to address a specific issue or work on a particular feature, add to any of the above prompts:

```markdown
**Specific Focus:** [Feature name or issue description]
**Priority:** [high/medium/low]
**Estimated Time:** [2-3 hours]
```

Examples:

```markdown
**Specific Focus:** Fix the conditional logic evaluation bug in FormRenderer
**Specific Focus:** Implement the authentication signup endpoint with JWT
**Specific Focus:** Add file upload field component with R2 storage integration
**Specific Focus:** Set up R2 storage for form file uploads
**Specific Focus:** Update Node.js version references from 18.x to 16.17.0
```

Otherwise, the agent will autonomously follow the checklist priority order.

---

## 📚 Context Files

### **Core Documentation**

- **PROJECT_RULES.md** - Coding standards and architecture (primary guide)
- **docs/PROGRESS_CHECKLIST.md** - Overall project status and sprint tracking
- **docs/BACKEND_CHECKLIST.md** - Backend development tasks and requirements
- **docs/FRONTEND_CHECKLIST.md** - Frontend development tasks and requirements
- **docs/DEV_RULES.md** - Development standards and best practices
- **docs/IMPLEMENTATION_GUIDE.md** - Implementation patterns and technical guidance

### **Marketplace & Strategy Documentation**

- **docs/POST_MVP_GUIDE.md** - Complete marketplace strategy and legal compliance framework
- **docs/PRICING.md** - Pricing strategy and template categorization
- **docs/BACKEND.md** - Backend architecture and API documentation
- **docs/QUALITY_ASSURANCE.md** - Quality standards and testing procedures

### **Setup & Configuration**

- **frontend/README.md** - Frontend architecture and development setup
- **backend/README.md** - Backend architecture, R2 setup, and secrets management
- **docs/ENVIRONMENT_SETUP.md** - Development environment configuration
- **docs/TESTING.md** - Testing strategies and procedures

### **Additional Resources**

- **docs/HOW_TO_CONTINUE_WORK.md** - Detailed sprint-based development instructions
- **docs/SPRINT_SUMMARY_2025-11-22.md** - Recent sprint accomplishments and learnings
- **docs/WRANGLER_GUIDE.md** - Cloudflare Workers configuration and deployment
- **docs/CACHE_STRATEGY.md** - Caching strategies and KV optimization plans

**Note:** For marketplace development, prioritize reading POST_MVP_GUIDE.md first to understand the comprehensive strategy before diving into implementation checklists.

---

**See [HOW_TO_CONTINUE_WORK.md](HOW_TO_CONTINUE_WORK.md) for more detailed instructions on sprint-based development.**
