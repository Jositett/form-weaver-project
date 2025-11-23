# Implementation Guide - Preventing Common Issues

**Last Updated:** 2025-11-23
**Purpose:** Guide to prevent common implementation issues based on lessons learned
**Scope:** Includes marketplace and student employment considerations

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

### Marketplace-Specific Pre-Implementation Checklist

1. **Verify Marketplace API Endpoints Exist**
   ```bash
   # Check marketplace API specifications
   read_file "backend/src/routes/marketplace.ts"
   
   # Verify creator dashboard component interfaces
   read_file "frontend/src/components/marketplace/CreatorDashboard.tsx"
   
   # Review template marketplace data structures
   read_file "backend/src/types/marketplace.ts"
   ```

2. **Review Legal Compliance Requirements**
   ```bash
   # Check data retention policy implementation
   read_file "backend/src/utils/compliance.ts"
   
   # Verify GDPR compliance requirements are documented
   read_file "docs/LEGAL_COMPLIANCE.md"
   
   # Check student verification system specifications
   read_file "backend/src/services/studentVerification.ts"
   ```

3. **Verify Template Marketplace Integration Points**
   ```bash
   # Check KV storage structure for templates
   read_file "backend/src/services/templateStorage.ts"
   
   # Verify commission calculation requirements
   read_file "backend/src/services/commissionCalculator.ts"
   
   # Review creator payout system implementation
   read_file "backend/src/services/payoutService.ts"
   ```

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

## 🛒 Marketplace Implementation Patterns

### Template Marketplace API Integration

1. **Follow Consistent API Patterns**
   ```typescript
   // ✅ GOOD: Follow existing marketplace API patterns
   interface MarketplaceAPI {
     getTemplates(category?: string): Promise<Template[]>
     getTemplate(id: string): Promise<Template>
     createTemplate(template: TemplateRequest): Promise<Template>
     updateTemplate(id: string, template: TemplateUpdate): Promise<Template>
     deleteTemplate(id: string): Promise<void>
   }
   
   // ❌ BAD: Inconsistent API naming
   // getTemplateData(), fetchTemplates(), createNewTemplate()
   // ✅ GOOD: Consistent naming
   // getTemplate(), getTemplates(), createTemplate()
   ```

2. **Implement Proper Error Handling**
   ```typescript
   // ✅ GOOD: Comprehensive error handling
   try {
     const templates = await marketplaceAPI.getTemplates(category);
     return templates;
   } catch (error) {
     if (error.status === 404) {
       return []; // No templates in category
     }
     throw new Error(`Failed to fetch templates: ${error.message}`);
   }
   ```

### Creator Dashboard Component Architecture

1. **Use Consistent Component Structure**
   ```typescript
   // ✅ GOOD: Creator dashboard component pattern
   interface CreatorDashboardProps {
     creatorId: string;
     onTemplateCreate: (template: Template) => void;
     onTemplateUpdate: (template: Template) => void;
   }
   
   function CreatorDashboard({ creatorId, onTemplateCreate, onTemplateUpdate }: CreatorDashboardProps) {
     const [templates, setTemplates] = useState<Template[]>([]);
     const [analytics, setAnalytics] = useState<CreatorAnalytics>({});
     
     // Component implementation
   }
   ```

2. **Implement State Management Properly**
   ```typescript
   // ✅ GOOD: Use Zustand for creator state management
   interface CreatorState {
     creatorInfo: Creator | null;
     templates: Template[];
     earnings: EarningsSummary;
     updateCreator: (info: Partial<Creator>) => void;
     addTemplate: (template: Template) => void;
   }
   
   const useCreatorStore = create<CreatorState>((set) => ({
     creatorInfo: null,
     templates: [],
     earnings: { total: 0, pending: 0, available: 0 },
     updateCreator: (info) => set((state) => ({ creatorInfo: { ...state.creatorInfo, ...info } })),
     addTemplate: (template) => set((state) => ({ templates: [...state.templates, template] })),
   }));
   ```

