/*
 Navicat Premium Data Transfer

 Source Server         : postgres-ubuntubox
 Source Server Type    : PostgreSQL
 Source Server Version : 90305
 Source Host           : 192.168.1.76
 Source Database       : lt_dev_db
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90305
 File Encoding         : utf-8

 Date: 10/08/2014 00:20:37 AM
*/

-- ----------------------------
--  Sequence structure for "public"."api_keys_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."api_keys_id_seq";
CREATE SEQUENCE "public"."api_keys_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."api_keys_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."approved_sites_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."approved_sites_id_seq";
CREATE SEQUENCE "public"."approved_sites_id_seq" INCREMENT 1 START 2 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."approved_sites_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."course_offerings_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."course_offerings_id_seq";
CREATE SEQUENCE "public"."course_offerings_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."course_offerings_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."courses_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."courses_id_seq";
CREATE SEQUENCE "public"."courses_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."courses_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."districts_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."districts_id_seq";
CREATE SEQUENCE "public"."districts_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."districts_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."emails_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."emails_id_seq";
CREATE SEQUENCE "public"."emails_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."emails_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."organizations_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."organizations_id_seq";
CREATE SEQUENCE "public"."organizations_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."organizations_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."page_clicks_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."page_clicks_id_seq";
CREATE SEQUENCE "public"."page_clicks_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."page_clicks_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."page_visits_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."page_visits_id_seq";
CREATE SEQUENCE "public"."page_visits_id_seq" INCREMENT 1 START 9 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."page_visits_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."pages_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."pages_id_seq";
CREATE SEQUENCE "public"."pages_id_seq" INCREMENT 1 START 9 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."pages_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."raw_message_logs_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."raw_message_logs_id_seq";
CREATE SEQUENCE "public"."raw_message_logs_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."raw_message_logs_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."raw_messages_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."raw_messages_id_seq";
CREATE SEQUENCE "public"."raw_messages_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."raw_messages_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."schools_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."schools_id_seq";
CREATE SEQUENCE "public"."schools_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."schools_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."section_users_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."section_users_id_seq";
CREATE SEQUENCE "public"."section_users_id_seq" INCREMENT 1 START 3 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."section_users_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."sections_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sections_id_seq";
CREATE SEQUENCE "public"."sections_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."sections_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."site_actions_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."site_actions_id_seq";
CREATE SEQUENCE "public"."site_actions_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."site_actions_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."sites_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sites_id_seq";
CREATE SEQUENCE "public"."sites_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."sites_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."staff_members_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."staff_members_id_seq";
CREATE SEQUENCE "public"."staff_members_id_seq" INCREMENT 1 START 1 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."staff_members_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."students_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."students_id_seq";
CREATE SEQUENCE "public"."students_id_seq" INCREMENT 1 START 2 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."students_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Sequence structure for "public"."users_id_seq"
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."users_id_seq";
CREATE SEQUENCE "public"."users_id_seq" INCREMENT 1 START 3 MAXVALUE 9223372036854775807 MINVALUE 1 CACHE 1;
ALTER TABLE "public"."users_id_seq" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."schema_migrations"
-- ----------------------------
DROP TABLE IF EXISTS "public"."schema_migrations";
CREATE TABLE "public"."schema_migrations" (
	"version" varchar(255) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."schema_migrations" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."schema_migrations"
-- ----------------------------
BEGIN;
INSERT INTO "public"."schema_migrations" VALUES ('20140902210605');
COMMIT;

-- ----------------------------
--  Table structure for "public"."site_actions"
-- ----------------------------
DROP TABLE IF EXISTS "public"."site_actions";
CREATE TABLE "public"."site_actions" (
	"id" int4 NOT NULL DEFAULT nextval('site_actions_id_seq'::regclass),
	"action_type" varchar(255) NOT NULL,
	"url_pattern" varchar(4096) NOT NULL,
	"css_selector" varchar(255),
	"site_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."site_actions" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."site_actions"
-- ----------------------------
BEGIN;
INSERT INTO "public"."site_actions" VALUES ('1', 'CLICK', 'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?', null, '1', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('2', 'PAGEVIEW', 'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?', null, '1', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('3', 'CLICK', 'http(s)?://(.*\.)?techcrunch\.com(/\S*)?', null, '2', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('4', 'PAGEVIEW', 'http(s)?://(.*\.)?techcrunch\.com(/\S*)?', null, '2', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('5', 'CLICK', 'http(s)?://(.*\.)?gizmodo\.com(/\S*)?', null, '3', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('6', 'PAGEVIEW', 'http(s)?://(.*\.)?gizmodo\.com(/\S*)?', null, '3', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('7', 'CLICK', 'http(s)?://(.*\.)?npr\.org(/\S*)?', null, '4', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('8', 'PAGEVIEW', 'http(s)?://(.*\.)?npr\.org(/\S*)?', null, '4', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('9', 'CLICK', 'http(s)?://(.*\.)?nytimes\.com(/\S*)?', null, '5', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('10', 'PAGEVIEW', 'http(s)?://(.*\.)?nytimes\.com(/\S*)?', null, '5', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('11', 'CLICK', 'http(s)?://(.*\.)?arstechnica\.com(/\S*)?', null, '6', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('12', 'PAGEVIEW', 'http(s)?://(.*\.)?arstechnica\.com(/\S*)?', null, '6', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('13', 'CLICK', 'http(s)?://(.*\.)?theverge\.com(/\S*)?', null, '7', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('14', 'PAGEVIEW', 'http(s)?://(.*\.)?theverge\.com(/\S*)?', null, '7', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('15', 'CLICK', 'http(s)?://(.*\.)?gigaom\.com(/\S*)?', null, '8', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('16', 'PAGEVIEW', 'http(s)?://(.*\.)?gigaom\.com(/\S*)?', null, '8', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('17', 'CLICK', 'http(s)?://(.*\.)?boingboing\.net(/\S*)?', null, '9', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('18', 'PAGEVIEW', 'http(s)?://(.*\.)?boingboing\.net(/\S*)?', null, '9', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('19', 'CLICK', 'http(s)?://(.*\.)?washingtonpost\.com(/\S*)?', null, '10', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('20', 'PAGEVIEW', 'http(s)?://(.*\.)?washingtonpost\.com(/\S*)?', null, '10', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('21', 'CLICK', 'http(s)?://(.*\.)?stackoverflow\.com(/\S*)?', null, '11', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."site_actions" VALUES ('22', 'PAGEVIEW', 'http(s)?://(.*\.)?stackoverflow\.com(/\S*)?', null, '11', '0014-09-17 20:47:00', '0014-09-17 20:47:00');
COMMIT;

-- ----------------------------
--  Table structure for "public"."api_keys"
-- ----------------------------
DROP TABLE IF EXISTS "public"."api_keys";
CREATE TABLE "public"."api_keys" (
	"id" int4 NOT NULL DEFAULT nextval('api_keys_id_seq'::regclass),
	"key" varchar(255) NOT NULL,
	"user_id" int4 NOT NULL,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."api_keys" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."organizations"
-- ----------------------------
DROP TABLE IF EXISTS "public"."organizations";
CREATE TABLE "public"."organizations" (
	"id" int4 NOT NULL DEFAULT nextval('organizations_id_seq'::regclass),
	"org_api_key" varchar(255)
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."organizations" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."raw_messages"
-- ----------------------------
DROP TABLE IF EXISTS "public"."raw_messages";
CREATE TABLE "public"."raw_messages" (
	"id" int4 NOT NULL DEFAULT nextval('raw_messages_id_seq'::regclass),
	"api_key" varchar(255),
	"user_id" int4,
	"org_api_key" varchar(255),
	"username" varchar(255),
	"page_title" varchar(255),
	"site_uuid" uuid,
	"verb" varchar(255),
	"action" json,
	"url" varchar(4096),
	"captured_at" timestamp(6) NULL,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."raw_messages" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."raw_message_logs"
-- ----------------------------
DROP TABLE IF EXISTS "public"."raw_message_logs";
CREATE TABLE "public"."raw_message_logs" (
	"id" int4 NOT NULL DEFAULT nextval('raw_message_logs_id_seq'::regclass),
	"action" varchar(255),
	"raw_message_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."raw_message_logs" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."sites"
-- ----------------------------
DROP TABLE IF EXISTS "public"."sites";
CREATE TABLE "public"."sites" (
	"id" int4 NOT NULL DEFAULT nextval('sites_id_seq'::regclass),
	"url" varchar(4096) NOT NULL,
	"display_name" varchar(255),
	"site_uuid" uuid NOT NULL,
	"logo_url_small" varchar(4096),
	"logo_url_large" varchar(4096),
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."sites" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."sites"
-- ----------------------------
BEGIN;
INSERT INTO "public"."sites" VALUES ('1', 'http://slashdot.org', 'Slashdot', '27c74d4d-a078-9bd3-557b-0a82aea8c759', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('2', 'http://techcrunch.com', 'TechCrunch', '8c63e4e9-beb9-0b0a-9ca9-2e896be646da', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('3', 'http://gizmodo.com', 'Gizmodo', '42e735bb-fcc0-0757-ceb0-3b632000a02a', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('4', 'http://npr.org', 'NPR', '9688ad74-6cea-4c43-7212-d0ac2754e787', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('5', 'http://nytimes.com', 'New York Times', '4fe2a48a-3c9c-ca2f-7aac-bc429d084754', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('6', 'http://arstechnica.com/', 'Ars Technica', '52a7dafb-049f-85c0-4789-2807e1f51a1a', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('7', 'http://theverge.com', 'The Verge', 'b49cf44e-0129-3649-82a8-e98a54067539', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('8', 'http://gigaom.com', 'Gigaom', '6656dd67-a96a-23bd-7e2e-508e30e9705b', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('9', 'http://boingboing.net', 'Boing Boing', '2c314552-cef2-88e2-1cbd-3f1490016b62', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('10', 'http://washingtonpost.com', 'Washington Post', '2c9f88c0-4887-0e83-7bc3-ec1e5090419d', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
INSERT INTO "public"."sites" VALUES ('11', 'http://stackoverflow.com', 'Stack Overflow', '4f5978b7-2bf7-f778-6298-86a575375ba6', null, null, '0014-09-17 20:47:00', '0014-09-17 20:47:00');
COMMIT;

-- ----------------------------
--  Table structure for "public"."approved_sites"
-- ----------------------------
DROP TABLE IF EXISTS "public"."approved_sites";
CREATE TABLE "public"."approved_sites" (
	"id" int4 NOT NULL DEFAULT nextval('approved_sites_id_seq'::regclass),
	"site_id" int4 NOT NULL,
	"district_id" int4,
	"school_id" int4,
	"section_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."approved_sites" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."approved_sites"
-- ----------------------------
BEGIN;
INSERT INTO "public"."approved_sites" VALUES ('1', '1', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('2', '2', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('3', '3', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('4', '4', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('5', '5', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('6', '6', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('7', '7', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('8', '8', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('9', '9', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('10', '10', '1', null, null, null, null);
INSERT INTO "public"."approved_sites" VALUES ('11', '11', '1', null, null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."pages"
-- ----------------------------
DROP TABLE IF EXISTS "public"."pages";
CREATE TABLE "public"."pages" (
	"id" int4 NOT NULL DEFAULT nextval('pages_id_seq'::regclass),
	"url" varchar(4096) NOT NULL,
	"display_name" varchar(255),
	"site_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."pages" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."pages"
-- ----------------------------
BEGIN;
INSERT INTO "public"."pages" VALUES ('1', 'http://arstechnica.com/science/2014/10/the-oceans-got-hotter-than-we-thought-but-the-heat-stayed-shallow/', 'The oceans got hotter than we thought, but the heat stayed shallow', '6', null, null);
INSERT INTO "public"."pages" VALUES ('3', 'http://arstechnica.com/security/2014/10/adobes-e-book-reader-sends-your-reading-logs-back-to-adobe-in-plain-text/', 'Adobe’s e-book reader sends your reading logs back to Adobe—in plain text', '6', null, null);
INSERT INTO "public"."pages" VALUES ('2', 'http://arstechnica.com/information-technology/2014/10/markdown-throwdown-what-happens-when-foss-software-gets-corporate-backing/', 'Markdown throwdown: what happens when FOSS software gets corporate backing?', '6', null, null);
INSERT INTO "public"."pages" VALUES ('4', 'http://arstechnica.com/tech-policy/2014/10/lawsuit-reveals-samsung-paid-microsoft-1-billion-a-year-for-android-patents/', 'Lawsuit reveals Samsung paid Microsoft $1 billion a year for Android patents', '6', null, null);
INSERT INTO "public"."pages" VALUES ('5', 'http://arstechnica.com/information-technology/2014/10/chrome-surges-windows-8-x-falls-in-september/', 'Chrome surges, Windows 8.x falls in September', '6', null, null);
INSERT INTO "public"."pages" VALUES ('6', 'http://www.nytimes.com/2014/10/08/us/politics/in-this-election-obamas-party-benches-him.html?hp&action=click&pgtype=Homepage&version=HpSum&module=first-column-region&region=top-news&WT.nav=top-news', 'President’s Own Party Benches Him in This Election', '5', null, null);
INSERT INTO "public"."pages" VALUES ('7', 'http://www.nytimes.com/2014/10/08/business/economy/why-federal-aid-for-higher-education-is-missing-the-mark.html?hp&action=click&pgtype=Homepage&version=HpSum&module=second-column-region&region=top-news&WT.nav=top-news', 'Why Aid for College Is Missing the Mark', '5', null, null);
INSERT INTO "public"."pages" VALUES ('8', 'http://www.nytimes.com/2014/10/08/business/30000-lose-health-care-coverage-at-walmart.html?hp&action=click&pgtype=Homepage&version=HpHeadline&module=second-column-region&region=top-news&WT.nav=top-news', '30,000 Lose Health Care Coverage at Walmart', '5', null, null);
INSERT INTO "public"."pages" VALUES ('9', 'http://www.nytimes.com/2014/10/07/business/microsoft-and-other-firms-pledge-to-protect-student-data.html?ref=technology', 'Microsoft and Other Firms Pledge to Protect Student Data', '5', null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."page_visits"
-- ----------------------------
DROP TABLE IF EXISTS "public"."page_visits";
CREATE TABLE "public"."page_visits" (
	"id" int4 NOT NULL DEFAULT nextval('page_visits_id_seq'::regclass),
	"date_visited" timestamp(6) NULL,
	"time_active" interval(6),
	"user_id" int4,
	"page_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."page_visits" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."page_visits"
-- ----------------------------
BEGIN;
INSERT INTO "public"."page_visits" VALUES ('1', '2014-10-08 00:00:00', '01:32:00', '1', '6');
INSERT INTO "public"."page_visits" VALUES ('2', '2014-10-08 00:00:00', '02:30:00', '1', '7');
INSERT INTO "public"."page_visits" VALUES ('3', '2014-10-08 00:00:00', '00:57:00', '1', '8');
INSERT INTO "public"."page_visits" VALUES ('4', '2014-10-08 00:00:00', '00:30:03', '1', '9');
INSERT INTO "public"."page_visits" VALUES ('5', '2014-10-08 00:00:00', '04:54:00', '2', '1');
INSERT INTO "public"."page_visits" VALUES ('6', '2014-10-08 00:00:00', '03:54:00', '2', '2');
INSERT INTO "public"."page_visits" VALUES ('7', '2014-10-08 00:00:00', '04:34:00', '2', '3');
INSERT INTO "public"."page_visits" VALUES ('8', '2014-10-08 00:00:00', '03:23:00', '2', '4');
INSERT INTO "public"."page_visits" VALUES ('9', '2014-10-08 00:00:00', '01:43:00', '2', '5');
COMMIT;

-- ----------------------------
--  Table structure for "public"."page_clicks"
-- ----------------------------
DROP TABLE IF EXISTS "public"."page_clicks";
CREATE TABLE "public"."page_clicks" (
	"id" int4 NOT NULL DEFAULT nextval('page_clicks_id_seq'::regclass),
	"date_visited" timestamp(6) NULL,
	"url_visited" varchar(4096),
	"user_id" int4,
	"page_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."page_clicks" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."districts"
-- ----------------------------
DROP TABLE IF EXISTS "public"."districts";
CREATE TABLE "public"."districts" (
	"id" int4 NOT NULL DEFAULT nextval('districts_id_seq'::regclass),
	"state_id" varchar(255),
	"nces_id" varchar(255),
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"name" varchar(255) NOT NULL,
	"address" varchar(255),
	"city" varchar(255),
	"state" varchar(255),
	"phone" varchar(255),
	"grade_low" varchar(255),
	"grade_high" varchar(255),
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."districts" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."districts"
-- ----------------------------
BEGIN;
INSERT INTO "public"."districts" VALUES ('1', '100', '10000000000', 'DISTRICT1', null, 'Acme District', null, null, null, null, 'K', '12', null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."schools"
-- ----------------------------
DROP TABLE IF EXISTS "public"."schools";
CREATE TABLE "public"."schools" (
	"id" int4 NOT NULL DEFAULT nextval('schools_id_seq'::regclass),
	"state_id" varchar(255),
	"nces_id" varchar(255),
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"name" varchar(255) NOT NULL,
	"address" varchar(255),
	"city" varchar(255),
	"state" varchar(255),
	"phone" varchar(255),
	"grade_low" varchar(255),
	"grade_high" varchar(255),
	"district_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."schools" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."schools"
-- ----------------------------
BEGIN;
INSERT INTO "public"."schools" VALUES ('1', '1000', '10000000', 'SCHOOL1', null, 'Acme School', null, null, null, null, 'K', '12', '1', null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."courses"
-- ----------------------------
DROP TABLE IF EXISTS "public"."courses";
CREATE TABLE "public"."courses" (
	"id" int4 NOT NULL DEFAULT nextval('courses_id_seq'::regclass),
	"course_code" varchar(255),
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"name" varchar(255) NOT NULL,
	"description" varchar(255),
	"subject_area" varchar(255),
	"high_school_requirement" bool,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."courses" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."course_offerings"
-- ----------------------------
DROP TABLE IF EXISTS "public"."course_offerings";
CREATE TABLE "public"."course_offerings" (
	"id" int4 NOT NULL DEFAULT nextval('course_offerings_id_seq'::regclass),
	"course_id" int4 NOT NULL,
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"date_start" date,
	"date_end" date,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."course_offerings" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."sections"
-- ----------------------------
DROP TABLE IF EXISTS "public"."sections";
CREATE TABLE "public"."sections" (
	"id" int4 NOT NULL DEFAULT nextval('sections_id_seq'::regclass),
	"section_code" varchar(255),
	"course_offering_id" int4,
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"name" varchar(255) NOT NULL,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."sections" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."sections"
-- ----------------------------
BEGIN;
INSERT INTO "public"."sections" VALUES ('1', 'USHIST01', null, null, null, 'Modern US History', null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."section_users"
-- ----------------------------
DROP TABLE IF EXISTS "public"."section_users";
CREATE TABLE "public"."section_users" (
	"id" int4 NOT NULL DEFAULT nextval('section_users_id_seq'::regclass),
	"user_type" varchar(255),
	"section_id" int4,
	"user_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."section_users" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."section_users"
-- ----------------------------
BEGIN;
INSERT INTO "public"."section_users" VALUES ('1', 'TEACHER', '1', '3');
INSERT INTO "public"."section_users" VALUES ('2', 'STUDENT', '1', '1');
INSERT INTO "public"."section_users" VALUES ('3', 'STUDENT', '1', '2');
COMMIT;

-- ----------------------------
--  Table structure for "public"."users"
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
	"id" int4 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
	"first_name" varchar(255) NOT NULL,
	"middle_name" varchar(255),
	"last_name" varchar(255) NOT NULL,
	"gender" varchar(255),
	"username" varchar(255) NOT NULL,
	"password_digest" varchar(255),
	"date_of_birth" date,
	"school_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."users" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."users"
-- ----------------------------
BEGIN;
INSERT INTO "public"."users" VALUES ('1', 'Jason', '', 'Hoekstra', '', 'jason', '$2a$10$IeZaG5lQ56q2IqTdcmba0.vny910JK8EXTexoJKM4nQO50s3KqJu2', null, null, null, null);
INSERT INTO "public"."users" VALUES ('2', 'Steve', '', 'Midgley', '', 'stevemidgley', '$2a$10$bEGzXak92.vMA0en7.Lq8eC4FfhDuO/K8XTaw2kvan.H0NslpWdUu', null, null, null, null);
INSERT INTO "public"."users" VALUES ('3', 'Jane', null, 'Jones', null, 'janejones', '$2a$10$IeZaG5lQ56q2IqTdcmba0.vny910JK8EXTexoJKM4nQO50s3KqJu2', null, null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."emails"
-- ----------------------------
DROP TABLE IF EXISTS "public"."emails";
CREATE TABLE "public"."emails" (
	"id" int4 NOT NULL DEFAULT nextval('emails_id_seq'::regclass),
	"email" varchar(255),
	"primary" bool,
	"user_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."emails" OWNER TO "lt_dbo";

-- ----------------------------
--  Table structure for "public"."students"
-- ----------------------------
DROP TABLE IF EXISTS "public"."students";
CREATE TABLE "public"."students" (
	"id" int4 NOT NULL DEFAULT nextval('students_id_seq'::regclass),
	"state_id" varchar(255),
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"grade_level" varchar(255),
	"user_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."students" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."students"
-- ----------------------------
BEGIN;
INSERT INTO "public"."students" VALUES ('1', '400', 'JASONH1', null, '12', '1', null, null);
INSERT INTO "public"."students" VALUES ('2', '401', 'STEVEM1', null, '12', '2', null, null);
COMMIT;

-- ----------------------------
--  Table structure for "public"."staff_members"
-- ----------------------------
DROP TABLE IF EXISTS "public"."staff_members";
CREATE TABLE "public"."staff_members" (
	"id" int4 NOT NULL DEFAULT nextval('staff_members_id_seq'::regclass),
	"state_id" varchar(255),
	"sis_id" varchar(255),
	"other_id" varchar(255),
	"staff_member_type" varchar(255) NOT NULL,
	"user_id" int4,
	"created_at" timestamp(6) NULL,
	"updated_at" timestamp(6) NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."staff_members" OWNER TO "lt_dbo";

-- ----------------------------
--  Records of "public"."staff_members"
-- ----------------------------
BEGIN;
INSERT INTO "public"."staff_members" VALUES ('1', '500', 'JJONES1', null, 'TEACHER', '3', null, null);
COMMIT;


-- ----------------------------
--  Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."api_keys_id_seq" OWNED BY "api_keys"."id";
ALTER SEQUENCE "public"."approved_sites_id_seq" OWNED BY "approved_sites"."id";
ALTER SEQUENCE "public"."course_offerings_id_seq" OWNED BY "course_offerings"."id";
ALTER SEQUENCE "public"."courses_id_seq" OWNED BY "courses"."id";
ALTER SEQUENCE "public"."districts_id_seq" OWNED BY "districts"."id";
ALTER SEQUENCE "public"."emails_id_seq" OWNED BY "emails"."id";
ALTER SEQUENCE "public"."organizations_id_seq" OWNED BY "organizations"."id";
ALTER SEQUENCE "public"."page_clicks_id_seq" OWNED BY "page_clicks"."id";
ALTER SEQUENCE "public"."page_visits_id_seq" OWNED BY "page_visits"."id";
ALTER SEQUENCE "public"."pages_id_seq" OWNED BY "pages"."id";
ALTER SEQUENCE "public"."raw_message_logs_id_seq" OWNED BY "raw_message_logs"."id";
ALTER SEQUENCE "public"."raw_messages_id_seq" OWNED BY "raw_messages"."id";
ALTER SEQUENCE "public"."schools_id_seq" OWNED BY "schools"."id";
ALTER SEQUENCE "public"."section_users_id_seq" OWNED BY "section_users"."id";
ALTER SEQUENCE "public"."sections_id_seq" OWNED BY "sections"."id";
ALTER SEQUENCE "public"."site_actions_id_seq" OWNED BY "site_actions"."id";
ALTER SEQUENCE "public"."sites_id_seq" OWNED BY "sites"."id";
ALTER SEQUENCE "public"."staff_members_id_seq" OWNED BY "staff_members"."id";
ALTER SEQUENCE "public"."students_id_seq" OWNED BY "students"."id";
ALTER SEQUENCE "public"."users_id_seq" OWNED BY "users"."id";
-- ----------------------------
--  Indexes structure for table "public"."schema_migrations"
-- ----------------------------
CREATE UNIQUE INDEX "unique_schema_migrations" ON "public"."schema_migrations" USING btree("version" ASC NULLS LAST);

-- ----------------------------
--  Primary key structure for table "public"."site_actions"
-- ----------------------------
ALTER TABLE "public"."site_actions" ADD CONSTRAINT "site_actions_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."api_keys"
-- ----------------------------
ALTER TABLE "public"."api_keys" ADD CONSTRAINT "api_keys_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."organizations"
-- ----------------------------
ALTER TABLE "public"."organizations" ADD CONSTRAINT "organizations_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."raw_messages"
-- ----------------------------
ALTER TABLE "public"."raw_messages" ADD CONSTRAINT "raw_messages_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."raw_message_logs"
-- ----------------------------
ALTER TABLE "public"."raw_message_logs" ADD CONSTRAINT "raw_message_logs_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."sites"
-- ----------------------------
ALTER TABLE "public"."sites" ADD CONSTRAINT "sites_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Indexes structure for table "public"."sites"
-- ----------------------------
CREATE UNIQUE INDEX "index_sites_on_url" ON "public"."sites" USING btree(url ASC NULLS LAST);

-- ----------------------------
--  Primary key structure for table "public"."approved_sites"
-- ----------------------------
ALTER TABLE "public"."approved_sites" ADD CONSTRAINT "approved_sites_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Indexes structure for table "public"."approved_sites"
-- ----------------------------
CREATE INDEX "index_approved_sites_on_site_id" ON "public"."approved_sites" USING btree(site_id ASC NULLS LAST);

-- ----------------------------
--  Primary key structure for table "public"."pages"
-- ----------------------------
ALTER TABLE "public"."pages" ADD CONSTRAINT "pages_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Indexes structure for table "public"."pages"
-- ----------------------------
CREATE UNIQUE INDEX "index_pages_on_url" ON "public"."pages" USING btree(url ASC NULLS LAST);

-- ----------------------------
--  Primary key structure for table "public"."page_visits"
-- ----------------------------
ALTER TABLE "public"."page_visits" ADD CONSTRAINT "page_visits_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."page_clicks"
-- ----------------------------
ALTER TABLE "public"."page_clicks" ADD CONSTRAINT "page_clicks_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."districts"
-- ----------------------------
ALTER TABLE "public"."districts" ADD CONSTRAINT "districts_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."schools"
-- ----------------------------
ALTER TABLE "public"."schools" ADD CONSTRAINT "schools_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."courses"
-- ----------------------------
ALTER TABLE "public"."courses" ADD CONSTRAINT "courses_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."course_offerings"
-- ----------------------------
ALTER TABLE "public"."course_offerings" ADD CONSTRAINT "course_offerings_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."sections"
-- ----------------------------
ALTER TABLE "public"."sections" ADD CONSTRAINT "sections_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."section_users"
-- ----------------------------
ALTER TABLE "public"."section_users" ADD CONSTRAINT "section_users_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."users"
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Indexes structure for table "public"."users"
-- ----------------------------
CREATE UNIQUE INDEX "index_users_on_username" ON "public"."users" USING btree(username ASC NULLS LAST);

-- ----------------------------
--  Primary key structure for table "public"."emails"
-- ----------------------------
ALTER TABLE "public"."emails" ADD CONSTRAINT "emails_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."students"
-- ----------------------------
ALTER TABLE "public"."students" ADD CONSTRAINT "students_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table "public"."staff_members"
-- ----------------------------
ALTER TABLE "public"."staff_members" ADD CONSTRAINT "staff_members_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

