# Business Plan — CraftPrice: Pricing Intelligence for Handmade Sellers

> **Reference Example** — This is a fictional but realistic business plan produced by this skill. Use it to calibrate the expected depth, tone, and structure of each section. The business, founder, and all figures are illustrative only.
>
> **Context:** Solo developer with a former side-hustle background in handmade goods selling. US-based, English-speaking market, no existing audience. Business direction chosen after a full decision questionnaire session.
>
> **Version:** v0.1.0
> **Status:** Ideation
> **Last updated:** 2025-09-12
> **Owner:** Solo founder

<!--
Version scheme: major.minor.patch
  major — significant business pivot or full restructure
  minor — new section added or major content update
  patch — corrections, small clarifications, decision log entries
-->

---

## 1. Snapshot

CraftPrice is a SaaS pricing and profit analysis tool for Etsy and independent handmade goods sellers. It calculates true profit margins per product (accounting for materials, time, platform fees, and shipping) and benchmarks those prices against current market rates for similar listings. Fully remote operation, US-first. Distribution through Etsy seller Facebook groups and YouTube content — no paid advertising. The free tier functions as both the product and the top-of-funnel.

**One-liner:** *The pricing tool that tells handmade sellers what to charge — and whether they are actually making money.*

---

## 2. Problem & Opportunity

### The pain (seller side)

- Handmade sellers chronically underprice their work. The standard mistake: price = materials cost × 2, ignoring time, overhead, platform fees, and shipping labor.
- Generic spreadsheet templates circulated in Facebook groups are not Etsy-aware — they do not account for Etsy's transaction fee (6.5%), listing fee ($0.20), payment processing (3% + $0.25), or Etsy Ads ROI.
- Existing tools (Marmalead, eRank) solve Etsy SEO and keyword ranking. None solve the pricing and profitability problem specifically.

### The pain (business growth side)

- Sellers who underprice cannot scale — every sale they make at volume loses more money. They burn out and close their shops.
- There is no clear feedback loop: sellers do not know if a shop is profitable until they have already lost months of earnings.

### The market signal

- **7.5M+ active Etsy sellers** globally as of 2024; US accounts for the largest share.
- Etsy's annual GMV exceeded **$13.2B in 2023** — the underlying commerce is real.
- A widely-cited Etsy seller survey found **65% of sellers report not paying themselves a livable wage** from their shop, despite significant time investment.
- Competitor tools Marmalead and eRank each have **100K+ paid subscribers** at $19–29/month, proving willingness to pay for Etsy-specific tools in this niche.

---

## 3. Solution

Two integrated features, each mapping directly to a stated pain:

### Feature A — True Cost and Profit Calculator

- Seller inputs: materials (with saved ingredient library), time at a custom hourly rate, packaging, Etsy fees (auto-calculated from current fee schedule), shipping labor.
- Output: true cost per unit, minimum viable price, profit margin at any given sale price.
- Etsy fee schedule is maintained in the product and updated when Etsy changes fees — sellers do not need to track this themselves.

### Feature B — Market Rate Benchmark

- Using Etsy's public listing search API, pulls current sold and active listing prices for a seller-defined search query (e.g., "hand-poured soy candle 8oz").
- Displays the price range distribution (p25, median, p75) so the seller can position their product relative to the market.
- No Etsy account connection required at MVP — public listing data only.

---

## 4. Target Market

### Primary (B2C)

| Segment | Description | Size signal |
|---|---|---|
| **Serious part-time Etsy sellers** | Sellers treating their shop as a second income, not a pure hobby. Have 10–200 active listings. Want to grow but are not yet full-time. | Estimated 2–3M of the 7.5M total active sellers |
| **New shop owners** | Sellers in their first 6–18 months who have not yet established pricing habits. High receptiveness to tools. | ~500K new shops opened annually on Etsy |

### Secondary (B2B, later)

| Segment | Description |
|---|---|
| **Etsy business coaches** | Individual coaches and course creators teaching Etsy shop growth. Will recommend or white-label CraftPrice to students. |
| **Craft supply brands** | Brands (e.g., candle wax suppliers, yarn companies) that support a community of makers and want a tool to offer as a value-add. |

### Out of scope (for now)

- Full-time professional craft businesses with dedicated accounting software (they need QuickBooks, not this)
- Non-Etsy platforms (Amazon Handmade, Faire, Shopify) — can be added in Phase 3 if Etsy traction is proven
- Physical retail pricing (entirely different cost structure and margin dynamics)

---

## 5. Unique Value Proposition

**For sellers:**
> "Enter your materials and time — get back what you should be charging on Etsy, and whether your shop is actually profitable."

**For coaches (B2B):**
> "Give your students the pricing tool you wish existed when you started — white-labeled under your brand."

---

## 6. Unfair Advantages