### Commission and Payout System Implementation

1. **Implement Accurate Commission Calculations**
   ```typescript
   // ✅ GOOD: Commission calculation with proper rounding
   interface CommissionCalculator {
     calculateCommission(amount: number, creatorTier: CreatorTier): {
       creatorEarnings: number;
       platformFee: number;
       currency: string;
     };
   }
   
   function calculateCommission(amount: number, creatorTier: CreatorTier): CommissionResult {
     const commissionRate = COMMISSION_RATES[creatorTier]; // 0.73 for Pro, 0.65 for Elite
     const creatorEarnings = Math.round(amount * commissionRate * 100) / 100; // Round to cents
     const platformFee = Math.round(amount * (1 - commissionRate) * 100) / 100;
     
     return {
       creatorEarnings,
       platformFee,
       currency: 'USD'
     };
   }
   ```

2. **Handle Payout Scheduling Correctly**
   ```typescript
   // ✅ GOOD: Net 30 days payout implementation
   function schedulePayout(sale: TemplateSale): PayoutSchedule {
     const payoutDate = new Date(sale.timestamp);
     payoutDate.setDate(payoutDate.getDate() + 30); // Net 30 days
     
     return {
       saleId: sale.id,
       creatorId: sale.creatorId,
       amount: sale.creatorEarnings,
       scheduledDate: payoutDate,
       status: 'pending',
       minimumThreshold: 50 // $50 minimum payout
     };
   }
   ```

### Template Review and Approval Workflow

1. **Implement Multi-Stage Review Process**
   ```typescript
   // ✅ GOOD: Template review workflow
   interface TemplateReview {
     status: 'pending' | 'reviewing' | 'approved' | 'rejected' | 'changes_requested';
     reviewerId?: string;
     reviewNotes?: string;
     reviewedAt?: string;
     rejectionReasons?: string[];
   }
   
   function processTemplateReview(templateId: string, decision: 'approve' | 'reject' | 'request_changes'): Promise<TemplateReview> {
     // Technical validation
     const technicalValidation = validateTemplateTechnical(templateId);
     
     // Design review
     const designReview = validateTemplateDesign(templateId);
     
     // Compliance check
     const complianceCheck = validateTemplateCompliance(templateId);
     
     return updateTemplateReview(templateId, {
       status: decision === 'approve' ? 'approved' : 'rejected',
       reviewerId: getCurrentUserId(),
       reviewedAt: new Date().toISOString(),
       reviewNotes: combineReviewNotes(technicalValidation, designReview, complianceCheck)
     });
   }
   ```

### Student Verification System Implementation

1. **Implement Progressive Verification**
   ```typescript
   // ✅ GOOD: Student verification with multiple methods
   interface StudentVerification {
     status: 'unverified' | 'pending' | 'verified' | 'rejected';
     verificationMethod: 'email' | 'id_upload' | 'oauth' | 'manual';
     verificationData: {
       email?: string;
       studentId?: string;
       institution?: string;
       verificationDocument?: string;
     };
     verifiedAt?: string;
     expiresAt?: string;
   }
   
   async function verifyStudent(userId: string, method: 'email' | 'id_upload' | 'oauth'): Promise<StudentVerification> {
     switch (method) {
       case 'email':
         return await sendVerificationEmail(userId);
       case 'id_upload':
         return await processStudentIdUpload(userId);
       case 'oauth':
         return await verifyThroughOAuth(userId);
       default:
         throw new Error('Invalid verification method');
     }
   }
   ```

---

## 👥 Student Creator Experience Implementation

### Low-Barrier Entry Development Practices

