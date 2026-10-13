-- E-shop: 9 tables, 8 foreign keys, 31 supplied rows.
-- MySQL / InnoDB. Run in a new schema; rename eshop_diagram if necessary.
-- Original VARCHAR(256) fields and ON DELETE CASCADE rules are preserved.
-- SERIAL is replaced with INT AUTO_INCREMENT, matching the INT foreign keys.
-- The original DROP statements are intentionally not included.
-- Diagram import into MySQL Workbench does not itself load the INSERT data.

CREATE DATABASE IF NOT EXISTS eshop_diagram
    DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eshop_diagram;
SET NAMES utf8mb4;

CREATE TABLE doprava (
    id_dopravy INT NOT NULL AUTO_INCREMENT,
    cena_dopravy VARCHAR(256) NOT NULL,
    dodaci_doba VARCHAR(256) NOT NULL,
    CONSTRAINT pk_doprava PRIMARY KEY (id_dopravy)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE kategorie (
    id_kategorie INT NOT NULL AUTO_INCREMENT,
    nazev_kategorie VARCHAR(256) NOT NULL,
    CONSTRAINT pk_kategorie PRIMARY KEY (id_kategorie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE zakaznik (
    id_zakaznika INT NOT NULL AUTO_INCREMENT,
    jmeno VARCHAR(256) NOT NULL,
    prijmeni VARCHAR(256) NOT NULL,
    email VARCHAR(256) NOT NULL,
    heslo VARCHAR(256) NOT NULL,
    telefon VARCHAR(256) NOT NULL,
    CONSTRAINT pk_zakaznik PRIMARY KEY (id_zakaznika)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE adresa_zakaznika (
    id_adresy INT NOT NULL AUTO_INCREMENT,
    id_zakaznika INT NOT NULL,
    ulice VARCHAR(256) NOT NULL,
    mesto VARCHAR(256) NOT NULL,
    psc VARCHAR(256) NOT NULL,
    stat VARCHAR(256) NOT NULL,
    datum_zmeny VARCHAR(256) NOT NULL,
    telefon VARCHAR(256) NOT NULL,
    CONSTRAINT pk_adresa_zakaznika PRIMARY KEY (id_adresy),
    CONSTRAINT fk_adresa_zakaznika FOREIGN KEY (id_zakaznika) REFERENCES zakaznik (id_zakaznika) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE objednavka (
    id_objednavky INT NOT NULL AUTO_INCREMENT,
    id_dopravy INT NOT NULL,
    id_zakaznika INT NOT NULL,
    datum_objednani VARCHAR(256) NOT NULL,
    datum_zaslano VARCHAR(256) NOT NULL,
    datum_doruceno VARCHAR(256) NOT NULL,
    stav_objednavky VARCHAR(256) NOT NULL,
    celkova_castka VARCHAR(256) NOT NULL,
    CONSTRAINT pk_objednavka PRIMARY KEY (id_objednavky),
    CONSTRAINT fk_objednavka_doprava FOREIGN KEY (id_dopravy) REFERENCES doprava (id_dopravy) ON DELETE CASCADE,
    CONSTRAINT fk_objednavka_zakaznik FOREIGN KEY (id_zakaznika) REFERENCES zakaznik (id_zakaznika) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE produkt (
    id_produktu INT NOT NULL AUTO_INCREMENT,
    id_kategorie INT NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    cena VARCHAR(256) NOT NULL,
    popis VARCHAR(256) NOT NULL,
    mnozstvi VARCHAR(256) NOT NULL,
    CONSTRAINT pk_produkt PRIMARY KEY (id_produktu),
    CONSTRAINT fk_produkt_kategorie FOREIGN KEY (id_kategorie) REFERENCES kategorie (id_kategorie) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE polozka_objednavky (
    id_polozky INT NOT NULL AUTO_INCREMENT,
    id_objednavky INT NOT NULL,
    id_produktu INT NOT NULL,
    pocet_kusu VARCHAR(256) NOT NULL,
    cena_kusu VARCHAR(256) NOT NULL,
    CONSTRAINT pk_polozka_objednavky PRIMARY KEY (id_polozky),
    CONSTRAINT fk_pol_obj_objednavka FOREIGN KEY (id_objednavky) REFERENCES objednavka (id_objednavky) ON DELETE CASCADE,
    CONSTRAINT fk_pol_obj_produkt FOREIGN KEY (id_produktu) REFERENCES produkt (id_produktu) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sklad (
    id_skladu INT NOT NULL AUTO_INCREMENT,
    nazev_skladu VARCHAR(256) NOT NULL,
    adresa VARCHAR(256) NOT NULL,
    kapacita VARCHAR(256) NOT NULL,
    CONSTRAINT pk_sklad PRIMARY KEY (id_skladu)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sklad_produkt (
    id_skladu INT NOT NULL,
    id_produktu INT NOT NULL,
    CONSTRAINT pk_sklad_produkt PRIMARY KEY (id_skladu, id_produktu),
    CONSTRAINT fk_sklad_produkt_sklad FOREIGN KEY (id_skladu) REFERENCES sklad (id_skladu) ON DELETE CASCADE,
    CONSTRAINT fk_sklad_produkt_produkt FOREIGN KEY (id_produktu) REFERENCES produkt (id_produktu) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Supplied sample data
START TRANSACTION;
INSERT INTO doprava (id_dopravy, cena_dopravy, dodaci_doba) VALUES (1, '99', '2 dny');
INSERT INTO doprava (id_dopravy, cena_dopravy, dodaci_doba) VALUES (2, '0', '5 dní');
INSERT INTO doprava (id_dopravy, cena_dopravy, dodaci_doba) VALUES (3, '150', '24 hodin');
INSERT INTO kategorie (id_kategorie, nazev_kategorie) VALUES (1, 'Laptopy');
INSERT INTO kategorie (id_kategorie, nazev_kategorie) VALUES (2, 'Elektronika');
INSERT INTO kategorie (id_kategorie, nazev_kategorie) VALUES (3, 'Příslušenství');
INSERT INTO kategorie (id_kategorie, nazev_kategorie) VALUES (4, 'Knihy');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (1, 2, 'iPhone 15', '25000', 'Nejnovější telefon', '100');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (2, 3, 'USB Kabel', '90', 'Levný kabel', '500');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (3, 2, 'Herní PC Ultra', '60000', 'Výkonný počítač', '5');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (4, 1, 'MacBook Pro', '45000', 'Laptop pro práci', '20');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (5, 1, 'Dell XPS', '40000', 'Windows laptop', '15');
INSERT INTO produkt (id_produktu, id_kategorie, nazev, cena, popis, mnozstvi) VALUES (6, 2, 'Starý Tablet', '2000', 'Nikdo ho nechce', '10');
INSERT INTO sklad (id_skladu, nazev_skladu, adresa, kapacita) VALUES (1, 'Hlavní sklad', 'Průmyslová 1', '10000');
INSERT INTO sklad (id_skladu, nazev_skladu, adresa, kapacita) VALUES (2, 'Sklad Brno', 'Brněnská 5', '5000');
INSERT INTO sklad_produkt (id_skladu, id_produktu) VALUES (1, 1);
INSERT INTO sklad_produkt (id_skladu, id_produktu) VALUES (2, 1);
INSERT INTO sklad_produkt (id_skladu, id_produktu) VALUES (1, 5);
INSERT INTO zakaznik (id_zakaznika, jmeno, prijmeni, email, heslo, telefon) VALUES (1, 'Jan', 'Novák', 'jan.novak@email.cz', 'pass123', '+420111222333');
INSERT INTO zakaznik (id_zakaznika, jmeno, prijmeni, email, heslo, telefon) VALUES (2, 'Jana', 'Bohatá', 'jana.bohata@email.cz', 'secure456', '+420999888777');
INSERT INTO zakaznik (id_zakaznika, jmeno, prijmeni, email, heslo, telefon) VALUES (3, 'Petr', 'Smutný', 'petr@email.cz', '12345', '+420000000000');
INSERT INTO adresa_zakaznika (id_adresy, id_zakaznika, ulice, mesto, psc, stat, datum_zmeny, telefon) VALUES (1, 1, 'Václavské nám. 1', 'Praha', '11000', 'ČR', '2023-01-01', '+420111222333');
INSERT INTO adresa_zakaznika (id_adresy, id_zakaznika, ulice, mesto, psc, stat, datum_zmeny, telefon) VALUES (2, 2, 'Hlavní 5', 'Brno', '60200', 'ČR', '2023-01-01', '+420999888777');
INSERT INTO objednavka (id_objednavky, id_dopravy, id_zakaznika, datum_objednani, datum_zaslano, datum_doruceno, stav_objednavky, celkova_castka) VALUES (1, 1, 1, '2023-10-01', '2023-10-02', '2023-10-03', 'Doručeno', '25090');
INSERT INTO objednavka (id_objednavky, id_dopravy, id_zakaznika, datum_objednani, datum_zaslano, datum_doruceno, stav_objednavky, celkova_castka) VALUES (2, 2, 2, '2023-11-15', '2023-11-16', '2023-11-17', 'Zpracováno', '45000');
INSERT INTO objednavka (id_objednavky, id_dopravy, id_zakaznika, datum_objednani, datum_zaslano, datum_doruceno, stav_objednavky, celkova_castka) VALUES (3, 3, 2, '2023-11-20', '2023-11-21', '2023-11-22', 'Odesláno', '40000');
INSERT INTO polozka_objednavky (id_polozky, id_objednavky, id_produktu, pocet_kusu, cena_kusu) VALUES (1, 1, 1, '1', '25000');
INSERT INTO polozka_objednavky (id_polozky, id_objednavky, id_produktu, pocet_kusu, cena_kusu) VALUES (2, 1, 2, '1', '90');
INSERT INTO polozka_objednavky (id_polozky, id_objednavky, id_produktu, pocet_kusu, cena_kusu) VALUES (3, 2, 4, '1', '45000');
INSERT INTO polozka_objednavky (id_polozky, id_objednavky, id_produktu, pocet_kusu, cena_kusu) VALUES (4, 3, 5, '1', '40000');
INSERT INTO kategorie (nazev_kategorie) VALUES ('Výprodej');
COMMIT;
