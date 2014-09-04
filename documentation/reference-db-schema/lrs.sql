--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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
-- Name: attachment_cache; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE attachment_cache (
    cache_key character varying(255) NOT NULL,
    value text NOT NULL,
    expires timestamp with time zone NOT NULL
);


ALTER TABLE public.attachment_cache OWNER TO lrs_dbo;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO lrs_dbo;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO lrs_dbo;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO lrs_dbo;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    password character varying(128) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO lrs_dbo;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO lrs_dbo;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO lrs_dbo;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO lrs_dbo;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: cache_statement_list; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE cache_statement_list (
    cache_key character varying(255) NOT NULL,
    value text NOT NULL,
    expires timestamp with time zone NOT NULL
);


ALTER TABLE public.cache_statement_list OWNER TO lrs_dbo;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO lrs_dbo;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO lrs_dbo;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO lrs_dbo;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO lrs_dbo;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO lrs_dbo;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO lrs_dbo;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO lrs_dbo;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: lrs_activity; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_activity (
    id integer NOT NULL,
    activity_id character varying(2083) NOT NULL,
    "objectType" character varying(8) NOT NULL,
    activity_definition_name text NOT NULL,
    activity_definition_description text NOT NULL,
    activity_definition_type character varying(2083) NOT NULL,
    "activity_definition_moreInfo" character varying(2083) NOT NULL,
    "activity_definition_interactionType" character varying(25) NOT NULL,
    activity_definition_extensions text NOT NULL,
    activity_definition_crpanswers text NOT NULL,
    activity_definition_choices text NOT NULL,
    activity_definition_scales text NOT NULL,
    activity_definition_sources text NOT NULL,
    activity_definition_targets text NOT NULL,
    activity_definition_steps text NOT NULL,
    authoritative character varying(100) NOT NULL,
    canonical_version boolean NOT NULL
);


ALTER TABLE public.lrs_activity OWNER TO lrs_dbo;

--
-- Name: lrs_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_activity_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_activity_id_seq OWNED BY lrs_activity.id;


--
-- Name: lrs_activityprofile; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_activityprofile (
    id integer NOT NULL,
    "profileId" character varying(2083) NOT NULL,
    updated timestamp with time zone NOT NULL,
    "activityId" character varying(2083) NOT NULL,
    profile character varying(100),
    json_profile text NOT NULL,
    content_type character varying(255) NOT NULL,
    etag character varying(50) NOT NULL
);


ALTER TABLE public.lrs_activityprofile OWNER TO lrs_dbo;

--
-- Name: lrs_activityprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_activityprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_activityprofile_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_activityprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_activityprofile_id_seq OWNED BY lrs_activityprofile.id;


--
-- Name: lrs_activitystate; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_activitystate (
    id integer NOT NULL,
    state_id character varying(2083) NOT NULL,
    updated timestamp with time zone NOT NULL,
    state character varying(100),
    json_state text NOT NULL,
    agent_id integer NOT NULL,
    activity_id character varying(2083) NOT NULL,
    registration_id character varying(40) NOT NULL,
    content_type character varying(255) NOT NULL,
    etag character varying(50) NOT NULL
);


ALTER TABLE public.lrs_activitystate OWNER TO lrs_dbo;

--
-- Name: lrs_activitystate_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_activitystate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_activitystate_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_activitystate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_activitystate_id_seq OWNED BY lrs_activitystate.id;


--
-- Name: lrs_agent; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_agent (
    id integer NOT NULL,
    "objectType" character varying(6) NOT NULL,
    name character varying(100) NOT NULL,
    mbox character varying(128),
    mbox_sha1sum character varying(40),
    "openID" character varying(2083),
    oauth_identifier character varying(192),
    canonical_version boolean NOT NULL,
    "account_homePage" character varying(2083),
    account_name character varying(50)
);


ALTER TABLE public.lrs_agent OWNER TO lrs_dbo;

--
-- Name: lrs_agent_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_agent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_agent_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_agent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_agent_id_seq OWNED BY lrs_agent.id;


--
-- Name: lrs_agent_member; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_agent_member (
    id integer NOT NULL,
    from_agent_id integer NOT NULL,
    to_agent_id integer NOT NULL
);


ALTER TABLE public.lrs_agent_member OWNER TO lrs_dbo;

--
-- Name: lrs_agent_member_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_agent_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_agent_member_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_agent_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_agent_member_id_seq OWNED BY lrs_agent_member.id;


--
-- Name: lrs_agentprofile; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_agentprofile (
    id integer NOT NULL,
    "profileId" character varying(2083) NOT NULL,
    updated timestamp with time zone NOT NULL,
    agent_id integer NOT NULL,
    profile character varying(100),
    json_profile text NOT NULL,
    content_type character varying(255) NOT NULL,
    etag character varying(50) NOT NULL
);


ALTER TABLE public.lrs_agentprofile OWNER TO lrs_dbo;

--
-- Name: lrs_agentprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_agentprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_agentprofile_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_agentprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_agentprofile_id_seq OWNED BY lrs_agentprofile.id;


--
-- Name: lrs_consumer; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_consumer (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text NOT NULL,
    default_scopes character varying(100) NOT NULL,
    key character varying(36) NOT NULL,
    secret character varying(64) NOT NULL,
    status smallint NOT NULL,
    user_id integer
);


ALTER TABLE public.lrs_consumer OWNER TO lrs_dbo;

