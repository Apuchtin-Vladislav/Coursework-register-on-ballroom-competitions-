CONNECT 'D:\Pars\3 course\2 semester\DataBase\Coursework\BD\coursework_ver2.FDB'
USER 'SYSDBA' PASSWORD 'masterkey';

DROP DATABASE;

CREATE DATABASE 'D:\Pars\3 course\2 semester\DataBase\Coursework\BD\coursework_ver2.FDB'
USER 'SYSDBA' PASSWORD 'masterkey';
/*==============================================================*/
/* Table: Adjudicators                                          */
/*==============================================================*/
create table Adjudicators
(
   nameAdjudicator      VARCHAR(32) not null,
   surnameAdjudicator   VARCHAR(32) not null,
   patronymicAdjudicator VARCHAR(32),
   codeAdjudicator      INTEGER not null,
   Country              VARCHAR(32),
   primary key (surnameAdjudicator, nameAdjudicator, codeAdjudicator)
);

/*==============================================================*/
/* Table: BallroomPrograms                                      */
/*==============================================================*/
create table BallroomPrograms
(
   IdCompetition        INTEGER not null,
   IdProgram            INTEGER not null,
   typeOfProgram        VARCHAR(32),
   primary key (IdCompetition, IdProgram)
);

/*==============================================================*/
/* Table: Categories                                            */
/*==============================================================*/
create table Categories
(
   IdCompetition        INTEGER not null,
   IdProgram            INTEGER not null,
   CategoryID           INTEGER not null,
   CategoryName         VARCHAR(32),
   primary key (IdCompetition, IdProgram, CategoryID)
);

/*==============================================================*/
/* Table: Classes                                               */
/*==============================================================*/
create table Classes
(
   ClassID              INTEGER not null,
   ClassName            VARCHAR(32),
   primary key (ClassID)
);

/*==============================================================*/
/* Table: Coaches                                               */
/*==============================================================*/
create table Coaches
(
   Country              VARCHAR(32),
   nameCoach            VARCHAR(32) not null,
   surnameCoach         VARCHAR(32) not null,
   patronymicCoaches    VARCHAR(32),
   codeCoach            INTEGER not null,
   primary key (surnameCoach, nameCoach, codeCoach)
);

/*==============================================================*/
/* Table: Competitions                                          */
/*==============================================================*/
create table Competitions
(
   IdCompetition        INTEGER not null,
   Title                VARCHAR(32) not null,
   DateCompetition      VARCHAR(32) not null,
   Place                VARCHAR(32) not null,
   Rules                VARCHAR(32),
   Organizers           VARCHAR(32),
   Country              VARCHAR(32),
   primary key (IdCompetition)
);

/*==============================================================*/
/* Table: Couples                                               */
/*==============================================================*/
create table Couples
(
   ClassID              INTEGER not null,
   IdCompetition        INTEGER not null,
   IdProgram            INTEGER not null,
   CategoryID           INTEGER not null,
   PairNumber           INTEGER not null,
   codePartner          VARCHAR(32) not null,
   namePartner          VARCHAR(32) not null,
   surnamePartner       VARCHAR(32) not null,
   surnameShepartner    VARCHAR(32) not null,
   nameShepartner       VARCHAR(32) not null,
   codeShePartner       INTEGER not null,
   surnameCoach         VARCHAR(32),
   nameCoach            VARCHAR(32),
   codeCoach            INTEGER,
   primary key (ClassID, IdCompetition, IdProgram, CategoryID, PairNumber)
);

/*==============================================================*/
/* Table: Partners                                              */
/*==============================================================*/
create table Partners
(
   Country              VARCHAR(32),
   namePartner          VARCHAR(32) not null,
   surnamePartner       VARCHAR(32) not null,
   patronymic           VARCHAR(32),
   codePartner          VARCHAR(32) not null,
   primary key (codePartner, namePartner, surnamePartner)
);