1. **Implement Progressive Onboarding**
   ```typescript
   // ✅ GOOD: Step-by-step creator onboarding
   interface CreatorOnboardingStep {
     id: 'welcome' | 'profile' | 'first_template' | 'publish' | 'promote';
     title: string;
     description: string;
     completed: boolean;
     requires: string[];
   }
   
   const onboardingSteps: CreatorOnboardingStep[] = [
     {
       id: 'welcome',
       title: 'Welcome to FormWeaver Creator',
       description: 'Learn about the marketplace and opportunities',
       completed: false,
       requires: []
     },
     {
       id: 'profile',
       title: 'Set Up Your Creator Profile',
       description: 'Create a professional profile to attract buyers',
       completed: false,
       requires: ['welcome']
     },
     {
       id: 'first_template',
       title: 'Create Your First Template',
       description: 'Build your first template with guided help',
       completed: false,
       requires: ['profile']
     },
     {
       id: 'publish',
       title: 'Publish and Get Reviewed',
       description: 'Submit your template for review and publishing',
       completed: false,
       requires: ['first_template']
     },
     {
       id: 'promote',
       title: 'Promote Your Template',
       description: 'Learn how to market your template to potential buyers',
       completed: false,
       requires: ['publish']
     }
   ];
   ```

2. **Provide Template Creation Assistance**
   ```typescript
   // ✅ GOOD: Template scaffolding and validation
   function generateTemplateScaffold(templateType: TemplateCategory): TemplateScaffold {
     const baseStructure = getBaseTemplateStructure(templateType);
     
     return {
       ...baseStructure,
       fields: addRecommendedFields(templateType),
       conditionalLogic: addBasicLogic(templateType),
       styling: applyDefaultStyling(templateType),
       documentation: generateTemplateDocumentation(templateType)
     };
   }
   
   function validateTemplateBeforeSubmission(template: Template): ValidationResult {
     const checks = [
       validateTemplateStructure(template),
       validateConditionalLogic(template),
       validateAccessibility(template),
       validateMobileResponsiveness(template),
       validatePerformance(template)
     ];
     
     return {
       isValid: checks.every(check => check.passed),
       errors: checks.filter(check => !check.passed).map(check => check.error),
       warnings: checks.filter(check => check.warning).map(check => check.warning)
     };
   }
   ```

### Mentorship Program Integration Patterns

1. **Implement Creator Mentorship System**
   ```typescript
   // ✅ GOOD: Mentorship matching and tracking
   interface MentorshipProgram {
     mentorId: string;
     menteeId: string;
     programType: 'beginner' | 'intermediate' | 'advanced';
     startDate: string;
     endDate?: string;
     milestones: MentorshipMilestone[];
     progress: number; // 0-100
   }
   
   function matchMentorWithMentee(menteeId: string, programType: string): Promise<MentorshipMatch> {
     const eligibleMentors = getEligibleMentors(programType);
     const compatibilityScore = calculateCompatibility(menteeId, eligibleMentors);
     const bestMatch = selectBestMatch(compatibilityScore);
     
     return createMentorshipMatch(bestMatch.mentorId, menteeId, programType);
   }
   ```

2. **Provide Educational Resource Integration**
   ```typescript
   // ✅ GOOD: Learning resources and progress tracking
   interface LearningResource {
     id: string;
     title: string;
     type: 'video' | 'article' | 'tutorial' | 'webinar';
     duration: number; // minutes
     difficulty: 'beginner' | 'intermediate' | 'advanced';
     completionRequired: boolean;
     prerequisiteIds: string[];
   }
   
   const creatorLearningPath: LearningResource[] = [
     {
       id: 'cl101',
       title: 'Form Design Fundamentals',
       type: 'video',
       duration: 30,
       difficulty: 'beginner',
       completionRequired: true,
       prerequisiteIds: []
     },
     {
       id: 'cl102',
       title: 'Advanced Conditional Logic',
       type: 'tutorial',
       duration: 45,
       difficulty: 'intermediate',
       completionRequired: true,
       prerequisiteIds: ['cl101']
     },
     {
       id: 'cl103',
       title: 'Marketplace Best Practices',
       type: 'webinar',
       duration: 60,
       difficulty: 'beginner',
       completionRequired: false,
       prerequisiteIds: []
     }
   ];
   ```

