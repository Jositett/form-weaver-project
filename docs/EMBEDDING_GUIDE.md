# Embedding Guide
## FormWeaver SaaS Integration (Cloudflare Workers Edition)

**Version:** 2.0  
**Last Updated:** 2025-11-16  
**Audience:** Developers integrating FormWeaver into their applications

---

## 1. Overview

This guide covers all methods for embedding FormWeaver forms into your website or application. Our forms are powered by Cloudflare Workers for ultra-fast global performance with <50ms latency worldwide.

---

## 2. Quick Start (5 Minutes)

### 2.1 Get Your Form ID
1. Log in to [FormWeaver.app](https://FormWeaver.app)
2. Navigate to your form
3. Click "Share" → Copy Form ID (e.g., `form_abc123xyz`)

### 2.2 Choose Your Embedding Method
- **iframe embed** - Easiest, works everywhere (zero JavaScript knowledge required)
- **JavaScript SDK** - More control, better UX (vanilla JS, works with any framework)
- **React SDK** - Best for React apps (TypeScript support, hooks)
- **Vue SDK** - Best for Vue apps (composition API)
- **API-only** - Headless mode (build your own UI)

---

## 3. Method 1: iframe Embed

### 3.1 Basic iframe
```html
<iframe 
  src="https://forms.FormWeaver.app/f/form_abc123xyz"
  width="100%"
  height="600"
  frameborder="0"
  title="Contact Form"
></iframe>
```

### 3.2 With Options
```html
<iframe
  src="https://forms.FormWeaver.app/f/form_abc123xyz?theme=dark&hideHeader=true"
  width="100%"
  height="600"
  frameborder="0"
  allow="clipboard-write"
  sandbox="allow-scripts allow-same-origin allow-forms"
></iframe>
```

**Query Parameters:**
- `theme` - `light` | `dark` | `auto` (default: `auto`)
- `hideHeader` - `true` | `false` (default: `false`)
- `hideFooter` - `true` | `false` (default: `false`)
- `primaryColor` - Hex color without `#` (e.g., `3B82F6`)
- `fontFamily` - URL-encoded font name (e.g., `Inter`)
- `language` - `en` | `es` | `fr` | `de` (default: `en`)
- `prefill` - JSON object for pre-filling fields (URL-encoded)

### 3.3 Marketplace Embedding Options
```html
<!-- Creator-attributed embed -->
<iframe
  src="https://forms.FormWeaver.app/f/form_abc123xyz?creatorAttribution=true&showReviews=true"
  width="100%"
  height="700"
  frameborder="0"
  allow="clipboard-write"
  sandbox="allow-scripts allow-same-origin allow-forms"
></iframe>

<!-- Student creator highlight embed -->
<iframe
  src="https://forms.FormWeaver.app/f/form_abc123xyz?studentCreatorBadge=true&mentorshipCTA=true"
  width="100%"
  height="700"
  frameborder="0"
  allow="clipboard-write"
  sandbox="allow-scripts allow-same-origin allow-forms"
></iframe>

<!-- Marketplace integration embed -->
<iframe
  src="https://forms.FormWeaver.app/marketplace/embed?category=healthcare&creatorType=student"
  width="100%"
  height="800"
  frameborder="0"
  allow="clipboard-write"
  sandbox="allow-scripts allow-same-origin allow-forms"
></iframe>
```

**Marketplace Query Parameters:**
- `creatorAttribution` - `true` | `false` (default: `false`) - Shows creator credit and profile link
- `showReviews` - `true` | `false` (default: `false`) - Displays template rating and review summary
- `studentCreatorBadge` - `true` | `false` (default: `false`) - Highlights student creator with verification badge
- `mentorshipCTA` - `true` | `false` (default: `false`) - Shows mentorship program promotion
- `category` - Filter templates by category (e.g., `healthcare`, `business`, `education`)
- `creatorType` - Filter by creator type (`student`, `verified`, `pro`)
- `showPricing` - `true` | `false` (default: `true`) - Display template pricing information
- `allowPurchase` - `true` | `false` (default: `true`) - Enable "Buy Template" CTA for premium templates

**Example with prefill:**
```html
<iframe 
  src="https://forms.FormWeaver.app/f/form_abc123xyz?prefill=%7B%22email%22%3A%22user%40example.com%22%7D"
  width="100%"
  height="600"
></iframe>
```

### 3.3 Responsive iframe
```html
<style>
  .form-container {
    position: relative;
    padding-bottom: 75%; /* 4:3 aspect ratio */
    height: 0;
    overflow: hidden;
  }
  .form-container iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }
</style>

<div class="form-container">
  <iframe src="https://forms.FormWeaver.app/f/form_abc123xyz"></iframe>
</div>
```

### 3.4 Auto-Resize iframe
```html
<script src="https://cdn.FormWeaver.app/iframe-resizer.min.js"></script>
<iframe 
  id="form-iframe"
  src="https://forms.FormWeaver.app/f/form_abc123xyz"
  width="100%"
></iframe>

<script>
  FormWeaverIframeResizer.resize('#form-iframe');
  
  // Listen for form events
  window.addEventListener('message', (event) => {
    if (event.origin !== 'https://forms.FormWeaver.app') return;
    
    if (event.data.type === 'FormWeaver:submit') {
      console.log('Form submitted:', event.data.payload);
    }
  });
</script>
```

---

## 4. Method 3: Marketplace Embedding Integration

### 4.1 Template Marketplace Browsing
```html
<div id="marketplace-container"></div>

<script src="https://cdn.FormWeaver.app/marketplace-sdk.min.js"></script>
<script>
  FormWeaverMarketplace.render({
    container: '#marketplace-container',
    category: 'healthcare',
    creatorType: 'student',
    showFilters: true,
    showRatings: true,
    onTemplateSelect: (template) => {
      console.log('Selected template:', template);
      // Handle template selection
    },
    onCreatorClick: (creator) => {
      console.log('Viewing creator:', creator);
      // Navigate to creator profile
    }
  });
</script>
```

### 4.2 Creator Attribution Integration
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  creatorAttribution: {
    enabled: true,
    showProfileLink: true,
    showCommissionInfo: true, // Shows revenue sharing disclosure
    attributionPosition: 'bottom', // 'top', 'bottom', 'sidebar'
    customMessage: 'Template by {creatorName} - {commissionPercentage}% goes to creator'
  },
  marketplaceIntegration: {
    showTemplateInfo: true,
    showSimilarTemplates: true,
    enablePurchaseCTA: true,
    showCreatorStats: true
  }
});
```

### 4.3 Student Creator Promotion
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  studentCreatorFeatures: {
    showStudentBadge: true,
    showMentorshipCTA: true,
    showPortfolioLink: true,
    showDiscountPromo: true, // Educational discounts
    enableSkillTracking: true
  },
  mentorshipIntegration: {
    showProgramInfo: true,
    enableApplication: true,
    showSuccessStories: true
  }
});
```

### 4.4 Template Rating and Review Display
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  reviews: {
    enabled: true,
    showAverageRating: true,
    showReviewCount: true,
    showRecentReviews: 5,
    enableReviewSubmission: true,
    reviewVerification: true
  }
});
```

### 4.5 Revenue Sharing Disclosure
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  revenueDisclosure: {
    enabled: true,
    showCreatorEarnings: true, // "$35.77 earned by creator"
    showPlatformFee: true, // "$13.23 platform fee"
    showCommissionRate: true, // "73% goes to creator"
    disclosurePosition: 'footer',
    legalCompliance: true
  }
});
```

---

## 5. Method 4: JavaScript SDK

### 4.1 Template Marketplace Browsing
```html
<div id="marketplace-container"></div>

<script src="https://cdn.FormWeaver.app/marketplace-sdk.min.js"></script>
<script>
  FormWeaverMarketplace.render({
    container: '#marketplace-container',
    category: 'healthcare',
    creatorType: 'student',
    showFilters: true,
    showRatings: true,
    onTemplateSelect: (template) => {
      console.log('Selected template:', template);
      // Handle template selection
    },
    onCreatorClick: (creator) => {
      console.log('Viewing creator:', creator);
      // Navigate to creator profile
    }
  });
</script>
```

