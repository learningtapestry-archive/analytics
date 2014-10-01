--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actions; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE actions (
    id integer NOT NULL,
    subject character varying(255),
    verb character varying(255),
    object character varying(255),
    object_detail character varying(255),
    result json,
    occurred_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.actions OWNER TO lt_dbo;

--
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actions_id_seq OWNER TO lt_dbo;

--
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE actions_id_seq OWNED BY actions.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE api_keys (
    id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.api_keys OWNER TO lt_dbo;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO lt_dbo;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE api_keys_id_seq OWNED BY api_keys.id;


--
-- Name: approved_site_actions; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE approved_site_actions (
    id integer NOT NULL,
    approved_site_id integer NOT NULL,
    action_type character varying(255) NOT NULL,
    url_pattern character varying(4096) NOT NULL,
    css_selector character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.approved_site_actions OWNER TO lt_dbo;

--
-- Name: approved_site_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE approved_site_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approved_site_actions_id_seq OWNER TO lt_dbo;

--
-- Name: approved_site_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE approved_site_actions_id_seq OWNED BY approved_site_actions.id;


--
-- Name: approved_sites; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE approved_sites (
    id integer NOT NULL,
    site_name character varying(255) NOT NULL,
    site_uuid uuid NOT NULL,
    url character varying(4096) NOT NULL,
    logo_url_small character varying(4096),
    logo_url_large character varying(4096),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.approved_sites OWNER TO lt_dbo;

--
-- Name: approved_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE approved_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approved_sites_id_seq OWNER TO lt_dbo;

--
-- Name: approved_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE approved_sites_id_seq OWNED BY approved_sites.id;


--
-- Name: course_offerings; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE course_offerings (
    id integer NOT NULL,
    course_id integer NOT NULL,
    sis_id character varying(255),
    other_id character varying(255),
    date_start date,
    date_end date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.course_offerings OWNER TO lt_dbo;

--
-- Name: course_offerings_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE course_offerings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_offerings_id_seq OWNER TO lt_dbo;

--
-- Name: course_offerings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE course_offerings_id_seq OWNED BY course_offerings.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    course_code character varying(255),
    sis_id character varying(255),
    other_id character varying(255),
    name character varying(255) NOT NULL,
    description character varying(255),
    subject_area character varying(255),
    high_school_requirement boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.courses OWNER TO lt_dbo;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO lt_dbo;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE districts (
    id integer NOT NULL,
    state_id character varying(255),
    nces_id character varying(255),
    sis_id character varying(255),
    other_id character varying(255),
    name character varying(255) NOT NULL,
    address character varying(255),
    city character varying(255),
    state character varying(255),
    phone character varying(255),
    grade_low character varying(255),
    grade_high character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.districts OWNER TO lt_dbo;

--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.districts_id_seq OWNER TO lt_dbo;

--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE districts_id_seq OWNED BY districts.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE emails (
    id integer NOT NULL,
    email character varying(255),
    "primary" boolean,
    user_id integer
);


ALTER TABLE public.emails OWNER TO lt_dbo;

--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emails_id_seq OWNER TO lt_dbo;

--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE emails_id_seq OWNED BY emails.id;


--
-- Name: janitor_jobs; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE janitor_jobs (
    id integer NOT NULL,
    job_status character varying(255),
    janitor_type character varying(255),
    job_id character varying(255),
    table_name character varying(255),
    table_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.janitor_jobs OWNER TO lt_dbo;

--
-- Name: janitor_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE janitor_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.janitor_jobs_id_seq OWNER TO lt_dbo;

--
-- Name: janitor_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE janitor_jobs_id_seq OWNED BY janitor_jobs.id;


--
-- Name: page_clicks; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE page_clicks (
    id integer NOT NULL,
    date_visited timestamp without time zone,
    url_visited character varying(4096),
    user_id integer,
    page_id integer
);


ALTER TABLE public.page_clicks OWNER TO lt_dbo;

--
-- Name: page_clicks_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE page_clicks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_clicks_id_seq OWNER TO lt_dbo;

--
-- Name: page_clicks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE page_clicks_id_seq OWNED BY page_clicks.id;


--
-- Name: page_visits; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE page_visits (
    id integer NOT NULL,
    date_visited timestamp without time zone,
    time_active interval,
    user_id integer,
    page_id integer
);


ALTER TABLE public.page_visits OWNER TO lt_dbo;

--
-- Name: page_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE page_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_visits_id_seq OWNER TO lt_dbo;

--
-- Name: page_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE page_visits_id_seq OWNED BY page_visits.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    url character varying(4096) NOT NULL,
    display_name character varying(255),
    site_id integer
);


ALTER TABLE public.pages OWNER TO lt_dbo;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO lt_dbo;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: raw_messages; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE raw_messages (
    id integer NOT NULL,
    api_key character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    site_uuid uuid,
    verb character varying(255),
    action json,
    url character varying(4096),
    captured_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.raw_messages OWNER TO lt_dbo;

--
-- Name: raw_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE raw_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raw_messages_id_seq OWNER TO lt_dbo;

--
-- Name: raw_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE raw_messages_id_seq OWNED BY raw_messages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO lt_dbo;

--
-- Name: schools; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE schools (
    id integer NOT NULL,
    state_id character varying(255),
    nces_id character varying(255),
    sis_id character varying(255),
    other_id character varying(255),
    name character varying(255) NOT NULL,
    address character varying(255),
    city character varying(255),
    state character varying(255),
    phone character varying(255),
    grade_low character varying(255),
    grade_high character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.schools OWNER TO lt_dbo;

--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.schools_id_seq OWNER TO lt_dbo;

--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE schools_id_seq OWNED BY schools.id;


--
-- Name: section_users; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE section_users (
    id integer NOT NULL,
    user_type character varying(255),
    section_id integer,
    user_id integer
);


ALTER TABLE public.section_users OWNER TO lt_dbo;

--
-- Name: section_users_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE section_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.section_users_id_seq OWNER TO lt_dbo;

--
-- Name: section_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE section_users_id_seq OWNED BY section_users.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    section_code character varying(255),
    course_offering_id integer,
    sis_id character varying(255),
    other_id character varying(255),
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.sections OWNER TO lt_dbo;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO lt_dbo;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: site_visits; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE site_visits (
    id integer NOT NULL,
    date_visited timestamp without time zone,
    time_active interval,
    user_id integer,
    site_id integer
);


ALTER TABLE public.site_visits OWNER TO lt_dbo;

--
-- Name: site_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE site_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_visits_id_seq OWNER TO lt_dbo;

--
-- Name: site_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE site_visits_id_seq OWNED BY site_visits.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    url character varying(4096) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.sites OWNER TO lt_dbo;

--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sites_id_seq OWNER TO lt_dbo;

--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: staff_members; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE staff_members (
    id integer NOT NULL,
    state_id character varying(255),
    sis_id character varying(255),
    other_id character varying(255),
    staff_member_type character varying(255) NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.staff_members OWNER TO lt_dbo;

--
-- Name: staff_members_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE staff_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_members_id_seq OWNER TO lt_dbo;

--
-- Name: staff_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE staff_members_id_seq OWNED BY staff_members.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE students (
    id integer NOT NULL,
    state_id character varying(255),
    sis_id character varying(255),
    other_id character varying(255),
    grade_level character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.students OWNER TO lt_dbo;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_id_seq OWNER TO lt_dbo;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE students_id_seq OWNED BY students.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    middle_name character varying(255),
    last_name character varying(255) NOT NULL,
    gender character varying(255),
    username character varying(255) NOT NULL,
    password_digest character varying(255),
    date_of_birth date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO lt_dbo;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: lt_dbo
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO lt_dbo;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lt_dbo
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY actions ALTER COLUMN id SET DEFAULT nextval('actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY api_keys ALTER COLUMN id SET DEFAULT nextval('api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY approved_site_actions ALTER COLUMN id SET DEFAULT nextval('approved_site_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY approved_sites ALTER COLUMN id SET DEFAULT nextval('approved_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY course_offerings ALTER COLUMN id SET DEFAULT nextval('course_offerings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY districts ALTER COLUMN id SET DEFAULT nextval('districts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY emails ALTER COLUMN id SET DEFAULT nextval('emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY janitor_jobs ALTER COLUMN id SET DEFAULT nextval('janitor_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY page_clicks ALTER COLUMN id SET DEFAULT nextval('page_clicks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY page_visits ALTER COLUMN id SET DEFAULT nextval('page_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY raw_messages ALTER COLUMN id SET DEFAULT nextval('raw_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY schools ALTER COLUMN id SET DEFAULT nextval('schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY section_users ALTER COLUMN id SET DEFAULT nextval('section_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY site_visits ALTER COLUMN id SET DEFAULT nextval('site_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY staff_members ALTER COLUMN id SET DEFAULT nextval('staff_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY students ALTER COLUMN id SET DEFAULT nextval('students_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lt_dbo
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: actions; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY actions (id, subject, verb, object, object_detail, result, occurred_at, created_at, updated_at) FROM stdin;
\.


--
-- Name: actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('actions_id_seq', 1, false);


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY api_keys (id, user_id, key, created_at, updated_at) FROM stdin;
1	1	e7c24dcf-483e-4b9c-b174-e02afe0f913d	2014-09-30 01:09:36.878994	2014-09-30 01:09:36.878994
2	1	be86a4ff-be73-42fc-a35d-0d94f31a64f6	2014-09-30 02:10:23.000775	2014-09-30 02:10:23.000775
3	1	8cce3eab-6805-4505-b91d-0085b4087e47	2014-09-30 03:03:03.809787	2014-09-30 03:03:03.809787
4	1	2ca231c0-de11-46f4-ae01-9d1b2381994a	2014-09-30 03:06:15.602492	2014-09-30 03:06:15.602492
5	1	5f27d6dc-ef14-4517-82b2-8ab65f3df93e	2014-09-30 03:10:33.530386	2014-09-30 03:10:33.530386
6	2	12e08e9d-3639-4911-9a12-b3a7df41f0e5	2014-09-30 16:59:27.485819	2014-09-30 16:59:27.485819
7	1	a20781fc-6e2b-4826-bdc1-2f439e347044	2014-10-01 17:14:02.568488	2014-10-01 17:14:02.568488
\.


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('api_keys_id_seq', 7, true);


--
-- Data for Name: approved_site_actions; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY approved_site_actions (id, approved_site_id, action_type, url_pattern, css_selector, created_at, updated_at) FROM stdin;
1	1	CLICK	http(s)?://(.*\\.)?slashdot\\.(com|org)(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
2	1	PAGEVIEW	http(s)?://(.*\\.)?slashdot\\.(com|org)(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
3	2	CLICK	http(s)?://(.*\\.)?techcrunch\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
4	2	PAGEVIEW	http(s)?://(.*\\.)?techcrunch\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
5	3	CLICK	http(s)?://(.*\\.)?gizmodo\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
6	3	PAGEVIEW	http(s)?://(.*\\.)?gizmodo\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
7	4	CLICK	http(s)?://(.*\\.)?npr\\.org(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
8	4	PAGEVIEW	http(s)?://(.*\\.)?npr\\.org(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
9	5	CLICK	http(s)?://(.*\\.)?nytimes\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
10	5	PAGEVIEW	http(s)?://(.*\\.)?nytimes\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
11	6	CLICK	http(s)?://(.*\\.)?arstechnica\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
12	6	PAGEVIEW	http(s)?://(.*\\.)?arstechnica\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
13	7	CLICK	http(s)?://(.*\\.)?theverge\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
14	7	PAGEVIEW	http(s)?://(.*\\.)?theverge\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
15	8	CLICK	http(s)?://(.*\\.)?gigaom\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
16	8	PAGEVIEW	http(s)?://(.*\\.)?gigaom\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
17	9	CLICK	http(s)?://(.*\\.)?boingboing\\.net(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
18	9	PAGEVIEW	http(s)?://(.*\\.)?boingboing\\.net(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
19	10	CLICK	http(s)?://(.*\\.)?washingtonpost\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
20	10	PAGEVIEW	http(s)?://(.*\\.)?washingtonpost\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
21	11	CLICK	http(s)?://(.*\\.)?stackoverflow\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
22	11	PAGEVIEW	http(s)?://(.*\\.)?stackoverflow\\.com(/\\S*)?	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
\.


--
-- Name: approved_site_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('approved_site_actions_id_seq', 1, false);


--
-- Data for Name: approved_sites; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY approved_sites (id, site_name, site_uuid, url, logo_url_small, logo_url_large, created_at, updated_at) FROM stdin;
1	Slashdot	27c74d4d-a078-9bd3-557b-0a82aea8c759	http://slashdot.org	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
2	TechCrunch	8c63e4e9-beb9-0b0a-9ca9-2e896be646da	http://techcrunch.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
3	Gizmodo	42e735bb-fcc0-0757-ceb0-3b632000a02a	http://gizmodo.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
4	NPR	9688ad74-6cea-4c43-7212-d0ac2754e787	http://npr.org	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
5	New York Times	4fe2a48a-3c9c-ca2f-7aac-bc429d084754	http://nytimes.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
6	Ars Technica	52a7dafb-049f-85c0-4789-2807e1f51a1a	http://arstechnica.com/	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
7	The Verge	b49cf44e-0129-3649-82a8-e98a54067539	http://theverge.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
8	Gigaom	6656dd67-a96a-23bd-7e2e-508e30e9705b	http://gigaom.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
9	Boing Boing	2c314552-cef2-88e2-1cbd-3f1490016b62	http://boingboing.net	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
10	Washington Post	2c9f88c0-4887-0e83-7bc3-ec1e5090419d	http://washingtonpost.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
11	Stack Overflow	4f5978b7-2bf7-f778-6298-86a575375ba6	http://stackoverflow.com	\N	\N	0014-09-17 20:47:00	0014-09-17 20:47:00
\.


--
-- Name: approved_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('approved_sites_id_seq', 1, false);


--
-- Data for Name: course_offerings; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY course_offerings (id, course_id, sis_id, other_id, date_start, date_end, created_at, updated_at) FROM stdin;
\.


--
-- Name: course_offerings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('course_offerings_id_seq', 1, false);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY courses (id, course_code, sis_id, other_id, name, description, subject_area, high_school_requirement, created_at, updated_at) FROM stdin;
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('courses_id_seq', 1, false);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY districts (id, state_id, nces_id, sis_id, other_id, name, address, city, state, phone, grade_low, grade_high, created_at, updated_at) FROM stdin;
\.


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('districts_id_seq', 1, false);


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY emails (id, email, "primary", user_id) FROM stdin;
\.


--
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('emails_id_seq', 1, false);


--
-- Data for Name: janitor_jobs; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY janitor_jobs (id, job_status, janitor_type, job_id, table_name, table_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: janitor_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('janitor_jobs_id_seq', 1, false);


--
-- Data for Name: page_clicks; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY page_clicks (id, date_visited, url_visited, user_id, page_id) FROM stdin;
\.


--
-- Name: page_clicks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('page_clicks_id_seq', 1, false);


--
-- Data for Name: page_visits; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY page_visits (id, date_visited, time_active, user_id, page_id) FROM stdin;
\.


--
-- Name: page_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('page_visits_id_seq', 1, false);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY pages (id, url, display_name, site_id) FROM stdin;
\.


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('pages_id_seq', 1, false);


--
-- Data for Name: raw_messages; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY raw_messages (id, api_key, username, site_uuid, verb, action, url, captured_at, created_at, updated_at) FROM stdin;
\.


--
-- Name: raw_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('raw_messages_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY schema_migrations (version) FROM stdin;
20140902210605
\.


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY schools (id, state_id, nces_id, sis_id, other_id, name, address, city, state, phone, grade_low, grade_high, created_at, updated_at) FROM stdin;
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('schools_id_seq', 1, false);


--
-- Data for Name: section_users; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY section_users (id, user_type, section_id, user_id) FROM stdin;
\.


--
-- Name: section_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('section_users_id_seq', 1, false);


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY sections (id, section_code, course_offering_id, sis_id, other_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('sections_id_seq', 1, false);


--
-- Data for Name: site_visits; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY site_visits (id, date_visited, time_active, user_id, site_id) FROM stdin;
\.


--
-- Name: site_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('site_visits_id_seq', 1, false);


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY sites (id, url, display_name) FROM stdin;
\.


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('sites_id_seq', 1, false);


--
-- Data for Name: staff_members; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY staff_members (id, state_id, sis_id, other_id, staff_member_type, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: staff_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('staff_members_id_seq', 1, false);


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY students (id, state_id, sis_id, other_id, grade_level, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('students_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY users (id, first_name, middle_name, last_name, gender, username, password_digest, date_of_birth, created_at, updated_at) FROM stdin;
1	Jason	\N	Hoekstra	\N	jason	$2a$10$IeZaG5lQ56q2IqTdcmba0.vny910JK8EXTexoJKM4nQO50s3KqJu2	\N	\N	\N
2	Steve	\N	Midgley	\N	stevemidgley	$2a$10$bEGzXak92.vMA0en7.Lq8eC4FfhDuO/K8XTaw2kvan.H0NslpWdUu	\N	\N	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('users_id_seq', 1, false);


--
-- Name: actions_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: approved_site_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY approved_site_actions
    ADD CONSTRAINT approved_site_actions_pkey PRIMARY KEY (id);


--
-- Name: approved_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY approved_sites
    ADD CONSTRAINT approved_sites_pkey PRIMARY KEY (id);


--
-- Name: course_offerings_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY course_offerings
    ADD CONSTRAINT course_offerings_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: districts_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: emails_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: janitor_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY janitor_jobs
    ADD CONSTRAINT janitor_jobs_pkey PRIMARY KEY (id);


--
-- Name: page_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY page_clicks
    ADD CONSTRAINT page_clicks_pkey PRIMARY KEY (id);


--
-- Name: page_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY page_visits
    ADD CONSTRAINT page_visits_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: raw_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY raw_messages
    ADD CONSTRAINT raw_messages_pkey PRIMARY KEY (id);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: section_users_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY section_users
    ADD CONSTRAINT section_users_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: site_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY site_visits
    ADD CONSTRAINT site_visits_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: staff_members_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY staff_members
    ADD CONSTRAINT staff_members_pkey PRIMARY KEY (id);


--
-- Name: students_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: lt_dbo; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_pages_on_url; Type: INDEX; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE UNIQUE INDEX index_pages_on_url ON pages USING btree (url);


--
-- Name: index_sites_on_url; Type: INDEX; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE UNIQUE INDEX index_sites_on_url ON sites USING btree (url);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: lt_dbo; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

