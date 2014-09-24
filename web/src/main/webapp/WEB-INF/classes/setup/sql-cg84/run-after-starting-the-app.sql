

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
DELETE FROM catalogue.Address;
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


INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (1, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (1, 1);
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (2, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (2, 2);
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (3, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (3, 3);
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (4, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (4, 4);
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (5, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (5, 5);
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (6, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (6, 6);

INSERT INTO catalogue.Users (id, username, password, name, surname, profile, kind, organisation, security, authtype)
  VALUES  (10,'admintmp','46e44386069f7cf0d4f2a420b9a2383a612f316e2024b0fe84052b0b96c479a23e8a0be8b90fb8c2','admin','admin',0,'','','','');
INSERT INTO catalogue.Address (id, address, city, country, state, zip) VALUES  (10, '', '', '', '', '');
INSERT INTO catalogue.UserAddress (userid, addressid) VALUES  (10, 10);



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

UPDATE catalogue.settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 21
) WHERE NAME = 'system/server/host';
UPDATE catalogue.settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 22
) WHERE NAME = 'system/server/port';

UPDATE catalogue.settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 11
) WHERE NAME = 'system/site/name';
UPDATE catalogue.settings SET value = (
  SELECT value FROM catalogue.old_settings WHERE id = 13
) WHERE NAME = 'system/site/organization';


