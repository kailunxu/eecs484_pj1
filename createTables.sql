-- cannot befriend oneself!
-- not null usage
-- 
SET AUTOCOMMIT OFF;

CREATE TABLE USERS(
    USER_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(100) NOT NULL,
    LAST_NAME VARCHAR2(100) NOT NULL,
    YEAR_OF_BIRTH INTEGER,
    MONTH_OF_BIRTH INTEGER,
    DAY_OF_BIRTH INTEGER,
    GENDER VARCHAR2(100)
);

CREATE TABLE FRIENDS(
    USER1_ID NUMBER NOT NULL,
    USER2_ID NUMBER NOT NULL,
    PRIMARY KEY (USER1_ID, USER2_ID),
    FOREIGN KEY (USER1_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (USER2_ID) REFERENCES USERS(USER_ID),
    CHECK (USER1_ID != USER2_ID)
);

CREATE TRIGGER order_friends_pairs
    BEFORE INSERT ON FRIENDS
    FOR EACH ROW
        DECLARE temp NUMBER;
        BEGIN
            IF :NEW.USER1_ID > :NEW.USER2_ID THEN
                temp := :NEW.USER2_ID;
                :NEW.USER2_ID := :NEW.USER1_ID;
                :NEW.USER1_ID := temp;
            END IF;
        END;
/

CREATE TABLE CITIES(
    CITY_ID INTEGER PRIMARY KEY,
    CITY_NAME VARCHAR2(100) NOT NULL,
    STATE_NAME VARCHAR2(100) NOT NULL,
    COUNTRY_NAME VARCHAR2(100) NOT NULL,
    UNIQUE (CITY_NAME, STATE_NAME, COUNTRY_NAME)
);

CREATE TABLE USER_CURRENT_CITIES(
    USER_ID NUMBER NOT NULL,
    CURRENT_CITY_ID INTEGER NOT NULL,
    PRIMARY KEY (USER_ID, CURRENT_CITY_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (CURRENT_CITY_ID) REFERENCES CITIES(CITY_ID),
    UNIQUE (USER_ID)
);

CREATE TABLE USER_HOMETOWN_CITIES(
    USER_ID NUMBER NOT NULL,
    HOMETOWN_CITY_ID INTEGER NOT NULL,
    PRIMARY KEY (USER_ID, HOMETOWN_CITY_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (HOMETOWN_CITY_ID) REFERENCES CITIES(CITY_ID),
    UNIQUE (USER_ID)
);

CREATE TABLE MESSAGES(
    MESSAGE_ID NUMBER PRIMARY KEY,
    SENDER_ID NUMBER NOT NULL,
    RECEIVER_ID NUMBER NOT NULL,
    MESSAGE_CONTENT VARCHAR2(2000) NOT NULL,
    SENT_TIME TIMESTAMP NOT NULL,
    FOREIGN KEY (SENDER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (RECEIVER_ID) REFERENCES USERS(USER_ID)
);

CREATE TABLE PROGRAMS(
    PROGRAM_ID INTEGER PRIMARY KEY,
    INSTITUTION VARCHAR2(100) NOT NULL,
    CONCENTRATION VARCHAR2(100) NOT NULL,
    DEGREE VARCHAR2(100) NOT NULL,
    UNIQUE (INSTITUTION, CONCENTRATION, DEGREE)
);

CREATE TABLE EDUCATION(
    USER_ID NUMBER NOT NULL,
    PROGRAM_ID INTEGER NOT NULL,
    PROGRAM_YEAR INTEGER NOT NULL,
    PRIMARY KEY (USER_ID, PROGRAM_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (PROGRAM_ID) REFERENCES PROGRAMS(PROGRAM_ID)
);

CREATE TABLE USER_EVENTS(
    EVENT_ID NUMBER PRIMARY KEY,
    EVENT_CREATOR_ID NUMBER NOT NULL,
    EVENT_NAME VARCHAR2(100) NOT NULL,
    EVENT_TAGLINE VARCHAR2(100),
    EVENT_DESCRIPTION VARCHAR2(100),
    EVENT_HOST VARCHAR2(100),
    EVENT_TYPE VARCHAR2(100),
    EVENT_SUBTYPE VARCHAR2(100),
    EVENT_ADDRESS VARCHAR2(2000),
    EVENT_CITY_ID INTEGER NOT NULL,
    EVENT_START_TIME TIMESTAMP,
    EVENT_END_TIME TIMESTAMP,
    FOREIGN KEY (EVENT_CREATOR_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (EVENT_CITY_ID) REFERENCES CITIES(CITY_ID)
);

CREATE TABLE PARTICIPANTS(
    EVENT_ID NUMBER NOT NULL,
    USER_ID NUMBER NOT NULL,
    CONFIRMATION VARCHAR2(100) NOT NULL,
    PRIMARY KEY (USER_ID, EVENT_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (EVENT_ID) REFERENCES USER_EVENTS(EVENT_ID),
    CHECK (CONFIRMATION IN ('ATTENDING', 'UNSURE', 'DECLINES', 'NOT_REPLIED'))
);

CREATE TABLE ALBUMS(
    ALBUM_ID NUMBER PRIMARY KEY,
    ALBUM_OWNER_ID NUMBER NOT NULL,
    ALBUM_NAME VARCHAR2(100) NOT NULL,
    ALBUM_CREATED_TIME TIMESTAMP NOT NULL,
    ALBUM_MODIFIED_TIME TIMESTAMP,
    ALBUM_LINK VARCHAR2(100) NOT NULL,
    ALBUM_VISIBILITY VARCHAR2(100) NOT NULL,
    COVER_PHOTO_ID NUMBER NOT NULL,
    FOREIGN KEY (ALBUM_OWNER_ID) REFERENCES USERS(USER_ID),
    CHECK (ALBUM_VISIBILITY IN ('EVERYONE', 'FRIENDS', 'FRIENDS_OF_FRIENDS', 'MYSELF'))
);

CREATE TABLE PHOTOS(
    PHOTO_ID NUMBER PRIMARY KEY,
    ALBUM_ID NUMBER NOT NULL,
    PHOTO_CAPTION VARCHAR2(2000),
    PHOTO_CREATED_TIME TIMESTAMP NOT NULL,
    PHOTO_MODIFIED_TIME TIMESTAMP,
    PHOTO_LINK VARCHAR2(2000) NOT NULL,
    FOREIGN KEY (ALBUM_ID) REFERENCES ALBUMS(ALBUM_ID)
);

ALTER TABLE ALBUMS
    ADD CONSTRAINT hasCoverPhoto
    FOREIGN KEY (COVER_PHOTO_ID) REFERENCES PHOTOS(PHOTO_ID)
    INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE TAGS(
    TAG_PHOTO_ID NUMBER NOT NULL,
    TAG_SUBJECT_ID NUMBER NOT NULL,
    TAG_CREATED_TIME TIMESTAMP NOT NULL,
    TAG_X NUMBER NOT NULL,
    TAG_Y NUMBER NOT NULL,
    PRIMARY KEY (TAG_PHOTO_ID, TAG_SUBJECT_ID),
    FOREIGN KEY (TAG_PHOTO_ID) REFERENCES PHOTOS(PHOTO_ID),
    FOREIGN KEY (TAG_SUBJECT_ID) REFERENCES USERS(USER_ID)
);