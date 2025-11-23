# How to Continue Work in a New Chat Session

This guide explains how to instruct an AI agent to pick up where you left off, especially for sprint-based development.

---

## 🚀 Quick Start Template (Autonomous Mode)

Use this template when starting a new chat session. The agent will determine what to do from the checklist:

### For Frontend Work

```
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

Start working now. Determine the next task from the checklist and begin implementation.
```

### For Backend Work

```
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

Start working now. Determine the next task from the checklist and begin implementation.
```

**For Specific Issues Only:**
If you need to address a specific issue, add: `**Specific Focus:** [issue description]`

---

## 📋 Detailed Instructions

### Option 1: Continue Specific Feature

```
Continue frontend work on [FEATURE NAME] from the FRONTEND_CHECKLIST.md.

**Feature:** [e.g., Conditional Logic UI]
**Sprint Goal:** [e.g., Build the rule builder interface]
**Time Box:** [e.g., 2-3 hours]

Please:
1. Review docs/FRONTEND_CHECKLIST.md for the feature requirements
2. Check the current codebase to see what's already implemented
3. Break the work into small, testable chunks
4. Implement the first chunk with:
   - Component structure
   - TypeScript types
   - Basic UI
   - Integration points
5. Update the checklist as you complete items
```

### Option 2: Continue from Last Sprint

```
I'm continuing frontend development. Last sprint I worked on [FEATURE]. 
Please review the progress and continue with the next sprint.

**Last Completed:** [e.g., File upload field component created]
**Next Sprint:** [e.g., File preview and validation]
**Checklist:** docs/FRONTEND_CHECKLIST.md

Please:
1. Review what was completed in the last session
2. Identify the next logical step
3. Implement it in a focused sprint
4. Update the checklist
```

### Option 3: Start New Sprint from Checklist

```
Start a new frontend sprint. Work on the highest priority pending item from 
docs/FRONTEND_CHECKLIST.md.

**Sprint Style:** 
- Break work into 2-3 hour chunks
- Complete one chunk per response
- Test as you go
- Update checklist after each completion

**Focus Areas:**
- [ ] Conditional Logic UI
- [ ] File Upload Fields  
- [ ] Form Analytics
- [ ] Email Notifications
- [ ] Form Versioning

Please start with the highest priority item and work through it systematically.
```

---

## 🎯 Sprint-Based Work Template

For systematic sprint work:

```
Work on frontend features in sprints. Each sprint should be:
- **Duration:** 2-4 hours of focused work
- **Scope:** One feature or one major component
- **Deliverable:** Working, tested code
- **Documentation:** Update checklist after completion

**Current Sprint:**
- Feature: [Feature name from checklist]
- Goal: [Specific goal for this sprint]
- Files to create/modify: [List if known]

**Process:**
1. Review PROJECT_RULES.md for coding standards
2. Check existing code patterns in frontend/src/
3. Implement following the project's TypeScript/React conventions
4. Update docs/FRONTEND_CHECKLIST.md as you complete items
5. Provide a summary of what was completed

Start the sprint now.
```

---

## 📝 Context Files Reference

Always reference these files for context:

### Essential Files

1. **PROJECT_RULES.md** - Coding standards, architecture rules
2. **docs/PROGRESS_CHECKLIST.md** - Overall project status
3. **docs/FRONTEND_CHECKLIST.md** - Detailed frontend tasks
4. **frontend/README.md** - Frontend architecture and setup

### Supporting Files

- **docs/DEV_RULES.md** - Detailed development rules
- **docs/PRD.md** - Product requirements
- **docs/BACKEND_CHECKLIST.md** - Backend status (for API dependencies)

---

## 🔄 Example Prompts

### Example 1: Starting Fresh Sprint

```
I'm starting a new frontend sprint. Please:

1. Read docs/FRONTEND_CHECKLIST.md
2. Identify the highest priority pending feature
3. Break it into a 2-3 hour sprint
4. Implement the first component/feature
5. Follow PROJECT_RULES.md standards
6. Update the checklist

Start with: [Feature name]
```

