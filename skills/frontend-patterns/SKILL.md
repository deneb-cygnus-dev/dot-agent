---
name: frontend-patterns
description: Frontend development patterns for React, Next.js, state management, performance optimization, and UI best practices.
---

# Frontend Development Patterns

Modern frontend patterns for React, Next.js, and performant user interfaces.

## Component Patterns

### Composition

```typescript
interface CardProps {
  children: React.ReactNode
  variant?: 'default' | 'outlined'
}

export function Card({ children, variant = 'default' }: CardProps) {
  return <div className={`card card-${variant}`}>{children}</div>
}

export function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header">{children}</div>
}

export function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="card-body">{children}</div>
}

// Usage
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
</Card>
```

### Compound Components

```typescript
const TabsContext = createContext<{
  activeTab: string
  setActiveTab: (tab: string) => void
} | undefined>(undefined)

export function Tabs({ children, defaultTab }: { children: React.ReactNode; defaultTab: string }) {
  const [activeTab, setActiveTab] = useState(defaultTab)
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      {children}
    </TabsContext.Provider>
  )
}

export function Tab({ id, children }: { id: string; children: React.ReactNode }) {
  const ctx = useContext(TabsContext)
  if (!ctx) throw new Error('Tab must be used within Tabs')

  return (
    <button className={ctx.activeTab === id ? 'active' : ''} onClick={() => ctx.setActiveTab(id)}>
      {children}
    </button>
  )
}

// Usage
<Tabs defaultTab="overview">
  <Tab id="overview">Overview</Tab>
  <Tab id="details">Details</Tab>
</Tabs>
```

### Render Props

```typescript
interface DataLoaderProps<T> {
  url: string
  children: (data: T | null, loading: boolean, error: Error | null) => React.ReactNode
}

export function DataLoader<T>({ url, children }: DataLoaderProps<T>) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [url])

  return <>{children(data, loading, error)}</>
}

// Usage
<DataLoader<Market[]> url="/api/markets">
  {(markets, loading, error) => {
    if (loading) return <Spinner />
    if (error) return <Error error={error} />
    return <MarketList markets={markets!} />
  }}
</DataLoader>
```

## Custom Hooks

### Common Utilities

```typescript
// Toggle state
export function useToggle(initial = false): [boolean, () => void] {
  const [value, setValue] = useState(initial)
  const toggle = useCallback(() => setValue(v => !v), [])
  return [value, toggle]
}

// Debounced value
export function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value)

  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay)
    return () => clearTimeout(timer)
  }, [value, delay])

  return debounced
}

// Usage
const [isOpen, toggleOpen] = useToggle()
const debouncedQuery = useDebounce(searchQuery, 500)
```

### Data Fetching Hook

```typescript
export function useQuery<T>(key: string, fetcher: () => Promise<T>, options?: {
  onSuccess?: (data: T) => void
  onError?: (error: Error) => void
  enabled?: boolean
}) {
  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<Error | null>(null)
  const [loading, setLoading] = useState(false)

  const refetch = useCallback(async () => {
    setLoading(true)
    try {
      const result = await fetcher()
      setData(result)
      options?.onSuccess?.(result)
    } catch (err) {
      setError(err as Error)
      options?.onError?.(err as Error)
    } finally {
      setLoading(false)
    }
  }, [fetcher])

  useEffect(() => {
    if (options?.enabled !== false) refetch()
  }, [key])

  return { data, error, loading, refetch }
}

// Usage
const { data: markets, loading } = useQuery('markets', () =>
  fetch('/api/markets').then(r => r.json())
)
```

## State Management

### Context + Reducer

```typescript
type Action =
  | { type: 'SET_MARKETS'; payload: Market[] }
  | { type: 'SELECT_MARKET'; payload: Market }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'SET_MARKETS':
      return { ...state, markets: action.payload }
    case 'SELECT_MARKET':
      return { ...state, selectedMarket: action.payload }
    default:
      return state
  }
}

const MarketContext = createContext<{
  state: State
  dispatch: Dispatch<Action>
} | undefined>(undefined)

export function MarketProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, { markets: [], selectedMarket: null })
  return (
    <MarketContext.Provider value={{ state, dispatch }}>
      {children}
    </MarketContext.Provider>
  )
}

export function useMarkets() {
  const ctx = useContext(MarketContext)
  if (!ctx) throw new Error('useMarkets must be used within MarketProvider')
  return ctx
}
```

## Performance

