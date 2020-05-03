-- Obligatoir : PostgreSql 9.5
-- En cas de problm .. ou si vous voulez supprimer la base de donnée mn serveur Postgre ..
-- 1-- selectionnez "postgre" f DropDownList dyl Aure data studio ^
-- 2- executez had les 3 requéte une par une.

select *
from pg_stat_activity
where datname = 'pgluxedatabase';

select pg_terminate_backend (pg_stat_activity.pid)
from pg_stat_activity
where pg_stat_activity.datname = 'pgluxedatabase';
-- suprime avec succes = true

drop database PgLuxeDatabase


-- Creer la BD 
create database PgLuxeDatabase
-- !!! ==> selectionnez "PgLuxeDatabase" f DropDownList dyl Aure data studio ^

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

create sequence PERSONNE_seq
start 1000;
create table PERSONNE
(
    id_client int default nextval ('PERSONNE_seq') primary key,
    nom varchar(50),
    prenom varchar(50),
    sexe_ int ,
    foreign key (sexe_)references SEXE(id_sexe),
    est_Marie boolean,
    nbr_Enfant_scolarise int,-- max 4
    check(nbr_Enfant_scolarise <=4),
    nbr_Enfant_non_scolarise int,--max 4
    check(nbr_Enfant_non_scolarise <=4),
    grade_ int,
    foreign key (grade_)references GRADE(id_grade),
    date_naissance date,
    point_personne int
    -- TODO : necessite un trigger.
);

create sequence REMARQUE_CLIENT_seq
start 1;
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
    personne_role_ int ,
    auth_role_ int ,
    primary key(personne_role_,auth_role_),
    username_email varchar(50),
    mot_de_passe varchar(50)
);

create table TYPE_LOGEMENT
(
    id_type_logement int primary key,
    libelle_type_logement varchar(50)
);

create sequence LOGEMENT_seq
start 1;
create table LOGEMENT
(
    id_logement int default nextval ('LOGEMENT_seq') primary key,
    nom_logement varchar(50),
    type_logement_ int,
    foreign key (type_logement_)references TYPE_LOGEMENT(id_type_logement),-- villa/appartement/suite/chambre hotel
    adress_logement varchar(100),
    superficie_logement double precision,-- en metre carre
    nbr_piece int,
    capacite_personne_max int,
    tarif_par_nuit_HS double precision,-- en dirham -- Haute saison
    tarif_par_nuit_BS double precision,-- en dirham -- basse saison
    description_logement varchar(1500),
    max_reserv int,-- nbr maximum de reservation par saison (Haute/Basse saison)
    tarif_annulation double precision,
    marge_annulation int
);

create sequence PHOTO_LOGEMENT_seq
start 1;
create table PHOTO_LOGEMENT
(
    id_photo int default nextval ('PHOTO_LOGEMENT_seq') primary key,
    chemin_photo varchar(250),
    logement_ int,
    foreign key (logement_) references LOGEMENT(id_logement)
);

create sequence PLANNING_LOGEMENT_seq
start 1;
create table PLANNING_LOGEMENT
(
    id_planing int default nextval ('PLANNING_LOGEMENT_seq') primary key,
    logement_ int,
    foreign key(logement_) references LOGEMENT(id_logement),
    est_disponible boolean,--status du logement (en travaux/disponible) <false/true>
    date_debut date,-- pas du tous obligatoires ... juste au cas au la maison est en etat de reparation ...
    date_fin date-- pas du tous obligatoires ... juste au cas au la maison est en etat de reparation ...

);

create sequence DEMANDE_RESERVATION_seq
start 1;
create table DEMANDE_RESERVATION
(
    id_demande int default nextval ('DEMANDE_RESERVATION_seq') primary key,
    date_demande date,
    personne_ int ,
    foreign key (personne_)references PERSONNE(id_client),
    logement_ int,
    foreign key(logement_) references LOGEMENT(id_logement),
    date_debut date,
    date_fin date,
    annule_par_client boolean default 'false',
    date_annulation date
);

create sequence RESERVATION_LOGEMENT_seq
start 1;
create table RESERVATION_LOGEMENT
(
    id_reservation int default nextval ('RESERVATION_LOGEMENT_seq') primary key,
    demande_reservation_ int,
    foreign key (demande_reservation_)references DEMANDE_RESERVATION(id_demande)
);

create table FACTURATION
(
    id_facture int primary key,
    reservation_logement_ int,
    foreign key(reservation_logement_) references RESERVATION_LOGEMENT(id_reservation),
    note_client int,-- L’echelle de satisfaction du collaborateur (0-5 etoile)
    check(note_client >=0 and note_client <=5)
    commentaire_client varchar(250),
);

