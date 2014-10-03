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
    url_pattern character varying(255) NOT NULL,
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
    site_hash character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    logo_url_small character varying(255),
    logo_url_large character varying(255),
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
    url_visited character varying(255),
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
    url character varying(255) NOT NULL,
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
    status_id integer,
    api_key character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    action character varying(255),
    event character varying(255),
    result character varying(255),
    url character varying(255),
    html text,
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
    url character varying(255) NOT NULL,
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
1	1	2866b962-a7be-44f8-9a0c-66502fba7d31	\N	\N
2	1	64a59863-bcc3-496e-bd2c-d67f0632afb1	\N	\N
3	2	b6562b8c-3272-4bad-b3fe-9765db4e7496	\N	\N
4	1	8858e2ea-9a9d-491c-acfb-29bc608c075c	2014-09-23 00:18:31.364196	2014-09-23 00:18:31.364196
5	1	bddead89-699d-46d3-9ec3-f07edc5b2e3b	2014-09-23 00:39:48.693908	2014-09-23 00:39:48.693908
6	1	b480992e-86a8-4aed-97d5-47e92f71fec3	2014-09-23 00:49:22.760039	2014-09-23 00:49:22.760039
7	2	83f58615-ddf0-41de-982d-2d3cfc9fdd89	2014-09-23 05:48:28.453239	2014-09-23 05:48:28.453239
8	1	d03e1ad6-2635-43c4-ae1b-3dd3a928912c	2014-09-26 13:01:14.241756	2014-09-26 13:01:14.241756
9	2	b9e02666-bc66-4bef-a5ec-213a628711cf	2014-09-29 03:12:58.814275	2014-09-29 03:12:58.814275
10	1	a2bbc99f-4b9d-466b-95d0-fc70c4298c39	2014-09-29 21:07:58.775169	2014-09-29 21:07:58.775169
11	1	e0240761-c6db-406a-8bf6-879f8114118e	2014-09-29 21:35:10.013312	2014-09-29 21:35:10.013312
12	1	609156a3-27cb-4157-816a-7da1cd9ccc03	2014-09-29 21:43:50.057903	2014-09-29 21:43:50.057903
\.


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('api_keys_id_seq', 12, true);


--
-- Data for Name: approved_site_actions; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY approved_site_actions (id, approved_site_id, action_type, url_pattern, css_selector, created_at, updated_at) FROM stdin;
1	1	CLICK	http(s)?://(.*\\.)?slashdot\\.(com|org)(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
2	1	PAGEVIEW	http(s)?://(.*\\.)?slashdot\\.(com|org)(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
3	2	CLICK	http(s)?://(.*\\.)?techcrunch\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
4	2	PAGEVIEW	http(s)?://(.*\\.)?techcrunch\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
5	3	CLICK	http(s)?://(.*\\.)?gizmodo\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
6	3	PAGEVIEW	http(s)?://(.*\\.)?gizmodo\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
7	4	CLICK	http(s)?://(.*\\.)?npr\\.org(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
8	4	PAGEVIEW	http(s)?://(.*\\.)?npr\\.org(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
9	5	CLICK	http(s)?://(.*\\.)?nytimes\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
10	5	PAGEVIEW	http(s)?://(.*\\.)?nytimes\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
11	6	CLICK	http(s)?://(.*\\.)?arstechnica\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
12	6	PAGEVIEW	http(s)?://(.*\\.)?arstechnica\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
13	7	CLICK	http(s)?://(.*\\.)?theverge\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
14	7	PAGEVIEW	http(s)?://(.*\\.)?theverge\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
15	8	CLICK	http(s)?://(.*\\.)?gigaom\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
16	8	PAGEVIEW	http(s)?://(.*\\.)?gigaom\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
17	9	CLICK	http(s)?://(.*\\.)?boingboing\\.net(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
18	9	PAGEVIEW	http(s)?://(.*\\.)?boingboing\\.net(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
19	10	CLICK	http(s)?://(.*\\.)?washingtonpost\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
20	10	PAGEVIEW	http(s)?://(.*\\.)?washingtonpost\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
21	11	CLICK	http(s)?://(.*\\.)?stackoverflow\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
22	11	PAGEVIEW	http(s)?://(.*\\.)?stackoverflow\\.com(/\\S*)?		2014-09-17 20:47:46	2014-09-17 20:47:46
\.


