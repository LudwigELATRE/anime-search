<template>
  <main class="detail">
    <!-- Loading -->
    <div v-if="pending" class="loading">
      Chargement...
    </div>

    <!-- Error -->
    <div v-else-if="error" class="error">
      <p>Anime non trouvé</p>
      <NuxtLink to="/" class="error__link">← Retour à l'accueil</NuxtLink>
    </div>

    <!-- Content -->
    <template v-else-if="anime">
      <!-- Back link -->
      <NuxtLink to="/" class="detail__back animate-fade-in">
        <span class="detail__back-arrow">←</span>
        <span class="detail__back-text">Retour</span>
      </NuxtLink>

      <!-- Header -->
      <header class="detail__header">
        <div class="detail__meta animate-fade-in animate-delay-1">
          <span class="detail__status" :class="anime.ongoing ? 'detail__status--ongoing' : ''">
            {{ anime.ongoing ? 'En cours' : 'Terminé' }}
          </span>
          <span class="detail__separator">·</span>
          <span class="detail__episodes">{{ anime.total_episodes }} épisodes</span>
        </div>

        <h1 class="detail__title animate-fade-in animate-delay-2">
          {{ anime.title }}
        </h1>

        <p class="detail__description animate-fade-in animate-delay-3">
          {{ anime.description }}
        </p>
      </header>

      <!-- Main info card -->
      <div class="info-card animate-fade-in animate-delay-4">
        <div class="info-card__header">
          <span class="info-card__label">Où commencer le scan ?</span>
        </div>

        <div class="info-card__chapter">
          <span class="info-card__chapter-label">Chapitre</span>
          <span class="info-card__chapter-number">{{ anime.start_chapter }}</span>
        </div>

        <div class="info-card__note">
          <p>
            L'anime couvre les chapitres <strong>1 à {{ anime.start_chapter - 1 }}</strong> du manga.
            Pour continuer l'histoire, commencez au <strong>chapitre {{ anime.start_chapter }}</strong>.
          </p>
        </div>

        <div class="info-card__details">
          <div class="info-card__row">
            <span class="info-card__row-label">Dernier épisode</span>
            <span class="info-card__row-value">Ép. {{ anime.total_episodes }}</span>
          </div>
          <div class="info-card__row">
            <span class="info-card__row-label">Chapitres adaptés</span>
            <span class="info-card__row-value">1 — {{ anime.start_chapter - 1 }}</span>
          </div>
          <div v-if="anime.total_chapters" class="info-card__row">
            <span class="info-card__row-label">Chapitres restants</span>
            <span class="info-card__row-value">{{ anime.total_chapters - anime.start_chapter + 1 }}+</span>
          </div>
        </div>
      </div>

      <!-- Tips -->
      <section class="tips animate-fade-in animate-delay-5">
        <h2 class="tips__title">Conseils</h2>
        <ul class="tips__list">
          <li class="tips__item">
            <span class="tips__bullet" />
            <span>Certaines scènes de l'anime sont originales et n'apparaissent pas dans le manga.</span>
          </li>
          <li class="tips__item">
            <span class="tips__bullet" />
            <span>Vous pouvez relire les derniers chapitres adaptés pour une meilleure transition.</span>
          </li>
        </ul>
      </section>
    </template>
  </main>
</template>

<script setup lang="ts">
const route = useRoute()
const id = route.params.id as string

interface Anime {
  id: number
  title: string
  description: string
  total_episodes: number
  start_chapter: number
  total_chapters: number | null
  ongoing: boolean
}

const { data: anime, pending, error } = await useFetch<Anime>(`/api/anime/${id}`)
</script>

<style scoped>
.detail {
  min-height: 100vh;
  padding: calc(var(--space-xl) + var(--space-md)) var(--space-lg) var(--space-xl);
  max-width: 720px;
  margin: 0 auto;
}

/* Back */
.detail__back {
  display: inline-flex;
  align-items: center;
  gap: var(--space-xs);
  font-family: var(--font-display);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-stone);
  margin-bottom: var(--space-lg);
  transition: color var(--duration-fast) var(--ease-out-expo);
  opacity: 0;
}

.detail__back:hover {
  color: var(--color-ink);
}

.detail__back-arrow {
  transition: transform var(--duration-normal) var(--ease-out-expo);
}

.detail__back:hover .detail__back-arrow {
  transform: translateX(-4px);
}

/* Header */
.detail__header {
  margin-bottom: var(--space-lg);
}

.detail__meta {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  margin-bottom: var(--space-sm);
  opacity: 0;
}

.detail__status {
  font-family: var(--font-display);
  font-size: 0.625rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  padding: 0.25rem 0.5rem;
  background: var(--color-mist);
  color: var(--color-stone);
}

.detail__status--ongoing {
  background: var(--color-vermillion-soft);
  color: var(--color-vermillion);
}

.detail__separator {
  color: var(--color-mist);
}

.detail__episodes {
  font-family: var(--font-display);
  font-size: 0.75rem;
  color: var(--color-stone);
}

