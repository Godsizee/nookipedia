/**
 * Pre-built search index, generated at build time and served as a static,
 * same-origin asset (output: 'static' prerenders this to dist/search-index.json).
 *
 * The spotlight popup and the full search page used to call the Directus
 * backend directly from the browser. Any cross-origin hiccup there (CORS,
 * backend downtime, slow cold start) surfaced as a hard connection error with
 * no way to recover. Searching this bundled index instead means the search
 * UI no longer depends on a live cross-origin request succeeding at all -
 * the same resilience the rest of the site already gets from fetching
 * Directus at build time (see lib/api.js).
 */
import { getCreatures, getFlowers, getRecipes, getArtworks, getFossils, DEFAULT_DIRECTUS } from '../lib/api.js';
import { getImageUrl } from '../lib/format.js';
import creaturesFallback from '../data/creatures.json';

export async function GET() {
  const directusUrl = import.meta.env.PUBLIC_DIRECTUS_URL || DEFAULT_DIRECTUS;

  const [creatures, flowers, recipes, artworks, fossils] = await Promise.all([
    getCreatures(directusUrl, creaturesFallback),
    getFlowers(directusUrl),
    getRecipes(directusUrl),
    getArtworks(directusUrl),
    getFossils(directusUrl),
  ]);

  const entries = [
    ...creatures.map((c) => ({
      title: c.name,
      subtitle: `${c.price || 0} Sternis`,
      type: c.category === 'insect' ? 'Insekt' : c.category === 'fish' ? 'Fisch' : 'Meerestier',
      url: `/tier/${c.id}/`,
      image: getImageUrl(c.image_path),
    })),
    ...flowers.map((f) => ({
      title: f.name,
      subtitle: 'Zuchtblume',
      type: 'Flora',
      url: `/blumen/${f.id}/`,
      image: getImageUrl(f.image_path),
    })),
    ...recipes.map((r) => ({
      title: r.name,
      subtitle: r.source || (r.type === 'diy' ? 'Bastelanleitung' : 'Kochrezept'),
      type: 'Rezept',
      url: `/items/${r.id}/`,
      image: getImageUrl(r.image_path),
    })),
    ...artworks.map((a) => ({
      title: a.name,
      subtitle: `Kunstwerk von ${a.artist}`,
      type: 'Kunst',
      url: `/museum/kunst/${a.id}`,
      image: getImageUrl(a.image_real, { folder: 'museum' }),
    })),
    ...fossils.map((f) => ({
      title: f.name,
      subtitle: 'Dino-Fossil',
      type: 'Fossil',
      url: '/museum/fossilien',
      image: getImageUrl(f.image_path, { folder: 'museum' }),
    })),
  ].filter((e) => e.title);

  return new Response(JSON.stringify(entries), {
    headers: { 'Content-Type': 'application/json' },
  });
}
