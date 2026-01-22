import OpenAI from 'openai'
import { query, queryOne } from '../../utils/db'
import type { Database } from '../../../types/database.types'

type AnimeRow = Database['public']['Tables']['animes']['Row']
type AnimeInsert = Database['public']['Tables']['animes']['Insert']

export default defineEventHandler(async (event) => {
  const { query: searchQuery } = await readBody<{ query: string }>(event)

  if (!searchQuery || searchQuery.trim().length < 2) {
    throw createError({
      statusCode: 400,
      message: 'Query trop courte'
    })
  }

  // 1. Chercher d'abord en BDD
  const existingAnimes = await query<AnimeRow>(
    `SELECT * FROM animes WHERE title ILIKE $1 LIMIT 10`,
    [`%${searchQuery}%`]
  )

  // Vérifie si les données ont plus de 30 jours
  const isExpired = (dateString: string | null | undefined): boolean => {
    if (!dateString) return true
    const createdDate = new Date(dateString)
    const limitDate = new Date()
    limitDate.setDate(limitDate.getDate() - 30)
    return createdDate < limitDate
  }

  const createdAt = existingAnimes[0]?.created_at ?? undefined

  if (existingAnimes.length > 0 && !isExpired(createdAt)) {
    return {
      source: 'database',
      animes: existingAnimes
    }
  }

  // 2. Si pas trouvé, demander à GPT-4o-mini
  const config = useRuntimeConfig()
  const openai = new OpenAI({
    apiKey: config.openaiApiKey
  })

  const prompt = `Tu es un expert en anime et manga. L'utilisateur cherche des informations sur "${searchQuery}".

Réponds UNIQUEMENT en JSON valide avec ce format exact (pas de texte avant ou après):
{
  "found": true ou false,
  "anime": {
    "title": "Titre officiel de l'anime",
    "description": "Description courte en français (2-3 phrases)",
    "total_episodes": nombre total d'épisodes de l'anime (actuellement diffusés),
    "start_chapter": numéro du chapitre du manga où reprendre après le dernier épisode,
    "total_chapters": nombre total de chapitres du manga,
    "ongoing": true si l'anime ou manga est en cours, false sinon
  }
}

Si l'anime n'existe pas ou n'a pas de manga source, réponds: {"found": false, "anime": null}

IMPORTANT:
- start_chapter = le chapitre APRÈS lequel le dernier épisode de l'anime s'arrête
- Donne des chiffres précis basés sur tes connaissances`

  try {
    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.3,
      max_tokens: 500
    })

    const responseText = completion.choices[0]?.message?.content || ''

    // Parser la réponse JSON
    let parsed
    try {
      parsed = JSON.parse(responseText)
    } catch {
      throw createError({
        statusCode: 500,
        message: 'Erreur parsing réponse IA'
      })
    }

    if (!parsed.found || !parsed.anime) {
      return {
        source: 'ai',
        found: false,
        message: `Aucun anime trouvé pour "${searchQuery}"`
      }
    }

    const animeData: AnimeInsert = {
      title: parsed.anime.title,
      description: parsed.anime.description,
      total_episodes: parsed.anime.total_episodes,
      start_chapter: parsed.anime.start_chapter,
      total_chapters: parsed.anime.total_chapters,
      ongoing: parsed.anime.ongoing
    }

    // 3. Sauvegarder ou mettre à jour en BDD
    const existingAnime = existingAnimes[0]

    let newAnime: AnimeRow | null = null

    if (existingAnime) {
      // UPDATE si l'anime existe déjà (données expirées)
      newAnime = await queryOne<AnimeRow>(
        `UPDATE animes
         SET description = $1, total_episodes = $2, start_chapter = $3,
             total_chapters = $4, ongoing = $5, created_at = NOW()
         WHERE id = $6
         RETURNING *`,
        [
          animeData.description,
          animeData.total_episodes,
          animeData.start_chapter,
          animeData.total_chapters,
          animeData.ongoing,
          existingAnime.id
        ]
      )
    } else {
      // INSERT si nouvel anime
      newAnime = await queryOne<AnimeRow>(
        `INSERT INTO animes (title, description, total_episodes, start_chapter, total_chapters, ongoing)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (title) DO UPDATE SET
           description = EXCLUDED.description,
           total_episodes = EXCLUDED.total_episodes,
           start_chapter = EXCLUDED.start_chapter,
           total_chapters = EXCLUDED.total_chapters,
           ongoing = EXCLUDED.ongoing,
           created_at = NOW()
         RETURNING *`,
        [
          animeData.title,
          animeData.description,
          animeData.total_episodes,
          animeData.start_chapter,
          animeData.total_chapters,
          animeData.ongoing
        ]
      )
    }

    return {
      source: 'ai',
      found: true,
      animes: newAnime ? [newAnime] : [animeData]
    }

  } catch (err) {
    console.error('OpenAI error:', err)
    throw createError({
      statusCode: 500,
      message: 'Erreur lors de la recherche IA'
    })
  }
})
