# TypeScript/JavaScript Standards

## Naming Conventions

### Variables

```typescript
// GOOD: Descriptive names
const marketSearchQuery = 'election'
const isUserAuthenticated = true
const totalRevenue = 1000

// BAD: Unclear names
const q = 'election'
const flag = true
const x = 1000
```

### Functions

```typescript
// GOOD: Verb-noun pattern
async function fetchMarketData(marketId: string) { }
function calculateSimilarity(a: number[], b: number[]) { }
function isValidEmail(email: string): boolean { }

// BAD: Unclear or noun-only
async function market(id: string) { }
function similarity(a, b) { }
```

## Immutability Pattern (CRITICAL)

```typescript
// ALWAYS use spread operator
const updatedUser = { ...user, name: 'New Name' }
const updatedArray = [...items, newItem]

// NEVER mutate directly
user.name = 'New Name'  // BAD
items.push(newItem)     // BAD
```

## Error Handling

```typescript
// GOOD: Comprehensive error handling
async function fetchData(url: string) {
  try {
    const response = await fetch(url)
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }
    return await response.json()
  } catch (error) {
    console.error('Fetch failed:', error)
    throw new Error('Failed to fetch data')
  }
}
```

## Async/Await

```typescript
// GOOD: Parallel execution when possible
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats()
])

// BAD: Sequential when unnecessary
const users = await fetchUsers()
const markets = await fetchMarkets()
const stats = await fetchStats()
```

## Type Safety

```typescript
// GOOD: Proper types
interface Market {
  id: string
  name: string
  status: 'active' | 'resolved' | 'closed'
  created_at: Date
}

function getMarket(id: string): Promise<Market> { }

// BAD: Using 'any'
function getMarket(id: any): Promise<any> { }
```

## React Best Practices

### Component Structure

```typescript
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}
```

### Custom Hooks

```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

### State Management

```typescript
const [count, setCount] = useState(0)

// GOOD: Functional update for state based on previous state
setCount(prev => prev + 1)

// BAD: Direct state reference (can be stale)
setCount(count + 1)
```

### Conditional Rendering

```typescript
// GOOD: Clear conditional rendering
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// BAD: Ternary hell
{isLoading ? <Spinner /> : error ? <ErrorMessage /> : data ? <DataDisplay /> : null}
```

## API Design

### REST Conventions

```text
GET    /api/markets              # List
GET    /api/markets/:id          # Get
POST   /api/markets              # Create
PUT    /api/markets/:id          # Update (full)
PATCH  /api/markets/:id          # Update (partial)
DELETE /api/markets/:id          # Delete
```

### Response Format

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: { total: number; page: number; limit: number }
}
```

### Input Validation (Zod)

```typescript
import { z } from 'zod'

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1)
})

export async function POST(request: Request) {
  const body = await request.json()
  try {
    const validated = CreateMarketSchema.parse(body)
    // Proceed with validated data
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: 'Validation failed',
        details: error.errors
      }, { status: 400 })
    }
  }
}
```

## File Organization

```text
src/
├── app/                    # Next.js App Router
│   ├── api/               # API routes
│   └── (auth)/           # Route groups
├── components/            # React components
│   ├── ui/               # Generic UI
│   └── forms/            # Form components
├── hooks/                # Custom hooks
├── lib/                  # Utilities
└── types/                # TypeScript types
```

## Performance

### Memoization

```typescript
import { useMemo, useCallback } from 'react'

// Memoize expensive computations (spread to avoid mutation)
const sortedMarkets = useMemo(() => {
  return [...markets].sort((a, b) => b.volume - a.volume)
}, [markets])

// Memoize callbacks
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query)
}, [])
```

### Lazy Loading

```typescript
import { lazy, Suspense } from 'react'

const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyChart />
    </Suspense>
  )
}
```

## Testing

```typescript
import { render, screen, fireEvent } from '@testing-library/react'

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

## Code Smells

### Deep Nesting

```typescript
// BAD
if (user) {
  if (user.isAdmin) {
    if (market) {
      if (market.isActive) {
        // Do something
      }
    }
  }
}

// GOOD: Early returns
if (!user) return
if (!user.isAdmin) return
if (!market) return
if (!market.isActive) return
// Do something
```

### Magic Numbers

```typescript
// BAD
if (retryCount > 3) { }
setTimeout(callback, 500)

// GOOD
const MAX_RETRIES = 3
const DEBOUNCE_DELAY_MS = 500

if (retryCount > MAX_RETRIES) { }
setTimeout(callback, DEBOUNCE_DELAY_MS)
```