| Advantage | Why it cannot be quickly replicated |
|---|---|
| **Community pricing benchmarks** | As more sellers enter their cost data, aggregated benchmarks improve. This data flywheel strengthens with each user and takes time to accumulate regardless of funding. |
| **Etsy-specific fee depth** | Etsy's fee structure (listing, transaction, payment processing, offsite ads, Etsy Ads) is complex and changes regularly. Building accurate, maintained models for all cases requires domain investment that general tools skip. |
| **Seller community distribution** | Etsy seller Facebook groups have millions of engaged members actively asking "how do I price this?" — a ready-made audience. Trust in this community is earned through helpful posts, not bought through ads. |
| **Founder domain experience** | Prior personal experience as an Etsy seller creates authentic product decisions and credibility in community outreach. Cannot be faked or replicated by an outsider quickly. |

---

## 7. Product

### Feature breakdown

| Feature | MVP | Phase 2 | Phase 3 |
|---|---|---|---|
| Cost builder (materials, time, fees, shipping) | ✅ | | |
| True profit margin output | ✅ | | |
| Etsy fee auto-calculation (current schedule) | ✅ | | |
| Market rate benchmark (public Etsy listing search) | ✅ | | |
| Saved ingredient/materials library | | ✅ | |
| Saved product library (multiple SKUs) | | ✅ | |
| Revenue tracker (actual sales vs. projected) | | ✅ | |
| Bulk repricing analysis | | ✅ | |
| Etsy shop OAuth integration (pull live listings) | | | ✅ |
| Competitive pricing alerts | | | ✅ |
| Amazon Handmade / Faire support | | | ✅ |
| White-label for coaching brands | | | ✅ |

### Pricing tiers

| Tier | Price | Target | Key features |
|---|---|---|---|
| **Free** | $0 | New sellers, casual users | 5 product calculations/month, basic market benchmark |
| **Pro** | $12/month | Serious part-time sellers | Unlimited calculations, full benchmark, saved libraries, revenue tracker |
| **Studio** | $39/month | Full-time sellers, multi-shop owners | Multiple shops, team access, bulk analysis, export reports |

---

## 8. Business Model

### Revenue streams

1. **Subscription (primary):** Pro and Studio monthly subscriptions via Stripe.
2. **Future — affiliate partnerships:** Link materials in the cost builder to supplier partners (e.g., CandleScience, Lion Brand Yarn) and earn affiliate commission on purchases.
3. **Future — white-label licensing:** Etsy coaching brands license the tool under their name for their student communities.

### Cost structure

| Item | Monthly cost | Notes |
|---|---|---|
| Vercel (frontend) | $0 | Free tier sufficient for early stage |
| Supabase (DB + auth) | $0 → $25 | Free tier covers ~50K MAU |
| Fly.io (Go backend) | $0 → $10 | Free allowance covers early traffic |
| Etsy API | $0 | Free to use; requires app registration |
| Domain + misc | ~$2 | Annual amortized |
| **Total MVP running cost** | **~$0–$37/month** | Covered by 3–4 Pro subscribers |

### Break-even

| Milestone | Requirement |
|---|---|
| Cover costs | 3–4 Pro subscribers |
| $5,000 MRR | 415 Pro OR 128 Studio OR blended mix |
| $20,000 MRR | 1,665 Pro OR 515 Studio OR blended mix |

---

## 9. Competitive Landscape

| Competitor | Strength | Weakness | Our edge |
|---|---|---|---|
| **Marmalead** | Market leader for Etsy SEO; 100K+ subscribers | Solves keyword ranking, not pricing or profitability | Dedicated pricing focus; complementary, not competing |
| **eRank** | Affordable Etsy analytics; large user base | Analytics-only; no cost/profit calculator | Deeper on pricing; clear differentiation |
| **Craftybase** | Inventory and COGS tracking for makers | Complex setup; targets production businesses; expensive ($49/month+) | Simpler UX; Etsy-native; lower entry price |
| **Excel/Google Sheets templates** | Free; widely shared in Facebook groups | Not Etsy-aware; no market data; manual maintenance | Automated fees; live market rates; saved libraries |
| **Pricing calculators (generic)** | Simple, free | Not handmade or Etsy-specific; no market context | Deep Etsy domain knowledge in every calculation |

**Key gap:** No tool in the market specifically solves the profitability and pricing decision problem for Etsy handmade sellers, combining true cost accounting with live market rate context.

---

## 10. Go-to-Market Strategy

### Principles

- Zero paid advertising.
- The content is the product demo — showing the output publicly creates demand.
- Distribution is through trust, not reach: Etsy seller communities reward genuine help over promotion.

### Phase 1 — First 200 users (Month 1–2)

