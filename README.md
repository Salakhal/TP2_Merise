# Gestion de Stock (Sortie) : Modélisation de la Base de Données

Ce document présente l'analyse et la modélisation des données (MCD et MLD) pour l'application de gestion des commandes et des stocks, basées sur l'énoncé fourni, et inclut le script SQL DDL pour la création des tables.

---

## 1. Dictionnaire de Données (DD)

| Nom symbolique | Description | Type | Commentaire / Contraintes | Entité / Association |
| :--- | :--- | :--- | :--- | :--- |
| **CodeProd** | Référence du produit | AN (Texte) | Clé primaire, Unique, obligatoire | Produit |
| **LibProd** | Libellé du produit | AN (Texte) | Obligatoire | Produit |
| **PrixUnit** | Prix unitaire du produit | N (Décimale) | $> 0$, obligatoire | Produit |
| **IdClient** | Identifiant du client | N (Entier) | Clé primaire, Unique, obligatoire | Client |
| **NomClient** | Nom du client | AN (Texte) | Obligatoire | Client |
| **PrenomClient** | Prénom du client | AN (Texte) | Obligatoire | Client |
| **AdresseClient** | Adresse du client | AN (Texte) | Obligatoire | Client |
| **NumCmd** | Numéro de commande | N (Entier) | Clé primaire, Unique, obligatoire | Commande |
| **DateCmd** | Date de la commande | Date | Obligatoire | Commande |
| **AdresseLiv** | Adresse de livraison | AN (Texte) | Obligatoire | Commande |
| **QteCmd** | Quantité commandée d’un produit | N (Entier) | $> 0$, obligatoire | Association Commande/Produit |

---

## 2. Règles de Gestion (RG)

* **RG1** : Un client peut passer **0** ou **plusieurs** commandes.
* **RG2** : Une commande est passée par **un seul** client.
* **RG3** : Une commande doit contenir **au moins 1** produit.
* **RG4** : Un produit peut être commandé **0** ou **plusieurs** fois.
* **RG5** : La quantité commandée (**QteCmd**) doit être strictement positive ($> 0$).
* **RG6** : Le prix unitaire d'un produit (**PrixUnit**) doit être strictement positif ($> 0$).

---

## 3. Modèle Conceptuel de Données (MCD)



**Entités** :
1.  **CLIENT** (<u>IdClient</u>, NomClient, PrenomClient, AdresseClient)
2.  **PRODUIT** (<u>CodeProd</u>, LibProd, PrixUnit)
3.  **COMMANDE** (<u>NumCmd</u>, DateCmd, AdresseLiv)

**Associations + Cardinalités** :
1.  **PASSER** : CLIENT **(0,N)** $\longleftarrow$ **PASSER** $\longrightarrow$ **(1,1)** COMMANDE
2.  **CONTENIR** : COMMANDE **(1,N)** $\longleftarrow$ **CONTENIR** (QteCmd) $\longrightarrow$ **(0,N)** PRODUIT

<img width="1249" height="568" alt="image" src="https://github.com/user-attachments/assets/c7de00b9-b122-4ad4-b9ae-de1f5965abc7" />

---

## 4. Modèle Logique de Données (MLD)

* **CLIENT** (**IdClient**, NomClient, PrenomClient, AdresseClient)
* **PRODUIT** (**CodeProd**, LibProd, PrixUnit)
* **COMMANDE** (**NumCmd**, DateCmd, AdresseLiv, IdClient\#)
* **LIGNE\_COMMANDE** (**NumCmd\#**, **CodeProd\#**, QteCmd)

<img width="1245" height="585" alt="image" src="https://github.com/user-attachments/assets/96e78954-4254-49d9-b71e-1c43d9151d78" />

---

## 5. Script SQL (DDL)

Ce script permet de créer les tables dans une base de données relationnelle (syntaxe MySQL/SQL standard).

```sql
-- Création de la table CLIENT
CREATE TABLE CLIENT (
    IdClient        INT             NOT NULL,
    NomClient       VARCHAR(50)     NOT NULL,
    PrenomClient    VARCHAR(50)     NOT NULL,
    AdresseClient   VARCHAR(100)    NOT NULL,
    PRIMARY KEY (IdClient)
);

-- Création de la table PRODUIT
CREATE TABLE PRODUIT (
    CodeProd        VARCHAR(10)     NOT NULL,
    LibProd         VARCHAR(100)    NOT NULL,
    PrixUnit        DECIMAL(10, 2)  NOT NULL CHECK (PrixUnit > 0),
    PRIMARY KEY (CodeProd)
);

-- Création de la table COMMANDE
-- L'IdClient (FK) est ajoutée suite à l'association 1-N (PASSER)
CREATE TABLE COMMANDE (
    NumCmd          INT             NOT NULL,
    DateCmd         DATE            NOT NULL,
    AdresseLiv      VARCHAR(100)    NOT NULL,
    IdClient        INT             NOT NULL,  -- Clé Étrangère (FK)
    PRIMARY KEY (NumCmd),
    FOREIGN KEY (IdClient) REFERENCES CLIENT(IdClient)
);

-- Création de la table de liaison LIGNE_COMMANDE
-- suite à l'association N-N (CONTENIR)
CREATE TABLE LIGNE_COMMANDE (
    NumCmd          INT             NOT NULL,  -- Clé Étrangère (FK)
    CodeProd        VARCHAR(10)     NOT NULL,  -- Clé Étrangère (FK)
    QteCmd          INT             NOT NULL CHECK (QteCmd > 0),
    PRIMARY KEY (NumCmd, CodeProd),            -- Clé Primaire Composite
    FOREIGN KEY (NumCmd) REFERENCES COMMANDE(NumCmd),
    FOREIGN KEY (CodeProd) REFERENCES PRODUIT(CodeProd)
);
