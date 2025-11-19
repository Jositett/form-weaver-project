# Implementation Guide - Preventing Common Issues

**Last Updated:** 2025-01-16  
**Purpose:** Guide to prevent common implementation issues based on lessons learned

---

## 🎯 Pre-Implementation Checklist

### Before Starting Any Feature

1. **Verify Type Files Exist**
   ```bash
   # Check if type files exist
   glob_file_search "**/types/*.ts"
   
   # Verify import paths match actual file names
   # ❌ BAD: import from "@/types/formBuilder" (file doesn't exist)
   # ✅ GOOD: import from "@/types/formweaver" (actual file)
   ```

2. **Check Component Interfaces**
   ```typescript
   // Read the component file to see required props
   read_file "frontend/src/components/formweaver/PropertyEditor.tsx"
   
   // Verify all required props are passed
   // ❌ BAD: <PropertyEditor field={field} onUpdate={update} />
   // ✅ GOOD: <PropertyEditor field={field} allFields={fields} onUpdate={update} />
   ```

3. **Verify Import Paths**
   ```typescript
   // Check actual directory structure
   list_dir "frontend/src/components"
   
   // Use correct casing (always lowercase for directories)
   // ❌ BAD: import from "@/components/FormWeaver/PropertyEditor"
   // ✅ GOOD: import from "@/components/formweaver/PropertyEditor"
   ```

4. **Review Existing Patterns**
   ```typescript
   // Check how similar features are implemented
   codebase_search "How are other editors integrated with PropertyEditor?"
   
   // Follow existing patterns for consistency
   ```

---

## 🔍 During Implementation

### Type Safety Checks

1. **Run Type Check Frequently**
   ```bash
   cd frontend
   npm run type-check
   ```

2. **Verify All Imports**
   - Check that all imported types exist
   - Verify import paths match actual file locations
   - Use consistent casing (lowercase for directories)

3. **Check Component Props**
   - Read component interface before using
   - Pass all required props
   - Use TypeScript to catch missing props

### Code Quality Checks

1. **Remove Unused Imports**
   ```typescript
   // ❌ BAD: Import but never use
   import { useState, Textarea } from 'react';
   
   // ✅ GOOD: Only import what you use
   import { Card } from '@/components/ui/card';
   ```

2. **Follow Project Conventions**
   - Use functional components only
   - Use TypeScript strict mode
   - Follow naming conventions from PROJECT_RULES.md

3. **Test Integration Points**
   - Verify component works with parent components
   - Check that props flow correctly
   - Test in actual usage context

---

## 🐛 Common Issues & Solutions

### Issue 1: Type Import Errors

**Symptom:**
```
Cannot find module '@/types/formBuilder' or its type declarations
```

**Cause:**
- Importing from non-existent type file
- Wrong file name in import

**Solution:**
1. Check actual type file name: `glob_file_search "**/types/*.ts"`
2. Verify correct import path
3. Update import to match actual file name

**Prevention:**
- Always verify type files exist before importing
- Use `glob_file_search` to find correct paths
- Follow existing import patterns in codebase

### Issue 2: Missing Props

**Symptom:**
```
Property 'allFields' is missing in type but required
```

**Cause:**
- Component interface requires prop but it's not passed
- New required prop added but usages not updated

**Solution:**
1. Read component interface to see required props
2. Find all usages: `grep "PropertyEditor" frontend/src`
3. Add missing prop to all usages

**Prevention:**
- Use TypeScript strict mode (catches at compile time)
- Run `npm run type-check` before committing
- Update all usages when adding required props

### Issue 3: Import Casing Issues (Windows)

**Symptom:**
```
Already included file name 'FormWeaver/X.tsx' differs from 'formweaver/X.tsx' only in casing
```

**Cause:**
- Windows filesystem is case-insensitive
- TypeScript is case-sensitive
- Mixed casing in imports

**Solution:**
1. Standardize all imports to lowercase directory names
2. Restart TypeScript server in IDE
3. Clear cache: `rm -rf node_modules/.cache .vite`
4. Restart dev server

**Prevention:**
- **Always use lowercase** for directory names
- Be consistent with import casing throughout project
- Use `list_dir` to verify actual directory casing

### Issue 4: Unused Imports

**Symptom:**
- No error, but code has unused imports
- Linter warnings about unused variables

**Solution:**
1. Remove unused imports
2. Run linter: `npm run lint`
3. Fix all warnings

**Prevention:**
- Remove imports as you remove code
- Run linter frequently during development
- Use IDE features to auto-remove unused imports

---

## ✅ Implementation Workflow

### Step-by-Step Process

1. **Read Requirements**
   - Read checklist item carefully
   - Understand what needs to be built
   - Check for dependencies

2. **Review Existing Code**
   - Check similar implementations
   - Understand existing patterns
   - Verify type definitions exist

