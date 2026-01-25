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

## Commands

```bash
# Run tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage

# E2E tests
npx playwright test

# E2E with UI
npx playwright test --ui
```

## CI/CD

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
- run: npm ci
- run: npm test -- --coverage
```
