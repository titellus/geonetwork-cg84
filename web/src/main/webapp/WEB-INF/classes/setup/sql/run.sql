
-- Backup old tables
CREATE TABLE catalogue.old_categories AS SELECT * FROM catalogue.categories;
CREATE TABLE catalogue.old_categoriesdes AS SELECT * FROM catalogue.categoriesdes;
CREATE TABLE catalogue.old_groups AS SELECT * FROM catalogue.groups;
CREATE TABLE catalogue.old_groupsdes AS SELECT * FROM catalogue.groupsdes;
CREATE TABLE catalogue.old_isolanguages AS SELECT * FROM catalogue.isolanguages;
CREATE TABLE catalogue.old_isolanguagesdes AS SELECT * FROM catalogue.isolanguagesdes;
CREATE TABLE catalogue.old_languages AS SELECT * FROM catalogue.languages;
CREATE TABLE catalogue.old_metadata AS SELECT * FROM catalogue.metadata;
CREATE TABLE catalogue.old_metadatacateg AS SELECT * FROM catalogue.metadatacateg;
CREATE TABLE catalogue.old_metadatarating AS SELECT * FROM catalogue.metadatarating;
CREATE TABLE catalogue.old_operationallowed AS SELECT * FROM catalogue.operationallowed;
CREATE TABLE catalogue.old_operations AS SELECT * FROM catalogue.operations;
CREATE TABLE catalogue.old_operationsdes AS SELECT * FROM catalogue.operationsdes;
CREATE TABLE catalogue.old_regions AS SELECT * FROM catalogue.regions;
CREATE TABLE catalogue.old_regionsdes AS SELECT * FROM catalogue.regionsdes;
CREATE TABLE catalogue.old_relations AS SELECT * FROM catalogue.relations;
CREATE TABLE catalogue.old_settings AS SELECT * FROM catalogue.settings;
CREATE TABLE catalogue.old_sources AS SELECT * FROM catalogue.sources;
CREATE TABLE catalogue.old_usergroups AS SELECT * FROM catalogue.usergroups;
CREATE TABLE catalogue.old_users AS SELECT * FROM catalogue.users;


-- Drop old tables
DROP TABLE catalogue.categoriesdes;
DROP TABLE catalogue.metadatacateg;
DROP TABLE catalogue.categories;
DROP TABLE catalogue.groupsdes;
DROP TABLE catalogue.operationallowed;
DROP TABLE catalogue.usergroups;
DROP TABLE catalogue.operationsdes;
DROP TABLE catalogue.operations;
DROP TABLE catalogue.isolanguagesdes;
DROP TABLE catalogue.metadatarating;
DROP TABLE catalogue.isolanguages;
DROP TABLE catalogue.relations;
DROP TABLE catalogue.regionsdes;
DROP TABLE catalogue.regions;
DROP TABLE catalogue.settings;
DROP TABLE catalogue.sources;
DROP TABLE catalogue.metadata;
DROP TABLE catalogue.languages;
DROP TABLE catalogue.groups;
DROP TABLE catalogue.users;


-- Startup the application to create new target structure - manually
-- Stop the application


-- Propagate old information to new structure
DELETE FROM catalogue.groupsdes;
DELETE FROM catalogue.groups;
INSERT INTO catalogue.groups (
  SELECT id, description, email, '', name, referrer, ''
  FROM catalogue.old_groups);
INSERT INTO catalogue.groupsdes (
  SELECT iddes, label, 'fre'
  FROM catalogue.old_groupsdes WHERE langid = 'fr');
INSERT INTO catalogue.groupsdes (
  SELECT iddes, label, 'eng'
  FROM catalogue.old_groupsdes WHERE langid = 'en');

DELETE FROM catalogue.categoriesdes;
DELETE FROM catalogue.categories;
INSERT INTO catalogue.categories (
  SELECT id, name
  FROM catalogue.old_categories);