--
-- Name: approved_site_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('approved_site_actions_id_seq', 1, false);


--
-- Data for Name: approved_sites; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY approved_sites (id, site_name, site_hash, url, logo_url_small, logo_url_large, created_at, updated_at) FROM stdin;
1	Slashdot	27c74d4da0789bd3557b0a82aea8c759	http://slashdot.org			2014-09-17 20:47:46	2014-09-17 20:47:46
2	TechCrunch	8c63e4e9beb90b0a9ca92e896be646da	http://techcrunch.com			2014-09-17 20:47:46	2014-09-17 20:47:46
3	Gizmodo	42e735bbfcc00757ceb03b632000a02a	http://gizmodo.com			2014-09-17 20:47:46	2014-09-17 20:47:46
4	NPR	9688ad746cea4c437212d0ac2754e787	http://npr.org			2014-09-17 20:47:46	2014-09-17 20:47:46
5	New York Times	4fe2a48a3c9cca2f7aacbc429d084754	http://nytimes.com			2014-09-17 20:47:46	2014-09-17 20:47:46
6	Ars Technica	52a7dafb049f85c047892807e1f51a1a	http://arstechnica.com/			2014-09-17 20:47:46	2014-09-17 20:47:46
7	The Verge	b49cf44e0129364982a8e98a54067539	http://theverge.com			2014-09-17 20:47:46	2014-09-17 20:47:46
8	Gigaom	6656dd67a96a23bd7e2e508e30e9705b	http://gigaom.com			2014-09-17 20:47:46	2014-09-17 20:47:46
9	Boing Boing	2c314552cef288e21cbd3f1490016b62	http://boingboing.net			2014-09-17 20:47:46	2014-09-17 20:47:46
10	Washington Post	2c9f88c048870e837bc3ec1e5090419d	http://washingtonpost.com			2014-09-17 20:47:46	2014-09-17 20:47:46
11	Stack Overflow	4f5978b72bf7f778629886a575375ba6	http://stackoverflow.com			2014-09-17 20:47:46	2014-09-17 20:47:46
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
1	2014-09-18 01:27:44	http://blog.stackoverflow.com/2014/09/introducing-runnable-javascript-css-and-html-code-snippets/?cb=1	1	1
2	2014-09-18 01:27:48	http://blog.stackoverflow.com/2014/07/please-welcome-jmac-community-manager-of-the-rising-sun/	1	2
3	2014-09-18 01:28:07	http://stackoverflow.com/?tab=featured	1	5
4	2014-09-18 01:28:44	http://stackoverflow.com/questions/tagged/ruby+performance?sort=frequent&pageSize=50	1	7
5	2014-09-18 01:29:17	http://stackoverflow.com/questions/2529852/why-do-people-say-that-ruby-is-slow	1	8
6	2014-09-18 01:29:55	http://benchmarksgame.alioth.debian.org/u32/benchmark.php?test=all&lang=yarv&lang2=php	1	9
7	2014-09-18 01:31:14	http://stackoverflow.com/questions/2529852/why-do-people-say-that-ruby-is-slow	1	7
8	2014-09-18 01:32:15	http://www.joelonsoftware.com/items/2006/09/12.html	1	9
9	2014-09-18 15:21:23	http://www.nytimes.com/2014/09/18/world/europe/scotland-independence-referendum.html	1	11
10	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
11	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
12	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
13	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
14	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
15	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
16	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
17	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
18	2014-09-18 15:22:33	http://www.nytimes.com/pages/technology/index.html	1	12
19	2014-09-18 15:23:05	http://dealbook.nytimes.com/2014/09/18/identity-security-firm-ping-raises-35-million-from-k-k-r-and-others/?ref=technology	1	13
20	2014-09-18 15:23:25	http://bits.blogs.nytimes.com/2014/09/17/amazon-refreshes-its-kindle-line/?ref=technology	1	13
21	2014-09-18 15:24:12	http://www.nytimes.com/2014/09/17/technology/terrance-paul-developer-of-teaching-software-dies-at-67.html?ref=technology	1	13
22	2014-09-19 01:00:51	http://arstechnica.com/tech-policy/2014/09/giant-mq-4c-triton-surveillance-drone-flies-across-the-united-states/	2	24
23	2014-09-19 01:01:00	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/	2	24
24	2014-09-19 01:01:03	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/?comments=1&unread=1	2	25
25	2014-09-19 01:06:39	http://arstechnica.com/tech-policy/2014/09/giant-mq-4c-triton-surveillance-drone-flies-across-the-united-states/?comments=1	2	29
26	2014-09-19 01:07:07	http://youtu.be/QGxNyaXfJsA	2	30
27	2014-09-19 01:07:07	http://youtu.be/QGxNyaXfJsA	2	30
28	2014-09-19 01:07:07	http://youtu.be/QGxNyaXfJsA	2	30
29	2014-09-19 01:12:12	http://arstechnica.com/gaming/2014/09/addressing-allegations-of-collusion-among-gaming-journalists/	2	24
30	2014-09-19 01:12:24	http://arstechnica.com/page/2	2	24
31	2014-09-19 01:16:02	http://arstechnica.com/gaming/2014/09/addressing-allegations-of-collusion-among-gaming-journalists/?comments=1	2	31
32	2014-09-19 01:17:11	http://arstechnica.com/apple/2014/09/ios-8-on-the-iphone-4s-performance-isnt-the-only-problem/	2	33
33	2014-09-19 01:19:00	http://arstechnica.com/apple/2014/09/ios-8-on-the-iphone-4s-performance-isnt-the-only-problem/?comments=1	2	34
34	2014-09-19 06:27:31	http://www.washingtonpost.com/world/scots-turn-out-to-vote-in-independence-referendum/2014/09/18/85cf9278-5c90-4cbb-ab29-4f4c0d4ef949_story.html	2	36
35	2014-09-19 06:30:16	http://www.washingtonpost.com/world/national-security/rift-widens-between-obama-us-military-over-strategy-to-fight-islamic-state/2014/09/18/ebdb422e-3f5c-11e4-b03f-de718edeb92f_story.html	2	36
36	\N	\N	\N	\N
\.


