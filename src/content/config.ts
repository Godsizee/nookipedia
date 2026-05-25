import { defineCollection, z } from 'astro:content';

const guidesCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    flowerId: z.number(),
    flowerName: z.string(),
    icon: z.string().optional(),
  }),
});

export const collections = {
  'guides': guidesCollection,
};
