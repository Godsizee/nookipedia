-- ======================================================
-- ACNH DATABASE SCHEMA (DUMP-VERSION)
-- Formatiert gemäß Referenz: grafik.png
-- ======================================================

DROP TABLE IF EXISTS public.item_variants CASCADE;
DROP TABLE IF EXISTS public.item_materials CASCADE;
DROP TABLE IF EXISTS public.cooking_recipes CASCADE;
DROP TABLE IF EXISTS public.diy_recipes CASCADE;
DROP TABLE IF EXISTS public.creature_weathers CASCADE;
DROP TABLE IF EXISTS public.creature_speeds CASCADE;
DROP TABLE IF EXISTS public.creature_shadows CASCADE;
DROP TABLE IF EXISTS public.creature_locations CASCADE;
DROP TABLE IF EXISTS public.flower_combinations CASCADE;
DROP TABLE IF EXISTS public.flower_seeds CASCADE;
DROP TABLE IF EXISTS public.villagers CASCADE;
DROP TABLE IF EXISTS public.special_npcs CASCADE;
DROP TABLE IF EXISTS public.fossils CASCADE;
DROP TABLE IF EXISTS public.artworks CASCADE;
DROP TABLE IF EXISTS public.materials CASCADE;
DROP TABLE IF EXISTS public.flowers CASCADE;
DROP TABLE IF EXISTS public.items CASCADE;
DROP TABLE IF EXISTS public.creatures CASCADE;
DROP TABLE IF EXISTS public.events CASCADE;


CREATE TABLE public.events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    month INTEGER,
    date_description VARCHAR(100),
    description TEXT,
    image_path VARCHAR(255) DEFAULT 'placeholder.png',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.creatures (
    id SERIAL PRIMARY KEY,
    category VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    price INTEGER DEFAULT 0,
    catchphrase TEXT,
    image_path VARCHAR(255),
    months_northern INTEGER[] DEFAULT '{}',
    time_active VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT creatures_category_check CHECK (category IN ('insect', 'fish', 'sea'))
);

CREATE TABLE public.items (
    id SERIAL PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) DEFAULT NULL,
    category VARCHAR(50) NOT NULL,
    size VARCHAR(20) DEFAULT '1.0x1.0',
    buy_price INTEGER,
    sell_price INTEGER DEFAULT 0 NOT NULL,
    source VARCHAR(100) DEFAULT NULL,
    is_customizable BOOLEAN DEFAULT false,
    customization_kit_cost INTEGER DEFAULT 0,
    is_cyrus_customizable BOOLEAN DEFAULT false,
    cyrus_customization_cost INTEGER DEFAULT 0
);


CREATE TABLE public.flowers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_path VARCHAR(255),
    colors TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.flower_seeds (
    id SERIAL PRIMARY KEY,
    flower_id INTEGER NOT NULL REFERENCES public.flowers(id) ON DELETE CASCADE,
    color VARCHAR(50),
    source VARCHAR(100),
    image_path VARCHAR(255)
);

CREATE TABLE public.flower_combinations (
    id SERIAL PRIMARY KEY,
    flower_id INTEGER NOT NULL REFERENCES public.flowers(id) ON DELETE CASCADE,
    parent1_color VARCHAR(50),
    parent1_image VARCHAR(255),
    parent2_color VARCHAR(50),
    parent2_image VARCHAR(255),
    child_color VARCHAR(50),
    child_image VARCHAR(255),
    probability VARCHAR(50),
    notes TEXT,
    child_sell_price VARCHAR(50)
);


CREATE TABLE public.special_npcs (
    id SERIAL PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    name_en VARCHAR(50) DEFAULT NULL,
    role VARCHAR(100) NOT NULL,
    species VARCHAR(50) DEFAULT NULL,
    gender VARCHAR(20) DEFAULT NULL,
    birthday VARCHAR(50) DEFAULT NULL,
    image_path VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE public.villagers (
    id SERIAL PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    name_en VARCHAR(50) DEFAULT NULL,
    species VARCHAR(50) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    personality VARCHAR(50) NOT NULL,
    hobby VARCHAR(50) DEFAULT NULL,
    catchphrase VARCHAR(50) DEFAULT NULL,
    birthday VARCHAR(50) DEFAULT NULL,
    preferred_styles VARCHAR(100) DEFAULT NULL,
    image_path VARCHAR(255) NOT NULL,
    house_image_path VARCHAR(255) DEFAULT NULL,
    description TEXT
);


CREATE TABLE public.materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    source VARCHAR(255),
    sell_price VARCHAR(100),
    image_path VARCHAR(255) DEFAULT 'material_placeholder.png'
);

