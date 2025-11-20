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
- After completing the sprint, run git commands to sync the frontend submodule.
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
3. Read PROJECT_RULES.md for coding standards
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
- After completing the sprint, run git commands to sync the backend submodule.
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
- After completing the sprint, run git commands to sync the relevant submodule or the main repository.
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

## 🛠️ Utility Prompts

These prompts are for specific, non-sprint tasks like code quality checks or project synchronization.

### Run Code Quality Checks

```markdown
Run type checks, lint checks, and resolve all errors/warnings in the [Frontend/Backend] codebase.
```

### Sync Git Submodules

```markdown
After completing the sprint, run git commands to sync the [frontend/backend] submodule.
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

**See [HOW_TO_CONTINUE_WORK.md](HOW_TO_CONTINUE_WORK.md) for more detailed instructions on sprint-based development.**