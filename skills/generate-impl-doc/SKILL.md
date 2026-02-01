---
name: generate-impl-doc
description: Generate implementation documentation using 5W1H format. Documents what the branch implements/fixes, why changes were made, and how they work. Run when ready to document a feature branch before merge.
---

# Implementation Documentation Generator

Generate comprehensive documentation for the current branch using the 5W1H framework (Who, What, When, Where, Why, How).

## Prerequisites

Before generating documentation:

1. **Check current branch**: Ensure you're on a feature/fix branch, not `main`
2. **Check for changes**: Verify there are commits that differ from `main`
3. **Check output directory**: Ensure `docs/implementations` exists

## Step 1: Gather Information

Run these commands to collect branch data:

```bash
# Get current branch name
git branch --show-current

# Get diff against main (summary)
git diff main --stat

# Get detailed diff
git diff main

# Get commit history for this branch
git log main..HEAD --oneline

# Get commit details with messages
git log main..HEAD --pretty=format:"%h - %s (%an, %ad)" --date=short

# Get author information
git log main..HEAD --pretty=format:"%an <%ae>" | sort -u
```

## Step 2: Directory Check

Check if `docs/implementations` exists in the project root:

```bash
ls -la docs/implementations 2>/dev/null || echo "DIRECTORY_NOT_FOUND"
```

**If directory does not exist**: Ask the user for permission to create it:

> "The `docs/implementations` directory does not exist. Would you like me to create it?"

If approved:
```bash
mkdir -p docs/implementations
```

## Step 3: Generate Documentation

Create a markdown file named after the branch: `docs/implementations/{branch-name}.md`

### Document Template

```markdown
# {Branch Name} - Implementation Documentation

> Generated: {YYYY-MM-DD}

---

## Summary

{One-paragraph summary of what this branch accomplishes}

---

## 5W1H Analysis

### WHO - Contributors

| Author | Email |
|--------|-------|
| {name} | {email} |

### WHAT - Changes Overview

**Type of Change:**
- [ ] New Feature
- [ ] Bug Fix
- [ ] Refactoring
- [ ] Documentation
- [ ] Performance Improvement
- [ ] Other: ___

**High-Level Summary:**
{Describe what was added, modified, or removed}

**Key Changes:**
1. {Change 1}
2. {Change 2}
3. {Change 3}

### WHEN - Timeline

| Event | Date |
|-------|------|
| First Commit | {date} |
| Last Commit | {date} |
| Documentation Generated | {date} |

### WHERE - Affected Areas

**Files Changed:**
```
{output of git diff main --stat}
```

**Modules/Components Affected:**
- {module/component 1}
- {module/component 2}

### WHY - Purpose & Motivation

**Problem Statement:**
{What problem does this branch solve?}

**Motivation:**
{Why was this change necessary?}

**Related Issues/Tickets:**
- {Link to issue or ticket, if any}

### HOW - Implementation Details

**Approach:**
{Describe the technical approach taken}

**Key Implementation Decisions:**
1. **{Decision 1}**: {Rationale}
2. **{Decision 2}**: {Rationale}

**Code Architecture:**
{Describe any architectural patterns or significant code structure}

---

## Commit History

| Hash | Message | Author | Date |
|------|---------|--------|------|
| {hash} | {message} | {author} | {date} |

---

## Testing

**Test Coverage:**
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

**How to Test:**
{Instructions for testing the changes}

---

## Dependencies

**New Dependencies Added:**
- {dependency 1}: {reason}

**Dependencies Modified:**
- {dependency}: {change description}

---

## Migration Notes

{Any migration steps required when deploying this change}

---

## Future Considerations

{Notes for future developers about potential improvements or known limitations}

---

## References

- {Link to design doc, if any}
- {Link to related PRs}
- {Link to relevant documentation}
```

## Step 4: Content Guidelines

### Analyzing the Diff

When reviewing `git diff main`, identify:

1. **New files**: What purpose do they serve?
2. **Modified files**: What functionality changed?
3. **Deleted files**: Why were they removed?
4. **Configuration changes**: What settings were adjusted?

### Writing the WHY Section

This is the most critical section. To determine "why":

1. Read commit messages for context
2. Look for comments in code explaining decisions
3. Identify the problem being solved by examining:
   - Error handling additions
   - New validation logic
   - Performance optimizations
   - Feature additions

### Writing the HOW Section

Explain implementation at a level useful for future developers:

1. **Algorithms used**: Describe any non-trivial algorithms
2. **Design patterns**: Note any patterns applied (Factory, Observer, etc.)
3. **Data flow**: How data moves through the new/modified code
4. **External integrations**: Any new API calls or service integrations

## Step 5: Validation

Before finalizing, verify:

- [ ] All 5W1H sections are filled
- [ ] Commit history is accurate
- [ ] File paths in "WHERE" section are correct
- [ ] Technical explanations are clear
- [ ] No sensitive information included (secrets, credentials)

## Output

Save the documentation to:
```
{project-root}/docs/implementations/{branch-name}.md
```

Example: For branch `feature/user-auth`, create:
```
docs/implementations/feature-user-auth.md
```

Note: Replace `/` with `-` in branch names for the filename.

---

## Quick Reference

| Section | Key Question |
|---------|--------------|
| WHO | Who contributed to this branch? |
| WHAT | What changes were made? |
| WHEN | When were the changes made? |
| WHERE | Which files/modules were affected? |
| WHY | Why were these changes necessary? |
| HOW | How were the changes implemented? |

---

**Remember**: Good documentation enables knowledge transfer. Future developers (including yourself) will thank you for thorough branch documentation.
