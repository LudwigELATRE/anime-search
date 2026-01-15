<template>
  <header class="header">
    <nav class="header__nav">
      <!-- Logo -->
      <NuxtLink to="/" class="header__logo">
        <span class="header__logo-text">Anime</span>
        <span class="header__logo-accent">アニメ</span>
      </NuxtLink>

      <!-- Navigation -->
      <div class="header__links">
        <NuxtLink to="/animes" class="header__link hover-line">
          Collection
        </NuxtLink>
      </div>

      <!-- Decorative line -->
      <div class="header__line line-reveal" />
    </nav>
  </header>
</template>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: var(--space-sm) var(--space-md);
  background: var(--color-paper);
  mix-blend-mode: difference;
}

.header__nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1400px;
  margin: 0 auto;
  position: relative;
}

.header__logo {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
  font-family: var(--font-display);
  font-weight: 600;
  font-size: 1.25rem;
  letter-spacing: -0.03em;
  color: var(--color-paper);
}

.header__logo-accent {
  font-family: var(--font-serif);
  font-weight: 400;
  font-style: italic;
  color: var(--color-vermillion);
  font-size: 1rem;
}

.header__links {
  display: flex;
  gap: var(--space-md);
}

.header__link {
  font-family: var(--font-display);
  font-size: 0.875rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--color-paper);
  transition: opacity var(--duration-fast) var(--ease-out-expo);
}

.header__link:hover {
  opacity: 0.6;
}

.header__line {
  position: absolute;
  bottom: -0.5rem;
  left: 0;
  right: 0;
  height: 1px;
  background: var(--color-paper);
  opacity: 0.2;
}

/* Responsive - Tablet */
@media (max-width: 768px) {
  .header {
    padding: var(--space-xs) var(--space-sm);
  }

  .header__logo {
    font-size: 1.125rem;
    gap: 0.375rem;
  }

  .header__logo-accent {
    font-size: 0.875rem;
  }

  .header__link {
    font-size: 0.75rem;
  }
}

/* Responsive - Mobile */
@media (max-width: 480px) {
  .header {
    padding: var(--space-xs) var(--space-xs);
  }

  .header__logo {
    font-size: 1rem;
    gap: 0.25rem;
  }

  .header__logo-accent {
    font-size: 0.75rem;
  }

  .header__link {
    font-size: 0.625rem;
    letter-spacing: 0.05em;
  }

  .header__line {
    bottom: -0.25rem;
  }
}
</style>