--
-- Name: page_clicks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('page_clicks_id_seq', 36, true);


--
-- Data for Name: page_visits; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY page_visits (id, date_visited, time_active, user_id, page_id) FROM stdin;
1	2014-09-18 01:27:44	00:00:02	1	1
2	2014-09-18 01:27:48	00:00:03	1	2
3	2014-09-18 01:27:53	00:00:04	1	3
4	2014-09-18 01:28:01	00:00:06	1	4
5	2014-09-18 01:28:07	00:00:04	1	5
6	2014-09-18 01:28:14	00:00:06	1	6
7	2014-09-18 01:28:44	00:00:28	1	7
8	2014-09-18 01:29:17	00:00:31	1	8
9	2014-09-18 01:29:55	00:00:37	1	9
10	2014-09-18 01:31:14	00:00:35	1	7
11	2014-09-18 01:32:15	00:00:59	1	9
12	2014-09-18 14:46:01	00:00:36	1	10
13	2014-09-18 15:21:23	00:00:09	1	11
14	2014-09-18 15:22:33	00:01:08	1	12
15	2014-09-18 15:23:05	00:00:28	1	13
16	2014-09-18 15:23:21	00:00:13	1	14
17	2014-09-18 15:23:26	00:00:02	1	13
18	2014-09-18 15:23:58	00:00:30	1	15
19	2014-09-18 15:24:12	00:00:10	1	13
20	2014-09-18 15:39:50	00:15:36	1	16
21	2014-09-18 19:28:05	00:49:10	2	17
22	2014-09-18 21:19:50	00:00:22	1	18
23	2014-09-18 21:31:25	00:03:36	1	19
24	2014-09-18 21:32:52	00:01:23	1	20
25	2014-09-18 22:41:30	00:36:20	1	21
26	2014-09-18 22:41:32	01:21:22	1	22
27	2014-09-18 22:42:15	04:53:01	1	23
28	2014-09-19 01:04:50	00:03:46	2	26
29	2014-09-19 01:04:50	00:02:58	2	26
30	2014-09-19 01:04:50	00:03:48	2	26
31	2014-09-19 01:04:50	00:03:45	2	26
32	2014-09-19 01:05:03	00:00:12	2	27
33	2014-09-19 01:05:03	00:00:12	2	27
34	2014-09-19 01:05:03	00:00:12	2	27
35	2014-09-19 01:05:12	00:00:09	2	28
36	2014-09-19 01:05:12	00:00:09	2	28
37	2014-09-19 01:05:12	00:00:09	2	28
38	2014-09-19 01:05:30	00:00:17	2	27
39	2014-09-19 01:05:30	00:00:17	2	27
40	2014-09-19 01:05:30	00:00:17	2	27
41	2014-09-19 01:05:38	00:00:06	2	28
42	2014-09-19 01:05:38	00:00:06	2	28
43	2014-09-19 01:05:38	00:00:06	2	28
44	2014-09-19 01:05:54	00:00:15	2	27
45	2014-09-19 01:05:54	00:00:15	2	27
46	2014-09-19 01:05:54	00:00:15	2	27
47	2014-09-19 01:07:07	00:06:15	2	30
48	2014-09-19 01:07:07	00:00:27	2	30
49	2014-09-19 01:07:07	00:00:27	2	30
50	2014-09-19 01:12:25	00:11:41	2	24
51	2014-09-19 01:16:46	00:04:33	2	32
52	2014-09-19 01:16:46	00:00:43	2	32
53	2014-09-19 01:16:46	00:00:43	2	32
54	2014-09-19 01:19:59	00:02:46	2	35
55	2014-09-19 01:19:59	00:00:59	2	35
56	2014-09-19 01:19:59	00:00:57	2	35
57	2014-09-19 01:20:04	00:07:38	2	33
58	2014-09-19 06:30:13	00:02:40	2	37
59	2014-09-19 06:30:16	00:02:47	2	36
60	2014-09-19 06:33:47	00:03:30	2	38
61	2014-09-19 14:29:01	11:54:12	1	39
62	2014-09-19 17:16:23	14:48:41	1	39
63	2014-09-19 18:24:07	00:00:44	1	40
64	2014-09-19 18:58:59	00:00:00	1	41
65	2014-09-19 22:11:23	00:00:46	1	42
66	2014-09-19 22:13:02	00:00:21	1	42
67	2014-09-19 23:31:17	00:05:24	1	44
68	2014-09-20 02:31:57	03:00:36	1	45
\.