### 4.2 Creator Attribution Integration
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  creatorAttribution: {
    enabled: true,
    showProfileLink: true,
    showCommissionInfo: true, // Shows revenue sharing disclosure
    attributionPosition: 'bottom', // 'top', 'bottom', 'sidebar'
    customMessage: 'Template by {creatorName} - {commissionPercentage}% goes to creator'
  },
  marketplaceIntegration: {
    showTemplateInfo: true,
    showSimilarTemplates: true,
    enablePurchaseCTA: true,
    showCreatorStats: true
  }
});
```

### 4.3 Student Creator Promotion
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  studentCreatorFeatures: {
    showStudentBadge: true,
    showMentorshipCTA: true,
    showPortfolioLink: true,
    showDiscountPromo: true, // Educational discounts
    enableSkillTracking: true
  },
  mentorshipIntegration: {
    showProgramInfo: true,
    enableApplication: true,
    showSuccessStories: true
  }
});
```

### 4.4 Template Rating and Review Display
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  reviews: {
    enabled: true,
    showAverageRating: true,
    showReviewCount: true,
    showRecentReviews: 5,
    enableReviewSubmission: true,
    reviewVerification: true
  }
});
```

### 4.5 Revenue Sharing Disclosure
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  revenueDisclosure: {
    enabled: true,
    showCreatorEarnings: true, // "$35.77 earned by creator"
    showPlatformFee: true, // "$13.23 platform fee"
    showCommissionRate: true, // "73% goes to creator"
    disclosurePosition: 'footer',
    legalCompliance: true
  }
});
```

---

## 5. Method 4: JavaScript SDK

### 6.1 Installation

**CDN (no build step) - Served from Cloudflare:**
```html
<script src="https://cdn.FormWeaver.app/sdk@2.0.0.min.js"></script>
<!-- Or use latest: -->
<script src="https://cdn.FormWeaver.app/sdk.min.js"></script>
```

**NPM (for bundlers):**
```bash
npm install @FormWeaver/sdk @FormWeaver/marketplace
```

### 6.2 Basic Usage
```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdn.FormWeaver.app/sdk.min.js"></script>
</head>
<body>
  <div id="form-container"></div>

  <script>
    FormWeaver.render({
      formId: 'form_abc123xyz',
      container: '#form-container',
      apiKey: 'pk_live_...', // Optional for public forms
      onSubmit: (data) => {
        console.log('Form submitted:', data);
      },
      onError: (error) => {
        console.error('Form error:', error);
      }
    });
  </script>
</body>
</html>
```

### 6.3 With Options
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  apiKey: 'pk_live_...', // Get from dashboard
  
  // API Configuration (Cloudflare Workers endpoint)
  apiUrl: 'https://api.FormWeaver.app/v1', // Default
  
  // Styling
  theme: 'dark',
  primaryColor: '#3B82F6',
  fontFamily: 'Inter, sans-serif',
  
  // Behavior
  submitButtonText: 'Send Message',
  successMessage: 'Thank you! We\'ll be in touch soon.',
  redirectUrl: 'https://yoursite.com/thank-you',
  redirectDelay: 2000, // Wait 2s before redirect
  
  // Pre-fill fields
  initialValues: {
    email: 'user@example.com',
    name: 'John Doe'
  },
  
  // Callbacks
  onLoad: () => console.log('Form loaded'),
  onSubmit: (data) => console.log('Submitted:', data),
  onError: (error) => console.error('Error:', error),
  onChange: (fieldId, value) => console.log(`${fieldId} changed to:`, value),
  onValidationError: (errors) => console.log('Validation errors:', errors),
  
  // Advanced
  locale: 'en',
  autoFocus: true,
  scrollToErrors: true,
  validateOnChange: true,
  validateOnBlur: true
});
```

### 4.4 Prefill from URL Parameters
```javascript
// Example: yoursite.com?email=user@example.com&name=John&utm_source=twitter
const urlParams = new URLSearchParams(window.location.search);

FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  initialValues: {
    email: urlParams.get('email'),
    name: urlParams.get('name'),
    // Store UTM parameters in hidden fields
    utm_source: urlParams.get('utm_source'),
    utm_campaign: urlParams.get('utm_campaign')
  }
});
```

### 6.4 Programmatic Control
```javascript
const form = FormWeaver.render({ 
  formId: 'form_abc123xyz', 
  container: '#app' 
});

// Get current values
const values = form.getValues();
console.log(values); // { name: 'John', email: 'john@example.com' }

// Get single field value
const email = form.getValue('email');

// Set values
form.setValues({ email: 'newemail@example.com' });

// Set single field value
form.setValue('name', 'Jane Doe');

// Validate without submitting
const errors = form.validate();
if (errors.length === 0) {
  console.log('Form is valid!');
} else {
  console.log('Validation errors:', errors);
}

// Submit programmatically
form.submit().then((result) => {
  console.log('Submission result:', result);
});

// Reset form
form.reset();

// Show/hide fields dynamically (if supported by form)
form.setFieldVisibility('conditionalField', true);

// Disable/enable form
form.setDisabled(true);

// Destroy form instance
form.destroy();
```

### 6.5 Error Handling

### 6.6 Marketplace-Specific Options
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  
  // Creator Attribution
  creatorAttribution: {
    enabled: true,
    creatorId: 'creator_123',
    creatorName: 'Jane Doe',
    creatorProfileUrl: 'https://formweaver.com/creator/jane-doe',
    showCommissionInfo: true,
    attributionStyle: 'minimal' // 'minimal', 'detailed', 'banner'
  },
  
  // Marketplace Integration
  marketplace: {
    templateId: 'template_456',
    categoryId: 'healthcare',
    showSimilarTemplates: true,
    enableTemplatePurchase: true,
    showCreatorPortfolio: true,
    templateRating: 4.8,
    templateReviewCount: 127
  },
  
  // Student Creator Features
  studentCreator: {
    isStudent: true,
    showStudentBadge: true,
    showMentorshipInfo: true,
    educationalDiscount: true,
    portfolioUrl: 'https://formweaver.com/student/jane-doe'
  },
  
  // Revenue Sharing
  revenueSharing: {
    creatorCommission: 73,
    platformFee: 27,
    showEarningsBreakdown: true,
    showTransparencyInfo: true
  }
});
```

### 6.7 Creator Analytics Tracking
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  analytics: {
    creatorId: 'creator_123',
    templateId: 'template_456',
    trackEmbedViews: true,
    trackFormSubmissions: true,
    trackTemplatePurchases: true,
    trackCreatorAttributionClicks: true,
    enablePerformanceMetrics: true
  }
});
```
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onError: (error) => {
    // Handle different error types
    switch (error.code) {
      case 'FORM_NOT_FOUND':
        console.error('Form not found or not published');
        break;
      case 'RATE_LIMIT_EXCEEDED':
        console.error('Too many submissions. Please try again later.');
        break;
      case 'VALIDATION_ERROR':
        console.error('Validation failed:', error.details);
        break;
      case 'NETWORK_ERROR':
        console.error('Network error. Please check your connection.');
        break;
      default:
        console.error('Unknown error:', error);
    }
  }
});
```

---

## 5. Method 3: React SDK

### 5.1 Installation
```bash
npm install @FormWeaver/react
```

### 5.2 Basic Usage
```tsx
import { FormWeaverEmbed } from '@FormWeaver/react';

function ContactPage() {
  return (
    <div className="container">
      <FormWeaverEmbed 
        formId="form_abc123xyz"
        apiKey="pk_live_..."
      />
    </div>
  );
}
```