### Example 2: Continuing Previous Work

```
Continue frontend development. Last session I completed [specific task].
The next item in docs/FRONTEND_CHECKLIST.md is [next task].

Please:
1. Review the current state of [feature/component]
2. Continue with the next logical step
3. Implement following project conventions
4. Update checklist when done
```

### Example 3: Multi-Sprint Planning

```
Plan and execute frontend work in sprints for the next [X] features.

**Features to work on:**
1. Conditional Logic UI
2. File Upload Fields
3. Form Analytics

**Sprint Structure:**
- Each sprint: 2-3 hours
- Complete one major component per sprint
- Test and update checklist after each

Start with sprint 1: Conditional Logic UI - Rule Builder Interface
```

---

## 🎨 Best Practices

### 1. Be Specific About Scope

```
❌ "Continue frontend work"
✅ "Continue frontend work on Conditional Logic UI - implement the rule builder interface component"
```

### 2. Reference Checklists

```
❌ "Add file upload"
✅ "Implement File Upload Fields from docs/FRONTEND_CHECKLIST.md, starting with the FileUploadField component"
```

### 3. Set Sprint Boundaries

```
❌ "Work on analytics"
✅ "Sprint: Build the Analytics Dashboard page component (2-3 hours). Include chart setup and data fetching structure."
```

### 4. Request Progress Updates

```
"After completing this sprint, update docs/FRONTEND_CHECKLIST.md to reflect progress"
```

---

## 📊 Checklist Update Format

When asking the agent to update checklists:

```
After completing this sprint, please:
1. Update docs/FRONTEND_CHECKLIST.md - mark completed items with [x]
2. Update docs/PROGRESS_CHECKLIST.md - update progress percentages
3. Note any blockers or dependencies discovered
```

---

## 🔗 Quick Reference Commands

### Start New Sprint

```
New frontend sprint: [Feature] from FRONTEND_CHECKLIST.md
```

### Continue Sprint

```
Continue frontend sprint: [Feature] - next task is [specific task]
```

### Review Progress

```
Review frontend progress from FRONTEND_CHECKLIST.md and suggest next sprint
```

### Complete Feature

```
Complete [Feature] from FRONTEND_CHECKLIST.md. Work through all remaining tasks in sprints.
```

---

## 💡 Tips

1. **Always reference the checklist** - It keeps context clear
2. **Specify sprint duration** - Helps agent scope work appropriately
3. **Request checklist updates** - Maintains accurate progress tracking
4. **Mention dependencies** - If backend API is needed, reference BACKEND_CHECKLIST.md
5. **Follow project rules** - Always remind agent to follow PROJECT_RULES.md

---

## 🎯 Example Full Prompt

Here's a complete example you can copy-paste:

```
I'm working on FormWeaver frontend development. Please continue in sprints.

**Context:**
- Project: FormWeaver (form builder SaaS)
- Tech: React 18 + TypeScript + Vite + Tailwind CSS
- Location: frontend/ directory

**Review These Files:**
- PROJECT_RULES.md
- docs/FRONTEND_CHECKLIST.md
- docs/PROGRESS_CHECKLIST.md
- frontend/README.md

**Current Sprint:**
- Feature: Conditional Logic UI
- Goal: Build the rule builder interface in PropertyEditor
- Duration: 2-3 hours
- Deliverable: Working rule builder component with add/edit/delete rules

**Process:**
1. Review existing conditional logic code (frontend/src/lib/conditionalLogic.ts)
2. Check PropertyEditor component structure
3. Implement rule builder UI following project conventions
4. Integrate with existing conditional logic engine
5. Update docs/FRONTEND_CHECKLIST.md when complete

Start the sprint now.
```

---

**Last Updated:** 2025-01-16  
**Purpose:** Help developers continue work across chat sessions
