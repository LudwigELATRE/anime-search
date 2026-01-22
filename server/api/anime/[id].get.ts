import { queryOne } from '../../utils/db'
import type { Database } from '../../../types/database.types'

type AnimeRow = Database['public']['Tables']['animes']['Row']

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')

  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'ID manquant'
    })
  }

  const anime = await queryOne<AnimeRow>(
    'SELECT * FROM animes WHERE id = $1',
    [id]
  )

  if (!anime) {
    throw createError({
      statusCode: 404,
      message: 'Anime non trouvé'
    })
  }

  return anime
})
