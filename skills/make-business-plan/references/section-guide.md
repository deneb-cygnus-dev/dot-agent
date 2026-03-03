# Section Writing Guide

Detailed guidance for every section of the business plan. Read this when the abbreviated template in SKILL.md is not sufficient context to fill a section well.

---

## Section 1 — Snapshot

**Purpose:** A single paragraph that orients any reader (including future-you) within 30 seconds.

**Must answer:**

- What is the product called?
- What does it do in one sentence?
- Who is the primary user?
- How does it reach users without paid advertising?

**One-liner format:** *"The {adjective} {product type} for {specific user} who {specific pain}."*

**Anti-patterns:**

- Vague language: "a platform that helps people" — name the person specifically
- Listing features instead of describing the outcome

---

## Section 2 — Problem & Opportunity

**Purpose:** Prove the pain is real and sized. Every decision in the plan should be traceable back to a statement in this section.

**Must answer:**

- Who specifically feels this pain? (not "small businesses" — "Japanese indie VTubers with 5K–50K followers")
- Why do existing tools fail them? (be specific about the gap, not "existing tools are bad")
- What is the market size or growth rate? (cite a number — even a rough one anchors the section)
- Is there a recent event or trend that makes this the right moment?

**Structure:**

1. The pain (VTuber/user-side)
2. The secondary pain (fan/customer-side, if applicable)
3. The market signal (size, event, timing)

**Anti-patterns:**

- Stating the problem in terms of your solution ("the problem is there is no platform for X")
- No market signal — a problem without a market is a hobby, not a business

---

## Section 3 — Solution

**Purpose:** Describe what you are actually building, at feature level, with strict scope discipline.

**Rules:**

- MVP must have at most 2–3 features. If you have more, move them to Phase 2.
- Each feature must map to a stated pain from Section 2.
- Use the format: Feature Name → what it does → why it solves the pain.

**Anti-patterns:**

- Writing aspirational features as if they are MVP ("AI-powered personalized recommendations")
- Vague feature names ("dashboard", "analytics") with no description of what they show

---

## Section 4 — Target Market

**Purpose:** Define your customers with enough specificity that you could find 10 of them tomorrow.

**Primary segment:** Must include a size signal. Not just "gamers in Japan" but "indie LoL VTubers in Japan with 1K–100K followers — thousands exist based on streaming platform data."

**Secondary segment (B2B):** State when this becomes relevant (not now). Include who the decision-maker is.

**Out of scope:** This is as important as the in-scope list. Explicitly naming what you are NOT building for prevents scope creep and sharpens the positioning.

**Anti-patterns:**

- "Everyone who plays games" — too broad to build a product or marketing message for
- Missing the "out of scope" list

---

## Section 5 — Unique Value Proposition

**Purpose:** The sentence you use in an outreach DM. It must be specific enough that the recipient immediately recognizes their own problem.

**Format:** One UVP per customer type (primary B2C user, and secondary B2B buyer if applicable).

**Test:** Read it aloud. If a competitor could say the exact same sentence truthfully, it is not differentiated enough.

**Anti-patterns:**

- "The best platform for X" — superlatives without specifics are meaningless
- Listing features instead of outcomes

---

## Section 6 — Unfair Advantages

**Purpose:** The moats that hold against a well-funded competitor. This is the most important section for long-term survival.

**Moat types (pick those that apply):**

| Type | What it looks like | How long it takes to replicate |
|---|---|---|
| Language / cultural | Product is built in a language competitors cannot staff quickly | 1–2 years minimum |
| Community / network effects | Users bring other users; value grows with each new member | Depends on critical mass |
| Niche domain knowledge | Deep understanding of a specific vertical's workflow | Cannot be bought — requires lived experience |
| Data accumulation | Product improves as more users create data | Proportional to user history |
| Distribution / existing audience | Already have reach into the target audience | Often impossible to replicate |
| Technical execution | Unique implementation | **Weak** — replicable in months with AI tools in 2026 |

**Validation test for each advantage:** Ask "Could a 5-person startup funded at $1M replicate this in 6 months?" If yes, it is not an unfair advantage.

**Anti-patterns:**

- Listing technical execution as a moat (it is not in 2026)
- Generic advantages that any startup could claim ("great team", "fast execution")

---

## Section 7 — Product

