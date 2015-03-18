CREATE TABLE agency_employee (
  id                 integer PRIMARY KEY AUTO_INCREMENT,
  billing_agency_id  integer,
  name               char(50),
  employee_number    integer,
  phone              char(25),
  address            char(50),
  city               char(50),
  state              char(5),
  zip                char(10),
  /* Foreign keys */
  FOREIGN KEY (billing_agency_id)
    REFERENCES billing_agency(id)
);


CREATE TABLE app_registration (
  id              integer PRIMARY KEY AUTO_INCREMENT,
  physician_id    integer,
  app_unique_key  char(50),
  /* Foreign keys */
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE app_yet_tobe_registered (
  id                integer PRIMARY KEY AUTO_INCREMENT,
  physician_id      integer,
  onetime_password  char(50),
  /* Foreign keys */
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE appointment (
  id            integer PRIMARY KEY AUTO_INCREMENT ,
  patient_id    integer,
  physician_id  integer,
  facility_id	integer,
  appt_date		date,
  appt_start    time,
  appt_end      time,
  reason        text,
  room          varchar(50),
  location      varchar(50),
  reminder      integer,
  mrn           varchar(50), 
  referring_physician_id INTEGER, complete integer DEFAULT 0,
  /* Foreign keys */
  FOREIGN KEY (referring_physician_id)
    REFERENCES referring_physician(id),
  FOREIGN KEY (patient_id)
    REFERENCES patient(id),
  FOREIGN KEY (facility_id)
    REFERENCES facility(id),
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE billing_agency (
  id       integer PRIMARY KEY AUTO_INCREMENT,
  name     char(50),
  address  char(50),
  city     char(50),
  state    char(5),
  zip      char(10),
  phone    char(25),
  fax      char(15)
);


CREATE TABLE billing_batch (
  id                 integer PRIMARY KEY AUTO_INCREMENT,
  encounter_id       integer,
  agencyemployee_id  integer,
  group_id           integer,
  physician_id       integer,
  exported_date      date,
  exported_filename  char(50),
  /* Foreign keys */
  FOREIGN KEY (agencyemployee_id)
    REFERENCES agency_employee(id), 
  FOREIGN KEY (encounter_id)
    REFERENCES encounter(id), 
  FOREIGN KEY (physician_id)
    REFERENCES physician(id), 
  FOREIGN KEY (group_id)
    REFERENCES physician_group(id)
);

CREATE TABLE billing_pref (
  id                integer PRIMARY KEY AUTO_INCREMENT ,
  billing_agency_id integer,
  resource_id       integer, 
  resource_type     char(20),
  /* Foreign keys */
  FOREIGN KEY (billing_agency_id)
    REFERENCES billing_agency(id) 
);

CREATE TABLE billing_report (
  id              integer PRIMARY KEY AUTO_INCREMENT,
  user_id         integer,
  group_name      char(20),
  physician       char(20),
  processed_date  date,
  report_path     text,
  created_at      datetime,
  updated_at      datetime
);

CREATE TABLE buddylist
(user_id varchar(50) NOT NULL,
buddy_user_id varchar(50) NOT NULL,
 /* Foreign keys */
  FOREIGN KEY (user_id)
    REFERENCES user_sip_config(user_id),
  FOREIGN KEY (buddy_user_id)
    REFERENCES user_sip_config(user_id)
);


CREATE TABLE census (
  id		integer  PRIMARY KEY AUTO_INCREMENT ,
  patient_id              integer,
  physician_id  integer,
  facility_id			  integer,
  mrn                     varchar(50),
  room                    integer,
  admit_date              date,
  discharge_date          date,
  referring_physician_id  integer,
  active				  integer,
  FOREIGN KEY (patient_id)
    REFERENCES patient(id), 
  FOREIGN KEY (physician_id)
    REFERENCES physician(id), 
  FOREIGN KEY (facility_id)
    REFERENCES facility(id),
  FOREIGN KEY (referring_physician_id)
    REFERENCES referring_physician(id)
);


CREATE TABLE cpt (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  code          char(50),
  description   text,
  short_key     char(50),
  version_year  integer
);


CREATE TABLE cpt_group (
  id    integer PRIMARY KEY AUTO_INCREMENT,
  name  char(50)
);


CREATE TABLE custom_procedure (
  physician_id  integer,
  description   text,
  /* Foreign keys */
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE encounter (
  id               integer PRIMARY KEY AUTO_INCREMENT,
  census_id       integer,
  appt_id  integer,
  date_of_service  date,
  attending_physician_id     integer,
  status integer,
  complete_date date,
  pull_date date,
  /* Foreign keys */
  FOREIGN KEY (census_id)
    REFERENCES census(id),
  FOREIGN KEY (appt_id)
    REFERENCES appointment(id),
  FOREIGN KEY (attending_physician_id)
    REFERENCES physician(id)
);


CREATE TABLE encounter_cpt (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  encounter_id  integer,
  superbill_cpt_id        integer,
  queued_date datetime,
  pulled_date datetime, 
  /* Foreign keys */
  FOREIGN KEY (superbill_cpt_id)
    REFERENCES superbill_cpt(id), 
  FOREIGN KEY (encounter_id)
    REFERENCES encounter(id)
);


CREATE TABLE encounter_cpt_modifier (
  id integer PRIMARY KEY AUTO_INCREMENT ,
  encounter_cpt_id  integer,
  modifier VARCHAR(25),
  /* Foreign keys */
  FOREIGN KEY (encounter_cpt_id)
    REFERENCES encounter_cpt(id)
);


CREATE TABLE encounter_icd (
  id                 integer PRIMARY KEY AUTO_INCREMENT,
  encounter_id       integer,
  encounter_cpt_id   integer,
  icd_id             integer,
  primary_diagnosis  smallint,
  /* Foreign keys */
  FOREIGN KEY (encounter_id)
    REFERENCES encounter(id), 
  FOREIGN KEY (encounter_cpt_id)
    REFERENCES encounter_cpt(id), 
  FOREIGN KEY (icd_id)
    REFERENCES icd(id)
);


CREATE TABLE encounter_note (
  id              integer PRIMARY KEY AUTO_INCREMENT ,
  encounter_id    integer,
  note_id         integer,
  type_id         integer,
  text_note       text,
  voice_note      blob,
  picture_note    blob,
  /* Foreign keys */
  FOREIGN KEY (encounter_id)
    REFERENCES encounter(id), 
  FOREIGN KEY (note_id)
    REFERENCES note(id),
  FOREIGN KEY (type_id)
    REFERENCES note_type(id)
);

CREATE TABLE facility (
  id               integer PRIMARY KEY AUTO_INCREMENT ,
  facility_type_id integer,
  medicare_id      numeric(15),
  name             char(50),
  address          char(50),
  city             char(50),
  state            char(5),
  zip              char(10),
  county           char(50),
  phone            char(25),
  resource_id      integer,
  resource_type    char(20),
  visibility_to_group boolean DEFAULT false,
  /* Foreign keys */
  FOREIGN KEY (facility_type_id)
    REFERENCES facility_type(id)
);


CREATE TABLE facility_type (
  id           integer PRIMARY KEY AUTO_INCREMENT ,
  name         char(50)
);


CREATE TABLE favorite_facility (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  physician_id  integer,
  facility_id   integer,
  /* Foreign keys */
  FOREIGN KEY (facility_id)
    REFERENCES facility(id), 
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE favorite_icd (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  physician_id  integer,
  icd_id        integer,
  /* Foreign keys */
  FOREIGN KEY (icd_id)
    REFERENCES icd(id), 
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);

CREATE TABLE hospital_episode (
  patient_id              integer PRIMARY KEY AUTO_INCREMENT,
  floor                   integer,
  room                    integer,
  admit_date              date,
  discharge_date          date,
  primary_physician_id    integer,
  referring_physician_id  integer,
  /* Foreign keys */
  FOREIGN KEY (patient_id)
    REFERENCES patient(id), 
  FOREIGN KEY (primary_physician_id)
    REFERENCES referring_physician(id), 
  FOREIGN KEY (referring_physician_id)
    REFERENCES referring_physician(id) 
);

CREATE TABLE icd (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  code          char(50),
  description   text,
  version_year  integer, 
  long_description TEXT,
  pft TEXT
);


CREATE TABLE im
(id INTEGER ,
from_user_id INTEGER,
to_user_id INTEGER,
send_timestamp NUMERIC(25),
recv_timestamp NUMERIC(25),
message TEXT(25),
PRIMARY KEY AUTO_INCREMENT (id));


CREATE TABLE location
(id INTEGER ,
location VARCHAR(45),
PRIMARY KEY AUTO_INCREMENT (id));


CREATE TABLE master_cpt_pft
(cpt_code VARCHAR(50) PRIMARY KEY ,
pft VARCHAR(256));


CREATE TABLE master_icd_pft(
  icd_code VARCHAR(50) PRIMARY KEY ,
  pft VARCHAR(256)
);

CREATE TABLE note (
  id           integer PRIMARY KEY AUTO_INCREMENT,
  type_id      integer,
  text_note    text,
  voice_note   blob, 
  picture_note blob,
  /* Foreign keys */
  FOREIGN KEY (type_id)
    REFERENCES note_type(id) 
);

CREATE TABLE note_type (
  id           integer PRIMARY KEY AUTO_INCREMENT,
  description  text
);


CREATE TABLE patient (
  id            integer PRIMARY KEY AUTO_INCREMENT, 
  first_name    char(50), 
  middle_name   char(50), 
  last_name     char(50), 
  date_of_birth date,
  race          char(50), 
  gender        char(50),
  phone         char(25), 
  email         char(50), 
  insurance     char(50),
  physician_id  integer,
  facility_id   integer,
  /* Foreign keys */
  FOREIGN KEY (physician_id)
    REFERENCES physician(id), 
  FOREIGN KEY (facility_id)
    REFERENCES facility(id) 
);


CREATE TABLE physician (
  id                  integer PRIMARY KEY AUTO_INCREMENT , 
  group_id            integer, 
  group_flag          smallint,
  name                char(50),
  initials            char(2), 
  specialty           char(50), 
  state               char(2), 
  zip                 char(10), 
  npi                 char(50), 
  mobile              char(15), 
  phone               char(25), 
  fax                 char(15), 
  email               char(50),
  password            char(50),
  subscribe_to_iphone integer, 
  subscribe_to_web    integer,
  salutation          char(5) DEFAULT "Dr.",
  no_of_billing_days  integer,
  print_id            integer,
  /* Foreign keys */
  FOREIGN KEY (group_id)
    REFERENCES physician_group(id)
);


CREATE TABLE physician_cpt_pft
(cpt_code VARCHAR(50) PRIMARY KEY ,
pft VARCHAR(256));


CREATE TABLE physician_group (
  id               integer PRIMARY KEY AUTO_INCREMENT,
  name             char(50),
  address          char(50),
  city             char(50),
  state            char(5),
  zip              char(10),
  phone            char(25),
  fax              char(15),
  admin_email      char(50),
  admin_password   char(50),
  is_user_required boolean DEFAULT false,
  print_id         integer
);


CREATE TABLE physician_icd_pft
(icd_code VARCHAR(50) PRIMARY KEY ,
pft VARCHAR(256));


CREATE TABLE physician_pref (
  id                      integer PRIMARY KEY AUTO_INCREMENT,
  physician_id            integer,
  number_of_days_to_bill  integer,
  fax_to_primary          integer,
  defacto_facility_id     integer,
  /* Foreign keys */
  FOREIGN KEY (defacto_facility_id)
    REFERENCES facility(id), 
  FOREIGN KEY (physician_id)
    REFERENCES physician(id)
);


CREATE TABLE physician_superbill (
  id            integer PRIMARY KEY AUTO_INCREMENT ,
  physician_id  integer,
  facility_type_id	integer,
  superbill_id  integer,
  preferred     smallint,
  /* Foreign keys */
  FOREIGN KEY (physician_id)
    REFERENCES physician(id), 
  FOREIGN KEY (facility_type_id)
    REFERENCES facility_type(id), 
  FOREIGN KEY (superbill_id)
    REFERENCES superbill(id)
);

CREATE TABLE prints (
  id            integer PRIMARY KEY AUTO_INCREMENT ,
  image_file_name       char(100),
  image_file_size       char(50),
  image_content_type    char(50),
  user_id               integer,
  created_at            datetime,
  updated_at            datetime    
);

CREATE TABLE referring_physician (
  id                  integer PRIMARY KEY AUTO_INCREMENT,
  name                char(50),
  address             char(50),
  city                char(50),
  state               char(5),
  zip                 char(10),
  phone               char(25),
  mobile              char(15),
  fax                 char(15),
  email               char(50),
  npi                 char(50),
  specialty           char(50),
  resource_id         integer,
  resource_type       char(20),
  visibility_to_group boolean DEFAULT false
);

CREATE TABLE roles (
  id    integer PRIMARY KEY AUTO_INCREMENT,
  name  char(25)
);

CREATE TABLE sessions (
  session_id  VARCHAR(50) primary key ,
  data        text, 
  created_at  datetime,
  updated_at  datetime
);


CREATE TABLE specialty (
  id    integer PRIMARY KEY AUTO_INCREMENT,
  name  char(45)
);


CREATE TABLE state (
  id    integer PRIMARY KEY AUTO_INCREMENT,
  code  char(5),
  name  char(100)
);


CREATE TABLE status
(id INTEGER ,
status VARCHAR(45),
PRIMARY KEY AUTO_INCREMENT (id));


CREATE TABLE superbill (
  id                integer PRIMARY KEY AUTO_INCREMENT ,
  name              char(50),
  state_id          integer,
  specialty_id      integer,
  billing_agency_id integer,
  /* Foreign keys */
  FOREIGN KEY (state_id)
    REFERENCES state(id), 
  FOREIGN KEY (specialty_id)
    REFERENCES specialty(id), 
  FOREIGN KEY (billing_agency_id)
    REFERENCES billing_agency(id) 
);


CREATE TABLE superbill_cpt (
  id                   integer PRIMARY KEY AUTO_INCREMENT,
  superbill_id         integer,
  cpt_group_id         integer,
  group_display_order  integer,
  cpt_id               integer,
  cpt_display_oder     INTEGER,
  modifier             char(45),
  /* Foreign keys */
  FOREIGN KEY (cpt_id)
    REFERENCES cpt(id), 
  FOREIGN KEY (cpt_group_id)
    REFERENCES cpt_group(id), 
  FOREIGN KEY (superbill_id)
    REFERENCES superbill(id)
);


CREATE TABLE superbill_cpt_modifier (
  id                   integer PRIMARY KEY AUTO_INCREMENT ,
  superbill_cpt_id     integer,
  display_order  integer,
  modifier             char(45), description TEXT,
  /* Foreign keys */
  FOREIGN KEY (superbill_cpt_id)
    REFERENCES superbill_cpt(id)
);


CREATE TABLE superbill_icd (
  id            integer PRIMARY KEY AUTO_INCREMENT,
  superbill_id  integer,
  superbill_cpt_id  integer,
  icd_id        integer,
  /* Foreign keys */
  FOREIGN KEY (icd_id)
    REFERENCES icd(id), 
  FOREIGN KEY (superbill_id)
    REFERENCES superbill(id),
  FOREIGN KEY (superbill_cpt_id)
    REFERENCES superbill_cpt(id)
);


CREATE TABLE users (
  id              integer PRIMARY KEY AUTO_INCREMENT,
  email                 char(50) DEFAULT "" NOT NULL,
  encrypted_password    char(128) DEFAULT "" NOT NULL,
  password_salt         char(128) DEFAULT "" NOT NULL,
  reset_password_token  char(50),
  remember_token        char(50),
  remember_created_at   datetime,
  sign_in_count         integer DEFAULT 0,
  current_sign_in_at    datetime,
  last_sign_in_at       datetime,
  current_sign_in_ip    char(15),
  last_sign_in_ip       char(15),
  confirmation_token    char(50),
  confirmed_at          datetime,
  confirmation_sent_at  datetime,
  failed_attempts       integer DEFAULT 0,
  unlock_token          char(50),
  locked_at             datetime,
  username              char(20),
  resource_id           integer,
  resource_type         char(20),
  created_at            datetime,
  updated_at            datetime,
  roles_mask            integer
);


CREATE TABLE user_sip_config
(user_id VARCHAR(50) primary key not null,
display_name VARCHAR(100),
sip_uri VARCHAR(50),
public_key VARCHAR(1024));


CREATE TABLE videos (
  id              integer PRIMARY KEY AUTO_INCREMENT,
  original_file_name    char(100),
  original_file_size    char(30),
  original_content_type char(30),
  user_id               integer,
  created_at            datetime,
  updated_at            datetime    
);

CREATE TABLE schema_migrations(
  version VARCHAR(255) PRIMARY KEY 
);


CREATE INDEX agencyemployee_id_idx
ON billing_batch
(agencyemployee_id)
;

CREATE INDEX billing_agency_id_idx
ON agency_employee
(billing_agency_id)
;

CREATE INDEX defacto_facility_id_idx
ON physician_pref
(defacto_facility_id)
;

CREATE INDEX encounter_id_idx
ON billing_batch
(encounter_id)
;

CREATE INDEX facility_id_idx
ON favorite_facility
(facility_id)
;

CREATE INDEX group_id_idx
ON billing_batch
(group_id)
;

CREATE INDEX icd_code_idx01 
	ON icd (code)
;


CREATE INDEX icd_id_idx01
ON favorite_icd
(icd_id)
;

CREATE INDEX physician_id
ON custom_procedure
(physician_id)
;

CREATE INDEX physician_id_idx
ON app_registration
(physician_id)
;

CREATE INDEX physician_id_idx01
ON app_yet_tobe_registered
(physician_id)
;

CREATE INDEX physician_id_idx02
ON billing_batch
(physician_id)
;

CREATE INDEX physician_id_idx04
ON favorite_facility
(physician_id)
;

CREATE INDEX physician_id_idx05
ON favorite_icd
(physician_id)
;

CREATE INDEX physician_id_idx07
ON physician_pref
(physician_id)
;