---

## 🏛️ Legal Compliance Implementation

### Data Retention Policy Implementation

1. **Implement TTL-Based Auto-Deletion**
   ```typescript
   // ✅ GOOD: KV TTL-based auto-deletion system
   interface DataRetentionConfig {
     formType: FormType;
     retentionDays: number;
     autoDelete: boolean;
     legalHold: boolean;
   }
   
   const retentionPolicies: Record<FormType, DataRetentionConfig> = {
     'contact': { formType: 'contact', retentionDays: 30, autoDelete: true, legalHold: false },
     'lead': { formType: 'lead', retentionDays: 365, autoDelete: true, legalHold: false },
     'event': { formType: 'event', retentionDays: 30, autoDelete: true, legalHold: false },
     'job-application': { formType: 'job-application', retentionDays: 180, autoDelete: true, legalHold: false },
     'medical': { formType: 'medical', retentionDays: 2190, autoDelete: false, legalHold: true }, // 6 years
     'payment': { formType: 'payment', retentionDays: 2555, autoDelete: false, legalHold: true }, // 7 years
     'failed': { formType: 'failed', retentionDays: 7, autoDelete: true, legalHold: false }
   };
   
   function calculateTTL(formType: FormType): number | null {
     const policy = retentionPolicies[formType];
     if (!policy) return 90 * 86400; // Default 90 days
     
     if (!policy.autoDelete || policy.legalHold) {
       return null; // No auto-deletion
     }
     
     return policy.retentionDays * 86400; // Convert days to seconds
   }
   
   // Usage in KV storage
   await env.FORMWEAVER_SUBMISSIONS.put(submissionId, JSON.stringify(data), {
     expirationTtl: calculateTTL(formType)
   });
   ```

2. **Implement Right to Erasure (GDPR/CCPA)**
   ```typescript
   // ✅ GOOD: User data deletion within 30 days
   async function handleDeletionRequest(request: Request, env: Env): Promise<Response> {
     const { userId, formId } = await request.json();
     
     // Find all user submissions
     const listResult = await env.FORMWEAVER_SUBMISSIONS.list({
       prefix: `submission:${formId}:${userId}:`
     });
     
     // Delete submissions
     const deletes = listResult.keys.map(key =>
       env.FORMWEAVER_SUBMISSIONS.delete(key.name)
     );
     
     await Promise.all(deletes);
     
     // Log compliance action
     await env.COMPLIANCE_LOG.put(`deletion:${Date.now()}`, JSON.stringify({
       userId,
       formId,
       deletedCount: deletes.length,
       completedAt: new Date().toISOString(),
       requestedAt: new Date().toISOString() // Will be different in real implementation
     }));
     
     return new Response(JSON.stringify({ success: true }), { status: 200 });
   }
   ```

### GDPR Compliance Implementation Guidelines

1. **Implement Data Subject Rights**
   ```typescript
   // ✅ GOOD: Data portability implementation
   async function exportUserData(userId: string, formId: string): Promise<Response> {
     const submissions = await env.FORMWEAVER_SUBMISSIONS.list({
       prefix: `submission:${formId}:${userId}:`
     });
     
     // Convert submissions to user data
     const data = await Promise.all(
       submissions.keys.map(async key => {
         const submission = await env.FORMWEAVER_SUBMISSIONS.get(key.name);
         return JSON.parse(submission || '{}');
       })
     );
     
     return new Response(JSON.stringify({
       userId,
       formId,
       submissions: data,
       exportedAt: new Date().toISOString(),
       format: 'json'
     }), {
       headers: {
         'Content-Type': 'application/json',
         'Content-Disposition': `attachment; filename="formweaver-data-${userId}-${formId}.json"`
       }
     });
   }
   ```

