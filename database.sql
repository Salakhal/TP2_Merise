/*==============================================================*/
/* Nom de SGBD :  Sybase AS Anywhere 9                          */
/* Date de création :  14/12/2025 15:43:17                      */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_COMMANDE_PASSER_CLIENT') then
    alter table COMMANDE
       delete foreign key FK_COMMANDE_PASSER_CLIENT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CONTENIR_CONTENIR_COMMANDE') then
    alter table CONTENIR
       delete foreign key FK_CONTENIR_CONTENIR_COMMANDE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CONTENIR_CONTENIR2_PRODUIT') then
    alter table CONTENIR
       delete foreign key FK_CONTENIR_CONTENIR2_PRODUIT
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='CLIENT_PK'
     and t.table_name='CLIENT'
) then
   drop index CLIENT.CLIENT_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='COMMANDE_PK'
     and t.table_name='COMMANDE'
) then
   drop index COMMANDE.COMMANDE_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='PASSER_FK'
     and t.table_name='COMMANDE'
) then
   drop index COMMANDE.PASSER_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='CONTENIR2_FK'
     and t.table_name='CONTENIR'
) then
   drop index CONTENIR.CONTENIR2_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='CONTENIR_FK'
     and t.table_name='CONTENIR'
) then
   drop index CONTENIR.CONTENIR_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='CONTENIR_PK'
     and t.table_name='CONTENIR'
) then
   drop index CONTENIR.CONTENIR_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='PRODUIT_PK'
     and t.table_name='PRODUIT'
) then
   drop index PRODUIT.PRODUIT_PK
end if;

/*==============================================================*/
/* Table : CLIENT                                               */
/*==============================================================*/
create table CLIENT 
(
    IDCLIENT             integer                        not null,
    NOMCLIENT            long varchar,
    PRENOMCLIENT         long varchar,
    ADRESSECLIENT        long varchar,
    constraint PK_CLIENT primary key (IDCLIENT)
);

/*==============================================================*/
/* Index : CLIENT_PK                                            */
/*==============================================================*/
create unique index CLIENT_PK on CLIENT (
IDCLIENT ASC
);

/*==============================================================*/
/* Table : COMMANDE                                             */
/*==============================================================*/
create table COMMANDE 
(
    NUMCMD               integer                        not null,
    IDCLIENT             integer                        not null,
    DATECMD              date,
    ADRESSELIV           long varchar,
    constraint PK_COMMANDE primary key (NUMCMD)
);

/*==============================================================*/
/* Index : COMMANDE_PK                                          */
/*==============================================================*/
create unique index COMMANDE_PK on COMMANDE (
NUMCMD ASC
);

/*==============================================================*/
/* Index : PASSER_FK                                            */
/*==============================================================*/
create  index PASSER_FK on COMMANDE (
IDCLIENT ASC
);

/*==============================================================*/
/* Table : CONTENIR                                             */
/*==============================================================*/
create table CONTENIR 
(
    NUMCMD               integer                        not null,
    CODEPROD             integer                        not null,
    QTECMD               integer,
    constraint PK_CONTENIR primary key (NUMCMD, CODEPROD)
);

/*==============================================================*/
/* Index : CONTENIR_PK                                          */
/*==============================================================*/
create unique index CONTENIR_PK on CONTENIR (
NUMCMD ASC,
CODEPROD ASC
);

/*==============================================================*/
/* Index : CONTENIR_FK                                          */
/*==============================================================*/
create  index CONTENIR_FK on CONTENIR (
NUMCMD ASC
);

/*==============================================================*/
/* Index : CONTENIR2_FK                                         */
/*==============================================================*/
create  index CONTENIR2_FK on CONTENIR (
CODEPROD ASC
);

/*==============================================================*/
/* Table : PRODUIT                                              */
/*==============================================================*/
create table PRODUIT 
(
    CODEPROD             integer                        not null,
    LIBPROD              long varchar,
    PRIXUNIT             decimal,
    constraint PK_PRODUIT primary key (CODEPROD)
);

/*==============================================================*/
/* Index : PRODUIT_PK                                           */
/*==============================================================*/
create unique index PRODUIT_PK on PRODUIT (
CODEPROD ASC
);

alter table COMMANDE
   add constraint FK_COMMANDE_PASSER_CLIENT foreign key (IDCLIENT)
      references CLIENT (IDCLIENT)
      on update restrict
      on delete restrict;

alter table CONTENIR
   add constraint FK_CONTENIR_CONTENIR_COMMANDE foreign key (NUMCMD)
      references COMMANDE (NUMCMD)
      on update restrict
      on delete restrict;

alter table CONTENIR
   add constraint FK_CONTENIR_CONTENIR2_PRODUIT foreign key (CODEPROD)
      references PRODUIT (CODEPROD)
      on update restrict
      on delete restrict;