--
-- Name: lrs_consumer_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_consumer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_consumer_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_consumer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_consumer_id_seq OWNED BY lrs_consumer.id;


--
-- Name: lrs_nonce; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_nonce (
    id integer NOT NULL,
    token_key character varying(16) NOT NULL,
    consumer_key character varying(64) NOT NULL,
    key character varying(50) NOT NULL
);


ALTER TABLE public.lrs_nonce OWNER TO lrs_dbo;

--
-- Name: lrs_nonce_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_nonce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_nonce_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_nonce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_nonce_id_seq OWNED BY lrs_nonce.id;


--
-- Name: lrs_statement; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statement (
    id integer NOT NULL,
    statement_id character varying(36) NOT NULL,
    object_agent_id integer,
    object_activity_id integer,
    object_substatement_id integer,
    object_statementref_id integer,
    actor_id integer,
    verb_id integer,
    result_success boolean,
    result_completion boolean,
    result_response text NOT NULL,
    result_duration character varying(40) NOT NULL,
    result_score_scaled double precision,
    result_score_raw double precision,
    result_score_min double precision,
    result_score_max double precision,
    result_extensions text NOT NULL,
    stored timestamp with time zone NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    authority_id integer,
    voided boolean,
    context_registration character varying(40) NOT NULL,
    context_instructor_id integer,
    context_team_id integer,
    context_revision text NOT NULL,
    context_platform character varying(50) NOT NULL,
    context_language character varying(50) NOT NULL,
    context_extensions text NOT NULL,
    context_statement character varying(40) NOT NULL,
    version character varying(7) NOT NULL,
    user_id integer,
    full_statement text NOT NULL
);


ALTER TABLE public.lrs_statement OWNER TO lrs_dbo;

--
-- Name: lrs_statement_attachments; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statement_attachments (
    id integer NOT NULL,
    statement_id integer NOT NULL,
    statementattachment_id integer NOT NULL
);


ALTER TABLE public.lrs_statement_attachments OWNER TO lrs_dbo;

--
-- Name: lrs_statement_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statement_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statement_attachments_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statement_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statement_attachments_id_seq OWNED BY lrs_statement_attachments.id;


--
-- Name: lrs_statement_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statement_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statement_id_seq OWNED BY lrs_statement.id;


--
-- Name: lrs_statementattachment; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statementattachment (
    id integer NOT NULL,
    "usageType" character varying(2083) NOT NULL,
    "contentType" character varying(128) NOT NULL,
    length integer NOT NULL,
    sha2 character varying(128) NOT NULL,
    "fileUrl" character varying(2083) NOT NULL,
    payload character varying(100),
    display text NOT NULL,
    description text NOT NULL,
    CONSTRAINT lrs_statementattachment_length_check CHECK ((length >= 0))
);


ALTER TABLE public.lrs_statementattachment OWNER TO lrs_dbo;

--
-- Name: lrs_statementattachment_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statementattachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statementattachment_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statementattachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statementattachment_id_seq OWNED BY lrs_statementattachment.id;


--
-- Name: lrs_statementcontextactivity; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statementcontextactivity (
    id integer NOT NULL,
    key character varying(8) NOT NULL,
    statement_id integer NOT NULL
);


ALTER TABLE public.lrs_statementcontextactivity OWNER TO lrs_dbo;

--
-- Name: lrs_statementcontextactivity_context_activity; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statementcontextactivity_context_activity (
    id integer NOT NULL,
    statementcontextactivity_id integer NOT NULL,
    activity_id integer NOT NULL
);


ALTER TABLE public.lrs_statementcontextactivity_context_activity OWNER TO lrs_dbo;

--
-- Name: lrs_statementcontextactivity_context_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statementcontextactivity_context_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statementcontextactivity_context_activity_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statementcontextactivity_context_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statementcontextactivity_context_activity_id_seq OWNED BY lrs_statementcontextactivity_context_activity.id;


--
-- Name: lrs_statementcontextactivity_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statementcontextactivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statementcontextactivity_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statementcontextactivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statementcontextactivity_id_seq OWNED BY lrs_statementcontextactivity.id;


--
-- Name: lrs_statementref; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_statementref (
    id integer NOT NULL,
    object_type character varying(12) NOT NULL,
    ref_id character varying(40) NOT NULL
);


ALTER TABLE public.lrs_statementref OWNER TO lrs_dbo;

--
-- Name: lrs_statementref_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_statementref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_statementref_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_statementref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_statementref_id_seq OWNED BY lrs_statementref.id;


--
-- Name: lrs_substatement; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_substatement (
    id integer NOT NULL,
    object_agent_id integer,
    object_activity_id integer,
    object_statementref_id integer,
    actor_id integer,
    verb_id integer,
    result_success boolean,
    result_completion boolean,
    result_response text NOT NULL,
    result_duration character varying(40) NOT NULL,
    result_score_scaled double precision,
    result_score_raw double precision,
    result_score_min double precision,
    result_score_max double precision,
    result_extensions text NOT NULL,
    "timestamp" timestamp with time zone,
    context_registration character varying(40) NOT NULL,
    context_instructor_id integer,
    context_team_id integer,
    context_revision text NOT NULL,
    context_platform character varying(50) NOT NULL,
    context_language character varying(50) NOT NULL,
    context_extensions text NOT NULL,
    context_statement character varying(40) NOT NULL
);