### Memoization

```typescript
// useMemo for expensive computations (spread to avoid mutation)
const sortedMarkets = useMemo(() =>
  [...markets].sort((a, b) => b.volume - a.volume),
  [markets]
)

// useCallback for functions passed to children
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query)
}, [])

// React.memo for pure components
export const MarketCard = React.memo<MarketCardProps>(({ market }) => (
  <div className="market-card">
    <h3>{market.name}</h3>
  </div>
))
```

### Code Splitting

```typescript
import { lazy, Suspense } from 'react'

const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<ChartSkeleton />}>
      <HeavyChart data={data} />
    </Suspense>
  )
}
```

### Virtualization

```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

export function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null)

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 100,
    overscan: 5
  })

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div style={{ height: virtualizer.getTotalSize(), position: 'relative' }}>
        {virtualizer.getVirtualItems().map(row => (
          <div
            key={row.index}
            style={{
              position: 'absolute',
              top: row.start,
              height: row.size,
              width: '100%'
            }}
          >
            <ItemCard item={items[row.index]} />
          </div>
        ))}
      </div>
    </div>
  )
}
```

## Form Handling

```typescript
interface FormData { name: string; description: string }
interface FormErrors { name?: string; description?: string }

export function CreateForm() {
  const [data, setData] = useState<FormData>({ name: '', description: '' })
  const [errors, setErrors] = useState<FormErrors>({})

  const validate = (): boolean => {
    const errs: FormErrors = {}
    if (!data.name.trim()) errs.name = 'Required'
    if (data.name.length > 200) errs.name = 'Too long'
    setErrors(errs)
    return Object.keys(errs).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!validate()) return
    await createMarket(data)
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={data.name}
        onChange={e => setData(prev => ({ ...prev, name: e.target.value }))}
      />
      {errors.name && <span className="error">{errors.name}</span>}
      <button type="submit">Create</button>
    </form>
  )
}
```

## Error Boundary

```typescript
export class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean; error: Error | null }
> {
  state = { hasError: false, error: null }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error boundary:', error, errorInfo)
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-fallback">
          <h2>Something went wrong</h2>
          <button onClick={() => this.setState({ hasError: false })}>Retry</button>
        </div>
      )
    }
    return this.props.children
  }
}

// Usage
<ErrorBoundary><App /></ErrorBoundary>
```

## Animations

```typescript
import { motion, AnimatePresence } from 'framer-motion'

// List animations
export function AnimatedList({ items }: { items: Item[] }) {
  return (
    <AnimatePresence>
      {items.map(item => (
        <motion.div
          key={item.id}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -20 }}
        >
          <ItemCard item={item} />
        </motion.div>
      ))}
    </AnimatePresence>
  )
}

// Modal animation
export function Modal({ isOpen, onClose, children }: ModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.95 }}
        >
          {children}
        </motion.div>
      )}
    </AnimatePresence>
  )
}
```

## Accessibility

### Keyboard Navigation

```typescript
export function Dropdown({ options, onSelect }: DropdownProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [activeIndex, setActiveIndex] = useState(0)

  const handleKeyDown = (e: React.KeyboardEvent) => {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        setActiveIndex(i => Math.min(i + 1, options.length - 1))
        break
      case 'ArrowUp':
        e.preventDefault()
        setActiveIndex(i => Math.max(i - 1, 0))
        break
      case 'Enter':
        onSelect(options[activeIndex])
        setIsOpen(false)
        break
      case 'Escape':
        setIsOpen(false)
        break
    }
  }

  return (
    <div role="combobox" aria-expanded={isOpen} onKeyDown={handleKeyDown}>
      {/* Implementation */}
    </div>
  )
}
```

### Focus Management

```typescript
export function Modal({ isOpen, onClose, children }: ModalProps) {
  const modalRef = useRef<HTMLDivElement>(null)
  const prevFocus = useRef<HTMLElement | null>(null)

  useEffect(() => {
    if (isOpen) {
      prevFocus.current = document.activeElement as HTMLElement
      modalRef.current?.focus()
    } else {
      prevFocus.current?.focus()
    }
  }, [isOpen])

  if (!isOpen) return null

  return (
    <div ref={modalRef} role="dialog" aria-modal tabIndex={-1} onKeyDown={e => e.key === 'Escape' && onClose()}>
      {children}
    </div>
  )
}
```

**Remember**: Choose patterns that fit your project complexity. Start simple, add abstraction when needed.
