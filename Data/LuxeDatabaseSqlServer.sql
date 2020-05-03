-- Obligatoir : SqlServer correctement installe.
-- En cas de problm .. ou si vous voulez supprimer la base de donnée mn serveur Postgre ..
use master;
drop database LuxeDatabase;


-- Creer la BD 
create database LuxeDatabase
use LuxeDatabase

create table SEXE
(
    id_sexe int primary key,
    libelle_sexe varchar(10),
)

create table GRADE
(
    id_grade int primary key,
    libelle_grade varchar(15),
)

create table PERSONNE
(
    id_client int identity(1000,1) primary key,
    nom varchar(50),
    prenom varchar(50),
    sexe# int foreign key references SEXE,
    est_Marie bit,
    nbr_Enfant_scolarise int,-- max 4
    check(nbr_Enfant_scolarise <=4),
    nbr_Enfant_non_scolarise int,--max 4
    check(nbr_Enfant_non_scolarise <=4),
    grade# int foreign key references GRADE,
    date_naissance date,
    point int, -- TODO : necessite trigger !
)

create table REMARQUE_CLIENT
(
    id_remarque int identity primary key,
    personne# int foreign key references PERSONNE,
    description_remarque nvarchar(100),
)

create table AUTH_ROLE
(
    id_role int primary key,
    description_role varchar(500),
    libelle_role varchar(15),
)

create table AUTH_ROLE_PERSONNE
(
    personne# int foreign key references PERSONNE,
    auth_role# int foreign key references AUTH_ROLE,
    primary key(personne#,auth_role#),
    username_email varchar(50),
    mot_de_passe varchar(50),
)

create table TYPE_LOGEMENT
(
    id_type_logement int primary key,
    libelle_type_logement varchar(50),
)

create table LOGEMENT
(
    id_logement int identity primary key,
    nom_logement varchar(50),
    type_logement# int foreign key references TYPE_LOGEMENT,
    -- villa/appartement/suite/chambre hotel
    adress_logement varchar(100),
    superficie_logement float,-- en metre carre
    nbr_piece int,
    capacite_personne_max int,
    tarif_par_nuit_HS float,
    -- en dirham -- Haute saison
    tarif_par_nuit_BS float,
    -- en dirham -- basse saison
    description_logement varchar(1500),
    max_reserv int,-- nbr maximum de reservation par saison (Haute/Basse saison)
    tarif_annulation float,
    marge_annulation int
)

create table PHOTO_LOGEMENT
(
    id_photo int identity primary key,
    chemin_photo nvarchar(250),
    logement# int foreign key references LOGEMENT,
)

create table PLANNING_LOGEMENT
(
    id_planing int identity primary key,
    logement# int foreign key references LOGEMENT,
    est_disponible bit,
    --status du logement (en travaux/disponible) <false/true>
    date_debut date,
    --
    date_fin date,
    -- pas du tous obligatoires ... juste au cas au la maison est en etat de reparation ...
)

create table DEMANDE_RESERVATION
(
    id_demande int identity primary key,
    date_demande date,
    personne# int foreign key references PERSONNE,
    logement# int foreign key references LOGEMENT,
    date_debut date,
    date_fin date,
    annule_par_client bit default 'false',
)

create table RESERVATION_LOGEMENT
(
    id_reservation int identity primary key,
    demande_reservation# int foreign key references 
    DEMANDE_RESERVATION,
)

create table FACTURATION
(
    id_facture int primary key,
    reservation_logement# int foreign key references 
    RESERVATION_LOGEMENT,
    note_client int,
    -- L echelle de satisfaction du collaborateur
    commentaire_client nvarchar(250),
    check(note_client >=0 and note_client <=5),
)

