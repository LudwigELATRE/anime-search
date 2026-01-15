import { serverSupabaseClient } from '#supabase/server'

const animes = [
  {
    title: 'Attack on Titan',
    description: "Dans un monde où l'humanité vit retranchée derrière d'immenses murs pour se protéger de titans mangeurs d'hommes, Eren Jäger jure d'exterminer ces créatures après avoir vu sa mère dévorée.",
    total_episodes: 87,
    start_chapter: 139,
    total_chapters: 139,
    ongoing: false
  },
  {
    title: 'Demon Slayer: Kimetsu no Yaiba',
    description: "Tanjiro Kamado devient pourfendeur de démons après que sa famille a été massacrée et sa sœur Nezuko transformée en démon. Il cherche un remède pour la guérir.",
    total_episodes: 55,
    start_chapter: 98,
    total_chapters: 205,
    ongoing: false
  },
  {
    title: 'My Hero Academia',
    description: "Dans un monde où 80% de la population possède un super-pouvoir, Izuku Midoriya naît sans don mais rêve de devenir un héros. Son destin change quand il rencontre All Might.",
    total_episodes: 138,
    start_chapter: 329,
    total_chapters: 430,
    ongoing: false
  },
  {
    title: 'Jujutsu Kaisen',
    description: "Yuji Itadori, lycéen aux capacités physiques hors normes, avale un doigt maudit appartenant au roi des fléaux Sukuna et intègre l'école d'exorcisme de Tokyo.",
    total_episodes: 47,
    start_chapter: 134,
    total_chapters: 271,
    ongoing: false
  },
  {
    title: 'One Piece',
    description: "Monkey D. Luffy part à l'aventure pour trouver le légendaire One Piece et devenir le roi des pirates. Il rassemble un équipage de compagnons aux rêves aussi grands que le sien.",
    total_episodes: 1122,
    start_chapter: 1100,
    total_chapters: 1139,
    ongoing: true
  },
  {
    title: 'Naruto Shippuden',
    description: "Deux ans après son départ, Naruto revient au village de Konoha plus fort que jamais. Il doit affronter l'organisation Akatsuki qui cherche à capturer tous les démons à queues.",
    total_episodes: 500,
    start_chapter: 700,
    total_chapters: 700,
    ongoing: false
  },
  {
    title: 'Tokyo Revengers',
    description: "Takemichi Hanagaki découvre qu'il peut voyager dans le temps après avoir appris la mort de son ex-petite amie. Il décide de changer le passé pour la sauver.",
    total_episodes: 37,
    start_chapter: 132,
    total_chapters: 278,
    ongoing: false
  },
  {
    title: 'Chainsaw Man',
    description: "Denji, un jeune homme endetté, fusionne avec son démon-tronçonneuse Pochita et devient Chainsaw Man. Il rejoint une organisation gouvernementale de chasseurs de démons.",
    total_episodes: 12,
    start_chapter: 38,
    total_chapters: 185,
    ongoing: true
  },
  {
    title: 'Spy x Family',
    description: "Un espion d'élite doit créer une fausse famille pour sa mission. Il adopte une télépathe sans le savoir et épouse une assassin. Chacun cache son identité aux autres.",
    total_episodes: 37,
    start_chapter: 38,
    total_chapters: 107,
    ongoing: true
  },
  {
    title: 'Blue Lock',
    description: "300 lycéens footballeurs sont enfermés dans un programme d'entraînement pour créer le meilleur attaquant du monde. Seul l'égoïsme permet de survivre dans Blue Lock.",
    total_episodes: 24,
    start_chapter: 95,
    total_chapters: 287,
    ongoing: true
  },
  {
    title: 'Death Note',
    description: "Light Yagami, lycéen surdoué, trouve un carnet permettant de tuer quiconque dont le nom y est inscrit. Il décide de créer un monde sans criminels.",
    total_episodes: 37,
    start_chapter: 108,
    total_chapters: 108,
    ongoing: false
  },
  {
    title: 'Fullmetal Alchemist: Brotherhood',
    description: "Deux frères alchimistes cherchent la pierre philosophale pour récupérer leurs corps perdus lors d'une transmutation humaine interdite visant à ressusciter leur mère.",
    total_episodes: 64,
    start_chapter: 108,
    total_chapters: 108,
    ongoing: false
  },
  {
    title: 'Hunter x Hunter',
    description: "Gon Freecss part à la recherche de son père, un légendaire Hunter. Pour le retrouver, il doit d'abord réussir l'examen Hunter, réputé mortel.",
    total_episodes: 148,
    start_chapter: 339,
    total_chapters: 400,
    ongoing: true
  },
  {
    title: 'Vinland Saga',
    description: "Thorfinn, fils d'un grand guerrier viking, jure de venger la mort de son père. Son voyage le mène à questionner la violence et à chercher la terre légendaire de Vinland.",
    total_episodes: 48,
    start_chapter: 100,
    total_chapters: 212,
    ongoing: true
  },
  {
    title: 'Bleach: Thousand-Year Blood War',
    description: "Le dernier arc de Bleach. Les Quincy attaquent la Soul Society et menacent de détruire l'équilibre des mondes. Ichigo doit découvrir ses vraies origines pour vaincre.",
    total_episodes: 39,
    start_chapter: 617,
    total_chapters: 686,
    ongoing: false
  }
]

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient(event)

  const results = []

  for (const anime of animes) {
    const { data, error } = await supabase
      .from('animes')
      .upsert(anime, { onConflict: 'title' })
      .select()
      .single()

    if (error) {
      results.push({ title: anime.title, status: 'error', error: error.message })
    } else {
      results.push({ title: anime.title, status: 'success', id: data?.id })
    }
  }

  return {
    message: `${results.filter(r => r.status === 'success').length}/${animes.length} animes ajoutés`,
    results
  }
})
