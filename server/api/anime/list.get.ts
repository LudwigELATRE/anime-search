import { query } from '../../utils/db'
import type { Database } from '../../../types/database.types'

type AnimeRow = Database['public']['Tables']['animes']['Row']

export default defineEventHandler(async () => {
  const animes = await query<AnimeRow>(
    'SELECT * FROM animes ORDER BY created_at DESC LIMIT 30'
  )
  return animes
})