CREATE TABLE public.diy_recipes (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES public.events(id) ON DELETE SET NULL,
    category VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    materials_desc TEXT,
    durability VARCHAR(50),
    is_customizable BOOLEAN DEFAULT false,
    source VARCHAR(255),
    sell_price VARCHAR(100),
    image_path VARCHAR(255) DEFAULT 'diy/96px-DIY_Recipe_NH_Icon.png',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT diy_recipes_category_check CHECK (category IN ('Saisonale Bastelprojekte', 'Werkzeuge', 'Einrichtung', 'Kleinkram', 'Wanddeko', 'Deckendeko', 'Tapeten/Böden/Teppiche', 'Ausrüstung', 'Sonstiges'))
);

CREATE TABLE public.cooking_recipes (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES public.events(id) ON DELETE SET NULL,
    category VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    materials_desc TEXT,
    source VARCHAR(255),
    sell_price VARCHAR(100),
    image_path VARCHAR(255) DEFAULT 'diy/96px-Cooking_Recipe_NH_Icon.png',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cooking_recipes_category_check CHECK (category IN ('Herzhaft', 'Süß'))
);

CREATE TABLE public.item_materials (
    id SERIAL PRIMARY KEY,
    diy_recipe_id INTEGER REFERENCES public.diy_recipes(id) ON DELETE CASCADE,
    cooking_recipe_id INTEGER REFERENCES public.cooking_recipes(id) ON DELETE CASCADE,
    material_id INTEGER REFERENCES public.materials(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    CONSTRAINT item_materials_check CHECK ((diy_recipe_id IS NOT NULL AND cooking_recipe_id IS NULL) OR (diy_recipe_id IS NULL AND cooking_recipe_id IS NOT NULL))
);


CREATE TABLE public.artworks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    real_world_name VARCHAR(255) NOT NULL,
    artist VARCHAR(255) NOT NULL,
    image_real VARCHAR(255) NOT NULL,
    image_fake VARCHAR(255) DEFAULT NULL,
    fake_description TEXT
);

CREATE TABLE public.fossils (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dinosaur_group VARCHAR(100) DEFAULT NULL,
    price INTEGER DEFAULT 0 NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL
);

CREATE TABLE public.item_variants (
    id SERIAL PRIMARY KEY,
    item_id INTEGER NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    variant_name_de VARCHAR(50) DEFAULT NULL,
    pattern_name_de VARCHAR(50) DEFAULT NULL,
    image_path VARCHAR(255) NOT NULL,
    CONSTRAINT item_variants_unique_key UNIQUE (item_id, variant_name_de, pattern_name_de)
);


CREATE TABLE public.creature_locations (
    creature_id INTEGER PRIMARY KEY REFERENCES public.creatures(id) ON DELETE CASCADE,
    location_name VARCHAR(100) NOT NULL
);

CREATE TABLE public.creature_shadows (
    creature_id INTEGER PRIMARY KEY REFERENCES public.creatures(id) ON DELETE CASCADE,
    shadow_image VARCHAR(255) NOT NULL
);

CREATE TABLE public.creature_speeds (
    creature_id INTEGER PRIMARY KEY REFERENCES public.creatures(id) ON DELETE CASCADE,
    speed VARCHAR(50) NOT NULL
);

CREATE TABLE public.creature_weathers (
    creature_id INTEGER PRIMARY KEY REFERENCES public.creatures(id) ON DELETE CASCADE,
    weather VARCHAR(50) NOT NULL
);


CREATE INDEX idx_artworks_type ON public.artworks (type);
CREATE INDEX idx_cooking_name ON public.cooking_recipes (name);
CREATE INDEX idx_creatures_category ON public.creatures (category);
CREATE INDEX idx_creatures_months_northern ON public.creatures USING GIN (months_northern);
CREATE INDEX idx_creatures_name ON public.creatures (name);
CREATE INDEX idx_creatures_price ON public.creatures (price DESC);
CREATE INDEX idx_diy_name ON public.diy_recipes (name);
CREATE INDEX idx_events_month ON public.events (month);
CREATE INDEX idx_events_type ON public.events (event_type);
CREATE INDEX idx_flowers_name ON public.flowers (name);
CREATE INDEX idx_fossils_group ON public.fossils (dinosaur_group);
CREATE INDEX idx_item_variants_item_id ON public.item_variants (item_id);
CREATE INDEX idx_items_category ON public.items (category);
CREATE INDEX idx_items_name ON public.items (name_de);
CREATE INDEX idx_materials_category ON public.materials (category);
CREATE INDEX idx_materials_name ON public.materials (name);
CREATE INDEX idx_special_npcs_name ON public.special_npcs (name_de);
CREATE INDEX idx_villagers_name ON public.villagers (name_de);
CREATE INDEX idx_villagers_personality ON public.villagers (personality);
CREATE INDEX idx_villagers_species ON public.villagers (species);