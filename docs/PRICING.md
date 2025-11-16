# Pricing Strategy
## Form Builder SaaS (Cloudflare Workers Edition)

**Last Updated:** 2025-11-16  
**Currency:** USD  
**Billing Cycle:** Monthly/Annual (annual = 2 months free)  
**Infrastructure:** Cloudflare Workers (low-cost, high-margin)

---

## 1. Pricing Philosophy

### 1.1 Core Principles
- **Usage-based with safety nets** - Predictable base cost + overages
- **Value metric alignment** - Price scales with customer success (form submissions)
- **Transparent pricing** - No hidden fees, clear overage costs
- **Land-and-expand** - Generous free tier to drive adoption
- **Fair to small and large** - Solopreneurs to enterprises
- **Edge-powered economics** - Pass Cloudflare's cost savings to customers

### 1.2 Target Metrics (Improved with Cloudflare)
- **CAC (Customer Acquisition Cost):** $150-300 (lower due to free tier generosity)
- **LTV (Lifetime Value):** $4,000-10,000
- **LTV:CAC Ratio:** 12:1 minimum (higher margins with Cloudflare)
- **Free to Paid Conversion:** 15-22% (better value prop)
- **Gross Margin:** 85-90% (Cloudflare's low infrastructure costs)

---

## 2. Pricing Tiers

### 2.1 Tier Overview

| Feature | Free | Prepaid | Pro | Business | Enterprise |
|---------|------|---------|-----|----------|------------|
| **Price** | $0/mo | Pay-as-you-go | $29/mo | $99/mo | Custom |
| **Forms** | 3 | Per-form pricing | Unlimited | Unlimited | Unlimited |
| **Submissions/month** | 100 | Pay per submission | 1,000 | 10,000 | Custom |
| **File storage** | 100 MB | Pay per GB | 5 GB | 50 GB | Custom |
| **Team members** | 1 | 1 | 3 | 10 | Unlimited |
| **Custom branding** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Custom domain** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **API access** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Webhooks** | ❌ | ✅ (1) | ✅ (10) | ✅ (50) | ✅ |
| **Priority support** | ❌ | Email | Email | Chat + Email | Dedicated manager |
| **SLA guarantee** | ❌ | 99.9% | 99.9% | 99.95% | 99.99% |
| **Custom elements** | ❌ | ✅ (Public) | ✅ (Public) | ✅ (Private) | ✅ (Private) |
| **SSO/SAML** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Audit logs** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **White-label** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Edge locations** | ✅ 300+ | ✅ 300+ | ✅ 300+ | ✅ 300+ | ✅ 300+ |
| **Global latency** | <50ms | <50ms | <50ms | <50ms | <50ms |

---

## 3. Detailed Tier Breakdown

### 3.1 Free Plan ($0/month)

**Target Audience:** 
- Individual developers testing the product
- Personal projects and portfolios
- Students and educators
- Weekend hackers

**Included:**
- 3 active forms
- 100 form submissions per month
- 100 MB file storage (R2)
- All 12 standard field types
- Basic analytics (last 30 days)
- Community support (Discord)
- "Powered by FormBuilder" badge
- **Served from Cloudflare edge (300+ locations)**
- **<50ms global latency**

**Limitations:**
- Cannot remove branding
- No API access
- No custom elements
- No team collaboration
- Data retained for 90 days
- Hard limits (submissions blocked after 100)

**Conversion Strategy:**
- Encourage upgrade at 80 submissions
- Show "Pro features" teaser in UI
- Offer Prepaid option: "Pay only $5 for 5 more forms, no subscription"
- After 3 forms: "Unlock unlimited forms for $29/mo or pay $2 per form"

---

### 3.2 NEW: Prepaid Plan (Pay-As-You-Go)

**Target Audience:**
- Occasional users who don't need monthly subscriptions
- Seasonal businesses (event registrations, holiday sales)
- Freelancers with irregular client work
- Users testing before committing to Pro
- Agencies with sporadic form needs

**How It Works:**
- **No monthly subscription** - Pay only for what you use
- **Credits never expire** - Use them whenever you need
- **Automatic or manual top-up** - Choose your billing style
- **No commitment** - Cancel anytime, keep unused credits

**Prepaid Pricing (Credit Packages):**

| Package | Forms | Submissions | Storage | Price | Price Per Form | Best For |
|---------|-------|-------------|---------|-------|----------------|----------|
| **Starter** | 5 forms | 500 submissions | 1 GB | $10 | $2.00/form | Testing, small projects |
| **Growth** | 15 forms | 2,000 submissions | 5 GB | $25 | $1.67/form | Freelancers, small agencies |
| **Scale** | 50 forms | 10,000 submissions | 20 GB | $75 | $1.50/form | Growing businesses |
| **Volume** | 150 forms | 50,000 submissions | 100 GB | $200 | $1.33/form | Agencies, high-volume users |

**What's Included:**
- **Unlimited active forms** (within purchased package)
- **Submissions** included in package ($0.01 per extra submission)
- **File storage** included in package ($2 per extra GB)
- **1 team member** (additional members: $5/mo each)
- **Remove "Powered by" badge**
- **API access** (50,000 requests included)
- **1 webhook endpoint** (additional: $5/mo each)
- **Custom elements** (from public marketplace)
- **Email support** (48-hour response time)
- **99.9% uptime SLA**
- **Data retained for 1 year**
- **Credits never expire** ✨

**How Billing Works:**

1. **Purchase Credits (Prepaid):**
   ```
   User buys $25 Growth package
   → Gets 15 form credits + 2,000 submission credits
   → Stored in account balance
   ```

2. **Use Forms (Burn Credits):**
   ```
   Create Form #1 → 1 form credit deducted (14 remaining)
   Receive 50 submissions → 50 submission credits deducted (1,950 remaining)
   ```

3. **Auto-Reload (Optional):**
   ```
   When balance drops below 20% (3 forms):
   → Automatically purchase another package
   → No interruption in service
   ```

4. **Manual Top-Up:**
   ```
   User can manually buy credits anytime
   → Choose any package
   → Credits added to existing balance
   ```

**Overage Rates (if credits depleted):**
- **Forms:** $2 per form (or buy new package)
- **Submissions:** $0.01 per submission
- **Storage:** $2 per GB/month

**Notifications:**
- **50% credits used:** "You've used 7 forms. Consider topping up."
- **80% credits used:** "Only 3 forms left. Enable auto-reload?"
- **100% credits used:** "Credits depleted. Purchase more to continue."

**Value Proposition:**
- **vs Pro ($29/mo):** Save $19/mo if you create <15 forms/month
- **vs Free:** Unlimited forms, remove branding, API access
- **vs Subscription:** No commitment, pay only when you need it

**Best For:**
- Event organizers (weddings, conferences) - buy credits before event season
- Freelancers with variable client work
- Seasonal businesses (tax prep, holiday sales)
- Users who create <15 forms per month
- Anyone who wants flexibility without subscriptions

---

### 3.3 Pro Plan ($29/month | $290/year)

**Target Audience:**
- Freelancers and consultants with regular clients
- Small businesses and startups
- Side projects with consistent users
- Developers building MVPs

**Everything in Prepaid, plus:**
- **Unlimited forms** (no per-form charges)
- **1,000 submissions/month** ($0.015 per extra submission)
- **5 GB file storage** ($3 per extra GB)
- **3 team members** ($5 per extra member)
- **Remove "Powered by" badge**
- **API access** (100,000 requests/month)
- **10 webhook endpoints**
- **Custom elements** (from public marketplace)
- **Email support** (24-hour response time)
- **99.9% uptime SLA**
- **Data retained for 1 year**

**Overage Pricing:**
- Submissions: $0.015 per submission ($15 per 1,000)
- Storage: $3 per GB/month
- Team members: $5 per member/month
- API requests: $5 per 100,000 requests

**Value Comparison:**
- **vs Prepaid:** Better value if you create 15+ forms/month
- **vs Business:** 10x cheaper for small teams
- Annual discount: Save $58/year (2 months free)

**Best Value Callout:**
- "Most popular for freelancers and small teams"
- "Best value for consistent usage"
- "Unlimited forms, predictable pricing"

---

### 3.4 Business Plan ($99/month | $990/year)

**Target Audience:**
- Growing startups with 10-50 employees
- Agencies managing multiple clients
- SaaS companies with embedded forms
- E-commerce platforms

**Everything in Pro, plus:**
- **10,000 submissions/month** ($0.01 per extra)
- **50 GB file storage** ($2 per extra GB)
- **10 team members** ($7 per extra member)
- **Custom domain** (forms.yourdomain.com via Cloudflare Workers)
- **Private custom elements** (not shared publicly)
- **Advanced analytics** (conversion funnels, drop-off analysis)
- **Conditional logic** (show/hide fields based on answers)
- **Multi-step forms** (wizard UI)
- **A/B testing** (split test form variations)
- **Priority email + chat support** (4-hour response time)
- **99.95% uptime SLA** (Cloudflare enterprise network)
- **White-label embeds** (remove all branding)
- **50 webhook endpoints**
- **Zapier/Make.com integrations**
- **Data retained indefinitely**

**Overage Pricing:**
- Submissions: $0.01 per submission ($10 per 1,000)
- Storage: $2 per GB/month
- Team members: $7 per member/month

**Best Value Callout:**
- "Recommended for growing teams"
- "Advanced features for conversion optimization"
- "White-label ready"
- Annual discount: Save $198/year

---

### 3.5 Enterprise Plan (Custom Pricing)

**Target Audience:**
- Enterprises with 100+ employees
- Government agencies
- Healthcare/finance with compliance needs
- High-volume users (>50k submissions/month)

**Everything in Business, plus:**
- **Custom submission limits** (negotiate volume discounts)
- **Custom storage limits** (up to 1 TB+ in R2)
- **Unlimited team members**
- **SSO/SAML authentication** (Okta, Azure AD)
- **Advanced security** (field-level encryption, HIPAA compliance)
- **Audit logs** (stored in D1, all user actions tracked)
- **Custom SLA** (up to 99.99% with penalties via Cloudflare)
- **Dedicated account manager**
- **Custom integrations** (Salesforce, HubSpot, custom APIs)
- **Training and onboarding** (up to 5 sessions)
- **Custom contract terms** (MSA, BAA, DPA)
- **24/7 phone support** (1-hour response time)
- **Dedicated Durable Object** (real-time collaboration)
- **Custom Cloudflare configuration**

**Pricing Model:**
- **Base:** $500-2,000/month (depends on volume)
- **Volume discounts:** 
  - 100k submissions/mo: $0.008 per submission
  - 500k submissions/mo: $0.005 per submission
  - 1M+ submissions/mo: $0.003 per submission
- **Implementation fee:** $5,000-25,000 (one-time)
- **Annual contracts required** (with quarterly invoicing)

**Cloudflare Benefits:**
- Leverage Cloudflare's 99.99% SLA
- Custom Workers configuration
- Dedicated edge locations if needed
- Direct Cloudflare support escalation

**Sales Process:**
- Contact sales form → Discovery call → Custom quote → Contract negotiation
- Minimum contract: $10,000/year

---

## 4. Add-On Pricing

### 4.1 Optional Add-Ons (All Paid Plans)

| Add-On | Prepaid | Pro | Business | Enterprise |
|--------|---------|-----|----------|------------|
| **Extra team member** | $5/mo | $5/mo | $7/mo | Included |
| **Extra 1,000 submissions** | $10 (one-time) | $15 | $10 | Custom |
| **Extra 1 GB storage** | $2/mo | $3/mo | $2/mo | Custom |
| **Priority support** | N/A | $49/mo | $29/mo | Included |
| **Dedicated IP** | N/A | N/A | $50/mo | $30/mo |
| **Advanced analytics** | $19/mo | $19/mo | Included | Included |
| **Custom element audit** | N/A | N/A | $200 (one-time) | Included |
| **Extra webhook** | $5/mo | Included | Included | Included |

### 4.2 Professional Services

| Service | Price | Turnaround |
|---------|-------|------------|
| **Custom integration** | $2,000-10,000 | 2-6 weeks |
| **Form migration** | $500-2,000 | 1-2 weeks |
| **White-label setup** | $1,000 | 1 week |
| **Custom training** | $500/session | On-demand |
| **Dedicated support** | $500/mo | Ongoing |
| **Cloudflare optimization** | $1,500 | 2 weeks |

---

## 5. Prepaid Credit System (Deep Dive)

### 5.1 Credit Types

**Form Credits:**
- 1 credit = 1 active form
- Used when form is created/published
- Refunded when form is deleted
- Never expire

**Submission Credits:**
- 1 credit = 1 form submission
- Deducted when submission is received
- Cannot be refunded (usage already consumed)
- Never expire

**Storage Credits:**
- Calculated monthly based on usage
- 1 GB = $2/month
- Deducted from main balance
- Prorated for partial months

### 5.2 Credit Purchase Flow

**Step 1: Choose Package**
```
User selects "Growth Package" ($25)
→ 15 form credits
→ 2,000 submission credits
→ 5 GB storage
```

**Step 2: Payment**
```
User enters credit card
→ Charge $25 via Stripe
→ Credits added to account immediately
→ Invoice sent to email
```

**Step 3: Confirmation**
```
Dashboard shows:
- Form Credits: 15
- Submission Credits: 2,000
- Storage: 5 GB included
- Next billing: Manual top-up
```

### 5.3 Auto-Reload Configuration

**Setup:**
```javascript
// User configures auto-reload
{
  enabled: true,
  threshold: 20%, // Reload when 20% remaining
  package: 'growth', // $25 package
  maxReloads: 10 // Safety limit per month
}
```

**Example Flow:**
```
Starting balance: 15 forms, 2,000 submissions

After usage: 3 forms remaining (20% threshold hit)
→ Trigger auto-reload
→ Charge $25
→ Add 15 more form credits (total: 18)
→ Email notification sent

If credit card fails:
→ Retry 3 times over 3 days
→ Disable auto-reload
→ Email urgent notification
```

### 5.4 Credit Expiration Policy

**Our Policy: Credits Never Expire** ✨

This is a key differentiator from competitors (e.g., OpenAI expires after 1 year).

**Why No Expiration?**
- Customers prefer predictability and don't want to lose pre-paid value
- Reduces customer frustration with overpaying for credits that expire
- Builds trust and loyalty
- Encourages larger upfront purchases

**Competitor Comparison:**
- **OpenAI:** Credits expire after 1 year, non-refundable
- **Mailchimp:** Email credits never expire
- **AWS:** Pay-as-you-go with no credits (post-paid)
- **FormBuilder (us):** Credits never expire ✅

### 5.5 Credit Refund Policy

**Form Credits:**
- Refunded when form is deleted/unpublished
- Automatically added back to balance
- Available for immediate reuse

**Submission Credits:**
- No refunds (usage already consumed)
- Once submission is recorded, credit is spent

**Package Refunds:**
- Within 14 days: Full refund of unused credits
- After 14 days: No refunds (but credits never expire)
- Exceptions reviewed case-by-case

### 5.6 Credit Notifications

**Low Balance Alerts:**
```
50% used: "You've used 7 of 15 form credits."
80% used: "Only 3 form credits left. Enable auto-reload?"
90% used: "Last chance: 1 form credit remaining."
100% used: "Out of credits. Top up now to create more forms."
```

**Usage Summary (Weekly Email):**
```
Subject: Your FormBuilder usage this week

Forms created: 3 (12 credits remaining)
Submissions received: 145 (1,855 credits remaining)
Storage used: 2.3 GB (2.7 GB remaining)

[Top up credits] [Enable auto-reload]
```

---

## 6. Usage-Based Overage Model

### 6.1 How Overages Work

**Example 1: Pro Plan User**
```
Base plan: $29/mo for 1,000 submissions
Month usage: 1,450 submissions
Overage: 450 × $0.015 = $6.75
Total bill: $29 + $6.75 = $35.75
```

**Example 2: Prepaid User**
```
Purchased: Growth package ($25) = 2,000 submission credits
Month usage: 2,300 submissions
Overage: 300 × $0.01 = $3
Options:
  A) Charge $3 to card
  B) Buy another package ($25)
User chooses B (better value)
Total spent: $25 (initial) + $25 (top-up) = $50
```

### 6.2 Soft vs Hard Limits

| Metric | Free | Prepaid | Pro | Business | Enterprise |
|--------|------|---------|-----|----------|------------|
| **Forms** | Hard (3 max) | Soft (pay per form) | Unlimited | Unlimited | Unlimited |
| **Submissions** | Hard (blocks at 100) | Soft (pay per extra) | Soft | Soft | Negotiated |
| **Storage** | Hard (blocks uploads) | Soft (pay per GB) | Soft | Soft | Negotiated |
| **API requests** | N/A | Soft | Soft | Soft | Negotiated |

---

## 7. Custom Element Marketplace

### 7.1 Revenue Share Model

**For Element Creators:**
- List custom elements on marketplace
- Set your own price: $5-200 per element
- **FormBuilder takes 20% commission**
- **Creator receives 80%** (paid monthly via Stripe Connect)

**Pricing Examples:**
- Simple star rating widget: $9
- Advanced signature pad: $29
- Payment input (Stripe integration): $49
- Custom chart builder: $99
- AI-powered autocomplete: $149

**Free Elements:**
- Creators can offer free elements (no commission)
- Good for portfolio building and community contributions
- Featured prominently in marketplace

### 7.2 Subscription Elements (Phase 3)
- Charge users monthly for access (e.g., $5/mo for premium widgets)
- FormBuilder takes 20% of subscription revenue
- Automatic billing and access management via D1 + Stripe

**Example:**
```
Creator lists "AI Form Analyzer" at $10/mo
User subscribes → $10 charged monthly
Creator earns: $8/mo (80%)
FormBuilder earns: $2/mo (20%)
```

---

## 8. Discounts & Promotions

### 8.1 Standard Discounts

| Discount Type | Amount | Eligibility |
|---------------|--------|-------------|
| **Annual billing** | 2 months free (16.7%) | All subscription plans |
| **Nonprofits** | 50% off | Verified 501(c)(3) orgs |
| **Education** | 50% off | Teachers, students (with .edu email) |
| **Startups** | 30% off year 1 | YC, Techstars, etc. alumni |
| **Referral** | $25 credits | Both referrer and referee |
| **First-time prepaid** | 20% bonus credits | First purchase only |

### 8.2 Prepaid Bonus Credits

**Volume Discounts:**
- Buy $50+ in credits: Get 10% bonus credits
- Buy $100+ in credits: Get 15% bonus credits
- Buy $250+ in credits: Get 20% bonus credits

**Example:**
```
User buys $100 in credits
→ Base: 75 form credits
→ Bonus: +11 form credits (15%)
→ Total: 86 form credits
```

### 8.3 Limited-Time Promotions

**Launch Promotion (First 3 months):**
- Prepaid: 30% bonus credits on first purchase
- Pro: $19/mo (save $10)
- Business: $79/mo (save $20)
- Lock in price for 1 year

**Black Friday/Cyber Monday:**
- 40% off annual plans
- 50% bonus on prepaid credit packages
- 3 months free on new subscriptions

**Product Hunt Launch:**
- Lifetime 20% discount for first 100 customers
- 100% bonus credits on first prepaid purchase

---

## 9. Pricing Comparison

### 9.1 Competitor Analysis

| Feature | FormBuilder (Prepaid) | FormBuilder (Pro) | Typeform (Basic) | Jotform (Bronze) | Tally (Pro) |
|---------|----------------------|-------------------|------------------|------------------|-------------|
| **Price** | $10-200 (credits) | $29/mo | $29/mo | $34/mo | $29/mo |
| **Model** | Pay-as-you-go | Subscription | Subscription | Subscription | Subscription |
| **Forms** | 5-150 (package) | Unlimited | Unlimited | 5 | Unlimited |
| **Submissions** | 500-50k (package) | 1,000/mo | 100/mo | 1,000/mo | Unlimited |
| **Storage** | 1-100 GB | 5 GB | 100 MB | 10 GB | 10 GB |
| **Credits expire?** | ❌ Never | N/A | N/A | N/A | N/A |
| **Remove branding** | ✅ | ✅ | ❌ ($59 plan) | ✅ | ✅ |
| **API access** | ✅ | ✅ | ❌ ($59 plan) | ✅ | ❌ |
| **Custom elements** | ✅ | ✅ | ❌ | Limited | ❌ |
| **Global edge** | ✅ <50ms | ✅ <50ms | ~200ms | ~150ms | ~100ms |
| **Best for** | Seasonal/occasional | Regular users | Design-focused | Power users | Simplicity |

**Value Proposition:**
- **vs Typeform:** 10x more submissions, API access, faster globally
- **vs Jotform:** Pay-as-you-go option, modern UI, edge performance
- **vs Tally:** More enterprise features, better for SaaS embedding
- **Unique:** Only form builder with non-expiring prepaid credits + edge performance

---

## 10. Cloudflare Cost Economics

### 10.1 Infrastructure Costs (per 1,000 customers)

| Component | Cloudflare Cost | Traditional Cost | Savings |
|-----------|----------------|------------------|---------|
| **Workers (API)** | $5/mo (10M req) | $200/mo (EC2 + ALB) | 97.5% |
| **D1 Database** | $5/mo (1M writes) | $50/mo (RDS) | 90% |
| **KV Storage** | $0.50/mo (1M reads) | $20/mo (Redis) | 97.5% |
| **R2 Storage** | $0.015/GB | $0.023/GB (S3) | 35% |
| **Bandwidth** | $0 (included) | $90/mo (AWS) | 100% |
| **Total** | ~$11/mo | ~$360/mo | **96.9%** |

### 10.2 Gross Margin Analysis

**Business Plan Customer ($99/mo):**
```
Revenue: $99/mo
COGS:
- Cloudflare Workers: $0.50
- D1 database: $1.20
- KV storage: $0.20
- R2 storage: $1.50
- Stripe fees: $3.00 (3%)
- Total COGS: $6.40

Gross Margin: $92.60 (93.5%)
```

**Traditional Infrastructure (Supabase):**
```
Revenue: $99/mo
COGS:
- Supabase Pro: $25/mo
- Extra database: $10/mo
- Extra bandwidth: $5/mo
- Stripe fees: $3.00
- Total COGS: $43.00

Gross Margin: $56.00 (56.6%)
```

**Savings with Cloudflare: 65% higher gross margin**

### 10.3 Pricing Power

Because of Cloudflare's economics, we can:
- **Offer more generous free tier** (100 submissions vs 10)
- **Lower prepaid prices** (competitive with subscriptions)
- **Higher margins** (reinvest in product, support, marketing)
- **Volume discounts** (still profitable at $0.003/submission)

---

## 11. Revenue Projections

### 11.1 Year 1 Targets (Updated with Prepaid)

| Month | Total | Free | Prepaid | Pro | Business | Enterprise | MRR | ARR |
|-------|-------|------|---------|-----|----------|------------|-----|-----|
| 1 | 150 | 100 | 30 | 15 | 5 | 0 | $1,230 | $14,760 |
| 3 | 750 | 500 | 150 | 75 | 20 | 5 | $9,210 | $110,520 |
| 6 | 2,500 | 1,800 | 400 | 200 | 80 | 20 | $39,210 | $470,520 |
| 12 | 8,000 | 5,500 | 1,200 | 800 | 400 | 100 | $162,600 | $1,951,200 |

**Assumptions:**
- Free to Prepaid conversion: 15% (higher than Pro due to low commitment)
- Prepaid to Pro conversion: 10% (after 3-6 months of usage)
- Pro to Business conversion: 10%
- Business to Enterprise: 8%
- Average Prepaid spend: $40/quarter ($13.33/mo equivalent)
- Average overage per Pro user: $12/mo
- Average Enterprise contract: $1,500/mo

### 11.2 Prepaid User Behavior Model

**Cohort Analysis (100 Prepaid Users):**
```
Month 1: 100 users buy $25 Growth package
  → Total revenue: $2,500
  → Average spend: $25/user

Month 2: 40 users top up $25
  → Total revenue: $1,000
  → Average spend: $10/user (across 100)

Month 3: 30 users top up, 20 upgrade to Pro
  → Prepaid revenue: $750
  → Pro MRR added: $580 (20 × $29)

Month 6: 50 remain on Prepaid, 30 on Pro, 20 churned
  → Prepaid revenue: $625 (avg $12.50/user)
  → Pro MRR: $870 (30 × $29)
```

**Key Insight:** Prepaid users spend less per month but:
- Higher conversion from Free (15% vs 10%)
- Lower churn (credits don't expire)
- Natural upgrade path to Pro
- Expand market to occasional users

---

## 12. Payment & Billing

### 12.1 Payment Methods
- **Credit/debit cards** (Visa, Mastercard, Amex) - Via Stripe
- **PayPal** (Pro and above)
- **ACH/wire transfer** (Enterprise only, annual contracts)
- **Invoicing** (Business and Enterprise, net 30 terms)
- **Apple Pay / Google Pay** (Prepaid purchases)

### 12.2 Billing Rules

**Subscriptions (Pro, Business):**
- Charges processed on the same day each month
- Overages billed at end of billing cycle
- Failed payments: 3 retry attempts over 7 days
- Downgrade takes effect at end of current billing period
- Upgrade takes effect immediately (prorated credit applied)

**Prepaid:**
- One-time charges when purchasing credits
- Auto-reload charged when threshold hit
- No recurring charges unless auto-reload enabled
- Failed auto-reload: 3 retries, then disabled

### 12.3 Refund Policy
- **Free plan:** N/A
- **Prepaid:** 14-day full refund on unused credits
- **Pro/Business:** 14-day money-back guarantee (first payment only)
- **Enterprise:** Custom terms in contract
- **Overages:** No refunds (usage already consumed)

---

## 13. Pricing Experiments (A/B Tests)

### 13.1 Test Ideas

**Test 1: Prepaid Pricing**
- Variant A: $25 Growth package (15 forms)
- Variant B: $20 Growth package (12 forms)
- Hypothesis: Lower price point drives higher conversion from Free

**Test 2: Credit Expiration Messaging**
- Variant A: "Credits never expire" (prominent badge)
- Variant B: No mention of expiration
- Hypothesis: Highlighting no-expiration increases prepaid conversion by 15%

**Test 3: Auto-Reload Default**
- Variant A: Auto-reload OFF by default
- Variant B: Auto-reload ON by default (with clear opt-out)
- Hypothesis: Default ON increases customer LTV by 25%

**Test 4: Pro Plan Price**
- Variant A: $29/mo
- Variant B: $39/mo (with 1,500 submissions instead of 1,000)
- Hypothesis: Higher price with more value increases perceived worth

**Test 5: Free Plan Limits**
- Variant A: 100 submissions/mo
- Variant B: 50 submissions/mo
- Hypothesis: Lower free tier drives faster upgrades to Prepaid

**Test 6: Annual Discount Messaging**
- Variant A: "2 months free" (16.7% off)
- Variant B: "Save $58/year"
- Hypothesis: Dollar savings messaging converts better than percentage

---

## 14. Pricing Iteration Plan

### 14.1 Phase 1 (Months 1-6): Customer Discovery
- Launch with current pricing (Free, Prepaid, Pro, Business, Enterprise)
- Track Prepaid adoption rate (target: 15% of Free users)
- Conduct 50+ customer interviews
- Monitor conversion rates at each tier
- Track prepaid user behavior (top-up frequency, upgrade paths)
- Analyze churn reasons (price sensitivity vs. missing features)

**Key Metrics to Watch:**
- Free to Prepaid conversion: Target 15%
- Prepaid to Pro conversion: Target 10% after 3 months
- Average Prepaid spend: Target $15/mo
- Credit usage patterns (forms vs submissions)

### 14.2 Phase 2 (Months 7-12): Optimization
- Test alternative prepaid packages (A/B tests)
- Optimize auto-reload thresholds (20% vs 30%)
- Introduce bonus credit promotions
- Launch custom element marketplace (20% commission)
- Test subscription + credits hybrid model

**Potential Hybrid Model:**
```
Pro + Credits Plan: $19/mo
- Base: 500 submissions included
- Buy additional credits as needed
- Best of both worlds
```

### 14.3 Phase 3 (Year 2+): Value-Based Pricing
- Introduce feature-based add-ons (conditional logic: $10/mo)
- Launch team/workspace pricing (per-workspace credits)
- Offer volume discounts for prepaid (bulk purchases)
- White-label prepaid option ($99/mo + credits)
- Enterprise pay-per-submission model (no base fee)

---

## 15. Prepaid Best Practices (Research-Based)

### 15.1 Industry Benchmarks

Based on SaaS prepaid models, successful implementations include non-expiring credits, clear balance visibility, and automatic low-balance notifications. Companies like Mailchimp (email credits) and Twilio (communication credits) have found success with transparent prepaid systems.

**Best Practices We're Implementing:**

1. **Credits Never Expire** ✅
   - Reduces customer anxiety about losing value
   - Encourages larger upfront purchases
   - Builds trust and loyalty

2. **Transparent Balance Display** ✅
   - Dashboard widget showing remaining credits
   - Usage graphs (daily/weekly/monthly)
   - Projected depletion date

3. **Smart Notifications** ✅
   - Proactive alerts at 50%, 80%, 90%, 100%
   - Weekly usage summaries
   - Personalized top-up recommendations

4. **Flexible Top-Up Options** ✅
   - Multiple package sizes ($10-$200)
   - Auto-reload with configurable thresholds
   - Manual top-up anytime
   - Gift credits to team members

5. **Fair Overage Handling** ✅
   - Soft limits (service continues)
   - Pay-as-you-go rates shown upfront
   - Option to buy package vs pay overage rate

6. **Clear Value Communication** ✅
   - Price per form clearly displayed
   - Savings vs subscription shown
   - "Best for" use case guidance

### 15.2 Common Pitfalls to Avoid

❌ **Expiring Credits**
- Creates negative customer experience
- Feels like "stealing" prepaid value
- High churn risk

❌ **Hidden Fees**
- Surprise overage charges without warning
- Unclear pricing tiers
- Complex credit calculations

❌ **Difficult Refunds**
- Making it hard to get money back
- No refund policy displayed
- Unreasonable restrictions

❌ **Poor UX**
- Hard to see balance
- Confusing credit types
- No usage history

**Our Solution:** Transparent, customer-friendly prepaid system with clear value and no nasty surprises.

---

## 16. Pricing Psychology

### 16.1 Anchoring
- Show Enterprise price first in sales materials ($2,000/mo) to make Business seem affordable
- Display annual savings prominently ("Save $198/year!")
- Show prepaid "per-form" cost vs subscription value

**Example:**
```
Prepaid: $2 per form
Pro: $29/mo for unlimited forms

Break-even: 15 forms/month
Message: "Create 15+ forms? Pro saves you money!"
```

### 16.2 Decoy Effect
- Make Business plan most attractive with "Most Popular" badge
- Position Prepaid as "flexible option" for occasional users
- Pro positioned as "best value" for regular users
- Enterprise positioned as "premium" with exclusive features

**Pricing Table Layout:**
```
[Free]    [Prepaid]         [Pro]              [Business]      [Enterprise]
$0        Pay-as-you-go     $29 ⭐ POPULAR    $99             Contact Sales
```

### 16.3 Grandfathering
- Early adopters lock in current pricing forever
- Creates urgency: "Lock in $29/mo before price increases to $39"
- Prepaid users: "Lock in $2/form pricing (may increase to $3)"
- Builds loyalty and reduces churn

### 16.4 Loss Aversion (Prepaid Specific)
- "Credits never expire" badge prominently displayed
- Compare to competitors: "Unlike [X], your credits never expire"
- Highlight saved vs spent: "You've saved $45 by using credits!"

---

## 17. Pricing Page Copy

### 17.1 Headline
**"Build forms at the edge. Pay only for what you use."**

### 17.2 Subheadline
"Start free with 100 submissions per month. Choose flexible prepaid credits or predictable subscriptions. Powered by Cloudflare's global network for <50ms latency worldwide."

### 17.3 Call-to-Actions

**Free Plan:**
- Button: "Start Building Free" (Primary)
- Below: "No credit card required"

**Prepaid Plan:**
- Button: "Buy Credits" (Secondary)
- Badge: "💳 No subscription"
- Below: "Credits never expire"

**Pro Plan:**
- Button: "Start Free Trial" (Primary)
- Badge: "⭐ Most Popular"
- Below: "14 days free, cancel anytime"

**Business Plan:**
- Button: "Start Free Trial" (Secondary)
- Badge: "🚀 For Teams"
- Below: "White-label ready"

**Enterprise Plan:**
- Button: "Contact Sales" (Outline)
- Badge: "🏢 Custom"
- Below: "Volume discounts available"

### 17.4 Social Proof
"Trusted by 8,000+ developers at companies like [Logos: Vercel, Supabase, Resend, Cal.com]"

### 17.5 Prepaid Section Copy

**Headline:** "Pay as you go. No commitment required."

**Subheadline:** "Perfect for seasonal projects, freelancers, and occasional users. Buy credits that never expire."

**Features:**
- ✅ Credits never expire
- ✅ No monthly subscription
- ✅ Auto-reload optional
- ✅ Start at just $10

**Comparison Table:**
```
┌─────────────────────────────────────────┐
│  When should I choose Prepaid vs Pro?  │
├─────────────────────────────────────────┤
│                                         │
│  Choose PREPAID if:                     │
│  • You create <15 forms per month       │
│  • You have seasonal/occasional needs   │
│  • You want no commitment               │
│  • You prefer pay-as-you-go             │
│                                         │
│  Choose PRO if:                         │
│  • You create 15+ forms per month       │
│  • You have consistent usage            │
│  • You want unlimited forms             │
│  • You prefer predictable billing       │
│                                         │
└─────────────────────────────────────────┘
```

---

## 18. Pricing FAQ

**Q: What happens when my prepaid credits run out?**  
A: You can manually purchase more credits or enable auto-reload. Your service continues with overage rates until you top up.

**Q: Do prepaid credits expire?**  
A: No! Your credits never expire. Use them whenever you need them.

**Q: Can I get a refund on unused prepaid credits?**  
A: Yes, within 14 days of purchase we'll refund unused credits. After 14 days, credits remain in your account indefinitely.

**Q: How does auto-reload work?**  
A: When your balance drops below your threshold (default 20%), we automatically purchase your selected package and add credits to your account.

**Q: Can I switch from Prepaid to Pro?**  
A: Yes! Unused prepaid credits remain in your account and can be used for overages or refunded.

**Q: What's the difference between Prepaid and Pro?**  
A: Prepaid is pay-as-you-go with no subscription. Pro gives you unlimited forms for a flat monthly fee. Prepaid is better for occasional use, Pro is better for consistent usage.

**Q: Can I upgrade or downgrade anytime?**  
A: Yes. Upgrades take effect immediately with prorated charges. Downgrades take effect at the end of your billing cycle.

**Q: What happens if I exceed my submission limit?**  
A: On Free plan, new submissions are blocked. On paid plans, overage charges apply at the published rates.

**Q: Do you offer refunds?**  
A: Yes, we offer a 14-day money-back guarantee on your first payment for Pro and Business plans, and 14 days on unused prepaid credits.

**Q: Can I cancel anytime?**  
A: Yes. Monthly plans can be canceled anytime. Annual plans can be canceled but no refunds are provided for unused months. Prepaid credits remain in your account.

**Q: Do form views count against my submission limit?**  
A: No. Only completed submissions count toward your limit.

**Q: What payment methods do you accept?**  
A: Credit/debit cards, PayPal, Apple Pay, Google Pay, and ACH/wire transfer for Enterprise customers.

**Q: Is there a setup fee?**  
A: No setup fees for Free, Prepaid, Pro, or Business plans. Enterprise plans may include implementation fees.

**Q: Why is FormBuilder faster than competitors?**  
A: We're built on Cloudflare's global edge network with 300+ locations worldwide, delivering <50ms latency anywhere. Traditional form builders run on centralized servers with 150-300ms latency.

**Q: What's included in the free tier?**  
A: 3 forms, 100 submissions/month, 100MB storage, basic analytics, community support, and access to all standard field types.

**Q: How do prepaid credits work with team members?**  
A: Each team member can use credits from the shared workspace pool. You can track individual usage in analytics.

---

## 19. Pricing Calculator (Interactive Tool)

### 19.1 Calculator Input

```
How many forms will you create per month?
[Slider: 0 - 100+]

How many submissions do you expect per month?
[Slider: 0 - 100k+]

How much file storage do you need?
[Slider: 0 - 100 GB]

How many team members?
[Slider: 1 - 20+]

Do you need white-label/custom domain?
[Toggle: Yes/No]
```

### 19.2 Calculator Output

```
┌──────────────────────────────────────────┐
│         Recommended Plan: PRO            │
├──────────────────────────────────────────┤
│  Monthly Cost: $29                       │
│  Includes:                               │
│  ✅ Unlimited forms                      │
│  ✅ 1,000 submissions                    │
│  ✅ 5 GB storage                         │
│  ✅ 3 team members                       │
│                                          │
│  Your projected usage:                   │
│  📊 30 forms/month (covered)             │
│  📊 800 submissions (covered)            │
│  📊 2 GB storage (covered)               │
│  📊 2 team members (covered)             │
│                                          │
│  [Start 14-day free trial]               │
└──────────────────────────────────────────┘

Alternative: Prepaid ($45/quarter)
→ Better if usage varies month-to-month
→ No commitment required

Alternative: Business ($99/mo)
→ Needed for white-label/custom domain
→ Includes advanced analytics
```

---

## 20. Revenue Optimization Strategies

### 20.1 Upsell Triggers

**Free → Prepaid:**
- Trigger: 80% of submission limit used
- Message: "Need 5 more forms? Get started with $10 in credits"
- CTA: "Buy Credits" (green button)

**Prepaid → Pro:**
- Trigger: 3 months of consistent usage (15+ forms/month)
- Message: "You're using $40/mo in credits. Save 27% with Pro at $29/mo"
- CTA: "Upgrade to Pro" (highlighted)

**Pro → Business:**
- Trigger: 8,000+ submissions/month (80% of limit)
- Message: "Avoid overages. Business plan saves you $25/mo"
- CTA: "Upgrade to Business"

**Business → Enterprise:**
- Trigger: 50,000+ submissions/month
- Message: "Volume discounts available. Let's chat."
- CTA: "Contact Sales"

### 20.2 Retention Strategies

**At-Risk Customer (Low Usage):**
- If Pro user creates <5 forms/month for 2 months
- Message: "Not using FormBuilder much? Switch to Prepaid and save."
- Offer: Downgrade to Prepaid, refund prorated amount

**Churn Prevention:**
- Exit survey: "Why are you leaving?"
- Offer: 50% off for 3 months, or pause subscription
- Win-back: "We miss you! Here's $25 in credits to come back"

**Expansion Revenue:**
- Feature upsells: "Add conditional logic for $10/mo"
- Team member upsells: "Invite another team member for $5/mo"
- Storage upsells: "Need more space? Add 10 GB for $25/mo"

### 20.3 Seasonal Promotions

**Q4 (Holiday Season):**
- Black Friday: 40% off annual plans
- Cyber Monday: 50% bonus on prepaid credits
- Gift credits: "Give the gift of forms" (purchase credits for others)

**Q1 (New Year):**
- January: "New Year, New Forms" - 30% off first month
- Prepaid: "Resolution Ready" - 25% bonus credits

**Q2-Q3 (Mid-Year):**
- Summer: "Build Cool Forms" - Free upgrade to Business for 1 month
- Back to School: 50% off for .edu emails

---

## 21. Competitive Positioning

### 21.1 Positioning Statement

**For** SaaS developers and growing businesses  
**Who** need fast, embeddable forms with flexible pricing  
**FormBuilder** is a form builder  
**That** delivers <50ms global latency and pays-as-you-grow pricing  
**Unlike** Typeform, Jotform, and Google Forms  
**We** offer edge performance + prepaid flexibility + unlimited extensibility

### 21.2 Key Differentiators

1. **Edge Performance** (Cloudflare Workers)
   - <50ms latency worldwide
   - 99.99% uptime SLA
   - Zero cold starts

2. **Flexible Pricing** (Only one with prepaid + subscriptions)
   - Credits never expire
   - Pay-as-you-go option
   - Predictable subscriptions

3. **Developer-First** (Custom elements, APIs, SDKs)
   - Custom element marketplace
   - React, Vue, vanilla JS SDKs
   - Headless API mode

4. **Cost-Effective** (Cloudflare economics)
   - 50% cheaper than Typeform
   - Better value than Jotform
   - More features than Tally

---

## 22. Pricing Governance

### 22.1 Price Change Policy

**Subscription Plans:**
- Existing customers grandfathered at current price
- New customers pay new price
- 90-day notice for price increases
- Email notification to all customers

**Prepaid Plans:**
- Existing credits honored at purchase price
- New credit packages at new price
- No retroactive price changes

**Example:**
```
April 1: Pro plan increases from $29 to $39
- Current Pro users: Stay at $29 forever
- New Pro users: Pay $39
- Grandfathered badge in dashboard
```

### 22.2 Discount Approval Matrix

| Discount | Amount | Approval Required |
|----------|--------|-------------------|
| Standard (annual, nonprofit) | Up to 50% | Automatic |
| Sales discretionary | 10-25% | Sales manager |
| Large deals | 25-40% | VP Sales |
| Strategic partnerships | 40%+ | CEO |

### 22.3 Pricing Committee

**Members:**
- CEO (final approval)
- CFO (financial modeling)
- VP Product (value analysis)
- VP Sales (market feedback)
- VP Engineering (cost analysis)

**Meeting Cadence:**
- Monthly: Review metrics, discuss experiments
- Quarterly: Major pricing decisions
- Annually: Full pricing strategy review

---

## 23. Success Metrics Dashboard

### 23.1 Key Metrics to Track

**Acquisition:**
- Free signups per month
- Free to paid conversion rate (overall)
- Free to Prepaid conversion rate
- Free to Pro conversion rate

**Revenue:**
- MRR (Monthly Recurring Revenue)
- ARR (Annual Recurring Revenue)
- ARPU (Average Revenue Per User) by tier
- Prepaid average purchase size
- Prepaid top-up frequency

**Retention:**
- Logo churn rate (% customers lost)
- Revenue churn rate ($ lost)
- Net revenue retention (expansion - churn)
- Prepaid user activity rate

**Expansion:**
- Upgrade rate (Prepaid → Pro → Business)
- Cross-sell rate (add-ons purchased)
- Average prepaid credit balance
- Team member add-on attachment rate

### 23.2 Target Dashboard (Month 12)

```
┌─────────────────────────────────────────────────┐
│  FormBuilder Pricing Dashboard - Nov 2026      │
├─────────────────────────────────────────────────┤
│  Total Customers: 8,000                         │
│  ├─ Free: 5,500 (69%)                          │
│  ├─ Prepaid: 1,200 (15%)                       │
│  ├─ Pro: 800 (10%)                             │
│  ├─ Business: 400 (5%)                         │
│  └─ Enterprise: 100 (1%)                       │
│                                                 │
│  MRR: $162,600                                  │
│  ├─ Prepaid: $16,000 (10%)                     │
│  ├─ Pro: $23,200 (14%)                         │
│  ├─ Business: $39,600 (24%)                    │
│  ├─ Enterprise: $150,000 (52%)                 │
│  └─ Add-ons & Overages: $33,800 (21%)          │
│                                                 │
│  Conversion Rates:                              │
│  ├─ Free → Prepaid: 15% ✅                     │
│  ├─ Free → Pro: 10% ✅                         │
│  ├─ Prepaid → Pro: 12% ✅                      │
│  └─ Pro → Business: 10% ✅                     │
│                                                 │
│  Retention:                                     │
│  ├─ Logo Churn: 4.2% ✅                        │
│  ├─ Revenue Churn: 2.8% ✅                     │
│  └─ NRR: 115% ✅                               │
└─────────────────────────────────────────────────┘
```

---

**Last Updated:** 2025-11-16  
**Next Review:** 2025-12-16 (monthly pricing committee)  
**Version:** 2.0 (Cloudflare + Prepaid Edition)
