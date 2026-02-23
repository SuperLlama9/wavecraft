---
name: research
description: >
  Guide deep research before any specs are written. This skill should be used when the user says
  "research this feature", "competitor analysis", "technical feasibility", "explore this idea",
  "what's the market for", "who are the competitors", "investigate", "deep dive into", or any
  variation of exploring a problem space before building. Also trigger when the user mentions
  "market research", "user research", "pain points", "JTBD", or asks about feasibility of a
  feature or product idea. This is typically the first skill in the planning chain.
version: 0.1.0
---

# wavecraft:research — Research Brief

Guide deep research before any specs are written. Explores the problem space through competitor analysis, user needs mapping, technical feasibility assessment, and market context. Produces a structured Research Brief that feeds into downstream design and specification decisions.

## Why This Matters

Jumping straight to specs without research leads to building the wrong thing. This skill forces a structured exploration of the problem space: who has this problem, how are they solving it today, what's technically feasible, and what's the market opportunity. The Research Brief becomes the foundation for all downstream decisions.

## When to Trigger

- "research this feature", "competitor analysis", "technical feasibility"
- "explore this idea", "what's the market for", "who are the competitors"
- "investigate", "deep dive into"
- As the first skill in the planning chain (before `:design` or `:spec`)

## Workflow

### Step 1: Read Context Files (Mandatory)

```
Read (mandatory):
├── DISCUSSION-LOG.md          → Previous decisions and context
│   (or PROJECT-LOG.md         → Lightweight mode equivalent)
├── PROCESS.md                 → Current lifecycle phase
│   (or PROJECT-LOG.md)

Read (if they exist):
├── docs/research/*.md         → Previous research briefs (for context)
└── CLAUDE.md                  → Tech stack context (informs feasibility)
```

**Bootstrap mode:** If DISCUSSION-LOG.md or PROCESS.md don't exist, create them with minimal content. Then proceed.

### Step 2: Identify Research Scope

Ask the user:
1. **What are we researching?** Get a clear description of the feature, product idea, or problem space.
2. **What decisions need to be made?** What will this research inform? (Build/buy, feature scope, tech choice, market entry)
3. **What's the time investment?** Quick (30 min), standard (1-2 hours), deep (half day+)?

### Step 3: Competitor / Existing Solution Analysis

Research 3-5 competitors or existing solutions:

```
For each competitor:
├── Name and URL
├── What they do well (specific features, UX patterns)
├── What's missing or weak
├── Pricing model (if relevant)
├── Target audience
└── Key takeaway for our product
```

**Use web search** to find competitors, product reviews (G2, Capterra, Product Hunt), and feature comparisons.

**For process automation (Scenario D):** Replace competitor analysis with existing tool/workflow analysis — what tools do people currently use to solve this problem?

### Step 4: User / Stakeholder Needs

Map the target users and their needs:

```
For each user type:
├── Role / persona
├── Current workflow (how they solve this today)
├── Pain points (what's frustrating or broken)
├── Jobs to be done (JTBD framework)
│   ├── Functional job: [what they need to accomplish]
│   ├── Emotional job: [how they want to feel]
│   └── Social job: [how they want to be perceived]
└── Success criteria (how they'd measure "this works")
```

If direct user research isn't available, use web research: forums, Reddit, review sites, support tickets, competitor reviews.

### Step 5: Technical Feasibility

Assess what's technically possible:

```
Technical Assessment:
├── Can we build this with our current stack?
├── Third-party services/APIs needed?
│   ├── Availability and reliability
│   ├── Pricing at expected scale
│   └── API quality (documentation, rate limits)
├── Data requirements
│   ├── What data do we need?
│   ├── Where does it come from?
│   └── Privacy/compliance implications
├── Performance constraints
│   ├── Expected data volumes
│   ├── Response time requirements
│   └── Scalability considerations
└── Known technical risks
    ├── [Risk 1]: [likelihood] / [impact] / [mitigation]
    └── [Risk 2]: [likelihood] / [impact] / [mitigation]
```

If the project has a codebase, use Claude Code's Plan Mode or file reading to explore existing architecture and identify constraints.

### Step 6: Market Context (If Applicable)

For new products or major features with revenue implications:

```
Market Context:
├── Market sizing (TAM / SAM / SOM)
├── Pricing benchmarks (what do competitors charge?)
├── Regulatory / compliance requirements
├── Timing considerations (market trends, competitive windows)
└── Go-to-market considerations
```

**Skip this step** for internal features, process automation, or features without direct revenue impact. Mark as "N/A — internal feature."

### Step 7: Produce Research Brief

Write the Research Brief to `docs/research/RESEARCH-BRIEF.md` (or `docs/research/RESEARCH-BRIEF-[topic].md` if multiple briefs exist).

```markdown
# Research Brief: [Topic]

## Date: [date]
## Researcher: [name] + Claude

## Problem Statement
[2-3 sentences: what problem are we solving? For whom?]

## User / Stakeholder Needs
[Key personas, pain points, JTBD — summarized from Step 4]

## Competitor / Existing Solutions
[3-5 alternatives analyzed — summarized from Step 3]

### [Competitor 1]
- Strengths: [what they do well]
- Weaknesses: [what's missing]
- Relevance: [what we can learn]

### [Competitor 2]
...

## Technical Feasibility
[Can we build this? Dependencies, APIs, constraints — from Step 5]

## Market Context
[If applicable: sizing, pricing, regulatory — from Step 6. Or "N/A"]

## Key Findings
1. [Most important insight]
2. [Second most important]
3. [Third]

## Open Questions
[What we still don't know — needs further investigation or user input]

## Recommendation
[Based on research: proceed / pivot / park? With rationale.]
```

### Step 8: Update Discussion Log

Append to DISCUSSION-LOG.md (or PROJECT-LOG.md):

```markdown
## [date] — Research: [Topic]

**Findings:**
- [Key finding 1]
- [Key finding 2]
- [Key finding 3]

**Decisions:**
- [Decision based on research — e.g., "Proceed with building feature X"]

**Open questions:**
- [What still needs investigation]

**Next:** [Design via `wavecraft:design` / Spec via `wavecraft:spec` / More research needed]
```

## Adaptation

**Single feature (Scenario B):**
Skip market sizing. Focus on technical feasibility and competitive patterns for the specific feature. Lighter research brief.

**Process automation (Scenario D):**
Replace competitor analysis with existing tool/workflow analysis. Focus on integration points and process pain points.

**Pure ideation (Scenario E):**
Lightest structure. Focus on capturing the idea, exploring feasibility at a high level, and listing open questions. The brief may be short (half a page) — that's fine.

**No web access:**
The skill works without web search — it just relies on the user's knowledge and Claude's training data. Note in the brief: "Research based on existing knowledge; web validation recommended."

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/research-brief-template.md` | When producing the final research brief (Step 7) |