3. **Plan Implementation**
   - Break into small steps
   - Identify files to create/modify
   - Check for required props/interfaces

4. **Implement**
   - Create/modify files
   - Follow project conventions
   - Run type-check frequently

5. **Verify**
   - Run `npm run type-check`
   - Run `npm run lint`
   - Test in browser
   - Update checklist

6. **Clean Up**
   - Remove unused imports
   - Fix linting errors
   - Update documentation

---

## 🔧 Quick Fixes Reference

### Fix Type Import Error
```bash
# 1. Find correct type file
glob_file_search "**/types/*.ts"

# 2. Update import
# Change: import from "@/types/formBuilder"
# To: import from "@/types/formweaver"
```

### Fix Missing Prop
```bash
# 1. Find component interface
read_file "frontend/src/components/formweaver/PropertyEditor.tsx"

# 2. Find all usages
grep "PropertyEditor" frontend/src -r

# 3. Add missing prop to all usages
```

### Fix Import Casing
```bash
# 1. Check actual directory name
list_dir "frontend/src/components"

# 2. Update all imports to match (use lowercase)
# Change: @/components/FormWeaver/
# To: @/components/formweaver/

# 3. Restart TypeScript server
```

### Fix Unused Imports
```bash
# 1. Run linter
npm run lint

# 2. Remove unused imports manually
# Or use IDE auto-fix
```

---

## 📋 Verification Checklist

After implementing any feature:

- [ ] **Type Check Passes**
  ```bash
  cd frontend && npm run type-check
  ```

- [ ] **Linter Passes**
  ```bash
  cd frontend && npm run lint
  ```

- [ ] **All Props Passed**
  - Check component interfaces
  - Verify all required props are passed
  - Check for TypeScript errors

- [ ] **Import Paths Correct**
  - Verify all imports use correct file names
  - Check directory casing is consistent
  - No references to non-existent files

- [ ] **No Unused Code**
  - Remove unused imports
  - Remove unused variables
  - Clean up commented code

- [ ] **Integration Works**
  - Test in browser
  - Verify feature works end-to-end
  - Check for console errors

- [ ] **Checklist Updated**
  - Mark completed items as [x]
  - Update progress percentages
  - Note any issues or limitations

---

## 🎓 Best Practices

### 1. Always Verify Before Importing
```typescript
// ❌ BAD: Assume file exists
import { FormField } from '@/types/formBuilder';

// ✅ GOOD: Verify first, then import
// Check: glob_file_search "**/formweaver.ts"
import { FormField } from '@/types/formweaver';
```

### 2. Read Interfaces Before Using Components
```typescript
// ❌ BAD: Guess what props are needed
<PropertyEditor field={field} />

// ✅ GOOD: Read interface first
// read_file "PropertyEditor.tsx" to see required props
<PropertyEditor field={field} allFields={fields} onUpdateField={update} />
```

### 3. Use Consistent Casing
```typescript
// ❌ BAD: Mixed casing
import from "@/components/FormWeaver/PropertyEditor"
import from "@/components/formweaver/FieldPalette"

// ✅ GOOD: Consistent lowercase
import from "@/components/formweaver/PropertyEditor"
import from "@/components/formweaver/FieldPalette"
```

### 4. Run Checks Frequently
```bash
# After every significant change:
npm run type-check  # Catch type errors early
npm run lint        # Catch style issues
```

### 5. Update Checklist Immediately
- Mark items as complete as you finish them
- Don't wait until the end
- Helps track progress accurately

---

## 🚨 Red Flags to Watch For

### During Implementation

1. **TypeScript Errors**
   - Don't ignore type errors
   - Fix them immediately
   - They indicate real problems

2. **Missing Props**
   - TypeScript will catch these
   - But verify manually too
   - Check all component usages

3. **Import Errors**
   - Verify file paths exist
   - Check casing matches
   - Use tools to verify

4. **Unused Code**
   - Remove as you go
   - Don't leave dead code
   - Keep codebase clean

---

## 📝 Post-Implementation Review

After completing a feature:

1. **Run All Checks**
   ```bash
   npm run type-check
   npm run lint
   npm run build  # Verify build works
   ```

2. **Test Functionality**
   - Test in browser
   - Verify feature works
   - Check for console errors

3. **Update Documentation**
   - Update checklist
   - Update progress percentages
   - Document any issues

4. **Code Review**
   - Review your own code
   - Check for improvements
   - Remove unused code

---

## 🎯 Success Criteria

A feature is complete when:

- ✅ All TypeScript errors resolved
- ✅ All linter warnings fixed
- ✅ All required props passed
- ✅ Feature works in browser
- ✅ Checklist items marked complete
- ✅ No unused imports/code
- ✅ Follows project conventions
- ✅ Integration tested

---

**Last Updated:** 2025-01-16  
**Based on:** Conditional Logic UI Implementation Review