ALTER TABLE public.lrs_substatement OWNER TO lrs_dbo;

--
-- Name: lrs_substatement_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_substatement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_substatement_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_substatement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_substatement_id_seq OWNED BY lrs_substatement.id;


--
-- Name: lrs_substatementcontextactivity; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_substatementcontextactivity (
    id integer NOT NULL,
    key character varying(8) NOT NULL,
    substatement_id integer NOT NULL
);


ALTER TABLE public.lrs_substatementcontextactivity OWNER TO lrs_dbo;

--
-- Name: lrs_substatementcontextactivity_context_activity; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_substatementcontextactivity_context_activity (
    id integer NOT NULL,
    substatementcontextactivity_id integer NOT NULL,
    activity_id integer NOT NULL
);


ALTER TABLE public.lrs_substatementcontextactivity_context_activity OWNER TO lrs_dbo;

--
-- Name: lrs_substatementcontextactivity_context_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_substatementcontextactivity_context_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_substatementcontextactivity_context_activity_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_substatementcontextactivity_context_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_substatementcontextactivity_context_activity_id_seq OWNED BY lrs_substatementcontextactivity_context_activity.id;


--
-- Name: lrs_substatementcontextactivity_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_substatementcontextactivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_substatementcontextactivity_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_substatementcontextactivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_substatementcontextactivity_id_seq OWNED BY lrs_substatementcontextactivity.id;


--
-- Name: lrs_token; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_token (
    id integer NOT NULL,
    key character varying(16),
    secret character varying(64),
    token_type smallint NOT NULL,
    "timestamp" integer NOT NULL,
    is_approved boolean NOT NULL,
    lrs_auth_id character varying(50),
    user_id integer,
    consumer_id integer NOT NULL,
    scope character varying(100) NOT NULL,
    verifier character varying(10) NOT NULL,
    callback character varying(2083),
    callback_confirmed boolean NOT NULL
);


ALTER TABLE public.lrs_token OWNER TO lrs_dbo;

--
-- Name: lrs_token_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_token_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_token_id_seq OWNED BY lrs_token.id;


--
-- Name: lrs_verb; Type: TABLE; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE TABLE lrs_verb (
    id integer NOT NULL,
    verb_id character varying(2083) NOT NULL,
    display text NOT NULL
);


ALTER TABLE public.lrs_verb OWNER TO lrs_dbo;

--
-- Name: lrs_verb_id_seq; Type: SEQUENCE; Schema: public; Owner: lrs_dbo
--

CREATE SEQUENCE lrs_verb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lrs_verb_id_seq OWNER TO lrs_dbo;

--
-- Name: lrs_verb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lrs_dbo
--