/*==============================================================*/
/* Table: Shepartners                                           */
/*==============================================================*/
create table Shepartners
(
   nameShepartner       VARCHAR(32) not null,
   surnameShepartner    VARCHAR(32) not null,
   patronymic           VARCHAR(32),
   codeShePartner       INTEGER not null,
   Country              VARCHAR(32),
   primary key (surnameShepartner, nameShepartner, codeShePartner)
);

/*==============================================================*/
/* Table: consistClass                                          */
/*==============================================================*/
create table consistClass
(
   IdCompetition        INTEGER not null,
   IdProgram            INTEGER not null,
   CategoryID           INTEGER not null,
   ClassID              INTEGER not null,
   primary key (IdCompetition, IdProgram, CategoryID, ClassID)
);

/*==============================================================*/
/* Table: judge                                                 */
/*==============================================================*/
create table judge
(
   IdCompetition        INTEGER not null,
   surnameAdjudicator   VARCHAR(32) not null,
   nameAdjudicator      VARCHAR(32) not null,
   codeAdjudicator      INTEGER not null,
   primary key (IdCompetition, surnameAdjudicator, nameAdjudicator, codeAdjudicator)
);

alter table BallroomPrograms add constraint FK_consist foreign key (IdCompetition)
      references Competitions (IdCompetition);

alter table Categories add constraint FK_consistCategories foreign key (IdCompetition, IdProgram)
      references BallroomPrograms (IdCompetition, IdProgram);

alter table Couples add constraint FK_consistPartnerIn foreign key (codePartner, namePartner, surnamePartner)
      references Partners (codePartner, namePartner, surnamePartner);

alter table Couples add constraint FK_consistShepartnerIn foreign key (surnameShepartner, nameShepartner, codeShePartner)
      references Shepartners (surnameShepartner, nameShepartner, codeShePartner);

alter table Couples add constraint FK_haveClass foreign key (ClassID)
      references Classes (ClassID);

alter table Couples add constraint FK_haveCoache foreign key (surnameCoach, nameCoach, codeCoach)
      references Coaches (surnameCoach, nameCoach, codeCoach);

alter table Couples add constraint FK_partIn foreign key (IdCompetition, IdProgram, CategoryID)
      references Categories (IdCompetition, IdProgram, CategoryID);

alter table consistClass add constraint FK_consistClass foreign key (IdCompetition, IdProgram, CategoryID)
      references Categories (IdCompetition, IdProgram, CategoryID);

alter table consistClass add constraint FK_consistClass2 foreign key (ClassID)
      references Classes (ClassID);

alter table judge add constraint FK_judge foreign key (IdCompetition)
      references Competitions (IdCompetition);

alter table judge add constraint FK_judge2 foreign key (surnameAdjudicator, nameAdjudicator, codeAdjudicator)
      references Adjudicators (surnameAdjudicator, nameAdjudicator, codeAdjudicator);

/*==============================================================*/
/* Insert: First competition                                    */
/*==============================================================*/
INSERT INTO Competitions (IdCompetition, Country, Title, DateCompetition, Place, Rules, Organizers)
   VALUES (1, 'Ukraine', 'Kyiv Open', '11.04.2017', 'Kyiv', 'WDS', 'Sergiy Gritsak');

INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
   VALUES (1, 1, 'Total');
INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
   VALUES (1, 2, 'Standart');
INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
   VALUES(1, 3, 'Latin');

--total
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 1, 1, 'Junior 1');
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 1, 2, 'Junior 2');
--standart
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 2, 3, 'Youth 1');
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 2, 4, 'Youth 2');
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 2, 5, 'Adult');
--latin
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 3, 3, 'Youth 1');
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 3, 4, 'Youth 2');
INSERT INTO Categories (IdCompetition, IdProgram, CategoryID, CategoryName)
   VALUES (1, 3, 5, 'Adult');


INSERT INTO Classes (ClassID, ClassName)
   VALUES (1, 'C');