### 5.3 With TypeScript + Options
```tsx
import { FormWeaverEmbed, FormSubmission } from '@FormWeaver/react';

interface ContactFormData {
  name: string;
  email: string;
  message: string;
  company?: string;
}

function ContactPage() {
  const handleSubmit = async (data: FormSubmission<ContactFormData>) => {
    console.log('Submitted:', data.values);
    
    // Send to your backend (optional)
    await fetch('/api/contact', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    
    // Track in analytics
    if (window.gtag) {
      window.gtag('event', 'form_submit', {
        form_id: 'contact_form'
      });
    }
  };

  return (
    <FormWeaverEmbed<ContactFormData>
      formId="form_abc123xyz"
      apiKey={process.env.NEXT_PUBLIC_FormWeaver_API_KEY}
      apiUrl="https://api.FormWeaver.app/v1" // Cloudflare Workers endpoint
      theme="dark"
      onSubmit={handleSubmit}
      onError={(error) => console.error(error)}
      onLoad={() => console.log('Form loaded')}
      initialValues={{
        email: 'user@example.com'
      }}
      className="my-form"
      style={{ maxWidth: '600px', margin: '0 auto' }}
    />
  );
}
```

### 5.4 Using Hooks
```tsx
import { useFormWeaver } from '@FormWeaver/react';

function CustomForm() {
  const { 
    formData, 
    isLoading, 
    errors, 
    values,
    submitForm,
    setFieldValue,
    validateField 
  } = useFormWeaver({
    formId: 'form_abc123xyz',
    apiKey: 'pk_live_...',
    apiUrl: 'https://api.FormWeaver.app/v1'
  });

  if (isLoading) return <div>Loading form...</div>;

  return (
    <div>
      <h2>{formData.title}</h2>
      <p>{formData.description}</p>
      
      {/* Render your own UI using formData.fields */}
      {formData.fields.map(field => (
        <div key={field.id} className="form-field">
          <label htmlFor={field.id}>
            {field.label}
            {field.required && <span className="text-red-500">*</span>}
          </label>
          
          <input 
            id={field.id}
            type={field.type}
            value={values[field.id] || ''}
            onChange={(e) => setFieldValue(field.id, e.target.value)}
            onBlur={() => validateField(field.id)}
            required={field.required}
            placeholder={field.placeholder}
          />
          
          {errors[field.id] && (
            <span className="text-red-500 text-sm">
              {errors[field.id]}
            </span>
          )}
        </div>
      ))}
      
      <button 
        onClick={submitForm}
        disabled={isLoading}
        className="btn btn-primary"
      >
        {isLoading ? 'Submitting...' : 'Submit'}
      </button>
    </div>
  );
}
```

### 5.5 Next.js App Router Example
```tsx
// app/contact/page.tsx
'use client';

import { FormWeaverEmbed } from '@FormWeaver/react';
import { useRouter } from 'next/navigation';

export default function ContactPage() {
  const router = useRouter();
  
  return (
    <main className="container mx-auto py-12">
      <h1 className="text-4xl font-bold mb-8">Contact Us</h1>
      
      <FormWeaverEmbed 
        formId={process.env.NEXT_PUBLIC_FORM_ID!}
        apiKey={process.env.NEXT_PUBLIC_FormWeaver_API_KEY!}
        apiUrl="https://api.FormWeaver.app/v1"
        onSubmit={async (data) => {
          // Send to your API route (optional)
          await fetch('/api/contact', {
            method: 'POST',
            body: JSON.stringify(data)
          });
          
          // Redirect to thank you page
          router.push('/thank-you');
        }}
        onError={(error) => {
          console.error('Form error:', error);
          // Show toast notification
        }}
      />
    </main>
  );
}
```

### 5.6 Server Components with Client Boundary
```tsx
// app/contact/page.tsx (Server Component)
import { ContactForm } from './ContactForm';

export default async function ContactPage() {
  // Fetch initial data on server if needed
  const formConfig = {
    formId: process.env.FORM_ID!,
    apiKey: process.env.NEXT_PUBLIC_FormWeaver_API_KEY!,
  };
  
  return (
    <main>
      <h1>Contact Us</h1>
      <ContactForm config={formConfig} />
    </main>
  );
}

// app/contact/ContactForm.tsx (Client Component)
'use client';

import { FormWeaverEmbed } from '@FormWeaver/react';

export function ContactForm({ config }: { config: any }) {
  return <FormWeaverEmbed {...config} />;
}
```

---

## 6. Method 4: Vue SDK

### 6.1 Installation
```bash
npm install @FormWeaver/vue
```

### 6.2 Basic Usage (Composition API)
```vue
<template>
  <div class="contact-page">
    <FormWeaverEmbed 
      :form-id="formId"
      :api-key="apiKey"
      :api-url="apiUrl"
      @submit="handleSubmit"
      @error="handleError"
    />
  </div>
</template>

<script setup lang="ts">
import { FormWeaverEmbed } from '@FormWeaver/vue';

const formId = 'form_abc123xyz';
const apiKey = import.meta.env.VITE_FormWeaver_API_KEY;
const apiUrl = 'https://api.FormWeaver.app/v1';

const handleSubmit = (data: any) => {
  console.log('Submitted:', data);
  // Send to analytics, backend, etc.
};

const handleError = (error: any) => {
  console.error('Form error:', error);
};
</script>
```

### 6.3 Using Composables
```vue
<template>
  <div>
    <div v-if="isLoading">Loading...</div>
    
    <div v-else-if="error">
      Error loading form: {{ error.message }}
    </div>
    
    <div v-else>
      <h2>{{ formData?.title }}</h2>
      <p>{{ formData?.description }}</p>
      
      <div v-for="field in formData?.fields" :key="field.id" class="form-field">
        <label :for="field.id">{{ field.label }}</label>
        <input 
          :id="field.id"
          :type="field.type"
          :value="values[field.id]"
          @input="setFieldValue(field.id, $event.target.value)"
        />
      </div>
      
      <button @click="submitForm" :disabled="isSubmitting">
        {{ isSubmitting ? 'Submitting...' : 'Submit' }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useFormWeaver } from '@FormWeaver/vue';

const { 
  formData, 
  isLoading, 
  error,
  values,
  isSubmitting,
  submitForm, 
  setFieldValue 
} = useFormWeaver({
  formId: 'form_abc123xyz',
  apiKey: import.meta.env.VITE_FormWeaver_API_KEY,
  apiUrl: 'https://api.FormWeaver.app/v1'
});
</script>
```

### 6.4 Nuxt 3 Example
```vue
<!-- pages/contact.vue -->
<template>
  <div class="container">
    <h1>Contact Us</h1>
    <ClientOnly>
      <FormWeaverEmbed 
        :form-id="formId"
        :api-key="config.public.FormWeaverApiKey"
        @submit="handleSubmit"
      />
    </ClientOnly>
  </div>
</template>

<script setup lang="ts">
import { FormWeaverEmbed } from '@FormWeaver/vue';

const config = useRuntimeConfig();
const formId = 'form_abc123xyz';

const handleSubmit = async (data: any) => {
  // Send to Nuxt API route
  await $fetch('/api/contact', {
    method: 'POST',
    body: data
  });
  
  // Navigate to success page
  await navigateTo('/thank-you');
};
</script>
```

---

## 7. Method 5: API-Only (Headless)

### 7.1 Fetch Form Schema
```javascript
const response = await fetch(
  'https://api.FormWeaver.app/v1/forms/form_abc123xyz',
  {
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json'
    }
  }
);

const formSchema = await response.json();
console.log(formSchema);
```