**Purpose:** Define what exists at each phase and what it costs.

### Feature table

Use three columns: MVP, Phase 2, Phase 3. A checkmark (✅) in a column means it is built in that phase. Empty means not yet. This prevents every feature from being "MVP."

### Pricing tier table

Columns: Tier | Price | Target | Key features

**Pricing principles for solo B2C founders:**

- Free tier is required if any external API ToS mandates it (Riot Games, for example)
- Free tier also serves as the acquisition funnel — it must be genuinely useful
- First paid tier should be priced where 2–3 subscribers cover your monthly infrastructure cost
- B2B tier should be priced at 10–20x the individual tier (businesses pay for reliability and support, not just features)

**Anti-patterns:**

- No free tier when the target audience is individual consumers
- Paid tier priced below the cost of serving one user
- More than 3 pricing tiers at launch (adds friction before you understand what customers want)

---

## Section 8 — Business Model

**Purpose:** Show that this is a sustainable business, not just a product.

### Revenue streams

Primary stream first. Future streams are fine to list but clearly label them as future.

### Cost structure

Be specific. Look up actual free tier limits for the services you plan to use. State the monthly cost and when you would exceed the free tier.

**Reference cost benchmarks (2026):**

- Vercel: Free for frontend static/serverless up to reasonable traffic
- Supabase: Free up to 500MB DB, 2GB storage, ~50K MAU
- Fly.io: Free allowance for small Go binaries in most regions
- Railway: $5/month after free tier
- Claude API (patch summaries): ~$0.01–0.05 per summary generation at typical prompt sizes
- Domain: ~¥1,500–2,000/year

### Break-even milestones

State the number of paying users needed to cover costs, then ¥100K MRR, then ¥500K MRR. This gives the roadmap a business-driven exit condition at each phase.

---

## Section 9 — Competitive Landscape

**Purpose:** Show you understand the space and have a specific edge over each named alternative.

**Format:** Table with columns Competitor | Strength | Weakness | Your edge

**Rules:**

- Name real competitors, not categories ("existing tools")
- Include indirect competitors (spreadsheets, Discord bots — anything the user does instead of paying you)
- Close with one sentence naming the key gap your product fills

**Anti-patterns:**

- "No competitors exist" — there are always alternatives, even manual ones
- Listing only weaknesses without acknowledging what makes competitors strong

---

## Section 10 — Go-to-Market Strategy

**Purpose:** A concrete plan to reach the first 10 paying customers with zero ad budget.

### Principles

State the constraints first (zero paid ads, fully remote, etc.). This prevents generic advice from creeping in.

### Phase 1 — First N users

Name the exact tactics. Not "social media marketing" but "DM indie LoL VTubers on Twitter/X with under 30K followers, offer 3 months free Pro in exchange for one stream using the tool."

**High-leverage zero-budget tactics:**

- Direct outreach to early adopters (DM on X, Discord, LINE)
- Content that demonstrates the product's value (post the output publicly, let it sell itself)
- Partnerships with aligned communities (gaming cafes, Discord servers, clubs)
- Product-led growth (the product itself generates shareable artifacts — tournament results, patch summaries)

### Phase 2 — Organic growth

Describe how the product markets itself once users are in. Every tournament on stream is a live demo. Every shared result is an organic post.

### Phase 3 — B2B

Only discuss this after Phase 1 and 2 are concrete. Premature B2B planning is a distraction.

---

## Section 11 — Technical Architecture

**Purpose:** A decision record of the technical stack, not an implementation spec.

### Stack table

Columns: Layer | Technology | Reason. The reason column is critical — it explains why this choice was made, not just what it is. This section is read months later when you consider changing a technology.

**Layers to always include:**

- Frontend (framework, UI library)
- Backend (language, framework)
- Database (engine, provider)
- Auth (who handles it)
- Deployment — frontend and backend separately if they differ
- Any domain-specific layers (stream overlay, bot, mobile app)

### Data sources table

Columns: Source | Access (key required? free?) | Purpose | Key constraint

**This section must be accurate.** Errors here cause real-world legal or operational problems. Verify API ToS before writing.

### Compliance checklist

Required whenever any external API or platform is used. Examples:

- Riot Games: register on Developer Portal, apply for Production Key, maintain free tier, no raw patch note reproduction
- LINE API: register as LINE Business Account, review Messaging API quotas
- Supabase: data residency (check if JP region is available for Japanese user data)

