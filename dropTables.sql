
DROP TRIGGER city_id_generator;
DROP SEQUENCE city_id_sequence;
DROP TRIGGER program_id_generator;
DROP SEQUENCE program_id_sequence;
DROP TABLE TAGS;
ALTER TABLE ALBUMS
  DROP CONSTRAINT hasCoverPhoto;
DROP TABLE PHOTOS;
DROP TABLE ALBUMS;
DROP TABLE PARTICIPANTS;
DROP TABLE USER_EVENTS;
DROP TABLE EDUCATION;
DROP TABLE PROGRAMS;
DROP TABLE MESSAGES;
DROP TABLE USER_HOMETOWN_CITIES;
DROP TABLE USER_CURRENT_CITIES;
DROP TABLE CITIES;
DROP TRIGGER order_friends_pairs;
DROP TABLE FRIENDS;
DROP TABLE USERS;