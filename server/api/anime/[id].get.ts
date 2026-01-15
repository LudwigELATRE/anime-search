import { serverSupabaseClient } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')

  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'ID manquant'
    })
  }

  const supabase = await serverSupabaseClient(event)

  const { data: anime, error } = await supabase
    .from('animes')
    .select('*')
    .eq('id', id)
    .single()

  if (error || !anime) {
    throw createError({
      statusCode: 404,
      message: 'Anime non trouvé'
    })
  }

  return anime
})