ALTER SEQUENCE lrs_verb_id_seq OWNED BY lrs_verb.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_activity ALTER COLUMN id SET DEFAULT nextval('lrs_activity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_activityprofile ALTER COLUMN id SET DEFAULT nextval('lrs_activityprofile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_activitystate ALTER COLUMN id SET DEFAULT nextval('lrs_activitystate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agent ALTER COLUMN id SET DEFAULT nextval('lrs_agent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agent_member ALTER COLUMN id SET DEFAULT nextval('lrs_agent_member_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agentprofile ALTER COLUMN id SET DEFAULT nextval('lrs_agentprofile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_consumer ALTER COLUMN id SET DEFAULT nextval('lrs_consumer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_nonce ALTER COLUMN id SET DEFAULT nextval('lrs_nonce_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement ALTER COLUMN id SET DEFAULT nextval('lrs_statement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement_attachments ALTER COLUMN id SET DEFAULT nextval('lrs_statement_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementattachment ALTER COLUMN id SET DEFAULT nextval('lrs_statementattachment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementcontextactivity ALTER COLUMN id SET DEFAULT nextval('lrs_statementcontextactivity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementcontextactivity_context_activity ALTER COLUMN id SET DEFAULT nextval('lrs_statementcontextactivity_context_activity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementref ALTER COLUMN id SET DEFAULT nextval('lrs_statementref_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement ALTER COLUMN id SET DEFAULT nextval('lrs_substatement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatementcontextactivity ALTER COLUMN id SET DEFAULT nextval('lrs_substatementcontextactivity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatementcontextactivity_context_activity ALTER COLUMN id SET DEFAULT nextval('lrs_substatementcontextactivity_context_activity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_token ALTER COLUMN id SET DEFAULT nextval('lrs_token_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_verb ALTER COLUMN id SET DEFAULT nextval('lrs_verb_id_seq'::regclass);


--
-- Data for Name: attachment_cache; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY attachment_cache (cache_key, value, expires) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add site	6	add_site
17	Can change site	6	change_site
18	Can delete site	6	delete_site
19	Can add nonce	7	add_nonce
20	Can change nonce	7	change_nonce
21	Can delete nonce	7	delete_nonce
22	Can add consumer	8	add_consumer
23	Can change consumer	8	change_consumer
24	Can delete consumer	8	delete_consumer
25	Can add token	9	add_token
26	Can change token	9	change_token
27	Can delete token	9	delete_token
28	Can add verb	10	add_verb
29	Can change verb	10	change_verb
30	Can delete verb	10	delete_verb
31	Can add agent	11	add_agent
32	Can change agent	11	change_agent
33	Can delete agent	11	delete_agent
34	Can add agent profile	12	add_agentprofile
35	Can change agent profile	12	change_agentprofile
36	Can delete agent profile	12	delete_agentprofile
37	Can add activity	13	add_activity
38	Can change activity	13	change_activity
39	Can delete activity	13	delete_activity
40	Can add statement ref	14	add_statementref
41	Can change statement ref	14	change_statementref
42	Can delete statement ref	14	delete_statementref
43	Can add sub statement context activity	15	add_substatementcontextactivity
44	Can change sub statement context activity	15	change_substatementcontextactivity
45	Can delete sub statement context activity	15	delete_substatementcontextactivity
46	Can add statement context activity	16	add_statementcontextactivity
47	Can change statement context activity	16	change_statementcontextactivity
48	Can delete statement context activity	16	delete_statementcontextactivity
49	Can add activity state	17	add_activitystate
50	Can change activity state	17	change_activitystate
51	Can delete activity state	17	delete_activitystate
52	Can add activity profile	18	add_activityprofile
53	Can change activity profile	18	change_activityprofile
54	Can delete activity profile	18	delete_activityprofile
55	Can add sub statement	19	add_substatement
56	Can change sub statement	19	change_substatement
57	Can delete sub statement	19	delete_substatement
58	Can add statement attachment	20	add_statementattachment
59	Can change statement attachment	20	change_statementattachment
60	Can delete statement attachment	20	delete_statementattachment
61	Can add statement	21	add_statement
62	Can change statement	21	change_statement
63	Can delete statement	21	delete_statement
64	Can add log entry	22	add_logentry
65	Can change log entry	22	change_logentry
66	Can delete log entry	22	delete_logentry
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_permission_id_seq', 66, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_user (id, username, first_name, last_name, email, password, is_staff, is_active, is_superuser, last_login, date_joined) FROM stdin;
1	adllrs			none@none.com	pbkdf2_sha256$10000$ZtoByCo4QZZv$B5HEK2p2JKclZB8kLZZT929g1n7RM3/nEV0SGYoiC+E=	t	t	t	2014-06-30 21:36:52.810086-04	2014-06-30 21:36:52.810086-04
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_user_id_seq', 1, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: cache_statement_list; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY cache_statement_list (cache_key, value, expires) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY django_admin_log (id, action_time, user_id, content_type_id, object_id, object_repr, action_flag, change_message) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
4	content type	contenttypes	contenttype
5	session	sessions	session
6	site	sites	site
7	nonce	lrs	nonce
8	consumer	lrs	consumer
9	token	lrs	token
10	verb	lrs	verb
11	agent	lrs	agent
12	agent profile	lrs	agentprofile
13	activity	lrs	activity
14	statement ref	lrs	statementref
15	sub statement context activity	lrs	substatementcontextactivity
16	statement context activity	lrs	statementcontextactivity
17	activity state	lrs	activitystate
18	activity profile	lrs	activityprofile
19	sub statement	lrs	substatement
20	statement attachment	lrs	statementattachment
21	statement	lrs	statement
22	log entry	admin	logentry
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('django_content_type_id_seq', 22, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Data for Name: lrs_activity; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_activity (id, activity_id, "objectType", activity_definition_name, activity_definition_description, activity_definition_type, "activity_definition_moreInfo", "activity_definition_interactionType", activity_definition_extensions, activity_definition_crpanswers, activity_definition_choices, activity_definition_scales, activity_definition_sources, activity_definition_targets, activity_definition_steps, authoritative, canonical_version) FROM stdin;
\.


--
-- Name: lrs_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_activity_id_seq', 1, false);


--
-- Data for Name: lrs_activityprofile; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_activityprofile (id, "profileId", updated, "activityId", profile, json_profile, content_type, etag) FROM stdin;
\.


--
-- Name: lrs_activityprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_activityprofile_id_seq', 1, false);


--
-- Data for Name: lrs_activitystate; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_activitystate (id, state_id, updated, state, json_state, agent_id, activity_id, registration_id, content_type, etag) FROM stdin;
\.


--
-- Name: lrs_activitystate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_activitystate_id_seq', 1, false);


--
-- Data for Name: lrs_agent; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_agent (id, "objectType", name, mbox, mbox_sha1sum, "openID", oauth_identifier, canonical_version, "account_homePage", account_name) FROM stdin;
\.


--
-- Name: lrs_agent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_agent_id_seq', 1, false);


--
-- Data for Name: lrs_agent_member; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_agent_member (id, from_agent_id, to_agent_id) FROM stdin;
\.


--
-- Name: lrs_agent_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_agent_member_id_seq', 1, false);


--
-- Data for Name: lrs_agentprofile; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_agentprofile (id, "profileId", updated, agent_id, profile, json_profile, content_type, etag) FROM stdin;
\.


--
-- Name: lrs_agentprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_agentprofile_id_seq', 1, false);


--
-- Data for Name: lrs_consumer; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_consumer (id, name, description, default_scopes, key, secret, status, user_id) FROM stdin;
\.


--
-- Name: lrs_consumer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_consumer_id_seq', 1, false);


--
-- Data for Name: lrs_nonce; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_nonce (id, token_key, consumer_key, key) FROM stdin;
\.


--
-- Name: lrs_nonce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_nonce_id_seq', 1, false);


--
-- Data for Name: lrs_statement; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statement (id, statement_id, object_agent_id, object_activity_id, object_substatement_id, object_statementref_id, actor_id, verb_id, result_success, result_completion, result_response, result_duration, result_score_scaled, result_score_raw, result_score_min, result_score_max, result_extensions, stored, "timestamp", authority_id, voided, context_registration, context_instructor_id, context_team_id, context_revision, context_platform, context_language, context_extensions, context_statement, version, user_id, full_statement) FROM stdin;
\.


--
-- Data for Name: lrs_statement_attachments; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statement_attachments (id, statement_id, statementattachment_id) FROM stdin;
\.


--
-- Name: lrs_statement_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statement_attachments_id_seq', 1, false);


--
-- Name: lrs_statement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statement_id_seq', 1, false);


--
-- Data for Name: lrs_statementattachment; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statementattachment (id, "usageType", "contentType", length, sha2, "fileUrl", payload, display, description) FROM stdin;
\.


--
-- Name: lrs_statementattachment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statementattachment_id_seq', 1, false);


--
-- Data for Name: lrs_statementcontextactivity; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statementcontextactivity (id, key, statement_id) FROM stdin;
\.


--
-- Data for Name: lrs_statementcontextactivity_context_activity; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statementcontextactivity_context_activity (id, statementcontextactivity_id, activity_id) FROM stdin;
\.


--
-- Name: lrs_statementcontextactivity_context_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statementcontextactivity_context_activity_id_seq', 1, false);


--
-- Name: lrs_statementcontextactivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statementcontextactivity_id_seq', 1, false);


--
-- Data for Name: lrs_statementref; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_statementref (id, object_type, ref_id) FROM stdin;
\.


--
-- Name: lrs_statementref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_statementref_id_seq', 1, false);


--
-- Data for Name: lrs_substatement; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_substatement (id, object_agent_id, object_activity_id, object_statementref_id, actor_id, verb_id, result_success, result_completion, result_response, result_duration, result_score_scaled, result_score_raw, result_score_min, result_score_max, result_extensions, "timestamp", context_registration, context_instructor_id, context_team_id, context_revision, context_platform, context_language, context_extensions, context_statement) FROM stdin;
\.


--
-- Name: lrs_substatement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_substatement_id_seq', 1, false);


--
-- Data for Name: lrs_substatementcontextactivity; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_substatementcontextactivity (id, key, substatement_id) FROM stdin;
\.


--
-- Data for Name: lrs_substatementcontextactivity_context_activity; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_substatementcontextactivity_context_activity (id, substatementcontextactivity_id, activity_id) FROM stdin;
\.


--
-- Name: lrs_substatementcontextactivity_context_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_substatementcontextactivity_context_activity_id_seq', 1, false);


--
-- Name: lrs_substatementcontextactivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_substatementcontextactivity_id_seq', 1, false);


--
-- Data for Name: lrs_token; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_token (id, key, secret, token_type, "timestamp", is_approved, lrs_auth_id, user_id, consumer_id, scope, verifier, callback, callback_confirmed) FROM stdin;
\.


--
-- Name: lrs_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_token_id_seq', 1, false);


--
-- Data for Name: lrs_verb; Type: TABLE DATA; Schema: public; Owner: lrs_dbo
--

COPY lrs_verb (id, verb_id, display) FROM stdin;
\.


--
-- Name: lrs_verb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lrs_dbo
--

SELECT pg_catalog.setval('lrs_verb_id_seq', 1, false);


--
-- Name: attachment_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY attachment_cache
    ADD CONSTRAINT attachment_cache_pkey PRIMARY KEY (cache_key);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: cache_statement_list_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY cache_statement_list
    ADD CONSTRAINT cache_statement_list_pkey PRIMARY KEY (cache_key);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: lrs_activity_activity_id_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_activity
    ADD CONSTRAINT lrs_activity_activity_id_canonical_version_key UNIQUE (activity_id, canonical_version);


--
-- Name: lrs_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_activity
    ADD CONSTRAINT lrs_activity_pkey PRIMARY KEY (id);


--
-- Name: lrs_activityprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_activityprofile
    ADD CONSTRAINT lrs_activityprofile_pkey PRIMARY KEY (id);


--
-- Name: lrs_activitystate_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_activitystate
    ADD CONSTRAINT lrs_activitystate_pkey PRIMARY KEY (id);


--
-- Name: lrs_agent_account_homePage_account_name_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT "lrs_agent_account_homePage_account_name_canonical_version_key" UNIQUE ("account_homePage", account_name, canonical_version);


--
-- Name: lrs_agent_mbox_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT lrs_agent_mbox_canonical_version_key UNIQUE (mbox, canonical_version);


--
-- Name: lrs_agent_mbox_sha1sum_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT lrs_agent_mbox_sha1sum_canonical_version_key UNIQUE (mbox_sha1sum, canonical_version);


--
-- Name: lrs_agent_member_from_agent_id_to_agent_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent_member
    ADD CONSTRAINT lrs_agent_member_from_agent_id_to_agent_id_key UNIQUE (from_agent_id, to_agent_id);


--
-- Name: lrs_agent_member_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent_member
    ADD CONSTRAINT lrs_agent_member_pkey PRIMARY KEY (id);


--
-- Name: lrs_agent_oauth_identifier_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT lrs_agent_oauth_identifier_canonical_version_key UNIQUE (oauth_identifier, canonical_version);


--
-- Name: lrs_agent_openID_canonical_version_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT "lrs_agent_openID_canonical_version_key" UNIQUE ("openID", canonical_version);


--
-- Name: lrs_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agent
    ADD CONSTRAINT lrs_agent_pkey PRIMARY KEY (id);


--
-- Name: lrs_agentprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_agentprofile
    ADD CONSTRAINT lrs_agentprofile_pkey PRIMARY KEY (id);


--
-- Name: lrs_consumer_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_consumer
    ADD CONSTRAINT lrs_consumer_pkey PRIMARY KEY (id);


--
-- Name: lrs_nonce_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_nonce
    ADD CONSTRAINT lrs_nonce_pkey PRIMARY KEY (id);


--
-- Name: lrs_statement_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statement_attachments
    ADD CONSTRAINT lrs_statement_attachments_pkey PRIMARY KEY (id);


--
-- Name: lrs_statement_attachments_statement_id_statementattachment__key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statement_attachments
    ADD CONSTRAINT lrs_statement_attachments_statement_id_statementattachment__key UNIQUE (statement_id, statementattachment_id);


--
-- Name: lrs_statement_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_pkey PRIMARY KEY (id);


--
-- Name: lrs_statement_statement_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_statement_id_key UNIQUE (statement_id);


--
-- Name: lrs_statementattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statementattachment
    ADD CONSTRAINT lrs_statementattachment_pkey PRIMARY KEY (id);


--
-- Name: lrs_statementcontextactivity__statementcontextactivity_id_a_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statementcontextactivity_context_activity
    ADD CONSTRAINT lrs_statementcontextactivity__statementcontextactivity_id_a_key UNIQUE (statementcontextactivity_id, activity_id);


--
-- Name: lrs_statementcontextactivity_context_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statementcontextactivity_context_activity
    ADD CONSTRAINT lrs_statementcontextactivity_context_activity_pkey PRIMARY KEY (id);


--
-- Name: lrs_statementcontextactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statementcontextactivity
    ADD CONSTRAINT lrs_statementcontextactivity_pkey PRIMARY KEY (id);


--
-- Name: lrs_statementref_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_statementref
    ADD CONSTRAINT lrs_statementref_pkey PRIMARY KEY (id);


--
-- Name: lrs_substatement_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_pkey PRIMARY KEY (id);


--
-- Name: lrs_substatementcontextactivi_substatementcontextactivity_i_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_substatementcontextactivity_context_activity
    ADD CONSTRAINT lrs_substatementcontextactivi_substatementcontextactivity_i_key UNIQUE (substatementcontextactivity_id, activity_id);


--
-- Name: lrs_substatementcontextactivity_context_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_substatementcontextactivity_context_activity
    ADD CONSTRAINT lrs_substatementcontextactivity_context_activity_pkey PRIMARY KEY (id);


--
-- Name: lrs_substatementcontextactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_substatementcontextactivity
    ADD CONSTRAINT lrs_substatementcontextactivity_pkey PRIMARY KEY (id);


--
-- Name: lrs_token_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_token
    ADD CONSTRAINT lrs_token_pkey PRIMARY KEY (id);


--
-- Name: lrs_verb_pkey; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_verb
    ADD CONSTRAINT lrs_verb_pkey PRIMARY KEY (id);


--
-- Name: lrs_verb_verb_id_key; Type: CONSTRAINT; Schema: public; Owner: lrs_dbo; Tablespace: 
--

ALTER TABLE ONLY lrs_verb
    ADD CONSTRAINT lrs_verb_verb_id_key UNIQUE (verb_id);


--
-- Name: attachment_cache_expires; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX attachment_cache_expires ON attachment_cache USING btree (expires);


--
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_user_groups_group_id ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_user_groups_user_id ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_permission_id ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_user_id ON auth_user_user_permissions USING btree (user_id);


--
-- Name: cache_statement_list_expires; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX cache_statement_list_expires ON cache_statement_list USING btree (expires);


--
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX django_session_expire_date ON django_session USING btree (expire_date);


--
-- Name: lrs_activity_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activity_activity_id ON lrs_activity USING btree (activity_id);


--
-- Name: lrs_activity_activity_id_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activity_activity_id_like ON lrs_activity USING btree (activity_id varchar_pattern_ops);


--
-- Name: lrs_activityprofile_activityId; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_activityprofile_activityId" ON lrs_activityprofile USING btree ("activityId");


--
-- Name: lrs_activityprofile_activityId_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_activityprofile_activityId_like" ON lrs_activityprofile USING btree ("activityId" varchar_pattern_ops);


--
-- Name: lrs_activityprofile_profileId; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_activityprofile_profileId" ON lrs_activityprofile USING btree ("profileId");


--
-- Name: lrs_activityprofile_profileId_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_activityprofile_profileId_like" ON lrs_activityprofile USING btree ("profileId" varchar_pattern_ops);


--
-- Name: lrs_activityprofile_updated; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activityprofile_updated ON lrs_activityprofile USING btree (updated);


--
-- Name: lrs_activitystate_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activitystate_activity_id ON lrs_activitystate USING btree (activity_id);


--
-- Name: lrs_activitystate_activity_id_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activitystate_activity_id_like ON lrs_activitystate USING btree (activity_id varchar_pattern_ops);


--
-- Name: lrs_activitystate_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activitystate_agent_id ON lrs_activitystate USING btree (agent_id);


--
-- Name: lrs_activitystate_updated; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_activitystate_updated ON lrs_activitystate USING btree (updated);


--
-- Name: lrs_agent_mbox; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_mbox ON lrs_agent USING btree (mbox);


--
-- Name: lrs_agent_mbox_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_mbox_like ON lrs_agent USING btree (mbox varchar_pattern_ops);


--
-- Name: lrs_agent_mbox_sha1sum; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_mbox_sha1sum ON lrs_agent USING btree (mbox_sha1sum);


--
-- Name: lrs_agent_mbox_sha1sum_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_mbox_sha1sum_like ON lrs_agent USING btree (mbox_sha1sum varchar_pattern_ops);


--
-- Name: lrs_agent_member_from_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_member_from_agent_id ON lrs_agent_member USING btree (from_agent_id);


--
-- Name: lrs_agent_member_to_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_member_to_agent_id ON lrs_agent_member USING btree (to_agent_id);


--
-- Name: lrs_agent_oauth_identifier; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_oauth_identifier ON lrs_agent USING btree (oauth_identifier);


--
-- Name: lrs_agent_oauth_identifier_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agent_oauth_identifier_like ON lrs_agent USING btree (oauth_identifier varchar_pattern_ops);


--
-- Name: lrs_agent_openID; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_agent_openID" ON lrs_agent USING btree ("openID");


--
-- Name: lrs_agent_openID_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_agent_openID_like" ON lrs_agent USING btree ("openID" varchar_pattern_ops);


--
-- Name: lrs_agentprofile_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_agentprofile_agent_id ON lrs_agentprofile USING btree (agent_id);


--
-- Name: lrs_agentprofile_profileId; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_agentprofile_profileId" ON lrs_agentprofile USING btree ("profileId");


--
-- Name: lrs_agentprofile_profileId_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX "lrs_agentprofile_profileId_like" ON lrs_agentprofile USING btree ("profileId" varchar_pattern_ops);


--
-- Name: lrs_consumer_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_consumer_user_id ON lrs_consumer USING btree (user_id);


--
-- Name: lrs_statement_actor_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_actor_id ON lrs_statement USING btree (actor_id);


--
-- Name: lrs_statement_attachments_statement_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_attachments_statement_id ON lrs_statement_attachments USING btree (statement_id);


--
-- Name: lrs_statement_attachments_statementattachment_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_attachments_statementattachment_id ON lrs_statement_attachments USING btree (statementattachment_id);


--
-- Name: lrs_statement_authority_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_authority_id ON lrs_statement USING btree (authority_id);


--
-- Name: lrs_statement_context_instructor_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_context_instructor_id ON lrs_statement USING btree (context_instructor_id);


--
-- Name: lrs_statement_context_registration; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_context_registration ON lrs_statement USING btree (context_registration);


--
-- Name: lrs_statement_context_registration_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_context_registration_like ON lrs_statement USING btree (context_registration varchar_pattern_ops);


--
-- Name: lrs_statement_context_team_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_context_team_id ON lrs_statement USING btree (context_team_id);


--
-- Name: lrs_statement_object_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_object_activity_id ON lrs_statement USING btree (object_activity_id);


--
-- Name: lrs_statement_object_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_object_agent_id ON lrs_statement USING btree (object_agent_id);


--
-- Name: lrs_statement_object_statementref_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_object_statementref_id ON lrs_statement USING btree (object_statementref_id);


--
-- Name: lrs_statement_object_substatement_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_object_substatement_id ON lrs_statement USING btree (object_substatement_id);


--
-- Name: lrs_statement_stored; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_stored ON lrs_statement USING btree (stored);


--
-- Name: lrs_statement_timestamp; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_timestamp ON lrs_statement USING btree ("timestamp");


--
-- Name: lrs_statement_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_user_id ON lrs_statement USING btree (user_id);


--
-- Name: lrs_statement_verb_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statement_verb_id ON lrs_statement USING btree (verb_id);


--
-- Name: lrs_statementcontextactivity_context_activity_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statementcontextactivity_context_activity_activity_id ON lrs_statementcontextactivity_context_activity USING btree (activity_id);


--
-- Name: lrs_statementcontextactivity_context_activity_statementcontf965; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statementcontextactivity_context_activity_statementcontf965 ON lrs_statementcontextactivity_context_activity USING btree (statementcontextactivity_id);


--
-- Name: lrs_statementcontextactivity_statement_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_statementcontextactivity_statement_id ON lrs_statementcontextactivity USING btree (statement_id);


--
-- Name: lrs_substatement_actor_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_actor_id ON lrs_substatement USING btree (actor_id);


--
-- Name: lrs_substatement_context_instructor_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_context_instructor_id ON lrs_substatement USING btree (context_instructor_id);


--
-- Name: lrs_substatement_context_registration; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_context_registration ON lrs_substatement USING btree (context_registration);


--
-- Name: lrs_substatement_context_registration_like; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_context_registration_like ON lrs_substatement USING btree (context_registration varchar_pattern_ops);


--
-- Name: lrs_substatement_context_team_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_context_team_id ON lrs_substatement USING btree (context_team_id);


--
-- Name: lrs_substatement_object_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_object_activity_id ON lrs_substatement USING btree (object_activity_id);


--
-- Name: lrs_substatement_object_agent_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_object_agent_id ON lrs_substatement USING btree (object_agent_id);


--
-- Name: lrs_substatement_object_statementref_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_object_statementref_id ON lrs_substatement USING btree (object_statementref_id);


--
-- Name: lrs_substatement_verb_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatement_verb_id ON lrs_substatement USING btree (verb_id);


--
-- Name: lrs_substatementcontextactivity_context_activity_activity_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatementcontextactivity_context_activity_activity_id ON lrs_substatementcontextactivity_context_activity USING btree (activity_id);


--
-- Name: lrs_substatementcontextactivity_context_activity_substateme9705; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatementcontextactivity_context_activity_substateme9705 ON lrs_substatementcontextactivity_context_activity USING btree (substatementcontextactivity_id);


--
-- Name: lrs_substatementcontextactivity_substatement_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_substatementcontextactivity_substatement_id ON lrs_substatementcontextactivity USING btree (substatement_id);


--
-- Name: lrs_token_consumer_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_token_consumer_id ON lrs_token USING btree (consumer_id);


--
-- Name: lrs_token_token_type; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_token_token_type ON lrs_token USING btree (token_type);


--
-- Name: lrs_token_user_id; Type: INDEX; Schema: public; Owner: lrs_dbo; Tablespace: 
--

CREATE INDEX lrs_token_user_id ON lrs_token USING btree (user_id);


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_728de91f; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_728de91f FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: from_agent_id_refs_id_7d553a11; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agent_member
    ADD CONSTRAINT from_agent_id_refs_id_7d553a11 FOREIGN KEY (from_agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_3cea63fe; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_3cea63fe FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_activitystate_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_activitystate
    ADD CONSTRAINT lrs_activitystate_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_agentprofile_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agentprofile
    ADD CONSTRAINT lrs_agentprofile_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_consumer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_consumer
    ADD CONSTRAINT lrs_consumer_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_attachments_statementattachment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement_attachments
    ADD CONSTRAINT lrs_statement_attachments_statementattachment_id_fkey FOREIGN KEY (statementattachment_id) REFERENCES lrs_statementattachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_authority_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_authority_id_fkey FOREIGN KEY (authority_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_context_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_context_instructor_id_fkey FOREIGN KEY (context_instructor_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_context_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_context_team_id_fkey FOREIGN KEY (context_team_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_object_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_object_activity_id_fkey FOREIGN KEY (object_activity_id) REFERENCES lrs_activity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_object_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_object_agent_id_fkey FOREIGN KEY (object_agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_object_statementref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_object_statementref_id_fkey FOREIGN KEY (object_statementref_id) REFERENCES lrs_statementref(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_object_substatement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_object_substatement_id_fkey FOREIGN KEY (object_substatement_id) REFERENCES lrs_substatement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statement_verb_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement
    ADD CONSTRAINT lrs_statement_verb_id_fkey FOREIGN KEY (verb_id) REFERENCES lrs_verb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_statementcontextactivity_context_activity_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementcontextactivity_context_activity
    ADD CONSTRAINT lrs_statementcontextactivity_context_activity_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES lrs_activity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_context_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_context_instructor_id_fkey FOREIGN KEY (context_instructor_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_context_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_context_team_id_fkey FOREIGN KEY (context_team_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_object_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_object_activity_id_fkey FOREIGN KEY (object_activity_id) REFERENCES lrs_activity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_object_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_object_agent_id_fkey FOREIGN KEY (object_agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_object_statementref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_object_statementref_id_fkey FOREIGN KEY (object_statementref_id) REFERENCES lrs_statementref(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatement_verb_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatement
    ADD CONSTRAINT lrs_substatement_verb_id_fkey FOREIGN KEY (verb_id) REFERENCES lrs_verb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_substatementcontextactivity_context_activi_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatementcontextactivity_context_activity
    ADD CONSTRAINT lrs_substatementcontextactivity_context_activi_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES lrs_activity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_token_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_token
    ADD CONSTRAINT lrs_token_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES lrs_consumer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: lrs_token_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_token
    ADD CONSTRAINT lrs_token_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: statement_id_refs_id_e9cde6b0; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statement_attachments
    ADD CONSTRAINT statement_id_refs_id_e9cde6b0 FOREIGN KEY (statement_id) REFERENCES lrs_statement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: statement_id_refs_id_eec7e3be; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementcontextactivity
    ADD CONSTRAINT statement_id_refs_id_eec7e3be FOREIGN KEY (statement_id) REFERENCES lrs_statement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: statementcontextactivity_id_refs_id_8d01306a; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_statementcontextactivity_context_activity
    ADD CONSTRAINT statementcontextactivity_id_refs_id_8d01306a FOREIGN KEY (statementcontextactivity_id) REFERENCES lrs_statementcontextactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: substatement_id_refs_id_65e8015e; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatementcontextactivity
    ADD CONSTRAINT substatement_id_refs_id_65e8015e FOREIGN KEY (substatement_id) REFERENCES lrs_substatement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: substatementcontextactivity_id_refs_id_ed48dc4e; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_substatementcontextactivity_context_activity
    ADD CONSTRAINT substatementcontextactivity_id_refs_id_ed48dc4e FOREIGN KEY (substatementcontextactivity_id) REFERENCES lrs_substatementcontextactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: to_agent_id_refs_id_7d553a11; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY lrs_agent_member
    ADD CONSTRAINT to_agent_id_refs_id_7d553a11 FOREIGN KEY (to_agent_id) REFERENCES lrs_agent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_831107f1; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT user_id_refs_id_831107f1 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_f2045483; Type: FK CONSTRAINT; Schema: public; Owner: lrs_dbo
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_f2045483 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


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

