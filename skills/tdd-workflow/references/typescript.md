# TypeScript/JavaScript Testing Reference

## Framework

- `Jest` or `Vitest` - Unit/integration testing
- `@testing-library/react` - React component testing
- `Playwright` or `Cypress` - E2E testing
- `msw` - API mocking

## File Organization

```text
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   └── Button.test.tsx
│   └── MarketCard/
│       ├── MarketCard.tsx
│       └── MarketCard.test.tsx
├── lib/
│   ├── utils.ts
│   └── utils.test.ts
├── app/api/
│   └── markets/
│       ├── route.ts
│       └── route.test.ts
└── e2e/
    └── markets.spec.ts
```

## Unit Test Pattern

```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import { MarketCard } from './MarketCard'

describe('MarketCard', () => {
  const mockMarket = { id: '1', name: 'Test Market', status: 'active' }

  it('renders market name', () => {
    render(<MarketCard market={mockMarket} />)
    expect(screen.getByText('Test Market')).toBeInTheDocument()
  })

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<MarketCard market={mockMarket} onClick={handleClick} />)

    fireEvent.click(screen.getByRole('article'))

    expect(handleClick).toHaveBeenCalledWith(mockMarket)
  })
})
```

## API Integration Test Pattern

```typescript
import { createMocks } from 'node-mocks-http'
import { GET, POST } from './route'

describe('/api/markets', () => {
  it('GET returns markets list', async () => {
    const { req } = createMocks({ method: 'GET' })
    const response = await GET(req)

    expect(response.status).toBe(200)
    expect((await response.json()).success).toBe(true)
  })

  it('POST validates required fields', async () => {
    const { req } = createMocks({ method: 'POST', body: { name: '' } })
    const response = await POST(req)

    expect(response.status).toBe(400)
  })
})
```

## E2E Test Pattern (Playwright)

```typescript
import { test, expect } from '@playwright/test'

test.describe('Market Search', () => {
  test('user can search markets', async ({ page }) => {
    await page.goto('/markets')

    await page.fill('[data-testid="search-input"]', 'election')
    await page.waitForTimeout(500)

    const results = page.locator('[data-testid="market-card"]')
    await expect(results.first()).toContainText('election', { ignoreCase: true })
  })
})
```

## Mocking Pattern

```typescript
// Jest mock
jest.mock('@/lib/api', () => ({
  fetchMarkets: jest.fn(() => Promise.resolve([{ id: '1', name: 'Test' }]))
}))

// MSW for API mocking
import { rest } from 'msw'
import { setupServer } from 'msw/node'

const server = setupServer(
  rest.get('/api/markets', (req, res, ctx) => {
    return res(ctx.json({ data: [{ id: '1', name: 'Test' }] }))
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
```

### Supabase Mock

```typescript
jest.mock('@/lib/supabase', () => ({
  supabase: {
    from: jest.fn(() => ({
      select: jest.fn(() => ({
        eq: jest.fn(() => Promise.resolve({
          data: [{ id: 1, name: 'Test Market' }],
          error: null
        }))
      }))
    }))
  }
}))
```

### Redis Mock

```typescript
jest.mock('@/lib/redis', () => ({
  searchMarketsByVector: jest.fn(() => Promise.resolve([
    { slug: 'test-market', similarity_score: 0.95 }
  ])),
  checkRedisHealth: jest.fn(() => Promise.resolve({ connected: true }))
}))
```

### OpenAI Mock

```typescript
jest.mock('@/lib/openai', () => ({
  generateEmbedding: jest.fn(() => Promise.resolve(
    new Array(1536).fill(0.1) // Mock 1536-dim embedding
  ))
}))
```

## Common Testing Mistakes to Avoid

### ❌ WRONG: Testing Implementation Details

```typescript
// Don't test internal state
expect(component.state.count).toBe(5)
```

### ✅ CORRECT: Test User-Visible Behavior

```typescript
// Test what users see
expect(screen.getByText('Count: 5')).toBeInTheDocument()
```

### ❌ WRONG: Brittle Selectors

```typescript
// Breaks easily
await page.click('.css-class-xyz')
```

### ✅ CORRECT: Semantic Selectors

```typescript
// Resilient to changes
await page.click('button:has-text("Submit")')
await page.click('[data-testid="submit-button"]')
```

### ❌ WRONG: No Test Isolation

```typescript
// Tests depend on each other
test('creates user', () => { /* ... */ })
test('updates same user', () => { /* depends on previous test */ })
```

### ✅ CORRECT: Independent Tests

```typescript
// Each test sets up its own data
test('creates user', () => {
  const user = createTestUser()
  // Test logic
})

test('updates user', () => {
  const user = createTestUser()
  // Update logic
})
```

## Coverage Thresholds

```json
{
  "jest": {
    "coverageThresholds": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```

## Commands

```bash
# Run tests
npm test

# Watch mode during development (auto-run on file changes)
npm test -- --watch

# Coverage report
npm run test:coverage

# E2E tests
npx playwright test

# E2E with UI
npx playwright test --ui
```

## Continuous Testing

### Pre-Commit Hook

```bash
# Runs before every commit
npm test && npm run lint
```

## CI/CD

```yaml
# GitHub Actions
- name: Run Tests
  run: npm test -- --coverage
- name: Upload Coverage
  uses: codecov/codecov-action@v3
```