**Response (served from Cloudflare D1):**
```json
{
  "id": "form_abc123xyz",
  "title": "Contact Form",
  "description": "Get in touch with us",
  "status": "published",
  "fields": [
    {
      "id": "field_1",
      "type": "text",
      "label": "Name",
      "placeholder": "Enter your name",
      "required": true,
      "validation": {
        "minLength": 2,
        "maxLength": 100,
        "pattern": null
      }
    },
    {
      "id": "field_2",
      "type": "email",
      "label": "Email",
      "required": true,
      "validation": {
        "pattern": "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
      }
    },
    {
      "id": "field_3",
      "type": "textarea",
      "label": "Message",
      "required": true,
      "validation": {
        "minLength": 10,
        "maxLength": 1000
      }
    }
  ],
  "settings": {
    "submitButtonText": "Send Message",
    "successMessage": "Thank you! We'll be in touch soon.",
    "redirectUrl": null
  }
}
```

### 7.2 Submit Form Data
```javascript
const submission = await fetch(
  'https://api.FormWeaver.app/v1/f/form_abc123xyz/submit',
  {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}` // Optional for public forms
    },
    body: JSON.stringify({
      data: {
        field_1: 'John Doe',
        field_2: 'john@example.com',
        field_3: 'Hello, I would like to get in touch...'
      },
      metadata: {
        userAgent: navigator.userAgent,
        referrer: document.referrer,
        timestamp: new Date().toISOString()
      }
    })
  }
);

const result = await submission.json();
console.log(result);
```

**Success Response:**
```json
{
  "id": "sub_def456",
  "status": "success",
  "message": "Submission received",
  "submittedAt": "2025-11-16T12:34:56.789Z"
}
```

**Error Response (Rate Limited):**
```json
{
  "error": "Too many requests",
  "code": "RATE_LIMIT_EXCEEDED",
  "retryAfter": 60
}
```

### 7.3 Validate Before Submit
```javascript
// Client-side validation
const validateFormData = (formSchema, data) => {
  const errors = {};
  
  formSchema.fields.forEach(field => {
    const value = data[field.id];
    
    // Required validation
    if (field.required && (!value || value.trim() === '')) {
      errors[field.id] = `${field.label} is required`;
      return;
    }
    
    // Type validation
    if (field.type === 'email' && value) {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(value)) {
        errors[field.id] = 'Invalid email address';
      }
    }
    
    // Length validation
    if (field.validation?.minLength && value.length < field.validation.minLength) {
      errors[field.id] = `Minimum ${field.validation.minLength} characters required`;
    }
    
    if (field.validation?.maxLength && value.length > field.validation.maxLength) {
      errors[field.id] = `Maximum ${field.validation.maxLength} characters allowed`;
    }
    
    // Pattern validation
    if (field.validation?.pattern && value) {
      const regex = new RegExp(field.validation.pattern);
      if (!regex.test(value)) {
        errors[field.id] = `Invalid format for ${field.label}`;
      }
    }
  });
  
  return Object.keys(errors).length > 0 ? errors : null;
};

// Usage
const errors = validateFormData(formSchema, formData);
if (errors) {
  console.error('Validation errors:', errors);
} else {
  // Submit form
  await submitForm(formData);
}
```

### 7.4 Fetch Submissions (Authenticated)
```javascript
const response = await fetch(
  'https://api.FormWeaver.app/v1/forms/form_abc123xyz/submissions?page=1&limit=50',
  {
    headers: {
      'Authorization': `Bearer ${apiKey}` // Requires authenticated API key
    }
  }
);

const { items, total, page, hasMore } = await response.json();
console.log(`Showing ${items.length} of ${total} submissions`);
```

---

## 8. Webhooks

### 8.1 Configure Webhook
1. Go to Form Settings → Webhooks
2. Add webhook URL: `https://yoursite.com/api/form-webhook`
3. Select events: `submission.created`, `submission.updated`
4. Copy webhook secret for signature verification
5. Save

**Note:** Webhooks are sent from Cloudflare Workers with <10ms latency.

### 8.2 Handle Webhook (Node.js/Express)
```javascript
const express = require('express');
const crypto = require('crypto');
const app = express();

app.post('/api/form-webhook', express.raw({ type: 'application/json' }), (req, res) => {
  // Verify webhook signature (IMPORTANT!)
  const signature = req.headers['x-FormWeaver-signature'];
  const timestamp = req.headers['x-FormWeaver-timestamp'];
  
  if (!verifyWebhookSignature(signature, timestamp, req.body)) {
    console.error('Invalid webhook signature');
    return res.status(401).send('Unauthorized');
  }
  
  // Parse body
  const payload = JSON.parse(req.body.toString());
  const { event, data } = payload;

  // Handle events
  switch (event) {
    case 'submission.created':
      console.log('New submission:', data);
      // Send to CRM, email, database, etc.
      handleNewSubmission(data);
      break;
      
    case 'submission.updated':
      console.log('Submission updated:', data);
      break;
      
    default:
      console.log('Unknown event:', event);
  }

  // Respond quickly (Cloudflare Workers timeout after 30s)
  res.status(200).send('OK');
});

function verifyWebhookSignature(signature, timestamp, rawBody) {
  const secret = process.env.FormWeaver_WEBHOOK_SECRET;
  
  // Prevent replay attacks (reject if >5 minutes old)
  const age = Date.now() - parseInt(timestamp);
  if (age > 5 * 60 * 1000) {
    return false;
  }
  
  // Verify signature
  const payload = `${timestamp}.${rawBody}`;
  const hash = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(hash)
  );
}

async function handleNewSubmission(data) {
  // Send email via SendGrid, Resend, etc.
  await sendEmail({
    to: 'team@company.com',
    subject: 'New Form Submission',
    body: JSON.stringify(data.values, null, 2)
  });
  
  // Save to database
  await db.submissions.create({
    formId: data.formId,
    values: data.values,
    submittedAt: data.submittedAt
  });
  
  // Send to CRM (Salesforce, HubSpot, etc.)
  await crm.createContact(data.values);
}
```

### 8.3 Handle Webhook (Cloudflare Workers)
```typescript
// api/webhooks/FormWeaver.ts
import { Hono } from 'hono';

const app = new Hono();

app.post('/webhooks/FormWeaver', async (c) => {
  const signature = c.req.header('x-FormWeaver-signature');
  const timestamp = c.req.header('x-FormWeaver-timestamp');
  const rawBody = await c.req.text();
  
  // Verify signature
  const isValid = await verifySignature(
    signature,
    timestamp,
    rawBody,
    c.env.FormWeaver_WEBHOOK_SECRET
  );
  
  if (!isValid) {
    return c.json({ error: 'Invalid signature' }, 401);
  }
  
  const payload = JSON.parse(rawBody);
  const { event, data } = payload;
  
  // Handle event
  if (event === 'submission.created') {
    // Store in D1
    await c.env.DB.prepare(
      'INSERT INTO webhook_events (event, data, received_at) VALUES (?, ?, ?)'
    ).bind(event, JSON.stringify(data), Date.now()).run();
    
    // Trigger background task
    c.executionCtx.waitUntil(processSubmission(c.env, data));
  }
  
  return c.json({ received: true });
});

async function verifySignature(
  signature: string,
  timestamp: string,
  rawBody: string,
  secret: string
): Promise<boolean> {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );
  
  const payload = `${timestamp}.${rawBody}`;
  const signatureBuffer = await crypto.subtle.sign(
    'HMAC',
    key,
    encoder.encode(payload)
  );
  
  const hash = Array.from(new Uint8Array(signatureBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
  
  return signature === hash;
}
```

### 8.4 Webhook Payload
```json
{
  "event": "submission.created",
  "timestamp": "2025-11-16T12:34:56.789Z",
  "data": {
    "id": "sub_def456",
    "formId": "form_abc123xyz",
    "values": {
      "field_1": "John Doe",
      "field_2": "john@example.com",
      "field_3": "Hello, I would like to get in touch..."
    },
    "metadata": {
      "ip": "192.168.1.1",
      "userAgent": "Mozilla/5.0...",
      "referrer": "https://yoursite.com/contact",
      "submittedAt": "2025-11-16T12:34:56.789Z"
    }
  }
}
```

### 8.5 Webhook Retry Logic
If your endpoint returns a non-2xx status code:
- Retry after 1 minute
- Retry after 5 minutes
- Retry after 15 minutes
- Retry after 1 hour
- Give up after 24 hours