2. **Implement Legal Hold System**
   ```typescript
   // ✅ GOOD: Litigation hold implementation
   async function applyLegalHold(submissionId: string, caseId: string, reason: string): Promise<void> {
     // Store legal hold record
     await env.LEGAL_HOLDS.put(`hold:${submissionId}`, JSON.stringify({
       caseId,
       holdStartDate: Date.now(),
       holdEndDate: null,
       reason,
       appliedBy: getCurrentUserId()
     }));
     
     // Log the hold for audit purposes
     await env.COMPLIANCE_LOG.put(`legalhold:${Date.now()}`, JSON.stringify({
       submissionId,
       caseId,
       reason,
       appliedBy: getCurrentUserId(),
       appliedAt: new Date().toISOString()
     }));
     
     // Notify compliance team
     await sendComplianceNotification('Legal hold applied', {
       submissionId,
       caseId,
       reason
     });
   }
   ```

### Industry-Specific Compliance Implementation

1. **HIPAA Compliance for Medical Forms**
   ```typescript
   // ✅ GOOD: HIPAA-compliant form handling
   interface HIPAACompliantForm {
     businessAssociateAgreement: boolean;
     encryptionRequired: boolean;
     accessControls: AccessControl[];
     auditLogging: boolean;
     breachNotificationPlan: boolean;
   }
   
   function validateHIPAACompliance(form: Form): ComplianceValidation {
     const validations = [
       validateEncryption(form),
       validateAccessControls(form),
       validateAuditLogging(form),
       validateBAASignature(form)
     ];
     
     return {
       compliant: validations.every(v => v.passed),
       failedChecks: validations.filter(v => !v.passed).map(v => v.check),
       requiredActions: validations.filter(v => !v.passed).map(v => v.requiredAction)
     };
   }
   ```

2. **SOX Compliance for Financial Forms**
   ```typescript
   // ✅ GOOD: SOX compliance for financial data
   function implementSOXControls(): SOXControls {
     return {
       auditTrail: {
         enabled: true,
         retentionYears: 7,
         immutable: true,
         tamperEvident: true
       },
       accessControls: {
         roleBased: true,
         dualApproval: true,
         segregationOfDuties: true
       },
       dataIntegrity: {
         checksums: true,
         validationRules: true,
         reconciliationProcesses: true
       }
     };
   }
   ```

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

### Issue 5: Template Marketplace API Integration Errors

**Symptom:**
```
Failed to fetch templates: NetworkError when attempting to fetch resource
```

**Cause:**
- Marketplace API endpoints not properly configured
- Missing authentication headers
- Incorrect API response handling

**Solution:**
1. Verify API endpoint exists: `read_file "backend/src/routes/marketplace.ts"`
2. Check authentication implementation: `read_file "backend/src/middleware/auth.ts"`
3. Test API response format matches frontend expectations
4. Implement proper error handling and retry logic

**Prevention:**
- Always test marketplace API endpoints before integration
- Use consistent API response format across all endpoints
- Implement comprehensive error handling
- Add API integration tests to CI/CD pipeline

### Issue 6: Creator Dashboard State Management Problems

**Symptom:**
```
Creator analytics not updating, template list out of sync
```

**Cause:**
- Zustand store not properly configured
- Missing state synchronization between components
- Incorrect state update patterns

**Solution:**
1. Verify Zustand store structure matches component requirements
2. Check state update functions are properly implemented
3. Add proper loading and error states
4. Implement state persistence for critical data

**Prevention:**
- Use consistent state management patterns across creator dashboard
- Implement proper loading and error states
- Add state validation and debugging tools
- Test state synchronization between components

### Issue 7: Commission Calculation Discrepancies

**Symptom:**
```
Creator earnings don't match expected commission rates
```

**Cause:**
- Incorrect commission rate application
- Rounding errors in calculations
- Missing tax or fee considerations

**Solution:**
1. Verify commission rates are correctly defined: `COMMISSION_RATES[creatorTier]`
2. Check rounding implementation: `Math.round(amount * rate * 100) / 100`
3. Test calculation with various amounts and tiers
4. Add calculation audit logging

