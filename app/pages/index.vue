<template>
  <main class="home">
    <!-- Hero with Search -->
    <section class="hero">
      <div class="hero__content">
        <h1 class="hero__title animate-fade-in">
          Où reprendre<br />
          en <span class="hero__accent">scan</span> ?
        </h1>
        <p class="hero__subtitle animate-fade-in animate-delay-1">
          Trouvez le chapitre exact du manga après avoir fini l'anime.
        </p>

        <!-- Search Bar -->
        <div class="search animate-fade-in animate-delay-2">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Rechercher un anime..."
            class="search__input"
            @input="handleSearch"
          />
          <div class="search__icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="11" cy="11" r="8" />
              <path d="m21 21-4.35-4.35" />
            </svg>
          </div>
        </div>
      </div>
    </section>

    <!-- Anime List -->
    <section class="list">
      <div class="list__header">
        <span class="list__count">
          <template v-if="isLoading || isSearching">Chargement...</template>
          <template v-else>{{ animes.length }} résultat{{ animes.length > 1 ? 's' : '' }}</template>
        </span>
        <div class="list__line" />
        <span v-if="searchSource === 'ai'" class="list__badge">IA</span>
      </div>

      <!-- Message de recherche -->
      <div v-if="searchMessage" class="search-message">
        {{ searchMessage }}
      </div>

      <div class="list__grid">
        <NuxtLink
          v-for="(anime, index) in animes"
          :key="anime.id"
          :to="`/animes/${anime.id}`"
          class="card animate-fade-in"
          :style="{ animationDelay: `${index * 50}ms` }"
        >
          <div class="card__header">
            <span class="card__status" :class="anime.ongoing ? 'card__status--ongoing' : ''">
              {{ anime.ongoing ? 'En cours' : 'Terminé' }}
            </span>
          </div>

          <h3 class="card__title">{{ anime.title }}</h3>

          <div class="card__info">
            <div class="card__row">
              <span class="card__label">Épisodes</span>
              <span class="card__value">{{ anime.total_episodes }}</span>
            </div>
            <div class="card__row card__row--highlight">
              <span class="card__label">Commencer au</span>
              <span class="card__chapter">Chap. {{ anime.start_chapter }}</span>
            </div>
          </div>

          <div class="card__footer">
            <span class="card__cta">Voir les détails</span>
            <span class="card__arrow">→</span>
          </div>
        </NuxtLink>
      </div>

      <!-- Empty state -->
      <div v-if="animes.length === 0 && !isLoading && !isSearching" class="empty">
        <p class="empty__text">
          <template v-if="searchQuery">Aucun anime trouvé pour "{{ searchQuery }}"</template>
          <template v-else>Recherchez un anime pour commencer</template>
        </p>
      </div>
    </section>
  </main>
</template>

<script setup lang="ts">
interface Anime {
  id: number
  title: string
  description?: string
  total_episodes: number
  start_chapter: number
  total_chapters?: number
  ongoing: boolean
}

const searchQuery = ref('')
const animes = ref<Anime[]>([])
const isLoading = ref(false)
const isSearching = ref(false)
const searchMessage = ref('')
const searchSource = ref<'database' | 'ai' | null>(null)

// Charger les animes au démarrage
const supabase = useSupabaseClient()

async function loadAnimes() {
  isLoading.value = true
  const { data } = await supabase
    .from('animes')
    .select('*')
    .order('created_at', { ascending: false })
    .limit(30)

  if (data) {
    animes.value = data
  }
  isLoading.value = false
}

// Recherche avec debounce
let searchTimeout: ReturnType<typeof setTimeout>

async function handleSearch() {
  clearTimeout(searchTimeout)

  if (!searchQuery.value || searchQuery.value.length < 2) {
    searchMessage.value = ''
    searchSource.value = null
    loadAnimes()
    return
  }

  searchTimeout = setTimeout(async () => {
    isSearching.value = true
    searchMessage.value = ''

    try {
      const response = await $fetch<{
        source: 'database' | 'ai'
        animes?: Anime[]
        found?: boolean
        message?: string
      }>('/api/anime/search', {
        method: 'POST',
        body: { query: searchQuery.value }
      })

      animes.value = response.animes || []
      searchSource.value = response.source

      if (response.source === 'ai' && response.found) {
        searchMessage.value = '✨ Trouvé par IA et ajouté à la base !'
      } else if (response.source === 'ai' && !response.found) {
        searchMessage.value = response.message || 'Aucun résultat'
      }
    } catch (error) {
      console.error('Search error:', error)
      searchMessage.value = 'Erreur lors de la recherche'
    }

    isSearching.value = false
  }, 500)
}

// Charger au montage
onMounted(() => {
  loadAnimes()
})
</script>

<style scoped>
.home {
  min-height: 100vh;
  background: var(--color-paper);
}

/* Hero */
.hero {
  padding: calc(var(--space-xl) + var(--space-lg)) var(--space-lg) var(--space-lg);
  background: var(--color-ink);
  color: var(--color-paper);
}

.hero__content {
  max-width: 800px;
  margin: 0 auto;
  text-align: center;
}

.hero__title {
  font-size: clamp(2.5rem, 6vw, 4rem);
  font-weight: 500;
  line-height: 1.1;
  margin-bottom: var(--space-sm);
  opacity: 0;
}

.hero__accent {
  font-family: var(--font-serif);
  font-style: italic;
  font-weight: 400;
  color: var(--color-vermillion);
}

.hero__subtitle {
  font-size: 1.125rem;
  color: var(--color-stone);
  margin-bottom: var(--space-lg);
  opacity: 0;
}

