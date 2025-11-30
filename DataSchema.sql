CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_surname VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL
    CHECK (status IN ('online', 'offline'))
);

ALTER TABLE app_user
ADD CONSTRAINT chk_user_name_format
CHECK (
    user_name ~ '^[A-Za-zА-Яа-яЁёІіЇїЄєҐґ\\-\\s]{2,100}$'
);

CREATE TABLE air_quality (
    aq_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    level_numeric NUMERIC(6, 2) NOT NULL
    CHECK (level_numeric >= 0),
    measured_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id)
    REFERENCES app_user (user_id)
    ON DELETE SET NULL
);

CREATE TABLE notification (
    notif_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    notif_text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    notif_type VARCHAR(50) NOT NULL
    CHECK (notif_type IN ('повітря', 'безпека')),
    FOREIGN KEY (user_id)
    REFERENCES app_user (user_id)
    ON DELETE CASCADE
);

ALTER TABLE notification
ADD CONSTRAINT chk_notification_text
CHECK (
    CHAR_LENGTH(notif_text) > 0
    AND CHAR_LENGTH(notif_text) < 2000
);

CREATE TABLE recommendation (
    rec_id SERIAL PRIMARY KEY,
    notif_id INTEGER,
    rec_text TEXT NOT NULL,
    priority SMALLINT
    CHECK (priority >= 1 AND priority <= 5),
    FOREIGN KEY (notif_id)
    REFERENCES notification (notif_id)
    ON DELETE CASCADE
);

CREATE TABLE geo_point (
    geo_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    latitude NUMERIC(9, 6)
    CHECK (latitude >= -90 AND latitude <= 90),
    longitude NUMERIC(9, 6)
    CHECK (longitude >= -180 AND longitude <= 180),
    FOREIGN KEY (user_id)
    REFERENCES app_user (user_id)
    ON DELETE CASCADE
);

CREATE TABLE hazard (
    hazard_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    geo_id INTEGER,
    hazard_desc TEXT NOT NULL,
    risk_level SMALLINT
    CHECK (risk_level >= 1 AND risk_level <= 10),
    FOREIGN KEY (user_id)
    REFERENCES app_user (user_id)
    ON DELETE SET NULL,
    FOREIGN KEY (geo_id)
    REFERENCES geo_point (geo_id)
    ON DELETE SET NULL
);

CREATE TABLE safety_measure (
    measure_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    measure_desc TEXT NOT NULL,
    FOREIGN KEY (user_id)
    REFERENCES app_user (user_id)
    ON DELETE CASCADE
);


CREATE TABLE safety_stats (
 stats_id SERIAL PRIMARY KEY,
 user_id INTEGER,
 actions_count INTEGER DEFAULT 0 CHECK (actions_count >= 0),
 recorded_date DATE NOT NULL,
 FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON DELETE CASCADE
);

CREATE TABLE chat (
 chat_id SERIAL PRIMARY KEY,
8
 name VARCHAR(200) NOT NULL
);
ALTER TABLE chat
 ADD CONSTRAINT chk_chat_name
 CHECK (name ~ '^[A-Za-zА-Яа-я0-9\-\s]{1,200}$');
CREATE TABLE message (
 msg_id SERIAL PRIMARY KEY,
 chat_id INTEGER,
 user_id INTEGER,
 text TEXT NOT NULL,
 sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
 FOREIGN KEY (chat_id) REFERENCES chat(chat_id) ON DELETE CASCADE,
 FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON DELETE SET NULL
);

CREATE TABLE project (
 project_id SERIAL PRIMARY KEY,
 name VARCHAR(200) NOT NULL,
 description TEXT
);

CREATE TABLE document (
 doc_id SERIAL PRIMARY KEY,
 project_id INTEGER,
 user_id INTEGER,
 title VARCHAR(300) NOT NULL,
 created_at DATE NOT NULL DEFAULT CURRENT_DATE,
 content TEXT,
 FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE SET
NULL,
 FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON DELETE SET NULL
);