1. **Facebook group posts:** Join the top 10 Etsy seller Facebook groups (combined membership: 2M+). Post a free "Is your Etsy shop profitable?" guide with a link to the free tier. No hard selling.
2. **Free tool as lead magnet:** The free tier (5 calculations/month) is the acquisition hook. Users hit the limit and convert.
3. **Reddit:** Post in r/Etsy and r/EtsySellers with a genuine "I built this because I had this problem" story. These communities respond well to authentic founder stories.

### Phase 2 — Organic growth (Month 3–6)

- **YouTube content:** "I analyzed 100 Etsy candle listings — here's the pricing data" — this style of content goes viral in the niche. The market benchmark feature generates the data; the video markets the product.
- **Pinterest:** Etsy sellers are heavy Pinterest users. Pricing tip infographics linking back to the tool drive evergreen traffic.
- **Email list:** Capture emails from free tier users; send bi-weekly "Etsy pricing insight" newsletter. Newsletter itself is the retention tool.

### Phase 3 — B2B coaching partnerships (Month 6+)

- Identify the top 20 Etsy business coaches on YouTube and Instagram with 50K+ followers.
- Offer a 6-month free Studio account in exchange for a mention in one video or course.
- Once 2–3 coaches are recommending it, referral traffic compounds.

---

## 11. Technical Architecture

### Stack

| Layer | Technology | Reason |
|---|---|---|
| Frontend | TypeScript + React + shadcn/ui | Modern visual components; fast to build calculation UIs |
| Backend | Go (Gin) | Founder's strongest language; performant for concurrent API requests to Etsy |
| Database | Supabase (PostgreSQL via pgx) | Free tier; handles auth, user data, saved libraries |
| Auth | Supabase Auth | Free; supports Google and email/password login |
| Deployment (frontend) | Vercel | Free tier; zero-config |
| Deployment (backend) | Fly.io | Free allowance; low latency for US users |
| Payments | Stripe | Native USD billing; handles subscriptions and free trials |

### Data sources

| Source | Access | Purpose | Key constraint |
|---|---|---|---|
| **Etsy Open API v3** | Free; app registration required; OAuth for shop data | Market rate benchmark (public listings); future shop integration | Rate limit: 10 req/sec per key; public listing data only without user OAuth |
| **Etsy fee schedule** | Manually maintained in app config | Accurate fee calculation | Etsy changes fees periodically — must monitor announcements |
| **User-entered cost data** | Owned; stored in Supabase | Cost builder inputs, saved ingredient library | PII handled per Stripe and Supabase data policies |

### Etsy API compliance checklist

- [ ] Register application at developer.etsy.com
- [ ] Use only public listing endpoints for market benchmark at MVP (no user OAuth required)
- [ ] Apply for production API access before public launch
- [ ] Do not cache or republish raw Etsy listing data beyond what the API terms permit
- [ ] Include Etsy attribution where listing data is displayed
- [ ] Implement OAuth flow correctly before Phase 3 shop integration

---

## 12. Roadmap

### Phase 0 — Validation (Week 1–2)

- [ ] Build a Google Sheets prototype of the cost calculator with Etsy fees hardcoded
- [ ] Share in 3 Facebook groups — count how many people ask for a link to "the tool"
- [ ] Manually pull 50 Etsy listings in a single category — validate that price range data is meaningful
- [ ] Post a Reddit thread: "What pricing tool do you wish existed for your Etsy shop?" — read responses

### Phase 1 — MVP (Week 3–8)

- [ ] Cost builder UI (materials, time input, fee auto-calculation)
- [ ] Profit margin output display
- [ ] Market rate benchmark (Etsy API public listing search + p25/median/p75 display)
- [ ] Free tier gate (5 calculations/month)
- [ ] Email capture on free tier signup
- [ ] Stripe Pro subscription ($12/month)
- [ ] Basic landing page with pricing

### Phase 2 — Retention & Growth (Week 9–16)

- [ ] Saved ingredient library (persistent, per user)
- [ ] Saved product library (multiple SKUs per user)
- [ ] Revenue tracker (seller inputs actual sales; compares to projected margin)
- [ ] Email newsletter (bi-weekly Etsy pricing insight)
- [ ] Studio tier ($39/month) with multi-shop and export
- [ ] YouTube video: "I analyzed 500 Etsy listings — here's the pricing data"

### Phase 3 — B2B (Month 5+)

- [ ] Etsy shop OAuth integration (pull live listings automatically)
- [ ] Bulk repricing analysis (flag listings below minimum viable price)
- [ ] White-label configuration for coaching brand partners
- [ ] Affiliate link integration in materials cost builder
- [ ] Amazon Handmade fee schedule support

---

## 13. Financial Projections

> These are directional estimates, not forecasts. Revise as real data comes in.

### Conservative scenario (Month 6)