Monitor failed webhooks in dashboard → Settings → Webhooks → Failed Deliveries

---

## 12. Legal & Compliance for Marketplace

### 12.1 Creator Rights & Licensing
All embedded templates must display proper licensing information:

```html
<div class="formweaver-licensing-info">
  <p>Template by <a href="https://formweaver.com/creator/jane-doe">Jane Doe</a></p>
  <p>Creator Commission: 73% of template sales</p>
  <p>License: Single use per domain</p>
</div>
```

### 12.2 Revenue Sharing Transparency
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  licensing: {
    showCreatorEarnings: true,
    showPlatformFee: true,
    showCommissionRate: true,
    showUsageTerms: true,
    creatorRightsNotice: true
  }
});
```

**Required Disclosures:**
- Creator name and profile link
- Commission percentage (50-73% based on creator tier)
- License terms (single use, multi-domain, etc.)
- Platform fee structure
- Data retention policy

### 12.3 GDPR Compliance for Marketplace Data
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  gdprCompliance: {
    showDataRetentionNotice: true,
    enableRightToErasure: true,
    showLegalBasis: true,
    includeConsentCheckbox: true,
    retentionPeriod: '30 days'
  }
});
```

### 12.4 Industry-Specific Compliance
```javascript
// HIPAA-compliant medical forms
FormWeaver.render({
  formId: 'medical_form_abc',
  container: '#form-container',
  compliance: {
    industry: 'healthcare',
    hipaaCompliant: true,
    businessAssociateAgreement: true,
    dataEncryption: true,
    auditLogging: true,
    retentionPeriod: '7 years'
  }
});

// SOX-compliant financial forms
FormWeaver.render({
  formId: 'financial_form_xyz',
  container: '#form-container',
  compliance: {
    industry: 'financial',
    soxCompliant: true,
    auditTrail: true,
    dataIntegrity: true,
    retentionPeriod: '7 years'
  }
});
```

---

## 13. Analytics & Tracking

### 13.1 Google Analytics 4
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onLoad: () => {
    // Track form view
    gtag('event', 'form_view', {
      form_id: 'form_abc123xyz',
      form_name: 'Contact Form'
    });
  },
  onSubmit: (data) => {
    // Track form submission with creator attribution
    gtag('event', 'form_submit', {
      form_id: 'form_abc123xyz',
      form_name: 'Contact Form',
      submission_id: data.id,
      creator_id: data.templateCreatorId,
      template_id: data.templateId,
      creator_earnings: data.creatorEarnings
    });
    
    // Track template performance
    gtag('event', 'template_submission', {
      event_category: 'marketplace',
      event_label: data.templateId,
      value: data.creatorEarnings
    });
  },
  onChange: (fieldId, value) => {
    // Track field interactions
    gtag('event', 'form_field_change', {
      form_id: 'form_abc123xyz',
      field_id: fieldId
    });
  }
});
```

### 13.2 Plausible Analytics
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onSubmit: (data) => {
    // Track custom event in Plausible with creator info
    plausible('Form Submit', {
      props: {
        form: 'Contact Form',
        submissionId: data.id,
        creatorId: data.templateCreatorId,
        creatorCommission: data.creatorCommission
      }
    });
    
    // Track marketplace metrics
    plausible('Template Submission', {
      props: {
        templateId: data.templateId,
        creatorEarnings: data.creatorEarnings,
        platformFee: data.platformFee
      }
    });
  }
});
```

### 13.3 Segment
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onSubmit: (data) => {
    // Track in Segment with marketplace context
    analytics.track('Form Submitted', {
      formId: 'form_abc123xyz',
      formName: 'Contact Form',
      submissionId: data.id,
      fields: Object.keys(data.values),
      marketplace: {
        templateId: data.templateId,
        creatorId: data.templateCreatorId,
        creatorCommissionRate: data.creatorCommissionRate,
        creatorEarnings: data.creatorEarnings,
        platformFee: data.platformFee,
        licenseType: data.licenseType
      }
    });
    
    // Identify creator if applicable
    if (data.templateCreatorId) {
      analytics.identify(`creator_${data.templateCreatorId}`, {
        creatorId: data.templateCreatorId,
        creatorType: data.creatorType,
        totalEarnings: data.totalCreatorEarnings,
        templateCount: data.creatorTemplateCount
      });
    }
  }
});
```

### 13.4 Creator-Specific Analytics
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  onSubmit: (data) => {
    // Track creator attribution metrics
    console.log('Template metrics:', {
      creatorId: data.templateCreatorId,
      templateId: data.templateId,
      creatorEarnings: data.creatorEarnings,
      platformFee: data.platformFee,
      submissionTimestamp: Date.now()
    });
    
    // Send to creator analytics endpoint
    fetch('/api/creator/analytics', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        creatorId: data.templateCreatorId,
        templateId: data.templateId,
        eventType: 'submission',
        earnings: data.creatorEarnings,
        metadata: {
          userAgent: navigator.userAgent,
          referrer: document.referrer,
          timestamp: new Date().toISOString()
        }
      })
    });
  }
});
```

### 13.5 Custom Events
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  customCSS: `
    .form-field {
      margin-bottom: 24px;
    }
    .form-label {
      font-weight: 600;
      font-size: 14px;
      color: #374151;
      margin-bottom: 8px;
    }
    .form-input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #E5E7EB;
      border-radius: 8px;
      font-size: 16px;
      transition: all 0.2s;
    }
    .form-input:focus {
      outline: none;
      border-color: #3B82F6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
    .form-button {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border: none;
      padding: 14px 28px;
      border-radius: 8px;
      color: white;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      transition: transform 0.2s;
    }
    .form-button:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
    }
  `
});
```

### 14. Styling & Customization
```css
:root {
  /* Colors */
  --FormWeaver-primary: #3B82F6;
  --FormWeaver-primary-hover: #2563EB;
  --FormWeaver-text: #1F2937;
  --FormWeaver-text-muted: #6B7280;
  --FormWeaver-bg: #FFFFFF;
  --FormWeaver-bg-secondary: #F9FAFB;
  --FormWeaver-border: #E5E7EB;
  --FormWeaver-error: #EF4444;
  --FormWeaver-success: #10B981;
  
  /* Typography */
  --FormWeaver-font-family: 'Inter', -apple-system, sans-serif;
  --FormWeaver-font-size-sm: 14px;
  --FormWeaver-font-size-base: 16px;
  --FormWeaver-font-size-lg: 18px;
  
  /* Spacing */
  --FormWeaver-spacing-sm: 8px;
  --FormWeaver-spacing-md: 16px;
  --FormWeaver-spacing-lg: 24px;
  
  /* Border Radius */
  --FormWeaver-border-radius: 8px;
  --FormWeaver-border-radius-lg: 12px;
  
  /* Shadows */
  --FormWeaver-shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --FormWeaver-shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07);
  --FormWeaver-shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --FormWeaver-text: #F9FAFB;
    --FormWeaver-text-muted: #9CA3AF;
    --FormWeaver-bg: #111827;
    --FormWeaver-bg-secondary: #1F2937;
    --FormWeaver-border: #374151;
  }
}
```

### 9.3 Custom Classes
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  classNames: {
    container: 'my-form-container max-w-2xl mx-auto',
    field: 'my-field mb-6',
    label: 'my-label block text-sm font-semibold text-gray-700 mb-2',
    input: 'my-input w-full px-4 py-3 border border-gray-300 rounded-lg',
    textarea: 'my-textarea w-full px-4 py-3 border border-gray-300 rounded-lg',
    select: 'my-select w-full px-4 py-3 border border-gray-300 rounded-lg',
    button: 'my-button btn btn-primary bg-blue-600 text-white px-6 py-3 rounded-lg',
    error: 'my-error text-red-500 text-sm mt-1',
    successMessage: 'my-success bg-green-50 text-green-800 p-4 rounded-lg'
  }
});
```

