import OpenAI from 'openai'
import { serverSupabaseClient } from '#supabase/server'

interface AnimeInfo {
  title: string
  description: string
  total_episodes: number
  start_chapter: number
  total_chapters: number
  ongoing: boolean
}

export default defineEventHandler(async (event) => {
  const { query } = await readBody<{ query: string }>(event)

  if (!query || query.trim().length < 2) {
    throw createError({
      statusCode: 400,
      message: 'Query trop courte'
    })
  }

  const supabase = await serverSupabaseClient(event)

  // 1. Chercher d'abord en BDD
  const { data: existingAnimes } = await supabase
    .from('animes')
    .select('*')
    .ilike('title', `%${query}%`)
    .limit(10)

  if (existingAnimes && existingAnimes.length > 0) {
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

  const prompt = `Tu es un expert en anime et manga. L'utilisateur cherche des informations sur "${query}".

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
        message: `Aucun anime trouvé pour "${query}"`
      }
    }

    const animeData: AnimeInfo = parsed.anime

    // 3. Sauvegarder en BDD
    const { data: newAnime, error } = await supabase
      .from('animes')
      .insert({
        title: animeData.title,
        description: animeData.description,
        total_episodes: animeData.total_episodes,
        start_chapter: animeData.start_chapter,
        total_chapters: animeData.total_chapters,
        ongoing: animeData.ongoing
      })
      .select()
      .single()

    if (error) {
      // Si doublon, récupérer l'existant
      if (error.code === '23505') {
        const { data: existing } = await supabase
          .from('animes')
          .select('*')
          .ilike('title', animeData.title)
          .single()

        return {
          source: 'database',
          animes: existing ? [existing] : []
        }
      }
      console.error('Supabase error:', error)
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
