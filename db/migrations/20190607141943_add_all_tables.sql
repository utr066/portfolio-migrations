
-- +goose Up
-- SQL in section 'Up' is executed when this migration is applied

CREATE TABLE users (
    id         SERIAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);

CREATE TABLE profiles (
    user_id      INTEGER        NOT NULL,
    nickname     VARCHAR(255)   NOT NULL,
    introduction TEXT           NOT NULL,
    avatar       VARCHAR(255),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_introduction_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(user_id)    
);

CREATE TABLE carriers (
    user_id         INTEGER          NOT NULL,
    compoany_name   VARCHAR(255)     NOT NULL,
    job_name        VARCHAR(255)     NOT NULL,
    start_date      DATE,
    end_date        DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_carrier_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(user_id)
);

CREATE TABLE links (
    id              SERIAL           NOT NULL,
    user_id         INTEGER          NOT NULL,
    title           VARCHAR(255)     NOT NULL,
    url             VARCHAR(255)     NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_link_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(id)
);

CREATE TABLE works (
    id              SERIAL           NOT NULL,
    user_id         INTEGER          NOT NULL,
    title           VARCHAR(255)     NOT NULL,
    sub_title       VARCHAR(255)     NOT NULL,
    description     TEXT,
    url             VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_work_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(id)
);

CREATE TABLE work_photos (
    work_id         INTEGER      NOT NULL,
    photo_path      VARCHAR(255) NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_work_work_id
        FOREIGN KEY (work_id) REFERENCES works(id)
        ON DELETE CASCADE,
    PRIMARY KEY(work_id)
);

CREATE TABLE skills (
    id              SERIAL           NOT NULL,
    name            VARCHAR(255)     NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);

CREATE TABLE user_skills (
    user_id         INTEGER NOT NULL,
    skill_id        INTEGER NOT NULL,
    level           SMALLINT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_skill_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_user_skill_skill_id
        FOREIGN KEY (skill_id) REFERENCES skills(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(user_id, skill_id)
);

-- トリガー
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';
-- +goose StatementEnd

-- トリガーの紐付け
CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON carriers
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON links
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON works
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_updated_at_column
BEFORE UPDATE ON user_skills
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();
-- +goose Down
-- SQL section 'Down' is executed when this migration is rolled back

DROP TRIGGER update_updated_at_column ON user_skills;
DROP TRIGGER update_updated_at_column ON works;
DROP TRIGGER update_updated_at_column ON links;
DROP TRIGGER update_updated_at_column ON carriers;
DROP TRIGGER update_updated_at_column ON profiles;
DROP TRIGGER update_updated_at_column ON users;
DROP FUNCTION update_updated_at_column();
DROP TABLE user_skills;
DROP TABLE skills;
DROP TABLE work_photos;
DROP TABLE works;
DROP TABLE links;
DROP TABLE carriers;
DROP TABLE profiles;
DROP TABLE users;