/* Search */
.search {
  position: relative;
  max-width: 500px;
  margin: 0 auto;
  opacity: 0;
}

.search__input {
  width: 100%;
  padding: var(--space-sm) var(--space-md);
  padding-left: 3.5rem;
  font-family: var(--font-display);
  font-size: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 0;
  color: var(--color-paper);
  transition: all var(--duration-normal) var(--ease-out-expo);
}

.search__input::placeholder {
  color: var(--color-stone);
}

.search__input:focus {
  outline: none;
  background: rgba(255, 255, 255, 0.08);
  border-color: var(--color-vermillion);
}

.search__icon {
  position: absolute;
  left: var(--space-sm);
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-stone);
}

/* List */
.list {
  padding: var(--space-lg);
  max-width: 1200px;
  margin: 0 auto;
}

.list__header {
  display: flex;
  align-items: center;
  gap: var(--space-md);
  margin-bottom: var(--space-md);
}

.list__count {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--color-stone);
  white-space: nowrap;
}

.list__line {
  flex: 1;
  height: 1px;
  background: var(--color-mist);
}

.list__badge {
  font-family: var(--font-display);
  font-size: 0.625rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  padding: 0.25rem 0.5rem;
  background: var(--color-vermillion);
  color: var(--color-paper);
}

.search-message {
  font-family: var(--font-serif);
  font-size: 1rem;
  color: var(--color-vermillion);
  text-align: center;
  padding: var(--space-sm) 0;
  margin-bottom: var(--space-md);
}

.list__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: var(--space-md);
}

/* Card */
.card {
  background: var(--color-paper);
  border: 1px solid var(--color-mist);
  padding: var(--space-md);
  transition: all var(--duration-normal) var(--ease-out-expo);
  opacity: 0;
}

.card:hover {
  border-color: var(--color-ink);
  transform: translateY(-4px);
}

.card__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-sm);
}

.card__status {
  font-family: var(--font-display);
  font-size: 0.625rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  padding: 0.25rem 0.5rem;
  background: var(--color-mist);
  color: var(--color-stone);
}

.card__status--ongoing {
  background: var(--color-vermillion-soft);
  color: var(--color-vermillion);
}

.card__title {
  font-family: var(--font-display);
  font-size: 1.5rem;
  font-weight: 500;
  margin-bottom: var(--space-md);
  line-height: 1.2;
}

.card__info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding: var(--space-sm) 0;
  border-top: 1px solid var(--color-mist);
  border-bottom: 1px solid var(--color-mist);
  margin-bottom: var(--space-sm);
}

.card__row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card__row--highlight {
  padding-top: 0.5rem;
}

.card__label {
  font-family: var(--font-serif);
  font-size: 0.875rem;
  color: var(--color-stone);
}

.card__value {
  font-family: var(--font-display);
  font-size: 0.875rem;
  font-weight: 500;
}

.card__chapter {
  font-family: var(--font-display);
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--color-vermillion);
}

.card__footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: var(--space-xs);
}

.card__cta {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--color-stone);
  transition: color var(--duration-fast) var(--ease-out-expo);
}

.card:hover .card__cta {
  color: var(--color-ink);
}

.card__arrow {
  font-size: 1rem;
  color: var(--color-stone);
  transition: all var(--duration-normal) var(--ease-out-expo);
}

.card:hover .card__arrow {
  color: var(--color-vermillion);
  transform: translateX(4px);
}

/* Empty */
.empty {
  padding: var(--space-xl);
  text-align: center;
}

.empty__text {
  font-family: var(--font-serif);
  font-size: 1.25rem;
  font-style: italic;
  color: var(--color-stone);
}

/* Responsive - Tablet */
@media (max-width: 768px) {
  .hero {
    padding: calc(var(--space-lg) + var(--space-md)) var(--space-md) var(--space-md);
  }

  .hero__subtitle {
    font-size: 1rem;
  }

  .list {
    padding: var(--space-md);
  }

  .list__grid {
    grid-template-columns: 1fr;
  }

  .card {
    padding: var(--space-sm);
  }

  .card__title {
    font-size: 1.25rem;
  }
}

/* Responsive - Mobile */
@media (max-width: 480px) {
  .hero {
    padding: calc(var(--space-md) + var(--space-lg)) var(--space-sm) var(--space-md);
  }

  .hero__title {
    font-size: 2rem;
  }

  .hero__subtitle {
    font-size: 0.875rem;
    margin-bottom: var(--space-md);
  }

  .search {
    max-width: 100%;
  }

  .search__input {
    padding: var(--space-sm);
    padding-left: 2.75rem;
    font-size: 0.875rem;
  }

  .search__icon {
    left: var(--space-xs);
  }

  .search__icon svg {
    width: 18px;
    height: 18px;
  }

  .list {
    padding: var(--space-sm);
  }

  .list__header {
    gap: var(--space-sm);
    margin-bottom: var(--space-sm);
  }

  .list__count {
    font-size: 0.625rem;
  }

  .list__grid {
    gap: var(--space-sm);
  }

  .card {
    padding: var(--space-sm);
  }

  .card__title {
    font-size: 1.125rem;
    margin-bottom: var(--space-sm);
  }

  .card__info {
    padding: var(--space-xs) 0;
  }

  .card__label {
    font-size: 0.75rem;
  }

  .card__value {
    font-size: 0.75rem;
  }

  .card__chapter {
    font-size: 1rem;
  }

  .card__cta {
    font-size: 0.625rem;
  }

  .empty {
    padding: var(--space-lg) var(--space-sm);
  }

  .empty__text {
    font-size: 1rem;
  }
}
</style>