### 9.4 Tailwind CSS Integration
```html
<!-- Include Tailwind CSS -->
<script src="https://cdn.tailwindcss.com"></script>

<div id="form-container"></div>

<script src="https://cdn.FormWeaver.app/sdk.min.js"></script>
<script>
  FormWeaver.render({
    formId: 'form_abc123xyz',
    container: '#form-container',
    classNames: {
      container: 'max-w-lg mx-auto p-6 bg-white rounded-xl shadow-lg',
      field: 'mb-6',
      label: 'block text-sm font-medium text-gray-700 mb-2',
      input: 'w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent',
      button: 'w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white font-semibold py-3 px-6 rounded-lg hover:shadow-lg transition-all duration-200',
      error: 'text-red-500 text-sm mt-1'
    }
  });
</script>
```

---

## 10. Security Best Practices

### 15.1 API Keys

**Public vs Private Keys:**
```javascript
// ✅ GOOD: Use public key for client-side (pk_live_...)
const apiKey = process.env.NEXT_PUBLIC_FormWeaver_API_KEY; // pk_live_xxx

// ✅ GOOD: Use private key for server-side only (sk_live_...)
const secretKey = process.env.FormWeaver_SECRET_KEY; // sk_live_xxx (NEVER expose to client!)

// ❌ BAD: Hardcode in client-side code
const apiKey = 'pk_live_abc123...'; // Exposed to users but OK for public keys
const secretKey = 'sk_live_xyz789...'; // NEVER DO THIS - exposed to users!
```

**Environment Variables:**
```bash
# .env.local (Next.js)
NEXT_PUBLIC_FormWeaver_API_KEY=pk_live_xxx # Exposed to client
FormWeaver_SECRET_KEY=sk_live_xxx # Server-side only

# .env (Vite)
VITE_FormWeaver_API_KEY=pk_live_xxx # Exposed to client
FormWeaver_SECRET_KEY=sk_live_xxx # Server-side only
```

### 10.2 CORS Configuration

In FormWeaver dashboard:
1. Go to Settings → Security → CORS
2. Add allowed domains:
   - `https://yoursite.com`
   - `https://www.yoursite.com`
   - `http://localhost:3000` (development)
3. Enable CORS for endpoints:
   - `GET /forms/:id` (fetch form schema)
   - `POST /f/:formId/submit` (submit form)

**Note:** Cloudflare Workers automatically handle CORS with edge-level security.

### 10.3 Rate Limiting

**Default Limits (enforced by Cloudflare Workers):**
- Public forms: 10 submissions per IP per 10 minutes
- Authenticated API: 100 requests per user per minute
- Webhook deliveries: 50 per endpoint per minute

**Monitor Usage:**
```javascript
// Check rate limit headers in response
const response = await fetch('https://api.FormWeaver.app/v1/f/form_abc123xyz/submit', {
  method: 'POST',
  body: JSON.stringify(data)
});

console.log('Rate Limit:', response.headers.get('X-RateLimit-Limit'));
console.log('Remaining:', response.headers.get('X-RateLimit-Remaining'));
console.log('Reset:', response.headers.get('X-RateLimit-Reset'));
```

**Upgrade for Higher Limits:**
- Business Plan: 100 submissions per IP per 10 minutes
- Enterprise Plan: Custom rate limits

### 15.4 CAPTCHA (Spam Protection)

**reCAPTCHA v3:**
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  captcha: {
    provider: 'recaptcha-v3',
    siteKey: '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
    action: 'submit_form',
    threshold: 0.5 // Minimum score (0-1)
  }
});
```

**hCaptcha:**
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  captcha: {
    provider: 'hcaptcha',
    siteKey: '10000000-ffff-ffff-ffff-000000000001'
  }
});
```

**Cloudflare Turnstile (Recommended):**
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  captcha: {
    provider: 'turnstile',
    siteKey: '1x00000000000000000000AA'
  }
});
```

### 15.5 Content Security Policy for Marketplace

**Enhanced CSP Headers for Marketplace:**
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' https://cdn.FormWeaver.app https://challenges.cloudflare.com https://js.stripe.com;
  connect-src 'self' https://api.FormWeaver.app https://api.stripe.com https://hooks.stripe.com;
  img-src 'self' data: https: blob:;
  style-src 'self' 'unsafe-inline' https://cdn.FormWeaver.app;
  frame-src https://forms.FormWeaver.app https://js.stripe.com;
  frame-ancestors 'none';
  object-src 'none';
  base-uri 'self';
">
```

### 15.6 Marketplace-Specific Security
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  security: {
    // Creator verification
    verifyCreatorSignature: true,
    checkTemplateIntegrity: true,
    
    // Payment security
    enableStripeElements: true,
    securePaymentFlow: true,
    
    // Data protection
    encryptSensitiveData: true,
    maskPII: false, // Show for legitimate business use
    
    // Fraud prevention
    enableCreatorFraudDetection: true,
    verifyTemplateOwnership: true
  }
});
```

---

## 16. Performance Optimization for Marketplace

### 16.1 Lazy Loading for Marketplace Assets
```javascript
// Load marketplace SDK only when needed
const marketplaceObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      loadMarketplaceSDK();
      marketplaceObserver.disconnect();
    }
  });
});

marketplaceObserver.observe(document.querySelector('#marketplace-container'));

function loadMarketplaceSDK() {
  const script = document.createElement('script');
  script.src = 'https://cdn.FormWeaver.app/marketplace-sdk.min.js';
  script.onload = () => {
    FormWeaverMarketplace.render({
      container: '#marketplace-container',
      lazyLoadTemplates: true,
      enableImageOptimization: true
    });
  };
  document.body.appendChild(script);
}
```

### 16.2 Preconnect to Marketplace APIs
```html
<head>
  <!-- Preconnect to marketplace services -->
  <link rel="preconnect" href="https://api.FormWeaver.app">
  <link rel="dns-prefetch" href="https://api.FormWeaver.app">
  <link rel="preconnect" href="https://marketplace.FormWeaver.app">
  <link rel="dns-prefetch" href="https://marketplace.FormWeaver.app">
  
  <!-- Preload critical marketplace assets -->
  <link rel="preload" href="https://cdn.FormWeaver.app/marketplace-sdk.min.js" as="script">
  <link rel="preload" href="https://cdn.FormWeaver.app/creator-avatars.css" as="style">
</head>
```

### 16.3 Edge Caching for Creator Content
```javascript
// Cache creator profiles and templates at edge
async function getCreatorContent(creatorId, templateId) {
  const cacheKey = `creator_${creatorId}_template_${templateId}`;
  const cached = await caches.match(cacheKey);
  if (cached) return cached.json();
  
  // Fetch creator and template data
  const [creatorResponse, templateResponse] = await Promise.all([
    fetch(`https://api.FormWeaver.app/v1/creators/${creatorId}`),
    fetch(`https://api.FormWeaver.app/v1/templates/${templateId}`)
  ]);
  
  const creatorData = await creatorResponse.json();
  const templateData = await templateResponse.json();
  
  // Cache for 30 minutes
  const cache = await caches.open('creator-content');
  cache.put(cacheKey, new Response(JSON.stringify({ creatorData, templateData })));
  
  return { creatorData, templateData };
}
```

### 16.4 Optimized Image Loading for Creator Avatars
```css
/* Lazy load creator avatars */
.creator-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  loading: lazy;
  background-color: #f3f4f6;
}

