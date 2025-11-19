# Quick Start Prompts for New Chat Sessions

Copy and paste the appropriate prompt when starting a new chat to continue development:

---

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
7. Update the checklist as you complete items

**Work Autonomously:**
- Use the checklist to determine what to do next
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the checklist
- Update checklists after completing work

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/FRONTEND_CHECKLIST.md - Frontend task list (your primary guide)
- docs/PROGRESS_CHECKLIST.md - Overall progress
- docs/BACKEND_CHECKLIST.md - Backend status (check for API dependencies)
- frontend/README.md - Frontend architecture

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
4. Determine the highest priority pending feature from the checklist
5. Break it into a 2-3 hour sprint
6. Implement the first sprint task following project conventions
7. Update the checklist as you complete items

**Work Autonomously:**
- Use the checklist to determine what to do next
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the checklist
- Update checklists after completing work
- Check docs/FRONTEND_CHECKLIST.md for API requirements frontend needs

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/BACKEND_CHECKLIST.md - Backend task list (your primary guide)
- docs/PROGRESS_CHECKLIST.md - Overall progress
- docs/FRONTEND_CHECKLIST.md - Frontend status (check for API dependencies)
- backend/README.md - Backend architecture

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
5. Determine the highest priority pending feature from the relevant checklist
6. Break it into a 2-3 hour sprint
7. Implement the first sprint task following project conventions
8. Update both the specific checklist and PROGRESS_CHECKLIST.md as you complete items

**Work Autonomously:**
- Use PROGRESS_CHECKLIST.md to determine which component to work on
- Use the specific checklist (Frontend/Backend) to determine what to do
- Only ask for clarification if you encounter blockers or need decisions
- Follow the priority order in the relevant checklist
- Update checklists after completing work
- Coordinate between frontend and backend when dependencies exist

**Context Files:**
- PROJECT_RULES.md - Coding standards and architecture
- docs/PROGRESS_CHECKLIST.md - Overall project status (start here)
- docs/FRONTEND_CHECKLIST.md - Frontend task list
- docs/BACKEND_CHECKLIST.md - Backend task list
- frontend/README.md - Frontend architecture
- backend/README.md - Backend architecture

Start working now. Review the overall progress, determine which component needs work, then begin implementation.
```

---

## 🎯 For Specific Issues

If you need to address a specific issue or work on a particular feature, add to any of the above prompts:

```markdown
**Specific Focus:** [Feature name or issue description]
```

Examples:

```markdown
**Specific Focus:** Fix the conditional logic evaluation bug in FormRenderer
**Specific Focus:** Implement the authentication signup endpoint
**Specific Focus:** Add file upload field component
**Specific Focus:** Set up R2 storage for file uploads
```

Otherwise, the agent will autonomously follow the checklist priority order.

---

**See [HOW_TO_CONTINUE_WORK.md](HOW_TO_CONTINUE_WORK.md) for more detailed instructions.**