| Metric | Value |
|---|---|
| Pro subscribers | 200 |
| Studio subscribers | 10 |
| MRR | $2,400 + $390 = $2,790 |
| Monthly costs | ~$37 |
| Net | ~$2,750 |

### Moderate scenario (Month 12)

| Metric | Value |
|---|---|
| Pro subscribers | 800 |
| Studio subscribers | 40 |
| MRR | $9,600 + $1,560 = $11,160 |
| Monthly costs | ~$100 |
| Net | ~$11,060 |

### Target scenario (Month 18)

| Metric | Value |
|---|---|
| Pro subscribers | 2,500 |
| Studio subscribers | 120 |
| MRR | $30,000 + $4,680 = $34,680 |
| Monthly costs | ~$300 |
| Net | ~$34,380/month |

---

## 14. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| **Etsy changes API terms or revokes access** | Medium | High | Phase 1 market benchmark uses public data only. Cost calculator works entirely without API. Core product survives API loss. |
| **Etsy changes its fee structure** | High | Medium | Fee schedule stored in configurable app settings, not hardcoded. Update takes minutes. Monitor Etsy seller news feeds. |
| **Low willingness to pay in Etsy community** | Medium | High | Validate with Phase 0 Google Sheets prototype before building. Free tier must generate genuine value to prove conversion path. |
| **Marmalead or eRank adds pricing features** | Medium | Medium | Their brand is SEO; a pricing pivot would confuse their positioning. Focus on pricing depth they cannot match without a full rebuild. |
| **Conflict with current employer** | Low | Very High | Product is in e-commerce / handmade goods — no overlap with current technical domain. Documented explicitly. |
| **Slow organic growth without paid ads** | Medium | Medium | Multiple zero-budget channels (Facebook groups, Reddit, YouTube, Pinterest) provide redundancy. Phase 0 tests channel viability before committing. |

---

## 15. KPIs & Success Metrics

### Product metrics

| Metric | Target (Month 3) | Target (Month 6) |
|---|---|---|
| Free tier signups | 1,000 | 5,000 |
| Calculations run | 10,000 | 60,000 |
| Free → Pro conversion rate | 4% | 6% |
| Pro subscriber count | 40 | 200 |
| Monthly active users | 500 | 3,000 |

### Business metrics

| Metric | Target (Month 6) | Target (Month 12) |
|---|---|---|
| MRR | $2,790 | $11,160 |
| Pro subscribers | 200 | 800 |
| Churn rate (monthly) | < 8% | < 5% |
| CAC | $0 (organic only) | $0 |

### Leading indicators (weekly)

- Facebook group post engagement (comments asking for the link)
- Free tier signups per week
- Free → Pro conversion events
- Email open rate on pricing insight newsletter
- YouTube video views on pricing content

---

## 16. Open Questions

- [ ] Which 10 Facebook groups should be the initial outreach targets? (Need to identify groups by size and engagement, not just membership count)
- [ ] Stripe or Paddle for billing? (Paddle handles EU VAT automatically — relevant if non-US users adopt the tool)
- [ ] Should market rate data display exact listing prices or ranges only? (Ranges are safer legally; exact prices could raise concerns about republishing Etsy data)
- [ ] What is the right free tier limit? 5 calculations/month may be too restrictive to demonstrate value — worth testing 10 or unlimited with a feature gate instead
- [ ] Is there a meaningful audience on Amazon Handmade large enough to justify a second fee schedule in Phase 1, or defer entirely to Phase 3?

---

## 17. Decision Log

| Date | Decision | Rationale |
|---|---|---|
| 2025-09-12 | Focused product on pricing/profitability, not SEO | Marmalead and eRank own SEO. Pricing is a clear gap with no dedicated tool. Differentiation is immediate. |
| 2025-09-12 | US English market first | Largest concentration of Etsy sellers; same language as founder; no localization cost at MVP. |
| 2025-09-12 | Ruled out full inventory management (Craftybase territory) | Craftybase already exists and targets production businesses. CraftPrice targets the pricing decision moment, not ongoing inventory. Different job-to-be-done. |
| 2025-09-12 | Phase 1 market benchmark uses public Etsy API only, no user OAuth | Avoids API approval delay at launch. Core value (cost calculator) requires no Etsy API at all. OAuth deferred to Phase 3 shop integration. |
| 2025-09-12 | Go backend chosen over Node.js | Founder's strongest language; better performance for concurrent Etsy API calls at scale. |
| 2025-09-12 | Free tier gated at 5 calculations/month (to be validated) | Creates a genuine incentive to convert without blocking value entirely. Treat as hypothesis — test in Phase 0. |

---

## 18. Version History

| Version | Date | Summary of changes |
|---|---|---|
| v0.1.0 | 2025-09-12 | Initial draft — full plan created from ideation session |