/* Progressive image loading */
.creator-avatar-placeholder {
  background: linear-gradient(45deg, #f3f4f6 25%, #e5e7eb 25%, #e5e7eb 50%, #f3f4f6 50%);
  background-size: 4px 4px;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% { background-position: -200px 0; }
  100% { background-position: calc(200px + 100%) 0; }
}
```

### 16.5 Template Bundle Optimization
```javascript
// Only load necessary template features
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#form-container',
  performance: {
    // Conditional feature loading
    loadCreatorAttribution: true,
    loadTemplateReviews: window.innerWidth > 768, // Only on desktop
    loadSimilarTemplates: true,
    loadPurchaseCTA: true,
    
    // Bundle optimization
    treeShakeUnusedFeatures: true,
    compressAssets: true,
    optimizeImages: true
  }
});
```

**Recommended CSP Headers:**
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' https://cdn.FormWeaver.app https://challenges.cloudflare.com;
  connect-src 'self' https://api.FormWeaver.app;
  img-src 'self' data: https:;
  style-src 'self' 'unsafe-inline' https://cdn.FormWeaver.app;
  frame-src https://forms.FormWeaver.app;
">
```

---

## 11. Analytics & Tracking

### 11.1 Google Analytics 4
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onLoad: () => {
    // Track form view
    gtag('event', 'form_view', {
      form_id: 'form_abc123xyz',
      form_name: 'Contact Form'
    });
  },
  onSubmit: (data) => {
    // Track form submission
    gtag('event', 'form_submit', {
      form_id: 'form_abc123xyz',
      form_name: 'Contact Form',
      submission_id: data.id
    });
  },
  onChange: (fieldId, value) => {
    // Track field interactions (optional)
    gtag('event', 'form_field_change', {
      form_id: 'form_abc123xyz',
      field_id: fieldId
    });
  }
});
```

### 11.2 Plausible Analytics
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onSubmit: (data) => {
    // Track custom event in Plausible
    plausible('Form Submit', {
      props: {
        form: 'Contact Form',
        submissionId: data.id
      }
    });
  }
});
```

### 11.3 Segment
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onSubmit: (data) => {
    // Track in Segment
    analytics.track('Form Submitted', {
      formId: 'form_abc123xyz',
      formName: 'Contact Form',
      submissionId: data.id,
      fields: Object.keys(data.values)
    });
    
    // Identify user if email provided
    if (data.values.email) {
      analytics.identify(data.values.email, {
        email: data.values.email,
        name: data.values.name
      });
    }
  }
});
```

### 11.4 Custom Events
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onLoad: () => console.log('✅ Form loaded'),
  onSubmit: (data) => console.log('✅ Form submitted', data),
  onChange: (fieldId, value) => console.log('📝 Field changed', fieldId, value),
  onError: (error) => console.error('❌ Form error', error),
  onValidationError: (errors) => console.log('⚠️ Validation failed', errors),
  onFocus: (fieldId) => console.log('👆 Field focused', fieldId),
  onBlur: (fieldId) => console.log('👋 Field blurred', fieldId)
});
```

---

## 12. Performance Optimization

### 12.1 Lazy Loading
```javascript
// Load SDK only when form is visible
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      loadFormWeaverSDK();
      observer.disconnect();
    }
  });
});

observer.observe(document.querySelector('#form-container'));

function loadFormWeaverSDK() {
  const script = document.createElement('script');
  script.src = 'https://cdn.FormWeaver.app/sdk.min.js';
  script.onload = () => {
    FormWeaver.render({
      formId: 'form_abc123xyz',
      container: '#form-container'
    });
  };
  document.body.appendChild(script);
}
```

### 12.2 Preconnect to API (faster first load)
```html
<head>
  <!-- Preconnect to Cloudflare Workers API -->
  <link rel="preconnect" href="https://api.FormWeaver.app">
  <link rel="dns-prefetch" href="https://api.FormWeaver.app">
  
  <!-- Preload SDK (optional) -->
  <link rel="preload" href="https://cdn.FormWeaver.app/sdk.min.js" as="script">
</head>
```

### 12.3 Cache Form Schema
```javascript
// Cache form schema in localStorage for 5 minutes
const CACHE_KEY = 'FormWeaver_schema_form_abc123xyz';
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

async function getFormSchema(formId) {
  // Check cache
  const cached = localStorage.getItem(CACHE_KEY);
  if (cached) {
    const { data, timestamp } = JSON.parse(cached);
    if (Date.now() - timestamp < CACHE_TTL) {
      return data;
    }
  }
  
  // Fetch from API (served from Cloudflare edge cache)
  const response = await fetch(`https://api.FormWeaver.app/v1/forms/${formId}`);
  const data = await response.json();
  
  // Cache it
  localStorage.setItem(CACHE_KEY, JSON.stringify({
    data,
    timestamp: Date.now()
  }));
  
  return data;
}
```

### 12.4 Edge Caching (Automatic)

Forms served from Cloudflare edge locations:
- Form schema cached at edge for 10 minutes
- Static assets cached for 1 year
- Global anycast network (300+ locations)
- Average latency: <50ms worldwide

**Cache Headers (automatically set by Workers):**
```
Cache-Control: public, max-age=600, s-maxage=600
CDN-Cache-Control: max-age=600
CF-Cache-Status: HIT
```

---

## 13. Troubleshooting

### 13.1 Form Not Loading

**Symptoms:** Blank container, no error messages

**Solutions:**
1. Check API key is valid (dashboard → Settings → API Keys)
2. Check form ID is correct
3. Check form status is "Published" (not Draft)
4. Check CORS settings (Settings → Security → CORS)
5. Open browser console for error messages
6. Verify network requests in DevTools (should see requests to `api.FormWeaver.app`)

**Debug Mode:**
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  debug: true // Enables verbose console logging
});
```

### 13.2 Submissions Not Saving

**Symptoms:** Form submits but no data in dashboard

**Solutions:**
1. Check form status is "Published"
2. Verify API key has write permissions (public keys can submit to published forms)
3. Check rate limits not exceeded (see error message)
4. Verify webhook endpoint is responding with 200 OK
5. Check browser console for errors
6. Test with API directly:
   ```bash
   curl -X POST https://api.FormWeaver.app/v1/f/form_abc123xyz/submit \
     -H "Content-Type: application/json" \
     -d '{"data":{"field_1":"test"}}'
   ```

### 13.3 Styling Issues

**Symptoms:** Form looks broken or unstyled

**Solutions:**
1. Check if custom CSS is overriding defaults
2. Verify CSS variables are set correctly
3. Check if iframe has correct width/height
4. Inspect elements with browser DevTools
5. Clear browser cache and hard reload (Ctrl+Shift+R)
6. Try disabling custom CSS to isolate issue

### 13.4 CORS Errors

**Symptoms:** Console shows "CORS policy" error

**Solutions:**
1. Add your domain to allowed origins (dashboard → Settings → Security)
2. Check protocol matches (http vs https)
3. Check subdomain matches exactly (www.site.com vs site.com)
4. For local development, add `http://localhost:3000`

### 13.5 Performance Issues

**Symptoms:** Slow loading, laggy interactions

**Solutions:**
1. Use CDN version of SDK (not NPM for faster delivery)
2. Enable lazy loading (load SDK only when needed)
3. Use edge caching (automatic with Cloudflare Workers)
4. Minimize custom CSS
5. Check network tab in DevTools for slow requests
6. Consider upgrading plan for higher performance tier

---

## 14. Migration Guides

### 14.1 From Typeform

**Step 1: Export Data**
```bash
# Export Typeform responses
curl https://api.typeform.com/forms/FORM_ID/responses \
  -H "Authorization: Bearer YOUR_TOKEN" > typeform_export.json
```

**Step 2: Create Form in FormWeaver**
1. Recreate form structure matching Typeform fields
2. Map field types:
   - Short Text → Text Input
   - Long Text → Textarea
   - Email → Email Input
   - Multiple Choice → Radio/Select
   - Opinion Scale → Range Slider

**Step 3: Import Submissions**
```javascript
// Convert and import submissions
const typeformData = require('./typeform_export.json');

for (const submission of typeformData.items) {
  await fetch('https://api.FormWeaver.app/v1/forms/YOUR_FORM_ID/submissions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${SECRET_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      data: convertTypeformSubmission(submission),
      metadata: {
        importedFrom: 'typeform',
        originalId: submission.token,
        submittedAt: submission.submitted_at
      }
    })
  });
}
```