.detail__title {
  font-size: clamp(2rem, 5vw, 3rem);
  font-weight: 500;
  line-height: 1.1;
  margin-bottom: var(--space-sm);
  opacity: 0;
}

.detail__description {
  font-family: var(--font-serif);
  font-size: 1.125rem;
  line-height: 1.7;
  color: var(--color-stone);
  opacity: 0;
}

/* Info Card */
.info-card {
  background: var(--color-ink);
  color: var(--color-paper);
  padding: var(--space-md);
  margin-bottom: var(--space-lg);
  opacity: 0;
}

.info-card__header {
  margin-bottom: var(--space-md);
}

.info-card__label {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--color-stone);
}

.info-card__chapter {
  display: flex;
  align-items: baseline;
  gap: var(--space-sm);
  margin-bottom: var(--space-md);
  padding-bottom: var(--space-md);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.info-card__chapter-label {
  font-family: var(--font-serif);
  font-size: 1.25rem;
  font-style: italic;
  color: var(--color-stone);
}

.info-card__chapter-number {
  font-family: var(--font-display);
  font-size: 4rem;
  font-weight: 600;
  line-height: 1;
  color: var(--color-vermillion);
}

.info-card__note {
  font-family: var(--font-serif);
  font-size: 1rem;
  line-height: 1.6;
  color: var(--color-stone);
  margin-bottom: var(--space-md);
}

.info-card__note strong {
  color: var(--color-paper);
  font-weight: 500;
}

.info-card__details {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding-top: var(--space-sm);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.info-card__row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.info-card__row-label {
  font-family: var(--font-serif);
  font-size: 0.875rem;
  color: var(--color-stone);
}

.info-card__row-value {
  font-family: var(--font-display);
  font-size: 0.875rem;
  font-weight: 500;
}

/* Tips */
.tips {
  opacity: 0;
}

.tips__title {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--color-stone);
  margin-bottom: var(--space-sm);
}

.tips__list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tips__item {
  display: flex;
  align-items: flex-start;
  gap: var(--space-sm);
  font-family: var(--font-serif);
  font-size: 1rem;
  color: var(--color-stone);
  margin-bottom: var(--space-xs);
}

.tips__bullet {
  width: 4px;
  height: 4px;
  background: var(--color-vermillion);
  border-radius: 50%;
  margin-top: 0.6rem;
  flex-shrink: 0;
}

/* Loading & Error states */
.loading,
.error {
  min-height: 50vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-md);
  font-family: var(--font-serif);
  font-size: 1.125rem;
  color: var(--color-stone);
}

.error__link {
  font-family: var(--font-display);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-vermillion);
  transition: opacity var(--duration-fast) var(--ease-out-expo);
}

.error__link:hover {
  opacity: 0.7;
}

/* Responsive - Tablet */
@media (max-width: 768px) {
  .detail {
    padding: calc(var(--space-lg) + var(--space-md)) var(--space-md) var(--space-lg);
  }

  .detail__description {
    font-size: 1rem;
  }

  .info-card__chapter-number {
    font-size: 3rem;
  }

  .info-card__note {
    font-size: 0.875rem;
  }
}

/* Responsive - Mobile */
@media (max-width: 480px) {
  .detail {
    padding: calc(var(--space-md) + var(--space-lg)) var(--space-sm) var(--space-md);
  }

  .detail__back {
    font-size: 0.75rem;
    margin-bottom: var(--space-md);
  }

  .detail__header {
    margin-bottom: var(--space-md);
  }

  .detail__meta {
    gap: var(--space-xs);
    flex-wrap: wrap;
  }

  .detail__status {
    font-size: 0.5rem;
  }

  .detail__episodes {
    font-size: 0.625rem;
  }

  .detail__title {
    font-size: 1.5rem;
  }

  .detail__description {
    font-size: 0.875rem;
    line-height: 1.6;
  }

  .info-card {
    padding: var(--space-sm);
    margin-bottom: var(--space-md);
  }

  .info-card__header {
    margin-bottom: var(--space-sm);
  }

  .info-card__label {
    font-size: 0.625rem;
  }

  .info-card__chapter {
    margin-bottom: var(--space-sm);
    padding-bottom: var(--space-sm);
  }

  .info-card__chapter-label {
    font-size: 1rem;
  }

  .info-card__chapter-number {
    font-size: 2.5rem;
  }

  .info-card__note {
    font-size: 0.8125rem;
    margin-bottom: var(--space-sm);
  }

  .info-card__details {
    padding-top: var(--space-xs);
  }

  .info-card__row-label {
    font-size: 0.75rem;
  }

  .info-card__row-value {
    font-size: 0.75rem;
  }

  .tips__title {
    font-size: 0.625rem;
  }

  .tips__item {
    font-size: 0.875rem;
    gap: var(--space-xs);
  }

  .tips__bullet {
    margin-top: 0.5rem;
  }
}
</style>