INSERT INTO catalogue.categoriesdes (
  SELECT iddes, label, 'fre'
  FROM catalogue.old_categoriesdes WHERE langid = 'fr');
INSERT INTO catalogue.categoriesdes (
  SELECT iddes, label, 'eng'
  FROM catalogue.old_categoriesdes WHERE langid = 'en');





DELETE FROM catalogue.useraddress;
DELETE FROM catalogue.email;
DELETE FROM catalogue.users;

UPDATE catalogue.old_users SET profile = 0 WHERE profile = 'Administrator';
UPDATE catalogue.old_users SET profile = 1 WHERE profile = 'UserAdmin';
UPDATE catalogue.old_users SET profile = 2 WHERE profile = 'Reviewer';
UPDATE catalogue.old_users SET profile = 3 WHERE profile = 'Editor';
UPDATE catalogue.old_users SET profile = 4 WHERE profile = 'RegisteredUser';
UPDATE catalogue.old_users SET profile = 5 WHERE profile = 'Guest';
UPDATE catalogue.old_users SET profile = 6 WHERE profile = 'Monitor';

INSERT INTO catalogue.users (
  SELECT id, kind, null, name, organisation, profile::integer, null, null, password,
  'update_hash_required', username, username
  FROM catalogue.old_users);

INSERT INTO Address (id, address, city, country, state, zip) VALUES  (1, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (1, 1);
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (2, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (2, 2);
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (3, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (3, 3);
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (4, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (4, 4);
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (5, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (5, 5);
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (6, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (6, 6);

INSERT INTO Users (id, username, password, name, surname, profile, kind, organisation, security, authtype)
  VALUES  (10,'admintmp','46e44386069f7cf0d4f2a420b9a2383a612f316e2024b0fe84052b0b96c479a23e8a0be8b90fb8c2','admin','admin',0,'','','','');
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (10, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (10, 10);



INSERT INTO catalogue.usergroups (
  SELECT groupid, 3, userid FROM catalogue.old_usergroups
);




INSERT INTO catalogue.metadata (SELECT
  id,
  data,
  changedate,
  createdate,
  displayorder,
  null,
  popularity,
  rating,
  root,
  schemaid,
  title,
  istemplate,
  isharvested,
  harvesturi,
  harvestuuid,
  groupowner,
  owner,
  source,
  uuid
FROM catalogue.old_metadata);

INSERT INTO catalogue.operationallowed (
  SELECT groupid, metadataid, operationid FROM catalogue.old_operationallowed
);

UPDATE settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 21
) WHERE NAME = 'system/server/host';
UPDATE settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 22
) WHERE NAME = 'system/server/port';

UPDATE settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 11
) WHERE NAME = 'system/site/name';
UPDATE settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 13
) WHERE NAME = 'system/site/organization';



-- Démarrer l'application



-- Migrer les fiches du profil France vers l'ISO19139





-- Vérifier les paramètres
http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/system
-- Définir le logo du catalogue
http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/logo
-- Configurer le CSW
http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/csw



-- Drop backup tables

DROP TABLE catalogue.old_categories;
DROP TABLE catalogue.old_categoriesdes;
DROP TABLE catalogue.old_groups;
DROP TABLE catalogue.old_groupsdes;
DROP TABLE catalogue.old_isolanguages;
DROP TABLE catalogue.old_isolanguagesdes;
DROP TABLE catalogue.old_languages;
DROP TABLE catalogue.old_metadata;
DROP TABLE catalogue.old_metadatacateg;
DROP TABLE catalogue.old_metadatarating;
DROP TABLE catalogue.old_operationallowed;
DROP TABLE catalogue.old_operations;
DROP TABLE catalogue.old_operationsdes;
DROP TABLE catalogue.old_regions;
DROP TABLE catalogue.old_regionsdes;
DROP TABLE catalogue.old_relations;
DROP TABLE catalogue.old_settings;
DROP TABLE catalogue.old_sources;
DROP TABLE catalogue.old_usergroups;
DROP TABLE catalogue.old_users;