**Step 4: Update Embed Code**
```html
<!-- Before (Typeform) -->
<div data-tf-widget="YOUR_FORM_ID"></div>
<script src="//embed.typeform.com/next/embed.js"></script>

<!-- After (FormWeaver) -->
<div id="form-container"></div>
<script src="https://cdn.FormWeaver.app/sdk.min.js"></script>
<script>
  FormWeaver.render({
    formId: 'form_abc123xyz',
    container: '#form-container'
  });
</script>
```

### 14.2 From Google Forms

**Step 1: Export Responses**
1. Open Google Form → Responses tab
2. Click three dots → Download responses (.csv)
3. Save as `google_forms_export.csv`

**Step 2: Import to FormWeaver**
1. Create matching form structure
2. Go to Submissions → Import
3. Upload CSV and map columns to fields
4. Review and confirm import

**Step 3: Update Links**
```html
<!-- Before (Google Forms) -->
<iframe src="https://docs.google.com/forms/d/e/FORM_ID/viewform?embedded=true"></iframe>

<!-- After (FormWeaver) -->
<iframe src="https://forms.FormWeaver.app/f/form_abc123xyz"></iframe>
```

### 14.3 From Wufoo

Similar process to Typeform:
1. Export Wufoo entries (CSV)
2. Create form in FormWeaver
3. Import submissions via CSV or API
4. Replace Wufoo embed code
5. Update webhook URLs

---

## 15. Advanced Patterns

### 15.1 Multi-Step Forms
```javascript
// Create multiple forms for each step
const steps = [
  'form_step1_abc',
  'form_step2_def',
  'form_step3_ghi'
];

let currentStep = 0;
let formData = {};

function renderStep(stepIndex) {
  FormWeaver.render({
    formId: steps[stepIndex],
    container: '#form-container',
    initialValues: formData,
    onSubmit: (data) => {
      // Save step data
      formData = { ...formData, ...data.values };
      
      if (stepIndex < steps.length - 1) {
        // Go to next step
        currentStep++;
        document.querySelector('#form-container').innerHTML = '';
        renderStep(currentStep);
      } else {
        // Final submission
        submitAllSteps(formData);
      }
    }
  });
}

renderStep(0);
```

### 15.2 Conditional Logic
```javascript
FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  onChange: (fieldId, value) => {
    const form = FormWeaver.getInstance('#app');
    
    // Show/hide fields based on values
    if (fieldId === 'country' && value === 'US') {
      form.setFieldVisibility('state', true);
      form.setFieldRequired('state', true);
    } else {
      form.setFieldVisibility('state', false);
      form.setFieldRequired('state', false);
    }
    
    // Show different fields based on selection
    if (fieldId === 'inquiry_type') {
      if (value === 'support') {
        form.setFieldVisibility('ticket_number', true);
      } else if (value === 'sales') {
        form.setFieldVisibility('company_size', true);
      }
    }
  }
});
```

### 15.3 A/B Testing
```javascript
// Randomly assign variant
const variant = Math.random() < 0.5 ? 'form_variant_a' : 'form_variant_b';

FormWeaver.render({
  formId: variant,
  container: '#app',
  onSubmit: (data) => {
    // Track which variant converted
    gtag('event', 'form_submit', {
      variant: variant,
      form_id: variant
    });
  }
});
```

### 15.4 Progressive Profiling
```javascript
// Only show fields user hasn't filled before
const userProfile = getUserProfile(); // From your database

const hiddenFields = Object.keys(userProfile).filter(key => 
  userProfile[key] !== null
);

FormWeaver.render({
  formId: 'form_abc123xyz',
  container: '#app',
  initialValues: userProfile,
  onLoad: (form) => {
    // Hide fields that are already filled
    hiddenFields.forEach(fieldId => {
      form.setFieldVisibility(fieldId, false);
    });
  }
});
```

---

## 16. Code Examples Repository

Find full working examples at:
- **GitHub:** [github.com/FormWeaver/examples](https://github.com/FormWeaver/examples)
- **CodeSandbox:** [codesandbox.io/FormWeaver](https://codesandbox.io/FormWeaver)
- **StackBlitz:** [stackblitz.com/@FormWeaver](https://stackblitz.com/@FormWeaver)

**Examples:**
- Next.js 14 App Router + Server Actions
- Next.js 14 Pages Router
- React + Vite + TypeScript
- Vue 3 + Vite + Composition API
- Nuxt 3 + Auto Imports
- SvelteKit
- Astro + Islands
- Vanilla JS + HTML
- WordPress plugin
- Shopify Liquid integration
- Webflow custom code
- Framer motion transitions

---

## 17. API Reference

**Base URL:** `https://api.FormWeaver.app/v1` (Cloudflare Workers global edge network)

**Authentication:**
```
Authorization: Bearer YOUR_API_KEY
```

**Endpoints:**
```
GET    /forms/:id                        # Get form schema
POST   /f/:formId/submit                 # Submit form (public)
GET    /forms/:id/submissions            # List submissions (auth required)
GET    /forms/:id/submissions/:subId     # Get single submission
DELETE /forms/:id/submissions/:subId     # Delete submission
GET    /forms/:id/submissions/export     # Export as CSV/JSON
POST   /forms                            # Create form (auth required)
PUT    /forms/:id                        # Update form
DELETE /forms/:id                        # Delete form
```

**Rate Limits:**
- 10 req/min per IP (public endpoints)
- 100 req/min per user (authenticated)
- Custom limits available (Enterprise plan)

**Full documentation:** [docs.FormWeaver.app/api](https://docs.FormWeaver.app/api)

---

## 18. Support & Resources

**Documentation:**
- Main Docs: [docs.FormWeaver.app](https://docs.FormWeaver.app)
- API Reference: [docs.FormWeaver.app/api](https://docs.FormWeaver.app/api)
- SDK Reference: [docs.FormWeaver.app/sdk](https://docs.FormWeaver.app/sdk)

**Community:**
- Discord: [discord.gg/FormWeaver](https://discord.gg/FormWeaver)
- GitHub Discussions: [github.com/FormWeaver/community](https://github.com/FormWeaver/community)
- Stack Overflow: Tag `FormWeaver-saas`

**Support:**
- Email: support@FormWeaver.app
- Chat: In-app chat (bottom right)
- Twitter: [@FormWeaver](https://twitter.com/FormWeaver)

**Status & Performance:**
- Status Page: [status.FormWeaver.app](https://status.FormWeaver.app)
- Cloudflare Network Status: [cloudflarestatus.com](https://cloudflarestatus.com)
- API Performance: 99.99% uptime, <50ms p99 latency globally

---

## 19. FAQ

**Q: Do I need an API key for public forms?**  
A: No, public (published) forms can be submitted without an API key. API keys are only needed for fetching form schemas or accessing private endpoints.

**Q: Where are my forms hosted?**  
A: Forms are served from Cloudflare's global edge network (300+ locations) for <50ms latency worldwide.

**Q: Can I use my own domain?**  
A: Yes! Business and Enterprise plans support custom domains (forms.yourdomain.com).

**Q: How do I migrate from another FormWeaver?**  
A: See Migration Guides section above. We provide import tools and support to help you migrate.

**Q: What happens if Cloudflare has an outage?**  
A: Cloudflare has 99.99%+ uptime. In rare outages, forms gracefully degrade and queue submissions for retry.

**Q: Can I self-host?**  
A: Not currently. FormWeaver is a managed SaaS built on Cloudflare Workers infrastructure.

**Q: Do you support GDPR/CCPA compliance?**  
A: Yes. See [docs.FormWeaver.app/privacy](https://docs.FormWeaver.app/privacy) for data handling and compliance information.

---

**Version:** 2.0 (Cloudflare Workers Edition)  
**Last Updated:** 2025-11-16  
**Next Update:** Q1 2026