**Prevention:**
- Use precise decimal arithmetic for financial calculations
- Implement unit tests for all commission scenarios
- Add calculation verification in payout processing
- Log all commission calculations for audit purposes

### Issue 8: Legal Compliance Implementation Gaps

**Symptom:**
```
Data not being auto-deleted after retention period
```

**Cause:**
- TTL not properly configured in KV storage
- Missing retention policy validation
- Auto-deletion system not implemented

**Solution:**
1. Verify TTL implementation: `expirationTtl: calculateTTL(formType)`
2. Check retention policy configuration matches legal requirements
3. Test auto-deletion with different form types
4. Add compliance monitoring and alerts

**Prevention:**
- Implement comprehensive data retention testing
- Add compliance dashboard for monitoring
- Regular audit of retention policies
- Automated compliance validation in CI/CD

### Issue 9: Student Verification System Failures

**Symptom:**
```
Student verification emails not being sent, ID uploads failing
```

**Cause:**
- Email service not properly configured
- File upload validation too strict
- OAuth integration not working

**Solution:**
1. Verify email service configuration: `read_file "backend/src/services/emailService.ts"`
2. Check file upload validation rules
3. Test OAuth integration with actual providers
4. Add proper error handling and user feedback

**Prevention:**
- Test all verification methods thoroughly
- Implement fallback verification options
- Add comprehensive error logging
- Monitor verification success rates

### Issue 10: Marketplace Performance Optimization Challenges

**Symptom:**
```
Template marketplace loading slowly, creator dashboard lagging
```

**Cause:**
- Inefficient API queries
- Missing pagination
- Unoptimized state management
- Large bundle sizes

**Solution:**
1. Implement API response caching and pagination
2. Optimize database queries with proper indexing
3. Use lazy loading for non-critical components
4. Implement code splitting for large features

**Prevention:**
- Add performance monitoring and alerting
- Implement regular performance audits
- Use performance budgets in development
- Optimize images and assets automatically

---

## ✅ Implementation Workflow

### Step-by-Step Process

#### Marketplace Development Workflow
```bash
# Marketplace development workflow
1. Review marketplace API specifications
2. Implement creator dashboard components
3. Add commission and payout logic
4. Implement legal compliance features
5. Add student verification system
6. Test marketplace integration points
7. Update marketplace checklists
```

1. **Read Requirements**
   - Read checklist item carefully
   - Understand what needs to be built
   - Check for dependencies
   - Verify marketplace integration requirements

2. **Review Existing Code**
   - Check similar implementations
   - Understand existing patterns
   - Verify type definitions exist
   - Review marketplace API specifications

3. **Plan Implementation**
   - Break into small steps
   - Identify files to create/modify
   - Check for required props/interfaces
   - Plan marketplace integration points

4. **Implement**
   - Create/modify files
   - Follow project conventions
   - Run type-check frequently
   - Test marketplace integrations

5. **Verify**
   - Run `npm run type-check`
   - Run `npm run lint`
   - Test in browser
   - Test marketplace API integration
   - Update checklist

6. **Clean Up**
   - Remove unused imports
   - Fix linting errors
   - Update documentation
   - Add marketplace-specific documentation

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

### Fix Template Marketplace API Errors
```bash
# 1. Check API endpoint configuration
read_file "backend/src/routes/marketplace.ts"

# 2. Verify authentication middleware
read_file "backend/src/middleware/auth.ts"

# 3. Test API response format
curl -X GET "https://api.formweaver.com/marketplace/templates"

# 4. Implement proper error handling
```

### Fix Creator Dashboard State Management
```bash
# 1. Check Zustand store structure
read_file "frontend/src/stores/creatorStore.ts"

# 2. Verify state update functions
read_file "frontend/src/hooks/useCreatorAnalytics.ts"

# 3. Add proper loading states
# Implement loading and error states in components

# 4. Test state synchronization
```