---

## Section 12 — Roadmap

**Purpose:** A phased build plan as checkboxes. Not a Gantt chart. Not a backlog.

**Phase structure:**

- Phase 0 — Validation (Week 1–2): prove the idea works before building the product
- Phase 1 — MVP (Week 3–8): the smallest thing you can show to a real user
- Phase 2 — Retention & Growth (Week 9–16): features that make users stay and invite others
- Phase 3 — B2B (Month 5+): features that unlock the business tier

**Phase 0 must come first.** It validates assumptions using minimal code. If you skip Phase 0, you risk building the wrong product for 6 weeks.

**Anti-patterns:**

- Phase 1 with more than 8 checkboxes (scope creep — move items to Phase 2)
- No Phase 0 (skipping validation)
- B2B features in Phase 1

---

## Section 13 — Financial Projections

**Purpose:** Directional targets to orient decision-making, not financial forecasts.

**Always label as:** *"These are directional estimates, not forecasts. Revise as real data comes in."*

**Three scenarios:**

- Conservative (Month 6): what happens if adoption is slow
- Moderate (Month 12): a realistic mid-case
- Target (Month 18): what you are aiming for

**Each scenario includes:** subscriber count by tier, MRR by tier, total MRR, monthly costs, net.

**Anti-patterns:**

- Projecting revenue without including costs
- "Hockey stick" projections with no stated assumptions
- Projecting further than 18 months (too speculative for an early-stage plan)

---

## Section 14 — Risk Register

**Purpose:** A structured list of what could kill the business, and how to prevent or survive each risk.

**Columns:** Risk | Likelihood (Low/Medium/High) | Impact (Low/Medium/High/Very High) | Mitigation

**Mandatory risks to always include:**

1. **Employer conflict** — risk that current employer claims the work or perceives conflict of interest. Mitigation: domain separation, document the decision explicitly.
2. **External API dependency** — if the product depends on a third-party API (Riot, LINE, YouTube), what happens if access is revoked or ToS changes.
3. **Platform risk** — if the product relies on a platform for distribution (VTubers on YouTube, fans on Discord), what if the platform changes rules.
4. **Slow adoption** — the most common early-stage risk. Mitigation: Phase 0 validation, multiple acquisition tactics, feature that generates value independently of adoption.

---

## Section 15 — KPIs & Success Metrics

**Purpose:** Define what "working" looks like before you start, so you are not rationalizing results later.

**Three layers:**

1. **Product metrics** — user behavior (tournaments created, fans registered, overlays active)
2. **Business metrics** — MRR, subscribers, churn rate, CAC
3. **Leading indicators** — weekly signals that predict future business metrics (impressions on patch post, VTuber DM response rate)

**Leading indicators are the most important.** Business metrics lag by weeks. Leading indicators tell you if the strategy is working before it shows up in revenue.

---

## Section 16 — Open Questions

**Purpose:** A parking lot for decisions that cannot be made yet — not a to-do list.

**Format:** Checkbox list. Each item is a specific question with a clear answer ("PAY.JP or Stripe?" not "payment processing").

**Anti-patterns:**

- Items that are tasks, not questions ("build the landing page")
- Questions that are already answered elsewhere in the plan

---

## Section 17 — Decision Log

**Purpose:** The institutional memory of the business. Every significant direction change is recorded here with a date and rationale.

**Entries from the questionnaire phase belong here.** When you ruled out a direction (e.g., "ruled out developer tools due to employer conflict"), log it. When you chose a tech stack, log it. Future-you will not remember why.

**Format:** Table with columns Date | Decision | Rationale

**Update this section every time:**

- A direction is changed or ruled out
- A significant architectural or pricing decision is made
- An external risk changes the plan (API ToS changes, competitor appears, etc.)

---

## Section 18 — Version History

**Purpose:** A changelog for the document itself.

**Format:** Table with columns Version | Date | Summary of changes

**Versioning scheme:**

- `v0.1.0` — first complete draft
- `v0.1.x` — patch: corrections, small updates, new Decision Log entries
- `v0.x.0` — minor: new section added, significant content update to existing section
- `vx.0.0` — major: significant business pivot that changes multiple core sections simultaneously