--
-- Name: page_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('page_visits_id_seq', 68, true);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY pages (id, url, display_name, site_id) FROM stdin;
1	http://stackoverflow.com/questions/2353818/how-do-i-get-started-with-node-js	\N	1
2	http://blog.stackoverflow.com/2014/09/introducing-runnable-javascript-css-and-html-code-snippets/?cb=1	\N	1
3	http://blog.stackoverflow.com/2014/07/please-welcome-jmac-community-manager-of-the-rising-sun/	\N	1
4	http://blog.stackoverflow.com/?s=ruby+performance	\N	1
5	http://stackoverflow.com/?s=ruby+performance	\N	1
6	http://stackoverflow.com/?tab=featured	\N	1
7	http://stackoverflow.com/questions/tagged/ruby+performance	\N	1
8	http://stackoverflow.com/questions/tagged/ruby+performance?sort=frequent&pageSize=50	\N	1
9	http://stackoverflow.com/questions/2529852/why-do-people-say-that-ruby-is-slow	\N	1
10	http://www.npr.org/blogs/thetwo-way/2014/09/16/349006089/bp-lawyers-use-old-school-trick-judge-not-amused?utm_source=facebook.com&utm_medium=social&utm_campaign=npr&utm_term=nprnews&utm_content=20140916	\N	2
11	http://www.nytimes.com/	\N	3
12	http://www.nytimes.com/2014/09/18/world/europe/scotland-independence-referendum.html?hp&action=click&pgtype=Homepage&version=LedeSum&module=first-column-region&region=top-news&WT.nav=top-news	\N	3
13	http://www.nytimes.com/pages/technology/index.html?module=SectionsNav&action=click&version=BrowseTree&region=TopBar&contentCollection=Technology&pgtype=article	\N	3
14	http://dealbook.nytimes.com/2014/09/18/identity-security-firm-ping-raises-35-million-from-k-k-r-and-others/?ref=technology	\N	3
15	http://bits.blogs.nytimes.com/2014/09/17/amazon-refreshes-its-kindle-line/?ref=technology	\N	3
16	http://www.nytimes.com/2014/09/17/technology/terrance-paul-developer-of-teaching-software-dies-at-67.html?ref=technology	\N	3
17	http://www.washingtonpost.com/posteverything/wp/2014/09/18/henry-kissinger-is-not-telling-the-truth-about-his-past-again/?hpid=z11	\N	4
18	http://stackoverflow.com/questions/1414951/how-do-i-get-elapsed-time-in-milliseconds-in-ruby	\N	1
19	http://stackoverflow.com/questions/1543171/how-can-i-output-leading-zeros-in-ruby	\N	1
20	http://stackoverflow.com/questions/19098056/increment-variable-in-ruby	\N	1
21	http://stackoverflow.com/questions/2191632/begin-rescue-and-ensure-in-ruby	\N	1
22	http://stackoverflow.com/questions/13148888/how-to-get-the-current-time-as-13-digit-integer-in-ruby	\N	1
23	http://stackoverflow.com/questions/12617152/how-do-i-create-directory-if-none-exists-using-file-class-in-ruby	\N	1
24	http://arstechnica.com/	\N	5
25	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/	\N	5
26	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/?comments=1&post=27616019&mode=quote#reply	\N	5
27	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/?comments=1&post=27616717	\N	5
28	http://arstechnica.com/gadgets/2014/09/android-l-will-have-device-encryption-on-by-default/?comments=1&post=27616717&mode=edit	\N	5
29	http://arstechnica.com/tech-policy/2014/09/giant-mq-4c-triton-surveillance-drone-flies-across-the-united-states/	\N	5
30	http://arstechnica.com/tech-policy/2014/09/giant-mq-4c-triton-surveillance-drone-flies-across-the-united-states/?comments=1	\N	5
31	http://arstechnica.com/gaming/2014/09/addressing-allegations-of-collusion-among-gaming-journalists/	\N	5
32	http://arstechnica.com/gaming/2014/09/addressing-allegations-of-collusion-among-gaming-journalists/?comments=1	\N	5
33	http://arstechnica.com/page/2/	\N	5
34	http://arstechnica.com/apple/2014/09/ios-8-on-the-iphone-4s-performance-isnt-the-only-problem/	\N	5
35	http://arstechnica.com/apple/2014/09/ios-8-on-the-iphone-4s-performance-isnt-the-only-problem/?comments=1	\N	5
36	http://www.washingtonpost.com/	\N	4
37	http://www.washingtonpost.com/world/scots-turn-out-to-vote-in-independence-referendum/2014/09/18/85cf9278-5c90-4cbb-ab29-4f4c0d4ef949_story.html?hpid=z1	\N	4
38	http://www.washingtonpost.com/world/national-security/rift-widens-between-obama-us-military-over-strategy-to-fight-islamic-state/2014/09/18/ebdb422e-3f5c-11e4-b03f-de718edeb92f_story.html?hpid=z2	\N	4
39	http://arstechnica.com/apple/2014/09/apple-expands-data-encryption-under-ios-8-making-handover-to-cops-moot/	\N	5
40	http://stackoverflow.com/questions/4293215/understanding-private-methods-in-ruby	\N	1
41	http://stackoverflow.com/questions/9658881/rails-select-unique-values-from-a-column	\N	1
42	http://stackoverflow.com/questions/8752654/how-do-i-effectively-force-minitest-to-run-my-tests-in-order	\N	1
43	http://stackoverflow.com/questions/3046607/rails-find-or-create-by-more-than-one-attribute	\N	1
44	http://stackoverflow.com/questions/9731585/lost-my-schema-rb-can-it-be-regenerated	\N	1
45	http://stackoverflow.com/questions/5951285/undo-a-git-merge-hasnt-been-committed-yet	\N	1
\.


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('pages_id_seq', 45, true);


--
-- Data for Name: raw_messages; Type: TABLE DATA; Schema: public; Owner: lt_dbo
--

COPY raw_messages (id, status_id, api_key, username, action, event, result, url, html, captured_at, created_at, updated_at) FROM stdin;
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
1	http://stackoverflow.com	Stack Overflow
2	http://npr.org	NPR
3	http://nytimes.com	New York Times
4	http://washingtonpost.com	Washington Post
5	http://arstechnica.com/	Ars Technica
\.


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lt_dbo
--

SELECT pg_catalog.setval('sites_id_seq', 5, true);


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
1	Jason		Hoekstra		jason	$2a$10$IeZaG5lQ56q2IqTdcmba0.vny910JK8EXTexoJKM4nQO50s3KqJu2	\N	\N	\N
2	Steve		Midgley		stevemidgley	$2a$10$bEGzXak92.vMA0en7.Lq8eC4FfhDuO/K8XTaw2kvan.H0NslpWdUu	\N	\N	\N
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