### Fix Commission Calculation Issues
```bash
# 1. Verify commission rates
read_file "backend/src/services/commissionCalculator.ts"

# 2. Check rounding implementation
# Use: Math.round(amount * rate * 100) / 100

# 3. Test calculation scenarios
npm test commission-calculator.test.ts

# 4. Add audit logging
```

### Fix Legal Compliance Implementation
```bash
# 1. Check TTL configuration
read_file "backend/src/utils/compliance.ts"

# 2. Verify retention policies
# Ensure calculateTTL() returns correct values

# 3. Test auto-deletion
# Verify KV expirationTtl is working

# 4. Add compliance monitoring
```

### Fix Student Verification System Errors
```bash
# 1. Check email service
read_file "backend/src/services/emailService.ts"

# 2. Verify file upload handling
read_file "backend/src/services/fileUpload.ts"

# 3. Test OAuth integration
# Verify OAuth provider configuration

# 4. Add error handling and logging
```

---

## 📋 Verification Checklist

After implementing any feature:

### General Verification
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

### Marketplace-Specific Verification
- [ ] **Marketplace API Integration**
  - Test all marketplace API endpoints
  - Verify authentication works correctly
  - Check error handling is comprehensive

- [ ] **Creator Dashboard Functionality**
  - Test creator analytics display
  - Verify template management works
  - Check earnings tracking accuracy

- [ ] **Commission System Accuracy**
  - Test commission calculations with various scenarios
  - Verify payout scheduling is correct
  - Check financial data accuracy

- [ ] **Legal Compliance Features**
  - Verify data retention policies are applied
  - Test auto-deletion system
  - Check GDPR compliance features

- [ ] **Student Verification System**
  - Test all verification methods
  - Verify verification status updates correctly
  - Check error handling and user feedback

- [ ] **Performance Optimization**
  - Test marketplace loading times
  - Verify dashboard responsiveness
  - Check API response times

- [ ] **Checklist Updated**
  - Mark completed items as [x]
  - Update progress percentages
  - Note any issues or limitations
  - Document marketplace-specific considerations

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

### 6. Marketplace Implementation Best Practices
- **API Consistency**: Always follow existing marketplace API patterns
- **Error Handling**: Implement comprehensive error handling for all marketplace features
- **State Management**: Use Zustand consistently for creator dashboard state
- **Financial Accuracy**: Double-check all commission and payout calculations
- **Compliance First**: Always implement legal compliance features alongside functionality
- **Performance Monitoring**: Add performance metrics for marketplace features
- **User Experience**: Prioritize low-friction experiences for student creators

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

5. **Marketplace Integration Issues**
   - API endpoints not responding
   - State management inconsistencies
   - Commission calculation errors
   - Compliance feature gaps

6. **Performance Problems**
   - Slow API responses
   - Large bundle sizes
   - Unoptimized database queries
   - Missing pagination

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
   - Test marketplace integrations

3. **Update Documentation**
   - Update checklist
   - Update progress percentages
   - Document any issues
   - Add marketplace-specific documentation

4. **Code Review**
   - Review your own code
   - Check for improvements
   - Remove unused code
   - Verify marketplace integration quality

---

## 🎯 Success Criteria

A feature is complete when:

### General Criteria
- ✅ All TypeScript errors resolved
- ✅ All linter warnings fixed
- ✅ All required props passed
- ✅ Feature works in browser
- ✅ Checklist items marked complete
- ✅ No unused imports/code
- ✅ Follows project conventions
- ✅ Integration tested

### Marketplace-Specific Criteria
- ✅ All marketplace API endpoints tested
- ✅ Creator dashboard state management working
- ✅ Commission calculations accurate to cents
- ✅ Legal compliance features implemented
- ✅ Student verification system functional
- ✅ Performance requirements met
- ✅ Error handling comprehensive
- ✅ User experience optimized for student creators

---

**Last Updated:** 2025-11-23
**Based on:** Conditional Logic UI Implementation Review + Marketplace & Compliance Implementation Guidelines

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

