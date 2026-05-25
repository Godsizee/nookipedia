--
-- PostgreSQL database cluster dump
--

-- Started on 2026-05-25 20:07:27

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE n8n_user;
ALTER ROLE n8n_user WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 17.0

-- Started on 2026-05-25 20:07:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-05-25 20:07:30

--
-- PostgreSQL database dump complete
--

--
-- Database "nookipedia_db" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 17.0

-- Started on 2026-05-25 20:07:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3958 (class 1262 OID 16580)
-- Name: nookipedia_db; Type: DATABASE; Schema: -; Owner: n8n_user
--

CREATE DATABASE nookipedia_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE nookipedia_db OWNER TO n8n_user;

\connect nookipedia_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 240 (class 1259 OID 17126)
-- Name: artworks; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.artworks (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    real_world_name character varying(255) NOT NULL,
    artist character varying(255) NOT NULL,
    image_real character varying(255) NOT NULL,
    image_fake character varying(255) DEFAULT NULL::character varying,
    fake_description text
);


ALTER TABLE public.artworks OWNER TO n8n_user;

--
-- TOC entry 239 (class 1259 OID 17125)
-- Name: artworks_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.artworks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artworks_id_seq OWNER TO n8n_user;

--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 239
-- Name: artworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.artworks_id_seq OWNED BY public.artworks.id;


--
-- TOC entry 230 (class 1259 OID 16980)
-- Name: cooking_recipes; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.cooking_recipes (
    id integer NOT NULL,
    event_id integer,
    category character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    materials_desc text,
    source character varying(255),
    sell_price character varying(100),
    image_path character varying(255) DEFAULT 'diy/96px-Cooking_Recipe_NH_Icon.png'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cooking_recipes_category_check CHECK (((category)::text = ANY ((ARRAY['Herzhaft'::character varying, 'Süß'::character varying])::text[])))
);


ALTER TABLE public.cooking_recipes OWNER TO n8n_user;

--
-- TOC entry 229 (class 1259 OID 16979)
-- Name: cooking_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.cooking_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cooking_recipes_id_seq OWNER TO n8n_user;

--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 229
-- Name: cooking_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.cooking_recipes_id_seq OWNED BY public.cooking_recipes.id;


--
-- TOC entry 236 (class 1259 OID 17084)
-- Name: creature_locations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.creature_locations (
    creature_id integer NOT NULL,
    location_name character varying(100) NOT NULL
);


ALTER TABLE public.creature_locations OWNER TO n8n_user;

--
-- TOC entry 233 (class 1259 OID 17054)
-- Name: creature_shadows; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.creature_shadows (
    creature_id integer NOT NULL,
    shadow_image character varying(255) NOT NULL
);


ALTER TABLE public.creature_shadows OWNER TO n8n_user;

--
-- TOC entry 234 (class 1259 OID 17064)
-- Name: creature_speeds; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.creature_speeds (
    creature_id integer NOT NULL,
    speed character varying(50) NOT NULL
);


ALTER TABLE public.creature_speeds OWNER TO n8n_user;

--
-- TOC entry 235 (class 1259 OID 17074)
-- Name: creature_weathers; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.creature_weathers (
    creature_id integer NOT NULL,
    weather character varying(50) NOT NULL
);


ALTER TABLE public.creature_weathers OWNER TO n8n_user;

--
-- TOC entry 216 (class 1259 OID 16604)
-- Name: creatures; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.creatures (
    id integer NOT NULL,
    category character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    price integer DEFAULT 0,
    catchphrase text,
    image_path character varying(255),
    months_northern integer[] DEFAULT '{}'::integer[],
    time_active character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT creatures_category_check CHECK (((category)::text = ANY ((ARRAY['insect'::character varying, 'fish'::character varying, 'sea'::character varying])::text[])))
);


ALTER TABLE public.creatures OWNER TO n8n_user;

--
-- TOC entry 215 (class 1259 OID 16603)
-- Name: creatures_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.creatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.creatures_id_seq OWNER TO n8n_user;

--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 215
-- Name: creatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.creatures_id_seq OWNED BY public.creatures.id;


--
-- TOC entry 255 (class 1259 OID 33024)
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO n8n_user;

--
-- TOC entry 254 (class 1259 OID 33023)
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO n8n_user;

--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 254
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- TOC entry 249 (class 1259 OID 32962)
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(30),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO n8n_user;

--
-- TOC entry 272 (class 1259 OID 33339)
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO n8n_user;

--
-- TOC entry 281 (class 1259 OID 33548)
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_extensions (
    folder character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    source character varying(255) DEFAULT 'local'::character varying NOT NULL,
    bundle uuid
);


ALTER TABLE public.directus_extensions OWNER TO n8n_user;

--
-- TOC entry 253 (class 1259 OID 33001)
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO n8n_user;

--
-- TOC entry 252 (class 1259 OID 33000)
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO n8n_user;

--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 252
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- TOC entry 257 (class 1259 OID 33048)
-- Name: directus_files; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    uploaded_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer
);


ALTER TABLE public.directus_files OWNER TO n8n_user;

--
-- TOC entry 277 (class 1259 OID 33453)
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO n8n_user;

--
-- TOC entry 256 (class 1259 OID 33038)
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO n8n_user;

--
-- TOC entry 271 (class 1259 OID 33212)
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO n8n_user;

--
-- TOC entry 275 (class 1259 OID 33399)
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO n8n_user;

--
-- TOC entry 274 (class 1259 OID 33398)
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO n8n_user;

--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 274
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- TOC entry 278 (class 1259 OID 33470)
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO n8n_user;

--
-- TOC entry 273 (class 1259 OID 33353)
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(30) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO n8n_user;

--
-- TOC entry 259 (class 1259 OID 33074)
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    role uuid,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text
);


ALTER TABLE public.directus_permissions OWNER TO n8n_user;

--
-- TOC entry 258 (class 1259 OID 33073)
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO n8n_user;

--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 258
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- TOC entry 261 (class 1259 OID 33093)
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(30) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO n8n_user;

--
-- TOC entry 260 (class 1259 OID 33092)
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO n8n_user;

--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 260
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- TOC entry 263 (class 1259 OID 33118)
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO n8n_user;

--
-- TOC entry 262 (class 1259 OID 33117)
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO n8n_user;

--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 262
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- TOC entry 265 (class 1259 OID 33137)
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO n8n_user;

--
-- TOC entry 264 (class 1259 OID 33136)
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO n8n_user;

--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 264
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- TOC entry 250 (class 1259 OID 32972)
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(30) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_roles OWNER TO n8n_user;

--
-- TOC entry 266 (class 1259 OID 33160)
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent character varying(255),
    share uuid,
    origin character varying(255)
);


ALTER TABLE public.directus_sessions OWNER TO n8n_user;

--
-- TOC entry 268 (class 1259 OID 33173)
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json
);


ALTER TABLE public.directus_settings OWNER TO n8n_user;

--
-- TOC entry 267 (class 1259 OID 33172)
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO n8n_user;

--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 267
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- TOC entry 276 (class 1259 OID 33419)
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO n8n_user;

--
-- TOC entry 279 (class 1259 OID 33504)
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO n8n_user;

--
-- TOC entry 251 (class 1259 OID 32983)
-- Name: directus_users; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json
);


ALTER TABLE public.directus_users OWNER TO n8n_user;

--
-- TOC entry 280 (class 1259 OID 33511)
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_versions OWNER TO n8n_user;

--
-- TOC entry 270 (class 1259 OID 33201)
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json
);


ALTER TABLE public.directus_webhooks OWNER TO n8n_user;

--
-- TOC entry 269 (class 1259 OID 33200)
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_webhooks_id_seq OWNER TO n8n_user;

--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 269
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- TOC entry 228 (class 1259 OID 16962)
-- Name: diy_recipes; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.diy_recipes (
    id integer NOT NULL,
    event_id integer,
    category character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    materials_desc text,
    durability character varying(50),
    is_customizable boolean DEFAULT false,
    source character varying(255),
    sell_price character varying(100),
    image_path character varying(255) DEFAULT 'diy/96px-DIY_Recipe_NH_Icon.png'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT diy_recipes_category_check CHECK (((category)::text = ANY ((ARRAY['Saisonale Bastelprojekte'::character varying, 'Werkzeuge'::character varying, 'Einrichtung'::character varying, 'Kleinkram'::character varying, 'Wanddeko'::character varying, 'Deckendeko'::character varying, 'Tapeten/Böden/Teppiche'::character varying, 'Ausrüstung'::character varying, 'Sonstiges'::character varying])::text[])))
);


ALTER TABLE public.diy_recipes OWNER TO n8n_user;

--
-- TOC entry 227 (class 1259 OID 16961)
-- Name: diy_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.diy_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diy_recipes_id_seq OWNER TO n8n_user;

--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 227
-- Name: diy_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.diy_recipes_id_seq OWNED BY public.diy_recipes.id;


--
-- TOC entry 224 (class 1259 OID 16783)
-- Name: events; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    event_type character varying(50) NOT NULL,
    month integer,
    date_description character varying(100),
    description text,
    image_path character varying(255) DEFAULT 'placeholder.png'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.events OWNER TO n8n_user;

--
-- TOC entry 223 (class 1259 OID 16782)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO n8n_user;

--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 223
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 220 (class 1259 OID 16689)
-- Name: flower_combinations; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.flower_combinations (
    id integer NOT NULL,
    flower_id integer NOT NULL,
    parent1_color character varying(50),
    parent1_image character varying(255),
    parent2_color character varying(50),
    parent2_image character varying(255),
    child_color character varying(50),
    child_image character varying(255),
    probability character varying(50),
    notes text,
    child_sell_price character varying(50)
);


ALTER TABLE public.flower_combinations OWNER TO n8n_user;

--
-- TOC entry 219 (class 1259 OID 16688)
-- Name: flower_combinations_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.flower_combinations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flower_combinations_id_seq OWNER TO n8n_user;

--
-- TOC entry 3973 (class 0 OID 0)
-- Dependencies: 219
-- Name: flower_combinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.flower_combinations_id_seq OWNED BY public.flower_combinations.id;


--
-- TOC entry 222 (class 1259 OID 16703)
-- Name: flower_seeds; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.flower_seeds (
    id integer NOT NULL,
    flower_id integer NOT NULL,
    color character varying(50),
    source character varying(100),
    image_path character varying(255)
);


ALTER TABLE public.flower_seeds OWNER TO n8n_user;

--
-- TOC entry 221 (class 1259 OID 16702)
-- Name: flower_seeds_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.flower_seeds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flower_seeds_id_seq OWNER TO n8n_user;

--
-- TOC entry 3974 (class 0 OID 0)
-- Dependencies: 221
-- Name: flower_seeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.flower_seeds_id_seq OWNED BY public.flower_seeds.id;


--
-- TOC entry 218 (class 1259 OID 16663)
-- Name: flowers; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.flowers (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    image_path character varying(255),
    colors text[] DEFAULT '{}'::text[],
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.flowers OWNER TO n8n_user;

--
-- TOC entry 217 (class 1259 OID 16662)
-- Name: flowers_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.flowers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flowers_id_seq OWNER TO n8n_user;

--
-- TOC entry 3975 (class 0 OID 0)
-- Dependencies: 217
-- Name: flowers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.flowers_id_seq OWNED BY public.flowers.id;


--
-- TOC entry 238 (class 1259 OID 17114)
-- Name: fossils; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.fossils (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    dinosaur_group character varying(100) DEFAULT NULL::character varying,
    price integer DEFAULT 0 NOT NULL,
    image_path character varying(255) NOT NULL,
    type character varying(50) NOT NULL
);


ALTER TABLE public.fossils OWNER TO n8n_user;

--
-- TOC entry 237 (class 1259 OID 17113)
-- Name: fossils_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.fossils_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fossils_id_seq OWNER TO n8n_user;

--
-- TOC entry 3976 (class 0 OID 0)
-- Dependencies: 237
-- Name: fossils_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.fossils_id_seq OWNED BY public.fossils.id;


--
-- TOC entry 232 (class 1259 OID 16997)
-- Name: item_materials; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.item_materials (
    id integer NOT NULL,
    diy_recipe_id integer,
    cooking_recipe_id integer,
    material_id integer,
    amount integer NOT NULL,
    CONSTRAINT item_materials_check CHECK ((((diy_recipe_id IS NOT NULL) AND (cooking_recipe_id IS NULL)) OR ((diy_recipe_id IS NULL) AND (cooking_recipe_id IS NOT NULL))))
);


ALTER TABLE public.item_materials OWNER TO n8n_user;

--
-- TOC entry 231 (class 1259 OID 16996)
-- Name: item_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.item_materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.item_materials_id_seq OWNER TO n8n_user;

--
-- TOC entry 3977 (class 0 OID 0)
-- Dependencies: 231
-- Name: item_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.item_materials_id_seq OWNED BY public.item_materials.id;


--
-- TOC entry 248 (class 1259 OID 32946)
-- Name: item_variants; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.item_variants (
    id integer NOT NULL,
    item_id integer NOT NULL,
    variant_name_de character varying(50) DEFAULT NULL::character varying,
    pattern_name_de character varying(50) DEFAULT NULL::character varying,
    image_path character varying(255) NOT NULL
);


ALTER TABLE public.item_variants OWNER TO n8n_user;

--
-- TOC entry 247 (class 1259 OID 32945)
-- Name: item_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.item_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.item_variants_id_seq OWNER TO n8n_user;

--
-- TOC entry 3978 (class 0 OID 0)
-- Dependencies: 247
-- Name: item_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.item_variants_id_seq OWNED BY public.item_variants.id;


--
-- TOC entry 246 (class 1259 OID 32929)
-- Name: items; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name_de character varying(100) NOT NULL,
    name_en character varying(100) DEFAULT NULL::character varying,
    category character varying(50) NOT NULL,
    size character varying(20) DEFAULT '1.0x1.0'::character varying,
    buy_price integer,
    sell_price integer DEFAULT 0 NOT NULL,
    source character varying(100) DEFAULT NULL::character varying,
    is_customizable boolean DEFAULT false,
    customization_kit_cost integer DEFAULT 0,
    is_cyrus_customizable boolean DEFAULT false,
    cyrus_customization_cost integer DEFAULT 0
);


ALTER TABLE public.items OWNER TO n8n_user;

--
-- TOC entry 245 (class 1259 OID 32928)
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.items_id_seq OWNER TO n8n_user;

--
-- TOC entry 3979 (class 0 OID 0)
-- Dependencies: 245
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- TOC entry 226 (class 1259 OID 16815)
-- Name: materials; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.materials (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    source character varying(255),
    sell_price character varying(100),
    image_path character varying(255) DEFAULT 'material_placeholder.png'::character varying
);


ALTER TABLE public.materials OWNER TO n8n_user;

--
-- TOC entry 225 (class 1259 OID 16814)
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_id_seq OWNER TO n8n_user;

--
-- TOC entry 3980 (class 0 OID 0)
-- Dependencies: 225
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- TOC entry 242 (class 1259 OID 24737)
-- Name: special_npcs; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.special_npcs (
    id integer NOT NULL,
    name_de character varying(50) NOT NULL,
    name_en character varying(50) DEFAULT NULL::character varying,
    role character varying(100) NOT NULL,
    species character varying(50) DEFAULT NULL::character varying,
    gender character varying(20) DEFAULT NULL::character varying,
    birthday character varying(50) DEFAULT NULL::character varying,
    image_path character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.special_npcs OWNER TO n8n_user;

--
-- TOC entry 241 (class 1259 OID 24736)
-- Name: special_npcs_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.special_npcs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.special_npcs_id_seq OWNER TO n8n_user;

--
-- TOC entry 3981 (class 0 OID 0)
-- Dependencies: 241
-- Name: special_npcs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.special_npcs_id_seq OWNED BY public.special_npcs.id;


--
-- TOC entry 244 (class 1259 OID 24751)
-- Name: villagers; Type: TABLE; Schema: public; Owner: n8n_user
--

CREATE TABLE public.villagers (
    id integer NOT NULL,
    name_de character varying(50) NOT NULL,
    name_en character varying(50) DEFAULT NULL::character varying,
    species character varying(50) NOT NULL,
    gender character varying(20) NOT NULL,
    personality character varying(50) NOT NULL,
    hobby character varying(50) DEFAULT NULL::character varying,
    catchphrase character varying(50) DEFAULT NULL::character varying,
    birthday character varying(50) DEFAULT NULL::character varying,
    preferred_styles character varying(100) DEFAULT NULL::character varying,
    image_path character varying(255) NOT NULL,
    house_image_path character varying(255) DEFAULT NULL::character varying,
    description text
);


ALTER TABLE public.villagers OWNER TO n8n_user;

--
-- TOC entry 243 (class 1259 OID 24750)
-- Name: villagers_id_seq; Type: SEQUENCE; Schema: public; Owner: n8n_user
--

CREATE SEQUENCE public.villagers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.villagers_id_seq OWNER TO n8n_user;

--
-- TOC entry 3982 (class 0 OID 0)
-- Dependencies: 243
-- Name: villagers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: n8n_user
--

ALTER SEQUENCE public.villagers_id_seq OWNED BY public.villagers.id;


--
-- TOC entry 3483 (class 2604 OID 17129)
-- Name: artworks id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.artworks ALTER COLUMN id SET DEFAULT nextval('public.artworks_id_seq'::regclass);


--
-- TOC entry 3476 (class 2604 OID 16983)
-- Name: cooking_recipes id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.cooking_recipes ALTER COLUMN id SET DEFAULT nextval('public.cooking_recipes_id_seq'::regclass);


--
-- TOC entry 3458 (class 2604 OID 16607)
-- Name: creatures id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creatures ALTER COLUMN id SET DEFAULT nextval('public.creatures_id_seq'::regclass);


--
-- TOC entry 3528 (class 2604 OID 33027)
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- TOC entry 3523 (class 2604 OID 33004)
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- TOC entry 3556 (class 2604 OID 33402)
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- TOC entry 3532 (class 2604 OID 33077)
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- TOC entry 3533 (class 2604 OID 33096)
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- TOC entry 3536 (class 2604 OID 33121)
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- TOC entry 3538 (class 2604 OID 33140)
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- TOC entry 3539 (class 2604 OID 33176)
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- TOC entry 3546 (class 2604 OID 33204)
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- TOC entry 3472 (class 2604 OID 16965)
-- Name: diy_recipes id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.diy_recipes ALTER COLUMN id SET DEFAULT nextval('public.diy_recipes_id_seq'::regclass);


--
-- TOC entry 3467 (class 2604 OID 16786)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 3465 (class 2604 OID 16692)
-- Name: flower_combinations id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flower_combinations ALTER COLUMN id SET DEFAULT nextval('public.flower_combinations_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 16706)
-- Name: flower_seeds id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flower_seeds ALTER COLUMN id SET DEFAULT nextval('public.flower_seeds_id_seq'::regclass);


--
-- TOC entry 3462 (class 2604 OID 16666)
-- Name: flowers id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flowers ALTER COLUMN id SET DEFAULT nextval('public.flowers_id_seq'::regclass);


--
-- TOC entry 3480 (class 2604 OID 17117)
-- Name: fossils id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.fossils ALTER COLUMN id SET DEFAULT nextval('public.fossils_id_seq'::regclass);


--
-- TOC entry 3479 (class 2604 OID 17000)
-- Name: item_materials id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_materials ALTER COLUMN id SET DEFAULT nextval('public.item_materials_id_seq'::regclass);


--
-- TOC entry 3506 (class 2604 OID 32949)
-- Name: item_variants id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_variants ALTER COLUMN id SET DEFAULT nextval('public.item_variants_id_seq'::regclass);


--
-- TOC entry 3497 (class 2604 OID 32932)
-- Name: items id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- TOC entry 3470 (class 2604 OID 16818)
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- TOC entry 3485 (class 2604 OID 24740)
-- Name: special_npcs id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.special_npcs ALTER COLUMN id SET DEFAULT nextval('public.special_npcs_id_seq'::regclass);


--
-- TOC entry 3490 (class 2604 OID 24754)
-- Name: villagers id; Type: DEFAULT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.villagers ALTER COLUMN id SET DEFAULT nextval('public.villagers_id_seq'::regclass);


--
-- TOC entry 3911 (class 0 OID 17126)
-- Dependencies: 240
-- Data for Name: artworks; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.artworks (id, name, type, real_world_name, artist, image_real, image_fake, fake_description) FROM stdin;
\.


--
-- TOC entry 3901 (class 0 OID 16980)
-- Dependencies: 230
-- Data for Name: cooking_recipes; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.cooking_recipes (id, event_id, category, name, materials_desc, source, sell_price, image_path, created_at) FROM stdin;
1	\N	Herzhaft	Mehl	5 Weizen	„Genießen mit Anleitungen+“ vom NookPortal	210 Sternis	diy/cooking/Flour.png	2026-03-25 09:37:21.835325+00
2	\N	Herzhaft	Vollkornmehl	5 Weizen	„Basis-Rezepte“ aus Nooks Laden	210 Sternis	diy/cooking/Whole-wheat flour.png	2026-03-25 09:37:21.835325+00
3	\N	Herzhaft	Zucker	5 Zuckerrohr	„Genießen mit Anleitungen+“ vom NookPortal	210 Sternis	diy/cooking/Sugar.png	2026-03-25 09:37:21.835325+00
4	\N	Herzhaft	Rohzucker	5 Zuckerrohr	„Basis-Rezepte“ aus Nooks Laden	210 Sternis	diy/cooking/Brown sugar.png	2026-03-25 09:37:21.835325+00
5	\N	Herzhaft	Karottensuppe	1 Mehl, 2 Karotte	„Genießen mit Anleitungen+“ vom NookPortal	1.370 Sternis	diy/cooking/Carrot potage.png	2026-03-25 09:37:21.835325+00
6	\N	Herzhaft	Kartoffelsuppe	1 Mehl, 2 Kartoffel	Nachbarn	1.370 Sternis	diy/cooking/Potato potage.png	2026-03-25 09:37:21.835325+00
7	\N	Herzhaft	Minestrone	2 Tomate, 1 Kartoffel, 1 Karotte	Nachbarn	2.100 Sternis	diy/cooking/Minestrone soup.png	2026-03-25 09:37:21.835325+00
8	\N	Herzhaft	Bambussprossensuppe	2 Bambussprosse	Jorna	1.000 Sternis	diy/cooking/Bamboo-shoot soup.png	2026-03-25 09:37:21.835325+00
9	\N	Herzhaft	Pilzsuppe	1 Mehl, 1 Rundpilz, 1 Flachpilz	Nachbarn	1.220 Sternis	diy/cooking/Mushroom potage.png	2026-03-25 09:37:21.835325+00
10	\N	Herzhaft	Algensuppe	2 Wakame-Alge	„Basis-Rezepte“ aus Nooks Laden	1.440 Sternis	diy/cooking/Seaweed soup.png	2026-03-25 09:37:21.835325+00
11	\N	Herzhaft	Salat	1 Tomate, 1 Karotte, 1 Kartoffel, 1 Orangekürbis	Nachbarn	2.100 Sternis	diy/cooking/Salad.png	2026-03-25 09:37:21.835325+00
12	\N	Herzhaft	Karottensalat	3 Karotte	Nachbarn	1.260 Sternis	diy/cooking/Salade_de_Carottes_Râpées_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
13	\N	Herzhaft	Pilzsalat	1 Rundpilz, 1 Flachpilz, 1 Dürrpilz	Nachbarn	1.400 Sternis	diy/cooking/Mushroom salad.png	2026-03-25 09:37:21.835325+00
14	\N	Herzhaft	Rübensalat	10 Rübe, 1 Tomate	Jorna	680 Sternis	diy/cooking/Turnip salad.png	2026-03-25 09:37:21.835325+00
15	\N	Herzhaft	Obstsalat	1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	1.550 Sternis	diy/cooking/Fruit salad.png	2026-03-25 09:37:21.835325+00
16	\N	Herzhaft	Poke-Salat	1 Lachs, 1 Tomate	4 Lachse angeln	1.260 Sternis	diy/cooking/Poke.png	2026-03-25 09:37:21.835325+00
17	\N	Herzhaft	Meeresfrüchte-Salat	1 Kalmar, 1 Botan-Garnele	Nachbarn	2.280 Sternis	diy/cooking/Seafood salad.png	2026-03-25 09:37:21.835325+00
18	\N	Herzhaft	Pommes frites	3 Kartoffel	Nachbarn	1.260 Sternis	diy/cooking/French fries.png	2026-03-25 09:37:21.835325+00
19	\N	Herzhaft	Fish and Chips	2 Kartoffel, 1 Kliesche	Nachbarn	1.200 Sternis	diy/cooking/Fish-and-chips.png	2026-03-25 09:37:21.835325+00
20	\N	Herzhaft	Backkartoffeln	2 Kartoffel	Nachbarn	840 Sternis	diy/cooking/Baked potatoes.png	2026-03-25 09:37:21.835325+00
21	\N	Herzhaft	Kartoffelpfannkuchen	2 Mehl, 3 Kartoffel	Nachbarn	2.210 Sternis	diy/cooking/Potato galette.png	2026-03-25 09:37:21.835325+00
22	\N	Herzhaft	Gemüse-Quiche	1 Mehl, 1 Kartoffel, 1 Orangekürbis	Nachbarn	1.350 Sternis	diy/cooking/Veggie quiche.png	2026-03-25 09:37:21.835325+00
23	\N	Herzhaft	Gemüse-Sandwich	2 Mehl, 1 Tomate, 1 Karotte	Nachbarn	1.680 Sternis	diy/cooking/Veggie sandwich.png	2026-03-25 09:37:21.835325+00
24	\N	Herzhaft	Obst-Sandwich	2 Mehl, 1 Orange, 1 Birne, 1 Pfirsich	Nachbarn	2.180 Sternis	diy/cooking/Mixed-fruits sandwich.png	2026-03-25 09:37:21.835325+00
25	\N	Herzhaft	Lachs-Sandwich	2 Vollkornmehl, 1 Lachs	4 Lachse angeln	1.260 Sternis	diy/cooking/Salmon sandwich.png	2026-03-25 09:37:21.835325+00
26	\N	Herzhaft	Tomaten-Bagel-Sandwich	2 Mehl, 3 Tomate	Nachbarn	2.210 Sternis	diy/cooking/Tomato bagel sandwich.png	2026-03-25 09:37:21.835325+00
27	\N	Herzhaft	Karotten-Bagel-Sandwich	2 Vollkornmehl, 3 Karotte	Nachbarn	2.210 Sternis	diy/cooking/Carrot bagel sandwich.png	2026-03-25 09:37:21.835325+00
28	\N	Herzhaft	Kürbis-Bagel-Sandwich	2 Mehl, 3 Orangekürbis	„Genießen mit Anleitungen+“ vom NookPortal	2.210 Sternis	diy/cooking/Pumpkin bagel sandwich.png	2026-03-25 09:37:21.835325+00
29	\N	Herzhaft	Obst-Bagel-Sandwich	2 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	2.180 Sternis	diy/cooking/Mixed-fruits bagel sandwich.png	2026-03-25 09:37:21.835325+00
30	\N	Herzhaft	Lachs-Bagel-Sandwich	2 Mehl, 1 Lachs	4 Lachse angeln	1.350 Sternis	diy/cooking/Salmon bagel sandwich.png	2026-03-25 09:37:21.835325+00
31	\N	Herzhaft	Pilz-Crêpe	2 Mehl, 1 Rundpilz, 1 Dürrpilz	Nachbarn	1.840 Sternis	diy/cooking/Mushroom crepe.png	2026-03-25 09:37:21.835325+00
32	\N	Herzhaft	Gemüse-Crêpe	2 Mehl, 1 Tomate, 1 Orangekürbis	Nachbarn	1.680 Sternis	diy/cooking/Veggie crepe.png	2026-03-25 09:37:21.835325+00
33	\N	Herzhaft	Brotsuppe	2 Mehl, 2 Vollkornmehl	Nachbarn	1.260 Sternis	diy/cooking/Bread gratin.png	2026-03-25 09:37:21.835325+00
34	\N	Herzhaft	Tomate mit Salatfüllung	3 Tomate	Nachbarn	1.260 Sternis	diy/cooking/Salad-stuffed tomato.png	2026-03-25 09:37:21.835325+00
35	\N	Herzhaft	Kürbissuppe	3 Orangekürbis	Nachbarn	1.260 Sternis	diy/cooking/Pumpkin soup.png	2026-03-25 09:37:21.835325+00
36	\N	Herzhaft	Kabu ankake	10 Rübe	Jorna	450 Sternis	diy/cooking/Kabu ankake.png	2026-03-25 09:37:21.835325+00
37	\N	Herzhaft	Tomates al ajillo	3 Tomate	Nachbarn	1.260 Sternis	diy/cooking/Tomates al ajillo.png	2026-03-25 09:37:21.835325+00
38	\N	Herzhaft	Champiñones al ajillo	1 Rundpilz, 1 Flachpilz, 1 Dürrpilz, 1 Seltenpilz	Nachbarn	20.040 Sternis	diy/cooking/Champiñones_al_Ajillo_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
39	\N	Herzhaft	Anchoas al ajillo	2 Sardelle	Sardelle angeln	600 Sternis	diy/cooking/Anchoas al ajillo.png	2026-03-25 09:37:21.835325+00
40	\N	Herzhaft	Meeresfrüchte ajillo	1 Kuruma-Garnele, 1 Kalmar, 1 Kammmuschel	Nachbarn	5.640 Sternis	diy/cooking/Seafood ajillo.png	2026-03-25 09:37:21.835325+00
41	\N	Herzhaft	Partybrot	2 Mehl	Nachbarn	630 Sternis	diy/cooking/Pull-apart bread.png	2026-03-25 09:37:21.835325+00
42	\N	Herzhaft	Brot	3 Mehl	Nachbarn	950 Sternis	diy/cooking/Bread.png	2026-03-25 09:37:21.835325+00
43	\N	Herzhaft	Biobrot	3 Vollkornmehl	„Basis-Rezepte“ aus Nooks Laden	950 Sternis	diy/cooking/Organic bread.png	2026-03-25 09:37:21.835325+00
44	\N	Herzhaft	Naschbrot	3 Mehl, 1 Zucker	Nachbarn	1.260 Sternis	diy/cooking/Snack bread.png	2026-03-25 09:37:21.835325+00
45	\N	Herzhaft	Snackbrot	3 Mehl, 1 Karotte, 1 Tomate, 1 Kartoffel	Nachbarn	2.520 Sternis	diy/cooking/Savory bread.png	2026-03-25 09:37:21.835325+00
46	\N	Herzhaft	Gnocchi di carote	2 Mehl, 3 Karotte	Nachbarn	2.210 Sternis	diy/cooking/Gnocchi di carote.png	2026-03-25 09:37:21.835325+00
47	\N	Herzhaft	Gnocchi di patate	2 Mehl, 3 Kartoffel	„Basis-Rezepte“ aus Nooks Laden	2.210 Sternis	diy/cooking/Gnocchi di patate.png	2026-03-25 09:37:21.835325+00
48	\N	Herzhaft	Gnocchi di zucca	2 Mehl, 3 Orangekürbis	Nachbarn	2.210 Sternis	diy/cooking/Gnocchi di zucca.png	2026-03-25 09:37:21.835325+00
49	\N	Herzhaft	Spaghetti marinara	3 Mehl, 1 Tomatenpüree	Nachbarn	2.210 Sternis	diy/cooking/Spaghetti marinara.png	2026-03-25 09:37:21.835325+00
50	\N	Herzhaft	Spaghetti napoletana	3 Mehl, 1 Tomatenpüree	Nachbarn	2.210 Sternis	diy/cooking/Spaghetti napolitan.png	2026-03-25 09:37:21.835325+00
51	\N	Herzhaft	Tintenfischtinte-Spaghetti	3 Mehl, 1 Kalmar	Kalmar angeln	1.360 Sternis	diy/cooking/Squid-ink spaghetti.png	2026-03-25 09:37:21.835325+00
52	\N	Herzhaft	Tomaten-Curry	3 Mehl, 3 Tomate	„Genießen mit Anleitungen+“ vom NookPortal	2.520 Sternis	diy/cooking/Tomato curry.png	2026-03-25 09:37:21.835325+00
53	\N	Herzhaft	Karottengrün-Curry	3 Mehl, 3 Karotte	Nachbarn	2.520 Sternis	diy/cooking/Carrot-tops curry.png	2026-03-25 09:37:21.835325+00
54	\N	Herzhaft	Kartoffel-Curry	3 Mehl, 3 Kartoffel	Nachbarn	2.520 Sternis	diy/cooking/Potato curry.png	2026-03-25 09:37:21.835325+00
55	\N	Herzhaft	Kürbis-Curry	3 Mehl, 3 Orangekürbis	Nachbarn	2.520 Sternis	diy/cooking/Pumpkin curry.png	2026-03-25 09:37:21.835325+00
56	\N	Herzhaft	Pilz-Curry	3 Mehl, 1 Rundpilz, 1 Flachpilz, 1 Dürrpilz	Nachbarn	2.660 Sternis	diy/cooking/Mushroom curry.png	2026-03-25 09:37:21.835325+00
57	\N	Herzhaft	Sepia-Curry	3 Mehl, 1 Kalmar	Kalmar angeln	1.360 Sternis	diy/cooking/Squid-ink curry.png	2026-03-25 09:37:21.835325+00
58	\N	Herzhaft	Pizza Margherita	3 Mehl, 2 Tomate	Nachbarn	2.000 Sternis	diy/cooking/Pizza margherita.png	2026-03-25 09:37:21.835325+00
59	\N	Herzhaft	Pizza mit Pilzen	3 Mehl, 2 Rundpilz, 2 Flachpilz	Nachbarn	2.860 Sternis	diy/cooking/Mushroom pizza.png	2026-03-25 09:37:21.835325+00
60	\N	Herzhaft	Pizza mit Obst	3 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	2.500 Sternis	diy/cooking/Fruit pizza.png	2026-03-25 09:37:21.835325+00
61	\N	Herzhaft	Pizza mit Meeresfrüchten	3 Mehl, 1 Kuruma-Garnele, 2 Teppichmuschel	Nachbarn	4.600 Sternis	diy/cooking/Seafood pizza.png	2026-03-25 09:37:21.835325+00
62	\N	Herzhaft	Carpaccio di capesante	2 Kammmuschel	Nachbarn	2.880 Sternis	diy/cooking/Carpaccio di capesante.png	2026-03-25 09:37:21.835325+00
63	\N	Herzhaft	Carpaccio di salmone	1 Lachs	Lachs angeln	840 Sternis	diy/cooking/Carpaccio di salmone.png	2026-03-25 09:37:21.835325+00
64	\N	Herzhaft	Schnabelbarsch-Carpaccio	1 Schnabelbarsch	Schnabelbarsch angeln	6.000 Sternis	diy/cooking/Barred-knifejaw carpaccio.png	2026-03-25 09:37:21.835325+00
65	\N	Herzhaft	Carpaccio di marlin blu	1 Marlin	Marlin angeln	12.000 Sternis	diy/cooking/Carpaccio di marlin blu.png	2026-03-25 09:37:21.835325+00
66	\N	Herzhaft	Seebarsch-Pastete	3 Mehl, 1 Seebarsch	Seebarsch angeln	1.240 Sternis	diy/cooking/Sea-bass pie.png	2026-03-25 09:37:21.835325+00
67	\N	Herzhaft	Kräuter-Seebarsch	1 Seebarsch, 5 Unkraut	„Genießen mit Anleitungen+“ vom NookPortal	540 Sternis	diy/cooking/Grilled sea bass with herbs.png	2026-03-25 09:37:21.835325+00
68	\N	Herzhaft	Bratmakrele	1 Makrele, 1 Mehl	Makrele angeln	540 Sternis	diy/cooking/Aji fry.png	2026-03-25 09:37:21.835325+00
69	\N	Herzhaft	Karei no nitsuke	1 Kliesche	Kliesche angeln	360 Sternis	diy/cooking/Karei no nitsuke.png	2026-03-25 09:37:21.835325+00
70	\N	Herzhaft	Pilz-Bratflunder	1 Flunder, 1 Dürrpilz	Flunder angeln	1.320 Sternis	diy/cooking/Sautéed_Olive_Flounder_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
71	\N	Herzhaft	Pesce all'acqua pazza	1 Kaiserschnapper, 1 Tomate, 1 Teppichmuschel	Kaiserschnapper angeln	4.140 Sternis	diy/cooking/Pesce all'acqua pazza.png	2026-03-25 09:37:21.835325+00
72	\N	Herzhaft	Tomatenpüree	3 Tomate	„Basis-Rezepte“ aus Nooks Laden	1.260 Sternis	diy/cooking/Tomato puree.png	2026-03-25 09:37:21.835325+00
73	\N	Herzhaft	Einleggemüse	1 Karotte, 1 Kartoffel, 1 Tomate, 1 Orangekürbis	Nachbarn	2.100 Sternis	diy/cooking/Pickled veggies.png	2026-03-25 09:37:21.835325+00
74	\N	Herzhaft	Einlegbambussprossen	3 Bambussprosse	Jorna	1.500 Sternis	diy/cooking/Jarred bamboo shoots.png	2026-03-25 09:37:21.835325+00
75	\N	Herzhaft	Einlegpilze	2 Dürrpilz	Nachbarn	1.200 Sternis	diy/cooking/Jarred mushrooms.png	2026-03-25 09:37:21.835325+00
76	\N	Herzhaft	Orangenmarmelade	3 Orange	Nachbarn	\N	diy/cooking/Orange marmalade.png	2026-03-25 09:37:21.835325+00
77	\N	Herzhaft	Kirschmarmelade	3 Kirsche	Nachbarn	\N	diy/cooking/Cherry jam.png	2026-03-25 09:37:21.835325+00
78	\N	Herzhaft	Pfirsichmarmelade	3 Pfirsich	Nachbarn	\N	diy/cooking/Peach jam.png	2026-03-25 09:37:21.835325+00
79	\N	Herzhaft	Birnenmarmelade	3 Birne	Nachbarn	\N	diy/cooking/Pear jam.png	2026-03-25 09:37:21.835325+00
80	\N	Herzhaft	Apfelmarmelade	3 Apfel	Nachbarn	\N	diy/cooking/Apple jam.png	2026-03-25 09:37:21.835325+00
81	\N	Herzhaft	Kokosöl	3 Kokosnuss	Nachbarn	\N	diy/cooking/Coconut oil.png	2026-03-25 09:37:21.835325+00
82	\N	Herzhaft	Einlegsardinen	1 Sardelle	Sardelle angeln	\N	diy/cooking/Sardines in oil.png	2026-03-25 09:37:21.835325+00
83	\N	Herzhaft	Muschelsuppe	1 Mehl, 3 Teppichmuschel	„Schlemmfest-Rezepte“ (Nooks Laden, Gernod)	\N	diy/cooking/Clam chowder.png	2026-03-25 09:37:21.835325+00
84	\N	Herzhaft	Kürbis-Tarte	3 Mehl, 2 Zucker, 2 Orangekürbis	„Schlemmfest-Rezepte“ (Nooks Laden, Gernod)	\N	diy/cooking/Pumpkin pie.png	2026-03-25 09:37:21.835325+00
85	\N	Herzhaft	Gratin	3 Mehl, 2 Kartoffel	„Schlemmfest-Rezepte“ (Nooks Laden, Gernod)	\N	diy/cooking/Gratin.png	2026-03-25 09:37:21.835325+00
86	\N	Herzhaft	Flunder Müllerinart	1 Flunder, 2 Mehl	„Schlemmfest-Rezepte“ (Nooks Laden, Gernod)	\N	diy/cooking/Olive-Flounder_Meunière_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
87	\N	Süß	Butterplätzchen	1 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Cookies.png	2026-03-25 09:37:21.835325+00
88	\N	Süß	Zuckerguss-Kekse	1 Mehl, 2 Zucker	Nachbarn	\N	diy/cooking/Frosted cookies.png	2026-03-25 09:37:21.835325+00
89	\N	Süß	Marmeladenkekse	1 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Thumbprint jam cookies.png	2026-03-25 09:37:21.835325+00
90	\N	Süß	Kokoskekse	1 Mehl, 1 Zucker, 1 Kokosnuss	Nachbarn	\N	diy/cooking/Coconut cookies.png	2026-03-25 09:37:21.835325+00
91	\N	Süß	Gemüsekekse	1 Mehl, 1 Zucker, 1 Tomate, 1 Karotte, 1 Orangekürbis	Nachbarn	\N	diy/cooking/Veggie cookies.png	2026-03-25 09:37:21.835325+00
92	\N	Süß	Café-Taubenschlag-Keks	1 Mehl, 2 Zucker	Kofi (5 Kaffees)	\N	diy/cooking/Roost_Sablé_Cookie_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
93	\N	Süß	Brezeln	1 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Pretzels.png	2026-03-25 09:37:21.835325+00
94	\N	Süß	Zuckerguss-Brezeln	1 Mehl, 2 Zucker	Nachbarn	\N	diy/cooking/Frosted pretzels.png	2026-03-25 09:37:21.835325+00
95	\N	Süß	Cupcakes ohne alles	1 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Plain cupcakes.png	2026-03-25 09:37:21.835325+00
96	\N	Süß	Rohzucker-Cupcakes	1 Vollkornmehl, 1 Rohzucker	„Basis-Rezepte“ aus Nooks Laden	\N	diy/cooking/Brown-sugar cupcakes.png	2026-03-25 09:37:21.835325+00
97	\N	Süß	Obst-Cupcakes	1 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	\N	diy/cooking/Fruit cupcakes.png	2026-03-25 09:37:21.835325+00
98	\N	Süß	Kürbis-Cupcakes	1 Mehl, 1 Zucker, 2 Orangekürbis	Nachbarn	\N	diy/cooking/Pumpkin cupcakes.png	2026-03-25 09:37:21.835325+00
99	\N	Süß	Gemüse-Cupcakes	1 Mehl, 1 Zucker, 1 Tomate, 1 Karotte, 1 Kartoffel	Nachbarn	\N	diy/cooking/Veggie cupcakes.png	2026-03-25 09:37:21.835325+00
100	\N	Süß	Orangen-Wackelpudding	2 Orange	Nachbarn	\N	diy/cooking/Orange jelly.png	2026-03-25 09:37:21.835325+00
101	\N	Süß	Kirsch-Wackelpudding	2 Kirsche	Nachbarn	\N	diy/cooking/Cherry jelly.png	2026-03-25 09:37:21.835325+00
102	\N	Süß	Pfirsich-Wackelpudding	2 Pfirsich	Nachbarn	\N	diy/cooking/Peach jelly.png	2026-03-25 09:37:21.835325+00
103	\N	Süß	Birnen-Wackelpudding	2 Birne	Nachbarn	\N	diy/cooking/Pear jelly.png	2026-03-25 09:37:21.835325+00
104	\N	Süß	Apfel-Wackelpudding	2 Apfel	Nachbarn	\N	diy/cooking/Apple jelly.png	2026-03-25 09:37:21.835325+00
105	\N	Süß	Kokospudding	1 Zucker, 2 Kokosnuss	Nachbarn	\N	diy/cooking/Coconut pudding.png	2026-03-25 09:37:21.835325+00
106	\N	Süß	Scones	2 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Plain scones.png	2026-03-25 09:37:21.835325+00
107	\N	Süß	Obst-Scones	2 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	\N	diy/cooking/Fruit scones.png	2026-03-25 09:37:21.835325+00
108	\N	Süß	Karotten-Scones	2 Vollkornmehl, 1 Zucker, 2 Karotte	Nachbarn	\N	diy/cooking/Carrot scones.png	2026-03-25 09:37:21.835325+00
109	\N	Süß	Kürbis-Scones	2 Vollkornmehl, 1 Zucker, 2 Orangekürbis	Nachbarn	\N	diy/cooking/Pumpkin scones.png	2026-03-25 09:37:21.835325+00
110	\N	Süß	Orangenkuchen	1 Mehl, 1 Zucker, 1 Orange	Nachbarn	\N	diy/cooking/Orange tart.png	2026-03-25 09:37:21.835325+00
111	\N	Süß	Kirschkuchen	1 Mehl, 1 Zucker, 1 Kirsche	Nachbarn	\N	diy/cooking/Cherry tart.png	2026-03-25 09:37:21.835325+00
112	\N	Süß	Pfirsichkuchen	1 Mehl, 1 Zucker, 1 Pfirsich	Nachbarn	\N	diy/cooking/Peach tart.png	2026-03-25 09:37:21.835325+00
113	\N	Süß	Birnenkuchen	1 Mehl, 1 Zucker, 1 Birne	Nachbarn	\N	diy/cooking/Pear tart.png	2026-03-25 09:37:21.835325+00
114	\N	Süß	Apfelkuchen	1 Mehl, 1 Zucker, 1 Apfel	Nachbarn	\N	diy/cooking/Apple tart.png	2026-03-25 09:37:21.835325+00
115	\N	Süß	Obstkuchen	1 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	\N	diy/cooking/Mixed-fruits tart.png	2026-03-25 09:37:21.835325+00
116	\N	Süß	Karottenkuchen	1 Mehl, 1 Zucker, 1 Karotte	„Basis-Rezepte“ aus Nooks Laden	\N	diy/cooking/Carrot cake.png	2026-03-25 09:37:21.835325+00
117	\N	Süß	Zucker-Crêpe	2 Mehl, 2 Zucker	Nachbarn	\N	diy/cooking/Sugar crepe.png	2026-03-25 09:37:21.835325+00
118	\N	Süß	Obst-Crêpe	2 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	\N	diy/cooking/Mixed-fruits crepe.png	2026-03-25 09:37:21.835325+00
119	\N	Süß	Rührkuchen	2 Mehl, 1 Zucker	Nachbarn	\N	diy/cooking/Pound cake.png	2026-03-25 09:37:21.835325+00
120	\N	Süß	Rohzucker-Rührkuchen	2 Mehl, 1 Rohzucker	Nachbarn	\N	diy/cooking/Brown-sugar pound cake.png	2026-03-25 09:37:21.835325+00
121	\N	Süß	Orangen-Rührkuchen	2 Mehl, 1 Zucker, 2 Orange	Nachbarn	\N	diy/cooking/Orange pound cake.png	2026-03-25 09:37:21.835325+00
122	\N	Süß	Kürbis-Rührkuchen	2 Mehl, 1 Zucker, 2 Orangekürbis	Nachbarn	\N	diy/cooking/Pumpkin pound cake.png	2026-03-25 09:37:21.835325+00
123	\N	Süß	Salzkuchen	2 Mehl, 1 Karotte, 1 Kartoffel	Nachbarn	1.680 Sternis	diy/cooking/Cake_Salé_NH_DIY_Icon.png	2026-03-25 09:37:21.835325+00
124	\N	Süß	Pfannkuchen	2 Mehl, 2 Zucker	„Genießen mit Anleitungen+“ vom NookPortal	1.260 Sternis	diy/cooking/Pancakes.png	2026-03-25 09:37:21.835325+00
125	\N	Süß	Kokospfannkuchen	2 Mehl, 2 Zucker, 2 Kokosnuss	Nachbarn	2.010 Sternis	diy/cooking/Coconut pancakes.png	2026-03-25 09:37:21.835325+00
126	\N	Süß	Obstpfannkuchen	2 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	2.180 Sternis	diy/cooking/Fruit-topped pancakes.png	2026-03-25 09:37:21.835325+00
127	\N	Süß	Orangen-Tarte	3 Mehl, 2 Zucker, 2 Orange	Nachbarn	1.880 Sternis	diy/cooking/Orange pie.png	2026-03-25 09:37:21.835325+00
128	\N	Süß	Kirsch-Tarte	3 Mehl, 2 Zucker, 2 Kirsche	Nachbarn	1.880 Sternis	diy/cooking/Cherry pie.png	2026-03-25 09:37:21.835325+00
129	\N	Süß	Pfirsich-Tarte	3 Mehl, 2 Zucker, 2 Pfirsich	Nachbarn	1.880 Sternis	diy/cooking/Peach pie.png	2026-03-25 09:37:21.835325+00
130	\N	Süß	Birnen-Tarte	3 Mehl, 2 Zucker, 2 Birne	Nachbarn	1.880 Sternis	diy/cooking/Pear pie.png	2026-03-25 09:37:21.835325+00
131	\N	Süß	Apfel-Tarte	3 Mehl, 2 Zucker, 2 Apfel	Nachbarn	1.880 Sternis	diy/cooking/Apple pie.png	2026-03-25 09:37:21.835325+00
132	\N	Süß	Obst-Tarte	3 Mehl, 1 Apfel, 1 Orange, 1 Birne, 1 Pfirsich, 1 Kirsche	Nachbarn	2.500 Sternis	diy/cooking/Mixed-fruits pie.png	2026-03-25 09:37:21.835325+00
133	\N	Süß	Orangen-Smoothie	2 Orange	Nachbarn, „Genießen mit Anleitungen+“ vom NookPortal	300 Sternis	diy/cooking/Orange smoothie.png	2026-03-25 09:37:21.835325+00
134	\N	Süß	Kirsch-Smoothie	2 Kirsche	Nachbarn, „Genießen mit Anleitungen+“ vom NookPortal	300 Sternis	diy/cooking/Cherry smoothie.png	2026-03-25 09:37:21.835325+00
135	\N	Süß	Pfirsich-Smoothie	2 Pfirsich	Nachbarn, „Genießen mit Anleitungen+“ vom NookPortal	300 Sternis	diy/cooking/Peach smoothie.png	2026-03-25 09:37:21.835325+00
136	\N	Süß	Birnen-Smoothie	2 Birne	Nachbarn, „Genießen mit Anleitungen+“ vom NookPortal	300 Sternis	diy/cooking/Pear smoothie.png	2026-03-25 09:37:21.835325+00
137	\N	Süß	Apfel-Smoothie	2 Apfel	Nachbarn, „Genießen mit Anleitungen+“ vom NookPortal	300 Sternis	diy/cooking/Apple smoothie.png	2026-03-25 09:37:21.835325+00
138	\N	Süß	Kokosmilch	2 Kokosnuss	Nachbarn	750 Sternis	diy/cooking/Coconut milk.png	2026-03-25 09:37:21.835325+00
139	\N	Süß	Tomatensaft	2 Tomate	Nachbarn	840 Sternis	diy/cooking/Tomato juice.png	2026-03-25 09:37:21.835325+00
140	\N	Süß	Karottensaft	2 Karotte	Nachbarn	840 Sternis	diy/cooking/Carrot juice.png	2026-03-25 09:37:21.835325+00
141	\N	Süß	Halloween-Kekse	1 Mehl, 1 Orangekürbis, 1 Gelbkürbis, 1 Weißkürbis, 1 Grünkürbis	Ballon, Nachbarn (Oktober), Nachbarn (Halloween)	1.820 Sternis	diy/cooking/Spooky cookies.png	2026-03-25 09:37:21.835325+00
\.


--
-- TOC entry 3907 (class 0 OID 17084)
-- Dependencies: 236
-- Data for Name: creature_locations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.creature_locations (creature_id, location_name) FROM stdin;
83	Fluss
84	Fluss
85	Fluss
86	Fluss
87	Fluss
88	Fluss
89	Fluss
91	Fluss
93	Fluss
94	Fluss
101	Fluss
104	Fluss
105	Fluss
110	Fluss
111	Fluss
122	Fluss
130	Fluss
132	Fluss
135	Fluss
142	Fluss
145	Fluss
150	Fluss
151	Fluss
153	Fluss
157	Fluss
159	Fluss
160	Fluss
95	Teich
96	Teich
99	Teich
112	Teich
113	Teich
114	Teich
115	Teich
117	Teich
119	Teich
134	Teich
146	Teich
155	Teich
98	Fluss (Plateau)
106	Fluss (Plateau)
125	Fluss (Plateau)
140	Fluss (Plateau)
118	Flussmündung
121	Flussmündung
154	Flussmündung
100	Steg
124	Steg
152	Steg
156	Steg
81	Meer
82	Meer
90	Meer
92	Meer
97	Meer
102	Meer
103	Meer
107	Meer
108	Meer
109	Meer
116	Meer
120	Meer
123	Meer
126	Meer
127	Meer
128	Meer
129	Meer
131	Meer
133	Meer
136	Meer
137	Meer
138	Meer
139	Meer
141	Meer
143	Meer
144	Meer
147	Meer
148	Meer
149	Meer
158	Meer
2	fliegt nahe Blumen
31	fliegt nahe Blumen
33	fliegt nahe Blumen
37	fliegt nahe Blumen
38	fliegt nahe Blumen
39	fliegt nahe Blumen
47	fliegt nahe Blumen
56	fliegt nahe Blumen
64	fliegt nahe Blumen
71	fliegt nahe Blumen
72	fliegt nahe Blumen
77	fliegt nahe Blumen
80	fliegt nahe Blumen
60	fliegt nahe dunkler Blumen
49	fliegt in der Luft
48	bei Lichtquellen
7	an Bäumen und Palmen
24	an Bäumen und Palmen
36	an Bäumen und Palmen
1	an Bäumen
9	an Bäumen
12	an Bäumen
32	an Bäumen
35	an Bäumen
51	an Bäumen
53	an Bäumen
57	an Bäumen
58	an Bäumen
62	an Bäumen
69	an Bäumen
79	an Bäumen
3	an Palmen
6	an Palmen
11	an Palmen
13	an Palmen
15	an Palmen
22	an Palmen
25	an Palmen
29	an Palmen
23	Boden
27	Boden
28	Boden
30	Boden
50	Boden
61	Boden
66	Boden
67	Boden
73	Boden
74	Boden
21	auf Blumen
26	auf Blumen
44	auf Blumen
70	auf Blumen
52	auf weißen Blumen
8	Bäume schütteln
68	Bäume schütteln
78	Bäume schütteln
16	fliegt nahe Gewässern
40	fliegt nahe Gewässern
42	fliegt nahe Gewässern
55	fliegt nahe Gewässern
75	fliegt nahe Gewässern
45	in der Erde
59	Fluss, auf dem Wasser
65	Fluss, auf dem Wasser
76	Fluss, auf dem Wasser
4	auf Baumstümpfen
17	auf Baumstümpfen
20	auf Baumstümpfen
54	auf Baumstümpfen
46	an Schneebällen
10	unter Bäumen (getarnt als Blatt)
5	an verfaulten Rüben oder Bonbons
14	am Strand
43	auf Felsen am Strand
18	an Müll
19	auf Dorfbewohnern
63	auf Steinen und Büschen
34	Felsen schlagen
41	Felsen schlagen
\.


--
-- TOC entry 3904 (class 0 OID 17054)
-- Dependencies: 233
-- Data for Name: creature_shadows; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.creature_shadows (creature_id, shadow_image) FROM stdin;
81	faunapedia/fish/Schatten/winzig.png
88	faunapedia/fish/Schatten/winzig.png
89	faunapedia/fish/Schatten/winzig.png
99	faunapedia/fish/Schatten/winzig.png
101	faunapedia/fish/Schatten/winzig.png
114	faunapedia/fish/Schatten/winzig.png
115	faunapedia/fish/Schatten/winzig.png
130	faunapedia/fish/Schatten/winzig.png
135	faunapedia/fish/Schatten/winzig.png
142	faunapedia/fish/Schatten/winzig.png
148	faunapedia/fish/Schatten/winzig.png
149	faunapedia/fish/Schatten/winzig.png
155	faunapedia/fish/Schatten/winzig.png
86	faunapedia/fish/Schatten/klein.png
90	faunapedia/fish/Schatten/klein.png
94	faunapedia/fish/Schatten/klein.png
95	faunapedia/fish/Schatten/klein.png
96	faunapedia/fish/Schatten/klein.png
97	faunapedia/fish/Schatten/klein.png
110	faunapedia/fish/Schatten/klein.png
111	faunapedia/fish/Schatten/klein.png
123	faunapedia/fish/Schatten/klein.png
131	faunapedia/fish/Schatten/klein.png
132	faunapedia/fish/Schatten/klein.png
134	faunapedia/fish/Schatten/klein.png
141	faunapedia/fish/Schatten/klein.png
150	faunapedia/fish/Schatten/klein.png
151	faunapedia/fish/Schatten/klein.png
153	faunapedia/fish/Schatten/klein.png
160	faunapedia/fish/Schatten/klein.png
85	faunapedia/fish/Schatten/mittel.png
93	faunapedia/fish/Schatten/mittel.png
98	faunapedia/fish/Schatten/mittel.png
104	faunapedia/fish/Schatten/mittel.png
107	faunapedia/fish/Schatten/mittel.png
109	faunapedia/fish/Schatten/mittel.png
116	faunapedia/fish/Schatten/mittel.png
120	faunapedia/fish/Schatten/mittel.png
125	faunapedia/fish/Schatten/mittel.png
138	faunapedia/fish/Schatten/mittel.png
140	faunapedia/fish/Schatten/mittel.png
144	faunapedia/fish/Schatten/mittel.png
157	faunapedia/fish/Schatten/mittel.png
82	faunapedia/fish/Schatten/groß.png
84	faunapedia/fish/Schatten/groß.png
87	faunapedia/fish/Schatten/groß.png
91	faunapedia/fish/Schatten/groß.png
108	faunapedia/fish/Schatten/groß.png
112	faunapedia/fish/Schatten/groß.png
113	faunapedia/fish/Schatten/groß.png
119	faunapedia/fish/Schatten/groß.png
121	faunapedia/fish/Schatten/groß.png
145	faunapedia/fish/Schatten/groß.png
146	faunapedia/fish/Schatten/groß.png
159	faunapedia/fish/Schatten/groß.png
92	faunapedia/fish/Schatten/sehr-groß.png
100	faunapedia/fish/Schatten/sehr-groß.png
105	faunapedia/fish/Schatten/sehr-groß.png
106	faunapedia/fish/Schatten/sehr-groß.png
118	faunapedia/fish/Schatten/sehr-groß.png
122	faunapedia/fish/Schatten/sehr-groß.png
137	faunapedia/fish/Schatten/sehr-groß.png
147	faunapedia/fish/Schatten/sehr-groß.png
152	faunapedia/fish/Schatten/sehr-groß.png
83	faunapedia/fish/Schatten/riesig.png
117	faunapedia/fish/Schatten/riesig.png
124	faunapedia/fish/Schatten/riesig.png
128	faunapedia/fish/Schatten/riesig.png
133	faunapedia/fish/Schatten/riesig.png
136	faunapedia/fish/Schatten/riesig.png
154	faunapedia/fish/Schatten/riesig.png
156	faunapedia/fish/Schatten/riesig.png
102	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
103	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
126	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
139	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
143	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
158	faunapedia/fish/Schatten/Sehr-groß-mit-Rückenflosse.png
127	faunapedia/fish/Schatten/schmal.png
129	faunapedia/fish/Schatten/schmal.png
175	winzig
176	winzig
178	winzig
196	winzig
161	klein
162	klein
163	klein
164	klein
172	klein
173	klein
177	klein
179	klein
183	klein
185	klein
188	klein
190	klein
191	klein
194	klein
197	klein
198	klein
165	mittel
166	mittel
168	mittel
170	mittel
180	mittel
181	mittel
182	mittel
184	mittel
186	mittel
193	mittel
195	mittel
199	mittel
169	groß
171	groß
174	groß
189	groß
192	groß
200	groß
167	sehr groß
187	sehr groß
\.


--
-- TOC entry 3905 (class 0 OID 17064)
-- Dependencies: 234
-- Data for Name: creature_speeds; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.creature_speeds (creature_id, speed) FROM stdin;
172	bewegungslos
192	bewegungslos
196	bewegungslos
200	bewegungslos
176	sehr langsam
178	sehr langsam
179	sehr langsam
193	sehr langsam
197	sehr langsam
161	langsam
162	langsam
163	langsam
170	langsam
175	langsam
177	langsam
180	langsam
188	langsam
191	langsam
194	langsam
198	langsam
164	mittelschnell
165	mittelschnell
168	mittelschnell
173	mittelschnell
181	mittelschnell
182	mittelschnell
183	mittelschnell
184	mittelschnell
195	mittelschnell
166	schnell
169	schnell
174	schnell
185	schnell
189	schnell
167	sehr schnell
171	sehr schnell
186	sehr schnell
187	sehr schnell
190	sehr schnell
199	sehr schnell
\.


--
-- TOC entry 3906 (class 0 OID 17074)
-- Dependencies: 235
-- Data for Name: creature_weathers; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.creature_weathers (creature_id, weather) FROM stdin;
63	Regen
2	Sonne
4	Sonne
16	Sonne
17	Sonne
20	Sonne
21	Sonne
26	Sonne
27	Sonne
28	Sonne
31	Sonne
33	Sonne
37	Sonne
38	Sonne
39	Sonne
40	Sonne
42	Sonne
44	Sonne
47	Sonne
48	Sonne
49	Sonne
52	Sonne
54	Sonne
55	Sonne
56	Sonne
60	Sonne
61	Sonne
64	Sonne
67	Sonne
70	Sonne
71	Sonne
72	Sonne
75	Sonne
77	Sonne
80	Sonne
1	Jedes
3	Jedes
5	Jedes
6	Jedes
7	Jedes
8	Jedes
9	Jedes
10	Jedes
11	Jedes
12	Jedes
13	Jedes
14	Jedes
15	Jedes
18	Jedes
19	Jedes
22	Jedes
23	Jedes
24	Jedes
25	Jedes
29	Jedes
30	Jedes
32	Jedes
34	Jedes
35	Jedes
36	Jedes
41	Jedes
43	Jedes
45	Jedes
46	Jedes
50	Jedes
51	Jedes
53	Jedes
57	Jedes
58	Jedes
59	Jedes
62	Jedes
65	Jedes
66	Jedes
68	Jedes
69	Jedes
73	Jedes
74	Jedes
76	Jedes
78	Jedes
79	Jedes
\.


--
-- TOC entry 3887 (class 0 OID 16604)
-- Dependencies: 216
-- Data for Name: creatures; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.creatures (id, category, name, price, catchphrase, image_path, months_northern, time_active, created_at) FROM stdin;
1	insect	Abendzikade	550	Eine Abendzikade! Ihr Gesang klingt so wehmütig...	faunapedia/insects/Evening Cicada.png	{7,8}	04:00 – 08:00 & 16:00 – 19:00	2026-03-24 10:07:32.530155+00
2	insect	Agrias-Falter	3000	Ein Agrias-Falter! Du treibst es ja ganz schön bunt!	faunapedia/insects/Agrias Butterfly.png	{4,5,6,7,8,9}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
3	insect	Allotopus rosenbergi	10000	Ein Allotopus rosenbergi! Er sieht aus wie aus purem Gold!	faunapedia/insects/Golden Stag.png	{7,8}	23:00 – 08:00	2026-03-24 10:07:32.530155+00
4	insect	Alpenbock	3000	Ein Alpenbock! Der hatte wohl keinen Bock mehr auf die Alpen...	faunapedia/insects/Rosalia Batesi Beetle.png	{5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
5	insect	Ameise	80	Eine Ameise! Da ist mir wohl eine ins Netz gegangen!	faunapedia/insects/Ant.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
6	insect	Atlaskäfer	8000	Ein Atlaskäfer! Trägt er die Last der Welt auf seinen Schultern?	faunapedia/insects/Horned Atlas.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
7	insect	Atlasspinner	3000	Ein Atlasspinner! Er mag zwar spinnen, aber er verfliegt sich bestimmt nie!	faunapedia/insects/Atlas Moth.png	{4,5,6,7,8,9}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
8	insect	Beutelschneider (Sackträger)	600	Ein Sackträger! Was der wohl alles in seinem Sack hat?	faunapedia/insects/Bagworm.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
9	insect	Bergzikade	400	Eine Bergzikade! Ihr Gesang klingt lustig!	faunapedia/insects/Walker Cicada.png	{8,9}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
10	insect	Blattschrecke	600	Eine Blattschrecke! Ich dachte erst, das wäre ein Blatt!	faunapedia/insects/Walking Leaf.png	{7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
11	insect	Blaurüsselkäfer	800	Ein Blaurüsselkäfer! Deine Augen sind blau wie ein Blaurüsselkäfer...	faunapedia/insects/Blue Weevil Beetle.png	{7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
12	insect	Braunzikade	250	Eine Braunzikade! Da zieh ich die Brauen hoch!	faunapedia/insects/Brown Cicada.png	{7,8}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
13	insect	Cyclommatus	8000	Ein Cyclommatus! Was für ein Kiefer!	faunapedia/insects/Cyclommatus Stag.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
14	insect	Einsiedlerkrebs	1000	Ein Einsiedlerkrebs! Suchst du Gesellschaft?	faunapedia/insects/Hermit Crab.png	{1,2,3,4,5,6,7,8,9,10,11,12}	19:00 – 08:00	2026-03-24 10:07:32.530155+00
15	insect	Elefantenkäfer	8000	Ein Elefantenkäfer! Er hat einen Rüssel, aber keine Ohren!	faunapedia/insects/Horned Elephant.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
16	insect	Feuerlibelle	180	Eine Feuerlibelle! Ein brandheißer Fang!	faunapedia/insects/Red Dragonfly.png	{9,10}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
17	insect	Fichtenbock	350	Ein Fichtenbock! Da habe ich wohl einen Bock geschossen!	faunapedia/insects/Citrus Long-Horned Beetle.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
18	insect	Fliege	60	Eine Fliege! Was für ein Reinfall!	faunapedia/insects/Fly.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
19	insect	Floh	70	Ein Floh! Der ist mir gerade noch rechtzeitig ins Netz gesprungen!	faunapedia/insects/Flea.png	{4,5,6,7,8,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
20	insect	Geigenkäfer	450	Ein Geigenkäfer! Der sieht aus, als wollte er mir tüchtig die Meinung geigen...	faunapedia/insects/Violin Beetle.png	{5,6,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
21	insect	Gesichtswanze	1000	Eine Gesichtswanze! An wen erinnert mich die...	faunapedia/insects/Man-Faced Stink Bug.png	{3,4,5,6,7,8,9,10}	19:00 – 08:00	2026-03-24 10:07:32.530155+00
22	insect	Giraffenhirschkäfer	12000	Ein Giraffenhirschkäfer! Ganz schön langer Hals für so einen Käfer!	faunapedia/insects/Giraffe Stag.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
23	insect	Gold-Mistkäfer	300	Ein Gold-Mistkäfer! Tja, Gegensätze ziehen sich an!	faunapedia/insects/Earth-Boring Dung Beetle.png	{7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
24	insect	Goldskarabäus	10000	Ein Goldskarabäus! Ein Juwel auf Beinen!	faunapedia/insects/Scarab Beetle.png	{7,8}	23:00 – 08:00	2026-03-24 10:07:32.530155+00
25	insect	Goliathkäfer	8000	Ein Goliathkäfer! Ein wahrer Riese unter den Käfern!	faunapedia/insects/Goliath Beetle.png	{6,7,8,9}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
26	insect	Gottesanbeterin	430	Eine Gottesanbeterin! Du bist ein guter Fang, Schrecke!	faunapedia/insects/Mantis.png	{3,4,5,6,7,8,9,10,11}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
27	insect	Grashüpfer	160	Ein Grashüpfer! Diese Hüpferei scheint gerade zu grassieren...	faunapedia/insects/Grasshopper.png	{7,8,9}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
28	insect	Grille	130	Eine Grille! Warst du unterwegs zu einer Grillparty?	faunapedia/insects/Cricket.png	{9,10,11}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
29	insect	Herkuleskäfer	12000	Ein Herkuleskäfer! Ganz schön stark für seine Größe!	faunapedia/insects/Horned Hercules.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
30	insect	Heuschrecke	400	Eine Heuschrecke! Schrecke ahoi!	faunapedia/insects/Long Locust.png	{8,9,10,11}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
31	insect	Himmelsfalter	4000	Ein Himmelsfalter! Mein Kescher war wie ein Blitz aus heiterem Himmel!	faunapedia/insects/Emperor Butterfly.png	{12,1,2,3,6,7,8,9}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
32	insect	Hirschkäfer	2000	Ein Hirschkäfer! Hast du dich im Wald verirrt?	faunapedia/insects/Miyama Stag.png	{7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
33	insect	Honigbiene	200	Eine Honigbiene! Was für ein süßer Fang!	faunapedia/insects/Honeybee.png	{3,4,5,6,7}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
34	insect	Hundertfüßer	300	Ein Hundertfüßer! Hast du für alle Beine auch Socken?	faunapedia/insects/Centipede.png	{9,10,11,12,1,2,3,4,5,6}	16:00 – 23:00	2026-03-24 10:07:32.530155+00
35	insect	Hyalessa-Zikade	300	Eine Hyalessa-Zikade! Hüah, kleine Zikade!	faunapedia/insects/Robust Cicada.png	{7,8}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
36	insect	Japan-Rosenkäfer	200	Ein Japan-Rosenkäfer! Und, wo sind die Rosen?	faunapedia/insects/Drone Beetle.png	{6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
37	insect	Japan-Schillerfalter	3000	Ein Japan-Schillerfalter! Du hast eine schillernde Zukunft in meiner Sammlung!	faunapedia/insects/Great Purple Emperor.png	{5,6,7,8}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
38	insect	Kohlweißling	160	Ein Kohlweißling! Von dir lass ich mich nicht verkohlen!	faunapedia/insects/Common Butterfly.png	{9,10,11,12,1,2,3,4,5,6}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
39	insect	Kolibrifalter	300	Ein Kolibrifalter! Macht der Faltkolibris?	faunapedia/insects/Common Bluebottle.png	{4,5,6,7,8}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
40	insect	Königslibelle	230	Eine Königslibelle! Die Krönung des Tages!	faunapedia/insects/Banded Dragonfly.png	{4,5,6,7,8,9,10}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
41	insect	Kugelassel	250	Eine Kugelassel! Das nenne ich mal eine runde Sache!	faunapedia/insects/Pill Bug.png	{9,10,11,12,1,2,3,4,5,6}	16:00 – 23:00	2026-03-24 10:07:32.530155+00
42	insect	Leuchtkäfer	300	Ein Leuchtkäfer! Dem hab ich heimgeleuchtet!	faunapedia/insects/Firefly.png	{6}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
43	insect	Ligia exotica	200	Eine Ligia exotica! Du hast wohl zu viele Beine, um wegzulaufen!	faunapedia/insects/Wharf Roach.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
44	insect	Marienkäfer	200	Ein Marienkäfer! Punktlandung im Kescher!	faunapedia/insects/Ladybug.png	{3,4,5,6,10}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
45	insect	Maulwurfsgrille	500	Eine Maulwurfsgrille! Du hättest wohl besser 'ne Schippe draufgelegt!	faunapedia/insects/Mole Cricket.png	{11,12,1,2,3,4,5}	Ganztägig	2026-03-24 10:07:32.530155+00
46	insect	Mistkäfer	3000	Ein Mistkäfer! Keine Sammlung ist komplett, wenn sie den vermisst!	faunapedia/insects/Dung Beetle.png	{12,1,2}	Ganztägig	2026-03-24 10:07:32.530155+00
47	insect	Monarchfalter	140	Ein Monarchfalter! Na? Wer ist jetzt hier der Monarch, Alter?	faunapedia/insects/Monarch Butterfly.png	{9,10,11}	04:00 – 17:00	2026-03-24 10:07:32.530155+00
48	insect	Motte	130	Eine Motte! Zum Kugeln!	faunapedia/insects/Moth.png	{1,2,3,4,5,6,7,8,9,10,11,12}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
49	insect	Mücke	130	Eine Mücke! Mir wird's hier zu bunt, ich mache die Mücke!	faunapedia/insects/Mosquito.png	{6,7,8,9}	17:00 – 04:00	2026-03-24 10:07:32.530155+00
50	insect	Nasenschrecke	200	Eine Nasenschrecke! Hab dich! Jetzt kann ich dir eine lange Nase drehen!	faunapedia/insects/Rice Grasshopper.png	{4,5,6,7,8,9,10,11}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
51	insect	Nashornkäfer	1350	Ein Nashornkäfer! Horn ab, Käfer!	faunapedia/insects/Horned Dynastid.png	{7,8}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
52	insect	Orchideenmantis	2400	Eine Orchideenmantis! Ich sehe unsere Freundschaft schon erblühen!	faunapedia/insects/Orchid Mantis.png	{3,4,5,6,7,8,9,10,11}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
53	insect	Pracht-Hirschkäfer	12000	Ein Pracht-Hirschkäfer! Ein wahrer Prachtkerl!	faunapedia/insects/Rainbow Stag.png	{7,8}	23:00 – 08:00	2026-03-24 10:07:32.530155+00
54	insect	Prachtkäfer	2400	Ein Prachtkäfer! Ein wahres Schmuckstück!	faunapedia/insects/Jewel Beetle.png	{4,5,6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
55	insect	Quelljungfer	4500	Eine Quelljungfer! Hab ich dich, du Quälgeist!	faunapedia/insects/Darner Dragonfly.png	{5,6,7,8,9,10}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
56	insect	Regenbogenfalter	2500	Ein Regenbogenfalter! Der ist so schön, da gehen mir die Sprüche aus...	faunapedia/insects/Madagascan Sunset Moth.png	{4,5,6,7,8,9}	08:00 – 16:00	2026-03-24 10:07:32.530155+00
57	insect	Riesen-Hirschkäfer	10000	Ein Riesen-Hirschkäfer! Ein Riese unter den Käfern!	faunapedia/insects/Giant Stag.png	{7,8}	23:00 – 08:00	2026-03-24 10:07:32.530155+00
58	insect	Riesenzikade	500	Eine Riesenzikade! Ganz schöner Brummer, im wahrsten Sinne des Wortes...	faunapedia/insects/Giant Cicada.png	{7,8}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
59	insect	Riesenwanze	2000	Eine Riesenwanze! Es ist nie gut, wenn ein Insekt „Riesen-“ im Namen trägt...	faunapedia/insects/Giant Water Bug.png	{4,5,6,7,8,9}	19:00 – 08:00	2026-03-24 10:07:32.530155+00
60	insect	Ritterfalter	2500	Ein Ritterfalter! Kannst du mit der Rüstung noch fliegen?	faunapedia/insects/Tiger Butterfly.png	{3,4,5,6}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
61	insect	Sandlaufkäfer	1500	Ein Sandlaufkäfer! Nachdem ich dich gefangen habe, bist du erst mal nur Handlaufkäfer!	faunapedia/insects/Tiger Beetle.png	{2,3,4,5,6,7,8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
62	insect	Sägezahn-Hirschkäfer	2000	Ein Sägezahn-Hirschkäfer! Du hast wohl eine spitze Zunge?	faunapedia/insects/Saw Stag.png	{7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
63	insect	Schnecke	250	Eine Schnecke! Hab dich! Da hast du wohl zu langsam gemacht!	faunapedia/insects/Snail.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig (Regen)	2026-03-24 10:07:32.530155+00
64	insect	Schwalbenschwanz	240	Ein Schwalbenschwanz! Zwitschern die nicht immer zu zweit zwischen zwei Zweigen?	faunapedia/insects/Tiger Butterfly.png	{3,4,5,6,7,8,9}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
65	insect	Schwimmkäfer	800	Ein Schwimmkäfer! Dass ich dich gefangen habe, ist hoffentlich nicht schlimm, Käfer...	faunapedia/insects/Diving Beetle.png	{5,6,7,8,9}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
66	insect	Skorpion	8000	Ein Skorpion! Der Stich hat gesessen!	faunapedia/insects/Scorpion.png	{5,6,7,8,9,10}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
67	insect	Singgrille	430	Eine Singgrille! Du musst nicht mehr alles allein machen. Du singst, ich grille!	faunapedia/insects/Bell Cricket.png	{9,10}	17:00 – 08:00	2026-03-24 10:07:32.530155+00
68	insect	Spinne	600	Eine Spinne! Da habe ich wohl ein Netz für dich gewebt!	faunapedia/insects/Spider.png	{1,2,3,4,5,6,7,8,9,10,11,12}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
69	insect	Stabschrecke	600	Eine Stabschrecke! Hab dich! Du dachtest wohl, du könntest dich hier einfach so dünnemachen!	faunapedia/insects/Walking Stick.png	{7,8,9,10,11}	04:00 – 08:00 & 17:00 – 19:00	2026-03-24 10:07:32.530155+00
70	insect	Stinkwanze	120	Eine Stinkwanze! Kein sehr netter Name, aber immerhin deutlich!	faunapedia/insects/Stinkbug.png	{3,4,5,6,7,8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
71	insect	Troides brookiana	2500	Ein Troides brookiana! Meiner Treu!	faunapedia/insects/Rajah Brooke's Birdwing.png	{4,5,6,7,8,9,12,1,2}	08:00 – 17:00	2026-03-24 10:07:32.530155+00
72	insect	Vogelfalter	4000	Ein Vogelfalter! Macht der Origami-Vögel?	faunapedia/insects/Queen Alexandra's Birdwing.png	{5,6,7,8,9}	08:00 – 16:00	2026-03-24 10:07:32.530155+00
73	insect	Vogelspinne	8000	Eine Vogelspinne! Von dir lass ich mich nicht einspinnen!	faunapedia/insects/Tarantula.png	{11,12,1,2,3,4}	19:00 – 04:00	2026-03-24 10:07:32.530155+00
74	insect	Wanderschrecke	600	Eine Wanderschrecke! Du wanderst jetzt in meine Sammlung!	faunapedia/insects/Migratory Locust.png	{8,9,10,11}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
75	insect	Wasserjungfer	500	Eine Wasserjungfer! Hat dich dein Jungfernflug in meinen Kescher geführt?	faunapedia/insects/Damselfly.png	{11,12,1,2}	Ganztägig	2026-03-24 10:07:32.530155+00
76	insect	Wasserläufer	130	Ein Wasserläufer! Das Laufen hat dir nix genützt, du hättest dich nicht hetzen müssen!	faunapedia/insects/Pondskater.png	{5,6,7,8,9}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
77	insect	Weiße Baumnymphe	1000	Eine Weiße Baumnymphe! Nymphen habe ich mir ja schon anders vorgestellt...	faunapedia/insects/Paper Kite Butterfly.png	{1,2,3,4,5,6,7,8,9,10,11,12}	08:00 – 19:00	2026-03-24 10:07:32.530155+00
78	insect	Wespe	2500	Eine Wespe! Dich steck ich glatt in die Wespentasche!	faunapedia/insects/Wasp.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
79	insect	Zikadenlarvenhaut	10	Eine Zikadenlarvenhaut! Nur eine Hülle ihres früheren Selbst...	faunapedia/insects/Cicada Shell.png	{7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
80	insect	Zitronenfalter	160	Ein Zitronenfalter! Sei nicht sauer, weil ich dich gefangen habe!	faunapedia/insects/Yellow Butterfly.png	{3,4,5,6,9,10}	04:00 – 19:00	2026-03-24 10:07:32.530155+00
81	fish	Anemonenfisch	650	Ein Anemonenfisch! Ich bin doch kein Anemon-Monster!	faunapedia/fish/Clown Fish.png	{4,5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
82	fish	Anglerfisch	2500	Ein Anglerfisch! Hallo, Kollege!	faunapedia/fish/Football Fish.png	{11,12,1,2,3}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
83	fish	Arapaima	10000	Ein Arapaima! Er ist so groß, dass er fast Arapapa-Ma-Ma sagen könnte!	faunapedia/fish/Arapaima.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
84	fish	Arowana	10000	Ein Arowana! Er ist sein Gewicht in Gold wert!	faunapedia/fish/Arowana.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
85	fish	Ayu	900	Ein Ayu! Ayu, was soll man da sagen?	faunapedia/fish/Sweetfish.png	{7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
86	fish	Bachschmerle	400	Eine Bachschmerle! Das Leben im Bach ist beschmerlich.	faunapedia/fish/Loach.png	{3,4,5}	Ganztägig	2026-03-24 10:07:32.530155+00
87	fish	Barsch	400	Ein Barsch! Abmarsch, Barsch!	faunapedia/fish/Black Bass.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
88	fish	Bitterling	900	Ein Bitterling! Bitte sei nicht verbittert…	faunapedia/fish/Bitterling.png	{11,12,1,2,3}	Ganztägig	2026-03-24 10:07:32.530155+00
89	fish	Döbel	200	Ein Döbel! Schau nicht so bedöbelt!	faunapedia/fish/Dace.png	{1,2,3,4,5,6,7,8,9,10,11,12}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
90	fish	Falterfisch	1000	Ein Falterfisch! Er hat wohl einiges zu verfaltern.	faunapedia/fish/Butterfly Fish.png	{4,5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
91	fish	Flösselhecht	4000	Ein Flösselhecht! Flössel doch woanders rum!	faunapedia/fish/Saddled Bichir.png	{6,7,8,9}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
92	fish	Flunder	800	Eine Flunder! Na, bist du wohlauf, Flunder?	faunapedia/fish/Olive Flounder.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
93	fish	Flussbarsch	300	Ein Flussbarsch! Bist du leicht beeinflussbarsch?	faunapedia/fish/Yellow Perch.png	{10,11,12,1,2,3}	Ganztägig	2026-03-24 10:07:32.530155+00
94	fish	Flussgrundel	400	Eine Flussgrundel! Die ist mir grundelich auf den Leim gegangen!	faunapedia/fish/Freshwater Goby.png	{1,2,3,4,5,6,7,8,9,10,11,12}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
95	fish	Flusskrebs	200	Ein Flusskrebs! Schluss mit Fluss, jetzt krebst du an meiner Angel rum!	faunapedia/fish/Crawfish.png	{4,5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
96	fish	Frosch	120	Ein Frosch! Ich hab dich gefangen, die Kröte musst du jetzt schlucken!	faunapedia/fish/Frog.png	{5,6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
97	fish	Glaskopffisch	15000	Ein Glaskopffisch! Ha, ich habe dich durchschaut!	faunapedia/fish/Barreleye.png	{1,2,3,4,5,6,7,8,9,10,11,12}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
98	fish	Goldforelle	15000	Eine Goldforelle! Viel größer als ein Silberfischchen…	faunapedia/fish/Golden Trout.png	{3,4,5,9,10,11}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
99	fish	Goldfisch	1300	Ein Goldfisch! Er ist sein Gewicht in Fisch wert!	faunapedia/fish/Goldfish.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
100	fish	Goldmakrele	6000	Eine Goldmakrele! Ein glänzender Fang!	faunapedia/fish/Mahi-Mahi.png	{5,6,7,8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
101	fish	Guppy	1300	Ein Guppy! Super, denn ich bin ein echtes Guppy-Groupie!	faunapedia/fish/Guppy.png	{4,5,6,7,8,9,10,11}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
102	fish	Hai	15000	Ein Hai! Hai-erlei!	faunapedia/fish/Great White Shark.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
103	fish	Hammerhai	8000	Ein Hammerhai! Der absolute Hammer!	faunapedia/fish/Hammerhead Shark.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
104	fish	Hasel	240	Ein Hasel! Haselein, hüpf!	faunapedia/fish/Pale Chub.png	{1,2,3,4,5,6,7,8,9,10,11,12}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
105	fish	Hecht	1800	Ein Hecht! Schon recht, Hecht!	faunapedia/fish/Pike.png	{9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
106	fish	Huchen	15000	HUCH! Ein Huchen! Nach denen muss man suchen!	faunapedia/fish/Stringfish.png	{12,1,2,3}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
107	fish	Igelfisch	250	Ein Igelfisch! Stachel dich nicht so auf!	faunapedia/fish/Blowfish.png	{7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
108	fish	Kaiserschnapper	3000	Ein Kaiserschnapper! Ein kaiserlicher Fang!	faunapedia/fish/Red Snapper.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
109	fish	Kalmar	500	Ein Kalmar! Das ist kal-markante Leistung!	faunapedia/fish/Squid.png	{12,1,2,3,4,5,6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
110	fish	Kampffisch	2500	Ein friedlicher Kampffisch! Da habe ich aber Glück!	faunapedia/fish/Betta.png	{5,6,7,8,9,10}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
111	fish	Karausche	160	Eine Karausche! Karausch mit dir aus dem Wasser!	faunapedia/fish/Crucian Carp.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
112	fish	Karpfen	300	Ein Karpfen! Meine karpfhafte Suche ist beendet!	faunapedia/fish/Carp.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
113	fish	Katzenwels	800	Ein Katzenwels! Fällst du auch immer auf die Flossen?	faunapedia/fish/Catfish.png	{5,6,7,8,9,10}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
114	fish	Kaulquappe	100	Eine Kaulquappe! Klein, aber nicht von Pappe!	faunapedia/fish/Tadpole.png	{3,4,5,6,7}	Ganztägig	2026-03-24 10:07:32.530155+00
115	fish	Killifisch	300	Ein Killifisch! Klingt gefährlicher, als er ist…	faunapedia/fish/Killifish.png	{4,5,6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
116	fish	Kliesche	300	Eine Kliesche! Und gar kein Klischee!	faunapedia/fish/Dab.png	{10,11,12,1,2,3,4}	Ganztägig	2026-03-24 10:07:32.530155+00
117	fish	Knochenhecht	6000	Ein Knochenhecht! Den habe ich mir redlich erklappert!	faunapedia/fish/Gar.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
118	fish	Königslachs	1800	Ein Königslachs! Hat dir der Hoffnarr einen guten Witz erzählt?	faunapedia/fish/King Salmon.png	{9}	Ganztägig	2026-03-24 10:07:32.530155+00
119	fish	Koi-Karpfen	4000	Ein Koi-Karpfen! War anstrengend, ich musste richtig koichen!	faunapedia/fish/Koi.png	{1,2,3,4,5,6,7,8,9,10,11,12}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
120	fish	Kugelfisch	5000	Ein Kugelfisch! Jetzt bist DU der Dumme!	faunapedia/fish/Puffer Fish.png	{11,12,1,2}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
121	fish	Lachs	700	Ein Lachs! Da war er wohl zu lax!	faunapedia/fish/Salmon.png	{9}	Ganztägig	2026-03-24 10:07:32.530155+00
122	fish	Lachssalmler	2500	Ein Lachssalmler! Ein echter Lachsschlager!	faunapedia/fish/Dorado.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
123	fish	Makrele	150	Eine Makrele! Makrel-i-o!	faunapedia/fish/Horse Mackerel.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
124	fish	Marlin	10000	Ein Marlin! Ein Fisch wie aus dem Bilderbuch!	faunapedia/fish/Blue Marlin.png	{11,12,1,2,3,4,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
125	fish	Masulachs	1000	Ein Masulachs! Das ist ja kaum masuzuhalten!	faunapedia/fish/Cherry Salmon.png	{3,4,5,9,10,11}	Variiert	2026-03-24 10:07:32.530155+00
126	fish	Mondfisch	4000	Ein Mondfisch! Ich hoffe, er scheint mir heim!	faunapedia/fish/Ocean Sunfish.png	{7,8,9}	04:00 – 21:00	2026-03-24 10:07:32.530155+00
127	fish	Muräne	2000	Eine Muräne! Du hast wohl eine saure Miene?	faunapedia/fish/Moray Eel.png	{8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
128	fish	Napoleonfisch	10000	Ein Napoleonfisch! Ein kaiserlicher Brocken!	faunapedia/fish/Napoleonfish.png	{7,8}	04:00 – 21:00	2026-03-24 10:07:32.530155+00
129	fish	Nasenmuräne	600	Eine Nasenmuräne! Kannst du damit auch riechen?	faunapedia/fish/Ribbon Eel.png	{8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
130	fish	Neonsalmler	500	Ein Neonsalmler! Ein leuchtendes Beispiel für schlechte Tarnung!	faunapedia/fish/Neon Tetra.png	{4,5,6,7,8,9,10,11}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
131	fish	Paletten-Doktorfisch	1000	Ein Paletten-Doktorfisch! Ich habe den Doktorgrad in Fischfang!	faunapedia/fish/Surgeonfish.png	{4,5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
132	fish	Piranha	2500	Ein Piranha! Das hat doch Biss!	faunapedia/fish/Piranha.png	{6,7,8,9}	09:00 – 16:00 & 21:00 – 04:00	2026-03-24 10:07:32.530155+00
133	fish	Quastenflosser	15000	Heiliges Fischstäbchen! Ein Quastenflosser!	faunapedia/fish/Coelacanth.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
134	fish	Ranchu	4500	Ein Ranchu! Kommst du von der Ranch, du?	faunapedia/fish/Ranchu Goldfish.png	{1,2,3,4,5,6,7,8,9,10,11,12}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
135	fish	Regenbogenfisch	800	Ein Regenbogenfisch! Welch zierliche Schönheit.	faunapedia/fish/Rainbowfish.png	{5,6,7,8,9,10}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
136	fish	Riemenfisch	9000	Ein Riemenfisch! Der ist wirklich riemlich groß…	faunapedia/fish/Oarfish.png	{12,1,2,3,4,5}	Ganztägig	2026-03-24 10:07:32.530155+00
137	fish	Rochen	3000	Ein Rochen! Ich hoffe, du bist nicht gerochen!	faunapedia/fish/Ray.png	{8,9,10,11}	04:00 – 21:00	2026-03-24 10:07:32.530155+00
138	fish	Rotfeuerfisch	500	Ein Rotfeuerfisch! Dein Anblick befeuert meine Begeisterung!	faunapedia/fish/Zebra Turkeyfish.png	{4,5,6,7,8,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
139	fish	Sägehai	12000	Ein Sägehai! Der hat aber eine spitze Nase!	faunapedia/fish/Saw Shark.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
140	fish	Saibling	3800	Ein Saibling! Da hat dir alles Saiblrasseln nichts genützt!	faunapedia/fish/Char.png	{3,4,5,9,10,11}	Variiert	2026-03-24 10:07:32.530155+00
141	fish	Sardelle	200	Eine Sardelle! Ein kleiner Fisch mit großem Geschmack!	faunapedia/fish/Anchovy.png	{1,2,3,4,5,6,7,8,9,10,11,12}	04:00 – 21:00	2026-03-24 10:07:32.530155+00
142	fish	Saugbarbe	1500	Eine Saugbarbe! So eine Saugbarbarei!	faunapedia/fish/Nibble Fish.png	{5,6,7,8,9}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
143	fish	Schiffshalter	1500	Ein Schiffshalter! Jetzt brauche ich nur noch ein Boot!	faunapedia/fish/Suckerfish.png	{6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
144	fish	Schnabelbarsch	5000	Ein Schnabelbarsch! Ganz schön vorlaut für einen Fisch!	faunapedia/fish/Barred Knifejaw.png	{3,4,5,6,7,8,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
145	fish	Schnappschildkröte	5000	Eine Schnappschildkröte! Ob sie eingeschnappt ist?	faunapedia/fish/Snapping Turtle.png	{4,5,6,7,8,9,10}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
146	fish	Schlangenkopf	5500	Ein Schlangenkopf! Das ist nichts Halbes und nichts Ganzes…	faunapedia/fish/Giant Snakehead.png	{6,7,8}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
147	fish	Seebarsch	400	Ein Seebarsch! Nicht schon wieder ein Seebarsch!	faunapedia/fish/Sea Bass.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
148	fish	See-Engel	1000	Ein See-Engel! Ein himmlischer Fang!	faunapedia/fish/Sea Butterfly.png	{12,1,2,3}	Ganztägig	2026-03-24 10:07:32.530155+00
149	fish	Seepferdchen	1100	Ein Seepferdchen! Galoppiert es jetzt in meinen Kescher?	faunapedia/fish/Sea Horse.png	{4,5,6,7,8,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
150	fish	Skalar	3000	Ein Skalar! Alles kalar!	faunapedia/fish/Angelfish.png	{5,6,7,8,9,10}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
151	fish	Sonnenbarsch	180	Ein Sonnenbarsch! Wie kann man bei Sonne barsch sein?	faunapedia/fish/Bluegill.png	{1,2,3,4,5,6,7,8,9,10,11,12}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
152	fish	Stachelmakrele	4500	Eine Stachelmakrele! Ganz schön stachelig!	faunapedia/fish/Giant Trevally.png	{5,6,7,8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
153	fish	Stint	400	Ein Stint! Jetzt sitzt du in der Stinte!	faunapedia/fish/Pond Smelt.png	{12,1,2}	Ganztägig	2026-03-24 10:07:32.530155+00
154	fish	Stör	10000	Ein Stör! Ich hoffe, ich habe dich nicht gestört!	faunapedia/fish/Sturgeon.png	{9,10,11,12,1,2,3}	Ganztägig	2026-03-24 10:07:32.530155+00
155	fish	Teleskopauge	1300	Ein Teleskopauge! Eigentlich hättest du mich kommen sehen müssen.	faunapedia/fish/Pop-Eyed Goldfish.png	{1,2,3,4,5,6,7,8,9,10,11,12}	09:00 – 16:00	2026-03-24 10:07:32.530155+00
156	fish	Thunfisch	7000	Ein Thunfisch! Was willst du tun, Fisch?	faunapedia/fish/Tuna.png	{11,12,1,2,3,4}	Ganztägig	2026-03-24 10:07:32.530155+00
157	fish	Tilapia	800	Ein Tilapia! Du glitzerst wie ein Tilapislazuli!	faunapedia/fish/Tilapia.png	{6,7,8,9,10}	Ganztägig	2026-03-24 10:07:32.530155+00
158	fish	Walhai	13000	Ein Walhai! Ein Riese der Meere!	faunapedia/fish/Whale Shark.png	{6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
159	fish	Weichschildkröte	3750	Eine Weichschildkröte! Weiche Schale, harter Kern?	faunapedia/fish/Soft-Shelled Turtle.png	{8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
160	fish	Wollhandkrabbe	2000	Eine Wollhandkrabbe! Hat die noch niemand fertig gestrickt?	faunapedia/fish/Mitten Crab.png	{9,10,11}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
161	sea	Auster	1100	Eine Auster! Sehr erfreut, Euer Austerität!	faunapedia/sea_creatures/Oyster.png	{9,10,11,12,1,2}	Ganztägig	2026-03-24 10:07:32.530155+00
162	sea	Babylon-Seeschnecke	1000	Eine Babylon-Seeschnecke! Na, baust du mir einen Turm?	faunapedia/sea_creatures/Whelk.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
163	sea	Botan-Garnele	1400	Eine Botan-Garnele! Was genau bot die denn an?	faunapedia/sea_creatures/Sweet Shrimp.png	{9,10,11,12,1,2}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
164	sea	Fangschreckenkrebs	2500	Ein Fangschreckenkrebs! Oh Schreck, was für ein Fang!	faunapedia/sea_creatures/Mantis Shrimp.png	{1,2,3,4,5,6,7,8,9,10,11,12}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
165	sea	Gazami-Krabbe	2200	Eine Gazami-Krabbe! Gibt's auch 'ne Salami-Krabbe?	faunapedia/sea_creatures/Gazami Crab.png	{6,7,8,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
166	sea	Gießkannenschwamm	5000	Ein Gießkannenschwamm! Wie praktisch, gleich zwei Funktionen auf einmal!	faunapedia/sea_creatures/Venus' Flower Basket.png	{10,11,12,1,2}	Ganztägig	2026-03-24 10:07:32.530155+00
167	sea	Gigas-Riesenmuschel	15000	Eine Gigas-Riesenmuschel! Kann da bitte auch eine Gigas-Riesenperle drin sein?	faunapedia/sea_creatures/Gigas Giant Clam.png	{5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
168	sea	Griffelseeigel	2000	Ein Griffelseeigel! Dich wollt ich immer schon in die Griffel bekommen!	faunapedia/sea_creatures/Slate Pencil Urchin.png	{5,6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
169	sea	Hummer	4500	Ein Hummer! Mir wird ganz hummrig!	faunapedia/sea_creatures/Lobster.png	{4,5,6,12,1}	Ganztägig	2026-03-24 10:07:32.530155+00
170	sea	Kammmuschel	1200	Eine Kammmuschel! Die Friseurin der Unterwasserwelt!	faunapedia/sea_creatures/Scallop.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
171	sea	Königskrabbe	8000	Eine Königskrabbe! Da hab ich wohl einen Meernarchen gefangen!	faunapedia/sea_creatures/Red King Crab.png	{11,12,1,2,3}	Ganztägig	2026-03-24 10:07:32.530155+00
172	sea	Kriechsprossalge	900	Eine Kriechsprossalge! Hab ich dich gekricht!	faunapedia/sea_creatures/Sea Grapes.png	{6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
173	sea	Kuruma-Garnele	3000	Eine Kuruma-Garnele! Kuruma her, Garnele!	faunapedia/sea_creatures/Tiger Prawn.png	{6,7,8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
174	sea	Languste	5000	Eine Languste! Innen weich, außen Kruste!	faunapedia/sea_creatures/Spiny Lobster.png	{10,11,12}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
175	sea	Leuchtkalmar	1400	Ein Leuchtkalmar! Das nenn ich mal ein leuchtendes Vorbild.	faunapedia/sea_creatures/Firefly Squid.png	{3,4,5,6}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
176	sea	Meerstrudelwurm	700	Ein Meerstrudelwurm! Mehr Strudel? Der Gedanke gefällt mir!	faunapedia/sea_creatures/Flatworm.png	{8,9}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
177	sea	Miesmuschel	1500	Eine Miesmuschel! Ist das eine entfernte Verwandte vom Miesepeter?	faunapedia/sea_creatures/Mussel.png	{6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
178	sea	Nacktkiemer	600	Ein Nacktkiemer! Er ist tatsächlich kiemlich nackt…	faunapedia/sea_creatures/Sea Slug.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
179	sea	Ohrenqualle	600	Eine Ohrenqualle! Endlich jemand, der mir zuhört.	faunapedia/sea_creatures/Moon Jellyfish.png	{7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
180	sea	Oktopus	1200	Ein Oktopus! Du hättest besser achtgeben sollen…	faunapedia/sea_creatures/Octopus.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
181	sea	Pazifik-Taschenkrebs	1900	Ein Pazifik-Taschenkrebs! Den hab ich in der Tasche!	faunapedia/sea_creatures/Dungeness Crab.png	{11,12,1,2,3,4,5}	Ganztägig	2026-03-24 10:07:32.530155+00
182	sea	Perlboot	1800	Ein Perlboot! Hab dich ausgebootet!	faunapedia/sea_creatures/Chambered Nautilus.png	{3,4,5,9,10,11}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
183	sea	Perlmuschel	2800	Eine Perlmuschel! Einfach perl-fekt!	faunapedia/sea_creatures/Pearl Oyster.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
184	sea	Pfeilschwanzkrebs	2500	Ein Pfeilschwanzkrebs! Wenn du dich von mir fangen lässt, hast du den Bogen nicht ganz raus…	faunapedia/sea_creatures/Horseshoe Crab.png	{7,8,9}	21:00 – 04:00	2026-03-24 10:07:32.530155+00
185	sea	Regenschirm-Oktopus	6000	Ein Regenschirm-Oktopus! Zu spät, bin schon klitschnass!	faunapedia/sea_creatures/Umbrella Octopus.png	{3,4,5,9,10,11}	Ganztägig	2026-03-24 10:07:32.530155+00
186	sea	Riesenassel	12000	WAAAH! Eine Riesenassel! Da bin ich eindeutig zu tief getaucht…	faunapedia/sea_creatures/Giant Isopod.png	{7,8,9,10}	09:00 – 16:00 & 21:00 – 04:00	2026-03-24 10:07:32.530155+00
187	sea	Riesenkrabbe	12000	Eine Riesenkrabbe! So ein Riesenkrabbler!	faunapedia/sea_creatures/Spider Crab.png	{3,4}	Ganztägig	2026-03-24 10:07:32.530155+00
188	sea	Röhrenaal	1100	Ein Röhrenaal! Na röhr mal!	faunapedia/sea_creatures/Spotted Garden Eel.png	{5,6,7,8,9,10}	04:00 – 21:00	2026-03-24 10:07:32.530155+00
189	sea	Schneekrabbe	6000	Eine Schneekrabbe! Ich glaube, ich nenn dich „Schneezwickchen“.	faunapedia/sea_creatures/Snow Crab.png	{11,12,1,2,3,4}	Ganztägig	2026-03-24 10:07:32.530155+00
190	sea	Scotoplanes	10000	Ein Scotoplanes! Wer ist Scoto, und wieso soll er etwas planen?	faunapedia/sea_creatures/Sea Pig.png	{11,12,1,2}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
191	sea	Seeananas	1500	Eine Seeananas! Zählt die zu den Meeresfrüchten?	faunapedia/sea_creatures/Sea Pineapple.png	{4,5,6,7,8}	Ganztägig	2026-03-24 10:07:32.530155+00
192	sea	Seeanemone	500	Eine Seeanemone! Funde wie dieser anemonieren mich zum Tauchen!	faunapedia/sea_creatures/Sea Anemone.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
193	sea	Seegurke	500	Eine Seegurke! Sei willkommen in meiner Truppe, Gurke!	faunapedia/sea_creatures/Sea Cucumber.png	{11,12,1,2,3,4}	Ganztägig	2026-03-24 10:07:32.530155+00
194	sea	Seeigel	1700	Ein Seeigel! Meister der Überraschungsakupunktur!	faunapedia/sea_creatures/Sea Urchin.png	{5,6,7,8,9}	Ganztägig	2026-03-24 10:07:32.530155+00
195	sea	Seeohr	2000	Ein Seeohr! Gibt's auch ein Hörauge?	faunapedia/sea_creatures/Abalone.png	{6,7,8,9,10,11,12,1}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
196	sea	Seepocke	600	Eine Seepocke! Die hat zu hoch gepokert!	faunapedia/sea_creatures/Acorn Barnacle.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
197	sea	Seestern	500	Ein Seestern! Ich seh Sternchen!	faunapedia/sea_creatures/Sea Star.png	{1,2,3,4,5,6,7,8,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
198	sea	Turbanschnecke	1000	Eine Turbanschnecke! Ich hab mich von ihr nicht einwickeln lassen!	faunapedia/sea_creatures/Turban Shell.png	{3,4,5,9,10,11,12}	Ganztägig	2026-03-24 10:07:32.530155+00
199	sea	Vampirtintenfisch	10000	Ein Vampirtintenfisch! Den hab ich mir ganz locker-pflockig geschnappt.	faunapedia/sea_creatures/Vampire Squid.png	{5,6,7,8}	16:00 – 09:00	2026-03-24 10:07:32.530155+00
200	sea	Wakame-Alge	600	Eine Wakame-Alge! Du hast dich wacker geschlagen!	faunapedia/sea_creatures/Seaweed.png	{10,11,12,1,2,3,4,5,6,7}	Ganztägig	2026-03-24 10:07:32.530155+00
\.


--
-- TOC entry 3926 (class 0 OID 33024)
-- Dependencies: 255
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, comment, origin) FROM stdin;
\.


--
-- TOC entry 3920 (class 0 OID 32962)
-- Dependencies: 249
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning) FROM stdin;
\.


--
-- TOC entry 3943 (class 0 OID 33339)
-- Dependencies: 272
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- TOC entry 3952 (class 0 OID 33548)
-- Dependencies: 281
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_extensions (folder, enabled, id, source, bundle) FROM stdin;
\.


--
-- TOC entry 3924 (class 0 OID 33001)
-- Dependencies: 253
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message) FROM stdin;
\.


--
-- TOC entry 3928 (class 0 OID 33048)
-- Dependencies: 257
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, uploaded_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y) FROM stdin;
\.


--
-- TOC entry 3948 (class 0 OID 33453)
-- Dependencies: 277
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
\.


--
-- TOC entry 3927 (class 0 OID 33038)
-- Dependencies: 256
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_folders (id, name, parent) FROM stdin;
\.


--
-- TOC entry 3942 (class 0 OID 33212)
-- Dependencies: 271
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2026-05-13 17:05:36.624733+00
20201029A	Remove System Relations	2026-05-13 17:05:36.628806+00
20201029B	Remove System Collections	2026-05-13 17:05:36.633174+00
20201029C	Remove System Fields	2026-05-13 17:05:36.641649+00
20201105A	Add Cascade System Relations	2026-05-13 17:05:36.663671+00
20201105B	Change Webhook URL Type	2026-05-13 17:05:36.670152+00
20210225A	Add Relations Sort Field	2026-05-13 17:05:36.674579+00
20210304A	Remove Locked Fields	2026-05-13 17:05:36.676672+00
20210312A	Webhooks Collections Text	2026-05-13 17:05:36.679991+00
20210331A	Add Refresh Interval	2026-05-13 17:05:36.68154+00
20210415A	Make Filesize Nullable	2026-05-13 17:05:36.685516+00
20210416A	Add Collections Accountability	2026-05-13 17:05:36.688134+00
20210422A	Remove Files Interface	2026-05-13 17:05:36.689616+00
20210506A	Rename Interfaces	2026-05-13 17:05:36.708018+00
20210510A	Restructure Relations	2026-05-13 17:05:36.720503+00
20210518A	Add Foreign Key Constraints	2026-05-13 17:05:36.728106+00
20210519A	Add System Fk Triggers	2026-05-13 17:05:36.742888+00
20210521A	Add Collections Icon Color	2026-05-13 17:05:36.744649+00
20210525A	Add Insights	2026-05-13 17:05:36.75433+00
20210608A	Add Deep Clone Config	2026-05-13 17:05:36.756031+00
20210626A	Change Filesize Bigint	2026-05-13 17:05:36.761956+00
20210716A	Add Conditions to Fields	2026-05-13 17:05:36.763735+00
20210721A	Add Default Folder	2026-05-13 17:05:36.766901+00
20210802A	Replace Groups	2026-05-13 17:05:36.769857+00
20210803A	Add Required to Fields	2026-05-13 17:05:36.771374+00
20210805A	Update Groups	2026-05-13 17:05:36.773742+00
20210805B	Change Image Metadata Structure	2026-05-13 17:05:36.777224+00
20210811A	Add Geometry Config	2026-05-13 17:05:36.779774+00
20210831A	Remove Limit Column	2026-05-13 17:05:36.781791+00
20210903A	Add Auth Provider	2026-05-13 17:05:36.790527+00
20210907A	Webhooks Collections Not Null	2026-05-13 17:05:36.793889+00
20210910A	Move Module Setup	2026-05-13 17:05:36.795879+00
20210920A	Webhooks URL Not Null	2026-05-13 17:05:36.799204+00
20210924A	Add Collection Organization	2026-05-13 17:05:36.801932+00
20210927A	Replace Fields Group	2026-05-13 17:05:36.806163+00
20210927B	Replace M2M Interface	2026-05-13 17:05:36.807602+00
20210929A	Rename Login Action	2026-05-13 17:05:36.808975+00
20211007A	Update Presets	2026-05-13 17:05:36.812271+00
20211009A	Add Auth Data	2026-05-13 17:05:36.813802+00
20211016A	Add Webhook Headers	2026-05-13 17:05:36.815374+00
20211103A	Set Unique to User Token	2026-05-13 17:05:36.817616+00
20211103B	Update Special Geometry	2026-05-13 17:05:36.819575+00
20211104A	Remove Collections Listing	2026-05-13 17:05:36.820914+00
20211118A	Add Notifications	2026-05-13 17:05:36.827548+00
20211211A	Add Shares	2026-05-13 17:05:36.835112+00
20211230A	Add Project Descriptor	2026-05-13 17:05:36.836628+00
20220303A	Remove Default Project Color	2026-05-13 17:05:36.84095+00
20220308A	Add Bookmark Icon and Color	2026-05-13 17:05:36.842666+00
20220314A	Add Translation Strings	2026-05-13 17:05:36.844111+00
20220322A	Rename Field Typecast Flags	2026-05-13 17:05:36.846742+00
20220323A	Add Field Validation	2026-05-13 17:05:36.848504+00
20220325A	Fix Typecast Flags	2026-05-13 17:05:36.851038+00
20220325B	Add Default Language	2026-05-13 17:05:36.85542+00
20220402A	Remove Default Value Panel Icon	2026-05-13 17:05:36.858568+00
20220429A	Add Flows	2026-05-13 17:05:36.872213+00
20220429B	Add Color to Insights Icon	2026-05-13 17:05:36.873884+00
20220429C	Drop Non Null From IP of Activity	2026-05-13 17:05:36.875369+00
20220429D	Drop Non Null From Sender of Notifications	2026-05-13 17:05:36.876801+00
20220614A	Rename Hook Trigger to Event	2026-05-13 17:05:36.878281+00
20220801A	Update Notifications Timestamp Column	2026-05-13 17:05:36.882556+00
20220802A	Add Custom Aspect Ratios	2026-05-13 17:05:36.884227+00
20220826A	Add Origin to Accountability	2026-05-13 17:05:36.886292+00
20230401A	Update Material Icons	2026-05-13 17:05:36.890404+00
20230525A	Add Preview Settings	2026-05-13 17:05:36.891834+00
20230526A	Migrate Translation Strings	2026-05-13 17:05:36.896789+00
20230721A	Require Shares Fields	2026-05-13 17:05:36.899755+00
20230823A	Add Content Versioning	2026-05-13 17:05:36.906637+00
20230927A	Themes	2026-05-13 17:05:36.913989+00
20231009A	Update CSV Fields to Text	2026-05-13 17:05:36.916451+00
20231009B	Update Panel Options	2026-05-13 17:05:36.91817+00
20231010A	Add Extensions	2026-05-13 17:05:36.920846+00
20231215A	Add Focalpoints	2026-05-13 17:05:36.922339+00
20240204A	Marketplace	2026-05-13 17:05:36.93054+00
\.


--
-- TOC entry 3946 (class 0 OID 33399)
-- Dependencies: 275
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- TOC entry 3949 (class 0 OID 33470)
-- Dependencies: 278
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
\.


--
-- TOC entry 3944 (class 0 OID 33353)
-- Dependencies: 273
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- TOC entry 3930 (class 0 OID 33074)
-- Dependencies: 259
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_permissions (id, role, collection, action, permissions, validation, presets, fields) FROM stdin;
\.


--
-- TOC entry 3932 (class 0 OID 33093)
-- Dependencies: 261
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
\.


--
-- TOC entry 3934 (class 0 OID 33118)
-- Dependencies: 263
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
\.


--
-- TOC entry 3936 (class 0 OID 33137)
-- Dependencies: 265
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
\.


--
-- TOC entry 3921 (class 0 OID 32972)
-- Dependencies: 250
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_roles (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
\.


--
-- TOC entry 3937 (class 0 OID 33160)
-- Dependencies: 266
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin) FROM stdin;
\.


--
-- TOC entry 3939 (class 0 OID 33173)
-- Dependencies: 268
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides) FROM stdin;
\.


--
-- TOC entry 3947 (class 0 OID 33419)
-- Dependencies: 276
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- TOC entry 3950 (class 0 OID 33504)
-- Dependencies: 279
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- TOC entry 3922 (class 0 OID 32983)
-- Dependencies: 251
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides) FROM stdin;
\.


--
-- TOC entry 3951 (class 0 OID 33511)
-- Dependencies: 280
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- TOC entry 3941 (class 0 OID 33201)
-- Dependencies: 270
-- Data for Name: directus_webhooks; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.directus_webhooks (id, name, method, url, status, data, actions, collections, headers) FROM stdin;
\.


--
-- TOC entry 3899 (class 0 OID 16962)
-- Dependencies: 228
-- Data for Name: diy_recipes; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.diy_recipes (id, event_id, category, name, materials_desc, durability, is_customizable, source, sell_price, image_path, created_at) FROM stdin;
1	\N	Werkzeuge	Wackelaxt	5x Ast, 1x Stein	40	f	Tom Nook / Nooks Laden	200	diy/tools/64px-Flimsy_Axe_NH_Icon.png	2026-03-23 14:57:23.373666+00
2	\N	Werkzeuge	Steinaxt	1x Wackelaxt, 3x Holz	100	f	Alltagswerkzeuge A–Z	560	diy/tools/64px-Stone_Axe_NH_Icon.png	2026-03-23 14:57:23.373666+00
3	\N	Werkzeuge	Axt	1x Wackelaxt, 3x Holz, 1x Eisenerz	100	f	Alltagswerkzeuge A–Z	625	diy/tools/64px-Axe_NH_Icon.png	2026-03-23 14:57:23.373666+00
4	\N	Werkzeuge	Goldaxt	1x Axt, 1x Golderz	200	f	100 Äxte zerbrechen	10.655	diy/tools/64px-Golden_Axe_NH_Icon.png	2026-03-23 14:57:23.373666+00
5	\N	Werkzeuge	Wackelschaufel	5x Hartholz	40	f	Eugen / Nooks Laden	200	diy/tools/64px-Flimsy_Shovel_NH_Icon.png	2026-03-23 14:57:23.373666+00
6	\N	Werkzeuge	Schaufel	1x Wackelschaufel, 1x Eisenerz	100	t	Alltagswerkzeuge A–Z	600	diy/tools/64px-Shovel_(Red)_NH_Icon.png	2026-03-23 14:57:23.373666+00
7	\N	Werkzeuge	Goldschaufel	1x Schaufel, 1x Golderz	200	f	Gulliver 30 Mal helfen	10.675	diy/tools/64px-Golden_Shovel_NH_Icon.png	2026-03-23 14:57:23.373666+00
8	\N	Werkzeuge	Wackelangel	5x Ast	10	f	Tom Nook (Bastelkurs)	100	diy/tools/64px-Flimsy_Fishing_Rod_NH_Icon.png	2026-03-23 14:57:23.373666+00
9	\N	Werkzeuge	Angel	1x Wackelangel, 1x Eisenerz	30	t	Alltagswerkzeuge A–Z	600	diy/tools/64px-Fishing_Rod_(Blue)_NH_Icon.png	2026-03-23 14:57:23.373666+00
10	\N	Werkzeuge	Goldangel	1x Angel, 1x Golderz	90	f	Faunapädie (Fische) voll	10.400	diy/tools/64px-Golden_Rod_NH_Icon.png	2026-03-23 14:57:23.373666+00
11	\N	Werkzeuge	Wackelkescher	5x Ast	10	f	Tom Nook (Bastelkurs)	100	diy/tools/64px-Flimsy_Net_NH_Icon.png	2026-03-23 14:57:23.373666+00
12	\N	Werkzeuge	Kescher	1x Wackelkescher, 1x Eisenerz	30	t	Alltagswerkzeuge A–Z	600	diy/tools/64px-Net_(Red)_NH_Icon.png	2026-03-23 14:57:23.373666+00
13	\N	Werkzeuge	Goldkescher	1x Kescher, 1x Golderz	90	f	Faunapädie (Insekten) voll	10.400	diy/tools/64px-Golden_Net_NH_Icon.png	2026-03-23 14:57:23.373666+00
14	\N	Werkzeuge	Wackelgießkanne	5x Weichholz	20	f	Tom Nook / Nooks Laden	200	diy/tools/64px-Flimsy_Watering_Can_NH_Icon.png	2026-03-23 14:57:23.373666+00
15	\N	Werkzeuge	Gießkanne	1x Wackelgießkanne, 1x Eisenerz	60	t	Alltagswerkzeuge A–Z	600	diy/tools/64px-Watering_Can_(Blue)_NH_Icon.png	2026-03-23 14:57:23.373666+00
16	\N	Werkzeuge	Goldkanne	1x Gießkanne, 1x Golderz	180	f	5-Sterne-Insel (Melinda)	10.675	diy/tools/64px-Golden_Watering_Can_NH_Icon.png	2026-03-23 14:57:23.373666+00
17	\N	Werkzeuge	Schleuder	5x Hartholz	20	t	Nooks Laden	225	diy/tools/64px-Slingshot_(Red)_NH_Icon.png	2026-03-23 14:57:23.373666+00
18	\N	Werkzeuge	Goldschleuder	1x Schleuder, 1x Golderz	60	f	300 Ballons abschießen	10.300	diy/tools/64px-Golden_Slingshot_NH_Icon.png	2026-03-23 14:57:23.373666+00
19	\N	Werkzeuge	Sprungstab	5x Weichholz	∞	f	Eugen / Nooks Laden	600	diy/tools/64px-Vaulting_Pole_NH_Icon.png	2026-03-23 14:57:23.373666+00
20	\N	Werkzeuge	Leiter	4x Holz, 4x Hartholz, 4x Weichholz	∞	f	Tom Nook (Hausbau)	1.440	diy/tools/64px-Ladder_NH_Icon.png	2026-03-23 14:57:23.373666+00
21	\N	Werkzeuge	Holzleiter-Bausatz	1x Leiter, 5x Holz	∞	t	Nooks Laden (Rezept-Paket)	1.500	diy/tools/64px-Wooden_Ladder_Set-Up_Kit_(Natural)_NH_Icon.png	2026-03-23 14:57:23.373666+00
22	\N	Werkzeuge	Eisenleiter-Bausatz	1x Leiter, 5x Eisenerz	∞	t	Von sportlichen Nachbarn	1.940	diy/tools/64px-Iron_Ladder_Set-Up_Kit_(Silver)_NH_Icon.png	2026-03-23 14:57:23.373666+00
23	\N	Werkzeuge	Rankenleiter-Bausatz	1x Leiter, 5x Ranke	∞	t	Flaschenpost (Käpten-Inseln / DLC)	1.465	diy/tools/64px-Vine_Ladder_Set-Up_Kit_(Light_Brown)_NH_Icon.png	2026-03-23 14:57:23.373666+00
24	\N	Werkzeuge	Goldleiter-Bausatz	1x Leiter, 1x Golderz	∞	t	Von hochnäsigen Nachbarn	11.440	diy/tools/64px-Golden_Ladder_Set-Up_Kit_NH_Icon.png	2026-03-23 14:57:23.373666+00
25	\N	Werkzeuge	Sternenstab	1x Riesensternensplitter, 3x Sternensplitter	∞	f	Eufemia	6.500	diy/tools/64px-Star_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
26	\N	Werkzeuge	Stab	2x Sternensplitter	∞	f	Eufemia	1.000	diy/tools/64px-Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
27	\N	Werkzeuge	Eisenstab	3x Eisenerz, 3x Sternensplitter	∞	f	Eufemia	3.750	diy/tools/64px-Iron_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
28	\N	Werkzeuge	Goldstab	2x Golderz, 3x Sternensplitter	∞	f	Eufemia	20.750	diy/tools/64px-Golden_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
29	\N	Werkzeuge	Zweigstab	5x Ast, 3x Sternensplitter	∞	f	Eufemia	1.550	diy/tools/64px-Tree-Branch_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
30	\N	Werkzeuge	Bambusstab	6x Frühlingsbambus, 3x Sternensplitter	∞	f	Frühling (Ballons)	3.900	diy/tools/64px-Bamboo_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
31	\N	Werkzeuge	Kirschblütenstab	3x Kirschblüte, 3x Sternensplitter	∞	f	Kirschblütenzeit (Ballons)	2.700	diy/tools/64px-Cherry-Blossom_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
32	\N	Werkzeuge	Muschelstab	3x Sommermuschel, 3x Sternensplitter	∞	f	Sommer (Ballons)	5.100	diy/tools/64px-Shell_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
33	\N	Werkzeuge	Pilzstab	3x Dürrpilz, 3x Sternensplitter	∞	f	Herbst (Ballons)	3.300	diy/tools/64px-Mushroom_Wand_(Ordinary_Mushroom)_NH_Icon.png	2026-03-23 14:57:23.373666+00
34	\N	Werkzeuge	Kürbisstab	1x Kürbislaterne, 3x Sternensplitter	∞	f	Halloween (von Jakob)	3.300	diy/tools/64px-Spooky_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
35	\N	Werkzeuge	Eisstab	1x Riesenschneeflocke, 3x Sternensplitter	∞	f	Winter (von Schnemil)	6.500	diy/tools/64px-Ice_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
36	\N	Werkzeuge	Häschentag-Stab	1x Steinaus-Ohs, 3x Sternensplitter	∞	f	Häschentag (von Ohs)	11.100	diy/tools/64px-Bunny_Day_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
37	\N	Werkzeuge	Hochzeitsstab	1x Hochzeits-Blumenständer, 3x Sternensplitter	∞	f	Hochzeitssaison (Juni)	3.500	diy/tools/64px-Wedding_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
38	\N	Werkzeuge	Kleeblattstab	3x Unkraut, 3x Sternensplitter	∞	f	Kleeblatttag (März)	1.530	diy/tools/64px-Shamrock_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
39	\N	Werkzeuge	Anemonenstab	1x Orangeanemone, 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Windflower_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
40	\N	Werkzeuge	Chrysanthemenstab	1x Gelbchrysantheme, 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Mums_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
41	\N	Werkzeuge	Cosmeastab	1x Weißcosmea, 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Cosmos_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
42	\N	Werkzeuge	Hyazinthenstab	1x Rosahyazinthe, 3x Sternensplitter	∞	f	Eufemia	1.660	diy/tools/64px-Hyacinth_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
43	\N	Werkzeuge	Lilienstab	1x Osterlilie, 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Lily_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
44	\N	Werkzeuge	Pansystab (Veilchen)	1x Hornveilchen, 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Pansy_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
45	\N	Werkzeuge	Rosenstab	1x Liebesrose (Rot), 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Rose_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
46	\N	Werkzeuge	Tulpenstab	1x Papageitulpe (Rot), 3x Sternensplitter	∞	f	Eufemia	1.580	diy/tools/64px-Tulip_Wand_NH_Icon.png	2026-03-23 14:57:23.373666+00
55	\N	Kleinkram	Schneidebrett	\N	\N	f	Nachbarn (Ausgeglichen)	990 Sternis	diy/Misc/Cutting board.png	2026-03-24 15:10:27.349517+00
58	\N	Kleinkram	Holz-Werkzeugkasten	\N	\N	f	Nachbarn (Ausgeglichen)	1.980 Sternis	diy/Misc/Wooden toolbox.png	2026-03-24 15:10:27.349517+00
60	\N	Kleinkram	Spendenbox	\N	\N	f	NookPortal	\N	diy/Misc/Donation box.png	2026-03-24 15:10:27.349517+00
62	\N	Kleinkram	Spielknete-Set	\N	\N	f	Nachbarn (Miesepeter)	400 Sternis	diy/Misc/Modeling clay.png	2026-03-24 15:10:27.349517+00
63	\N	Kleinkram	Keramikgeschirr	\N	\N	f	Nachbarn (Hochnäsig)	600 Sternis	diy/Misc/Unglazed dish set.png	2026-03-24 15:10:27.349517+00
64	\N	Kleinkram	Keramikkrug	\N	\N	f	Nachbarn (Hochnäsig) / Tom Nook	800 Sternis	diy/Misc/Classic pitcher.png	2026-03-24 15:10:27.349517+00
65	\N	Kleinkram	Topf	\N	\N	f	Nachbarn (Miesepeter) / Tom Nook	1.000 Sternis	diy/Misc/Pot.png	2026-03-24 15:10:27.349517+00
67	\N	Kleinkram	Pfanne	\N	\N	f	Nooks Laden	1.500 Sternis	diy/Misc/Frying pan.png	2026-03-24 15:10:27.349517+00
68	\N	Kleinkram	Kugelhantel	\N	\N	f	Nachbarn (Sportlich)	3.750 Sternis	diy/Misc/Kettlebell.png	2026-03-24 15:10:27.349517+00
69	\N	Kleinkram	Wok	\N	\N	f	Nachbarn (Hochnäsig)	\N	diy/Misc/Imperial pot.png	2026-03-24 15:10:27.349517+00
74	\N	Kleinkram	Mini-Gold-Daruma	\N	\N	f	Nachbarn (Miesepeter)	\N	diy/Misc/Mini golden dharma.png	2026-03-24 15:10:27.349517+00
76	\N	Kleinkram	Goldurne	1 Golderz, 1 Metallgefäß	\N	f	Nachbarn (Schwungvoll)	\N	diy/Misc/Golden urn.png	2026-03-24 15:10:27.349517+00
77	\N	Kleinkram	Goldschmuckteller	1 Golderz, 1 Schmuckteller	\N	f	Nachbarn (Miesepeter)	\N	diy/Misc/Golden decorative plate.png	2026-03-24 15:10:27.349517+00
78	\N	Kleinkram	Goldsparschwein	\N	\N	f	Nachbarn (Ausgeglichen)	\N	diy/Misc/Golden piggy bank.png	2026-03-24 15:10:27.349517+00
79	\N	Kleinkram	Goldhasen-Gartendeko	1 Golderz, 1 Hasen-Gartendeko	\N	f	Nachbarn (Ausgeglichen)	\N	diy/Misc/Golden garden bunny.png	2026-03-24 15:10:27.349517+00
83	\N	Kleinkram	Sukkulente	\N	\N	f	Leere Dose angeln	220 Sternis	diy/Misc/Succulent plant.png	2026-03-24 15:10:27.349517+00
84	\N	Kleinkram	Terrarium	\N	\N	f	Nachbarn (Ausgeglichen)	1.740 Sternis	diy/Misc/Terrarium.png	2026-03-24 15:10:27.349517+00
85	\N	Kleinkram	Rankenlampe	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Misc/Vine lamp.png	2026-03-24 15:10:27.349517+00
86	\N	Kleinkram	Leuchtmoos-Glas	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Misc/Glowing-moss jar.png	2026-03-24 15:10:27.349517+00
87	\N	Kleinkram	Kirschenlautsprecher	\N	\N	f	Nachbarn (Schwungvoll)	3.500 Sternis	diy/Misc/Cherry speakers.png	2026-03-24 15:10:27.349517+00
88	\N	Kleinkram	Überraschungspfirsich	\N	\N	f	Nachbarn (Ausgeglichen)	2.480 Sternis	diy/Misc/Peach surprise box.png	2026-03-24 15:10:27.349517+00
89	\N	Kleinkram	Kokosnusswasser	\N	\N	f	Nachbarn (Hochnäsig)	500 Sternis	diy/Misc/Coconut juice.png	2026-03-24 15:10:27.349517+00
91	\N	Kleinkram	Obst-Wasserspender	\N	\N	f	Nachbarn (Miesepeter)	3.000 Sternis	diy/Misc/Infused-water dispenser.png	2026-03-24 15:10:27.349517+00
94	\N	Kleinkram	Zeitschriftenablage	\N	\N	f	Nachbarn (Schwungvoll)	690 Sternis	diy/Misc/Magazine rack.png	2026-03-24 15:10:27.349517+00
95	\N	Kleinkram	Magazinsammlung	\N	\N	f	Nachbarn (Schwungvoll)	630 Sternis	diy/Misc/Stacked magazines.png	2026-03-24 15:10:27.349517+00
98	\N	Kleinkram	Schneidebrett mit Karpfen	\N	\N	f	Nachbarn (Schlafmütze)	\N	diy/Misc/Carp on a cutting board.png	2026-03-24 15:10:27.349517+00
100	\N	Kleinkram	Geldscheinpyramide	3x 99.000-Sterni-Sack	\N	f	Nachbarn (Hochnäsig)	\N	diy/Misc/Pile of cash.png	2026-03-24 15:10:27.349517+00
101	\N	Kleinkram	Lichtstern	\N	\N	f	Eufemia	2.500 Sternis	diy/Misc/Nova light.png	2026-03-24 15:10:27.349517+00
102	\N	Kleinkram	Sternuhr	\N	\N	f	Eufemia	2.250 Sternis	diy/Misc/Star clock.png	2026-03-24 15:10:27.349517+00
104	\N	Kleinkram	Skorpion-Lampe	\N	\N	f	Eufemia	22.125 Sternis	diy/Misc/Scorpio lamp.png	2026-03-24 15:10:27.349517+00
103	\N	Kleinkram	Balkenwaage	3 Sternensplitter, 2 Waage-Splitter, 2 Golderz	\N	f	Eufemia	21.750 Sternis	diy/Misc/Libra scale.png	2026-03-24 15:10:27.349517+00
105	\N	Kleinkram	Bambus-Kerzenhalter	3 Bambus, 2 Lehm	\N	f	Nachbarn (Hochnäsig)	880 Sternis	diy/Misc/Bamboo candleholder.png	2026-03-24 15:10:27.349517+00
106	\N	Kleinkram	Bambuskugel	3 Bambus	\N	f	Nachbarn (Ausgeglichen)	480 Sternis	diy/Misc/Bamboo sphere.png	2026-03-24 15:10:27.349517+00
93	\N	Kleinkram	Bücherstapel	5 Buch	\N	f	Nachbarn (Schlafmütze)	725 Sternis	diy/Misc/Stack of books.png	2026-03-24 15:10:27.349517+00
97	\N	Kleinkram	Daruma	3 Mini-Daruma	\N	f	Nachbarn (Miesepeter)	\N	diy/Misc/Dharma.png	2026-03-24 15:10:27.349517+00
56	\N	Kleinkram	Deko-Ente	4 Weichholz	\N	f	Nachbarn (Selbstzufrieden)	480 Sternis	diy/Misc/Decoy duck.png	2026-03-24 15:10:27.349517+00
111	\N	Kleinkram	Kirschblüten-Bonsai	\N	\N	f	Ballon (Kirschblüten)	3.300 Sternis	diy/Misc/Cherry-blossom bonsai.png	2026-03-24 15:10:27.349517+00
112	\N	Kleinkram	Muschellampe	\N	\N	f	Nachbarn (Große Schwester)	4.200 Sternis	diy/Misc/Shell lamp.png	2026-03-24 15:10:27.349517+00
113	\N	Kleinkram	Muschel-Lautsprecher	\N	\N	f	Nachbarn (Große Schwester)	5.700 Sternis	diy/Misc/Shell speaker.png	2026-03-24 15:10:27.349517+00
114	\N	Kleinkram	Muschel-Musikschatulle	\N	\N	f	Nachbarn (Schwungvoll)	\N	diy/Misc/Shell music box.png	2026-03-24 15:10:27.349517+00
118	\N	Kleinkram	Kiefern-Bonsai	\N	\N	f	Ballon (Baumfrucht)	4.200 Sternis	diy/Misc/Pine bonsai tree.png	2026-03-24 15:10:27.349517+00
119	\N	Kleinkram	Kürbislaterne	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/Misc/Spooky lantern.png	2026-03-24 15:10:27.349517+00
120	\N	Kleinkram	Kürbis-Süßigkeiten-Set	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/Misc/Spooky candy set.png	2026-03-24 15:10:27.349517+00
121	\N	Kleinkram	Kürbis-Tischgedeck	\N	\N	f	Nachbarn (Halloween)	\N	diy/Misc/Spooky table setting.png	2026-03-24 15:10:27.349517+00
122	\N	Kleinkram	Kürbis-Tricklampe	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/Misc/Spooky trick lamp.png	2026-03-24 15:10:27.349517+00
123	\N	Kleinkram	Schlemmfest-Bräter	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Misc/Turkey Day casserole.png	2026-03-24 15:10:27.349517+00
124	\N	Kleinkram	Schlemmfest-Tischgedeck	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Misc/Turkey Day table setting.png	2026-03-24 15:10:27.349517+00
125	\N	Kleinkram	Schlemmfest-Getreidedeko	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Misc/Turkey Day wheat decor.png	2026-03-24 15:10:27.349517+00
126	\N	Kleinkram	Schlemmfest-Dekoration	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Misc/Turkey Day decorations.png	2026-03-24 15:10:27.349517+00
127	\N	Kleinkram	Stieleis-Duo	\N	\N	f	Schnemil	5.400 Sternis	diy/Misc/Frozen-treat set.png	2026-03-24 15:10:27.349517+00
131	\N	Kleinkram	Tischtannenbaum	\N	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	930 Sternis	diy/Misc/Tabletop festive tree.png	2026-03-24 15:10:27.349517+00
134	\N	Kleinkram	Hyazinthenlampe	\N	\N	f	Nachbarn (Große Schwester)	3.000 Sternis	diy/Misc/Hyacinth lamp.png	2026-03-24 15:10:27.349517+00
136	\N	Kleinkram	Stehauf-Ohs	\N	\N	f	Ohs (Häschentag)	9.600 Sternis	diy/Misc/Wobbling Zipper toy.png	2026-03-24 15:10:27.349517+00
137	\N	Einrichtung	Lagerfeuer	\N	\N	f	Tom Nook (Bastelkurs)	30 Sternis	diy/Housewares/Campfire.png	2026-03-24 16:52:46.642355+00
138	\N	Einrichtung	Feuerstelle	1 Lagerfeuer, 10 Hartholz	\N	f	Nachbarn (Miesepeter), Tom Nook (2 Spenden)	1.230 Sternis	diy/Housewares/Bonfire.png	2026-03-24 16:52:46.642355+00
140	\N	Einrichtung	Simpel-Wäscheleine	\N	\N	f	Nachbarn (Miesepeter), Tom Nook (Drei Häuser)	100 Sternis	diy/Housewares/Clothesline.png	2026-03-24 16:52:46.642355+00
141	\N	Einrichtung	Vogelscheuche	\N	\N	f	Nachbarn (Miesepeter)	130 Sternis	diy/Housewares/Scarecrow.png	2026-03-24 16:52:46.642355+00
143	\N	Einrichtung	Mini-Werkbank	\N	\N	f	Ideen für Bastler aus Nooks Laden	2.580 Sternis	diy/Housewares/Mini DIY workbench.png	2026-03-24 16:52:46.642355+00
144	\N	Einrichtung	Werkbank	5 Holz, 5 Hartholz, 5 Weichholz, 3 Eisenerz, 1 Mini-Werkbank	\N	f	Nachbarn (Große Schwester)	6.630 Sternis	diy/Housewares/DIY workbench.png	2026-03-24 16:52:46.642355+00
146	\N	Einrichtung	Holzstuhl	\N	\N	f	Nachbarn (Hochnäsig), Tom Nook (Drei Häuser)	720 Sternis	diy/Housewares/Wooden chair.png	2026-03-24 16:52:46.642355+00
147	\N	Einrichtung	Holztischchen	\N	\N	f	Nachbarn (Große Schwester)	720 Sternis	diy/Housewares/Wooden mini table.png	2026-03-24 16:52:46.642355+00
149	\N	Einrichtung	Holzsofatisch	\N	\N	f	Nachbarn (Selbstzufrieden)	1.200 Sternis	diy/Housewares/Wooden low table.png	2026-03-24 16:52:46.642355+00
150	\N	Einrichtung	Holztisch	\N	\N	f	Nachbarn (Große Schwester)	1.800 Sternis	diy/Housewares/Wooden table.png	2026-03-24 16:52:46.642355+00
155	\N	Einrichtung	Holzspiegel	\N	\N	f	Nachbarn (Schwungvoll)	1.350 Sternis	diy/Housewares/Wooden full-length mirror.png	2026-03-24 16:52:46.642355+00
158	\N	Einrichtung	Lattentrennwand S	\N	\N	f	Nachbarn (Hochnäsig)	\N	diy/Housewares/Small wooden partition.png	2026-03-24 16:52:46.642355+00
159	\N	Einrichtung	Lattentrennwand M	\N	\N	f	Nachbarn (Hochnäsig)	\N	diy/Housewares/Medium wooden partition.png	2026-03-24 16:52:46.642355+00
162	\N	Einrichtung	Rohholzbank	\N	\N	f	Nachbarn (Sportlich)	960 Sternis	diy/Housewares/Wild log bench.png	2026-03-24 16:52:46.642355+00
167	\N	Einrichtung	Baumstammsofa	2 Baumstammsessel	\N	f	Nachbarn (Ausgeglichen)	1.920 Sternis	diy/Housewares/Log extra-long sofa.png	2026-03-24 16:52:46.642355+00
169	\N	Einrichtung	Baumstammregal	2 Baumstammbank, 3 Hartholz	\N	f	Nachbarn (Schwungvoll)	1.560 Sternis	diy/Housewares/Log decorative shelves.png	2026-03-24 16:52:46.642355+00
171	\N	Einrichtung	Bauklotzhocker	1 Bauklotzset, 2 Weichholz	\N	f	Nachbarn (Schwungvoll)	600 Sternis	diy/Housewares/Wooden-block stool.png	2026-03-24 16:52:46.642355+00
172	\N	Einrichtung	Bauklotzstuhl	1 Bauklotzset, 3 Weichholz	\N	f	Ideen für Bastler aus Nooks Laden	720 Sternis	diy/Housewares/Wooden-block chair.png	2026-03-24 16:52:46.642355+00
173	\N	Einrichtung	Bauklotzbank	1 Bauklotzset, 4 Weichholz	\N	f	Nachbarn (Große Schwester)	840 Sternis	diy/Housewares/Wooden-block bench.png	2026-03-24 16:52:46.642355+00
174	\N	Einrichtung	Bauklotztisch	1 Bauklotzset, 8 Weichholz	\N	f	Nachbarn (Große Schwester), Tom Nook (Drei Häuser)	1.320 Sternis	diy/Housewares/Wooden-block table.png	2026-03-24 16:52:46.642355+00
175	\N	Einrichtung	Bauklotzkommode	1 Bauklotzset, 12 Weichholz	\N	f	Nachbarn (Ausgeglichen)	1.800 Sternis	diy/Housewares/Wooden-block chest.png	2026-03-24 16:52:46.642355+00
176	\N	Einrichtung	Bauklotzbett	1 Bauklotzset, 17 Weichholz	\N	f	Nachbarn (Ausgeglichen)	2.400 Sternis	diy/Housewares/Wooden-block bed.png	2026-03-24 16:52:46.642355+00
177	\N	Einrichtung	Bauklotzbücherregal	1 Bauklotzset, 3 Weichholz	\N	f	Ideen für Bastler aus Nooks Laden	720 Sternis	diy/Housewares/Wooden-block bookshelf.png	2026-03-24 16:52:46.642355+00
178	\N	Einrichtung	Bauklotzanlage	1 Bauklotzset, 5 Weichholz, 2 Eisenerz	\N	f	Ideen für Bastler aus Nooks Laden, Tom Nook (Drei Häuser)	2.460 Sternis	diy/Housewares/Wooden-block stereo.png	2026-03-24 16:52:46.642355+00
179	\N	Einrichtung	Holzwaschtisch	\N	\N	f	Bist du der Bastelboss? aus Nooks Laden	2.270 Sternis	diy/Housewares/Plain sink.png	2026-03-24 16:52:46.642355+00
184	\N	Einrichtung	Schaukelstuhl	\N	\N	f	Ideen für Bastler aus Nooks Laden	960 Sternis	diy/Housewares/Rocking chair.png	2026-03-24 16:52:46.642355+00
185	\N	Einrichtung	Schwingschaukel	\N	\N	f	Ideen für Bastler aus Nooks Laden, Tom Nook (Drei Häuser)	1.440 Sternis	diy/Housewares/Swinging bench.png	2026-03-24 16:52:46.642355+00
186	\N	Einrichtung	Pappgras	\N	\N	f	Nachbarn (Ausgeglichen)	480 Sternis	diy/Housewares/Grass standee.png	2026-03-24 16:52:46.642355+00
187	\N	Einrichtung	Pappbusch	\N	\N	f	Nachbarn (Ausgeglichen)	600 Sternis	diy/Housewares/Hedge standee.png	2026-03-24 16:52:46.642355+00
188	\N	Einrichtung	Papphügel	\N	\N	f	Nachbarn (Sportlich)	1.080 Sternis	diy/Housewares/Mountain standee.png	2026-03-24 16:52:46.642355+00
189	\N	Einrichtung	Pappbaum	\N	\N	f	Nachbarn (Sportlich)	1.560 Sternis	diy/Housewares/Tree standee.png	2026-03-24 16:52:46.642355+00
190	\N	Einrichtung	Teetischchen	\N	\N	f	Nachbarn (Miesepeter)	1.440 Sternis	diy/Housewares/Tea table.png	2026-03-24 16:52:46.642355+00
191	\N	Einrichtung	Pokalvitrine	\N	\N	f	Nachbarn (Sportlich)	33.690 Sternis	diy/Housewares/Trophy case.png	2026-03-24 16:52:46.642355+00
192	\N	Einrichtung	Spielwagen	\N	\N	f	Nachbarn (Schlafmütze)	960 Sternis	diy/Housewares/Clackercart.png	2026-03-24 16:52:46.642355+00
193	\N	Einrichtung	Schaukelpferd	\N	\N	f	Nachbarn (Ausgeglichen)	600 Sternis	diy/Housewares/Rocking horse.png	2026-03-24 16:52:46.642355+00
194	\N	Einrichtung	Vogelkäfig	\N	\N	f	Nachbarn (Große Schwester)	960 Sternis	diy/Housewares/Birdcage.png	2026-03-24 16:52:46.642355+00
195	\N	Einrichtung	Notenständer	\N	\N	f	Nachbarn (Schlafmütze)	960 Sternis	diy/Housewares/Music stand.png	2026-03-24 16:52:46.642355+00
198	\N	Einrichtung	Projekttisch	\N	\N	f	Nachbarn (Hochnäsig)	\N	diy/Housewares/Project table.png	2026-03-24 16:52:46.642355+00
199	\N	Einrichtung	Spannstangenregal	\N	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Tension-pole rack.png	2026-03-24 16:52:46.642355+00
200	\N	Einrichtung	Hundehütte	\N	\N	f	Nachbarn (Sportlich)	2.040 Sternis	diy/Housewares/Doghouse.png	2026-03-24 16:52:46.642355+00
203	\N	Einrichtung	Vogelhaus	\N	\N	f	Nachbarn (Schwungvoll), Tom Nook (2 Spenden)	840 Sternis	diy/Housewares/Birdhouse.png	2026-03-24 16:52:46.642355+00
204	\N	Einrichtung	Blumen-Bollerwagen	3 Weißhyazinthe, 3 Rotcosmea, 3 Bernsteinrose, 8 Holz, 2 Eisenerz	\N	f	Nachbarn (Schwungvoll)	3.180 Sternis	diy/Housewares/Garden wagon.png	2026-03-24 16:52:46.642355+00
205	\N	Einrichtung	Bonsai-Tisch	1 Kirschblüten-Bonsai, 1 Kiefern-Bonsai, 8 Holz	\N	f	Nachbarn (Miesepeter)	8.460 Sternis	diy/Housewares/Bonsai shelf.png	2026-03-24 16:52:46.642355+00
206	\N	Einrichtung	Verkaufsstand	\N	\N	f	NookPortal	1.440 Sternis	diy/Housewares/Stall.png	2026-03-24 16:52:46.642355+00
207	\N	Einrichtung	Wegweiser	\N	\N	f	Nachbarn (Schlafmütze)	600 Sternis	diy/Housewares/Signpost.png	2026-03-24 16:52:46.642355+00
313	\N	Einrichtung	Landefähre	\N	\N	f	Eufemia	16.250 Sternis	diy/Housewares/Lunar lander.png	2026-03-24 16:52:46.642355+00
209	\N	Einrichtung	Weltwegweiser	\N	\N	f	NookPortal	1.440 Sternis	diy/Housewares/Destinations signpost.png	2026-03-24 16:52:46.642355+00
210	\N	Einrichtung	Schlitten	\N	\N	f	Nachbarn (Miesepeter)	960 Sternis	diy/Housewares/Sleigh.png	2026-03-24 16:52:46.642355+00
212	\N	Einrichtung	Werbebande	\N	\N	f	Nachbarn (Sportlich)	\N	diy/Housewares/Wooden field sign.png	2026-03-24 16:52:46.642355+00
215	\N	Einrichtung	Reifenspielgerät	\N	\N	f	Alter Reifen angeln	20 Sternis	diy/Housewares/Tire toy.png	2026-03-24 16:52:46.642355+00
216	\N	Einrichtung	Reifenstapel	\N	\N	f	3 mal Alter Reifen angeln	60 Sternis	diy/Housewares/Tire stack.png	2026-03-24 16:52:46.642355+00
217	\N	Einrichtung	Müllsack-Set	\N	\N	f	15 mal Müll angeln	60 Sternis	diy/Housewares/Trash bags.png	2026-03-24 16:52:46.642355+00
218	\N	Einrichtung	Waschbärenfigur	\N	\N	f	Nachbarn (Miesepeter)	1.200 Sternis	diy/Housewares/Raccoon figurine.png	2026-03-24 16:52:46.642355+00
219	\N	Einrichtung	Steinofen	\N	\N	f	Bist du der Bastelboss? aus Nooks Laden	3.820 Sternis	diy/Housewares/Brick oven.png	2026-03-24 16:52:46.642355+00
220	\N	Einrichtung	Ziegelsteinbrunnen	8 Lehm, 15 Holz, 1 Wackelschaufel	\N	f	NookPortal	2.800 Sternis	diy/Housewares/Brick well.png	2026-03-24 16:52:46.642355+00
221	\N	Einrichtung	Silo	\N	\N	f	NookPortal	13.920 Sternis	diy/Housewares/Silo.png	2026-03-24 16:52:46.642355+00
222	\N	Einrichtung	Steinhocker	\N	\N	f	Mein erstes Bastelbuch aus Nooks Laden, Tom Nook (Drei Häuser)	450 Sternis	diy/Housewares/Stone stool.png	2026-03-24 16:52:46.642355+00
223	\N	Einrichtung	Steintisch	\N	\N	f	Nachbarn (Schlafmütze), Tom Nook (Drei Häuser)	1.200 Sternis	diy/Housewares/Stone table.png	2026-03-24 16:52:46.642355+00
224	\N	Einrichtung	Vogeltränke	\N	\N	f	Nachbarn (Hochnäsig), Tom Nook (Drei Häuser)	900 Sternis	diy/Housewares/Birdbath.png	2026-03-24 16:52:46.642355+00
225	\N	Einrichtung	Trinkbrunnen	\N	\N	f	NookPortal	2.700 Sternis	diy/Housewares/Drinking fountain.png	2026-03-24 16:52:46.642355+00
226	\N	Einrichtung	Springbrunnen	1 Trinkbrunnen, 20 Stein, 8 Eisenerz	\N	f	NookPortal	11.700 Sternis	diy/Housewares/Fountain.png	2026-03-24 16:52:46.642355+00
229	\N	Einrichtung	Moos-Gartenstein	\N	\N	f	Nachbarn (Schlafmütze)	2.550 Sternis	diy/Housewares/Mossy garden rock.png	2026-03-24 16:52:46.642355+00
231	\N	Einrichtung	Steinbogen	\N	\N	f	NookPortal	13.500 Sternis	diy/Housewares/Stone arch.png	2026-03-24 16:52:46.642355+00
232	\N	Einrichtung	Saunaofen	\N	\N	f	Nachbarn (Schlafmütze)	3.510 Sternis	diy/Housewares/Sauna heater.png	2026-03-24 16:52:46.642355+00
233	\N	Einrichtung	Grundwasserbrunnen	15 Stein, 1 Wackelschaufel	\N	f	NookPortal	2.850 Sternis	diy/Housewares/Simple well.png	2026-03-24 16:52:46.642355+00
234	\N	Einrichtung	Freiluftbad	20 Stein, 1 Schaufel	\N	f	NookPortal	4.350 Sternis	diy/Housewares/Outdoor bath.png	2026-03-24 16:52:46.642355+00
235	\N	Einrichtung	Wellenbrecher	\N	\N	f	NookPortal	3.500 Sternis	diy/Housewares/Wave breaker.png	2026-03-24 16:52:46.642355+00
237	\N	Einrichtung	Japan-Grabstein	\N	\N	f	Nachbarn (Schlafmütze)	4.500 Sternis	diy/Housewares/Zen-style stone.png	2026-03-24 16:52:46.642355+00
238	\N	Einrichtung	Steinlöwe	\N	\N	f	Nachbarn (Selbstzufrieden)	3.600 Sternis	diy/Housewares/Stone lion-dog.png	2026-03-24 16:52:46.642355+00
240	\N	Einrichtung	Mega-Laterne	\N	\N	f	Nachbarn (Selbstzufrieden)	2.700 Sternis	diy/Housewares/Tall lantern.png	2026-03-24 16:52:46.642355+00
241	\N	Einrichtung	Vogelbad-Fels	\N	\N	f	Nachbarn (Hochnäsig)	1.500 Sternis	diy/Housewares/Pond stone.png	2026-03-24 16:52:46.642355+00
242	\N	Einrichtung	Kirschblüten-Vogelbad-Fels	\N	\N	f	Ballon (Kirschblüten)	2.700 Sternis	diy/Housewares/Cherry-blossom pond stone.png	2026-03-24 16:52:46.642355+00
244	\N	Einrichtung	Eisen-Holz-Küchenschrank	12 Holz, 6 Eisenerz, 1 Eisen-Holz-Kommode	\N	f	Nachbarn (Hochnäsig)	10.800 Sternis	diy/Housewares/Ironwood cupboard.png	2026-03-24 16:52:46.642355+00
245	\N	Einrichtung	Eisen-Holz-Spülschrank	4 Holz, 3 Eisenerz, 1 Eisen-Holz-Kommode, 1 Schneidebrett	\N	f	Bist du der Bastelboss? aus Nooks Laden	10.950 Sternis	diy/Housewares/Ironwood kitchenette.png	2026-03-24 16:52:46.642355+00
246	\N	Einrichtung	Eisen-Holz-Werkbank	12 Holz, 6 Eisenerz, 1 Mini-Werkbank	\N	f	Nachbarn (Miesepeter)	8.880 Sternis	diy/Housewares/Ironwood DIY workbench.png	2026-03-24 16:52:46.642355+00
251	\N	Einrichtung	Goldritterrüstung	2 Golderz, 1 Ritterrüstung	\N	f	Nachbarn (Selbstzufrieden)	\N	diy/Housewares/Golden plate armor.png	2026-03-24 16:52:46.642355+00
252	\N	Einrichtung	Goldrohrsystem	2 Golderz, 1 Rohrsystem	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Golden meter and pipes.png	2026-03-24 16:52:46.642355+00
253	\N	Einrichtung	Goldzahnradapparatur	2 Golderz, 1 Zahnradapparatur	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Golden gear apparatus.png	2026-03-24 16:52:46.642355+00
254	\N	Einrichtung	Goldzahnradturm	2 Golderz, 1 Zahnradturm	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Golden gear tower.png	2026-03-24 16:52:46.642355+00
255	\N	Einrichtung	Goldvase	1 Golderz, 1 Edel-Vase	\N	f	Nachbarn (Ausgeglichen)	\N	diy/Housewares/Golden vase.png	2026-03-24 16:52:46.642355+00
256	\N	Einrichtung	Goldbadebecken	2 Golderz, 1 Quadratbadebecken	\N	f	Nachbarn (Schwungvoll)	\N	diy/Housewares/Golden bathtub.png	2026-03-24 16:52:46.642355+00
257	\N	Einrichtung	Gold-Samuraikostüm	2 Golderz, 1 Samuraikostüm	\N	f	Nachbarn (Sportlich)	\N	diy/Housewares/Golden samurai suit.png	2026-03-24 16:52:46.642355+00
258	\N	Einrichtung	Goldaltar	5 Golderz, 1 Obskuraltar	\N	f	Nachbarn (Schlafmütze)	\N	diy/Housewares/Golden altar.png	2026-03-24 16:52:46.642355+00
259	\N	Einrichtung	Goldminenlore	3 Golderz, 1 Minenlore	\N	f	Nachbarn (Sportlich)	\N	diy/Housewares/Gold-nugget mining car.png	2026-03-24 16:52:46.642355+00
260	\N	Einrichtung	Strohbett	\N	\N	f	Mein erstes Bastelbuch aus Nooks Laden, Tom Nook (Drei Häuser)	400 Sternis	diy/Housewares/Hay bed.png	2026-03-24 16:52:46.642355+00
261	\N	Einrichtung	Rankenhängesessel	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Vine hanging chair.png	2026-03-24 16:52:46.642355+00
262	\N	Einrichtung	Rankenbank	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Vine bench.png	2026-03-24 16:52:46.642355+00
263	\N	Einrichtung	Riesenranke	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Giant vine.png	2026-03-24 16:52:46.642355+00
264	\N	Einrichtung	Ruinentor	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Ruined arch.png	2026-03-24 16:52:46.642355+00
265	\N	Einrichtung	Ruinen-Schmucksäule	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Ruined decorated pillar.png	2026-03-24 16:52:46.642355+00
266	\N	Einrichtung	Ruinen-Bruchsäule	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Ruined broken pillar.png	2026-03-24 16:52:46.642355+00
267	\N	Einrichtung	Ruinenhocker	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Ruined seat.png	2026-03-24 16:52:46.642355+00
269	\N	Einrichtung	Leuchtmoosstuhl	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss stool.png	2026-03-24 16:52:46.642355+00
270	\N	Einrichtung	Leuchtmoosfindling	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss boulder.png	2026-03-24 16:52:46.642355+00
271	\N	Einrichtung	Leuchtmoosballon	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss balloon.png	2026-03-24 16:52:46.642355+00
272	\N	Einrichtung	Leuchtmoosregal	6 Leuchtmoos-Glas, 6 Eisenerz	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss-jar shelves.png	2026-03-24 16:52:46.642355+00
274	\N	Einrichtung	Leuchtmoosstatue	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss statue.png	2026-03-24 16:52:46.642355+00
275	\N	Einrichtung	Leuchtmoosteich	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Glowing-moss pond.png	2026-03-24 16:52:46.642355+00
276	\N	Einrichtung	Orange-Tischchen	\N	\N	f	Nachbarn (Schlafmütze), Tom Nook (Drei Häuser)	2.480 Sternis	diy/Housewares/Orange end table.png	2026-03-24 16:52:46.642355+00
277	\N	Einrichtung	Pfirsichstuhl	\N	\N	f	Nachbarn (Ausgeglichen), Tom Nook (Drei Häuser)	2.600 Sternis	diy/Housewares/Peach chair.png	2026-03-24 16:52:46.642355+00
282	\N	Einrichtung	Palmenlampe	\N	\N	f	Nachbarn (Hochnäsig)	3.280 Sternis	diy/Housewares/Palm-tree lamp.png	2026-03-24 16:52:46.642355+00
283	\N	Einrichtung	Senmaizuke-Fass	\N	\N	f	Nachbarn (Miesepeter)	\N	diy/Housewares/Senmaizuke barrel.png	2026-03-24 16:52:46.642355+00
284	\N	Einrichtung	Senmaizuke-Fass-Stapel	2 Senmaizuke-Fass	\N	f	Nachbarn (Miesepeter)	\N	diy/Housewares/Stacked senmaizuke barrels.png	2026-03-24 16:52:46.642355+00
286	\N	Einrichtung	Mini-Bibliothek	\N	\N	f	Nachbarn (Ausgeglichen)	1.035 Sternis	diy/Housewares/Tiny library.png	2026-03-24 16:52:46.642355+00
288	\N	Einrichtung	Papierchaos	1 Dokumentenstapel	\N	f	Nachbarn (Selbstzufrieden)	400 Sternis	diy/Housewares/Scattered papers.png	2026-03-24 16:52:46.642355+00
289	\N	Einrichtung	Kartonhocker	\N	\N	f	Nachbarn (Schlafmütze)	60 Sternis	diy/Housewares/Cardboard chair.png	2026-03-24 16:52:46.642355+00
290	\N	Einrichtung	Kartonsofa	\N	\N	f	Nachbarn (Schwungvoll)	120 Sternis	diy/Housewares/Cardboard sofa.png	2026-03-24 16:52:46.642355+00
291	\N	Einrichtung	Kartontisch	\N	\N	f	Nachbarn (Schwungvoll)	240 Sternis	diy/Housewares/Cardboard table.png	2026-03-24 16:52:46.642355+00
292	\N	Einrichtung	Kartonbett	\N	\N	f	Nachbarn (Schlafmütze)	240 Sternis	diy/Housewares/Cardboard bed.png	2026-03-24 16:52:46.642355+00
293	\N	Einrichtung	Umzugskistenset (S)	\N	\N	f	Nachbarn (Schwungvoll)	120 Sternis	diy/Housewares/Small cardboard boxes.png	2026-03-24 16:52:46.642355+00
294	\N	Einrichtung	Umzugskistenset (M)	\N	\N	f	Nachbarn (Schlafmütze)	240 Sternis	diy/Housewares/Medium cardboard boxes.png	2026-03-24 16:52:46.642355+00
295	\N	Einrichtung	Umzugskistenset (L)	\N	\N	f	Nachbarn (Schlafmütze)	300 Sternis	diy/Housewares/Large cardboard boxes.png	2026-03-24 16:52:46.642355+00
296	\N	Einrichtung	Kartonstapel	\N	\N	f	Nachbarn (Schlafmütze)	180 Sternis	diy/Housewares/Pile of cardboard boxes.png	2026-03-24 16:52:46.642355+00
297	\N	Einrichtung	Fernost-Kissen-Stapel	3 Fernost-Kissen	\N	f	Nachbarn (Miesepeter)	750 Sternis	diy/Housewares/Pile of zen cushions.png	2026-03-24 16:52:46.642355+00
298	\N	Einrichtung	Ölfassbad	1 Ölfass, 1 Lagerfeuer, 2 Stein	\N	f	Nachbarn (Sportlich)	655 Sternis	diy/Housewares/Oil-barrel bathtub.png	2026-03-24 16:52:46.642355+00
299	\N	Einrichtung	Riesenteddy	1 Papa-Bär, 1 Mama-Bär, 1 Baby-Bär	\N	f	Nachbarn (Schwungvoll)	25.500 Sternis	diy/Housewares/Giant teddy bear.png	2026-03-24 16:52:46.642355+00
300	\N	Einrichtung	Straßenklavier	1 Klavier, 1 Malset	\N	f	Nachbarn (Große Schwester)	26.500 Sternis	diy/Housewares/Street piano.png	2026-03-24 16:52:46.642355+00
301	\N	Einrichtung	Einkaufskörbestapel	5 Einkaufskorb	\N	f	Nachbarn (Ausgeglichen)	\N	diy/Housewares/Stacked shopping baskets.png	2026-03-24 16:52:46.642355+00
302	\N	Einrichtung	Fischkistenstapel	3 Fischkiste	\N	f	Nachbarn (Schlafmütze)	\N	diy/Housewares/Stacked fish containers.png	2026-03-24 16:52:46.642355+00
303	\N	Einrichtung	Zahnradturm	4 Zahnradgetriebe	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Gear tower.png	2026-03-24 16:52:46.642355+00
304	\N	Einrichtung	Zahnradapparatur	3 Zahnradgetriebe	\N	f	Nachbarn (Große Schwester)	\N	diy/Housewares/Gear apparatus.png	2026-03-24 16:52:46.642355+00
305	\N	Einrichtung	Mondsichelstuhl	\N	\N	f	Eufemia	8.500 Sternis	diy/Housewares/Crescent-moon chair.png	2026-03-24 16:52:46.642355+00
306	\N	Einrichtung	Mond	\N	\N	f	Eufemia	10.000 Sternis	diy/Housewares/Moon.png	2026-03-24 16:52:46.642355+00
309	\N	Einrichtung	Rakete	\N	\N	f	Eufemia	20.000 Sternis	diy/Housewares/Rocket.png	2026-03-24 16:52:46.642355+00
310	\N	Einrichtung	Raumsonde	\N	\N	f	Eufemia	16.250 Sternis	diy/Housewares/Satellite.png	2026-03-24 16:52:46.642355+00
311	\N	Einrichtung	Raumfähre	\N	\N	f	Eufemia	10.000 Sternis	diy/Housewares/Space shuttle.png	2026-03-24 16:52:46.642355+00
312	\N	Einrichtung	Rakete mit Besatzung	\N	\N	f	Eufemia	20.000 Sternis	diy/Housewares/Crewed spaceship.png	2026-03-24 16:52:46.642355+00
314	\N	Einrichtung	Mondfahrzeug	10 Sternensplitter, 10 Eisenerz, 4 Reifen	\N	f	Eufemia	12.580 Sternis	diy/Housewares/Lunar rover.png	2026-03-24 16:52:46.642355+00
315	\N	Einrichtung	UFO	\N	\N	f	Eufemia	15.000 Sternis	diy/Housewares/Flying saucer.png	2026-03-24 16:52:46.642355+00
318	\N	Einrichtung	Pilzschemel	\N	\N	f	Ballon (Pilz)	800 Sternis	diy/Housewares/Mush low stool.png	2026-03-24 16:52:46.642355+00
319	\N	Einrichtung	Pilzbaumstumpf	2 Dürrpilz, 1 Baumstammhocker	\N	f	Ballon (Pilz)	1.680 Sternis	diy/Housewares/Mush log.png	2026-03-24 16:52:46.642355+00
320	\N	Einrichtung	Pilztisch	\N	\N	f	Ballon (Pilz)	1.520 Sternis	diy/Housewares/Mush table.png	2026-03-24 16:52:46.642355+00
321	\N	Einrichtung	Pilzlampe	\N	\N	f	Ballon (Pilz)	1.600 Sternis	diy/Housewares/Mush lamp.png	2026-03-24 16:52:46.642355+00
322	\N	Einrichtung	Pilzschirm	\N	\N	f	Ballon (Pilz)	1.200 Sternis	diy/Housewares/Mush parasol.png	2026-03-24 16:52:46.642355+00
323	\N	Einrichtung	Pilzwandschirm	\N	\N	f	Ballon (Pilz)	\N	diy/Housewares/Mush screen.png	2026-03-24 16:52:46.642355+00
324	\N	Einrichtung	Kürbisstuhl	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	1.410 Sternis	diy/Housewares/Spooky chair.png	2026-03-24 16:52:46.642355+00
325	\N	Einrichtung	Kürbistisch	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	6.100 Sternis	diy/Housewares/Spooky table.png	2026-03-24 16:52:46.642355+00
326	\N	Einrichtung	Kürbis-Stehlampe	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	1.900 Sternis	diy/Housewares/Spooky standing lamp.png	2026-03-24 16:52:46.642355+00
327	\N	Einrichtung	Kürbislaternenset	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	1.480 Sternis	diy/Housewares/Spooky lantern set.png	2026-03-24 16:52:46.642355+00
328	\N	Einrichtung	Kürbisvogelscheuche	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	1.510 Sternis	diy/Housewares/Spooky scarecrow.png	2026-03-24 16:52:46.642355+00
329	\N	Einrichtung	Kürbisturm	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	2.450 Sternis	diy/Housewares/Spooky tower.png	2026-03-24 16:52:46.642355+00
330	\N	Einrichtung	Kürbistor	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	5.300 Sternis	diy/Housewares/Spooky arch.png	2026-03-24 16:52:46.642355+00
331	\N	Einrichtung	Kürbiskutsche	\N	\N	f	Jakob (Halloween)	25.000 Sternis	diy/Housewares/Spooky carriage.png	2026-03-24 16:52:46.642355+00
332	\N	Einrichtung	Kürbisbaum	\N	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/Housewares/Spooky tree.png	2026-03-24 16:52:46.642355+00
333	\N	Einrichtung	Schlemmfest-Stuhl	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Housewares/Turkey Day chair.png	2026-03-24 16:52:46.642355+00
334	\N	Einrichtung	Schlemmfest-Tisch	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Housewares/Turkey Day table.png	2026-03-24 16:52:46.642355+00
335	\N	Einrichtung	Schlemmfest-Sockel	\N	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Housewares/Turkey Day garden stand.png	2026-03-24 16:52:46.642355+00
336	\N	Einrichtung	Schlemmfest-Kamin	1 Lagerfeuer, 30 Stein, 10 Lehm	\N	f	Gernod, Schlemmfest-Bastelbuch	\N	diy/Housewares/Turkey Day hearth.png	2026-03-24 16:52:46.642355+00
344	\N	Wanddeko	Zweigetürkranz	\N	\N	f	Nachbarn (Große Schwester)	100 Sternis	diy/wall-mounted/Tree branch wreath.png	2026-03-24 17:15:41.005225+00
346	\N	Wanddeko	Bauklotzwanduhr	1 Bauklotzset, 2 Weichholz, 1 Eisenerz	\N	f	Nachbarn (Schwungvoll)	1.350 Sternis	diy/wall-mounted/Wooden-block wall clock.png	2026-03-24 17:15:41.005225+00
347	\N	Wanddeko	Schlüsselbrett	\N	\N	f	Nachbarn (Große Schwester)	1.110 Sternis	diy/wall-mounted/Key holder.png	2026-03-24 17:15:41.005225+00
351	\N	Wanddeko	Hundeknochentürschild	\N	\N	f	Nachbarn (Schlafmütze)	360 Sternis	diy/wall-mounted/Bone doorplate.png	2026-03-24 17:15:41.005225+00
352	\N	Wanddeko	Pfotenabdrucktürschild	\N	\N	f	Nachbarn (Schwungvoll)	360 Sternis	diy/wall-mounted/Paw-print doorplate.png	2026-03-24 17:15:41.005225+00
353	\N	Wanddeko	Holztürschild	2 Holz, 1 Pinkrose	\N	f	Nachbarn (Hochnäsig)	400 Sternis	diy/wall-mounted/Timber doorplate.png	2026-03-24 17:15:41.005225+00
358	\N	Wanddeko	Wappentürschild	\N	\N	f	Nachbarn (Selbstzufrieden)	3.000 Sternis	diy/wall-mounted/Crest doorplate.png	2026-03-24 17:15:41.005225+00
364	\N	Wanddeko	Leuchtaufkleber-Set	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wall-mounted/Glow-in-the-dark stickers.png	2026-03-24 17:15:41.005225+00
365	\N	Wanddeko	Leuchtmooskranz	\N	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wall-mounted/Glowing-moss wreath.png	2026-03-24 17:15:41.005225+00
366	\N	Wanddeko	Orange-Wanduhr	\N	\N	f	Nachbarn (Schlafmütze), Tom Nook (Drei Häuser)	2.240 Sternis	diy/wall-mounted/Orange wall-mounted clock.png	2026-03-24 17:15:41.005225+00
367	\N	Wanddeko	Kirschenlampe	\N	\N	f	Nachbarn (Schwungvoll), Tom Nook (Drei Häuser)	2.400 Sternis	diy/wall-mounted/Cherry lamp.png	2026-03-24 17:15:41.005225+00
368	\N	Wanddeko	Kokosnuss-Wandkübel	\N	\N	f	Nachbarn (Hochnäsig)	600 Sternis	diy/wall-mounted/Coconut wall planter.png	2026-03-24 17:15:41.005225+00
370	\N	Wanddeko	Skateboard-Wandregal	3 Skateboard, 2 Hartholz	\N	f	Nachbarn (Sportlich)	\N	diy/wall-mounted/Skateboard wall rack.png	2026-03-24 17:15:41.005225+00
371	\N	Wanddeko	Sternengirlande	\N	\N	f	Eufemia	5.000 Sternis	diy/wall-mounted/Starry garland.png	2026-03-24 17:15:41.005225+00
372	\N	Wanddeko	Löwe-Wandschmuck	\N	\N	f	Eufemia	21.975 Sternis	diy/wall-mounted/Leo sculpture.png	2026-03-24 17:15:41.005225+00
373	\N	Wanddeko	Schütze-Bogen	3 Sternensplitter, 2 Löwe-Splitter, 2 Golderz	\N	f	Eufemia	21.750 Sternis	diy/wall-mounted/Sagittarius arrow.png	2026-03-24 17:15:41.005225+00
375	\N	Wanddeko	Kirschblütenuhr	\N	\N	f	Ballon (Kirschblüten)	2.750 Sternis	diy/wall-mounted/Cherry-blossom clock.png	2026-03-24 17:15:41.005225+00
376	\N	Wanddeko	Nixenwanduhr	\N	\N	f	Johannes	12.290 Sternis	diy/wall-mounted/Mermaid wall clock.png	2026-03-24 17:15:41.005225+00
377	\N	Wanddeko	Muscheltürkranz	\N	\N	f	Ballon (Sommermuschel), Melinda (Sommermuschel)	4.720 Sternis	diy/wall-mounted/Shell wreath.png	2026-03-24 17:15:41.005225+00
379	\N	Wanddeko	Pilztürkranz	\N	\N	f	Ballon (Pilz), Melinda (Pilz)	1.500 Sternis	diy/wall-mounted/Mushroom wreath.png	2026-03-24 17:15:41.005225+00
380	\N	Wanddeko	Kürbis-Girlande	\N	\N	f	Nachbarn (Halloween)	\N	diy/wall-mounted/Spooky garland.png	2026-03-24 17:15:41.005225+00
381	\N	Wanddeko	Schneeflockentürschmuck	\N	\N	f	Ballon (Schneeflocken), Melinda (Schneeflocken)	1.600 Sternis	diy/wall-mounted/Snowflake wreath.png	2026-03-24 17:15:41.005225+00
382	\N	Wanddeko	Objektmobile	\N	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	340 Sternis	diy/wall-mounted/Ornament mobile.png	2026-03-24 17:15:41.005225+00
384	\N	Wanddeko	Anemonentürkranz	3 Rotanemone, 3 Weißanemone, 3 Orangeanemone	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Windflower wreath.png	2026-03-24 17:15:41.005225+00
385	\N	Wanddeko	Buntanemonentürkranz	3 Blauanemone, 3 Pinkanemone, 3 Weißanemone	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Cool windflower wreath.png	2026-03-24 17:15:41.005225+00
387	\N	Wanddeko	Chrysanthementürkranz	3 Weißchrysantheme, 3 Gelbchrysantheme, 3 Rotchrysantheme	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Mum wreath.png	2026-03-24 17:15:41.005225+00
388	\N	Wanddeko	Edelchrysanth.-Türkranz	3 Rosachrysantheme, 3 Lilachrysantheme, 3 Rotchrysantheme	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Fancy mum wreath.png	2026-03-24 17:15:41.005225+00
390	\N	Wanddeko	Cosmeentürkranz	3 Gelbcosmea, 3 Weißcosmea, 3 Rotcosmea	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Cosmos wreath.png	2026-03-24 17:15:41.005225+00
391	\N	Wanddeko	Buntcosmeentürkranz	3 Orangecosmea, 3 Pinkcosmea, 3 Rotcosmea	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Pretty cosmos wreath.png	2026-03-24 17:15:41.005225+00
393	\N	Wanddeko	Tulpentürkranz	3 Papageitulpe, 3 Viridifloratulpe, 3 Triumphtulpe	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Tulip wreath.png	2026-03-24 17:15:41.005225+00
394	\N	Wanddeko	Bunttulpentürkranz	3 Flachlandtulpe, 3 Grengjer-Tulpe, 3 Wildtulpe	\N	f	Nachbarn	2.400 Sternis	diy/wall-mounted/Pretty tulip wreath.png	2026-03-24 17:15:41.005225+00
395	\N	Wanddeko	Römertulpentürkranz	10 Römertulpe	\N	f	Nachbarn	1.600 Sternis	diy/wall-mounted/Dark tulip wreath.png	2026-03-24 17:15:41.005225+00
396	\N	Wanddeko	Rosentürkranz	3 Liebesrose, 3 Unschuldsrose, 3 Bernsteinrose	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Rose wreath.png	2026-03-24 17:15:41.005225+00
397	\N	Wanddeko	Prachtrosentürkranz	3 Sonnenrose, 3 Pinkrose, 3 Bernsteinrose	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Fancy rose wreath.png	2026-03-24 17:15:41.005225+00
398	\N	Wanddeko	Dunkelrosentürkranz	3 Schwarzrose, 6 Lilarose	\N	f	Nachbarn	4.320 Sternis	diy/wall-mounted/Dark rose wreath.png	2026-03-24 17:15:41.005225+00
401	\N	Wanddeko	Veilchentürkranz	3 Hornveilchen, 3 Pfingstveilchen, 3 Alpenveilchen	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Pansy wreath.png	2026-03-24 17:15:41.005225+00
402	\N	Wanddeko	Schickveilchentürkranz	3 Stiefmütterchen, 3 Duftveilchen, 3 Hornveilchen	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Snazzy pansy wreath.png	2026-03-24 17:15:41.005225+00
403	\N	Wanddeko	Buntveilchentürkranz	10 Hainveilchen	\N	f	Nachbarn	4.800 Sternis	diy/wall-mounted/Cool pansy wreath.png	2026-03-24 17:15:41.005225+00
404	\N	Wanddeko	Hyazinthentürkranz	3 Weißhyazinthe, 3 Rothyazinthe, 3 Gelbhyazinthe	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Hyacinth wreath.png	2026-03-24 17:15:41.005225+00
405	\N	Wanddeko	Bunthyazinthentürkranz	3 Orangehyazinthe, 3 Blauhyazinthe, 3 Rosahyazinthe	\N	f	Nachbarn	1.440 Sternis	diy/wall-mounted/Cool hyacinth wreath.png	2026-03-24 17:15:41.005225+00
406	\N	Wanddeko	Purpurhyazinthentürkranz	\N	\N	f	Nachbarn	4.800 Sternis	diy/wall-mounted/Purple hyacinth wreath.png	2026-03-24 17:15:41.005225+00
407	\N	Wanddeko	Lilientürkranz	3 Osterlilie, 3 Rotlilie, 3 Pyrenäenlilie	\N	f	Nachbarn, Tom Nook (Drei Häuser)	720 Sternis	diy/wall-mounted/Lily wreath.png	2026-03-24 17:15:41.005225+00
408	\N	Wanddeko	Prachtlilientürkranz	3 Feuerlilie, 3 Türkenbundlilie, 3 Pyrenäenlilie	\N	f	Nachbarn	1.200 Sternis	diy/wall-mounted/Fancy lily wreath.png	2026-03-24 17:15:41.005225+00
409	\N	Wanddeko	Dunkellilientürkranz	10 Dunkellilie	\N	f	Nachbarn	1.600 Sternis	diy/wall-mounted/Dark lily wreath.png	2026-03-24 17:15:41.005225+00
413	\N	Deckendeko	Rankengirlande	7 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Vine garland.png	2026-03-25 08:30:24.630534+00
414	\N	Deckendeko	Hängeleuchtmoos	5 Leuchtmoos, 3 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Hanging glowing moss.png	2026-03-25 08:30:24.630534+00
415	\N	Deckendeko	Lampion-Set	4 Lampion	\N	f	Nachbarn (Schwungvoll)	\N	diy/wallpaper_floor_rugs-ceiling/Festival-lantern set.png	2026-03-25 08:30:24.630534+00
416	\N	Tapeten/Böden/Teppiche	Buntholzwand	5 Holz, 5 Weichholz, 5 Hartholz	\N	f	Nachbarn (Hochnäsig)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Modern wood wall.png	2026-03-25 08:30:24.630534+00
417	\N	Tapeten/Böden/Teppiche	Mischholzwand	15 Holz	\N	f	Nachbarn (Ausgeglichen)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Wooden-mosaic wall.png	2026-03-25 08:30:24.630534+00
418	\N	Tapeten/Böden/Teppiche	Dunkel-Mischholzwand	15 Holz	\N	f	Nachbarn (Große Schwester)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Dark wooden-mosaic wall.png	2026-03-25 08:30:24.630534+00
419	\N	Tapeten/Böden/Teppiche	Wildholzwand	15 Holz	\N	f	Nachbarn (Miesepeter)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Wild-wood wall.png	2026-03-25 08:30:24.630534+00
420	\N	Tapeten/Böden/Teppiche	Hell-Fischgrätwand	15 Weichholz	\N	f	Nachbarn (Große Schwester)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Brown herringbone wall.png	2026-03-25 08:30:24.630534+00
421	\N	Tapeten/Böden/Teppiche	Dunkel-Fischgrätwand	15 Weichholz	\N	f	Nachbarn (Selbstzufrieden)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Chocolate herringbone wall.png	2026-03-25 08:30:24.630534+00
422	\N	Tapeten/Böden/Teppiche	Zirbenverkleidung	15 Hartholz	\N	f	Nachbarn (Selbstzufrieden)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Wooden-knot wall.png	2026-03-25 08:30:24.630534+00
423	\N	Tapeten/Böden/Teppiche	Blockhauswand	15 Hartholz	\N	f	Nachbarn (Schwungvoll)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Cabin wall.png	2026-03-25 08:30:24.630534+00
424	\N	Tapeten/Böden/Teppiche	Holzstapelwand	15 Hartholz	\N	f	Nachbarn (Sportlich)	1.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Stacked-wood wall.png	2026-03-25 08:30:24.630534+00
425	\N	Tapeten/Böden/Teppiche	Baumstammteppich	6 Holz	\N	f	Nachbarn (Hochnäsig)	\N	diy/wallpaper_floor_rugs-ceiling/Tree-stump rug.png	2026-03-25 08:30:24.630534+00
426	\N	Tapeten/Böden/Teppiche	Müllbergtapete	2 Dose, 2 Stiefel, 2 Reifen	\N	f	15 mal Müll angeln	120 Sternis	diy/wallpaper_floor_rugs-ceiling/Garbage-heap wall.png	2026-03-25 08:30:24.630534+00
427	\N	Tapeten/Böden/Teppiche	Müllbergboden	2 Dose, 2 Stiefel, 2 Reifen	\N	f	15 mal Müll angeln	120 Sternis	diy/wallpaper_floor_rugs-ceiling/Garbage-heap flooring.png	2026-03-25 08:30:24.630534+00
428	\N	Tapeten/Böden/Teppiche	Steinwand	10 Stein	\N	f	Nachbarn (Selbstzufrieden)	1.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Stone wall.png	2026-03-25 08:30:24.630534+00
429	\N	Tapeten/Böden/Teppiche	Bruchsteinwand	5 Stein, 5 Lehm	\N	f	Nachbarn (Hochnäsig)	1.750 Sternis	diy/wallpaper_floor_rugs-ceiling/Rustic-stone wall.png	2026-03-25 08:30:24.630534+00
430	\N	Tapeten/Böden/Teppiche	Kellerboden	10 Stein	\N	f	Nachbarn (Selbstzufrieden)	1.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Basement flooring.png	2026-03-25 08:30:24.630534+00
431	\N	Tapeten/Böden/Teppiche	Eisengittertapete	8 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	6.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Steel-frame wall.png	2026-03-25 08:30:24.630534+00
432	\N	Tapeten/Böden/Teppiche	Eisenbelag	7 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	5.250 Sternis	diy/wallpaper_floor_rugs-ceiling/Steel flooring.png	2026-03-25 08:30:24.630534+00
433	\N	Tapeten/Böden/Teppiche	Goldtapete	4 Golderz	\N	f	Nachbarn (Selbstzufrieden)	40.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Golden wall.png	2026-03-25 08:30:24.630534+00
434	\N	Tapeten/Böden/Teppiche	Goldtürtapete	2 Golderz, 1 Schiebetürtapete	\N	f	Nachbarn (Selbstzufrieden)	20.750 Sternis	diy/wallpaper_floor_rugs-ceiling/Gold-screen wall.png	2026-03-25 08:30:24.630534+00
435	\N	Tapeten/Böden/Teppiche	Goldboden	4 Golderz	\N	f	Nachbarn (Selbstzufrieden)	40.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Golden flooring.png	2026-03-25 08:30:24.630534+00
436	\N	Tapeten/Böden/Teppiche	Dschungeltapete	15 Unkraut, 3 Holz, 3 Hartholz, 3 Weichholz	\N	f	Nachbarn (Sportlich)	1.380 Sternis	diy/wallpaper_floor_rugs-ceiling/Jungle wall.png	2026-03-25 08:30:24.630534+00
437	\N	Tapeten/Böden/Teppiche	Urwaldtapete	15 Unkraut, 9 Weichholz	\N	f	Nachbarn (Ausgeglichen)	1.380 Sternis	diy/wallpaper_floor_rugs-ceiling/Woodland wall.png	2026-03-25 08:30:24.630534+00
438	\N	Tapeten/Böden/Teppiche	Dschungelboden	10 Unkraut, 10 Lehm	\N	f	Nachbarn (Sportlich)	2.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Jungle flooring.png	2026-03-25 08:30:24.630534+00
439	\N	Tapeten/Böden/Teppiche	Wiese	30 Unkraut	\N	f	Nachbarn (Schwungvoll)	600 Sternis	diy/wallpaper_floor_rugs-ceiling/Backyard lawn.png	2026-03-25 08:30:24.630534+00
440	\N	Tapeten/Böden/Teppiche	Seilnetz-Tapete	10 Ranke, 10 Holz	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Rope-net wall.png	2026-03-25 08:30:24.630534+00
441	\N	Tapeten/Böden/Teppiche	Seilnetz-Boden	10 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Rope-net flooring.png	2026-03-25 08:30:24.630534+00
442	\N	Tapeten/Böden/Teppiche	Rund-Rankenteppich	4 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Round vine rug.png	2026-03-25 08:30:24.630534+00
443	\N	Tapeten/Böden/Teppiche	Leuchtmooswald-Tapete	10 Leuchtmoos, 10 Hartholz	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Glowing-moss forest wall.png	2026-03-25 08:30:24.630534+00
444	\N	Tapeten/Böden/Teppiche	Leuchtmooshöhlen-Tapete	10 Leuchtmoos, 10 Lehm	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Glowing-moss cave wall.png	2026-03-25 08:30:24.630534+00
445	\N	Tapeten/Böden/Teppiche	Leuchtmoosruinen-Tapete	10 Leuchtmoos, 1 Ruinenwand	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Glowing-moss ruins wall.png	2026-03-25 08:30:24.630534+00
446	\N	Tapeten/Böden/Teppiche	Leuchtmooswald-Boden	10 Leuchtmoos, 10 Unkraut, 5 Stein	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Glowing-moss flooring.png	2026-03-25 08:30:24.630534+00
447	\N	Tapeten/Böden/Teppiche	Rund-Leuchtmoosteppich	4 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Round glowing-moss rug.png	2026-03-25 08:30:24.630534+00
448	\N	Tapeten/Böden/Teppiche	Leuchtmoosteppich	6 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/wallpaper_floor_rugs-ceiling/Glowing-moss rug.png	2026-03-25 08:30:24.630534+00
449	\N	Tapeten/Böden/Teppiche	Orangentapete	20 Orange	\N	f	Nachbarn (Schlafmütze)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Orange wall.png	2026-03-25 08:30:24.630534+00
450	\N	Tapeten/Böden/Teppiche	Orangen-Teppich	6 Orange	\N	f	Nachbarn (Schlafmütze)	1.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Orange rug.png	2026-03-25 08:30:24.630534+00
451	\N	Tapeten/Böden/Teppiche	Kirschtapete	20 Kirsche	\N	f	Nachbarn (Schwungvoll)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Cherry wall.png	2026-03-25 08:30:24.630534+00
452	\N	Tapeten/Böden/Teppiche	Kirsch-Teppich	6 Kirsche	\N	f	Nachbarn (Schwungvoll)	1.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Cherry rug.png	2026-03-25 08:30:24.630534+00
453	\N	Tapeten/Böden/Teppiche	Pfirsichtapete	20 Pfirsich	\N	f	Nachbarn (Ausgeglichen)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Peach wall.png	2026-03-25 08:30:24.630534+00
454	\N	Tapeten/Böden/Teppiche	Pfirsich-Teppich	6 Pfirsich	\N	f	Nachbarn (Ausgeglichen)	1.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Peach rug.png	2026-03-25 08:30:24.630534+00
455	\N	Tapeten/Böden/Teppiche	Birnentapete	20 Birne	\N	f	Nachbarn (Sportlich)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Pear wall.png	2026-03-25 08:30:24.630534+00
456	\N	Tapeten/Böden/Teppiche	Birnen-Teppich	6 Birne	\N	f	Nachbarn (Sportlich)	1.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Pear rug.png	2026-03-25 08:30:24.630534+00
457	\N	Tapeten/Böden/Teppiche	Apfeltapete	20 Apfel	\N	f	Nachbarn (Große Schwester)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Apple wall.png	2026-03-25 08:30:24.630534+00
458	\N	Tapeten/Böden/Teppiche	Apfel-Teppich	6 Apfel	\N	f	Nachbarn (Große Schwester)	1.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Apple rug.png	2026-03-25 08:30:24.630534+00
459	\N	Tapeten/Böden/Teppiche	Bienenwabenwand	6 Wespennest	\N	f	Nachbarn (Sportlich)	3.600 Sternis	diy/wallpaper_floor_rugs-ceiling/Honeycomb wall.png	2026-03-25 08:30:24.630534+00
460	\N	Tapeten/Böden/Teppiche	Bienenwabenboden	5 Wespennest	\N	f	Nachbarn (Sportlich)	3.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Honeycomb flooring.png	2026-03-25 08:30:24.630534+00
461	\N	Tapeten/Böden/Teppiche	Klassik-Bücherwand	10 Buch	\N	f	Nachbarn (Ausgeglichen)	1.450 Sternis	diy/wallpaper_floor_rugs-ceiling/Classic-library wall.png	2026-03-25 08:30:24.630534+00
462	\N	Tapeten/Böden/Teppiche	Manga-Bücherwand	10 Magazin	\N	f	Nachbarn (Schwungvoll)	1.050 Sternis	diy/wallpaper_floor_rugs-ceiling/Manga-library wall.png	2026-03-25 08:30:24.630534+00
463	\N	Tapeten/Böden/Teppiche	Monetenboden	50.000-Sterni-Sack	\N	f	Nachbarn (Hochnäsig)	25.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Money flooring.png	2026-03-25 08:30:24.630534+00
464	\N	Tapeten/Böden/Teppiche	Sternenhimmeltapete	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Starry-sky wall.png	2026-03-25 08:30:24.630534+00
465	\N	Tapeten/Böden/Teppiche	Sternentapete	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Starry wall.png	2026-03-25 08:30:24.630534+00
466	\N	Tapeten/Böden/Teppiche	Raumschifftapete	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Sci-fi wall.png	2026-03-25 08:30:24.630534+00
467	\N	Tapeten/Böden/Teppiche	Weltraumboden	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Galaxy flooring.png	2026-03-25 08:30:24.630534+00
468	\N	Tapeten/Böden/Teppiche	Mondlandschaft	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Lunar surface.png	2026-03-25 08:30:24.630534+00
469	\N	Tapeten/Böden/Teppiche	Raumschiffboden	5 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	7.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Sci-fi flooring.png	2026-03-25 08:30:24.630534+00
470	\N	Tapeten/Böden/Teppiche	Gelb-Sternteppich	3 Sternensplitter	\N	f	Eufemia	\N	diy/wallpaper_floor_rugs-ceiling/Yellow star rug.png	2026-03-25 08:30:24.630534+00
471	\N	Tapeten/Böden/Teppiche	Sternbilder-Teppich	1 Sternensplitter, 1 Riesensternensplitter	\N	f	Eufemia	\N	diy/wallpaper_floor_rugs-ceiling/Starry-skies rug.png	2026-03-25 08:30:24.630534+00
472	\N	Tapeten/Böden/Teppiche	Bambuswand	15 Bambus	\N	f	Nachbarn (Miesepeter)	2.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Bamboo wall.png	2026-03-25 08:30:24.630534+00
473	\N	Tapeten/Böden/Teppiche	Bambusboden	15 Bambus	\N	f	Nachbarn (Miesepeter)	2.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Bamboo flooring.png	2026-03-25 08:30:24.630534+00
474	\N	Tapeten/Böden/Teppiche	Dunkel-Bambusmatte	6 Bambus	\N	f	Nachbarn (Miesepeter)	960 Sternis	diy/wallpaper_floor_rugs-ceiling/Dark bamboo rug.png	2026-03-25 08:30:24.630534+00
475	\N	Tapeten/Böden/Teppiche	Grün-Bambusmatte	3 Bambus	\N	f	Nachbarn (Miesepeter)	\N	diy/wallpaper_floor_rugs-ceiling/Green bamboo mat.png	2026-03-25 08:30:24.630534+00
476	\N	Tapeten/Böden/Teppiche	Dunkel-Bambusbadematte	3 Bambus	\N	f	Nachbarn (Miesepeter)	\N	diy/wallpaper_floor_rugs-ceiling/Dark bamboo bath mat.png	2026-03-25 08:30:24.630534+00
477	\N	Tapeten/Böden/Teppiche	Bambuswaldtapete	7 Frühlingsbambus, 3 Bambussprosse	\N	f	Ballon (Frühlingsbambus)	4.300 Sternis	diy/wallpaper_floor_rugs-ceiling/Bamboo-grove wall.png	2026-03-25 08:30:24.630534+00
478	\N	Tapeten/Böden/Teppiche	Hell-Bambusmatte	6 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	2.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Light bamboo rug.png	2026-03-25 08:30:24.630534+00
479	\N	Tapeten/Böden/Teppiche	Gelb-Bambusmatte	3 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	\N	diy/wallpaper_floor_rugs-ceiling/Yellow bamboo mat.png	2026-03-25 08:30:24.630534+00
480	\N	Tapeten/Böden/Teppiche	Hell-Bambusbadematte	3 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	\N	diy/wallpaper_floor_rugs-ceiling/Light bamboo bath mat.png	2026-03-25 08:30:24.630534+00
481	\N	Tapeten/Böden/Teppiche	Kirschblütenwand	10 Kirschblüte, 5 Hartholz	\N	f	Ballon (Kirschblüten)	4.600 Sternis	diy/wallpaper_floor_rugs-ceiling/Cherry-blossom-trees wall.png	2026-03-25 08:30:24.630534+00
482	\N	Tapeten/Böden/Teppiche	Kirschholzverkleidung	5 Kirschblüte, 10 Holz	\N	f	Ballon (Kirschblüten)	3.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Sakura-wood wall.png	2026-03-25 08:30:24.630534+00
483	\N	Tapeten/Böden/Teppiche	Kirschblütenboden	10 Kirschblüte, 20 Unkraut	\N	f	Ballon (Kirschblüten)	4.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Cherry-blossom flooring.png	2026-03-25 08:30:24.630534+00
484	\N	Tapeten/Böden/Teppiche	Kirschholzboden	5 Kirschblüte, 10 Holz	\N	f	Ballon (Kirschblüten)	3.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Sakura-wood flooring.png	2026-03-25 08:30:24.630534+00
485	\N	Tapeten/Böden/Teppiche	Kirschblütenteppich	6 Kirschblüte	\N	f	Ballon (Kirschblüten)	\N	diy/wallpaper_floor_rugs-ceiling/Cherry-blossom rug.png	2026-03-25 08:30:24.630534+00
486	\N	Tapeten/Böden/Teppiche	Nixentapete	2 Perle, 2 Kreiselschnecke, 2 Sanddollar, 2 Koralle, 2 Riesenmuschel, 2 Kaurischnecke	\N	f	Johannes	23.520 Sternis	diy/wallpaper_floor_rugs-ceiling/Mermaid wall.png	2026-03-25 08:30:24.630534+00
487	\N	Tapeten/Böden/Teppiche	Sandboden	1 Kreiselschnecke, 1 Stachelschnecke, 1 Sanddollar, 1 Koralle, 1 Riesenmuschel, 1 Kaurischnecke	\N	f	Nachbarn (Sportlich)	4.120 Sternis	diy/wallpaper_floor_rugs-ceiling/Sandy-beach flooring.png	2026-03-25 08:30:24.630534+00
488	\N	Tapeten/Böden/Teppiche	Nixenboden	2 Perle, 5 Sanddollar, 5 Stein	\N	f	Johannes	20.975 Sternis	diy/wallpaper_floor_rugs-ceiling/Mermaid flooring.png	2026-03-25 08:30:24.630534+00
489	\N	Tapeten/Böden/Teppiche	Muschelteppich	3 Riesenmuschel	\N	f	Nachbarn (Schwungvoll)	5.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Shell rug.png	2026-03-25 08:30:24.630534+00
490	\N	Tapeten/Böden/Teppiche	Nixenteppich	1 Perle, 3 Sanddollar	\N	f	Johannes	10.360 Sternis	diy/wallpaper_floor_rugs-ceiling/Mermaid rug.png	2026-03-25 08:30:24.630534+00
491	\N	Tapeten/Böden/Teppiche	Tropentapete	5 Sommermuschel	\N	f	Ballon (Sommermuschel)	6.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Tropical vista.png	2026-03-25 08:30:24.630534+00
492	\N	Tapeten/Böden/Teppiche	Meerestapete	3 Sommermuschel, 5 Koralle	\N	f	Ballon (Sommermuschel)	8.600 Sternis	diy/wallpaper_floor_rugs-ceiling/Underwater wall.png	2026-03-25 08:30:24.630534+00
493	\N	Tapeten/Böden/Teppiche	Meeresboden	3 Sommermuschel, 3 Koralle	\N	f	Ballon (Sommermuschel)	6.600 Sternis	diy/wallpaper_floor_rugs-ceiling/Underwater flooring.png	2026-03-25 08:30:24.630534+00
494	\N	Tapeten/Böden/Teppiche	Glitzersandboden	3 Sommermuschel, 1 Sandboden	\N	f	Ballon (Sommermuschel)	7.720 Sternis	diy/wallpaper_floor_rugs-ceiling/Starry-sands flooring.png	2026-03-25 08:30:24.630534+00
495	\N	Tapeten/Böden/Teppiche	Wasseroberfläche	6 Sommermuschel	\N	f	Ballon (Sommermuschel)	7.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Water flooring.png	2026-03-25 08:30:24.630534+00
496	\N	Tapeten/Böden/Teppiche	Sommer-Muschelteppich	6 Sommermuschel	\N	f	Ballon (Sommermuschel)	7.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Summer-shell rug.png	2026-03-25 08:30:24.630534+00
497	\N	Tapeten/Böden/Teppiche	Herbstlaubtapete	10 Herbstblatt, 5 Holz, 5 Unkraut	\N	f	Ballon (Herbstblatt)	4.700 Sternis	diy/wallpaper_floor_rugs-ceiling/Autumn wall.png	2026-03-25 08:30:24.630534+00
498	\N	Tapeten/Böden/Teppiche	Herbstlaubboden	10 Herbstblatt, 15 Unkraut	\N	f	Ballon (Herbstblatt)	4.300 Sternis	diy/wallpaper_floor_rugs-ceiling/Colored-leaves flooring.png	2026-03-25 08:30:24.630534+00
499	\N	Tapeten/Böden/Teppiche	Eichelteppich	6 Eichel	\N	f	Ballon (Baumfrucht)	\N	diy/wallpaper_floor_rugs-ceiling/Acorn rug.png	2026-03-25 08:30:24.630534+00
500	\N	Tapeten/Böden/Teppiche	Ahornblattteppich	6 Herbstblatt	\N	f	Ballon (Herbstblatt)	\N	diy/wallpaper_floor_rugs-ceiling/Maple-leaf rug.png	2026-03-25 08:30:24.630534+00
501	\N	Tapeten/Böden/Teppiche	Waldtapete	2 Elegantpilz, 2 Rundpilz, 2 Dürrpilz, 2 Flachpilz, 10 Holz	\N	f	Ballon (Pilz)	44.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Forest wall.png	2026-03-25 08:30:24.630534+00
502	\N	Tapeten/Böden/Teppiche	Waldpilztapete	1 Elegantpilz, 1 Rundpilz, 1 Dürrpilz, 1 Flachpilz	\N	f	Ballon (Pilz)	21.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Mush wall.png	2026-03-25 08:30:24.630534+00
503	\N	Tapeten/Böden/Teppiche	Waldboden	1 Seltenpilz, 2 Rundpilz, 2 Dürrpilz, 2 Flachpilz, 10 Unkraut	\N	f	Ballon (Pilz)	35.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Forest flooring.png	2026-03-25 08:30:24.630534+00
504	\N	Tapeten/Böden/Teppiche	Eistapete	1 Riesenschneeflocke, 8 Schneeflocke	\N	f	Schnemil	8.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Ice wall.png	2026-03-25 08:30:24.630534+00
505	\N	Tapeten/Böden/Teppiche	Eisboden	1 Riesenschneeflocke, 8 Schneeflocke	\N	f	Schnemil	8.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Ice flooring.png	2026-03-25 08:30:24.630534+00
506	\N	Tapeten/Böden/Teppiche	Skipistentapete	8 Schneeflocke	\N	f	Ballon (Schneeflocken)	3.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Ski-slope wall.png	2026-03-25 08:30:24.630534+00
507	\N	Tapeten/Böden/Teppiche	Eisbergtapete	10 Schneeflocke	\N	f	Ballon (Schneeflocken)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Iceberg wall.png	2026-03-25 08:30:24.630534+00
508	\N	Tapeten/Böden/Teppiche	Schneeflockentapete	12 Schneeflocke	\N	f	Ballon (Schneeflocken)	4.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Snowflake wall.png	2026-03-25 08:30:24.630534+00
509	\N	Tapeten/Böden/Teppiche	Schneefall-Tapete	3 Schneeflocke, 10 Stein	\N	f	Ballon (Schneeflocken)	\N	diy/wallpaper_floor_rugs-ceiling/Falling-snow wall.png	2026-03-25 08:30:24.630534+00
510	\N	Tapeten/Böden/Teppiche	Skipistenboden	8 Schneeflocke	\N	f	Ballon (Schneeflocken)	3.200 Sternis	diy/wallpaper_floor_rugs-ceiling/Ski-slope flooring.png	2026-03-25 08:30:24.630534+00
511	\N	Tapeten/Böden/Teppiche	Eisbergboden	10 Schneeflocke	\N	f	Ballon (Schneeflocken)	4.000 Sternis	diy/wallpaper_floor_rugs-ceiling/Iceberg flooring.png	2026-03-25 08:30:24.630534+00
512	\N	Tapeten/Böden/Teppiche	Eis-Fliesenvierer	8 Schneeflocke	\N	f	Ballon (Schneeflocken)	\N	diy/wallpaper_floor_rugs-ceiling/Frozen floor tiles.png	2026-03-25 08:30:24.630534+00
513	\N	Tapeten/Böden/Teppiche	Festtagstapete	5 Rotschmuck, 5 Blauschmuck, 5 Goldschmuck, 5 Lehm	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	2.500 Sternis	diy/wallpaper_floor_rugs-ceiling/Jingle wall.png	2026-03-25 08:30:24.630534+00
514	\N	Tapeten/Böden/Teppiche	Festtagsteppich	5 Rotschmuck, 5 Blauschmuck, 5 Goldschmuck	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	\N	diy/wallpaper_floor_rugs-ceiling/Festive rug.png	2026-03-25 08:30:24.630534+00
515	\N	Tapeten/Böden/Teppiche	Häschentag-Tapete	2 Erd-Glücksei, 2 Fels-Glücksei, 2 Laub-Glücksei, 2 Holz-Glücksei, 2 Luft-Glücksei, 2 Wasser-Glücksei	\N	f	Häschentag-Ballon	4.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Bunny Day wall.png	2026-03-25 08:30:24.630534+00
516	\N	Tapeten/Böden/Teppiche	Häschentag-Boden	2 Erd-Glücksei, 2 Fels-Glücksei, 2 Laub-Glücksei, 2 Holz-Glücksei, 2 Luft-Glücksei, 2 Wasser-Glücksei	\N	f	Häschentag-Ballon	4.800 Sternis	diy/wallpaper_floor_rugs-ceiling/Bunny Day flooring.png	2026-03-25 08:30:24.630534+00
517	\N	Tapeten/Böden/Teppiche	Häschentag-Teppich	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Häschentag-Ballon	2.400 Sternis	diy/wallpaper_floor_rugs-ceiling/Bunny Day rug.png	2026-03-25 08:30:24.630534+00
518	\N	Ausrüstung	Holzfällerrucksack	3 Holz, 5 Hartholz	\N	f	Nachbarn (Sportlich)	960 Sternis	diy/equipment/Log pack.png	2026-03-25 08:47:25.283501+00
519	\N	Ausrüstung	Paar Recyclingstiefel	2 Stiefel	\N	f	Stiefel angeln	40 Sternis	diy/equipment/Recycled boots.png	2026-03-25 08:47:25.283501+00
520	\N	Ausrüstung	Ritterhelm	5 Eisenerz	\N	f	Nachbarn (Miesepeter)	3.750 Sternis	diy/equipment/Knight's helmet.png	2026-03-25 08:47:25.283501+00
521	\N	Ausrüstung	Eisenrüstung	8 Eisenerz	\N	f	Nachbarn (Miesepeter)	6.000 Sternis	diy/equipment/Iron armor.png	2026-03-25 08:47:25.283501+00
522	\N	Ausrüstung	Paar Silberrüstungsschuhe	4 Eisenerz	\N	f	Nachbarn (Miesepeter)	3.000 Sternis	diy/equipment/Armor shoes.png	2026-03-25 08:47:25.283501+00
523	\N	Ausrüstung	Goldhelm	5 Golderz	\N	f	Nachbarn (Selbstzufrieden)	50.000 Sternis	diy/equipment/Gold helmet.png	2026-03-25 08:47:25.283501+00
524	\N	Ausrüstung	Goldrüstung	8 Golderz	\N	f	Nachbarn (Selbstzufrieden)	80.000 Sternis	diy/equipment/Gold armor.png	2026-03-25 08:47:25.283501+00
525	\N	Ausrüstung	Paar Goldrüstungsschuhe	4 Golderz	\N	f	Nachbarn (Selbstzufrieden)	40.000 Sternis	diy/equipment/Gold-armor shoes.png	2026-03-25 08:47:25.283501+00
526	\N	Ausrüstung	Pharaomaske	5 Golderz	\N	f	Golderz aus einem Stein schlagen	\N	diy/equipment/King Tut mask.png	2026-03-25 08:47:25.283501+00
527	\N	Ausrüstung	Blatt	5 Unkraut	\N	f	Nachbarn (Sportlich)	100 Sternis	diy/equipment/Leaf.png	2026-03-25 08:47:25.283501+00
528	\N	Ausrüstung	Blatt-Maske	10 Unkraut	\N	f	Nachbarn (Schwungvoll)	200 Sternis	diy/equipment/Leaf mask.png	2026-03-25 08:47:25.283501+00
529	\N	Ausrüstung	Blättchenschirm	15 Unkraut	\N	f	mit einem Nachbarn am zweiten Tag sprechen, Nachbarn (Große Schwester)	300 Sternis	diy/equipment/Leaf umbrella.png	2026-03-25 08:47:25.283501+00
530	\N	Ausrüstung	Flach-Reishut	10 Unkraut	\N	f	Nachbarn (Selbstzufrieden)	200 Sternis	diy/equipment/Straw umbrella hat.png	2026-03-25 08:47:25.283501+00
531	\N	Ausrüstung	Bambushut	10 Unkraut	\N	f	Nachbarn (Miesepeter)	200 Sternis	diy/equipment/Bamboo hat.png	2026-03-25 08:47:25.283501+00
532	\N	Ausrüstung	Strohmantel	8 Unkraut	\N	f	Nachbarn (Ausgeglichen)	160 Sternis	diy/equipment/Traditional straw coat.png	2026-03-25 08:47:25.283501+00
533	\N	Ausrüstung	Baströckchen	7 Unkraut	\N	f	Nachbarn (Ausgeglichen)	140 Sternis	diy/equipment/Grass skirt.png	2026-03-25 08:47:25.283501+00
534	\N	Ausrüstung	Grasröckchen	7 Unkraut	\N	f	Nachbarn (Schwungvoll)	140 Sternis	diy/equipment/Green grass skirt.png	2026-03-25 08:47:25.283501+00
535	\N	Ausrüstung	Grasgeflecht-Rucksack	20 Unkraut	\N	f	Nachbarn (Ausgeglichen)	400 Sternis	diy/equipment/Knitted-grass backpack.png	2026-03-25 08:47:25.283501+00
536	\N	Ausrüstung	Rankenkrone	3 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Vine crown.png	2026-03-25 08:47:25.283501+00
537	\N	Ausrüstung	Rankengeflechthut	8 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Woven-vines hat.png	2026-03-25 08:47:25.283501+00
538	\N	Ausrüstung	Ranken-Outfit	10 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Vine outfit.png	2026-03-25 08:47:25.283501+00
539	\N	Ausrüstung	Rankengeflecht-Pochette	5 Ranke	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Woven-vine pochette.png	2026-03-25 08:47:25.283501+00
540	\N	Ausrüstung	Leuchtmooshaube	8 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Glowing-moss hood.png	2026-03-25 08:47:25.283501+00
541	\N	Ausrüstung	Leuchtmoosspitzhut	8 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Glowing-moss pointed cap.png	2026-03-25 08:47:25.283501+00
542	\N	Ausrüstung	Leuchtmooshaarreif	3 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Glowing-moss headband.png	2026-03-25 08:47:25.283501+00
543	\N	Ausrüstung	Leuchtmoos-Overall	15 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Full-body glowing-moss suit.png	2026-03-25 08:47:25.283501+00
544	\N	Ausrüstung	Leuchtmooskleid	15 Leuchtmoos	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/equipment/Glowing-moss dress.png	2026-03-25 08:47:25.283501+00
545	\N	Ausrüstung	Orangenschirm	7 Orange	\N	f	Nachbarn (Schlafmütze)	1.400 Sternis	diy/equipment/Orange umbrella.png	2026-03-25 08:47:25.283501+00
546	\N	Ausrüstung	Orangenhut	5 Orange	\N	f	Nachbarn (Schlafmütze)	1.000 Sternis	diy/equipment/Orange hat.png	2026-03-25 08:47:25.283501+00
547	\N	Ausrüstung	Orangenkleid	8 Orange	\N	f	Nachbarn (Schlafmütze)	1.600 Sternis	diy/equipment/Orange dress.png	2026-03-25 08:47:25.283501+00
548	\N	Ausrüstung	Kirschschirm	7 Kirsche	\N	f	Nachbarn (Schwungvoll)	1.400 Sternis	diy/equipment/Cherry umbrella.png	2026-03-25 08:47:25.283501+00
549	\N	Ausrüstung	Kirschhut	5 Kirsche	\N	f	Nachbarn (Schwungvoll)	1.000 Sternis	diy/equipment/Cherry hat.png	2026-03-25 08:47:25.283501+00
550	\N	Ausrüstung	Kirschkleid	8 Kirsche	\N	f	Nachbarn (Schwungvoll)	1.600 Sternis	diy/equipment/Cherry dress.png	2026-03-25 08:47:25.283501+00
551	\N	Ausrüstung	Pfirsichschirm	7 Pfirsich	\N	f	Nachbarn (Ausgeglichen)	1.400 Sternis	diy/equipment/Peach umbrella.png	2026-03-25 08:47:25.283501+00
552	\N	Ausrüstung	Pfirsichhut	5 Pfirsich	\N	f	Nachbarn (Ausgeglichen)	1.000 Sternis	diy/equipment/Peach hat.png	2026-03-25 08:47:25.283501+00
553	\N	Ausrüstung	Pfirsichkleid	8 Pfirsich	\N	f	Nachbarn (Ausgeglichen)	1.600 Sternis	diy/equipment/Peach dress.png	2026-03-25 08:47:25.283501+00
554	\N	Ausrüstung	Birnenschirm	7 Birne	\N	f	Nachbarn (Sportlich)	1.400 Sternis	diy/equipment/Pear umbrella.png	2026-03-25 08:47:25.283501+00
555	\N	Ausrüstung	Birnenhut	5 Birne	\N	f	Nachbarn (Sportlich)	1.000 Sternis	diy/equipment/Pear hat.png	2026-03-25 08:47:25.283501+00
556	\N	Ausrüstung	Birnenkleid	8 Birne	\N	f	Nachbarn (Sportlich)	1.600 Sternis	diy/equipment/Pear dress.png	2026-03-25 08:47:25.283501+00
557	\N	Ausrüstung	Apfelschirm	7 Apfel	\N	f	Nachbarn (Große Schwester)	1.400 Sternis	diy/equipment/Apple umbrella.png	2026-03-25 08:47:25.283501+00
558	\N	Ausrüstung	Apfelhut	5 Apfel	\N	f	Nachbarn (Große Schwester)	1.000 Sternis	diy/equipment/Apple hat.png	2026-03-25 08:47:25.283501+00
559	\N	Ausrüstung	Apfelkleid	8 Apfel	\N	f	Nachbarn (Große Schwester)	1.600 Sternis	diy/equipment/Apple dress.png	2026-03-25 08:47:25.283501+00
560	\N	Ausrüstung	Sternenkapuze	5 Sternensplitter	\N	f	Eufemia	2.500 Sternis	diy/equipment/Star head.png	2026-03-25 08:47:25.283501+00
561	\N	Ausrüstung	Sternchen-Pochette	6 Sternensplitter	\N	f	Eufemia	3.000 Sternis	diy/equipment/Star pochette.png	2026-03-25 08:47:25.283501+00
562	\N	Ausrüstung	Tragekorb	6 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	2.400 Sternis	diy/equipment/Basket pack.png	2026-03-25 08:47:25.283501+00
563	\N	Ausrüstung	Kirschblütenschirm	7 Kirschblüte	\N	f	Ballon (Kirschblüten)	2.800 Sternis	diy/equipment/Cherry-blossom umbrella.png	2026-03-25 08:47:25.283501+00
564	\N	Ausrüstung	Kirschblüten-Pochette	6 Kirschblüte	\N	f	Ballon (Kirschblüten)	2.400 Sternis	diy/equipment/Cherry-blossom pochette.png	2026-03-25 08:47:25.283501+00
565	\N	Ausrüstung	Muschel-Pochette	2 Riesenmuschel, 6 Sommermuschel	\N	f	Ballon (Sommermuschel)	10.800 Sternis	diy/equipment/Shellfish pochette.png	2026-03-25 08:47:25.283501+00
566	\N	Ausrüstung	Ahornschirm	7 Herbstblatt	\N	f	Ballon (Herbstblatt)	2.800 Sternis	diy/equipment/Maple-leaf umbrella.png	2026-03-25 08:47:25.283501+00
567	\N	Ausrüstung	Ahorn-Pochette	6 Herbstblatt	\N	f	Ballon (Herbstblatt)	2.400 Sternis	diy/equipment/Maple-leaf pochette.png	2026-03-25 08:47:25.283501+00
568	\N	Ausrüstung	Eichel-Pochette	6 Eichel	\N	f	Ballon (Baumfrucht)	2.400 Sternis	diy/equipment/Acorn pochette.png	2026-03-25 08:47:25.283501+00
569	\N	Ausrüstung	Pilzregenschirm	3 Flachpilz	\N	f	Ballon (Pilz)	1.200 Sternis	diy/equipment/Mush umbrella.png	2026-03-25 08:47:25.283501+00
570	\N	Ausrüstung	Schneemannhut	1 Riesenschneeflocke, 5 Schneeflocke	\N	f	Schnemil	7.000 Sternis	diy/equipment/Snowperson head.png	2026-03-25 08:47:25.283501+00
571	\N	Ausrüstung	Schneeflocken-Pochette	6 Schneeflocke	\N	f	Ballon (Schneeflocken)	2.400 Sternis	diy/equipment/Snowflake pochette.png	2026-03-25 08:47:25.283501+00
572	\N	Ausrüstung	Ornamentkrone	3 Rotschmuck, 3 Blauschmuck, 3 Goldschmuck	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	\N	diy/equipment/Ornament crown.png	2026-03-25 08:47:25.283501+00
573	\N	Ausrüstung	Anemonenkrone	2 Rotanemone, 2 Orangeanemone, 2 Weißanemone	\N	f	Nachbarn	480 Sternis	diy/equipment/Windflower crown.png	2026-03-25 08:47:25.283501+00
574	\N	Ausrüstung	Buntanemonenkrone	3 Blauanemone, 3 Pinkanemone	\N	f	Nachbarn	960 Sternis	diy/equipment/Cool windflower crown.png	2026-03-25 08:47:25.283501+00
575	\N	Ausrüstung	Purpuranemonenkrone	6 Purpuranemone	\N	f	Nachbarn	2.880 Sternis	diy/equipment/Purple windflower crown.png	2026-03-25 08:47:25.283501+00
576	\N	Ausrüstung	Chrysanthemenkrone	2 Rotchrysantheme, 2 Gelbchrysantheme, 2 Weißchrysantheme	\N	f	Nachbarn	480 Sternis	diy/equipment/Mum crown.png	2026-03-25 08:47:25.283501+00
577	\N	Ausrüstung	Edelchrysanthemenkrone	3 Lilachrysanthme, 3 Rosachrysanthme	\N	f	Nachbarn	960 Sternis	diy/equipment/Chic mum crown.png	2026-03-25 08:47:25.283501+00
578	\N	Ausrüstung	Grünchrysanthemenkrone	6 Grünchrysanthme	\N	f	Nachbarn	2.880 Sternis	diy/equipment/Simple mum crown.png	2026-03-25 08:47:25.283501+00
579	\N	Ausrüstung	Cosmeenkrone	2 Rotcosmea, 2 Gelbcosmea, 3 Weißcosmea	\N	f	Nachbarn	480 Sternis	diy/equipment/Cosmos crown.png	2026-03-25 08:47:25.283501+00
580	\N	Ausrüstung	Buntcosmeenkrone	4 Pinkcosmea, 3 Orangecosmea	\N	f	Nachbarn	1.120 Sternis	diy/equipment/Lovely cosmos crown.png	2026-03-25 08:47:25.283501+00
581	\N	Ausrüstung	Schwarzcosmeenkrone	7 Schwarzcosmea	\N	f	Nachbarn	3.360 Sternis	diy/equipment/Dark cosmos crown.png	2026-03-25 08:47:25.283501+00
582	\N	Ausrüstung	Tulpenkrone	2 Papageitulpe, 2 Viridifloratulpe, 1 Triumphtulpe	\N	f	Nachbarn	400 Sternis	diy/equipment/Tulip crown.png	2026-03-25 08:47:25.283501+00
583	\N	Ausrüstung	Edeltulpenkrone	2 Wildtulpe, 2 Grengjer-Tulpe, 1 Flachlandtulpe	\N	f	Nachbarn	1.440 Sternis	diy/equipment/Chic tulip crown.png	2026-03-25 08:47:25.283501+00
584	\N	Ausrüstung	Römertulpenkrone	5 Römertulpe	\N	f	Nachbarn	800 Sternis	diy/equipment/Dark tulip crown.png	2026-03-25 08:47:25.283501+00
585	\N	Ausrüstung	Rosenkrone	2 Liebesrose, 2 Bernsteinrose, 2 Unschuldrose	\N	f	Nachbarn	480 Sternis	diy/equipment/Rose crown.png	2026-03-25 08:47:25.283501+00
586	\N	Ausrüstung	Buntrosenkrone	3 Pinkrose, 3 Sonnenrose	\N	f	Nachbarn	960 Sternis	diy/equipment/Cute rose crown.png	2026-03-25 08:47:25.283501+00
587	\N	Ausrüstung	Edelrosenkrone	3 Lilarose, 3 Schwarzrose	\N	f	Nachbarn	2.880 Sternis	diy/equipment/Chic rose crown.png	2026-03-25 08:47:25.283501+00
588	\N	Ausrüstung	Blaurosenkrone	6 Blaurose	\N	f	Nachbarn	12.000 Sternis	diy/equipment/Blue rose crown.png	2026-03-25 08:47:25.283501+00
589	\N	Ausrüstung	Goldrosenkrone	6 Goldrose	\N	f	Nachbarn	12.000 Sternis	diy/equipment/Gold rose crown.png	2026-03-25 08:47:25.283501+00
590	\N	Ausrüstung	Veilchenkrone	2 Alpenveilchen, 2 Hornveilchen, 2 Pfingstveilchen	\N	f	Nachbarn	480 Sternis	diy/equipment/Pansy crown.png	2026-03-25 08:47:25.283501+00
591	\N	Ausrüstung	Buntveilchenkrone	3 Stiefmütterchen, 3 Duftveilchen	\N	f	Nachbarn	960 Sternis	diy/equipment/Cool pansy crown.png	2026-03-25 08:47:25.283501+00
592	\N	Ausrüstung	Hainveilchenkrone	6 Hainveilchen	\N	f	Nachbarn	2.880 Sternis	diy/equipment/Purple pansy crown.png	2026-03-25 08:47:25.283501+00
593	\N	Ausrüstung	Hyazinthenkrone	4 Rothyazinthe, 2 Gelbhyazinthe, 2 Weißhyazinthe	\N	f	Nachbarn	640 Sternis	diy/equipment/Hyacinth crown.png	2026-03-25 08:47:25.283501+00
594	\N	Ausrüstung	Bunthyazinthenkrone	4 Blauhyazinthe, 2 Rosahyazinthe, 2 Orangehyazinthe	\N	f	Nachbarn	1.280 Sternis	diy/equipment/Cool hyacinth crown.png	2026-03-25 08:47:25.283501+00
595	\N	Ausrüstung	Purpurhyazinthenkrone	6 Purpurhyazinthe	\N	f	Nachbarn	2.880 Sternis	diy/equipment/Purple hyacinth crown.png	2026-03-25 08:47:25.283501+00
596	\N	Ausrüstung	Lilienkrone	2 Rotlilie, 2 Pyrenäenlilie, 2 Osterlilie	\N	f	Nachbarn	480 Sternis	diy/equipment/Lily crown.png	2026-03-25 08:47:25.283501+00
597	\N	Ausrüstung	Buntlilienkrone	2 Türkenbundlilie, 2 Feuerlilie, 2 Osterlilie	\N	f	Nachbarn	800 Sternis	diy/equipment/Cute lily crown.png	2026-03-25 08:47:25.283501+00
598	\N	Ausrüstung	Dunkellilienkrone	6 Dunkellilie	\N	f	Nachbarn	960 Sternis	diy/equipment/Dark lily crown.png	2026-03-25 08:47:25.283501+00
599	\N	Ausrüstung	Erd-Eierschale	2 Erd-Glücksei	\N	f	mehrere Erd-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Earth-egg shell.png	2026-03-25 08:47:25.283501+00
600	\N	Ausrüstung	Erd-Glücksei-Outfit	3 Erd-Glücksei	\N	f	mehrere Erd-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Earth-egg outfit.png	2026-03-25 08:47:25.283501+00
601	\N	Ausrüstung	Paar Erd-Ei-Schuhe	2 Erd-Glücksei	\N	f	mehrere Erd-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Earth-egg shoes.png	2026-03-25 08:47:25.283501+00
602	\N	Ausrüstung	Fels-Eierschale	2 Fels-Glücksei	\N	f	mehrere Fels-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Stone-egg shell.png	2026-03-25 08:47:25.283501+00
603	\N	Ausrüstung	Fels-Glücksei-Outfit	3 Fels-Glücksei	\N	f	mehrere Fels-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Stone-egg outfit.png	2026-03-25 08:47:25.283501+00
604	\N	Ausrüstung	Paar Fels-Ei-Schuhe	2 Fels-Glücksei	\N	f	mehrere Fels-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Stone-egg shoes.png	2026-03-25 08:47:25.283501+00
605	\N	Ausrüstung	Laub-Eierschale	2 Laub-Glücksei	\N	f	mehrere Laub-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Leaf-egg shell.png	2026-03-25 08:47:25.283501+00
606	\N	Ausrüstung	Laub-Glücksei-Outfit	3 Laub-Glücksei	\N	f	mehrere Laub-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Leaf-egg outfit.png	2026-03-25 08:47:25.283501+00
607	\N	Ausrüstung	Paar Laub-Ei-Schuhe	2 Laub-Glücksei	\N	f	mehrere Laub-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Leaf-egg shoes.png	2026-03-25 08:47:25.283501+00
608	\N	Ausrüstung	Holz-Eierschale	2 Holz-Glücksei	\N	f	mehrere Holz-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Wood-egg shell.png	2026-03-25 08:47:25.283501+00
609	\N	Ausrüstung	Holz-Glücksei-Outfit	3 Holz-Glücksei	\N	f	mehrere Holz-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Wood-egg outfit.png	2026-03-25 08:47:25.283501+00
610	\N	Ausrüstung	Paar Holz-Ei-Schuhe	2 Holz-Glücksei	\N	f	mehrere Holz-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Wood-egg shoes.png	2026-03-25 08:47:25.283501+00
611	\N	Ausrüstung	Luft-Eierschale	2 Luft-Glücksei	\N	f	mehrere Luft-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Sky-egg shell.png	2026-03-25 08:47:25.283501+00
612	\N	Ausrüstung	Luft-Glücksei-Outfit	3 Luft-Glücksei	\N	f	mehrere Luft-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Sky-egg outfit.png	2026-03-25 08:47:25.283501+00
613	\N	Ausrüstung	Paar Luft-Ei-Schuhe	2 Luft-Glücksei	\N	f	mehrere Luft-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Sky-egg shoes.png	2026-03-25 08:47:25.283501+00
614	\N	Ausrüstung	Wasser-Eierschale	2 Wasser-Glücksei	\N	f	mehrere Wasser-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Water-egg shell.png	2026-03-25 08:47:25.283501+00
615	\N	Ausrüstung	Wasser-Glücksei-Outfit	3 Wasser-Glücksei	\N	f	mehrere Wasser-Glückseier einsammeln (Häschentag)	1.200 Sternis	diy/equipment/Water-egg outfit.png	2026-03-25 08:47:25.283501+00
616	\N	Ausrüstung	Paar Wasser-Ei-Schuhe	2 Wasser-Glücksei	\N	f	mehrere Wasser-Glückseier einsammeln (Häschentag)	800 Sternis	diy/equipment/Water-egg shoes.png	2026-03-25 08:47:25.283501+00
617	\N	Ausrüstung	Glücksei-Partyhut	2 Erd-Glücksei, 2 Fels-Glücksei, 2 Laub-Glücksei, 2 Holz-Glücksei, 2 Luft-Glücksei, 2 Wasser-Glücksei	\N	f	alle Outfit-Teile der 6 Eier-Typen (Häschentag)	4.800 Sternis	diy/equipment/Egg party hat.png	2026-03-25 08:47:25.283501+00
618	\N	Ausrüstung	Glücksei-Abendkleid	3 Erd-Glücksei, 3 Fels-Glücksei, 3 Laub-Glücksei, 3 Holz-Glücksei, 3 Luft-Glücksei, 3 Wasser-Glücksei	\N	f	alle Outfit-Teile der 6 Eier-Typen (Häschentag)	7.200 Sternis	diy/equipment/Egg party dress.png	2026-03-25 08:47:25.283501+00
619	\N	Ausrüstung	Häschentag-Krone	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Nachbar (Häschentag)	2.400 Sternis	diy/equipment/Bunny Day crown.png	2026-03-25 08:47:25.283501+00
620	\N	Ausrüstung	Häschentag-Rucksack	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Nachbar (Häschentag)	2.400 Sternis	diy/equipment/Bunny Day bag.png	2026-03-25 08:47:25.283501+00
621	\N	Einrichtung	Gitterstäbe	5 Eisenerz	\N	f	Nachbarn (Miesepeter)	3.750 Sternis	diy/Housewares/Jail bars.png	2026-03-25 09:07:51.635163+00
622	\N	Einrichtung	Langhantel	10 Eisenerz	\N	f	Nachbarn (Sportlich)	7.500 Sternis	diy/Housewares/Barbell.png	2026-03-25 09:07:51.635163+00
623	\N	Einrichtung	Stahlträger	20 Eisenerz	\N	f	Nachbarn (Miesepeter)	15.000 Sternis	diy/Housewares/Iron frame.png	2026-03-25 09:07:51.635163+00
624	\N	Einrichtung	Kesselbad	8 Eisenerz, 2 Holz, 1 Lagerfeuer	\N	f	Nachbarn (Miesepeter)	6.330 Sternis	diy/Housewares/Kettle bathtub.png	2026-03-25 09:07:51.635163+00
625	\N	Einrichtung	Kanaldeckel	3 Eisenerz	\N	f	NookPortal	2.250 Sternis	diy/Housewares/Manhole cover.png	2026-03-25 09:07:51.635163+00
626	\N	Einrichtung	Ritterrüstung	10 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	7.500 Sternis	diy/Housewares/Plate armor.png	2026-03-25 09:07:51.635163+00
627	\N	Einrichtung	Eisen-Holz-Stuhl	3 Holz, 2 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	1.860 Sternis	diy/Housewares/Ironwood chair.png	2026-03-25 09:07:51.635163+00
628	\N	Einrichtung	Eisen-Holz-Rollwagen	6 Holz, 4 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	3.720 Sternis	diy/Housewares/Ironwood cart.png	2026-03-25 09:07:51.635163+00
629	\N	Einrichtung	Eisen-Holz-Kommode	7 Holz, 4 Eisenerz	\N	f	Nachbarn (Hochnäsig)	3.840 Sternis	diy/Housewares/Ironwood dresser.png	2026-03-25 09:07:51.635163+00
630	\N	Einrichtung	Eisen-Holz-Tisch	12 Holz, 6 Eisenerz	\N	f	Nachbarn (Miesepeter)	5.940 Sternis	diy/Housewares/Ironwood table.png	2026-03-25 09:07:51.635163+00
631	\N	Einrichtung	Eisen-Holz-Sofatisch	6 Holz, 4 Eisenerz	\N	f	Nachbarn (Hochnäsig)	3.720 Sternis	diy/Housewares/Ironwood low table.png	2026-03-25 09:07:51.635163+00
632	\N	Einrichtung	Eisen-Holz-Bett	20 Holz, 10 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	9.900 Sternis	diy/Housewares/Ironwood bed.png	2026-03-25 09:07:51.635163+00
633	\N	Einrichtung	Heldenroboter	1 Rakete, 1 Goldrüstung, 30 Rost-Bauteil, 90 Eisenerz, 10 Golderz	\N	f	NookPortal	250.000 Sternis	diy/Housewares/Robot hero.png	2026-03-25 09:07:51.635163+00
634	\N	Einrichtung	Widder-Schaukelstuhl	3 Sternensplitter, 2 Widder-Splitter, 1 Golderz, 5 Stein	\N	f	Eufemia	12.125 Sternis	diy/Housewares/Aries rocking chair.png	2026-03-25 09:07:51.635163+00
635	\N	Einrichtung	Stier-Badewanne	3 Sternensplitter, 2 Stier-Splitter, 1 Golderz, 8 Stein	\N	f	Eufemia	12.500 Sternis	diy/Housewares/Taurus bathtub.png	2026-03-25 09:07:51.635163+00
636	\N	Einrichtung	Zwillinge-Schrank	3 Sternensplitter, 2 Zwillinge-Splitter, 2 Golderz, 6 Stein	\N	f	Eufemia	22.150 Sternis	diy/Housewares/Gemini closet.png	2026-03-25 09:07:51.635163+00
637	\N	Einrichtung	Krebs-Tisch	3 Sternensplitter, 2 Krebs-Splitter, 2 Golderz, 3 Stein	\N	f	Eufemia	21.975 Sternis	diy/Housewares/Cancer table.png	2026-03-25 09:07:51.635163+00
638	\N	Einrichtung	Jungfrau-Harfe	3 Sternensplitter, 2 Jungfrau-Splitter, 2 Golderz, 4 Stein	\N	f	Eufemia	22.050 Sternis	diy/Housewares/Virgo harp.png	2026-03-25 09:07:51.635163+00
639	\N	Einrichtung	Steinbock-Ornament	3 Sternensplitter, 2 Steinbock-Splitter, 2 Golderz, 12 Stein	\N	f	Eufemia	22.650 Sternis	diy/Housewares/Capricorn ornament.png	2026-03-25 09:07:51.635163+00
640	\N	Einrichtung	Wassermann-Krug	3 Sternensplitter, 2 Wassermann-Splitter, 2 Golderz, 5 Stein	\N	f	Eufemia	22.125 Sternis	diy/Housewares/Aquarius urn.png	2026-03-25 09:07:51.635163+00
641	\N	Einrichtung	Fische-Lampe	3 Sternensplitter, 2 Fische-Splitter, 2 Golderz, 4 Stein	\N	f	Eufemia	22.050 Sternis	diy/Housewares/Pisces lamp.png	2026-03-25 09:07:51.635163+00
642	\N	Einrichtung	Bambussitzbank	8 Bambus	\N	f	Nachbarn (Ausgeglichen)	1.280 Sternis	diy/Housewares/Bamboo bench.png	2026-03-25 09:07:51.635163+00
643	\N	Einrichtung	Bambus-Wandschirm	7 Bambus, 6 Stein	\N	f	Nachbarn (Miesepeter)	2.020 Sternis	diy/Housewares/Bamboo partition.png	2026-03-25 09:07:51.635163+00
644	\N	Einrichtung	Bambusregal	15 Bambus	\N	f	Nachbarn (Hochnäsig)	2.400 Sternis	diy/Housewares/Bamboo shelf.png	2026-03-25 09:07:51.635163+00
645	\N	Einrichtung	Bambuskörbchen	7 Bambus	\N	f	Nachbarn (Hochnäsig)	1.120 Sternis	diy/Housewares/Bamboo basket.png	2026-03-25 09:07:51.635163+00
646	\N	Einrichtung	Bambuslautsprecher	3 Bambus, 1 Eisenerz	\N	f	Nachbarn (Hochnäsig)	1.230 Sternis	diy/Housewares/Bamboo speaker.png	2026-03-25 09:07:51.635163+00
647	\N	Einrichtung	Bambus-Stehlampe	8 Bambus	\N	f	Nachbarn (Ausgeglichen)	1.280 Sternis	diy/Housewares/Bamboo floor lamp.png	2026-03-25 09:07:51.635163+00
648	\N	Einrichtung	Bambushocker	5 Bambus	\N	f	Nachbarn (Hochnäsig)	800 Sternis	diy/Housewares/Bamboo stool.png	2026-03-25 09:07:51.635163+00
649	\N	Einrichtung	Bambus-Absperrblock	3 Bambus	\N	f	Nachbarn (Sportlich)	480 Sternis	diy/Housewares/Bamboo stopblock.png	2026-03-25 09:07:51.635163+00
650	\N	Einrichtung	Bambuspuppe	6 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	2.400 Sternis	diy/Housewares/Bamboo doll.png	2026-03-25 09:07:51.635163+00
651	\N	Einrichtung	Bambus-Nudelrutsche	7 Frühlingsbambus, 3 Holz	\N	f	Ballon (Frühlingsbambus)	3.160 Sternis	diy/Housewares/Bamboo noodle slide.png	2026-03-25 09:07:51.635163+00
652	\N	Einrichtung	Hirschschreck	3 Bambus, 8 Stein, 3 Unkraut	\N	f	Nachbarn (Miesepeter)	1.740 Sternis	diy/Housewares/Deer scare.png	2026-03-25 09:07:51.635163+00
653	\N	Einrichtung	Kirschblütenhaufen	5 Kirschblüte	\N	f	Ballon (Kirschblüten)	2.000 Sternis	diy/Housewares/Cherry-blossom-petal pile.png	2026-03-25 09:07:51.635163+00
654	\N	Einrichtung	Kirschblütenzweige	8 Kirschblüte, 4 Ast, 5 Lehm	\N	f	Ballon (Kirschblüten)	4.240 Sternis	diy/Housewares/Cherry-blossom branches.png	2026-03-25 09:07:51.635163+00
655	\N	Einrichtung	Picknick-Set	10 Kirschblüte	\N	f	Ballon (Kirschblüten), Melinda (Kirschblüten)	4.000 Sternis	diy/Housewares/Outdoor picnic set.png	2026-03-25 09:07:51.635163+00
656	\N	Einrichtung	Blütenlaterne	6 Kirschblüte, 4 Hartholz	\N	f	Ballon (Kirschblüten)	2.880 Sternis	diy/Housewares/Blossom-viewing lantern.png	2026-03-25 09:07:51.635163+00
657	\N	Einrichtung	Muschelbett	5 Riesenmuschel, 3 Lehm, 4 Stein	\N	f	Nachbarn (Schwungvoll)	10.200 Sternis	diy/Housewares/Shell bed.png	2026-03-25 09:07:51.635163+00
658	\N	Einrichtung	Muschelhocker	5 Kaurischnecke	\N	f	Nachbarn (Große Schwester)	600 Sternis	diy/Housewares/Shell stool.png	2026-03-25 09:07:51.635163+00
659	\N	Einrichtung	Muscheltisch	7 Sanddollar, 3 Lehm	\N	f	Nachbarn (Schwungvoll)	2.280 Sternis	diy/Housewares/Shell table.png	2026-03-25 09:07:51.635163+00
660	\N	Einrichtung	Muscheltrennwand	4 Stachelschnecke, 4 Kreiselschnecke	\N	f	Nachbarn (Große Schwester)	8.000 Sternis	diy/Housewares/Shell partition.png	2026-03-25 09:07:51.635163+00
661	\N	Einrichtung	Muschel-Springbrunnen	5 Riesenmuschel, 3 Stein	\N	f	Nachbarn (Schlafmütze)	9.450 Sternis	diy/Housewares/Shell fountain.png	2026-03-25 09:07:51.635163+00
662	\N	Einrichtung	Muscheltor	3 Stachelschnecke, 3 Kreiselschnecke, 3 Sanddollar, 3 Koralle, 3 Riesenmuschel, 3 Kaurischnecke	\N	f	Nachbarn (Schlafmütze)	12.360 Sternis	diy/Housewares/Shell arch.png	2026-03-25 09:07:51.635163+00
663	\N	Einrichtung	Nixen-Bett	2 Perle, 2 Riesenmuschel, 5 Sanddollar	\N	f	Johannes	22.000 Sternis	diy/Housewares/Mermaid bed.png	2026-03-25 09:07:51.635163+00
664	\N	Einrichtung	Nixen-Lampe	1 Perle, 3 Kreiselschnecke, 2 Koralle, 2 Eisenerz	\N	f	Johannes	12.700 Sternis	diy/Housewares/Mermaid lamp.png	2026-03-25 09:07:51.635163+00
665	\N	Einrichtung	Nixen-Regal	1 Perle, 1 Riesenmuschel, 4 Koralle	\N	f	Johannes	11.800 Sternis	diy/Housewares/Mermaid shelf.png	2026-03-25 09:07:51.635163+00
666	\N	Einrichtung	Nixen-Paravent	2 Perle, 3 Riesenmuschel, 5 Sanddollar	\N	f	Johannes	22.700 Sternis	diy/Housewares/Mermaid screen.png	2026-03-25 09:07:51.635163+00
667	\N	Einrichtung	Nixen-Spiegel	1 Perle, 1 Riesenmuschel, 2 Koralle, 2 Eisenerz	\N	f	Johannes	13.500 Sternis	diy/Housewares/Mermaid vanity.png	2026-03-25 09:07:51.635163+00
668	\N	Einrichtung	Nixen-Tisch	1 Perle, 4 Sanddollar	\N	f	Johannes	11.600 Sternis	diy/Housewares/Mermaid table.png	2026-03-25 09:07:51.635163+00
669	\N	Einrichtung	Nixen-Schrank	2 Perle, 1 Riesenmuschel, 2 Koralle, 5 Sanddollar	\N	f	Johannes	22.900 Sternis	diy/Housewares/Mermaid closet.png	2026-03-25 09:07:51.635163+00
670	\N	Einrichtung	Nixen-Sofa	1 Perle, 10 Sanddollar	\N	f	Johannes	18.000 Sternis	diy/Housewares/Mermaid sofa.png	2026-03-25 09:07:51.635163+00
671	\N	Einrichtung	Nixen-Kommode	2 Perle, 1 Riesenmuschel, 3 Koralle	\N	f	Johannes	21.300 Sternis	diy/Housewares/Mermaid dresser.png	2026-03-25 09:07:51.635163+00
672	\N	Einrichtung	Nixen-Stuhl	1 Perle, 1 Riesenmuschel, 2 Sanddollar	\N	f	Johannes	11.800 Sternis	diy/Housewares/Mermaid chair.png	2026-03-25 09:07:51.635163+00
673	\N	Einrichtung	Laubhaufen in Gelb	3 Eichel, 5 Unkraut	\N	f	Ballon (Baumfrucht)	1.300 Sternis	diy/Housewares/Yellow-leaf pile.png	2026-03-25 09:07:51.635163+00
674	\N	Einrichtung	Laubhaufen in Rot	3 Herbstblatt, 4 Unkraut	\N	f	Ballon (Herbstblatt), Melinda (Herbstblatt)	1.280 Sternis	diy/Housewares/Red-leaf pile.png	2026-03-25 09:07:51.635163+00
675	\N	Einrichtung	Laubhaufen	3 Zapfen, 5 Unkraut	\N	f	Ballon (Baumfrucht)	1.300 Sternis	diy/Housewares/Pile of leaves.png	2026-03-25 09:07:51.635163+00
676	\N	Einrichtung	Laub-Lagerfeuer	3 Zapfen, 5 Unkraut, 3 Ast	\N	f	Ballon (Baumfrucht)	1.330 Sternis	diy/Housewares/Leaf campfire.png	2026-03-25 09:07:51.635163+00
677	\N	Einrichtung	Laubhocker	3 Herbstblatt, 3 Holz	\N	f	Ballon (Herbstblatt)	1.560 Sternis	diy/Housewares/Leaf stool.png	2026-03-25 09:07:51.635163+00
678	\N	Einrichtung	Eisskulptur	1 Riesenschneeflocke, 4 Schneeflocke	\N	f	Schnemil	6.200 Sternis	diy/Housewares/Frozen sculpture.png	2026-03-25 09:07:51.635163+00
679	\N	Einrichtung	Eisbaum	1 Riesenschneeflocke, 8 Schneeflocke	\N	f	Schnemil	6.200 Sternis	diy/Housewares/Frozen tree.png	2026-03-25 09:07:51.635163+00
680	\N	Einrichtung	Drei-Stufen-Schneemann	1 Riesenschneeflocke, 6 Schneeflocke, 2 Ast	\N	f	Schnemil	6.260 Sternis	diy/Housewares/Three-tiered snowperson.png	2026-03-25 09:07:51.635163+00
681	\N	Einrichtung	Tannenbäumchen	3 Rotschmuck, 3 Blauschmuck, 2 Goldschmuck, 5 Holz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	1.400 Sternis	diy/Housewares/Festive tree.png	2026-03-25 09:07:51.635163+00
682	\N	Einrichtung	Tannenbaum	6 Rotschmuck, 6 Blauschmuck, 4 Goldschmuck, 5 Holz, 5 Lehm	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	3.200 Sternis	diy/Housewares/Big festive tree.png	2026-03-25 09:07:51.635163+00
683	\N	Einrichtung	Leuchtschnee	9 Blauschmuck, 3 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	3.150 Sternis	diy/Housewares/Illuminated snowflakes.png	2026-03-25 09:07:51.635163+00
684	\N	Einrichtung	Leuchtgeschenk	3 Rotschmuck, 4 Goldschmuck, 3 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	2.550 Sternis	diy/Housewares/Illuminated present.png	2026-03-25 09:07:51.635163+00
685	\N	Einrichtung	Leucht-Rentier	6 Goldschmuck, 5 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	5.750 Sternis	diy/Housewares/Illuminated reindeer.png	2026-03-25 09:07:51.635163+00
686	\N	Einrichtung	Leuchtbaum	8 Rotschmuck, 8 Blauschmuck, 6 Goldschmuck, 6 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	5.500 Sternis	diy/Housewares/Illuminated tree.png	2026-03-25 09:07:51.635163+00
687	\N	Einrichtung	Geschenkeberg	3 Rot-Geschenkpapier, 1 Bauklotzset, 1 Karton	\N	f	Chris	3.840 Sternis	diy/Housewares/Gift pile.png	2026-03-25 09:07:51.635163+00
688	\N	Einrichtung	Dekobaum	3 Rotschmuck, 2 Blauschmuck, 1 Goldschmuck, 3 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	3.150 Sternis	diy/Housewares/Ornament tree.png	2026-03-25 09:07:51.635163+00
689	\N	Einrichtung	Riesenschmuck	10 Rotschmuck	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	5.000 Sternis	diy/Housewares/Giant ornament.png	2026-03-25 09:07:51.635163+00
690	\N	Einrichtung	Dekogirlande	2 Rotschmuck, 2 Blauschmuck, 2 Goldschmuck, 5 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	4.750 Sternis	diy/Housewares/Ornament garland.png	2026-03-25 09:07:51.635163+00
691	\N	Einrichtung	Chrysanthemenkissen	3 Gelbchrysantheme, 10 Unkraut	\N	f	Nachbarn (Schwungvoll)	360 Sternis	diy/Housewares/Mum cushion.png	2026-03-25 09:07:51.635163+00
692	\N	Einrichtung	Cosmeadusche	5 Rosacosmea, 3 Eisenerz	\N	f	Nachbarn (Hochnäsig)	3.050 Sternis	diy/Housewares/Cosmos shower.png	2026-03-25 09:07:51.635163+00
693	\N	Einrichtung	Überraschungstulpe	5 Rottulpe, 3 Weichholz	\N	f	Nachbarn (Sportlich)	760 Sternis	diy/Housewares/Tulip surprise box.png	2026-03-25 09:07:51.635163+00
694	\N	Einrichtung	Rosenbett	10 Rotrose, 5 Holz	\N	f	Nachbarn (Selbstzufrieden)	1.400 Sternis	diy/Housewares/Rose bed.png	2026-03-25 09:07:51.635163+00
695	\N	Einrichtung	Stiefmütterchentisch	5 Gelbveilchen, 3 Hartholz	\N	f	Nachbarn (Ausgeglichen)	760 Sternis	diy/Housewares/Pansy table.png	2026-03-25 09:07:51.635163+00
696	\N	Einrichtung	Liliengrammofon	5 Weißlilie, 3 Eisenerz, 3 Holz	\N	f	Nachbarn (Miesepeter)	2.820 Sternis	diy/Housewares/Lily record player.png	2026-03-25 09:07:51.635163+00
697	\N	Einrichtung	Blumenständer	1 Rotrose, 2 Rosarose, 2 Orangerose, 2 Weißlilie, 1 Gelblilie, 4 Lila-Anemone	\N	f	Nachbarn (Große Schwester)	2.880 Sternis	diy/Housewares/Flower stand.png	2026-03-25 09:07:51.635163+00
698	\N	Einrichtung	Häschentag-Hocker	3 Wasser-Glücksei	\N	f	Häschentag-Ballon	1.200 Sternis	diy/Housewares/Bunny Day stool.png	2026-03-25 09:07:51.635163+00
699	\N	Einrichtung	Häschentag-Tisch	4 Erd-Glücksei	\N	f	Häschentag-Ballon	1.600 Sternis	diy/Housewares/Bunny Day table.png	2026-03-25 09:07:51.635163+00
700	\N	Einrichtung	Häschentag-Schrank	4 Fels-Glücksei	\N	f	Häschentag-Ballon	1.600 Sternis	diy/Housewares/Bunny Day wardrobe.png	2026-03-25 09:07:51.635163+00
701	\N	Einrichtung	Häschentag-Frisiertisch	4 Laub-Glücksei	\N	f	Häschentag-Ballon	1.600 Sternis	diy/Housewares/Bunny Day vanity.png	2026-03-25 09:07:51.635163+00
702	\N	Einrichtung	Häschentag-Bett	1 von jedem Glücksei (Erd, Fels, Laub, Holz, Luft, Wasser)	\N	f	Ohs (7 Tage vor dem Häschentag)	2.400 Sternis	diy/Housewares/Bunny Day bed.png	2026-03-25 09:07:51.635163+00
703	\N	Einrichtung	Häschentag-Ballon-Deko A	1 Erd-Glücksei, 1 Laub-Glücksei, 1 Luft-Glücksei	\N	f	Häschentag-Ballon	1.200 Sternis	diy/Housewares/Bunny Day merry balloons.png	2026-03-25 09:07:51.635163+00
704	\N	Einrichtung	Häschentag-Ballon-Deko B	1 Fels-Glücksei, 1 Holz-Glücksei, 1 Wasser-Glücksei	\N	f	Häschentag-Ballon	1.200 Sternis	diy/Housewares/Bunny Day festive balloons.png	2026-03-25 09:07:51.635163+00
705	\N	Einrichtung	Häschentag-Tor	2 von jedem Glücksei (Erd, Fels, Laub, Holz, Luft, Wasser)	\N	f	Ohs (Häschentag)	4.800 Sternis	diy/Housewares/Bunny Day arch.png	2026-03-25 09:07:51.635163+00
706	\N	Einrichtung	Obskuraltar	30 Stein	\N	f	Nachbarn (Selbstzufrieden)	4.500 Sternis	diy/Housewares/Forbidden altar.png	2026-03-25 09:07:51.635163+00
707	\N	Einrichtung	Eisenwandschrank	12 Eisenerz	\N	f	Nachbarn (Miesepeter)	9.000 Sternis	diy/Housewares/Iron closet.png	2026-03-25 09:07:51.635163+00
708	\N	Einrichtung	Eisengartenbank	8 Eisenerz	\N	f	Nachbarn (Schwungvoll)	6.000 Sternis	diy/Housewares/Iron garden bench.png	2026-03-25 09:07:51.635163+00
709	\N	Einrichtung	Eisengartenstuhl	3 Eisenerz	\N	f	Nachbarn (Schwungvoll)	2.250 Sternis	diy/Housewares/Iron garden chair.png	2026-03-25 09:07:51.635163+00
710	\N	Einrichtung	Eisengartentisch	5 Eisenerz	\N	f	Nachbarn (Schwungvoll)	3.750 Sternis	diy/Housewares/Iron garden table.png	2026-03-25 09:07:51.635163+00
711	\N	Einrichtung	Eisen-Kleiderständer	3 Eisenerz	\N	f	Nachbarn (Große Schwester)	2.250 Sternis	diy/Housewares/Iron hanger stand.png	2026-03-25 09:07:51.635163+00
712	\N	Einrichtung	Eisenregal	14 Eisenerz	\N	f	Nachbarn (Miesepeter)	10.500 Sternis	diy/Housewares/Iron shelf.png	2026-03-25 09:07:51.635163+00
713	\N	Einrichtung	Eisen-Arbeitstisch	10 Eisenerz	\N	f	Nachbarn (Große Schwester)	7.500 Sternis	diy/Housewares/Iron worktable.png	2026-03-25 09:07:51.635163+00
714	\N	Einrichtung	Schirmständer	3 Eisenerz	\N	f	Nachbarn (Große Schwester)	2.250 Sternis	diy/Housewares/Standard umbrella stand.png	2026-03-25 09:07:51.635163+00
715	\N	Sonstiges	Medizin	1 Wespennest, 3 Unkraut	\N	f	von einem Nachbarn, nachdem du von Wespen gestochen wurdest	100 Sternis	diy/other/Medicine.png	2026-03-25 09:19:25.175062+00
716	\N	Sonstiges	Köder	1 Teppichmuschel	\N	f	Teppichmuschel am Strand ausgraben	200 Sternis	diy/other/Fish bait.png	2026-03-25 09:19:25.175062+00
717	\N	Sonstiges	Okarina	5 Lehm	\N	f	„Mein erstes Bastelbuch“ aus Nooks Laden	1.000 Sternis	diy/other/Ocarina.png	2026-03-25 09:19:25.175062+00
718	\N	Sonstiges	Panflöte	7 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	2.800 Sternis	diy/other/Pan flute.png	2026-03-25 09:19:25.175062+00
719	\N	Sonstiges	Falle	4 Unkraut, 6 Ast	\N	f	Falle ausgraben, Nooks Laden	140 Sternis	diy/other/Pitfall seed.png	2026-03-25 09:19:25.175062+00
720	\N	Sonstiges	Zweig	3 Ast	\N	f	Nachbarn (Ausgeglichen)	\N	diy/other/Nice branch.png	2026-03-25 09:19:25.175062+00
721	\N	Sonstiges	Weidezaun	6 Holz	\N	f	NookPortal	72 Sternis	diy/other/Corral fence.png	2026-03-25 09:19:25.175062+00
722	\N	Sonstiges	Bretterzaun	8 Holz	\N	f	NookPortal	96 Sternis	diy/other/Vertical-board fence.png	2026-03-25 09:19:25.175062+00
723	\N	Sonstiges	Baumstammzaun	6 Hartholz	\N	f	NookPortal	72 Sternis	diy/other/Country fence.png	2026-03-25 09:19:25.175062+00
724	\N	Sonstiges	Spitzpfostenzaun	8 Hartholz	\N	f	NookPortal	96 Sternis	diy/other/Spiky fence.png	2026-03-25 09:19:25.175062+00
725	\N	Sonstiges	Stacheldrahtzaun	4 Hartholz, 2 Eisenerz	\N	f	NookPortal	198 Sternis	diy/other/Barbed-wire fence.png	2026-03-25 09:19:25.175062+00
726	\N	Sonstiges	Baumstammwandzaun	10 Hartholz	\N	f	NookPortal	\N	diy/other/Log-wall fence.png	2026-03-25 09:19:25.175062+00
727	\N	Sonstiges	Westernzaun	6 Weichholz	\N	f	NookPortal	\N	diy/other/Log fence.png	2026-03-25 09:19:25.175062+00
728	\N	Sonstiges	Standard-Holzzaun	6 Weichholz	\N	f	NookPortal	72 Sternis	diy/other/Simple wooden fence.png	2026-03-25 09:19:25.175062+00
729	\N	Sonstiges	Gitterzaun	8 Weichholz	\N	f	NookPortal	96 Sternis	diy/other/Lattice fence.png	2026-03-25 09:19:25.175062+00
730	\N	Sonstiges	Riesengitterzaun	10 Weichholz	\N	f	„Zäuneverzaubern-Abc“ vom NookPortal	\N	diy/other/Large lattice fence.png	2026-03-25 09:19:25.175062+00
731	\N	Sonstiges	Asienzaun	6 Holz, 4 Weichholz	\N	f	NookPortal	120 Sternis	diy/other/Imperial fence.png	2026-03-25 09:19:25.175062+00
732	\N	Sonstiges	Raumteiler	3 Holz, 3 Lehm	\N	f	8 Häuser einrichten (HHP)	\N	diy/other/Partition wall.png	2026-03-25 09:19:25.175062+00
733	\N	Sonstiges	Hoch-Holzinseltheke	3 Holz, 3 Hartholz, 3 Weichholz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall wooden island counter.png	2026-03-25 09:19:25.175062+00
734	\N	Sonstiges	Niedrig-Holzinseltheke	2 Holz, 2 Hartholz, 2 Weichholz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low wooden island counter.png	2026-03-25 09:19:25.175062+00
735	\N	Sonstiges	Holzsäule	2 Holz, 2 Hartholz, 2 Weichholz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Wooden pillar.png	2026-03-25 09:19:25.175062+00
736	\N	Sonstiges	Ziegelsteinmauer	6 Lehm	\N	f	NookPortal	120 Sternis	diy/other/Brick fence.png	2026-03-25 09:19:25.175062+00
737	\N	Sonstiges	Hoch-Ziegelinseltheke	8 Lehm	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall brick island counter.png	2026-03-25 09:19:25.175062+00
738	\N	Sonstiges	Niedrig-Ziegelinseltheke	4 Lehm	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low brick island counter.png	2026-03-25 09:19:25.175062+00
739	\N	Sonstiges	Ziegelsäule	4 Lehm	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Brick pillar.png	2026-03-25 09:19:25.175062+00
740	\N	Sonstiges	Hoch-Schlichtinseltheke	4 Lehm, 4 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall simple island counter.png	2026-03-25 09:19:25.175062+00
741	\N	Sonstiges	Niedrig-Schlichtinseltheke	2 Lehm, 2 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low simple island counter.png	2026-03-25 09:19:25.175062+00
742	\N	Sonstiges	Schlichtsäule	2 Lehm, 2 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Simple pillar.png	2026-03-25 09:19:25.175062+00
743	\N	Sonstiges	Feldsteinmauer	4 Stein	\N	f	NookPortal	60 Sternis	diy/other/Stone fence.png	2026-03-25 09:19:25.175062+00
744	\N	Sonstiges	Villenzaun	6 Stein, 3 Eisenerz	\N	f	NookPortal	315 Sternis	diy/other/Iron-and-stone fence.png	2026-03-25 09:19:25.175062+00
745	\N	Sonstiges	Betonmauer	8 Stein, 2 Eisenerz	\N	f	NookPortal	\N	diy/other/Block fence.png	2026-03-25 09:19:25.175062+00
746	\N	Sonstiges	Japanmauer	3 Eisenerz, 3 Lehm, 3 Stein	\N	f	NookPortal	330 Sternis	diy/other/Zen fence.png	2026-03-25 09:19:25.175062+00
747	\N	Sonstiges	Hoch-Betoninseltheke	6 Stein, 2 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall concrete island counter.png	2026-03-25 09:19:25.175062+00
748	\N	Sonstiges	Niedrig-Betoninseltheke	3 Stein, 1 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low concrete island counter.png	2026-03-25 09:19:25.175062+00
749	\N	Sonstiges	Betonsäule	3 Stein, 1 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Concrete pillar.png	2026-03-25 09:19:25.175062+00
750	\N	Sonstiges	Hoch-Marmorinseltheke	16 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall marble island counter.png	2026-03-25 09:19:25.175062+00
751	\N	Sonstiges	Niedrig-Marmorinseltheke	8 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low marble island counter.png	2026-03-25 09:19:25.175062+00
752	\N	Sonstiges	Marmorsäule	8 Stein	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Marble pillar.png	2026-03-25 09:19:25.175062+00
753	\N	Sonstiges	Seilzaun	4 Eisenerz	\N	f	NookPortal	300 Sternis	diy/other/Rope fence.png	2026-03-25 09:19:25.175062+00
754	\N	Sonstiges	Eisenzaun	6 Eisenerz	\N	f	NookPortal	450 Sternis	diy/other/Iron fence.png	2026-03-25 09:19:25.175062+00
755	\N	Sonstiges	Hochzeitsabsperrung	5 Eisenerz, 3 Weichholz	\N	f	Hochzeitssaison	411 Sternis	diy/other/Wedding fence.png	2026-03-25 09:19:25.175062+00
756	\N	Sonstiges	Parkzaun	5 Eisenerz	\N	f	„Zäuneverzaubern-Abc“ vom NookPortal	\N	diy/other/Park fence.png	2026-03-25 09:19:25.175062+00
757	\N	Sonstiges	Blechzaun	3 Eisenerz, 3 Hartholz	\N	f	NookPortal	\N	diy/other/Corrugated iron fence.png	2026-03-25 09:19:25.175062+00
758	\N	Sonstiges	Hoch-Stahlinseltheke	8 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall steel island counter.png	2026-03-25 09:19:25.175062+00
759	\N	Sonstiges	Niedrig-Stahlinseltheke	4 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low steel island counter.png	2026-03-25 09:19:25.175062+00
760	\N	Sonstiges	Stahlsäule	4 Eisenerz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Steel pillar.png	2026-03-25 09:19:25.175062+00
761	\N	Sonstiges	Hoch-Goldinseltheke	8 Golderz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Tall golden island counter.png	2026-03-25 09:19:25.175062+00
762	\N	Sonstiges	Niedrig-Goldinseltheke	4 Golderz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Low golden island counter.png	2026-03-25 09:19:25.175062+00
763	\N	Sonstiges	Goldsäule	4 Golderz	\N	f	Bonos Werkstoffkiste (HHP)	\N	diy/other/Golden pillar.png	2026-03-25 09:19:25.175062+00
764	\N	Sonstiges	Strohzaun	10 Unkraut, 3 Holz	\N	f	NookPortal	56 Sternis	diy/other/Straw fence.png	2026-03-25 09:19:25.175062+00
765	\N	Sonstiges	Hecke	10 Unkraut, 5 Ast, 2 Stein	\N	f	Gerd	55 Sternis	diy/other/Hedge.png	2026-03-25 09:19:25.175062+00
766	\N	Sonstiges	Fuchsschwanzgras	3 Unkraut	\N	f	Nachbarn (Schwungvoll)	\N	diy/other/Foxtail.png	2026-03-25 09:19:25.175062+00
767	\N	Sonstiges	Bambuszaun	6 Bambus	\N	f	NookPortal	96 Sternis	diy/other/Bamboo lattice fence.png	2026-03-25 09:19:25.175062+00
768	\N	Sonstiges	Grün-Bambuszaun	6 Bambus	\N	f	NookPortal	\N	diy/other/Green bamboo fence.png	2026-03-25 09:19:25.175062+00
769	\N	Sonstiges	Bambus-Lamellenzaun	3 Bambus	\N	f	NookPortal	\N	diy/other/Bamboo-slats fence.png	2026-03-25 09:19:25.175062+00
770	\N	Sonstiges	Nixenzaun	1 Perle, 5 Koralle, 5 Sanddollar	\N	f	Johannes	\N	diy/other/Mermaid fence.png	2026-03-25 09:19:25.175062+00
771	\N	Sonstiges	Kürbiszaun	3 Orangekürbis, 5 Eisenerz	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/other/Spooky fence.png	2026-03-25 09:19:25.175062+00
772	\N	Sonstiges	Kürbis-Naschkorb	1 Orangekürbis, 2 Bonbon	\N	f	Nachbarn (Oktober), Nachbarn (Halloween)	\N	diy/other/Spooky treats basket.png	2026-03-25 09:19:25.175062+00
773	\N	Sonstiges	Eiszaun	5 Schneeflocke	\N	f	Ballon (Schneeflocken)	\N	diy/other/Frozen fence.png	2026-03-25 09:19:25.175062+00
774	\N	Sonstiges	Festtagsgeschenkpapier	1 Rotschmuck, 1 Blauschmuck, 1 Goldschmuck	\N	f	Chris	\N	diy/other/Festive wrapping paper.png	2026-03-25 09:19:25.175062+00
775	\N	Sonstiges	Regenbogenfeder	1 Rubinfeder, 1 Azurfeder, 1 Smaragdfeder, 1 Lilafeder	\N	f	Pavo	\N	diy/other/Rainbow feather.png	2026-03-25 09:19:25.175062+00
776	\N	Sonstiges	Häschentag-Zaun	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Häschentag-Ballon	240 Sternis	diy/other/Bunny Day fence.png	2026-03-25 09:19:25.175062+00
196	\N	Einrichtung	Akustikgitarre	8 Weichholz, 3 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	3.210 Sternis	diy/Housewares/Acoustic guitar.png	2026-03-24 16:52:46.642355+00
133	\N	Kleinkram	Anemonenventilator	3 Rot-Anemone, 2 Eisenerz	\N	f	Nachbarn (Schlafmütze)	1.740 Sternis	diy/Misc/Windflower fan.png	2026-03-24 15:10:27.349517+00
281	\N	Einrichtung	Apfelfernseher	10 Apfel, 2 Eisenerz	\N	f	Nachbarn (Große Schwester), Tom Nook (Drei Häuser)	3.500 Sternis	diy/Housewares/Juicy-apple TV.png	2026-03-24 16:52:46.642355+00
280	\N	Einrichtung	Apfelstuhl	10 Apfel, 4 Holz	\N	f	Nachbarn (Große Schwester), Tom Nook (Drei Häuser)	2.480 Sternis	diy/Housewares/Apple chair.png	2026-03-24 16:52:46.642355+00
197	\N	Einrichtung	Arbeitsschemel	6 Holz	\N	f	Nachbarn (Schwungvoll)	\N	diy/Housewares/Box-shaped seat.png	2026-03-24 16:52:46.642355+00
307	\N	Einrichtung	Asteroid	5 Sternensplitter, 10 Stein	\N	f	Eufemia	4.000 Sternis	diy/Housewares/Asteroid.png	2026-03-24 16:52:46.642355+00
308	\N	Einrichtung	Astronautenanzug	5 Sternensplitter, 5 Eisenerz	\N	f	Eufemia	6.250 Sternis	diy/Housewares/Astronaut suit.png	2026-03-24 16:52:46.642355+00
107	\N	Kleinkram	Bambus-Bento	4 Bambus	\N	f	Nachbarn (Hochnäsig)	640 Sternis	diy/Misc/Bamboo lunch box.png	2026-03-24 15:10:27.349517+00
374	\N	Wanddeko	Bambusdekoration	1 Bambus	\N	f	Nachbarn (Sportlich)	160 Sternis	diy/wall-mounted/Bamboo wall decoration.png	2026-03-24 17:15:41.005225+00
110	\N	Kleinkram	Bambussprossenlampe	4 Frühlingsbambus, 5 Bambussprosse, 4 Lehm	\N	f	Ballon (Frühlingsbambus)	4.900 Sternis	diy/Misc/Bamboo-shoot lamp.png	2026-03-24 15:10:27.349517+00
108	\N	Kleinkram	Bambustrommel	3 Bambus, 2 Weichholz	\N	f	Nachbarn (Sportlich)	720 Sternis	diy/Misc/Bamboo drum.png	2026-03-24 15:10:27.349517+00
117	\N	Kleinkram	Baumfrucht-Bäumchen	6 Zapfen, 4 Eichel, 1 Hartholz	\N	f	Ballon (Baumfrucht), Melinda (Baumfrucht)	4.120 Sternis	diy/Misc/Tree's bounty little tree.png	2026-03-24 15:10:27.349517+00
317	\N	Einrichtung	Baumfrucht-Bogen	4 Zapfen, 5 Eichel, 5 Herbstblatt, 15 Ast	\N	f	Ballon (Herbstblatt)	5.850 Sternis	diy/Housewares/Tree's bounty arch.png	2026-03-24 16:52:46.642355+00
116	\N	Kleinkram	Baumfrucht-Lampe	6 Eichel, 4 Lehm	\N	f	Ballon (Baumfrucht)	3.200 Sternis	diy/Misc/Tree's bounty lamp.png	2026-03-24 15:10:27.349517+00
378	\N	Wanddeko	Baumfrucht-Mobile	2 Zapfen, 3 Eichel, 3 Ast	\N	f	Ballon (Baumfrucht)	2.030 Sternis	diy/wall-mounted/Tree's bounty mobile.png	2026-03-24 17:15:41.005225+00
316	\N	Einrichtung	Baumfrucht-Tannenbaum	5 Zapfen, 4 Eichel, 4 Herbstblatt, 8 Ast, 4 Lehm	\N	f	Ballon (Herbstblatt)	6.080 Sternis	diy/Housewares/Tree's bounty big tree.png	2026-03-24 16:52:46.642355+00
211	\N	Einrichtung	Baumruine	10 Hartholz	\N	f	Nachbarn (Selbstzufrieden)	\N	diy/Housewares/Decayed tree.png	2026-03-24 16:52:46.642355+00
161	\N	Einrichtung	Baumstammbank	5 Hartholz	\N	f	Nachbarn (Ausgeglichen), Tom Nook (Drei Häuser)	600 Sternis	diy/Housewares/Log bench.png	2026-03-24 16:52:46.642355+00
168	\N	Einrichtung	Baumstammbett	30 Hartholz	\N	f	Nachbarn (Ausgeglichen)	3.600 Sternis	diy/Housewares/Log bed.png	2026-03-24 16:52:46.642355+00
163	\N	Einrichtung	Baumstamm-Esstisch	15 Hartholz	\N	f	Nachbarn (Miesepeter), Tom Nook (Drei Häuser)	1.800 Sternis	diy/Housewares/Log dining table.png	2026-03-24 16:52:46.642355+00
160	\N	Einrichtung	Baumstammhocker	4 Hartholz	\N	f	Nachbarn (Schwungvoll), Tom Nook (Drei Häuser)	480 Sternis	diy/Housewares/Log stool.png	2026-03-24 16:52:46.642355+00
165	\N	Einrichtung	Baumstammliegestuhl	12 Hartholz	\N	f	Nachbarn (Schwungvoll), Tom Nook (Drei Häuser)	1.440 Sternis	diy/Housewares/Log garden lounge.png	2026-03-24 16:52:46.642355+00
170	\N	Einrichtung	Baumstammpfahl-Set	3 Holz	\N	f	Nachbarn (Selbstzufrieden), Tom Nook (2 Spenden)	360 Sternis	diy/Housewares/Log stakes.png	2026-03-24 16:52:46.642355+00
166	\N	Einrichtung	Baumstammsessel	8 Hartholz	\N	f	Nachbarn (Schwungvoll)	960 Sternis	diy/Housewares/Log chair.png	2026-03-24 16:52:46.642355+00
164	\N	Einrichtung	Baumstammtisch	15 Hartholz	\N	f	Nachbarn (Schwungvoll)	1.800 Sternis	diy/Housewares/Log round table.png	2026-03-24 16:52:46.642355+00
345	\N	Wanddeko	Baumstammwanduhr	2 Hartholz, 1 Eisenerz	\N	f	Nachbarn (Schlafmütze)	990 Sternis	diy/wall-mounted/Log wall-mounted clock.png	2026-03-24 17:15:41.005225+00
142	\N	Einrichtung	Behelfswerkbank	5 Hartholz, 1 Eisenerz	\N	f	Brief von Nintendo (Bastelkurs), Nachbarn (Sportlich)	1.350 Sternis	diy/Housewares/Simple DIY workbench.png	2026-03-24 16:52:46.642355+00
285	\N	Einrichtung	Bienenstock	3 Wespennest, 5 Holz	\N	f	Nachbarn (Sportlich)	2.400 Sternis	diy/Housewares/Beekeeper's hive.png	2026-03-24 16:52:46.642355+00
279	\N	Einrichtung	Birnenbett	10 Birne, 6 Weichholz	\N	f	Nachbarn (Sportlich), Tom Nook (Drei Häuser)	2.720 Sternis	diy/Housewares/Pear bed.png	2026-03-24 16:52:46.642355+00
278	\N	Einrichtung	Birnenschrank	10 Birne, 5 Holz	\N	f	Nachbarn (Sportlich), Tom Nook (Drei Häuser)	2.600 Sternis	diy/Housewares/Pear wardrobe.png	2026-03-24 16:52:46.642355+00
399	\N	Wanddeko	Blaurosentürkranz	10 Blaurose	\N	f	Nachbarn	20.000 Sternis	diy/wall-mounted/Blue rose wreath.png	2026-03-24 17:15:41.005225+00
361	\N	Wanddeko	Blumengebinde	10 Unkraut	\N	f	Nachbarn (Ausgeglichen)	200 Sternis	diy/wall-mounted/Floral swag.png	2026-03-24 17:15:41.005225+00
348	\N	Wanddeko	Bumerang	3 Hartholz	\N	f	Nachbarn (Schlafmütze)	360 Sternis	diy/wall-mounted/Boomerang.png	2026-03-24 17:15:41.005225+00
202	\N	Einrichtung	Butterfass	4 Holz, 2 Eisenerz	\N	f	Nachbarn (Hochnäsig)	1.980 Sternis	diy/Housewares/Butter churn.png	2026-03-24 16:52:46.642355+00
109	\N	Kleinkram	Dampfgarer	6 Frühlingsbambus	\N	f	Ballon (Frühlingsbambus)	2.400 Sternis	diy/Misc/Steamer-basket set.png	2026-03-24 15:10:27.349517+00
132	\N	Kleinkram	Dekotischlampe	2 Rotschmuck, 2 Eisenerz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	\N	diy/Misc/Ornament table lamp.png	2026-03-24 15:10:27.349517+00
383	\N	Wanddeko	Dekotürkranz	6 Blauschmuck, 2 Goldschmuck	\N	f	Ballon (Festtag), Melinda (Festtag)	800 Sternis	diy/wall-mounted/Ornament wreath.png	2026-03-24 17:15:41.005225+00
208	\N	Einrichtung	Diagonal-Wegweiser	2 Hartholz, 3 Weichholz	\N	f	Nachbarn (Schlafmütze)	600 Sternis	diy/Housewares/Angled signpost.png	2026-03-24 16:52:46.642355+00
96	\N	Kleinkram	Dokumentenstapel	1 Papierhaufen	\N	f	Nachbarn (Selbstzufrieden)	400 Sternis	diy/Misc/Document stack.png	2026-03-24 15:10:27.349517+00
61	\N	Kleinkram	Dosen-Kalimba	1 Leere Dose, 1 Holz, 1 Eisenerz	\N	f	3x Dose angeln	890 Sternis	diy/Misc/Recycled-can thumb piano.png	2026-03-24 15:10:27.349517+00
129	\N	Kleinkram	Dreidelspiel	2 Goldschmuck, 1 Hartholz	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	320 Sternis	diy/Misc/Festive top set.png	2026-03-24 15:10:27.349517+00
66	\N	Kleinkram	Duftlampe	3 Lehm	\N	f	Nachbarn (Hochnäsig)	600 Sternis	diy/Misc/Aroma pot.png	2026-03-24 15:10:27.349517+00
386	\N	Wanddeko	Edelanemonentürkranz	10 Lila-Anemone	\N	f	Nachbarn	4.800 Sternis	diy/wall-mounted/Chic windflower wreath.png	2026-03-24 17:15:41.005225+00
392	\N	Wanddeko	Edelcosmeentürkranz	10 Schwarzcosmea	\N	f	Nachbarn	4.800 Sternis	diy/wall-mounted/Chic cosmos wreath.png	2026-03-24 17:15:41.005225+00
362	\N	Wanddeko	Efeu-Topfpflanze	5 Unkraut, 5 Lehm	\N	f	Ideen für Bastler aus Nooks Laden	1.100 Sternis	diy/wall-mounted/Potted ivy.png	2026-03-24 17:15:41.005225+00
340	\N	Einrichtung	Eisbett	1 Riesenschneeflocke, 10 Schneeflocke	\N	f	Schnemil	9.000 Sternis	diy/Housewares/Frozen bed.png	2026-03-24 16:52:46.642355+00
359	\N	Wanddeko	Eisen-Holz-Wanduhr	2 Holz, 2 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	1.740 Sternis	diy/wall-mounted/Ironwood clock.png	2026-03-24 17:15:41.005225+00
355	\N	Wanddeko	Eisenwandlampe	4 Eisenerz, 2 Lehm	\N	f	Bist du der Bastelboss? aus Nooks Laden	3.400 Sternis	diy/wall-mounted/Iron wall lamp.png	2026-03-24 17:15:41.005225+00
356	\N	Wanddeko	Eisenwandregal	3 Eisenerz, 1 Lehm	\N	f	Nachbarn (Selbstzufrieden)	2.450 Sternis	diy/wall-mounted/Iron wall rack.png	2026-03-24 17:15:41.005225+00
128	\N	Kleinkram	Eis-Minischneemann	1 Riesenschneeflocke, 2 Schneeflocke	\N	f	Schnemil	\N	diy/Misc/Frozen mini snowperson.png	2026-03-24 15:10:27.349517+00
343	\N	Einrichtung	Eissäule	1 Riesenschneeflocke, 3 Schneeflocke	\N	f	Schnemil	6.200 Sternis	diy/Housewares/Frozen pillar.png	2026-03-24 16:52:46.642355+00
337	\N	Einrichtung	Eisstuhl	1 Riesenschneeflocke, 3 Schneeflocke	\N	f	Schnemil	6.200 Sternis	diy/Housewares/Frozen chair.png	2026-03-24 16:52:46.642355+00
339	\N	Einrichtung	Eistisch	1 Riesenschneeflocke, 8 Schneeflocke	\N	f	Schnemil	8.200 Sternis	diy/Housewares/Frozen table.png	2026-03-24 16:52:46.642355+00
342	\N	Einrichtung	Eistor	1 Riesenschneeflocke, 10 Schneeflocke	\N	f	Schnemil	9.000 Sternis	diy/Housewares/Frozen arch.png	2026-03-24 16:52:46.642355+00
341	\N	Einrichtung	Eis-Trennwand	1 Riesenschneeflocke, 6 Schneeflocke	\N	f	Schnemil	7.400 Sternis	diy/Housewares/Frozen partition.png	2026-03-24 16:52:46.642355+00
338	\N	Einrichtung	Eistresen	1 Riesenschneeflocke, 5 Schneeflocke	\N	f	Schnemil	7.000 Sternis	diy/Housewares/Frozen counter.png	2026-03-24 16:52:46.642355+00
139	\N	Einrichtung	Fackel	5 Ast, 5 Holz	\N	f	Nachbarn (Miesepeter), Tom Nook (2 Spenden)	1.400 Sternis	diy/Housewares/Tiki torch.png	2026-03-24 16:52:46.642355+00
201	\N	Einrichtung	Fass	5 Holz, 2 Eisenerz	\N	f	Nachbarn (Miesepeter), Tom Nook (Drei Häuser)	2.100 Sternis	diy/Housewares/Barrel.png	2026-03-24 16:52:46.642355+00
130	\N	Kleinkram	Festtagsgesteck	5 Rotschmuck, 5 Unkraut	\N	f	Nachbarn (Festtag-Saison), Ballon (Festtag)	600 Sternis	diy/Misc/Holiday candle.png	2026-03-24 15:10:27.349517+00
57	\N	Kleinkram	Feuerholz	8 Holz	\N	f	Nachbarn (Sportlich)	960 Sternis	diy/Misc/Firewood.png	2026-03-24 15:10:27.349517+00
115	\N	Kleinkram	Fingerschaukel	4 Eichel, 2 Hartholz	\N	f	Ballon (Baumfrucht)	1.840 Sternis	diy/Misc/Traditional balancing toy.png	2026-03-24 15:10:27.349517+00
228	\N	Einrichtung	Flach-Gartenstein	20 Stein	\N	f	Nachbarn (Hochnäsig)	3.000 Sternis	diy/Housewares/Flat garden rock.png	2026-03-24 16:52:46.642355+00
354	\N	Wanddeko	Fossilientürschild	1 Fossil, 2 Stein	\N	f	Nachbarn (Sportlich)	500 Sternis	diy/wall-mounted/Fossil doorplate.png	2026-03-24 17:15:41.005225+00
369	\N	Wanddeko	Früchtetürkranz	2 Apfel, 1 Birne, 3 Kirsche, 3 Orange, 1 Pfirsich	\N	f	Nachbarn (Miesepeter)	2.000 Sternis	diy/wall-mounted/Fruit wreath.png	2026-03-24 17:15:41.005225+00
90	\N	Kleinkram	Fruchtkorb	1 Apfel, 1 Birne, 1 Kirsche, 1 Orange, 1 Pfirsich	\N	f	Nachbarn (Miesepeter)	1.000 Sternis	diy/Misc/Fruit basket.png	2026-03-24 15:10:27.349517+00
181	\N	Einrichtung	Funktional-Gartenstuhl	6 Hartholz, 2 Eisenerz	\N	f	Nachbarn (Schwungvoll), Tom Nook (Drei Häuser)	2.220 Sternis	diy/Housewares/Natural garden chair.png	2026-03-24 16:52:46.642355+00
183	\N	Einrichtung	Funktional-Gartentisch	9 Hartholz, 3 Eisenerz	\N	f	Nachbarn (Ausgeglichen), Tom Nook (Drei Häuser)	3.330 Sternis	diy/Housewares/Natural garden table.png	2026-03-24 16:52:46.642355+00
182	\N	Einrichtung	Funktionaltischchen	4 Hartholz, 2 Eisenerz	\N	f	Nachbarn (Ausgeglichen)	1.980 Sternis	diy/Housewares/Natural square table.png	2026-03-24 16:52:46.642355+00
247	\N	Einrichtung	Gartenbank	12 Holz, 4 Eisenerz	\N	f	Nachbarn (Hochnäsig)	4.800 Sternis	diy/Housewares/Garden Bench.png	2026-03-24 16:52:46.642355+00
230	\N	Einrichtung	Gartenfels	60 Stein	\N	f	Nachbarn (Hochnäsig)	9.000 Sternis	diy/Housewares/Tall garden rock.png	2026-03-24 16:52:46.642355+00
227	\N	Einrichtung	Gartenstein	15 Stein	\N	f	Nachbarn (Schlafmütze)	2.250 Sternis	diy/Housewares/Garden rock.png	2026-03-24 16:52:46.642355+00
239	\N	Einrichtung	Gedenkstein	12 Stein	\N	f	NookPortal	1.800 Sternis	diy/Housewares/Stone tablet.png	2026-03-24 16:52:46.642355+00
92	\N	Kleinkram	Gemüsekorb	1 Tomate, 1 Karotte, 1 Kartoffel, 1 Orangekürbis, 1 Weizen, 1 Zuckerrohr	\N	f	Gerd	\N	diy/Misc/Veggie basket.png	2026-03-24 15:10:27.349517+00
99	\N	Kleinkram	Getränkekistentisch	2 Flaschenkiste, 1 Holz	\N	f	Nachbarn (Sportlich)	\N	diy/Misc/Stacked bottle crates.png	2026-03-24 15:10:27.349517+00
80	\N	Kleinkram	Goldarmbanduhr	1 Golderz, 1 Armbanduhr	\N	f	Nachbarn (Selbstzufrieden)	\N	diy/Misc/Golden wristwatch.png	2026-03-24 15:10:27.349517+00
82	\N	Kleinkram	Gold-Arowana-Modell	3 Golderz	\N	f	Nachbarn (Schlafmütze)	30.000 Sternis	diy/Misc/Golden arowana model.png	2026-03-24 15:10:27.349517+00
70	\N	Kleinkram	Goldbarrenstapel	3 Golderz	\N	f	Nachbarn (Hochnäsig)	30.000 Sternis	diy/Misc/Gold bars.png	2026-03-24 15:10:27.349517+00
75	\N	Kleinkram	Gold-Daruma	1 Golderz, 1 Daruma	\N	f	Nachbarn (Miesepeter)	\N	diy/Misc/Golden dharma.png	2026-03-24 15:10:27.349517+00
71	\N	Kleinkram	Goldgeschirr	1 Golderz	\N	f	Nachbarn (Hochnäsig)	10.000 Sternis	diy/Misc/Golden dishes.png	2026-03-24 15:10:27.349517+00
360	\N	Wanddeko	Gold-Getriebe	1 Golderz, 3 Eisenerz	\N	f	Nachbarn (Selbstzufrieden)	11.125 Sternis	diy/wall-mounted/Golden gears.png	2026-03-24 17:15:41.005225+00
73	\N	Kleinkram	Gold-Glückskatze	2 Golderz, 1 Glückskatze	\N	f	Nachbarn (Hochnäsig)	21.675 Sternis	diy/Misc/Lucky gold cat.png	2026-03-24 15:10:27.349517+00
72	\N	Kleinkram	Goldkerzenhalter	2 Golderz	\N	f	Nachbarn (Selbstzufrieden)	20.000 Sternis	diy/Misc/Golden candlestick.png	2026-03-24 15:10:27.349517+00
400	\N	Wanddeko	Goldrosentürkranz	10 Goldrose	\N	f	Nachbarn	20.000 Sternis	diy/wall-mounted/Gold rose wreath.png	2026-03-24 17:15:41.005225+00
249	\N	Einrichtung	Goldsarkophag	8 Golderz	\N	f	Nachbarn (Selbstzufrieden)	80.000 Sternis	diy/Housewares/Golden casket.png	2026-03-24 16:52:46.642355+00
248	\N	Einrichtung	Goldsitz	5 Golderz	\N	f	Nachbarn (Hochnäsig)	50.000 Sternis	diy/Housewares/Golden seat.png	2026-03-24 16:52:46.642355+00
81	\N	Kleinkram	Gold-Skarabäus	3 Golderz	\N	f	Nachbarn (Schlafmütze)	30.000 Sternis	diy/Misc/Golden dung beetle.png	2026-03-24 15:10:27.349517+00
250	\N	Einrichtung	Goldtoilette	6 Golderz	\N	f	Nachbarn (Hochnäsig)	60.000 Sternis	diy/Housewares/Golden toilet.png	2026-03-24 16:52:46.642355+00
236	\N	Einrichtung	Grabstein	30 Stein	\N	f	Nachbarn (Ausgeglichen)	4.500 Sternis	diy/Housewares/Western-style stone.png	2026-03-24 16:52:46.642355+00
389	\N	Wanddeko	Grünchrysanth.-Türkranz	10 Grünchrysantheme	\N	f	Nachbarn	4.800 Sternis	diy/wall-mounted/Natural mum wreath.png	2026-03-24 17:15:41.005225+00
357	\N	Wanddeko	Gusseisentürschild	2 Eisenerz	\N	f	Nachbarn (Große Schwester)	1.500 Sternis	diy/wall-mounted/Iron doorplate.png	2026-03-24 17:15:41.005225+00
363	\N	Wanddeko	Hänge-Terrarium	12 Unkraut, 4 Eisenerz	\N	f	Nachbarn (Schwungvoll)	3.240 Sternis	diy/wall-mounted/Hanging terrarium.png	2026-03-24 17:15:41.005225+00
411	\N	Wanddeko	Häschentag-Girlande	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Häschentag-Ballon	2.400 Sternis	diy/wall-mounted/Bunny Day glowy garland.png	2026-03-24 17:15:41.005225+00
135	\N	Kleinkram	Häschentag-Lampe	4 Holz-Glücksei	\N	f	Häschentag-Ballon	1.600 Sternis	diy/Misc/Bunny Day lamp.png	2026-03-24 15:10:27.349517+00
412	\N	Wanddeko	Häschentag-Türkranz	1 Erd-Glücksei, 1 Fels-Glücksei, 1 Laub-Glücksei, 1 Holz-Glücksei, 1 Luft-Glücksei, 1 Wasser-Glücksei	\N	f	Häschentag-Ballon	2.400 Sternis	diy/wall-mounted/Bunny Day wreath.png	2026-03-24 17:15:41.005225+00
410	\N	Wanddeko	Häschentag-Wanduhr	3 Luft-Glücksei	\N	f	Häschentag-Ballon	1.200 Sternis	diy/wall-mounted/Bunny Day wall clock.png	2026-03-24 17:15:41.005225+00
243	\N	Einrichtung	Herbstlaub-Vogelbad-Fels	10 Stein, 3 Herbstblatt	\N	f	Ballon (Herbstblatt)	2.700 Sternis	diy/Housewares/Maple-leaf pond stone.png	2026-03-24 16:52:46.642355+00
273	\N	Einrichtung	Hexenkessel	10 Leuchtmoos, 10 Eisenerz	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Suspicious cauldron.png	2026-03-24 16:52:46.642355+00
268	\N	Einrichtung	Höhle	10 Ranke, 20 Leuchtmoos, 30 Stein	\N	f	Bootsausflug, Ferienhausagentur	\N	diy/Housewares/Cave.png	2026-03-24 16:52:46.642355+00
156	\N	Einrichtung	Holz-Abfalleimer	4 Holz	\N	f	Nachbarn (Große Schwester)	480 Sternis	diy/Housewares/Wooden waste bin.png	2026-03-24 16:52:46.642355+00
153	\N	Einrichtung	Holzbett	18 Holz	\N	f	Nachbarn (Schlafmütze), Tom Nook (Drei Häuser)	2.160 Sternis	diy/Housewares/Wooden simple bed.png	2026-03-24 16:52:46.642355+00
350	\N	Wanddeko	Holzbrettschild	5 Hartholz	\N	f	Nachbarn (Miesepeter)	600 Sternis	diy/wall-mounted/Wooden-plank sign.png	2026-03-24 17:15:41.005225+00
287	\N	Einrichtung	Holzbücherregal	5 Buch, 10 Holz	\N	f	Nachbarn (Schlafmütze)	2.150 Sternis	diy/Housewares/Wooden bookshelf.png	2026-03-24 16:52:46.642355+00
154	\N	Einrichtung	Holzdoppelbett	30 Holz	\N	f	Nachbarn (Schlafmütze)	3.600 Sternis	diy/Housewares/Wooden double bed.png	2026-03-24 16:52:46.642355+00
349	\N	Wanddeko	Holz-Hirschkopf	8 Weichholz	\N	f	Nachbarn (Schlafmütze)	960 Sternis	diy/wall-mounted/Deer decoration.png	2026-03-24 17:15:41.005225+00
214	\N	Einrichtung	Holzkiste	6 Holz	\N	f	Nachbarn (Schwungvoll)	\N	diy/Housewares/Wooden box.png	2026-03-24 16:52:46.642355+00
152	\N	Einrichtung	Holzkommode	16 Holz	\N	f	Nachbarn (Schlafmütze)	1.920 Sternis	diy/Housewares/Wooden chest.png	2026-03-24 16:52:46.642355+00
213	\N	Einrichtung	Holz-Lagerschrank	30 Holz, 30 Hartholz, 30 Weichholz, 10 Eisenerz	\N	f	NookPortal	\N	diy/Housewares/Wooden storage shed.png	2026-03-24 16:52:46.642355+00
59	\N	Kleinkram	Holz-Musikschatulle	3 Holz, 3 Weichholz, 1 Eisenerz	\N	f	Nachbarn (Hochnäsig)	\N	diy/Misc/Wooden music box.png	2026-03-24 15:10:27.349517+00
148	\N	Einrichtung	Holznachttisch	8 Holz	\N	f	Nachbarn (Hochnäsig)	960 Sternis	diy/Housewares/Wooden end table.png	2026-03-24 16:52:46.642355+00
157	\N	Einrichtung	Holz-Offenregal	10 Holz	\N	f	Nachbarn (Selbstzufrieden)	\N	diy/Housewares/Open wooden shelves.png	2026-03-24 16:52:46.642355+00
145	\N	Einrichtung	Holzschemel	4 Holz	\N	f	Nachbarn (Schwungvoll)	480 Sternis	diy/Housewares/Wooden stool.png	2026-03-24 16:52:46.642355+00
180	\N	Einrichtung	Holzschild	6 Holz	\N	f	Nachbarn (Sportlich)	720 Sternis	diy/Housewares/Plain wooden shop sign.png	2026-03-24 16:52:46.642355+00
151	\N	Einrichtung	Holzschrank	12 Holz	\N	f	Tom Nook (Umgestaltungskurs)	1.440 Sternis	diy/Housewares/Wooden wardrobe.png	2026-03-24 16:52:46.642355+00
47	\N	Kleinkram	Holz-Tischspiegel	3 Holz, 1 Eisenerz	\N	f	Nachbarn (Große Schwester)	1.110 Sternis	diy/Misc/Wooden table mirror.png	2026-03-24 15:10:27.349517+00
48	\N	Kleinkram	Bauklotzset	3 Weichholz	\N	f	Nooks Laden / Tom Nook	360 Sternis	diy/Misc/Wooden-block toy.png	2026-03-24 15:10:27.349517+00
49	\N	Kleinkram	Holzeimer	3 Holz, 1 Eisenerz	\N	f	Nachbarn (Selbstzufrieden) / Tom Nook	\N	diy/Misc/Wooden bucket.png	2026-03-24 15:10:27.349517+00
50	\N	Kleinkram	Ringwurfspiel	2 Holz, 2 Weichholz	\N	f	Nooks Laden	480 Sternis	diy/Misc/Ringtoss.png	2026-03-24 15:10:27.349517+00
51	\N	Kleinkram	Matroschka	5 Weichholz	\N	f	Nachbarn (Schlafmütze)	600 Sternis	diy/Misc/Matryoshka.png	2026-03-24 15:10:27.349517+00
52	\N	Kleinkram	Ukulele	5 Hartholz	\N	f	Nachbarn (Selbstzufrieden)	600 Sternis	diy/Misc/Ukulele.png	2026-03-24 15:10:27.349517+00
53	\N	Kleinkram	Holzblocktrommel	3 Holz	\N	f	Nooks Laden	360 Sternis	diy/Misc/Wooden fish.png	2026-03-24 15:10:27.349517+00
54	\N	Kleinkram	Waschbottich	3 Weichholz	\N	f	Nooks Laden	360 Sternis	diy/Misc/Old-fashioned washtub.png	2026-03-24 15:10:27.349517+00
\.


--
-- TOC entry 3895 (class 0 OID 16783)
-- Dependencies: 224
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.events (id, name, event_type, month, date_description, description, image_path, created_at) FROM stdin;
1	Neujahr	event	1	01.01. – 05.01.	Nook Shopping: Besondere Neujahrs-Waren erhältlich.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
2	Nanakusa gayu	event	1	05.01. – 07.01.	Nook Shopping: Traditionelles Reisgericht.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
3	Karneval in Venedig	event	1	14.01. – 15.02.	Nook Shopping: Bestelle besondere Waren!	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
4	Football-Finale	event	1	15.01. – 15.02.	Nook Shopping: Alles für das große Spiel.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
5	Mondneujahr	event	1	20.01. – 17.02.	Nook Shopping: Feiere das Mondneujahr.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
6	Murmeltiertag	event	1	25.01. – 02.02.	Nook Shopping: Feiere den Murmeltiertag (Resetti-Figur).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
7	Setsubun	event	1	25.01. – 03.02.	Nook Shopping: Japanisches Bohnenwerf-Fest.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
8	Schneeflocken-Saison & Schnemil	season	1	11.12. – 24.02.	Fange Schneeflocken und baue den perfekten Schnemil.	schneeflocke.png	2026-03-23 10:13:41.824066+00
9	Festtag-Saison	season	1	15.12. – 06.01.	Schüttle beleuchtete Nadelbäume für roten, blauen und goldenen Ornamentschmuck.	rotschmuck.png	2026-03-23 10:13:41.824066+00
10	Angelturnier	tournament	1	2. Samstag	Lomeus lädt zum ersten Angelturnier des Jahres ein.	angel.png	2026-03-23 10:13:41.824066+00
11	Valentinstag	event	2	01.02. – 14.02.	Nook Shopping: Herzförmige Geschenke und Schokolade.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
12	Karneval in Venedig	event	2	14.01. – 15.02.	Nook Shopping: Bestelle besondere Waren!	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
13	Football-Finale	event	2	15.01. – 15.02.	Nook Shopping: Alles für das große Spiel.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
14	Mondneujahr	event	2	20.01. – 17.02.	Nook Shopping: Feiere das Mondneujahr.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
15	Karneval	holiday	2	Variabel (Februar)	Pavé besucht die Insel. Sammle bunte Federn!	regenbogenfeder.png	2026-03-23 10:13:41.824066+00
16	Hinamatsuri	event	2	22.02. – 03.03.	Nook Shopping: Das japanische Mädchenfest.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
17	Murmeltiertag	event	2	25.01. – 02.02.	Nook Shopping: Feiere den Murmeltiertag (Resetti-Figur).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
18	Setsubun	event	2	25.01. – 03.02.	Nook Shopping: Japanisches Bohnenwerf-Fest.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
19	Frühlingsbambus-Saison	season	2	25.02. – 31.05.	Fälle Bambus für hellen Frühlingsbambus und bastle neue Anleitungen.	fruehlingsbambus.png	2026-03-23 10:13:41.824066+00
20	Schneeflocken-Saison & Schnemil	season	2	11.12. – 24.02.	Fange Schneeflocken und baue den perfekten Schnemil.	schneeflocke.png	2026-03-23 10:13:41.824066+00
21	Pi-Tag	event	3	01.03. – 14.03.	Nook Shopping: Feiere die berühmte Kreiszahl Pi mit einem Kuchen.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
22	Kleeblatttag	event	3	10.03. – 17.03.	Nook Shopping: Alles erstrahlt in Grün zum St. Patricks Day.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
23	Hinamatsuri	event	3	22.02. – 03.03.	Nook Shopping: Das japanische Mädchenfest.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
24	1. April	event	3	26.03. – 01.04.	Nook Shopping: Pupskissen zur Feier des Tages.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
25	Häschentag	holiday	3	Variabel (März/April)	Ohs der Hase versteckt Eier auf der ganzen Insel (7 Tage vor Ostern).	fels-gluecksei.png	2026-03-23 10:13:41.824066+00
26	Frühlingsbambus-Saison	season	3	25.02. – 31.05.	Fälle Bambus für hellen Frühlingsbambus und bastle neue Anleitungen.	fruehlingsbambus.png	2026-03-23 10:13:41.824066+00
27	Kirschblüten-Saison	season	4	01.04. – 10.04.	Fange sanft fallende Kirschblütenblätter für schöne DIYs.	kirschbluete.png	2026-03-23 10:13:41.824066+00
28	Singmogil	event	4	01.04. – 10.04.	Nook Shopping: Südkoreanischer Tag des Baumes.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
29	Abschlussball	event	4	01.04. – 30.04.	Nook Shopping: Feiere den Abschlussball (Prom).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
30	Tag der Natur	event	4	15.04. – 22.04.	Nook Shopping: Spezieller Globus zum Tag der Natur.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
31	Kodomo no Hi	event	4	26.04. – 05.05.	Nook Shopping: Japanischer Kindertag (Karpfenwimpel).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
32	Mai-Feierei	event	4	29.04. – 07.05.	Olli erwartet dich auf einer speziellen Labyrinth-Insel mit einem Ticket von Tom Nook.	sterni-coupon.png	2026-03-23 10:13:41.824066+00
33	Angelturnier	tournament	4	2. Samstag	Lomeus lädt zum Frühlings-Angelturnier ein.	angel.png	2026-03-23 10:13:41.824066+00
34	1. April	event	4	26.03. – 01.04.	Nook Shopping: Pupskissen zur Feier des Tages.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
35	Häschentag	holiday	4	Variabel (März/April)	Ohs der Hase versteckt Eier auf der ganzen Insel (7 Tage vor Ostern).	fels-gluecksei.png	2026-03-23 10:13:41.824066+00
36	Frühlingsbambus-Saison	season	4	25.02. – 31.05.	Fälle Bambus für hellen Frühlingsbambus und bastle neue Anleitungen.	fruehlingsbambus.png	2026-03-23 10:13:41.824066+00
37	Muttertag	event	5	01.05. – 31.05.	Nook Shopping: Zeige deiner Mutter, wie sehr du sie schätzt (Nelken-Deko).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
38	Internationaler Museumstag	event	5	18.05. – 31.05.	Nimm an Eugens großer Stempeljagd im Museum teil für goldene Wand-Plaketten.	fossil.png	2026-03-23 10:13:41.824066+00
39	Kodomo no Hi	event	5	26.04. – 05.05.	Nook Shopping: Japanischer Kindertag (Karpfenwimpel).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
40	Mai-Feierei	event	5	29.04. – 07.05.	Olli erwartet dich auf einer speziellen Labyrinth-Insel mit einem Ticket von Tom Nook.	sterni-coupon.png	2026-03-23 10:13:41.824066+00
41	Käserollen & Drachenbootfest	event	5	Variabel	Nook Shopping: Hol dir den rollenden Käse und andere spezielle Items.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
42	Frühlingsbambus-Saison	season	5	25.02. – 31.05.	Fälle Bambus für hellen Frühlingsbambus und bastle neue Anleitungen.	fruehlingsbambus.png	2026-03-23 10:13:41.824066+00
43	Hochzeitssaison	season	6	01.06. – 30.06.	Gestalte Hochzeitsfotos für Rosina & Björn auf Harvey's Insel.	liebeskristall.png	2026-03-23 10:13:41.824066+00
44	Vatertag	event	6	01.06. – 30.06.	Nook Shopping: Geschenke zum Vatertag.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
45	Sommermuschel-Saison	season	6	01.06. – 31.08.	Sammle blaue Sommermuscheln am Strand für sommerliche Muschel-Möbel.	sommermuschel.png	2026-03-23 10:13:41.824066+00
46	Mittsommer	event	6	15.06. – 21.06.	Nook Shopping: Feiere die Sonnenwende mit Blumenkrone und Midsommarstång.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
47	Insektikus-Turnier	tournament	6	4. Samstag	Carl veranstaltet das erste Sommer-Insektenturnier.	kescher.png	2026-03-23 10:13:41.824066+00
48	Käserollen & Drachenbootfest	event	6	Variabel	Nook Shopping: Hol dir den rollenden Käse und andere spezielle Items.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
49	Tanabata	event	7	01.07. – 07.07.	Nook Shopping: Wünsche dir etwas beim Sternenfest am Bambusbaum.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
50	14. Juli	event	7	10.07. – 20.07.	Nook Shopping: Feiere den französischen Nationalfeiertag.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
51	Cowboy-Festival	event	7	15.07. – 15.08.	Nook Shopping: Hol dir das Rodeo-Federwipptier.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
52	Angelturnier	tournament	7	2. Samstag	Lomeus lädt zum Sommer-Angelturnier ein.	angel.png	2026-03-23 10:13:41.824066+00
53	Insektikus-Turnier	tournament	7	4. Samstag	Carl veranstaltet das nächste Sommer-Insektenturnier.	kescher.png	2026-03-23 10:13:41.824066+00
54	Sommermuschel-Saison	season	7	01.06. – 31.08.	Sammle blaue Sommermuscheln am Strand für sommerliche Muschel-Möbel.	sommermuschel.png	2026-03-23 10:13:41.824066+00
55	Feuerwerk	event	8	Jeden Sonntag	Feuerwerksshow mit Reiners Tombola auf dem Festplatz. Sichere dir Leuchtbopper!	fontaene.png	2026-03-23 10:13:41.824066+00
56	Obon	event	8	10.08. – 16.08.	Nook Shopping: Japanisches Totenfest (Auberginenkuh & Gurkenpferd).	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
57	Cowboy-Festival	event	8	15.07. – 15.08.	Nook Shopping: Hol dir das Rodeo-Federwipptier.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
58	Tomatenfest	event	8	20.08. – 31.08.	Nook Shopping: Feiere La Tomatina mit dem Tomaten-T-Shirt.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
59	Insektikus-Turnier	tournament	8	4. Samstag	Carl veranstaltet ein weiteres Sommer-Insektenturnier.	kescher.png	2026-03-23 10:13:41.824066+00
60	Sommermuschel-Saison	season	8	01.06. – 31.08.	Sammle blaue Sommermuscheln am Strand für sommerliche Muschel-Möbel.	sommermuschel.png	2026-03-23 10:13:41.824066+00
61	Traubenlese-Festival	event	9	01.09. – 30.09.	Nook Shopping: Feiere die Ernte mit dem Traubenkiepe-Rucksack.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
62	Baumfrucht-Saison	season	9	01.09. – 10.12.	Schüttle Bäume, um Eicheln und Zapfen für herbstliche Möbel zu finden.	eichel.png	2026-03-23 10:13:41.824066+00
63	Mondfest & Chuseok	event	9	Variabel (Sep/Okt)	Nook Shopping: Hol dir Mondkuchen und Songpyeon.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
64	Insektikus-Turnier	tournament	9	4. Samstag	Carl veranstaltet das letzte Insektenturnier für dieses Jahr.	kescher.png	2026-03-23 10:13:41.824066+00
65	Angelturnier	tournament	10	2. Samstag	Lomeus lädt zum herbstlichen Angelturnier ein.	angel.png	2026-03-23 10:13:41.824066+00
66	Tag der Toten	event	10	25.10. – 03.11.	Nook Shopping: Feiere den Día de Muertos.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
67	Halloween	holiday	10	31. Oktober	Jakob, der Prinz von Halloween, fordert Süßes oder Saures! Baue Kürbisse an.	orangekuerbis.png	2026-03-23 10:13:41.824066+00
68	Mondfest & Chuseok	event	10	Variabel (Sep/Okt)	Nook Shopping: Hol dir Mondkuchen und Songpyeon.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
69	Baumfrucht-Saison	season	10	01.09. – 10.12.	Schüttle Bäume, um Eicheln und Zapfen für herbstliche Möbel zu finden.	eichel.png	2026-03-23 10:13:41.824066+00
70	Pilz-Saison	season	11	01.11. – 30.11.	Finde verschiedene Pilze rund um die Bäume (inklusive dem seltenen Trüffel).	flachpilz.png	2026-03-23 10:13:41.824066+00
71	Laternenfest	event	11	01.11. – 11.11.	Nook Shopping: Erleuchte die Nacht mit speziellen Laternen.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
72	Shichi-Go-San	event	11	11.11. – 20.11.	Nook Shopping: Japanisches Kinderfest.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
73	Herbstblätter-Saison	season	11	16.11. – 25.11.	Fange tanzende Ahornblätter mit dem Kescher für Laub-DIYs.	herbstblatt.png	2026-03-23 10:13:41.824066+00
74	Schlemmfest	holiday	11	4. Donnerstag	Thanksgiving mit Gernod. Hilf ihm beim Kochen auf dem Festplatz!	bonbon.png	2026-03-23 10:13:41.824066+00
75	Nook Friday	event	11	4. Freitag	Große Rabatte (30%) auf alles in Nooks Laden.	sterni-sack_s.png	2026-03-23 10:13:41.824066+00
76	Tag der Toten	event	11	25.10. – 03.11.	Nook Shopping: Feiere den Día de Muertos.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
77	Baumfrucht-Saison	season	11	01.09. – 10.12.	Schüttle Bäume, um Eicheln und Zapfen für herbstliche Möbel zu finden.	eichel.png	2026-03-23 10:13:41.824066+00
78	Schneeflocken-Saison & Schnemil	season	12	11.12. – 24.02.	Der Schnee bleibt liegen! Fange Schneeflocken und rolle Schneebälle.	schneeflocke.png	2026-03-23 10:13:41.824066+00
79	Festtag-Saison	season	12	15.12. – 06.01.	Schüttle beleuchtete Nadelbäume für roten, blauen und goldenen Ornamentschmuck.	rotschmuck.png	2026-03-23 10:13:41.824066+00
80	Mittwinter	event	12	15.12. – 22.12.	Nook Shopping: Items zur Wintersonnenwende.	NH-Icon-Nook_Phone-Nook_shopping.webp	2026-03-23 10:13:41.824066+00
81	Spielzeugtag	holiday	12	24. Dezember	Weihnachten: Chris das Rentier braucht Hilfe beim Verteilen der Geschenke.	geschenkesack.png	2026-03-23 10:13:41.824066+00
82	Countdown	holiday	12	31. Dezember	Große Silvesterfeier mit Feuerwerk und Leuchtartikeln auf dem Festplatz!	leuchtstab.png	2026-03-23 10:13:41.824066+00
83	Baumfrucht-Saison	season	12	01.09. – 10.12.	Schüttle Bäume, um Eicheln und Zapfen für herbstliche Möbel zu finden.	eichel.png	2026-03-23 10:13:41.824066+00
\.


--
-- TOC entry 3891 (class 0 OID 16689)
-- Dependencies: 220
-- Data for Name: flower_combinations; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.flower_combinations (id, flower_id, parent1_color, parent1_image, parent2_color, parent2_image, child_color, child_image, probability, notes, child_sell_price) FROM stdin;
6	1	Rotanemone (Hybrid)	flowers/Red windflowers.png	Rotanemone (Hybrid)	flowers/Red windflowers.png	Purpuranemone	flowers/Purple windflowers.png	6,25%	Das Finale! Erfordert etwas Geduld (1/16 Chance).	240 Sternis
7	1	Purpuranemone	flowers/Purple windflowers.png	Purpuranemone	flowers/Purple windflowers.png	Purpuranemone	flowers/Purple windflowers.png	100%	Einmal erreicht, einfach einzeln stellen zum Klonen.	240 Sternis
2	1	Rotanemone (Samen)	flowers/Red windflowers.png	Orangeanemone (Samen)	flowers/Orange windflowers.png	Pinkanemone	flowers/Pink windflowers.png	100%	Beste Methode für Rosa.	80 Sternis
38	2	Alpenveilchen (Samen)	flowers/Red pansies.png	Hornveilchen (Samen)	flowers/Yellow pansies.png	Stiefmütterchen	flowers/Orange pansies.png	100%	Schön für Dekoration.	80 Sternis
4	1	Orangeanemone (Samen)	flowers/Orange windflowers.png	Weißanemone (Samen)	flowers/White windflowers.png	Orangeanemone	flowers/Orange windflowers.png	50%	Weitere 50% werden Rot.	\N
5	1	Pinkanemone (Hybrid)	flowers/Pink windflowers.png	Blauanemone	flowers/Blue windflowers.png	Rotanemone (Hybrid)	flowers/Red windflowers.png	100%	Der wichtigste Schritt auf dem Weg zu Lila!	\N
39	2	Pfingstveilchen (Samen)	flowers/White pansies.png	Pfingstveilchen (Samen)	flowers/White pansies.png	Duftveilchen	flowers/Blue pansies.png	25%	Wichtig für Lila! (Rest 75% Weiß).	80 Sternis
40	2	Duftveilchen	flowers/Blue pansies.png	Alpenveilchen (Samen)	flowers/Red pansies.png	Hybrid-Alpenveilchen	flowers/Red pansies.png	100%	Zwingend notwendig für den nächsten Schritt.	40 Sternis
41	2	Hybrid-Alpenveilchen	flowers/Red pansies.png	Hybrid-Alpenveilchen	flowers/Red pansies.png	Hainveilchen	flowers/Purple pansies.png	6,25%	Das Finale! (25% Blau, 56% Rot, 12,5% Weiß).	\N
42	2	Hainveilchen	flowers/Purple pansies.png	Hainveilchen	flowers/Purple pansies.png	Hainveilchen	flowers/Purple pansies.png	100%	Einmal gezüchtet, leicht zu klonen.	\N
17	3	Lilachrysantheme (Hybrid)	flowers/Purple mums.png	Lilachrysantheme (Hybrid)	flowers/Purple mums.png	Grünchrysantheme	flowers/Green mums.png	25%	Der effizienteste Weg! (Weitere: 50% Lila, 25% Weiß)	240 Sternis
18	3	Grünchrysantheme	flowers/Green mums.png	Grünchrysantheme	flowers/Green mums.png	Grünchrysantheme	flowers/Green mums.png	100%	Garantiert grüne Nachkommen.	240 Sternis
13	3	Rotchrysantheme (Samen)	flowers/Red mums.png	Weißchrysantheme (Samen)	flowers/White mums.png	Rosachrysantheme	flowers/Pink mums.png	100%	Hervorragend zur Dekoration.	80 Sternis
14	3	Weißchrysantheme (Samen)	flowers/White mums.png	Weißchrysantheme (Samen)	flowers/White mums.png	Lilachrysantheme	flowers/Purple mums.png	25%	Eine weitere Basis für Grün.	80 Sternis
15	3	Rotchrysantheme (Samen)	flowers/Red mums.png	Gelbchrysantheme (Samen)	flowers/Yellow mums.png	Gelbchrysantheme (Hybrid)	flowers/Yellow mums.png	100%	Wichtigster Zwischenschritt! Sieht aus wie normales Gelb.	40 Sternis
16	3	Gelbchrysantheme (Hybrid)	flowers/Yellow mums.png	Gelbchrysantheme (Hybrid)	flowers/Yellow mums.png	Lilachrysantheme (Hybrid)	flowers/Purple mums.png	25%	Weg B: Sammelt diese! (Auch möglich: 6,25% Grün, 56% Gelb, 12,5% Weiß)	\N
10	4	Orangecosmea (Hybrid)	flowers/Orange cosmos.png	Orangecosmea (Hybrid)	flowers/Orange cosmos.png	Schwarzcosmea	flowers/Black cosmos.png	6,25%	Ein sehr großes Feld wird empfohlen (weitere Kinder: 75% Orange, 18,75% Gelb).	240 Sternis
12	4	Schwarzcosmea	flowers/Black cosmos.png	Schwarzcosmea	flowers/Black cosmos.png	Schwarzcosmea	flowers/Black cosmos.png	100%	Einmal gezüchtet, leicht zu vermehren.	240 Sternis
8	4	Rotcosmea (Samen)	flowers/Red cosmos.png	Weißcosmea (Samen)	flowers/White cosmos.png	Pinkcosmea	flowers/Pink cosmos.png	100%	Sehr einfach zu züchten.	80 Sternis
9	4	Rotcosmea (Samen)	flowers/Red cosmos.png	Gelbcosmea (Samen)	flowers/Yellow cosmos.png	Orangecosmea	flowers/Orange cosmos.png	100%	Die Basis für die schwarzen Cosmeen.	80 Sternis
11	4	Pinkcosmea	flowers/Pink cosmos.png	Pinkcosmea	flowers/Pink cosmos.png	Pinkcosmea	flowers/Pink cosmos.png	50%	Weitere Kinder: 25% Rot, 25% Weiß.	80 Sternis
22	5	Orangehyazinthe	flowers/Orange hyacinths.png	Orangehyazinthe	flowers/Orange hyacinths.png	Purpurhyazinthe	flowers/Purple hyacinths.png	6,25%	Methode A (Einfach). Weitere: Orange, Blau, Gelb.	240 Sternis
23	5	Orangehyazinthe	flowers/Orange hyacinths.png	Blauhyazinthe	flowers/Blue hyacinths.png	Purpurhyazinthe	flowers/Purple hyacinths.png	25%	Methode B (Effizienter). Weitere: Orange, Blau, Rot, Weiß.	240 Sternis
24	5	Blauhyazinthe	flowers/Blue hyacinths.png	Blauhyazinthe	flowers/Blue hyacinths.png	Purpurhyazinthe	flowers/Purple hyacinths.png	25%	Funktioniert nur bei bestimmten "Hybrid-Blau"!	240 Sternis
25	5	Purpurhyazinthe	flowers/Purple hyacinths.png	Purpurhyazinthe	flowers/Purple hyacinths.png	Purpurhyazinthe	flowers/Purple hyacinths.png	100%	Einmal erreicht, sehr leicht zu vermehren.	240 Sternis
19	5	Rothyazinthe (Samen)	flowers/Red hyacinths.png	Weißhyazinthe (Samen)	flowers/White hyacinths.png	Rosahyazinthe	flowers/Pink hyacinths.png	50%	Schön für Dekoration (50% Rot).	80 Sternis
20	5	Rothyazinthe (Samen)	flowers/Red hyacinths.png	Gelbhyazinthe (Samen)	flowers/Yellow hyacinths.png	Orangehyazinthe	flowers/Orange hyacinths.png	50%	Wichtig für Lila (50% Gelb).	80 Sternis
21	5	Weißhyazinthe (Samen)	flowers/White hyacinths.png	Weißhyazinthe (Samen)	flowers/White hyacinths.png	Blauhyazinthe	flowers/Blue hyacinths.png	25%	Wichtig für Lila (75% Weiß).	80 Sternis
26	6	Rotlilie (Samen)	flowers/Red lilies.png	Rotlilie (Samen)	flowers/Red lilies.png	Dunkellilie	flowers/Black lilies.png	25%	Die restlichen 75% bleiben Rot.	80 Sternis
27	6	Rotlilie (Samen)	flowers/Red lilies.png	Pyrenäenlilie (Samen)	flowers/Yellow lilies.png	Feuerlilie	flowers/Orange lilies.png	50%	Die restlichen 50% werden Gelb.	80 Sternis
30	6	Feuerlilie	flowers/Orange lilies.png	Feuerlilie	flowers/Orange lilies.png	Dunkellilie	flowers/Black lilies.png	25%	Alternative für Schwarz (50% Orange, 25% Gelb).	80 Sternis
31	6	Dunkellilie	flowers/Black lilies.png	Dunkellilie	flowers/Black lilies.png	Dunkellilie	flowers/Black lilies.png	100%	Perfekt zum schnellen Klonen.	80 Sternis
29	6	Pyrenäenlilie (Samen)	flowers/Yellow lilies.png	Osterlilie (Samen)	flowers/White lilies.png	Osterlilie	flowers/White lilies.png	100%	Hier sind leider keine Hybride möglich.	40 Sternis
28	6	Rotlilie (Samen)	flowers/Red lilies.png	Osterlilie (Samen)	flowers/White lilies.png	Pink	flowers/Pink lilies.png	50%	Die restlichen 50% werden Rot.	\N
36	7	Schwarzrose	flowers/Black roses.png	Schwarzrose	flowers/Black roses.png	Goldrose	flowers/Gold roses.png	50%	Klappt nur, wenn mit der Goldgießkanne gegossen!	1.000 Sternis
37	7	Blaurose	flowers/Blue roses.png	Blaurose	flowers/Blue roses.png	Blaurose	flowers/Blue roses.png	100%	Herzlichen Glückwunsch, du hast die Königsdisziplin geschafft!	1.000 Sternis
33	7	Unschuldsrose (Samen)	flowers/White roses.png	Unschuldsrose (Samen)	flowers/White roses.png	Lilarose	flowers/Purple roses.png	25%	Erster wichtiger Schritt für Blau! (75% Weiß).	240 Sternis
35	7	Liebesrose (Samen)	flowers/Red roses.png	Liebesrose (Samen)	flowers/Red roses.png	Schwarzrose	flowers/Black roses.png	25%	Wichtigste Basis für die legendäre Goldrose.	240 Sternis
32	7	Liebesrose (Samen)	flowers/Red roses.png	Unschuldsrose (Samen)	flowers/White roses.png	Pinkrose	flowers/Pink roses.png	50%	Weitere 50% werden Rot.	80 Sternis
34	7	Liebesrose (Samen)	flowers/Red roses.png	Bernsteinrose (Samen)	flowers/Yellow roses.png	Sonnenrose	flowers/Orange roses.png	50%	Ebenfalls eine Vorstufe (50% Gelb).	80 Sternis
43	8	Papageitulpe (Samen)	flowers/Red tulips.png	Papageitulpe (Samen)	flowers/Red tulips.png	Römertulpe	flowers/Black tulips.png	25%	Die restlichen 75% bleiben Rot.	80 Sternis
44	8	Papageitulpe (Samen)	flowers/Red tulips.png	Viridifloratulpe (Samen)	flowers/Yellow tulips.png	Flachlandtulpe	flowers/Orange tulips.png	50%	Basis für Lila.	80 Sternis
45	8	Papageitulpe (Samen)	flowers/Red tulips.png	Triumphtulpe (Samen)	flowers/White tulips.png	Pink	flowers/Pink tulips.png	50%	Die restlichen 50% werden Rot.	\N
3	1	Rotanemone (Samen)	flowers/Red windflowers.png	Weißanemone (Samen)	flowers/White windflowers.png	Pinkanemone	flowers/Pink windflowers.png	50%	Alternative für Rosa (weitere 50% Rot).	80 Sternis
1	1	Weißanemone (Samen)	flowers/White windflowers.png	Weißanemone (Samen)	flowers/White windflowers.png	Blauanemone	flowers/Blue windflowers.png	25%	Die restlichen 75% sind Weiß.	80 Sternis
47	8	Flachlandtulpe	flowers/Orange tulips.png	Flachlandtulpe	flowers/Orange tulips.png	Wildtulpe	flowers/Purple tulips.png	6,25%	Benötigt ein großes Zuchtfeld aus Orangen Hybriden.	240 Sternis
49	8	Wildtulpe	flowers/Purple tulips.png	Wildtulpe	flowers/Purple tulips.png	Wildtulpe	flowers/Purple tulips.png	100%	Garantiert lila Nachkommen.	240 Sternis
48	8	Römertulpe	flowers/Black tulips.png	Römertulpe	flowers/Black tulips.png	Römertulpe	flowers/Black tulips.png	100%	Garantiert schwarze Nachkommen.	80 Sternis
46	8	Triumphtulpe (Samen)	flowers/White tulips.png	Triumphtulpe (Samen)	flowers/White tulips.png	Triumphtulpe	flowers/White tulips.png	100%	Keine Hybride möglich.	40 Sternis
\.


--
-- TOC entry 3893 (class 0 OID 16703)
-- Dependencies: 222
-- Data for Name: flower_seeds; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.flower_seeds (id, flower_id, color, source, image_path) FROM stdin;
1	1	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
2	1	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
3	1	Orange	Nooks Laden / Gerd	flowers/Seed Bag.png
4	4	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
5	4	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
6	4	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
7	3	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
8	3	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
9	3	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
10	5	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
11	5	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
12	5	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
13	6	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
14	6	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
15	6	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
16	7	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
17	7	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
18	7	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
19	2	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
20	2	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
21	2	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
22	8	Rot	Nooks Laden / Gerd	flowers/Seed Bag.png
23	8	Gelb	Nooks Laden / Gerd	flowers/Seed Bag.png
24	8	Weiß	Nooks Laden / Gerd	flowers/Seed Bag.png
\.


--
-- TOC entry 3889 (class 0 OID 16663)
-- Dependencies: 218
-- Data for Name: flowers; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.flowers (id, name, description, image_path, colors, created_at) FROM stdin;
1	Anemone	Wild und zart. Perfekt für natürliche Wiesen und farbenfrohe Felder.	flowers/Red windflowers.png	{Rotanemone,Orangeanemone,Weißanemone,Pinkanemone,Blauanemone,Purpuranemone}	2026-03-22 16:40:06.153351+00
2	Veilchen	Die Blume mit dem charmanten "Gesicht". Zieht besonders oft Schmetterlinge an.	flowers/Red pansies.png	{Alpenveilchen,Hornveilchen,Pfingstveilchen,Stiefmütterchen,Duftveilchen,Hainveilchen}	2026-03-22 16:40:06.153351+00
3	Chrysantheme	Versprüht wundervolle, herbstliche Vibes und ist ein echtes Deko-Highlight.	flowers/Red mums.png	{Rotchrysantheme,Gelbchrysantheme,Weißchrysantheme,Rosachrysantheme,Lilachrysantheme,Grünchrysantheme}	2026-03-22 16:40:06.153351+00
4	Cosmea	Sternenklare Blüten für verträumte Gärten. Lässt sich hervorragend kreuzen.	flowers/Red cosmos.png	{Rotcosmea,Gelbcosmea,Weißcosmea,Orangecosmea,Pinkcosmea,Schwarzcosmea}	2026-03-22 16:40:06.153351+00
5	Hyazinthe	Prachtvoll und optisch intensiv duftend. Ein Muss für jeden edlen Vorgarten.	flowers/Red hyacinths.png	{Rothyazinthe,Gelbhyazinthe,Weißhyazinthe,Rosahyazinthe,Orangehyazinthe,Blauhyazinthe,Purpurhyazinthe}	2026-03-22 16:40:06.153351+00
6	Lilie	Ein absolutes Symbol für Eleganz und Reinheit auf deiner Insel.	flowers/Red lilies.png	{Rotlilie,Pyrenäenlilie,Osterlilie,Türkenbundlilie,Feuerlilie,Dunkellilie}	2026-03-22 16:40:06.153351+00
7	Rose	Die unangefochtene Königin der Blumen. Nur hier gibt es die legendäre goldene Variante!	flowers/Red roses.png	{Liebesrose,Bernsteinrose,Unschuldsrose,Pinkrose,Sonnenrose,Lilarose,Schwarzrose,Blaurose,Goldrose}	2026-03-22 16:40:06.153351+00
8	Tulpe	Ein zeitloser Klassiker, der immer passt und für farbliche Akzente sorgt.	flowers/Red tulips.png	{Papageitulpe,Viridifloratulpe,Triumphtulpe,Grengjer-Tulpe,Flachlandtulpe,Römertulpe,Wildtulpe}	2026-03-22 16:40:06.153351+00
9	Maiglöckchen	Die absolute Krönung: Diese seltene Blume wächst völlig von allein, sobald deine Insel ein 5-Sterne-Rating erreicht hat!	flowers/Lily-of-the-valley plant.png	{Maiglöckchen}	2026-03-22 16:40:06.153351+00
\.


--
-- TOC entry 3909 (class 0 OID 17114)
-- Dependencies: 238
-- Data for Name: fossils; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.fossils (id, name, dinosaur_group, price, image_path, type) FROM stdin;
\.


--
-- TOC entry 3903 (class 0 OID 16997)
-- Dependencies: 232
-- Data for Name: item_materials; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.item_materials (id, diy_recipe_id, cooking_recipe_id, material_id, amount) FROM stdin;
1	1	\N	6	5
2	1	\N	11	1
4	2	\N	3	3
6	3	\N	3	3
7	3	\N	10	1
8	4	\N	93	1
9	4	\N	9	1
10	5	\N	1	5
12	6	\N	10	1
13	7	\N	93	1
14	7	\N	9	1
15	8	\N	6	5
17	9	\N	10	1
18	10	\N	93	1
19	10	\N	9	1
20	11	\N	6	5
22	12	\N	10	1
23	13	\N	93	1
24	13	\N	9	1
25	14	\N	2	5
27	15	\N	10	1
28	16	\N	93	1
29	16	\N	9	1
30	17	\N	1	5
31	18	\N	93	1
32	18	\N	9	1
33	19	\N	2	5
34	20	\N	3	4
35	20	\N	1	4
36	20	\N	2	4
37	21	\N	137	1
38	21	\N	3	5
39	22	\N	137	1
40	22	\N	10	5
41	23	\N	137	1
42	23	\N	28	5
43	24	\N	137	1
44	24	\N	9	1
45	25	\N	46	1
46	25	\N	47	3
47	26	\N	47	2
48	27	\N	10	3
49	27	\N	47	3
50	28	\N	9	2
51	28	\N	47	3
52	29	\N	6	5
53	29	\N	47	3
54	30	\N	65	6
55	30	\N	47	3
56	31	\N	66	3
57	31	\N	47	3
58	32	\N	67	3
59	32	\N	47	3
60	33	\N	74	3
61	33	\N	47	3
62	34	\N	135	1
63	34	\N	47	3
64	35	\N	77	1
65	35	\N	47	3
66	36	\N	143	1
67	36	\N	47	3
68	37	\N	133	1
69	37	\N	47	3
70	38	\N	20	3
71	38	\N	47	3
72	39	\N	184	1
73	39	\N	47	3
74	40	\N	169	1
75	40	\N	47	3
76	41	\N	212	1
77	41	\N	47	3
78	42	\N	194	1
79	42	\N	47	3
80	43	\N	214	1
81	43	\N	47	3
82	44	\N	175	1
83	44	\N	47	3
84	45	\N	203	1
85	45	\N	47	3
86	46	\N	204	1
87	46	\N	47	3
88	47	\N	3	3
89	47	\N	10	1
90	48	\N	2	3
91	49	\N	3	3
92	49	\N	10	1
93	50	\N	3	2
94	50	\N	2	2
95	51	\N	2	5
96	52	\N	1	5
97	53	\N	3	3
98	54	\N	2	3
99	55	\N	1	2
100	55	\N	10	1
101	56	\N	2	4
102	57	\N	3	8
103	58	\N	2	4
104	58	\N	10	2
105	59	\N	3	3
106	59	\N	2	3
107	59	\N	10	1
108	60	\N	3	4
109	60	\N	2	4
110	61	\N	44	1
111	61	\N	3	1
112	61	\N	10	1
113	62	\N	8	2
114	63	\N	8	3
115	64	\N	8	4
116	65	\N	8	5
117	66	\N	8	3
118	67	\N	10	2
119	68	\N	10	5
120	69	\N	10	3
121	70	\N	9	3
122	71	\N	9	1
123	72	\N	9	2
124	73	\N	9	2
125	73	\N	104	1
126	74	\N	9	1
127	74	\N	108	1
128	75	\N	9	1
129	75	\N	129	1
130	78	\N	9	1
131	78	\N	156	1
132	80	\N	9	1
133	80	\N	124	1
134	81	\N	9	3
135	82	\N	9	3
136	83	\N	20	10
137	83	\N	44	1
138	84	\N	20	12
139	84	\N	10	2
140	85	\N	28	5
141	85	\N	10	2
142	86	\N	21	3
143	87	\N	14	10
144	87	\N	10	2
145	88	\N	17	10
146	88	\N	2	4
147	89	\N	15	1
148	90	\N	13	1
149	90	\N	18	1
150	90	\N	14	1
151	90	\N	16	1
152	90	\N	17	1
153	91	\N	13	2
154	91	\N	18	2
155	91	\N	14	2
156	91	\N	16	2
157	91	\N	17	2
158	91	\N	15	2
159	92	\N	26	1
160	92	\N	19	1
161	92	\N	24	1
162	92	\N	23	1
163	92	\N	29	1
164	92	\N	25	1
165	93	\N	94	5
166	94	\N	95	2
167	94	\N	3	4
168	95	\N	95	6
169	96	\N	144	1
170	97	\N	108	3
171	98	\N	113	1
172	98	\N	3	1
173	99	\N	131	2
174	99	\N	3	1
175	101	\N	47	5
176	102	\N	47	3
177	102	\N	10	1
178	103	\N	47	3
179	103	\N	55	2
180	103	\N	9	2
181	104	\N	47	3
182	104	\N	56	2
183	104	\N	9	2
184	104	\N	11	5
185	105	\N	4	3
186	105	\N	8	2
187	106	\N	4	3
188	107	\N	4	4
189	108	\N	4	3
190	108	\N	2	2
191	109	\N	65	6
192	110	\N	65	4
193	110	\N	5	5
194	110	\N	8	4
195	111	\N	66	6
196	111	\N	1	2
197	111	\N	20	3
198	111	\N	8	3
199	112	\N	39	2
200	112	\N	8	3
201	113	\N	36	3
202	113	\N	10	2
203	114	\N	39	3
204	114	\N	10	2
205	115	\N	68	4
206	115	\N	1	2
207	116	\N	68	6
208	116	\N	8	4
209	117	\N	69	6
210	117	\N	68	4
211	117	\N	1	1
212	118	\N	69	8
213	118	\N	8	5
214	119	\N	23	4
215	120	\N	23	1
216	120	\N	88	3
217	121	\N	23	1
218	121	\N	10	1
219	121	\N	8	1
220	122	\N	23	4
221	122	\N	10	4
222	123	\N	10	5
223	123	\N	8	1
224	124	\N	8	4
225	124	\N	10	2
226	125	\N	20	10
227	126	\N	2	2
228	126	\N	20	5
229	126	\N	8	2
230	127	\N	77	1
231	127	\N	76	1
232	128	\N	77	1
233	128	\N	76	2
234	129	\N	90	2
235	129	\N	1	1
236	130	\N	91	5
237	130	\N	20	5
238	131	\N	90	5
239	131	\N	6	3
240	131	\N	8	2
241	132	\N	91	2
242	132	\N	10	2
243	133	\N	198	3
244	133	\N	10	2
245	134	\N	180	5
246	134	\N	8	3
247	135	\N	84	4
248	136	\N	82	4
249	136	\N	83	4
250	136	\N	85	4
251	136	\N	84	4
252	136	\N	86	4
253	136	\N	87	4
254	137	\N	6	3
255	139	\N	6	5
256	139	\N	3	5
257	140	\N	6	10
258	141	\N	6	3
259	141	\N	20	5
260	142	\N	1	5
261	142	\N	10	1
262	143	\N	3	3
263	143	\N	1	3
264	143	\N	2	3
265	143	\N	10	2
266	145	\N	3	4
267	146	\N	3	6
268	147	\N	3	6
269	148	\N	3	8
270	149	\N	3	10
271	150	\N	3	15
272	151	\N	3	12
273	152	\N	3	16
274	153	\N	3	18
275	154	\N	3	30
276	155	\N	3	5
277	155	\N	10	1
278	156	\N	3	4
279	157	\N	3	10
280	158	\N	3	10
281	159	\N	3	20
282	160	\N	1	4
283	161	\N	1	5
284	162	\N	1	8
285	163	\N	1	15
286	164	\N	1	15
287	165	\N	1	12
288	166	\N	1	8
289	168	\N	1	30
290	170	\N	3	3
291	179	\N	3	6
292	179	\N	8	4
293	179	\N	10	1
294	180	\N	3	6
295	181	\N	1	6
296	181	\N	10	2
297	182	\N	1	4
298	182	\N	10	2
299	183	\N	1	9
300	183	\N	10	3
301	184	\N	3	3
302	184	\N	2	5
303	185	\N	3	5
304	185	\N	2	7
305	186	\N	3	2
306	186	\N	2	2
307	187	\N	3	2
308	187	\N	2	3
309	188	\N	3	4
310	188	\N	2	5
311	189	\N	3	5
312	189	\N	2	8
313	190	\N	1	12
314	191	\N	1	24
315	191	\N	9	3
316	191	\N	10	6
317	192	\N	1	2
318	192	\N	2	6
319	193	\N	2	5
320	194	\N	3	8
321	195	\N	1	8
322	196	\N	2	8
323	196	\N	10	3
324	197	\N	3	6
325	198	\N	3	10
326	199	\N	3	8
327	200	\N	3	10
328	200	\N	1	7
329	201	\N	3	5
330	201	\N	10	2
331	202	\N	3	4
332	202	\N	10	2
333	203	\N	3	2
334	203	\N	2	5
335	206	\N	3	12
336	207	\N	1	2
337	207	\N	2	3
338	208	\N	1	2
339	208	\N	2	3
340	209	\N	1	4
341	209	\N	2	8
342	210	\N	3	8
343	211	\N	1	10
344	212	\N	2	6
345	212	\N	1	2
346	213	\N	3	30
347	213	\N	1	30
348	213	\N	2	30
349	213	\N	10	10
350	214	\N	3	6
351	215	\N	45	1
352	216	\N	45	3
353	217	\N	44	1
354	217	\N	43	1
355	217	\N	45	1
356	218	\N	8	6
357	219	\N	8	8
358	219	\N	10	2
359	219	\N	3	6
360	221	\N	10	12
361	221	\N	1	6
362	221	\N	8	12
363	221	\N	11	12
364	222	\N	11	3
365	223	\N	11	8
366	224	\N	11	6
367	225	\N	11	8
368	225	\N	10	2
369	227	\N	11	15
370	228	\N	11	20
371	229	\N	11	15
372	229	\N	20	15
373	230	\N	11	60
374	231	\N	11	90
375	232	\N	11	6
376	232	\N	10	3
377	232	\N	3	3
378	235	\N	11	10
379	235	\N	8	10
380	236	\N	11	30
381	237	\N	11	30
382	238	\N	11	24
383	239	\N	11	12
384	240	\N	11	18
385	241	\N	11	10
386	242	\N	11	10
387	242	\N	66	3
388	243	\N	11	10
389	243	\N	75	3
390	247	\N	3	12
391	247	\N	10	4
392	248	\N	9	5
393	249	\N	9	8
394	250	\N	9	6
395	260	\N	20	20
396	261	\N	28	10
397	262	\N	28	8
398	263	\N	28	25
399	264	\N	28	5
400	264	\N	11	20
401	265	\N	28	5
402	265	\N	11	10
403	266	\N	28	5
404	266	\N	11	5
405	267	\N	28	3
406	267	\N	11	3
407	268	\N	28	10
408	268	\N	21	20
409	268	\N	11	30
410	269	\N	21	8
411	270	\N	21	15
412	271	\N	21	10
413	271	\N	10	1
414	273	\N	21	10
415	273	\N	10	10
416	274	\N	21	5
417	274	\N	11	8
418	275	\N	21	30
419	275	\N	11	10
420	276	\N	16	10
421	276	\N	3	4
422	277	\N	17	10
423	277	\N	3	5
424	278	\N	18	10
425	278	\N	3	5
426	279	\N	18	10
427	279	\N	2	6
428	280	\N	13	10
429	280	\N	3	4
430	281	\N	13	10
431	281	\N	10	2
432	282	\N	15	4
433	282	\N	3	4
434	282	\N	8	4
435	283	\N	27	30
436	285	\N	7	3
437	285	\N	3	5
438	286	\N	94	3
439	286	\N	3	5
440	287	\N	94	5
441	287	\N	3	10
442	289	\N	97	1
443	290	\N	97	2
444	291	\N	97	4
445	292	\N	97	4
446	293	\N	97	2
447	294	\N	97	4
448	295	\N	97	5
449	296	\N	97	3
450	305	\N	47	7
451	305	\N	46	1
452	306	\N	47	15
453	306	\N	46	1
454	307	\N	47	5
455	307	\N	11	10
456	308	\N	47	5
457	308	\N	10	5
458	309	\N	47	10
459	309	\N	10	20
460	310	\N	47	10
461	310	\N	10	15
462	311	\N	47	5
463	311	\N	10	10
464	312	\N	47	10
465	312	\N	10	20
466	313	\N	47	10
467	313	\N	10	15
468	315	\N	47	15
469	315	\N	10	10
470	316	\N	69	5
471	316	\N	68	4
472	316	\N	75	4
473	316	\N	6	8
474	316	\N	8	4
475	317	\N	69	4
476	317	\N	68	5
477	317	\N	75	5
478	317	\N	6	15
479	318	\N	73	2
480	320	\N	71	2
481	320	\N	3	6
482	321	\N	74	1
483	321	\N	8	5
484	322	\N	71	3
485	323	\N	74	3
486	324	\N	23	3
487	324	\N	2	3
488	325	\N	23	14
489	325	\N	2	10
490	326	\N	23	3
491	326	\N	1	5
492	326	\N	8	1
493	327	\N	23	4
494	327	\N	20	4
495	328	\N	23	3
496	328	\N	3	4
497	329	\N	23	7
498	330	\N	23	10
499	330	\N	1	10
500	330	\N	8	3
501	331	\N	23	30
502	331	\N	1	20
503	331	\N	3	20
504	331	\N	2	20
505	331	\N	10	10
506	332	\N	23	5
507	332	\N	1	10
508	333	\N	3	5
509	333	\N	1	2
510	333	\N	2	2
511	334	\N	1	10
512	334	\N	2	5
513	335	\N	11	8
514	335	\N	8	3
515	337	\N	77	1
516	337	\N	76	3
517	338	\N	77	1
518	338	\N	76	5
519	339	\N	77	1
520	339	\N	76	8
521	340	\N	77	1
522	340	\N	76	10
523	341	\N	77	1
524	341	\N	76	6
525	342	\N	77	1
526	342	\N	76	10
527	343	\N	77	1
528	343	\N	76	3
529	344	\N	6	10
530	345	\N	1	2
531	345	\N	10	1
532	347	\N	3	3
533	347	\N	10	1
534	348	\N	1	3
535	349	\N	2	8
536	350	\N	1	5
537	351	\N	2	3
538	352	\N	3	3
539	354	\N	61	1
540	354	\N	11	2
541	355	\N	10	4
542	355	\N	8	2
543	356	\N	10	3
544	356	\N	8	1
545	357	\N	10	2
546	358	\N	10	4
547	359	\N	3	2
548	359	\N	10	2
549	360	\N	9	1
550	360	\N	10	3
551	361	\N	20	10
552	362	\N	20	5
553	362	\N	8	5
554	363	\N	20	12
555	363	\N	10	4
556	364	\N	21	5
557	365	\N	21	5
558	366	\N	16	10
559	366	\N	3	2
560	367	\N	14	10
561	367	\N	8	2
562	368	\N	15	1
563	368	\N	20	5
564	369	\N	13	2
565	369	\N	18	1
566	369	\N	14	3
567	369	\N	16	3
568	369	\N	17	1
569	371	\N	47	10
570	372	\N	47	3
571	372	\N	53	2
572	372	\N	9	2
573	372	\N	11	3
574	374	\N	4	1
575	375	\N	66	5
576	375	\N	10	1
577	376	\N	12	1
578	376	\N	41	3
579	376	\N	37	2
580	376	\N	10	2
581	377	\N	67	1
582	377	\N	41	1
583	377	\N	40	1
584	377	\N	37	1
585	377	\N	39	1
586	377	\N	38	1
587	378	\N	69	2
588	378	\N	68	3
589	378	\N	6	3
590	379	\N	6	10
591	379	\N	73	1
592	379	\N	74	1
593	379	\N	71	1
594	380	\N	23	1
595	380	\N	10	1
596	380	\N	8	1
597	381	\N	76	4
598	382	\N	91	1
599	382	\N	89	1
600	382	\N	90	1
601	382	\N	6	4
602	383	\N	89	6
603	383	\N	90	2
604	386	\N	178	10
605	389	\N	177	10
606	392	\N	206	10
607	399	\N	166	10
608	400	\N	176	10
609	406	\N	180	10
610	410	\N	86	3
611	411	\N	82	1
612	411	\N	83	1
613	411	\N	85	1
614	411	\N	84	1
615	411	\N	86	1
616	411	\N	87	1
617	412	\N	82	1
618	412	\N	83	1
619	412	\N	85	1
620	412	\N	84	1
621	412	\N	86	1
622	412	\N	87	1
623	413	\N	28	7
624	414	\N	21	5
625	414	\N	28	3
626	415	\N	\N	4
627	416	\N	3	5
628	416	\N	2	5
629	416	\N	1	5
630	417	\N	3	15
631	418	\N	3	15
632	419	\N	3	15
633	420	\N	2	15
634	421	\N	2	15
635	422	\N	1	15
636	423	\N	1	15
637	424	\N	1	15
638	425	\N	3	6
639	426	\N	44	2
640	426	\N	43	2
641	426	\N	45	2
642	427	\N	44	2
643	427	\N	43	2
644	427	\N	45	2
645	428	\N	11	10
646	429	\N	11	5
647	429	\N	8	5
648	430	\N	11	10
649	431	\N	10	8
650	432	\N	10	7
651	433	\N	9	4
652	434	\N	9	2
653	434	\N	\N	1
654	435	\N	9	4
655	436	\N	20	15
656	436	\N	3	3
657	436	\N	1	3
658	436	\N	2	3
659	437	\N	20	15
660	437	\N	2	9
661	438	\N	20	10
662	438	\N	8	10
663	439	\N	20	30
664	440	\N	28	10
665	440	\N	3	10
666	441	\N	28	10
667	442	\N	28	4
668	443	\N	21	10
669	443	\N	1	10
670	444	\N	21	10
671	444	\N	8	10
672	445	\N	21	10
673	445	\N	149	1
674	446	\N	21	10
675	446	\N	20	10
676	446	\N	11	5
677	447	\N	21	4
678	448	\N	21	6
679	449	\N	16	20
680	450	\N	16	6
681	451	\N	14	20
682	452	\N	14	6
683	453	\N	17	20
684	454	\N	17	6
685	455	\N	18	20
686	456	\N	18	6
687	457	\N	13	20
688	458	\N	13	6
689	459	\N	7	6
690	460	\N	7	5
691	461	\N	94	10
692	462	\N	95	10
693	463	\N	\N	1
694	464	\N	47	5
695	464	\N	46	1
696	465	\N	47	5
697	465	\N	46	1
698	466	\N	47	5
699	466	\N	46	1
700	467	\N	47	5
701	467	\N	46	1
702	468	\N	47	5
703	468	\N	46	1
704	469	\N	47	5
705	469	\N	46	1
706	470	\N	47	3
707	471	\N	47	1
708	471	\N	46	1
709	472	\N	4	15
710	473	\N	4	15
711	474	\N	4	6
712	475	\N	4	3
713	476	\N	4	3
714	477	\N	65	7
715	477	\N	5	3
716	478	\N	65	6
717	479	\N	65	3
718	480	\N	65	3
719	481	\N	66	10
720	481	\N	1	5
721	482	\N	66	5
722	482	\N	3	10
723	483	\N	66	10
724	483	\N	20	20
725	484	\N	66	5
726	484	\N	3	10
727	485	\N	66	6
728	486	\N	12	2
729	486	\N	41	2
730	486	\N	40	2
731	486	\N	37	2
732	486	\N	39	2
733	486	\N	38	2
734	487	\N	41	1
735	487	\N	42	1
736	487	\N	40	1
737	487	\N	37	1
738	487	\N	39	1
739	487	\N	38	1
740	488	\N	12	2
741	488	\N	40	5
742	488	\N	11	5
743	489	\N	39	3
744	490	\N	12	1
745	490	\N	40	3
746	491	\N	67	5
747	492	\N	67	3
748	492	\N	37	5
749	493	\N	67	3
750	493	\N	37	3
751	494	\N	67	3
752	494	\N	151	1
753	495	\N	67	6
754	496	\N	67	6
755	497	\N	75	10
756	497	\N	3	5
757	497	\N	20	5
758	498	\N	75	10
759	498	\N	20	15
760	499	\N	68	6
761	500	\N	75	6
762	501	\N	70	2
763	501	\N	73	2
764	501	\N	74	2
765	501	\N	71	2
766	501	\N	3	10
767	502	\N	70	1
768	502	\N	73	1
769	502	\N	74	1
770	502	\N	71	1
771	503	\N	72	1
772	503	\N	73	2
773	503	\N	74	2
774	503	\N	71	2
775	503	\N	20	10
776	504	\N	77	1
777	504	\N	76	8
778	505	\N	77	1
779	505	\N	76	8
780	506	\N	76	8
781	507	\N	76	10
782	508	\N	76	12
783	509	\N	76	3
784	509	\N	11	10
785	510	\N	76	8
786	511	\N	76	10
787	512	\N	76	8
788	513	\N	91	5
789	513	\N	89	5
790	513	\N	90	5
791	513	\N	8	5
792	514	\N	91	5
793	514	\N	89	5
794	514	\N	90	5
795	515	\N	82	2
796	515	\N	83	2
797	515	\N	85	2
798	515	\N	84	2
799	515	\N	86	2
800	515	\N	87	2
801	516	\N	82	2
802	516	\N	83	2
803	516	\N	85	2
804	516	\N	84	2
805	516	\N	86	2
806	516	\N	87	2
807	517	\N	82	1
808	517	\N	83	1
809	517	\N	85	1
810	517	\N	84	1
811	517	\N	86	1
812	517	\N	87	1
813	518	\N	3	3
814	518	\N	1	5
815	519	\N	43	2
816	520	\N	10	5
817	521	\N	10	8
818	522	\N	10	4
819	523	\N	9	5
820	524	\N	9	8
821	525	\N	9	4
822	526	\N	9	5
823	527	\N	20	5
824	528	\N	20	10
825	529	\N	20	15
826	530	\N	20	10
827	531	\N	20	10
828	532	\N	20	8
829	533	\N	20	7
830	534	\N	20	7
831	535	\N	20	20
832	536	\N	28	3
833	537	\N	28	8
834	538	\N	28	10
835	539	\N	28	5
836	540	\N	21	8
837	541	\N	21	8
838	542	\N	21	3
839	543	\N	21	15
840	544	\N	21	15
841	545	\N	16	7
842	546	\N	16	5
843	547	\N	16	8
844	548	\N	14	7
845	549	\N	14	5
846	550	\N	14	8
847	551	\N	17	7
848	552	\N	17	5
849	553	\N	17	8
850	554	\N	18	7
851	555	\N	18	5
852	556	\N	18	8
853	557	\N	13	7
854	558	\N	13	5
855	559	\N	13	8
856	560	\N	47	5
857	561	\N	47	6
858	562	\N	65	6
859	563	\N	66	7
860	564	\N	66	6
861	565	\N	39	2
862	565	\N	67	6
863	566	\N	75	7
864	567	\N	75	6
865	568	\N	68	6
866	569	\N	71	3
867	570	\N	77	1
868	570	\N	76	5
869	571	\N	76	6
870	572	\N	91	3
871	572	\N	89	3
872	572	\N	90	3
873	573	\N	198	2
874	573	\N	184	2
875	573	\N	210	2
876	574	\N	164	3
877	574	\N	191	3
878	575	\N	178	6
879	576	\N	199	2
880	576	\N	169	2
881	576	\N	211	2
882	577	\N	179	3
883	577	\N	192	3
884	578	\N	177	6
885	579	\N	200	2
886	579	\N	170	2
887	579	\N	212	3
888	580	\N	193	4
889	580	\N	185	3
890	581	\N	206	7
891	582	\N	204	2
892	582	\N	174	2
893	582	\N	216	1
894	583	\N	182	2
895	583	\N	197	2
896	583	\N	189	1
897	584	\N	209	5
898	585	\N	203	2
899	585	\N	173	2
900	585	\N	215	2
901	586	\N	196	3
902	586	\N	188	3
903	587	\N	181	3
904	587	\N	208	3
905	588	\N	166	6
906	589	\N	176	6
907	590	\N	205	2
908	590	\N	175	2
909	590	\N	217	2
910	591	\N	167	3
911	591	\N	190	3
912	592	\N	183	6
913	593	\N	201	4
914	593	\N	171	2
915	593	\N	213	2
916	594	\N	165	4
917	594	\N	194	2
918	594	\N	186	2
919	595	\N	180	6
920	596	\N	202	2
921	596	\N	172	2
922	596	\N	214	2
923	597	\N	195	2
924	597	\N	187	2
925	597	\N	214	2
926	598	\N	207	6
927	599	\N	82	2
928	600	\N	82	3
929	601	\N	82	2
930	602	\N	83	2
931	603	\N	83	3
932	604	\N	83	2
933	605	\N	85	2
934	606	\N	85	3
935	607	\N	85	2
936	608	\N	84	2
937	609	\N	84	3
938	610	\N	84	2
939	611	\N	86	2
940	612	\N	86	3
941	613	\N	86	2
942	614	\N	87	2
943	615	\N	87	3
944	616	\N	87	2
945	617	\N	82	2
946	617	\N	83	2
947	617	\N	85	2
948	617	\N	84	2
949	617	\N	86	2
950	617	\N	87	2
951	618	\N	82	3
952	618	\N	83	3
953	618	\N	85	3
954	618	\N	84	3
955	618	\N	86	3
956	618	\N	87	3
957	619	\N	82	1
958	619	\N	83	1
959	619	\N	85	1
960	619	\N	84	1
961	619	\N	86	1
962	619	\N	87	1
963	620	\N	82	1
964	620	\N	83	1
965	620	\N	85	1
966	620	\N	84	1
967	620	\N	86	1
968	620	\N	87	1
969	621	\N	10	5
970	622	\N	10	10
971	623	\N	10	20
972	624	\N	10	8
973	624	\N	3	2
974	624	\N	136	1
975	625	\N	10	3
976	626	\N	10	10
977	627	\N	3	3
978	627	\N	10	2
979	628	\N	3	6
980	628	\N	10	4
981	629	\N	3	7
982	629	\N	10	4
983	630	\N	3	12
984	630	\N	10	6
985	631	\N	3	6
986	631	\N	10	4
987	632	\N	3	20
988	632	\N	10	10
989	633	\N	103	1
990	633	\N	101	1
991	633	\N	64	30
992	633	\N	10	90
993	633	\N	9	10
994	634	\N	47	3
995	634	\N	49	2
996	634	\N	9	1
997	634	\N	11	5
998	635	\N	47	3
999	635	\N	50	2
1000	635	\N	9	1
1001	635	\N	11	8
1002	636	\N	47	3
1003	636	\N	51	2
1004	636	\N	9	2
1005	636	\N	11	6
1006	637	\N	47	3
1007	637	\N	52	2
1008	637	\N	9	2
1009	637	\N	11	3
1010	638	\N	47	3
1011	638	\N	54	2
1012	638	\N	9	2
1013	638	\N	11	4
1014	639	\N	47	3
1015	639	\N	58	2
1016	639	\N	9	2
1017	639	\N	11	12
1018	640	\N	47	3
1019	640	\N	59	2
1020	640	\N	9	2
1021	640	\N	11	5
1022	641	\N	47	3
1023	641	\N	48	2
1024	641	\N	9	2
1025	641	\N	11	4
1026	642	\N	4	8
1027	643	\N	4	7
1028	643	\N	11	6
1029	644	\N	4	15
1030	645	\N	4	7
1031	646	\N	4	3
1032	646	\N	10	1
1033	647	\N	4	8
1034	648	\N	4	5
1035	649	\N	4	3
1036	650	\N	65	6
1037	651	\N	65	7
1038	651	\N	3	3
1039	652	\N	4	3
1040	652	\N	11	8
1041	652	\N	20	3
1042	653	\N	66	5
1043	654	\N	66	8
1044	654	\N	6	4
1045	654	\N	8	5
1046	655	\N	66	10
1047	656	\N	66	6
1048	656	\N	1	4
1049	657	\N	39	5
1050	657	\N	8	3
1051	657	\N	11	4
1052	658	\N	38	5
1053	659	\N	40	7
1054	659	\N	8	3
1055	660	\N	42	4
1056	660	\N	41	4
1057	661	\N	39	5
1058	661	\N	11	3
1059	662	\N	42	3
1060	662	\N	41	3
1061	662	\N	40	3
1062	662	\N	37	3
1063	662	\N	39	3
1064	662	\N	38	3
1065	663	\N	12	2
1066	663	\N	39	2
1067	663	\N	40	5
1068	664	\N	12	1
1069	664	\N	41	3
1070	664	\N	37	2
1071	664	\N	10	2
1072	665	\N	12	1
1073	665	\N	39	1
1074	665	\N	37	4
1075	666	\N	12	2
1076	666	\N	39	3
1077	666	\N	40	5
1078	667	\N	12	1
1079	667	\N	39	1
1080	667	\N	37	2
1081	667	\N	10	2
1082	668	\N	12	1
1083	668	\N	40	4
1084	669	\N	12	2
1085	669	\N	39	1
1086	669	\N	37	2
1087	669	\N	40	5
1088	670	\N	12	1
1089	670	\N	40	10
1090	671	\N	12	2
1091	671	\N	39	1
1092	671	\N	37	3
1093	672	\N	12	1
1094	672	\N	39	1
1095	672	\N	40	2
1096	673	\N	68	3
1097	673	\N	20	5
1098	674	\N	75	3
1099	674	\N	20	4
1100	675	\N	69	3
1101	675	\N	20	5
1102	676	\N	69	3
1103	676	\N	20	5
1104	676	\N	6	3
1105	677	\N	75	3
1106	677	\N	3	3
1107	678	\N	77	1
1108	678	\N	76	4
1109	679	\N	77	1
1110	679	\N	76	8
1111	680	\N	77	1
1112	680	\N	76	6
1113	680	\N	6	2
1114	681	\N	91	3
1115	681	\N	89	3
1116	681	\N	90	2
1117	681	\N	3	5
1118	682	\N	91	6
1119	682	\N	89	6
1120	682	\N	90	4
1121	682	\N	3	5
1122	682	\N	8	5
1123	683	\N	89	9
1124	683	\N	10	3
1125	684	\N	91	3
1126	684	\N	90	4
1127	684	\N	10	3
1128	685	\N	90	6
1129	685	\N	10	5
1130	686	\N	91	8
1131	686	\N	89	8
1132	686	\N	90	6
1133	686	\N	10	6
1134	687	\N	63	3
1135	687	\N	97	1
1136	688	\N	91	3
1137	688	\N	89	2
1138	688	\N	90	1
1139	688	\N	10	3
1140	689	\N	91	10
1141	690	\N	91	2
1142	690	\N	89	2
1143	690	\N	90	2
1144	690	\N	10	5
1145	691	\N	169	3
1146	691	\N	20	10
1147	692	\N	193	5
1148	692	\N	10	3
1149	693	\N	204	5
1150	693	\N	2	3
1151	694	\N	203	10
1152	694	\N	3	5
1153	695	\N	175	5
1154	695	\N	1	3
1155	696	\N	214	5
1156	696	\N	10	3
1157	696	\N	3	3
1158	697	\N	203	1
1159	697	\N	196	2
1160	697	\N	188	2
1161	697	\N	214	2
1162	697	\N	172	1
1163	697	\N	178	4
1164	698	\N	87	3
1165	699	\N	82	4
1166	700	\N	83	4
1167	701	\N	85	4
1168	702	\N	82	1
1169	702	\N	83	1
1170	702	\N	85	1
1171	702	\N	84	1
1172	702	\N	86	1
1173	702	\N	87	1
1174	703	\N	82	1
1175	703	\N	85	1
1176	703	\N	86	1
1177	704	\N	83	1
1178	704	\N	84	1
1179	704	\N	87	1
1180	705	\N	82	2
1181	705	\N	83	2
1182	705	\N	85	2
1183	705	\N	84	2
1184	705	\N	86	2
1185	705	\N	87	2
1186	706	\N	11	30
1187	707	\N	10	12
1188	708	\N	10	8
1189	709	\N	10	3
1190	710	\N	10	5
1191	711	\N	10	3
1192	712	\N	10	14
1193	713	\N	10	10
1194	714	\N	10	3
1195	715	\N	7	1
1196	715	\N	20	3
1197	716	\N	62	1
1198	717	\N	8	5
1199	718	\N	65	7
1200	719	\N	20	4
1201	719	\N	6	6
1202	720	\N	6	3
1203	721	\N	3	6
1204	722	\N	3	8
1205	723	\N	1	6
1206	724	\N	1	8
1207	725	\N	1	4
1208	725	\N	10	2
1209	726	\N	1	10
1210	727	\N	2	6
1211	728	\N	2	6
1212	729	\N	2	8
1213	730	\N	2	10
1214	731	\N	3	6
1215	731	\N	2	4
1216	732	\N	3	3
1217	732	\N	8	3
1218	733	\N	3	3
1219	733	\N	1	3
1220	733	\N	2	3
1221	734	\N	3	2
1222	734	\N	1	2
1223	734	\N	2	2
1224	735	\N	3	2
1225	735	\N	1	2
1226	735	\N	2	2
1227	736	\N	8	6
1228	737	\N	8	8
1229	738	\N	8	4
1230	739	\N	8	4
1231	740	\N	8	4
1232	740	\N	11	4
1233	741	\N	8	2
1234	741	\N	11	2
1235	742	\N	8	2
1236	742	\N	11	2
1237	743	\N	11	4
1238	744	\N	11	6
1239	744	\N	10	3
1240	745	\N	11	8
1241	745	\N	10	2
1242	746	\N	10	3
1243	746	\N	8	3
1244	746	\N	11	3
1245	747	\N	11	6
1246	747	\N	10	2
1247	748	\N	11	3
1248	748	\N	10	1
1249	749	\N	11	3
1250	749	\N	10	1
1251	750	\N	11	16
1252	751	\N	11	8
1253	752	\N	11	8
1254	753	\N	10	4
1255	754	\N	10	6
1256	755	\N	10	5
1257	755	\N	2	3
1258	756	\N	10	5
1259	757	\N	10	3
1260	757	\N	1	3
1261	758	\N	10	8
1262	759	\N	10	4
1263	760	\N	10	4
1264	761	\N	9	8
1265	762	\N	9	4
1266	763	\N	9	4
1267	764	\N	20	10
1268	764	\N	3	3
1269	765	\N	20	10
1270	765	\N	6	5
1271	765	\N	11	2
1272	766	\N	20	3
1273	767	\N	4	6
1274	768	\N	4	6
1275	769	\N	4	3
1276	770	\N	12	1
1277	770	\N	37	5
1278	770	\N	40	5
1279	771	\N	23	3
1280	771	\N	10	5
1281	772	\N	23	1
1282	772	\N	88	2
1283	773	\N	76	5
1284	774	\N	91	1
1285	774	\N	89	1
1286	774	\N	90	1
1287	775	\N	80	1
1288	775	\N	78	1
1289	775	\N	81	1
1290	775	\N	79	1
1291	776	\N	82	1
1292	776	\N	83	1
1293	776	\N	85	1
1294	776	\N	84	1
1295	776	\N	86	1
1296	776	\N	87	1
1297	\N	1	29	5
1298	\N	2	29	5
1299	\N	3	25	5
1300	\N	4	25	5
1301	\N	5	33	1
1302	\N	5	19	2
1303	\N	6	33	1
1304	\N	6	24	2
1305	\N	7	26	2
1306	\N	7	24	1
1307	\N	7	19	1
1308	\N	8	5	2
1309	\N	9	33	1
1310	\N	9	73	1
1311	\N	9	71	1
1312	\N	10	123	2
1313	\N	11	26	1
1314	\N	11	19	1
1315	\N	11	24	1
1316	\N	11	23	1
1317	\N	12	19	3
1318	\N	13	73	1
1319	\N	13	71	1
1320	\N	13	74	1
1321	\N	14	27	10
1322	\N	14	26	1
1323	\N	15	13	1
1324	\N	15	16	1
1325	\N	15	18	1
1326	\N	15	17	1
1327	\N	15	14	1
1328	\N	16	116	1
1329	\N	16	26	1
1330	\N	17	111	1
1331	\N	18	24	3
1332	\N	19	24	2
1333	\N	19	114	1
1334	\N	20	24	2
1335	\N	21	33	2
1336	\N	21	24	3
1337	\N	22	33	1
1338	\N	22	24	1
1339	\N	22	23	1
1340	\N	23	33	2
1341	\N	23	26	1
1342	\N	23	19	1
1343	\N	24	33	2
1344	\N	24	16	1
1345	\N	24	18	1
1346	\N	24	17	1
1347	\N	25	35	2
1348	\N	25	116	1
1349	\N	26	33	2
1350	\N	26	26	3
1351	\N	27	35	2
1352	\N	27	19	3
1353	\N	28	33	2
1354	\N	28	23	3
1355	\N	29	33	2
1356	\N	29	13	1
1357	\N	29	16	1
1358	\N	29	18	1
1359	\N	29	17	1
1360	\N	29	14	1
1361	\N	30	33	2
1362	\N	30	116	1
1363	\N	31	33	2
1364	\N	31	73	1
1365	\N	31	74	1
1366	\N	32	33	2
1367	\N	32	26	1
1368	\N	32	23	1
1369	\N	33	33	2
1370	\N	33	35	2
1371	\N	34	26	3
1372	\N	35	23	3
1373	\N	36	27	10
1374	\N	37	26	3
1375	\N	38	73	1
1376	\N	38	71	1
1377	\N	38	74	1
1378	\N	38	72	1
1379	\N	39	119	2
1380	\N	40	115	1
1381	\N	40	111	1
1382	\N	40	112	1
1383	\N	41	33	2
1384	\N	42	33	3
1385	\N	43	35	3
1386	\N	44	33	3
1387	\N	44	34	1
1388	\N	45	33	3
1389	\N	45	19	1
1390	\N	45	26	1
1391	\N	45	24	1
1392	\N	46	33	2
1393	\N	46	19	3
1394	\N	47	33	2
1395	\N	47	24	3
1396	\N	48	33	2
1397	\N	48	23	3
1398	\N	49	33	3
1399	\N	49	157	1
1400	\N	50	33	3
1401	\N	50	157	1
1402	\N	51	33	3
1403	\N	51	111	1
1404	\N	52	33	3
1405	\N	52	26	3
1406	\N	53	33	3
1407	\N	53	19	3
1408	\N	54	33	3
1409	\N	54	24	3
1410	\N	55	33	3
1411	\N	55	23	3
1412	\N	56	33	3
1413	\N	56	73	1
1414	\N	56	71	1
1415	\N	56	74	1
1416	\N	57	33	3
1417	\N	57	111	1
1418	\N	58	33	3
1419	\N	58	26	2
1420	\N	59	33	3
1421	\N	59	73	2
1422	\N	59	71	2
1423	\N	60	33	3
1424	\N	60	13	1
1425	\N	60	16	1
1426	\N	60	18	1
1427	\N	60	17	1
1428	\N	60	14	1
1429	\N	61	33	3
1430	\N	61	115	1
1431	\N	61	62	2
1432	\N	62	112	2
1433	\N	63	116	1
1434	\N	64	120	1
1435	\N	65	118	1
1436	\N	66	33	3
1437	\N	66	121	1
1438	\N	67	121	1
1439	\N	67	20	5
1440	\N	68	117	1
1441	\N	68	33	1
1442	\N	69	114	1
1443	\N	70	109	1
1444	\N	70	74	1
1445	\N	71	110	1
1446	\N	71	26	1
1447	\N	71	62	1
1448	\N	72	26	3
1449	\N	73	19	1
1450	\N	73	24	1
1451	\N	73	26	1
1452	\N	73	23	1
1453	\N	74	5	3
1454	\N	75	74	2
1455	\N	76	16	3
1456	\N	77	14	3
1457	\N	78	17	3
1458	\N	79	18	3
1459	\N	80	13	3
1460	\N	81	15	3
1461	\N	82	119	1
1462	\N	83	33	1
1463	\N	83	62	3
1464	\N	84	33	3
1465	\N	84	34	2
1466	\N	84	23	2
1467	\N	85	33	3
1468	\N	85	24	2
1469	\N	86	109	1
1470	\N	86	33	2
1471	\N	87	33	1
1472	\N	87	34	1
1473	\N	88	33	1
1474	\N	88	34	2
1475	\N	89	33	1
1476	\N	89	34	1
1477	\N	90	33	1
1478	\N	90	34	1
1479	\N	90	15	1
1480	\N	91	33	1
1481	\N	91	34	1
1482	\N	91	26	1
1483	\N	91	19	1
1484	\N	91	23	1
1485	\N	92	33	1
1486	\N	92	34	2
1487	\N	93	33	1
1488	\N	93	34	1
1489	\N	94	33	1
1490	\N	94	34	2
1491	\N	95	33	1
1492	\N	95	34	1
1493	\N	96	35	1
1494	\N	96	32	1
1495	\N	97	33	1
1496	\N	97	13	1
1497	\N	97	16	1
1498	\N	97	18	1
1499	\N	97	17	1
1500	\N	97	14	1
1501	\N	98	33	1
1502	\N	98	34	1
1503	\N	98	23	2
1504	\N	99	33	1
1505	\N	99	34	1
1506	\N	99	26	1
1507	\N	99	19	1
1508	\N	99	24	1
1509	\N	100	16	2
1510	\N	101	14	2
1511	\N	102	17	2
1512	\N	103	18	2
1513	\N	104	13	2
1514	\N	105	34	1
1515	\N	105	15	2
1516	\N	106	33	2
1517	\N	106	34	1
1518	\N	107	33	2
1519	\N	107	13	1
1520	\N	107	16	1
1521	\N	107	18	1
1522	\N	107	17	1
1523	\N	107	14	1
1524	\N	108	35	2
1525	\N	108	34	1
1526	\N	108	19	2
1527	\N	109	35	2
1528	\N	109	34	1
1529	\N	109	23	2
1530	\N	110	33	1
1531	\N	110	34	1
1532	\N	110	16	1
1533	\N	111	33	1
1534	\N	111	34	1
1535	\N	111	14	1
1536	\N	112	33	1
1537	\N	112	34	1
1538	\N	112	17	1
1539	\N	113	33	1
1540	\N	113	34	1
1541	\N	113	18	1
1542	\N	114	33	1
1543	\N	114	34	1
1544	\N	114	13	1
1545	\N	115	33	1
1546	\N	115	13	1
1547	\N	115	16	1
1548	\N	115	18	1
1549	\N	115	17	1
1550	\N	115	14	1
1551	\N	116	33	1
1552	\N	116	34	1
1553	\N	116	19	1
1554	\N	117	33	2
1555	\N	117	34	2
1556	\N	118	33	2
1557	\N	118	13	1
1558	\N	118	16	1
1559	\N	118	18	1
1560	\N	118	17	1
1561	\N	118	14	1
1562	\N	119	33	2
1563	\N	119	34	1
1564	\N	120	33	2
1565	\N	120	32	1
1566	\N	121	33	2
1567	\N	121	34	1
1568	\N	121	16	2
1569	\N	122	33	2
1570	\N	122	34	1
1571	\N	122	23	2
1572	\N	123	33	2
1573	\N	123	19	1
1574	\N	123	24	1
1575	\N	124	33	2
1576	\N	124	34	2
1577	\N	125	33	2
1578	\N	125	34	2
1579	\N	125	15	2
1580	\N	126	33	2
1581	\N	126	13	1
1582	\N	126	16	1
1583	\N	126	18	1
1584	\N	126	17	1
1585	\N	126	14	1
1586	\N	127	33	3
1587	\N	127	34	2
1588	\N	127	16	2
1589	\N	128	33	3
1590	\N	128	34	2
1591	\N	128	14	2
1592	\N	129	33	3
1593	\N	129	34	2
1594	\N	129	17	2
1595	\N	130	33	3
1596	\N	130	34	2
1597	\N	130	18	2
1598	\N	131	33	3
1599	\N	131	34	2
1600	\N	131	13	2
1601	\N	132	33	3
1602	\N	132	13	1
1603	\N	132	16	1
1604	\N	132	18	1
1605	\N	132	17	1
1606	\N	132	14	1
1607	\N	133	16	2
1608	\N	134	14	2
1609	\N	135	17	2
1610	\N	136	18	2
1611	\N	137	13	2
1612	\N	138	15	2
1613	\N	139	26	2
1614	\N	140	19	2
1615	\N	141	33	1
1616	\N	141	23	1
1617	\N	141	31	1
1618	\N	141	30	1
1619	\N	141	22	1
1620	\N	17	218	1
1621	76	\N	225	1
1622	76	\N	9	1
1623	77	\N	235	1
1624	77	\N	9	1
1625	79	\N	228	1
1626	79	\N	9	1
1627	100	\N	226	3
1628	138	\N	136	1
1629	138	\N	1	10
1630	167	\N	128	2
1631	169	\N	125	2
1632	169	\N	1	3
1633	171	\N	244	1
1634	171	\N	2	2
1635	172	\N	244	1
1636	172	\N	2	3
1637	173	\N	244	1
1638	173	\N	2	4
1639	174	\N	244	1
1640	174	\N	2	8
1641	175	\N	244	1
1642	175	\N	2	12
1643	176	\N	244	1
1644	176	\N	2	17
1645	177	\N	244	1
1646	177	\N	2	3
1647	178	\N	244	1
1648	178	\N	10	2
1649	178	\N	2	5
1651	204	\N	213	3
1652	204	\N	200	3
1653	204	\N	10	2
1654	204	\N	3	8
1655	205	\N	134	1
1656	205	\N	102	1
1657	205	\N	3	8
1658	233	\N	219	1
1659	233	\N	11	15
1660	234	\N	248	1
1661	234	\N	11	20
1662	244	\N	243	1
1663	244	\N	10	6
1664	244	\N	3	12
1665	245	\N	243	1
1666	245	\N	153	1
1667	245	\N	10	3
1668	245	\N	3	4
1669	246	\N	142	1
1670	246	\N	10	6
1671	246	\N	3	12
1672	251	\N	242	1
1673	251	\N	9	2
1674	252	\N	147	1
1675	252	\N	9	2
1676	253	\N	247	1
1677	253	\N	9	2
1678	254	\N	162	1
1679	254	\N	9	2
1680	255	\N	222	1
1681	255	\N	9	1
1682	256	\N	239	1
1683	256	\N	9	2
1684	257	\N	224	1
1685	257	\N	9	2
1686	258	\N	245	1
1687	258	\N	9	5
1688	259	\N	238	1
1689	259	\N	9	3
1690	297	\N	229	3
1691	301	\N	220	5
1692	302	\N	227	3
1693	346	\N	244	1
1694	346	\N	10	1
1695	346	\N	2	2
1702	387	\N	211	3
1703	387	\N	199	3
1704	387	\N	169	3
1705	388	\N	199	3
1706	388	\N	192	3
1707	388	\N	179	3
1708	390	\N	212	3
1709	390	\N	200	3
1710	390	\N	170	3
1711	391	\N	200	3
1712	391	\N	185	3
1716	398	\N	208	3
1717	398	\N	181	6
1719	405	\N	194	3
1720	405	\N	186	3
1721	405	\N	165	3
1723	\N	17	218	1
3	2	\N	249	1
5	3	\N	249	1
16	9	\N	250	1
21	12	\N	251	1
11	6	\N	219	1
26	15	\N	252	1
1650	204	\N	173	3
1696	384	\N	210	3
1697	384	\N	198	3
1698	384	\N	184	3
1699	385	\N	210	3
1700	385	\N	164	3
1701	385	\N	191	3
1713	394	\N	189	3
1714	394	\N	182	3
1715	394	\N	197	3
1718	403	\N	183	10
1722	409	\N	207	10
\.


--
-- TOC entry 3919 (class 0 OID 32946)
-- Dependencies: 248
-- Data for Name: item_variants; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.item_variants (id, item_id, variant_name_de, pattern_name_de, image_path) FROM stdin;
\.


--
-- TOC entry 3917 (class 0 OID 32929)
-- Dependencies: 246
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.items (id, name_de, name_en, category, size, buy_price, sell_price, source, is_customizable, customization_kit_cost, is_cyrus_customizable, cyrus_customization_cost) FROM stdin;
\.


--
-- TOC entry 3897 (class 0 OID 16815)
-- Dependencies: 226
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.materials (id, name, category, source, sell_price, image_path) FROM stdin;
1	Hartholz	normal	Bäume mit einer Axt fällen	60 Sternis	64px-Hardwood_NH_Inv_Icon.png
2	Weichholz	normal	Bäume mit einer Axt fällen	60 Sternis	64px-Softwood_NH_Inv_Icon.png
3	Holz	normal	Bäume mit einer Axt fällen	60 Sternis	64px-Wood_NH_Inv_Icon.png
4	Bambus	normal	Bambus mit einer Axt fällen	80 Sternis	64px-Bamboo_Piece_NH_Inv_Icon.png
5	Bambussprosse	normal	Ausgraben (neben ausgewachsenem Bambus) / Jorna	250 Sternis	64px-Bamboo_Shoot_NH_Inv_Icon.png
6	Ast	normal	Bäume schütteln	5 Sternis	64px-Tree_Branch_NH_Inv_Icon.png
7	Wespennest	normal	Bäume schütteln	300 Sternis	64px-Wasp_Nest_NH_Inv_Icon.png
8	Lehm	normal	Aus Steinen schlagen	100 Sternis	64px-Clay_NH_Inv_Icon.png
9	Golderz	normal	Aus Steinen schlagen / Ballons	10.000 Sternis	64px-Gold_Nugget_NH_Inv_Icon.png
10	Eisenerz	normal	Aus Steinen schlagen	375 Sternis	64px-Iron_Nugget_NH_Inv_Icon.png
11	Stein	normal	Aus Steinen schlagen / Angeln	75 Sternis	64px-Stone_NH_Inv_Icon.png
12	Perle	normal	Tauchen / Von Johannes	10.000 Sternis	64px-Pearl_NH_Inv_Icon.png
13	Apfel	normal	Apfelbaum / Nooks Laden	500 Sternis	64px-Apple_NH_Inv_Icon.png
14	Kirsche	normal	Kirschbaum / Nooks Laden	500 Sternis	64px-Cherry_NH_Inv_Icon.png
15	Kokosnuss	normal	Palme	250 Sternis	64px-Coconut_NH_Inv_Icon.png
16	Orange	normal	Orangenbaum / Nooks Laden	500 Sternis	64px-Orange_NH_Inv_Icon.png
17	Pfirsich	normal	Pfirsichbaum / Nooks Laden	500 Sternis	64px-Peach_NH_Inv_Icon.png
18	Birne	normal	Birnenbaum / Nooks Laden	500 Sternis	64px-Pear_NH_Inv_Icon.png
19	Karotte	normal	Reife Karottenpflanze ernten	350 Sternis	64px-Carrot_NH_Inv_Icon.png
20	Unkraut	normal	Auf dem Boden aufsammeln	10 Sternis	64px-Clump_of_Weeds_NH_Inv_Icon.png
21	Leuchtmoos	normal	Bootsausflug (Käpten) / Archipel (DLC)	25 Sternis	64px-Glowing_Moss_NH_Inv_Icon.png
22	Grünkürbis	normal	Reife grüne Kürbispflanze ernten	350 Sternis	64px-Green_Pumpkin_NH_Inv_Icon.png
23	Orangekürbis	normal	Reife orange Kürbispflanze ernten	350 Sternis	64px-Orange_Pumpkin_NH_Inv_Icon.png
24	Kartoffel	normal	Reife Kartoffelpflanze ernten	350 Sternis	64px-Potato_NH_Inv_Icon.png
25	Zuckerrohr	normal	Reife Zuckerrohrpflanze ernten	350 Sternis	64px-Sugarcane_NH_Inv_Icon.png
26	Tomate	normal	Reife Tomatenpflanze ernten	350 Sternis	64px-Tomato_NH_Inv_Icon.png
27	Rüben	normal	Jorna (Sonntagmorgen)	9 Sternis	64px-Turnips_NH_Inv_Icon.png
28	Ranke	normal	Bootsausflug (Käpten) / Archipel (DLC)	50 Sternis	64px-Vine_NH_Inv_Icon.png
29	Weizen	normal	Reife Weizenpflanze ernten	350 Sternis	64px-Wheat_NH_Inv_Icon.png
30	Weißkürbis	normal	Reife weiße Kürbispflanze ernten	350 Sternis	64px-White_Pumpkin_NH_Inv_Icon.png
31	Gelbkürbis	normal	Reife gelbe Kürbispflanze ernten	350 Sternis	64px-Yellow_Pumpkin_NH_Inv_Icon.png
32	Brauner Zucker	normal	Kochen (Rezept)	210 Sternis	64px-Brown_Sugar_NH_Inv_Icon.png
33	Mehl	normal	Kochen (Rezept)	210 Sternis	64px-Flour_NH_Inv_Icon.png
34	Zucker	normal	Kochen (Rezept)	210 Sternis	64px-Sugar_NH_Inv_Icon.png
35	Vollkornmehl	normal	Kochen (Rezept)	210 Sternis	64px-Whole-Wheat_Flour_NH_Inv_Icon.png
36	Tritonshorn	normal	Am Strand aufsammeln	700 Sternis	64px-Venus_Comb_NH_Inv_Icon.png
37	Koralle	normal	Am Strand aufsammeln	500 Sternis	64px-Coral_NH_Inv_Icon.png
38	Kaurischnecke	normal	Am Strand aufsammeln	60 Sternis	64px-Cowrie_NH_Inv_Icon.png
39	Riesenmuschel	normal	Am Strand aufsammeln	900 Sternis	64px-Giant_Clam_NH_Inv_Icon.png
40	Sanddollar	normal	Am Strand aufsammeln	120 Sternis	64px-Sand_Dollar_NH_Inv_Icon.png
41	Kreiselschnecke	normal	Am Strand aufsammeln	180 Sternis	64px-Sea_Snail_Shell_NH_Inv_Icon.png
42	Stachelschnecke	normal	Am Strand aufsammeln	300 Sternis	64px-Conch_NH_Inv_Icon.png
43	Stiefel	normal	Angeln (Müll) / Recycling-Kiste	10 Sternis	64px-Boot_NH_Inv_Icon.png
44	Leere Dose	normal	Angeln (Müll) / Recycling-Kiste	10 Sternis	64px-Empty_Can_NH_Inv_Icon.png
45	Alter Reifen	normal	Angeln (Müll) / Recycling-Kiste	10 Sternis	64px-Old_Tire_NH_Inv_Icon.png
46	Riesensternensplitter	normal	Am Strand (nach Meteoritenschauer)	2.500 Sternis	64px-Large_Star_Fragment_NH_Inv_Icon.png
47	Sternensplitter	normal	Am Strand (nach Meteoritenschauer)	250 Sternis	64px-Star_Fragment_NH_Inv_Icon.png
48	Fische-Splitter	normal	Sternschnuppen (20. Feb. - 20. März)	500 Sternis	64px-Pisces_Fragment_NH_Inv_Icon.png
49	Widder-Splitter	normal	Sternschnuppen (21. März - 19. April)	500 Sternis	64px-Aries_Fragment_NH_Inv_Icon.png
50	Stier-Splitter	normal	Sternschnuppen (20. April - 20. Mai)	500 Sternis	64px-Taurus_Fragment_NH_Inv_Icon.png
51	Zwillinge-Splitter	normal	Sternschnuppen (21. Mai - 21. Juni)	500 Sternis	64px-Gemini_Fragment_NH_Inv_Icon.png
52	Krebs-Splitter	normal	Sternschnuppen (22. Juni - 22. Juli)	500 Sternis	64px-Cancer_Fragment_NH_Inv_Icon.png
53	Löwe-Splitter	normal	Sternschnuppen (23. Juli - 22. Aug.)	500 Sternis	64px-Leo_Fragment_NH_Inv_Icon.png
54	Jungfrau-Splitter	normal	Sternschnuppen (23. Aug. - 22. Sept.)	500 Sternis	64px-Virgo_Fragment_NH_Inv_Icon.png
55	Waage-Splitter	normal	Sternschnuppen (23. Sept. - 23. Okt.)	500 Sternis	64px-Libra_Fragment_NH_Inv_Icon.png
56	Skorpion-Splitter	normal	Sternschnuppen (24. Okt. - 22. Nov.)	500 Sternis	64px-Scorpius_Fragment_NH_Inv_Icon.png
57	Schütze-Splitter	normal	Sternschnuppen (23. Nov. - 21. Dez.)	500 Sternis	64px-Sagittarius_Fragment_NH_Inv_Icon.png
58	Steinbock-Splitter	normal	Sternschnuppen (22. Dez. - 19. Jan.)	500 Sternis	64px-Capricorn_Fragment_NH_Inv_Icon.png
59	Wassermann-Splitter	normal	Sternschnuppen (20. Jan. - 19. Feb.)	500 Sternis	64px-Aquarius_Fragment_NH_Inv_Icon.png
249	Wackelaxt	other	Basteln / Nooks Laden	200 Sternis	../diy/tools/64px-Flimsy_Axe_NH_Icon.png
61	Fossil	normal	Ausgraben	100 Sternis	64px-Fossil_NH_Inv_Icon.png
62	Teppichmuschel	normal	Am Strand ausgraben	100 Sternis	64px-Manila_Clam_NH_Inv_Icon.png
63	Rotes Geschenkpapier	normal	Nooks Laden	60 Sternis	64px-Red_Wrapping_Paper_NH_Inv_Icon.png
64	Rost-Bauteil	normal	Recycling-Kiste / Gulliver / Gullivarrr	10 Sternis	64px-Rusted_Part_NH_Inv_Icon.png
65	Frühlingsbambus	seasonal	Bambus im Frühling fällen	200 Sternis	64px-Young_Spring_Bamboo_NH_Inv_Icon.png
66	Kirschblüte	seasonal	Mit dem Kescher fangen (Frühling)	200 Sternis	64px-Cherry-Blossom_Petal_NH_Inv_Icon.png
67	Sommermuschel	seasonal	Am Strand aufsammeln (Sommer)	600 Sternis	64px-Summer_Shell_NH_Inv_Icon.png
68	Eichel	seasonal	Laubbäume schütteln (Herbst)	200 Sternis	64px-Acorn_NH_Inv_Icon.png
69	Zapfen	seasonal	Nadelbäume schütteln (Herbst)	200 Sternis	64px-Pine_Cone_NH_Inv_Icon.png
70	Elegantpilz	seasonal	Bei Bäumen (Pilz-Saison / Herbst)	10.000 Sternis	64px-Elegant_Mushroom_NH_Inv_Icon.png
71	Flachpilz	seasonal	Bei Bäumen (Pilz-Saison / Herbst)	200 Sternis	64px-Flat_Mushroom_NH_Inv_Icon.png
72	Seltenpilz	seasonal	Ausgraben bei Bäumen (Pilz-Saison)	16.000 Sternis	64px-Rare_Mushroom_NH_Inv_Icon.png
73	Rundpilz	seasonal	Bei Bäumen (Pilz-Saison / Herbst)	200 Sternis	64px-Round_Mushroom_NH_Inv_Icon.png
74	Dürrpilz	seasonal	Bei Bäumen (Pilz-Saison / Herbst)	300 Sternis	64px-Skinny_Mushroom_NH_Inv_Icon.png
75	Herbstblatt	seasonal	Mit dem Kescher fangen (Herbst)	200 Sternis	64px-Maple_Leaf_NH_Inv_Icon.png
76	Schneeflocke	seasonal	Mit dem Kescher fangen (Winter)	200 Sternis	64px-Snowflake_NH_Inv_Icon.png
77	Riesenschneeflocke	seasonal	Schnemil perfekt bauen (Winter)	2.500 Sternis	64px-Large_Snowflake_NH_Inv_Icon.png
78	Azurfeder	seasonal	Mit Kescher fangen (Karneval)	200 Sternis	64px-Blue_Feather_NH_Inv_Icon.png
79	Lilafeder	seasonal	Mit Kescher fangen (Karneval)	200 Sternis	64px-Purple_Feather_NH_Inv_Icon.png
80	Rubinfeder	seasonal	Mit Kescher fangen (Karneval)	200 Sternis	64px-Red_Feather_NH_Inv_Icon.png
81	Smaragdfeder	seasonal	Mit Kescher fangen (Karneval)	200 Sternis	64px-Green_Feather_NH_Inv_Icon.png
82	Erd-Glücksei	seasonal	Aus dem Boden ausgraben (Häschentag)	200 Sternis	64px-Earth_Egg_NH_Inv_Icon.png
83	Fels-Glücksei	seasonal	Aus Steinen schlagen (Häschentag)	200 Sternis	64px-Stone_Egg_NH_Inv_Icon.png
84	Holz-Glücksei	seasonal	Bäume mit der Axt schlagen (Häschentag)	200 Sternis	64px-Wood_Egg_NH_Inv_Icon.png
85	Laub-Glücksei	seasonal	Laubbäume schütteln (Häschentag)	200 Sternis	64px-Leaf_Egg_NH_Inv_Icon.png
86	Luft-Glücksei	seasonal	Ballons abschießen (Häschentag)	200 Sternis	64px-Sky_Egg_NH_Inv_Icon.png
87	Wasser-Glücksei	seasonal	Angeln (Häschentag)	200 Sternis	64px-Water_Egg_NH_Inv_Icon.png
88	Bonbon	seasonal	Nooks Laden (Halloween) / Nachbarn	30 Sternis	64px-Candy_NH_Inv_Icon.png
89	Blauschmuck	seasonal	Geschmückten Nadelbaum schütteln (Festtage)	50 Sternis	64px-Blue_Ornament_NH_Inv_Icon.png
90	Goldschmuck	seasonal	Geschmückten Nadelbaum schütteln (Festtage)	50 Sternis	64px-Gold_Ornament_NH_Inv_Icon.png
91	Rotschmuck	seasonal	Geschmückten Nadelbaum schütteln (Festtage)	50 Sternis	64px-Red_Ornament_NH_Inv_Icon.png
93	Standard-Werkzeuge	other	Basteln / Nooks Laden	600 - 625 Sternis	64px-Axe_NH_Inv_Icon.png
250	Wackelangel	other	Basteln / Nooks Laden	100 Sternis	../diy/tools/64px-Flimsy_Fishing_Rod_NH_Icon.png
251	Wackelkescher	other	Basteln / Nooks Laden	100 Sternis	../diy/tools/64px-Flimsy_Net_NH_Icon.png
252	Wackelgießkanne	other	Basteln / Nooks Laden	100 Sternis	../diy/tools/64px-Flimsy_Watering_Can_NH_Icon.png
101	Goldrüstung	other	Basteln	80.000 Sternis	64px-Dress-Up_NH_Inv_Icon.png
124	Armbanduhr	other	Nooks Laden / Ferienhausagentur (DLC)	17.000 Sternis	64px-Dress-Up_NH_Inv_Icon.png
100	Baby- / Mama- / Papabär	other	Nooks Laden	450+ Sternis	../diy/Housewares/Giant teddy bear.png
125	Baumstammbank	other	Basteln	600 Sternis	../diy/Housewares/Log bench.png
126	Baumstammhocker	other	Basteln	480 Sternis	../diy/Housewares/Log stool.png
127	Baumstammpfahl	other	Basteln	360 Sternis	../diy/Housewares/Log stakes.png
128	Baumstammsessel	other	Basteln	960 Sternis	../diy/Housewares/Log chair.png
94	Buch	other	Nooks Laden	72 Sternis	../diy/Misc/Stack of books.png
129	Daruma	other	Basteln	3.630 Sternis	../diy/Misc/Dharma.png
96	Dokumentenstapel	other	Basteln	400 Sternis	../diy/Misc/Document stack.png
99	Zen-Kissen	other	Nooks Laden	125 Sternis	../diy/Housewares/Pile of zen cushions.png
107	Fischbehälter / Skateboard / Einkaufskorb	other	Nooks Laden	Variiert	../diy/Housewares/Stacked fish containers.png
131	Flaschenkiste	other	Nooks Laden / Ferienhausagentur (DLC)	120 Sternis	../diy/Misc/Stacked bottle crates.png
137	Leiter	other	Basteln	1.440 Sternis	64px-Ladder_NH_Inv_Icon.png
145	Plattenrüstung	other	Basteln	7.500 Sternis	64px-Dress-Up_NH_Inv_Icon.png
149	Ruinenwand	other	Aziza (Saharah)	750 Sternis	64px-Wallpaper_NH_Inv_Icon.png
150	Samurairüstung	other	Nooks Laden / Ferienhausagentur (DLC)	37.500 Sternis	64px-Dress-Up_NH_Inv_Icon.png
151	Sandstrandboden	other	Basteln	4.120 Sternis	64px-Flooring_NH_Inv_Icon.png
152	Schleuder	other	Nepp / Nooks Laden / Basteln	225 Sternis	64px-Slingshot_NH_Inv_Icon.png
155	Shoji-Wand	other	Nooks Laden	750 Sternis	64px-Wallpaper_NH_Inv_Icon.png
157	Tomatenpüree	other	Kochen	1.260 Sternis	64px-Dishes_NH_Inv_Icon.png
146	Prunkvase	other	Nooks Laden / Ferienhausagentur (DLC)	32.500 Sternis	../diy/Housewares/Golden vase.png
109	Flunder	other	Angeln	800 Sternis	../faunapedia/fish/Olive Flounder.png
110	Kaiserschnapper	other	Angeln	3.000 Sternis	../faunapedia/fish/Red Snapper.png
111	Kalmar	other	Angeln	500 Sternis	../faunapedia/fish/Squid.png
112	Kammmuschel	other	Tauchen	1.200 Sternis	../faunapedia/sea_creatures/Scallop.png
113	Karpfen	other	Angeln	300 Sternis	../faunapedia/fish/Carp.png
114	Kliesche	other	Angeln	300 Sternis	../faunapedia/fish/Dab.png
115	Kuruma-Garnele	other	Tauchen	1.400 Sternis	../faunapedia/sea_creatures/Sweet Shrimp.png
116	Lachs	other	Angeln	700 Sternis	../faunapedia/fish/Salmon.png
117	Makrele	other	Angeln	150 Sternis	../faunapedia/fish/Horse Mackerel.png
118	Marlin	other	Angeln	10.000 Sternis	../faunapedia/fish/Blue Marlin.png
119	Sardelle	other	Angeln	200 Sternis	../faunapedia/fish/Anchovy.png
120	Schnabelbarsch	other	Angeln	5.000 Sternis	../faunapedia/fish/Barred Knifejaw.png
121	Seebarsch	other	Angeln	400 Sternis	../faunapedia/fish/Sea Bass.png
122	Tigergarnele	other	Tauchen	3.000 Sternis	../faunapedia/sea_creatures/Tiger Prawn.png
123	Wakame-Alge	other	Tauchen	600 Sternis	../faunapedia/sea_creatures/Seaweed.png
218	Botan-Garnele	other	Tauchen	1.400 Sternis	../faunapedia/sea_creatures/Sweet Shrimp.png
219	Wackelschaufel	other	Basteln / Nooks Laden	100 Sternis	../diy/tools/64px-Flimsy_Shovel_NH_Icon.png
226	99.000-Sterni-Sack	other	Sternis	\N	64px-99k_Bells_NH_Inv_Icon.png
248	Schaufel	other	Basteln	\N	64px-Shovel_NH_Inv_Icon.png
244	Bauklotzset	other	Basteln	\N	../diy/Misc/Wooden-block toy.png
245	Obskuraltar	other	Basteln	\N	../diy/Housewares/Forbidden altar.png
242	Ritterrüstung	other	Basteln	\N	../diy/Housewares/Plate armor.png
243	Eisen-Holz-Kommode	other	Basteln	\N	../diy/Housewares/Ironwood dresser.png
222	Edel-Vase	other	Nooks Laden	\N	../diy/Housewares/Golden vase.png
220	Einkaufskorb	other	Nooks Laden	\N	../diy/Housewares/Stacked shopping baskets.png
229	Fernost-Kissen	other	Nooks Laden	\N	../diy/Housewares/Pile of zen cushions.png
227	Fischkiste	other	Nooks Laden	\N	../diy/Housewares/Stacked fish containers.png
104	Glückskatze	other	Gulliver	1.675 Sternis	../diy/Misc/Lucky gold cat.png
132	Häschen-Deko	other	Nooks Laden / Ferienhausagentur (DLC)	425 Sternis	../diy/Misc/Golden garden bunny.png
228	Hasen-Gartendeko	other	Nooks Laden	\N	../diy/Misc/Golden garden bunny.png
106	Holzklotz-Spielzeug	other	Basteln	360 Sternis	../diy/Misc/Wooden-block toy.png
97	Karton	other	Recycling-Kiste / Nooks Laden	25 Sternis	../diy/Housewares/Small cardboard boxes.png
102	Kiefern-Bonsai	other	Basteln	4.200 Sternis	../diy/Misc/Pine bonsai tree.png
134	Kirschblüten-Bonsai	other	Basteln	3.300 Sternis	../diy/Misc/Cherry-blossom bonsai.png
105	Klavier (Aufrecht)	other	Nooks Laden	13.250 Sternis	../diy/Housewares/Street piano.png
135	Kürbislaterne	other	Basteln / Nooks Laden	1.400 Sternis	../diy/Misc/Spooky lantern.png
136	Lagerfeuer	other	Basteln	30 Sternis	../diy/Housewares/Campfire.png
138	Leuchtmoosglas	other	Basteln	150 Sternis	../diy/Misc/Glowing-moss jar.png
139	Lore	other	Nooks Laden / Ferienhausagentur (DLC)	950 Sternis	../diy/Housewares/Gold-nugget mining car.png
238	Minenlore	other	Nooks Laden	\N	../diy/Housewares/Gold-nugget mining car.png
95	Magazin	other	Nooks Laden	52 Sternis	../diy/Misc/Stacked magazines.png
225	Metallgefäß	other	Nooks Laden	\N	../diy/Housewares/Suspicious cauldron.png
141	Metalltopf	other	Nooks Laden / Ferienhausagentur (DLC)	1.250 Sternis	../diy/Misc/Imperial pot.png
108	Mini-Daruma	other	Smeralda	605 Sternis	../diy/Misc/Mini golden dharma.png
142	Mini-Werkbank	other	Basteln	2.580 Sternis	../diy/Housewares/Mini DIY workbench.png
148	Ruinen-Altar	other	Basteln	4.500 Sternis	../diy/Housewares/Forbidden altar.png
143	Ohs-Stehaufmännchen	other	Basteln	9.600 Sternis	../diy/Misc/Wobbling Zipper toy.png
98	Ölfass	other	Nooks Laden	162 Sternis	../diy/Housewares/Oil-barrel bathtub.png
144	Papierhaufen	other	Basteln	400 Sternis	../diy/Housewares/Scattered papers.png
103	Rakete	other	Basteln	20.000 Sternis	../diy/Housewares/Rocket.png
147	Rohrsystem	other	Nooks Laden / Ferienhausagentur (DLC)	1.150 Sternis	../diy/Housewares/Golden meter and pipes.png
153	Schneidebrett	other	Basteln	990 Sternis	../diy/Misc/Cutting board.png
154	Senmaizuke-Fass	other	Basteln	600 Sternis	../diy/Housewares/Senmaizuke barrel.png
156	Sparschwein	other	Nooks Laden / Ferienhausagentur (DLC)	185 Sternis	../diy/Misc/Golden piggy bank.png
158	Trinkbrunnen	other	Basteln	2.700 Sternis	../diy/Housewares/Drinking fountain.png
160	Zahnrad	other	Nooks Laden (ausgebaut)	375 Sternis	../diy/wall-mounted/Golden gears.png
161	Zahnrad-Apparatur	other	Basteln	2.250 Sternis	../diy/Housewares/Gear apparatus.png
247	Zahnradapparatur	other	Basteln	\N	../diy/Housewares/Gear apparatus.png
162	Zahnradturm	other	Basteln	3.000 Sternis	../diy/Housewares/Gear tower.png
163	Zierteller	other	Nooks Laden / Ferienhausagentur (DLC)	3.500 Sternis	../diy/Misc/Golden decorative plate.png
130	Festtagslampion	other	Nooks Laden / Ferienhausagentur (DLC)	250 Sternis	64px-Furniture_NH_Inv_Icon.png
133	Hochzeitsblumenständer	other	Björn (Cyrus)	1.000 Sternis	64px-Furniture_NH_Inv_Icon.png
140	Malkasten	other	Nooks Laden	127 Sternis	64px-Furniture_NH_Inv_Icon.png
159	Viereck-Badewanne	other	Nooks Laden / Ferienhausagentur (DLC)	1.725 Sternis	64px-Furniture_NH_Inv_Icon.png
240	Hochzeits-Blumenständer	other	Björn	\N	64px-Furniture_NH_Inv_Icon.png
239	Quadratbadebecken	other	Nooks Laden	\N	64px-Furniture_NH_Inv_Icon.png
235	Schmuckteller	other	Nooks Laden	\N	64px-Furniture_NH_Inv_Icon.png
224	Samuraikostüm	other	Nooks Laden	\N	64px-Dress-Up_NH_Inv_Icon.png
172	Pyrenäenlilie	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow lilies.png
215	Unschuldsrose	normal	Pflanze pflücken	40 Sternis	../flowers/White roses.png
173	Bernsteinrose	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow roses.png
203	Liebesrose	normal	Pflanze pflücken	40 Sternis	../flowers/Red roses.png
216	Triumphtulpe	normal	Pflanze pflücken	40 Sternis	../flowers/White tulips.png
174	Viridifloratulpe	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow tulips.png
204	Papageitulpe	normal	Pflanze pflücken	40 Sternis	../flowers/Red tulips.png
217	Pfingstveilchen	normal	Pflanze pflücken	40 Sternis	../flowers/White pansies.png
175	Hornveilchen	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow pansies.png
205	Alpenveilchen	normal	Pflanze pflücken	40 Sternis	../flowers/Red pansies.png
164	Blauanemone	normal	Pflanze pflücken	80 Sternis	../flowers/Blue windflowers.png
191	Pinkanemone	normal	Pflanze pflücken	80 Sternis	../flowers/Pink windflowers.png
193	Pinkcosmea	normal	Pflanze pflücken	80 Sternis	../flowers/Pink cosmos.png
207	Dunkellilie	normal	Pflanze pflücken	80 Sternis	../flowers/Black lilies.png
187	Feuerlilie	normal	Pflanze pflücken	80 Sternis	../flowers/Orange lilies.png
195	Türkenbundlilie	normal	Pflanze pflücken	80 Sternis	../flowers/Pink lilies.png
196	Pinkrose	normal	Pflanze pflücken	80 Sternis	../flowers/Pink roses.png
188	Sonnenrose	normal	Pflanze pflücken	80 Sternis	../flowers/Orange roses.png
197	Grengjer-Tulpe	normal	Pflanze pflücken	80 Sternis	../flowers/Pink tulips.png
189	Flachlandtulpe	normal	Pflanze pflücken	80 Sternis	../flowers/Orange tulips.png
209	Römertulpe	normal	Pflanze pflücken	80 Sternis	../flowers/Black tulips.png
167	Duftveilchen	normal	Pflanze pflücken	80 Sternis	../flowers/Blue pansies.png
169	Gelbchrysantheme	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow mums.png
170	Gelbcosmea	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow cosmos.png
171	Gelbhyazinthe	normal	Pflanze pflücken	40 Sternis	../flowers/Yellow hyacinths.png
199	Rotchrysantheme	normal	Pflanze pflücken	40 Sternis	../flowers/Red mums.png
200	Rotcosmea	normal	Pflanze pflücken	40 Sternis	../flowers/Red cosmos.png
201	Rothyazinthe	normal	Pflanze pflücken	40 Sternis	../flowers/Red hyacinths.png
202	Rotlilie	normal	Pflanze pflücken	40 Sternis	../flowers/Red lilies.png
211	Weißchrysantheme	normal	Pflanze pflücken	40 Sternis	../flowers/White mums.png
212	Weißcosmea	normal	Pflanze pflücken	40 Sternis	../flowers/White cosmos.png
213	Weißhyazinthe	normal	Pflanze pflücken	40 Sternis	../flowers/White hyacinths.png
210	Weißanemone	normal	Pflanze pflücken	40 Sternis	../flowers/White windflowers.png
184	Orangeanemone	normal	Pflanze pflücken	40 Sternis	../flowers/Orange windflowers.png
198	Rotanemone	normal	Pflanze pflücken	40 Sternis	../flowers/Red windflowers.png
214	Osterlilie	normal	Pflanze pflücken	40 Sternis	../flowers/White lilies.png
185	Orangecosmea	normal	Pflanze pflücken	80 Sternis	../flowers/Orange cosmos.png
186	Orangehyazinthe	normal	Pflanze pflücken	80 Sternis	../flowers/Orange hyacinths.png
192	Rosachrysantheme	normal	Pflanze pflücken	80 Sternis	../flowers/Pink mums.png
194	Rosahyazinthe	normal	Pflanze pflücken	80 Sternis	../flowers/Pink hyacinths.png
190	Stiefmütterchen	normal	Pflanze pflücken	80 Sternis	../flowers/Orange pansies.png
166	Blaurose	normal	Pflanze pflücken	1.000 Sternis	../flowers/Blue roses.png
176	Goldrose	normal	Pflanze pflücken	1.000 Sternis	../flowers/Gold roses.png
177	Grünchrysantheme	normal	Pflanze pflücken	240 Sternis	../flowers/Green mums.png
181	Lilarose	normal	Pflanze pflücken	240 Sternis	../flowers/Purple roses.png
206	Schwarzcosmea	normal	Pflanze pflücken	240 Sternis	../flowers/Black cosmos.png
208	Schwarzrose	normal	Pflanze pflücken	240 Sternis	../flowers/Black roses.png
178	Purpuranemone	normal	Pflanze pflücken	240 Sternis	../flowers/Purple windflowers.png
180	Purpurhyazinthe	normal	Pflanze pflücken	240 Sternis	../flowers/Purple hyacinths.png
182	Wildtulpe	normal	Pflanze pflücken	240 Sternis	../flowers/Purple tulips.png
183	Hainveilchen	normal	Pflanze pflücken	240 Sternis	../flowers/Purple pansies.png
165	Blauhyazinthe	normal	Pflanze pflücken	80 Sternis	../flowers/Blue hyacinths.png
179	Lilachrysantheme	normal	Pflanze pflücken	80 Sternis	../flowers/Purple mums.png
\.


--
-- TOC entry 3913 (class 0 OID 24737)
-- Dependencies: 242
-- Data for Name: special_npcs; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.special_npcs (id, name_de, name_en, role, species, gender, birthday, image_path, description) FROM stdin;
1	Eugen	Blathers	Museumsleiter	Eule	Männlich	24. September	museum/Eugen.png	<p>Wer die Insel betritt, wird früher oder später auf das markante, grüne Zelt (und später das prachtvolle Museumsgebäude) stoßen. Darin residiert Eugen (engl. Blathers), eine Eule von Welt, deren Wissen nur noch von ihrem immensen Schlafbedürfnis am helllichten Tag übertroffen wird.</p>\r\n\r\n<h3>🦉 Ein Professor mit Tag-Nacht-Rhythmus</h3>\r\n<p>Als Eule ist Eugen von Natur aus nachtaktiv. Wer ihn tagsüber im Museum besucht, wird ihn meist tief schlummernd vorfinden. Ein kurzes Anstupsen genügt jedoch, um ihn mit einem erschrockenen <em>„Hu... Was?!“</em> aus seinen Träumen zu reißen. Trotz der anfänglichen Verwirrung ist er sofort bereit, seiner Arbeit als Kurator mit unbändiger Leidenschaft nachzugehen.</p>\r\n\r\n<h3>🏛️ Die drei Säulen des Wissens (und eine große Angst)</h3>\r\n<p>Eugen ist nicht einfach nur ein Verwalter; er ist ein wandelndes Lexikon. Seine Expertise erstreckt sich über drei Kerngebiete, doch seine Begeisterung ist ungleich verteilt:</p>\r\n<ul class="ac-list">\r\n    <li><strong>Fossilien:</strong> Eugens wahre Leidenschaft. Wenn du ihm ein Skelettteil bringst, leuchten seine Augen. Er liebt es, die prähistorischen Zusammenhänge zu erklären und die Evolution der Inselbewohner zu rekonstruieren.</li>\r\n    <li><strong>Fische & Kunst:</strong> Hier zeigt er sich als kultivierter Genießer. Er bewundert die Ästhetik der Flossen und die Pinselstriche alter Meister – auch wenn er manchmal kurz innehalten muss, um den wissenschaftlichen Kontext zu prüfen.</li>\r\n    <li><strong>Insekten:</strong> Das „Sorgenkind“ seiner Karriere. Eugen leidet unter einer tiefsitzenden Entomophobie. Obwohl er pflichtbewusst jedes Krabbeltier für die Sammlung annimmt, kann er seinen Ekel kaum verbergen. Seine Beschreibungen von Käfern sind oft geprägt von Adjektiven wie „widerwärtig“ oder „furchteinflößend“.</li>\r\n</ul>\r\n\r\n<h3>✨ Der Charme der Abschweifung</h3>\r\n<p>Eugen ist bekannt für seine „Informationsschübe“. Wer ihn bittet, mehr über eine Spende zu erzählen, sollte etwas Zeit mitbringen. In langen, oft humorvollen Monologen erfährt der Spieler kuriose Details aus der Biologie oder Geschichte. Dabei ist er stets der Inbegriff von Höflichkeit – ein wahrer Gentleman des Museums.</p>\r\n<div class="fun-fact-box"><strong>Fun Fact:</strong> Eugen hat eine Schwester namens Eufemia, die sich im Gegensatz zu ihm nicht für das Erdgebundene, sondern für die Sterne und Sternbilder interessiert. Das akademische Gen liegt also definitiv in der Familie!</div>\r\n\r\n<h3>❤️ Warum wir Eugen lieben</h3>\r\n<p>Ohne Eugen wäre das Museum nur ein leeres Gebäude. Er ist es, der den Fundstücken eine Bedeutung gibt. Sein Enthusiasmus (außer bei Kakerlaken) ist ansteckend und macht das Sammeln von Exponaten zu einer Bildungsreise, die das Inselleben erst so richtig bereichert.</p>
2	Kofi	Brewster	Barista im Taubenschlag	Taube	Männlich	15. Oktober	museum/Kofi.png	<p>Wenn der Trubel auf der Insel zu groß wird und das ständige „Huhu!“ der Nachbarn an den Nerven zehrt, gibt es einen Ort der absoluten Ruhe: das Café Taubenschlag im Obergeschoss des Museums. Dort, hinter dem Tresen aus dunklem Holz, steht Kofi (engl. Brewster). Er ist eine Taube weniger Worte, aber von exzellentem Geschmack.</p>\r\n\r\n<h3>☕ Perfektion in jeder Tasse</h3>\r\n<p>Kofi ist kein gewöhnlicher Gastronom; er ist ein Handwerker. Für ihn ist Kaffee kein bloßes Getränk, sondern eine Zeremonie. Wer bei ihm bestellt, bekommt keine hippen Kaltgetränke mit zu viel Sirup, sondern handgebrühten, heißen Kaffee.</p>\r\n<ul class="ac-list">\r\n    <li><strong>Die goldene Regel:</strong> Kaffee schmeckt am besten, wenn er heiß ist. Wer den Fehler macht, die Tasse abkühlen zu lassen, erntet von Kofi einen Blick, der kälter ist als der vergessene Espresso.</li>\r\n    <li><strong>Das Geheimnis:</strong> Gelegentlich bietet er Stammgästen einen Schuss „Taubenmilch“ an. Was genau das ist? Nun, in der Natur ist es eine nährstoffreiche Substanz zur Fütterung von Jungvögeln – im Spiel ist es Kofis ganz persönlicher Vertrauensbeweis.</li>\r\n</ul>\r\n\r\n<h3>🤫 Ein Mann, ein Wort (oder gar keines)</h3>\r\n<p>Zu Beginn deiner Freundschaft mit Kofi wird er dich mit einer stoischen Professionalität behandeln, die fast schon kühl wirkt. Er antwortet oft nur mit einem knappen <em>„...“</em> oder einem schlichten <em>„Ganz wie Sie wünschen.“</em> Doch Kofi ist ein Beobachter. Mit jedem Besuch taut er ein wenig mehr auf. Er erinnert sich an deine Vorlieben und beginnt schließlich, kleine Anekdoten zu teilen oder dir besondere Geschenke zu machen. Er ist der lebende Beweis dafür, dass man nicht laut sein muss, um eine tiefe Verbindung aufzubauen.</p>\r\n\r\n<h3>🏺 Die Leidenschaft für das Verborgene</h3>\r\n<p>Neben der Bohne schlägt Kofis Herz für etwas, das viele auf den ersten Blick seltsam finden: Gurgoiden. Die tanzenden, rhythmischen Tonfiguren sind seine große Sammelleidenschaft. In seinem Lager hinter dem Tresen hortet er diese kleinen Kerle, und wer sein Vertrauen gewinnt, erhält von ihm sogar Rezepte, um eigene Gurgoiden-Fragmente zu züchten.</p>\r\n<div class="fun-fact-box"><strong>Atmosphären-Check:</strong> Im Taubenschlag herrscht ein ganz eigener Vibe. Die sanfte Jazz-Musik, das Klappern der Tassen und Kofis ruhige Art machen das Café zum ultimativen Rückzugsort für alle, die das Entschleunigte lieben.</div>\r\n\r\n<h3>❤️ Warum Kofi unverzichtbar ist</h3>\r\n<p>Kofi bringt Erdung auf die Insel. Er verlangt nichts von dir – keine Aufgaben, keine Geschenke, kein Interieur-Design. Er bietet dir lediglich einen Platz an der Bar und eine perfekte Tasse Kaffee. In einer Welt voller flippiger Bewohner ist er der ruhige Pol, der uns daran erinnert, dass die besten Dinge im Leben Zeit zum Ziehen brauchen.</p>
3	Reiner	Redd	Kunsthändler (Schwarzmarkt)	Fuchs	Männlich	18. Oktober	museum/Reiner.png	<p>Wenn ein düsteres, leicht heruntergekommenes Boot am geheimen Nordstrand deiner Insel anlegt, weißt du: Der Cousin ist da! Reiner, der fuchsige Kunsthändler, bringt Glanz, Gloria und eine ordentliche Portion Skepsis in dein Inselleben. Er ist der Mann für die besonderen Dinge – vorausgesetzt, man stört sich nicht an fehlenden Echtheitszertifikaten.</p>\r\n\r\n<h3>🦊 Das Geschäft mit der Ästhetik (und den Kopien)</h3>\r\n<p>Reiners Geschäftsmodell ist so simpel wie genial: Er verkauft weltberühmte Gemälde und Statuen direkt aus seinem „Schatzkutter“. Das Problem? Nicht alles, was dort im schummrigen Licht glänzt, ist auch ein Original.</p>\r\n<ul class="ac-list">\r\n    <li><strong>Das Auge des Kenners:</strong> Reiner ist ein Meister darin, Fälschungen unter das Volk zu bringen. Mal schaut eine Statue in die falsche Richtung, mal hat ein berühmtes Porträt plötzlich einen modischen Bart.</li>\r\n    <li><strong>Der Deal:</strong> Man hat genau einen Versuch pro Besuch. Einmal gekauft, gibt es kein Zurück. Eugen im Museum ist der unerbittliche Richter – er erkennt sofort, ob du ein Meisterwerk oder einen teuren Briefbeschwerer erworben hast.</li>\r\n    <li><strong>Wucherpreise?</strong> Reiner nennt es „Familienrabatt“. Er baut sofort eine kumpelhafte Nähe auf, indem er dich „Vetter“ oder „Cousine“ nennt, nur um dir dann ein Möbelstück zum dreifachen Ladenpreis anzudrehen.</li>\r\n</ul>\r\n\r\n<h3>🎭 Ein Fuchs im Schafspelz</h3>\r\n<p>Reiner basiert auf der japanischen Sagengestalt des <em>Kitsune</em> – ein Fuchsgeist, der für seine List und seine Verwandlungskünste bekannt ist. Das spiegelt sich in jedem Satz wider, den er sagt. Er ist wortgewandt, schmeichlerisch und schafft es, dass man sich selbst beim Kauf einer offensichtlichen Fälschung noch irgendwie „exklusiv“ fühlt.</p>\r\n\r\n<h3>🎆 Die bunten Seiten: Feuerwerk und Tombola</h3>\r\n<p>Doch Reiner hat auch eine weiche, feierliche Seite. Bei den sommerlichen Feuerwerksshows tauscht er seinen dunklen Kutter gegen einen bunten Stand auf dem Festplatz. Hier verkauft er Lose für seine Tombola. Ob Wunderkerzen, Seifenblasen oder bunte Ballons – in diesen Momenten zeigt er, dass er auch ein Herz für das einfache Vergnügen (und das Kleingeld der Bewohner) hat.</p>\r\n<div class="fun-fact-box"><strong>Pro-Tipp:</strong> Wenn du Reiners Boot betrittst, ist es immer ratsam, die Taschenlampe (oder den Screenshot-Modus) dabeizuhaben. Das schummrige Licht in seinem Laden ist kein Design-Element, sondern Taktik, um die kleinen Fehler in seinen „Meisterwerken“ zu kaschieren!</div>\r\n\r\n<h3>❤️ Warum wir ihn trotzdem anlegen lassen</h3>\r\n<p>Trotz seiner zwielichtigen Art ist Reiner unverzichtbar. Er ist der einzige Weg, die Kunstgalerie des Museums zu vervollständigen. Zudem bringt er eine Prise Nervenkitzel auf die sonst so friedliche Insel. Es ist ein ewiges Katz-und-Maus-Spiel (oder eher Eule-und-Fuchs-Spiel), bei dem man sich jedes Mal wie ein echter Kunstexperte fühlt, wenn man eine Fälschung entlarvt.</p>
\.


--
-- TOC entry 3915 (class 0 OID 24751)
-- Dependencies: 244
-- Data for Name: villagers; Type: TABLE DATA; Schema: public; Owner: n8n_user
--

COPY public.villagers (id, name_de, name_en, species, gender, personality, hobby, catchphrase, birthday, preferred_styles, image_path, house_image_path, description) FROM stdin;
1	Gunnar	Raymond	Katze	Männlich	Selbstgefällig	Natur	maunz	1. Oktober	Elegant, Cool	villagers/Gunnar.png	\N	Gunnar ist eine selbstgefällige Katze mit Heterochromie (verschiedenfarbige Augen) und einem Faible für schicke Bürokleidung. Er ist einer der beliebtesten Nachbarn im gesamten Spiel.
2	Berry	Stitches	Bär (Plüsch)	Männlich	Schlafmütze	Spielen	brummm	10. Februar	Bunt, Putzig	villagers/Berry.png	\N	Berry sieht aus wie ein bunter, zusammengenähter Teddybär. Als Schlafmütze liebt er Essen über alles und führt oft imaginäre Gespräche mit den Insekten in seinem Fußboden.
3	Mischka	Marshal	Hörnchen	Männlich	Selbstgefällig	Musik	husch	29. September	Elegant, Cool	villagers/Mischka.png	\N	Trotz seines stets leicht mürrischen Gesichtsausdrucks ist Mischka extrem charmant und selbstgefällig. Er liebt es, im Café zu sitzen und sich über die neuesten Modetrends auszutauschen.
\.


--
-- TOC entry 3983 (class 0 OID 0)
-- Dependencies: 239
-- Name: artworks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.artworks_id_seq', 1, false);


--
-- TOC entry 3984 (class 0 OID 0)
-- Dependencies: 229
-- Name: cooking_recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.cooking_recipes_id_seq', 141, true);


--
-- TOC entry 3985 (class 0 OID 0)
-- Dependencies: 215
-- Name: creatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.creatures_id_seq', 200, true);


--
-- TOC entry 3986 (class 0 OID 0)
-- Dependencies: 254
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 1, false);


--
-- TOC entry 3987 (class 0 OID 0)
-- Dependencies: 252
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 1, false);


--
-- TOC entry 3988 (class 0 OID 0)
-- Dependencies: 274
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- TOC entry 3989 (class 0 OID 0)
-- Dependencies: 258
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 1, false);


--
-- TOC entry 3990 (class 0 OID 0)
-- Dependencies: 260
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 1, false);


--
-- TOC entry 3991 (class 0 OID 0)
-- Dependencies: 262
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 1, false);


--
-- TOC entry 3992 (class 0 OID 0)
-- Dependencies: 264
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 1, false);


--
-- TOC entry 3993 (class 0 OID 0)
-- Dependencies: 267
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, false);


--
-- TOC entry 3994 (class 0 OID 0)
-- Dependencies: 269
-- Name: directus_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.directus_webhooks_id_seq', 1, false);


--
-- TOC entry 3995 (class 0 OID 0)
-- Dependencies: 227
-- Name: diy_recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.diy_recipes_id_seq', 776, true);


--
-- TOC entry 3996 (class 0 OID 0)
-- Dependencies: 223
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.events_id_seq', 83, true);


--
-- TOC entry 3997 (class 0 OID 0)
-- Dependencies: 219
-- Name: flower_combinations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.flower_combinations_id_seq', 49, true);


--
-- TOC entry 3998 (class 0 OID 0)
-- Dependencies: 221
-- Name: flower_seeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.flower_seeds_id_seq', 24, true);


--
-- TOC entry 3999 (class 0 OID 0)
-- Dependencies: 217
-- Name: flowers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.flowers_id_seq', 9, true);


--
-- TOC entry 4000 (class 0 OID 0)
-- Dependencies: 237
-- Name: fossils_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.fossils_id_seq', 1, false);


--
-- TOC entry 4001 (class 0 OID 0)
-- Dependencies: 231
-- Name: item_materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.item_materials_id_seq', 1723, true);


--
-- TOC entry 4002 (class 0 OID 0)
-- Dependencies: 247
-- Name: item_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.item_variants_id_seq', 1, false);


--
-- TOC entry 4003 (class 0 OID 0)
-- Dependencies: 245
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.items_id_seq', 1, false);


--
-- TOC entry 4004 (class 0 OID 0)
-- Dependencies: 225
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.materials_id_seq', 252, true);


--
-- TOC entry 4005 (class 0 OID 0)
-- Dependencies: 241
-- Name: special_npcs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.special_npcs_id_seq', 3, true);


--
-- TOC entry 4006 (class 0 OID 0)
-- Dependencies: 243
-- Name: villagers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: n8n_user
--

SELECT pg_catalog.setval('public.villagers_id_seq', 3, true);


--
-- TOC entry 3619 (class 2606 OID 17134)
-- Name: artworks artworks_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.artworks
    ADD CONSTRAINT artworks_pkey PRIMARY KEY (id);


--
-- TOC entry 3599 (class 2606 OID 16990)
-- Name: cooking_recipes cooking_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.cooking_recipes
    ADD CONSTRAINT cooking_recipes_pkey PRIMARY KEY (id);


--
-- TOC entry 3614 (class 2606 OID 17088)
-- Name: creature_locations creature_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_locations
    ADD CONSTRAINT creature_locations_pkey PRIMARY KEY (creature_id);


--
-- TOC entry 3608 (class 2606 OID 17058)
-- Name: creature_shadows creature_shadows_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_shadows
    ADD CONSTRAINT creature_shadows_pkey PRIMARY KEY (creature_id);


--
-- TOC entry 3610 (class 2606 OID 17068)
-- Name: creature_speeds creature_speeds_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_speeds
    ADD CONSTRAINT creature_speeds_pkey PRIMARY KEY (creature_id);


--
-- TOC entry 3612 (class 2606 OID 17078)
-- Name: creature_weathers creature_weathers_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_weathers
    ADD CONSTRAINT creature_weathers_pkey PRIMARY KEY (creature_id);


--
-- TOC entry 3574 (class 2606 OID 16615)
-- Name: creatures creatures_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creatures
    ADD CONSTRAINT creatures_pkey PRIMARY KEY (id);


--
-- TOC entry 3653 (class 2606 OID 33032)
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 3639 (class 2606 OID 32971)
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- TOC entry 3675 (class 2606 OID 33347)
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- TOC entry 3697 (class 2606 OID 33558)
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 3651 (class 2606 OID 33012)
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- TOC entry 3657 (class 2606 OID 33057)
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- TOC entry 3683 (class 2606 OID 33464)
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- TOC entry 3685 (class 2606 OID 33462)
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- TOC entry 3655 (class 2606 OID 33042)
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- TOC entry 3673 (class 2606 OID 33219)
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3679 (class 2606 OID 33407)
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3687 (class 2606 OID 33477)
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- TOC entry 3689 (class 2606 OID 33486)
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- TOC entry 3691 (class 2606 OID 33479)
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- TOC entry 3677 (class 2606 OID 33362)
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- TOC entry 3659 (class 2606 OID 33081)
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3661 (class 2606 OID 33101)
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- TOC entry 3663 (class 2606 OID 33125)
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- TOC entry 3665 (class 2606 OID 33144)
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- TOC entry 3641 (class 2606 OID 32982)
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3667 (class 2606 OID 33166)
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- TOC entry 3669 (class 2606 OID 33184)
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3681 (class 2606 OID 33427)
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- TOC entry 3693 (class 2606 OID 33510)
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- TOC entry 3643 (class 2606 OID 33389)
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- TOC entry 3645 (class 2606 OID 33387)
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- TOC entry 3647 (class 2606 OID 32992)
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- TOC entry 3649 (class 2606 OID 33397)
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- TOC entry 3695 (class 2606 OID 33519)
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- TOC entry 3671 (class 2606 OID 33211)
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- TOC entry 3595 (class 2606 OID 16973)
-- Name: diy_recipes diy_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.diy_recipes
    ADD CONSTRAINT diy_recipes_pkey PRIMARY KEY (id);


--
-- TOC entry 3587 (class 2606 OID 16792)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 3583 (class 2606 OID 16696)
-- Name: flower_combinations flower_combinations_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flower_combinations
    ADD CONSTRAINT flower_combinations_pkey PRIMARY KEY (id);


--
-- TOC entry 3585 (class 2606 OID 16708)
-- Name: flower_seeds flower_seeds_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flower_seeds
    ADD CONSTRAINT flower_seeds_pkey PRIMARY KEY (id);


--
-- TOC entry 3580 (class 2606 OID 16672)
-- Name: flowers flowers_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.flowers
    ADD CONSTRAINT flowers_pkey PRIMARY KEY (id);


--
-- TOC entry 3616 (class 2606 OID 17123)
-- Name: fossils fossils_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.fossils
    ADD CONSTRAINT fossils_pkey PRIMARY KEY (id);


--
-- TOC entry 3606 (class 2606 OID 17003)
-- Name: item_materials item_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_materials
    ADD CONSTRAINT item_materials_pkey PRIMARY KEY (id);


--
-- TOC entry 3635 (class 2606 OID 32955)
-- Name: item_variants item_variants_item_id_variant_name_de_pattern_name_de_key; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_item_id_variant_name_de_pattern_name_de_key UNIQUE (item_id, variant_name_de, pattern_name_de);


--
-- TOC entry 3637 (class 2606 OID 32953)
-- Name: item_variants item_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_pkey PRIMARY KEY (id);


--
-- TOC entry 3632 (class 2606 OID 32942)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- TOC entry 3593 (class 2606 OID 16823)
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- TOC entry 3623 (class 2606 OID 24748)
-- Name: special_npcs special_npcs_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.special_npcs
    ADD CONSTRAINT special_npcs_pkey PRIMARY KEY (id);


--
-- TOC entry 3628 (class 2606 OID 24764)
-- Name: villagers villagers_pkey; Type: CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.villagers
    ADD CONSTRAINT villagers_pkey PRIMARY KEY (id);


--
-- TOC entry 3620 (class 1259 OID 17135)
-- Name: idx_artworks_type; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_artworks_type ON public.artworks USING btree (type);


--
-- TOC entry 3600 (class 1259 OID 17105)
-- Name: idx_cooking_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_cooking_name ON public.cooking_recipes USING btree (name);


--
-- TOC entry 3601 (class 1259 OID 17110)
-- Name: idx_cooking_recipes_event_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_cooking_recipes_event_id ON public.cooking_recipes USING btree (event_id);


--
-- TOC entry 3575 (class 1259 OID 16616)
-- Name: idx_creatures_category; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_creatures_category ON public.creatures USING btree (category);


--
-- TOC entry 3576 (class 1259 OID 17111)
-- Name: idx_creatures_months_northern; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_creatures_months_northern ON public.creatures USING gin (months_northern);


--
-- TOC entry 3577 (class 1259 OID 16617)
-- Name: idx_creatures_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_creatures_name ON public.creatures USING btree (name);


--
-- TOC entry 3578 (class 1259 OID 17112)
-- Name: idx_creatures_price; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_creatures_price ON public.creatures USING btree (price DESC);


--
-- TOC entry 3596 (class 1259 OID 17104)
-- Name: idx_diy_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_diy_name ON public.diy_recipes USING btree (name);


--
-- TOC entry 3597 (class 1259 OID 17109)
-- Name: idx_diy_recipes_event_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_diy_recipes_event_id ON public.diy_recipes USING btree (event_id);


--
-- TOC entry 3588 (class 1259 OID 16793)
-- Name: idx_events_month; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_events_month ON public.events USING btree (month);


--
-- TOC entry 3589 (class 1259 OID 16794)
-- Name: idx_events_type; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_events_type ON public.events USING btree (event_type);


--
-- TOC entry 3581 (class 1259 OID 16673)
-- Name: idx_flowers_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_flowers_name ON public.flowers USING btree (name);


--
-- TOC entry 3617 (class 1259 OID 17124)
-- Name: idx_fossils_group; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_fossils_group ON public.fossils USING btree (dinosaur_group);


--
-- TOC entry 3602 (class 1259 OID 17108)
-- Name: idx_item_materials_cooking_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_item_materials_cooking_id ON public.item_materials USING btree (cooking_recipe_id);


--
-- TOC entry 3603 (class 1259 OID 17107)
-- Name: idx_item_materials_diy_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_item_materials_diy_id ON public.item_materials USING btree (diy_recipe_id);


--
-- TOC entry 3604 (class 1259 OID 17106)
-- Name: idx_item_materials_material_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_item_materials_material_id ON public.item_materials USING btree (material_id);


--
-- TOC entry 3633 (class 1259 OID 32961)
-- Name: idx_item_variants_item_id; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_item_variants_item_id ON public.item_variants USING btree (item_id);


--
-- TOC entry 3629 (class 1259 OID 32944)
-- Name: idx_items_category; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_items_category ON public.items USING btree (category);


--
-- TOC entry 3630 (class 1259 OID 32943)
-- Name: idx_items_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_items_name ON public.items USING btree (name_de);


--
-- TOC entry 3590 (class 1259 OID 16824)
-- Name: idx_materials_category; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_materials_category ON public.materials USING btree (category);


--
-- TOC entry 3591 (class 1259 OID 17103)
-- Name: idx_materials_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_materials_name ON public.materials USING btree (name);


--
-- TOC entry 3621 (class 1259 OID 24749)
-- Name: idx_special_npcs_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_special_npcs_name ON public.special_npcs USING btree (name_de);


--
-- TOC entry 3624 (class 1259 OID 24765)
-- Name: idx_villagers_name; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_villagers_name ON public.villagers USING btree (name_de);


--
-- TOC entry 3625 (class 1259 OID 24767)
-- Name: idx_villagers_personality; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_villagers_personality ON public.villagers USING btree (personality);


--
-- TOC entry 3626 (class 1259 OID 24766)
-- Name: idx_villagers_species; Type: INDEX; Schema: public; Owner: n8n_user
--

CREATE INDEX idx_villagers_species ON public.villagers USING btree (species);


--
-- TOC entry 3699 (class 2606 OID 16991)
-- Name: cooking_recipes cooking_recipes_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.cooking_recipes
    ADD CONSTRAINT cooking_recipes_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- TOC entry 3706 (class 2606 OID 17089)
-- Name: creature_locations creature_locations_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_locations
    ADD CONSTRAINT creature_locations_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id) ON DELETE CASCADE;


--
-- TOC entry 3703 (class 2606 OID 17059)
-- Name: creature_shadows creature_shadows_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_shadows
    ADD CONSTRAINT creature_shadows_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id) ON DELETE CASCADE;


--
-- TOC entry 3704 (class 2606 OID 17069)
-- Name: creature_speeds creature_speeds_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_speeds
    ADD CONSTRAINT creature_speeds_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id) ON DELETE CASCADE;


--
-- TOC entry 3705 (class 2606 OID 17079)
-- Name: creature_weathers creature_weathers_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.creature_weathers
    ADD CONSTRAINT creature_weathers_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id) ON DELETE CASCADE;


--
-- TOC entry 3708 (class 2606 OID 33391)
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- TOC entry 3727 (class 2606 OID 33348)
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3711 (class 2606 OID 33304)
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- TOC entry 3712 (class 2606 OID 33235)
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- TOC entry 3713 (class 2606 OID 33230)
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- TOC entry 3735 (class 2606 OID 33465)
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3710 (class 2606 OID 33240)
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- TOC entry 3730 (class 2606 OID 33408)
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3731 (class 2606 OID 33413)
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- TOC entry 3736 (class 2606 OID 33492)
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- TOC entry 3737 (class 2606 OID 33487)
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- TOC entry 3738 (class 2606 OID 33480)
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- TOC entry 3739 (class 2606 OID 33497)
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3728 (class 2606 OID 33363)
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- TOC entry 3729 (class 2606 OID 33368)
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3714 (class 2606 OID 33309)
-- Name: directus_permissions directus_permissions_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3715 (class 2606 OID 33319)
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3716 (class 2606 OID 33314)
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3717 (class 2606 OID 33324)
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- TOC entry 3718 (class 2606 OID 33265)
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- TOC entry 3719 (class 2606 OID 33536)
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- TOC entry 3720 (class 2606 OID 33443)
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- TOC entry 3721 (class 2606 OID 33329)
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3722 (class 2606 OID 33275)
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- TOC entry 3723 (class 2606 OID 33285)
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- TOC entry 3724 (class 2606 OID 33543)
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- TOC entry 3725 (class 2606 OID 33280)
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- TOC entry 3726 (class 2606 OID 33379)
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- TOC entry 3732 (class 2606 OID 33428)
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- TOC entry 3733 (class 2606 OID 33433)
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3734 (class 2606 OID 33438)
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3709 (class 2606 OID 33334)
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- TOC entry 3740 (class 2606 OID 33520)
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- TOC entry 3741 (class 2606 OID 33525)
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3742 (class 2606 OID 33530)
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3698 (class 2606 OID 16974)
-- Name: diy_recipes diy_recipes_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.diy_recipes
    ADD CONSTRAINT diy_recipes_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- TOC entry 3700 (class 2606 OID 17009)
-- Name: item_materials item_materials_cooking_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_materials
    ADD CONSTRAINT item_materials_cooking_recipe_id_fkey FOREIGN KEY (cooking_recipe_id) REFERENCES public.cooking_recipes(id) ON DELETE CASCADE;


--
-- TOC entry 3701 (class 2606 OID 17004)
-- Name: item_materials item_materials_diy_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_materials
    ADD CONSTRAINT item_materials_diy_recipe_id_fkey FOREIGN KEY (diy_recipe_id) REFERENCES public.diy_recipes(id) ON DELETE CASCADE;


--
-- TOC entry 3702 (class 2606 OID 17014)
-- Name: item_materials item_materials_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_materials
    ADD CONSTRAINT item_materials_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE CASCADE;


--
-- TOC entry 3707 (class 2606 OID 32956)
-- Name: item_variants item_variants_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: n8n_user
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


-- Completed on 2026-05-25 20:07:36

--
-- PostgreSQL database dump complete
--

-- Completed on 2026-05-25 20:07:36

--
-- PostgreSQL database cluster dump complete
--

