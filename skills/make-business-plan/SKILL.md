---
name: make-business-plan
description: Generate a structured, versioned business plan markdown document for a new business idea. Guides through a decision-making questionnaire first, then produces a complete plan with all standard sections. Use when starting a new business idea from scratch or when formalizing an idea that has been discussed.
---

# Business Plan Generator

A business plan here is a **living document** — versioned, logged, and updated as the business evolves. It is not a one-time pitch deck. The output is a markdown file committed to the user's notes or business repository.

---

## Phase 1 — Decision Questions

Gather answers through conversation **before writing anything**. Ask questions in the three rounds below. Later rounds depend on earlier answers — do not collapse them into one prompt.

### Round 1: Founder Profile

These establish the moat and constraints unique to this person.

| # | Question | Why it matters |
|---|---|---|
| 1 | What is your primary technical skill and stack preference? | Shapes the Technical Architecture section |
| 2 | Outside your main job, what fields or activities do you have deep interest or experience in? | Reveals niche domain knowledge — strongest non-technical moat |
| 3 | Are you based in a non-English speaking market? Which one? | Language/cultural access is a durable competitive advantage |
| 4 | Do you have an existing audience or community? Platform and size? | Determines if distribution moat already exists |
| 5 | Are there any conflict-of-interest constraints with your current employment? (domain overlap, IP risk) | Rules out entire categories before wasting planning time |
| 6 | Solo founder or do you have coworkers? | Determines scope of what can realistically be built |

### Round 2: Business Constraints

| # | Question | Why it matters |
|---|---|---|
| 7 | Fully remote operation, or can physical presence be involved? | Eliminates or enables location-dependent tactics |
| 8 | What is your available budget for infrastructure and marketing at launch? | Determines if zero-cost distribution only, or small paid spend is possible |
| 9 | Is small income acceptable at first, or is a minimum revenue threshold required? | Calibrates financial projection targets |
| 10 | What legal or copyright risks are you sensitive to? (data scraping, licensing, IP) | Shapes which data sources and product categories are safe |

### Round 3: Product Shape

Ask these only after the product direction has been narrowed by Rounds 1 and 2.

| # | Question | Why it matters |
|---|---|---|
| 11 | Who is the primary customer — individual consumer (B2C) or business (B2B)? What is the growth path? | Shapes Pricing, Go-to-Market, and Financial Projections |
| 12 | What moat type applies? (language/cultural, data, community/network effects, niche domain, technical execution) | Shapes Unfair Advantages and Competitive Landscape |
| 13 | What external data sources or APIs does the product depend on? Are there ToS or access constraints? | Shapes Technical Architecture and Risk Register |
| 14 | What is the MVP feature set? (maximum 2–3 features, buildable in 6–10 weeks solo) | Shapes Product and Roadmap sections |
| 15 | What is the primary distribution channel with zero ad budget? | Shapes Go-to-Market section |

---

## Phase 2 — Output File

### Location and naming

Save the plan at a path agreed with the user. Default suggestion:

```text
{notes-or-business-repo}/business/{kebab-case-product-name}/business-plan.md
```

### File header (required)

Every plan must open with:

```markdown
# Business Plan — {Product Name}

> **Version:** v0.1.0
> **Status:** {Ideation | Validation | Building | Launched}
> **Last updated:** {YYYY-MM-DD}
> **Owner:** {Solo founder | name}

<!--
Version scheme: major.minor.patch
  major — significant business pivot or full restructure
  minor — new section added or major content update
  patch — corrections, small clarifications, decision log entries
-->
```

---

## Phase 3 — Abbreviated Template

The skeleton below shows all required sections with one-line descriptions. Fill each section using the guidance in [references/section-guide.md](./references/section-guide.md). A fully worked example is in [references/example-craftprice.md](./references/example-craftprice.md).

```markdown
## 1. Snapshot
One paragraph. Product name, what it does, who it is for, and the
distribution strategy. Include a one-liner (the sentence you say in a DM).

## 2. Problem & Opportunity
The specific pain. Who feels it. Why existing solutions fail.
Include at least one real market signal (size, growth rate, recent event).

## 3. Solution
Two to three features maximum at MVP stage. No scope creep.
Each feature maps to a pain from Section 2.

## 4. Target Market
Primary (B2C first): specific segment, size signal.
Secondary (B2B later): who and when.
Out of scope: explicit list of what you are NOT targeting.

## 5. Unique Value Proposition
One sentence per customer type. The sentence you use in outreach DMs.

## 6. Unfair Advantages
Table: Advantage | Why it cannot be quickly replicated.
Must survive the question: "What if a well-funded startup copies this?"

## 7. Product
Feature breakdown table: Feature | MVP | Phase 2 | Phase 3.
Pricing tiers table: Tier | Price | Target | Key features.

## 8. Business Model
Revenue streams (numbered list).
Cost structure table with monthly estimates.
Break-even milestones table.

## 9. Competitive Landscape
Table: Competitor | Strength | Weakness | Your edge.
End with a one-sentence statement of the key gap.

## 10. Go-to-Market Strategy
Principles (zero-budget constraints).
Phase 1 (first N users): specific tactics, not generic advice.
Phase 2 (organic growth): how the product markets itself.
Phase 3 (B2B): timing and approach.

## 11. Technical Architecture
Stack table: Layer | Technology | Reason.
Data sources table: Source | Access | Purpose | Key constraint.
Any pipeline or workflow that is non-obvious (code block).
Compliance checklist (ToS, legal, attribution requirements).

## 12. Roadmap
Phase 0 — Validation (Week 1–2): checkboxes.
Phase 1 — MVP (Week 3–8): checkboxes.
Phase 2 — Retention & Growth (Week 9–16): checkboxes.
Phase 3 — B2B (Month 5+): checkboxes.

## 13. Financial Projections
Label as directional estimates, not forecasts.
Three scenarios: Conservative (Month 6), Moderate (Month 12), Target (Month 18).
Each scenario: MRR, subscriber count, costs, net.

## 14. Risk Register
Table: Risk | Likelihood | Impact | Mitigation.
Must include: employer conflict risk, dependency on external API/platform.

## 15. KPIs & Success Metrics
Product metrics table with targets at Month 3 and Month 6.
Business metrics table with targets at Month 6 and Month 12.
Weekly leading indicators (short bullet list).

## 16. Open Questions
Checkbox list of unresolved decisions.
Each item is a concrete question, not a vague topic.

## 17. Decision Log
Table: Date | Decision | Rationale.
Every major direction change is recorded here with a date.
Decisions from the Round 1–3 questionnaire belong here.

## 18. Version History
Table: Version | Date | Summary of changes.
Start with v0.1.0 on creation date.
```

---

## Phase 4 — Validation Checklist

Before delivering the plan, verify:

- [ ] All 18 sections are present and non-empty
- [ ] Section 6 (Unfair Advantages) passes the "well-funded copycat" test — each advantage has a reason it holds
- [ ] Section 7 (Product) MVP has no more than 3 features
- [ ] Section 11 (Technical Architecture) includes a compliance checklist if any external API or data source is used
- [ ] Section 13 (Financial Projections) is labeled as directional estimates
- [ ] Section 14 (Risk Register) includes employer conflict risk and at least one external dependency risk
- [ ] Section 17 (Decision Log) contains at least one entry for each major direction ruled out during the questionnaire
- [ ] Section 18 (Version History) starts at v0.1.0 with today's date
- [ ] File header includes Version, Status, Last updated, Owner
- [ ] Version scheme comment block is present below the header
