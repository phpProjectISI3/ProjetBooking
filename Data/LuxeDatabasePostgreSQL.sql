create database LuxeDatabase


create table SEXE
(
id_sexe int primary key,
libelle_sexe varchar(10)
);

create table GRADE
(
id_grade int primary key,
libelle_grade varchar(15)
);

create sequence PERSONNE_seq;

create table PERSONNE
(
id_client int default nextval ('PERSONNE_seq') primary key,
nom varchar(50),
prenom varchar(50),
sexe_id int ,
foreign key (sexe_id)references SEXE(id_sexe),
est_Marie boolean,
nbr_Enfant_scolarise int,-- max 4
check(nbr_Enfant_scolarise <=4),
nbr_Enfant_non_scolarise int,--max 4
check(nbr_Enfant_non_scolarise <=4),
grade_id int,
 foreign key (grade_id)references GRADE(id_grade),
date_naissance date,
point int
);

create sequence REMARQUE_CLIENT_seq;

create table REMARQUE_CLIENT
(
id_remarque int default nextval ('REMARQUE_CLIENT_seq') primary key,
personne_id int,
foreign key (personne_id) references PERSONNE(id_client),
description_remarque varchar(100)
);

create table AUTH_ROLE
(
id_role int primary key,
description_role varchar(500),
libelle_role varchar(15)
);

create table AUTH_ROLE_PERSONNE
(
personne_role_id int ,
auth_role_id int ,
primary key(personne_role_id,auth_role_id),
username_email varchar(50),
mot_de_passe varchar(50)
);

create table TYPE_LOGEMENT
(
id_type_logement int primary key,
libelle_type_logement varchar(50)
);

create sequence LOGEMENT_seq;

create table LOGEMENT
(
id_logement int default nextval ('LOGEMENT_seq') primary key,
nom_logement varchar(50),
type_logement_id int,
 foreign key (type_logement_id )references TYPE_LOGEMENT(id_type_logement), -- villa/appartement/suite/chambre hotel
adress_logement varchar(100),
superficie_logement double precision,-- en metre carre
nbr_piece int,
capacite_personne_max int,
tarif_par_nuit_HS double precision, -- en dirham -- Haute saison
tarif_par_nuit_BS double precision, -- en dirham -- basse saison
description_logement varchar(1500),
max_reserv int,-- nbr maximum de reservation par saison (Haute/Basse saison)
tarif_annulation double precision,
marge_annulation int
);

create sequence PHOTO_LOGEMENT_seq;

create table PHOTO_LOGEMENT
(
id_photo int default nextval ('PHOTO_LOGEMENT_seq') primary key,
chemin_photo varchar(250),
logement_id int,
foreign key (logement_id) references LOGEMENT(id_logement)
);

create sequence PLANNING_LOGEMENT_seq;

create table PLANNING_LOGEMENT
(
id_planing int default nextval ('PLANNING_LOGEMENT_seq') primary key,
logement_id int,
foreign key(logement_id) references LOGEMENT(id_logement),
est_disponible boolean, --status du logement (en travaux/disponible) <false/true>
date_debut date, --
date_fin date -- pas du tous obligatoires ... juste au cas au la maison est en etat de reparation ...
);

create sequence DEMANDE_RESERVATION_seq;

create table DEMANDE_RESERVATION
(
id_demande int default nextval ('DEMANDE_RESERVATION_seq') primary key,
date_demande date,
personne_id int ,
foreign key (personne_id)references PERSONNE(id_client),
logement_id int,
 foreign key(logement_id) references LOGEMENT(id_logement),
date_debut date,
date_fin date,
annule_par_client boolean default 'false'
);

create sequence RESERVATION_LOGEMENT_seq;

create table RESERVATION_LOGEMENT
(
id_reservation int default nextval ('RESERVATION_LOGEMENT_seq') primary key,
demande_reservation_id int,
foreign key (demande_reservation_id)references DEMANDE_RESERVATION(id_demande)
);

create table FACTURATION
(
id_facture int primary key,
reservation_logement_id int,
foreign key(reservation_logement_id) references RESERVATION_LOGEMENT(id_reservation),
note_client int, -- L’echelle de satisfaction du collaborateur
commentaire_client varchar(250),
check(note_client >=0 and note_client <=5)
);

