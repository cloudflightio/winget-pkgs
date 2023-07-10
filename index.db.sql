BEGIN TRANSACTION;
DROP TABLE IF EXISTS "metadata";
CREATE TABLE IF NOT EXISTS "metadata" (
	"name"	TEXT NOT NULL,
	"value"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
DROP TABLE IF EXISTS "ids";
CREATE TABLE IF NOT EXISTS "ids" (
	"rowid"	INTEGER,
	"id"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "names";
CREATE TABLE IF NOT EXISTS "names" (
	"rowid"	INTEGER,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "monikers";
CREATE TABLE IF NOT EXISTS "monikers" (
	"rowid"	INTEGER,
	"moniker"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "versions";
CREATE TABLE IF NOT EXISTS "versions" (
	"rowid"	INTEGER,
	"version"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "channels";
CREATE TABLE IF NOT EXISTS "channels" (
	"rowid"	INTEGER,
	"channel"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "pathparts";
CREATE TABLE IF NOT EXISTS "pathparts" (
	"rowid"	INTEGER,
	"parent"	INT64,
	"pathpart"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "manifest";
CREATE TABLE IF NOT EXISTS "manifest" (
	"rowid"	INTEGER,
	"id"	INT64 NOT NULL,
	"name"	INT64 NOT NULL,
	"moniker"	INT64 NOT NULL,
	"version"	INT64 NOT NULL,
	"channel"	INT64 NOT NULL,
	"pathpart"	INT64 NOT NULL,
	"arp_min_version"	INT64,
	"arp_max_version"	INT64,
	"hash"	BLOB,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "tags";
CREATE TABLE IF NOT EXISTS "tags" (
	"rowid"	INTEGER,
	"tag"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "tags_map";
CREATE TABLE IF NOT EXISTS "tags_map" (
	"manifest"	INT64 NOT NULL,
	"tag"	INT64 NOT NULL
);
DROP TABLE IF EXISTS "commands";
CREATE TABLE IF NOT EXISTS "commands" (
	"rowid"	INTEGER,
	"command"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "commands_map";
CREATE TABLE IF NOT EXISTS "commands_map" (
	"manifest"	INT64 NOT NULL,
	"command"	INT64 NOT NULL
);
DROP TABLE IF EXISTS "pfns";
CREATE TABLE IF NOT EXISTS "pfns" (
	"rowid"	INTEGER,
	"pfn"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "pfns_map";
CREATE TABLE IF NOT EXISTS "pfns_map" (
	"manifest"	INT64 NOT NULL,
	"pfn"	INT64 NOT NULL
);
DROP TABLE IF EXISTS "productcodes";
CREATE TABLE IF NOT EXISTS "productcodes" (
	"rowid"	INTEGER,
	"productcode"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "productcodes_map";
CREATE TABLE IF NOT EXISTS "productcodes_map" (
	"manifest"	INT64 NOT NULL,
	"productcode"	INT64 NOT NULL
);
DROP TABLE IF EXISTS "norm_names";
CREATE TABLE IF NOT EXISTS "norm_names" (
	"rowid"	INTEGER,
	"norm_name"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "norm_names_map";
CREATE TABLE IF NOT EXISTS "norm_names_map" (
	"manifest"	INT64 NOT NULL,
	"norm_name"	INT64 NOT NULL
);
DROP TABLE IF EXISTS "norm_publishers";
CREATE TABLE IF NOT EXISTS "norm_publishers" (
	"rowid"	INTEGER,
	"norm_publisher"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP TABLE IF EXISTS "norm_publishers_map";
CREATE TABLE IF NOT EXISTS "norm_publishers_map" (
	"manifest"	INT64 NOT NULL,
	"norm_publisher"	INT64 NOT NULL
);
DROP INDEX IF EXISTS "upgradecodes";
CREATE TABLE IF NOT EXISTS "upgradecodes" (
	"rowid"	INTEGER,
	"upgradecode"	TEXT NOT NULL,
	PRIMARY KEY("rowid")
);
DROP INDEX IF EXISTS "upgradecodes_map";
CREATE TABLE IF NOT EXISTS "upgradecodes_map" (
	"manifest"	INT64 NOT NULL,
	"upgradecode"	INT64 NOT NULL
);
DROP INDEX IF EXISTS "manifest_id_index";
CREATE INDEX IF NOT EXISTS "manifest_id_index" ON "manifest" (
	"id"
);
DROP INDEX IF EXISTS "manifest_name_index";
CREATE INDEX IF NOT EXISTS "manifest_name_index" ON "manifest" (
	"name"
);
DROP INDEX IF EXISTS "manifest_moniker_index";
CREATE INDEX IF NOT EXISTS "manifest_moniker_index" ON "manifest" (
	"moniker"
);
DROP INDEX IF EXISTS "tags_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "tags_map_pkindex" ON "tags_map" (
	"tag",
	"manifest"
);
DROP INDEX IF EXISTS "commands_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "commands_map_pkindex" ON "commands_map" (
	"command",
	"manifest"
);
DROP INDEX IF EXISTS "pfns_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "pfns_pkindex" ON "pfns" (
	"pfn"
);
DROP INDEX IF EXISTS "pfns_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "pfns_map_pkindex" ON "pfns_map" (
	"pfn",
	"manifest"
);
DROP INDEX IF EXISTS "pfns_map_index";
CREATE INDEX IF NOT EXISTS "pfns_map_index" ON "pfns_map" (
	"manifest"
);
DROP INDEX IF EXISTS "productcodes_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "productcodes_pkindex" ON "productcodes" (
	"productcode"
);
DROP INDEX IF EXISTS "productcodes_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "productcodes_map_pkindex" ON "productcodes_map" (
	"productcode",
	"manifest"
);
DROP INDEX IF EXISTS "productcodes_map_index";
CREATE INDEX IF NOT EXISTS "productcodes_map_index" ON "productcodes_map" (
	"manifest"
);
DROP INDEX IF EXISTS "norm_names_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "norm_names_pkindex" ON "norm_names" (
	"norm_name"
);
DROP INDEX IF EXISTS "norm_names_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "norm_names_map_pkindex" ON "norm_names_map" (
	"norm_name",
	"manifest"
);
DROP INDEX IF EXISTS "norm_names_map_index";
CREATE INDEX IF NOT EXISTS "norm_names_map_index" ON "norm_names_map" (
	"manifest"
);
DROP INDEX IF EXISTS "norm_publishers_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "norm_publishers_pkindex" ON "norm_publishers" (
	"norm_publisher"
);
DROP INDEX IF EXISTS "norm_publishers_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "norm_publishers_map_pkindex" ON "norm_publishers_map" (
	"norm_publisher",
	"manifest"
);
DROP INDEX IF EXISTS "norm_publishers_map_index";
CREATE INDEX IF NOT EXISTS "norm_publishers_map_index" ON "norm_publishers_map" (
	"manifest"
);
DROP INDEX IF EXISTS "upgradecodes_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "upgradecodes_pkindex" ON "upgradecodes" (
	"upgradecode"
);
DROP INDEX IF EXISTS "upgradecodes_map_pkindex";
CREATE UNIQUE INDEX IF NOT EXISTS "upgradecodes_map_pkindex" ON "upgradecodes_map" (
	"upgradecode",
	"manifest"
);
DROP INDEX IF EXISTS "upgradecodes_map_index";
CREATE INDEX IF NOT EXISTS "upgradecodes_map_index" ON "upgradecodes_map" (
	"manifest"
);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO "metadata" VALUES ('majorVersion','1');
INSERT INTO "metadata" VALUES ('minorVersion','6');
INSERT INTO "metadata" VALUES ('lastwritetime','1641996215');
INSERT INTO "channels" VALUES (1,'');
INSERT INTO "versions" VALUES (1,'');
COMMIT;