INSERT INTO Classes (ClassID, ClassName)
   VALUES (2, 'B');
INSERT INTO Classes (ClassID, ClassName)
   VALUES (3, 'A');

-- idcompetition, total, junior1, C  
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 1, 1, 1);
-- idcompetition, total, junior2, C 
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 1, 2, 1);
-- idcompetition, standart, youth1, C,B,A 
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 3, 1);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 3, 2);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 3, 3);
-- idcompetition, latin, youth1, C,B,A
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 3, 1);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 3, 2);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 3, 3);
-- idcompetition, standart, youth2, C,B,A 
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 4, 1);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 4, 2);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 4, 3);
-- idcompetition, latin, youth2, C,B,A
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 4, 1);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 4, 2);
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 4, 3);
-- idcompetition, standart, adult, A
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 2, 5, 3);
-- idcompetition, latin, adult, A
INSERT INTO consistClass (IdCompetition, IdProgram, CategoryID, ClassID)
   VALUES (1, 3, 5, 3);


INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (1, 'Dikyi', 'Igor', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (2, 'Pasazkaya', 'Polina', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (3, 'Frolova', 'Vera', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (4, 'Frolov', 'Valentin', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (5, 'Boev', 'Igor', null, 'Hong Kong');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (6, 'Prohorenko', 'Yura', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (7, 'Golovashenko', 'Igor', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (8, 'Tkachenko', 'Artem', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (9, 'Tkachenko', 'Anna', null, 'Ukraine');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (10, 'Fujii', 'Masaaki', null, 'Japan');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (11, 'Horacek', 'Petr', null, 'Slovakia');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (12, 'Juul', 'Kevin', null, 'Republic of South Africa');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (13, 'Sandor', 'Zoltan', null, 'Hungary');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (14, 'Rusu', 'Alexandru', null, 'Romania');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (15, 'Bodini', 'Luigi', null, 'Itali');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (16, 'Milicija', 'Sergej', null, 'Bosna i Hercegovina');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (17, 'Novak', 'Daniela', null, 'Slovenia');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (18, 'Ashrafov', 'Azar', null, 'Azerbaijan');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (19, 'Smirnova', 'Galina', null, 'Poland');
INSERT INTO Coaches (codeCoach, surnameCoach, nameCoach, patronymicCoaches, Country)
   VALUES (20, 'Kavzinadze', 'Nino', null, 'Georgia');



INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (1, 'Dikyi', 'Igor', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (2, 'Pasazkaya', 'Polina', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (3, 'Frolova', 'Vera', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (4, 'Frolov', 'Valentin', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (5, 'Boev', 'Igor', null, 'Hong Kong');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (6, 'Prohorenko', 'Yura', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (7, 'Golovashenko', 'Igor', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (8, 'Tkachenko', 'Artem', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (9, 'Tkachenko', 'Anna', null, 'Ukraine');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (10, 'Fujii', 'Masaaki', null, 'Japan');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (11, 'Horacek', 'Petr', null, 'Slovakia');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (12, 'Juul', 'Kevin', null, 'Republic of South Africa');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (13, 'Sandor', 'Zoltan', null, 'Hungary');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (14, 'Rusu', 'Alexandru', null, 'Romania');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (15, 'Bodini', 'Luigi', null, 'Itali');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (16, 'Milicija', 'Sergej', null, 'Bosna i Hercegovina');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (17, 'Novak', 'Daniela', null, 'Slovenia');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (18, 'Ashrafov', 'Azar', null, 'Azerbaijan');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (19, 'Smirnova', 'Galina', null, 'Poland');
INSERT INTO Adjudicators (codeAdjudicator, surnameAdjudicator, nameAdjudicator, patronymicAdjudicator, Country)
   VALUES (20, 'Kavzinadze', 'Nino', null, 'Georgia');

INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 1, 'Dikyi', 'Igor');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 2, 'Pasazkaya', 'Polina');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 3, 'Frolova', 'Vera');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 4, 'Frolov', 'Valentin');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 5, 'Boev', 'Igor');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 6, 'Prohorenko', 'Yura');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 7, 'Golovashenko', 'Igor');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 8, 'Tkachenko', 'Artem');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 9, 'Tkachenko', 'Anna');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 10, 'Fujii', 'Masaaki');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 11, 'Horacek', 'Petr');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 12, 'Juul', 'Kevin');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 13, 'Sandor', 'Zoltan');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 14, 'Rusu', 'Alexandru');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 15, 'Bodini', 'Luigi');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 16, 'Milicija', 'Sergej');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 17, 'Novak', 'Daniela');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 18, 'Ashrafov', 'Azar');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 19, 'Smirnova', 'Galina');
INSERT INTO judge (IdCompetition, codeAdjudicator, surnameAdjudicator, nameAdjudicator)
   VALUES (1, 20, 'Kavzinadze', 'Nino');

INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (1, 'Apukhtin', 'Vladislav', 'Ukraine', 'Sergiyovich');
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (2, 'Poddubny', 'Denis', 'Ukraine', 'Stanislavovich');
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (3, 'Khandus', 'Vladislav', 'Ukraine', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (4, 'Ishchenko', 'Artem', 'Ukraine', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (5, 'Bitetto', 'Alessio', 'Itali', null);
INSERT INTO Partners (codePartner, namePartner, surnamePartner, Country, patronymic)
   VALUES (6, 'Bures', 'Marek', 'Czech Republic', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (7, 'Cecinati', 'Mario', 'Italy', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (8, 'Choma', 'Karol', 'Poland', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (9, 'Cicchitti', 'Matteo', 'Slovakia', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (10, 'Cseke', 'Zsolt-Sandor', 'Germany', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (11, 'Denes', 'Ferenc-Szalai', 'Budapest', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (12, 'Doga', 'Dumitru', 'Germany', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (13, 'Esposito', 'Francesco', 'Itali', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (14, 'Fabik', 'Anton', 'Slovakia', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (15, 'Kasprzak', 'Konstanty', 'Poland', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (16, 'Khodenko', 'Alexandr', 'Russia', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (17, 'Maidaniuk', 'Mihail', 'Belorus', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (18, 'Mugerman', 'Alon', 'Israel', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (19, 'Rednic', 'Paul', 'Romania', null);
INSERT INTO Partners (codePartner, surnamePartner, namePartner, Country, patronymic)
   VALUES (20, 'Szkutnik', 'Bartlomiej', 'Poland', null);

INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (1, 'Teterina', 'Anastasiia', 'Ukraine', 'Alexeyevna');
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (2, 'Pack', 'Anastasiia', 'Ukraine', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (3, 'Velikaya', 'Anna', 'Ukraine', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (4, 'Glushchenko', 'Lena', 'Ukraine', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (5, 'Dabramo', 'Annamaria', 'Itali', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (6, 'Iermolenko', 'Anastasiia', 'Czech Republic', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (7, 'Denaro', 'Rosaria_Messina', 'Italy', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (8, 'Dabek', 'Paulina', 'Poland', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (9, 'Brecikova', 'Simona', 'Slovakia', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (10, 'Dzumaev', 'Malika', 'Germany', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (11, 'Petra', 'Balla', 'Budapest', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (12, 'Shkyria', 'Valeriia', 'Germany', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (13, 'Ertmer', 'Sarah', 'Itali', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (14, 'Kostenko', 'Svetlana', 'Slovakia', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (15, 'Vargova', 'Iveta', 'Poland', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (16, 'Zanlorenzi', 'Giulia', 'Russia', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (17, 'Karcagi', 'Laura', 'Belorus', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (18, 'Vasickova', 'Gabriela', 'Israel', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (19, 'Shalaeva', 'Ekaterina', 'Romania', null);
INSERT INTO Shepartners (codeShePartner, surnameShepartner, nameShepartner, Country, patronymic)
   VALUES (20, 'Ekaterina', 'Mishina', 'Poland', null);

-- --Junior1 total C
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
VALUES (1, 1, 1, 1, 6, 'Prohorenko', 'Yura', 6, 'Cecinati', 'Mario', 7, 'Iermolenko', 'Anastasiia', 6);

-- --total Junior1 C
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
VALUES (1, 1, 2, 1, 6, 'Prohorenko', 'Yura', 6, 'Cecinati', 'Mario', 7, 'Iermolenko', 'Anastasiia', 6);

--st Youth2 B
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 4, 2, 1, 'Dikyi', 'Igor', 1, 'Apukhtin', 'Vladislav', 1, 'Teterina', 'Anastasiia', 1);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 4, 2, 2, 'Pasazkaya', 'Polina', 2, 'Poddubny', 'Denis', 2, 'Pack', 'Anastasiia', 2);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 4, 2, 3, 'Frolova', 'Vera', 3, 'Ishchenko', 'Artem', 4, 'Velikaya', 'Anna', 3);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 4, 2, 4, 'Frolov', 'Valentin', 4, 'Khandus', 'Vladislav', 3, 'Glushchenko', 'Lena', 4);

--st Youth2 A
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 4, 3, 5, 'Boev', 'Igor', 5, 'Bitetto', 'Alessio', 5, 'Dabramo', 'Annamaria', 5);
--lat Youth2 A
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 3, 5, 'Boev', 'Igor', 5, 'Bitetto', 'Alessio', 5, 'Dabramo', 'Annamaria', 5);

--lat Youth2 B
INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 2, 1, 'Dikyi', 'Igor', 1, 'Apukhtin', 'Vladislav', 1, 'Teterina', 'Anastasiia', 1);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 2, 2, 'Pasazkaya', 'Polina', 2, 'Poddubny', 'Denis', 2, 'Pack', 'Anastasiia', 2);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 2, 3, 'Frolova', 'Vera', 3, 'Ishchenko', 'Artem', 4, 'Velikaya', 'Anna', 3);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 2, 4, 'Frolov', 'Valentin', 4, 'Khandus', 'Vladislav', 3, 'Glushchenko', 'Lena', 4);

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 4, 2, 5, 'Boev', 'Igor', 5, 'Bitetto', 'Alessio', 5, 'Dabramo', 'Annamaria', 5);

--st Adult A

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 2, 5, 3, 5, 'Boev', 'Igor', 5, 'Bitetto', 'Alessio', 5, 'Dabramo', 'Annamaria', 5);

--lat Adult A

INSERT INTO Couples (IdCompetition, IdProgram, CategoryID, ClassID, PairNumber, surnameCoach,
   nameCoach, codeCoach, surnamePartner, namePartner, codePartner, surnameShepartner,
      nameShepartner, codeShePartner)
   VALUES (1, 3, 5, 3, 5, 'Boev', 'Igor', 5, 'Bitetto', 'Alessio', 5, 'Dabramo', 'Annamaria', 5);


/*==============================================================*/
/* Insert: Second competition                                   */
/*==============================================================*/

--IdProgram неправильно
-- INSERT INTO Competitions (IdCompetition, Country, Title, DateCompetition, Place, Rules, Organizers)
--    VALUES (2, 'Russia', 'Kremlin Cup', '18.04.2017', 'Russia', 'WDSF', 'Stanislav Popov');

-- INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
--    VALUES (2, 1, 'Total');
-- INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
--    VALUES (2, 2, 'Standart');
-- INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
--    VALUES (2, 3, 'Latin');

/*==============================================================*/
/* Insert: Third competition                                    */
/*==============================================================*/

--IdProgram неправильно
-- INSERT INTO Competitions (IdCompetition, Country, Title, DateCompetition, Place, Rules, Organizers)
--    VALUES (3, 'Belarus', 'Open Championship', '18.04.2017', 'Belarus', 'IDSF', 'Belarusian Dance Federation');
   
-- INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
--    VALUES (3, 1, 'Standart');
-- INSERT INTO BallroomPrograms (IdCompetition, IdProgram, typeOfProgram)
--    VALUES (3, 2, 'Latin');



select Couples.PairNumber,  Couples.surnamePartner, Couples.namePartner, Partners.Country,
   Couples.surnameShepartner, Couples.nameShepartner, Shepartners.Country
from Couples, Partners, Shepartners 
where Couples.codePartner = Partners.codePartner and Couples.codePartner = Shepartners.codeShePartner;

select competitions.idcompetition, ballroomprograms.idprogram, ballroomprograms.typeOfProgram
from competitions, ballroomprograms 
where competitions.idcompetition = 1 and ballroomprograms.IdCompetition = 1;

select distinct Categories.CategoryName, Classes.ClassName
from consistClass, Categories, Classes
where consistClass.CategoryID = Categories.CategoryID 
   and consistClass.ClassID = Classes.ClassID
   and Categories.idcompetition = 1
order by Classes.ClassName, Categories.CategoryName; 


select Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram, count(Couples.PairNumber)
from Competitions 
   INNER JOIN BallroomPrograms 
      ON Competitions.idCompetition = BallroomPrograms.idCompetition
   INNER JOIN Categories 
      ON BallroomPrograms.idCompetition = Categories.idCompetition
   INNER JOIN consistClass
      ON Categories.idCompetition = consistClass.idCompetition
         and Categories.idProgram = consistClass.idProgram
            and Categories.CategoryID = consistClass.CategoryID
   INNER JOIN Classes
      ON consistClass.ClassID = Classes.ClassID
         and BallroomPrograms.idProgram = Categories.idProgram
   LEFT JOIN Couples
      ON Categories.idCompetition = Couples.idCompetition
         and Categories.idProgram = Couples.idProgram
            and Categories.CategoryID = Couples.CategoryID
               and Couples.ClassID = Classes.ClassID
where Competitions.idCompetition = 1
group by Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram
order by Classes.ClassName DESC, Categories.CategoryName DESC, BallroomPrograms.typeOfProgram DESC;

select Competitions.IdCompetition, Competitions.Title, Competitions.DateCompetition, Competitions.Place, Competitions.Rules, Competitions.Organizers,
Competitions.Country, count(Couples.codePartner)
from Competitions, Couples
group by Competitions.IdCompetition, Competitions.Title, Competitions.DateCompetition, Competitions.Place, Competitions.Rules, Competitions.Organizers,
Competitions.Country
where Competitions.IdCompetition = 1;


select distinct Couples.surnamePartner, Couples.namePartner, 
   Couples.surnameShepartner, Couples.nameShepartner,
   Classes.ClassName, Categories.CategoryName, BallroomPrograms.typeOfProgram
from Couples, Partners, Shepartners, Categories, Classes, BallroomPrograms, consistClass
where Couples.codePartner = Partners.codePartner 
   and Couples.codeShePartner = Shepartners.codeShePartner
   and Couples.ClassID = Classes.ClassID
   and Couples.IdProgram = Categories.IdProgram
   and Couples.CategoryID = Categories.CategoryID
   and Couples.CategoryID = consistClass.CategoryID
   and Couples.IdProgram = BallroomPrograms.IdProgram
   and Categories.IdProgram = BallroomPrograms.IdProgram
   and consistClass.IdProgram = Categories.IdProgram
   and consistClass.CategoryID = Categories.CategoryID 
   and BallroomPrograms.idcompetition = 1
order by BallroomPrograms.typeOfProgram DESC;

select distinct Couples.PairNumber, Couples.surnamePartner, Couples.namePartner, Partners.Country,
   Couples.surnameShepartner, Couples.nameShepartner, Shepartners.Country,
   Classes.ClassName, Categories.CategoryName, BallroomPrograms.typeOfProgram
from Couples, Partners, Shepartners, Categories, Classes, BallroomPrograms, consistClass
where Couples.codePartner = Partners.codePartner 
   and Couples.codeShePartner = Shepartners.codeShePartner
   and Couples.ClassID = Classes.ClassID
   and Couples.IdProgram = Categories.IdProgram
   and Couples.CategoryID = Categories.CategoryID
   and Couples.CategoryID = consistClass.CategoryID
   and Couples.IdProgram = BallroomPrograms.IdProgram
   and Categories.IdProgram = BallroomPrograms.IdProgram
   and consistClass.IdProgram = Categories.IdProgram
   and consistClass.CategoryID = Categories.CategoryID 
   and BallroomPrograms.idcompetition = 1
   and Classes.ClassName = 'B'
   and Categories.CategoryName = 'Youth 2'
   and BallroomPrograms.typeOfProgram = 'Standart'
order by Couples.PairNumber, BallroomPrograms.typeOfProgram DESC;

-- Partner
select * 
from Partners
where codePartner = 1;

--class program ballroom program
select Categories.CategoryID, Classes.ClassID, BallroomPrograms.idProgram
from Competitions 
   INNER JOIN BallroomPrograms 
      ON Competitions.idCompetition = BallroomPrograms.idCompetition
   INNER JOIN Categories 
      ON BallroomPrograms.idCompetition = Categories.idCompetition
   INNER JOIN consistClass
      ON Categories.idCompetition = consistClass.idCompetition
         and Categories.idProgram = consistClass.idProgram
            and Categories.CategoryID = consistClass.CategoryID
   INNER JOIN Classes
      ON consistClass.ClassID = Classes.ClassID
         and BallroomPrograms.idProgram = Categories.idProgram
where Competitions.idCompetition = 1
   and Categories.CategoryName = 'Adult'
   and Classes.ClassName = 'A'
   and BallroomPrograms.typeOfProgram = 'Standart'
group by Categories.CategoryID, Classes.ClassID, BallroomPrograms.idProgram;

-- couple
select * from Couples where PairNumber = 1
and IDCOMPETITION = 1 and IDPROGRAM = 2
and CATEGORYID = 3 and CLASSID = 3;

--partner
select namePartner, surnamePartner, Country
from Partners
where namePartner='Vladislav'and surnamePartner='Apukhtin' and Country='Ukraine'; 

-- select Categories.CategoryName, BallroomPrograms.typeOfProgram
-- from Categories, BallroomPrograms
-- where Categories.IdCompetition = 1 and BallroomPrograms.idcompetition = 1 
--    and Categories.IdCompetition = BallroomPrograms.IdCompetition;

--LEFT JOIN для FK_partIn
--позиция для order by Classes.ClassName DESC, Categories.CategoryName DESC;

-- select Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram, count(Couples.PairNumber)
-- from Competitions 
--    INNER JOIN BallroomPrograms 
--       ON Competitions.idCompetition = BallroomPrograms.idCompetition
--    INNER JOIN Categories 
--       ON BallroomPrograms.idCompetition = Categories.idCompetition
--          and BallroomPrograms.idProgram = Categories.idProgram
--    INNER JOIN Couples
--       ON Categories.idCompetition = Couples.idCompetition
--          and Categories.idProgram = Couples.idProgram
--             and Categories.CategoryID = Couples.CategoryID
--    INNER JOIN consistClass
--       on Categories.idCompetition = consistClass.idCompetition
--          and Categories.idProgram = consistClass.idProgram
--             and Categories.CategoryID = consistClass.CategoryID
--    INNER JOIN Classes
--       on consistClass.ClassID = Classes.ClassID
-- group by Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram
-- order by Classes.ClassName DESC, Categories.CategoryName DESC; 



