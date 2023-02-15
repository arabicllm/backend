

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;



SET default_tablespace = '';

SET default_with_oids = false;


DROP TABLE IF EXISTS message_reaction CASCADE;
DROP TABLE IF EXISTS text_labels CASCADE;
DROP TABLE IF EXISTS task CASCADE;
DROP TABLE IF EXISTS user_stats CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS journal_integration CASCADE;
DROP TABLE IF EXISTS journal CASCADE;
DROP TABLE IF EXISTS api_client CASCADE;



CREATE TABLE api_client (
  id UUID PRIMARY KEY,
  api_key VARCHAR(512),
  description VARCHAR(256),
  admin_email VARCHAR(256),
  enabled BOOLEAN
);

CREATE TABLE "user" (
  id UUID PRIMARY KEY,
  username VARCHAR(128),
  display_name VARCHAR(256),
  created_date TIMESTAMP,
  auth_method VARCHAR(128),
  api_client_id UUID REFERENCES api_client(id)

);

CREATE TABLE "user_stats" (
  modified_date TIMESTAMP,
  leader_score INTEGER,
  reactions INTEGER,
  messages INTEGER,
  upvotes INTEGER,
  downvotes INTEGER,
  task_reward INTEGER,
  compare_wins INTEGER,
  compare_losses INTEGER,
    user_id UUID REFERENCES "user"(id)

);

CREATE TABLE task (
  id UUID PRIMARY KEY,
  created_date TIMESTAMP,
  expiry_date TIMESTAMP NULL,
  payload JSONB NULL,
  done BOOLEAN,
  collective BOOLEAN,
  user_id UUID ,
  payload_type VARCHAR(200),
  api_client_id UUID REFERENCES api_client(id),
  ack BOOLEAN NULL,
  frontend_message_id VARCHAR(200),
  message_tree_id UUID,
  parent_message_id UUID
);

CREATE TABLE message_reaction (
  task_id UUID REFERENCES task(id),
  user_id UUID REFERENCES "user"(id) ,
  created_date TIMESTAMP,
  payload JSONB NULL,
  payload_type VARCHAR(200),
  api_client_id UUID REFERENCES api_client(id)
);


CREATE TABLE message (
  id UUID PRIMARY KEY,
  created_date TIMESTAMP,
  payload JSONB NULL,
  depth INTEGER,
  children_count INTEGER,
  parent_id UUID NULL,
  message_tree_id UUID,
  user_id UUID ,
  role VARCHAR(128),
  api_client_id UUID REFERENCES api_client(id),
  frontend_message_id VARCHAR(200),
  payload_type VARCHAR(200),
  lang VARCHAR(200),
  enabled BOOLEAN
);


CREATE TABLE journal (
  id UUID PRIMARY KEY,
  created_date TIMESTAMP,
  api_client UUID REFERENCES api_client(id),
  event_type VARCHAR(200),
  user_id UUID NULL REFERENCES "user"(id) ,
  message_id UUID NULL REFERENCES "message"(id)
);

CREATE TABLE journal_integration (
  id UUID PRIMARY KEY,
  description VARCHAR(512),
  last_journal_id UUID REFERENCES journal(id),
  last_error VARCHAR NULL,
  next_run TIMESTAMP NULL
);


CREATE TABLE text_labels (
  id UUID PRIMARY KEY,
  created_date TIMESTAMP,
  labels JSONB,
  api_client_id UUID REFERENCES api_client(id),
  text VARCHAR(65536),
  message_id UUID REFERENCES message(id)
);



