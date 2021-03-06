-- Jennifer Lin, jlin123
-- Tanner Amundsen, tamunds1

DROP TABLE IF EXISTS DailyCOVID19Reports;
DROP TABLE IF EXISTS Population;
DROP TABLE IF EXISTS Education;
DROP TABLE IF EXISTS LaborForce;
DROP TABLE IF EXISTS Travel;
DROP TABLE IF EXISTS Health;
DROP TABLE IF EXISTS GDP;
DROP TABLE IF EXISTS ImportsFrom;
DROP TABLE IF EXISTS ExportsTo;
DROP TABLE IF EXISTS Country;

CREATE TABLE Country (
  countryId INTEGER NOT NULL,
  name VARCHAR(40) NOT NULL,
  PRIMARY KEY (countryId)
);

CREATE TABLE DailyCOVID19Reports (
  countryId INTEGER NOT NULL,
  date DATE NOT NULL,
  numConfirmed INTEGER,
  numDeaths INTEGER,
  numRecovered INTEGER,
  PRIMARY KEY (countryId, date),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE Population (
  countryId INTEGER NOT NULL,
  estPopSize FLOAT(2),
  popDensity FLOAT(1),
  rateIncrease NUMERIC(3, 1),
  lifeExpectancy NUMERIC(3, 1),
  mortalityRate NUMERIC(3, 1),
  fertilityRate NUMERIC(3, 1),
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE Education (
  countryId INTEGER NOT NULL,
  totalPublicExp NUMERIC(3, 1),
  primaryEdPercent NUMERIC(3, 1),
  secondaryEdPercent NUMERIC(3, 1),
  tertiaryEdPercent NUMERIC(3, 1),
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE LaborForce (
  countryId INTEGER NOT NULL,
  laborForceParticipationRate NUMERIC(3, 1),
  unemploymentRate NUMERIC(3, 1),
  percentEmplAgriculture NUMERIC(3, 1),
  percentEmplIndustry NUMERIC(3, 1),
  percentEmplServices NUMERIC(3, 1),
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE Travel (
  countryId INTEGER NOT NULL,
  migrantPercentOfPop NUMERIC(3, 1),
  numRefugeesAndAsylum INTEGER,
  tourismExp INTEGER,
  numTourists INTEGER,
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE Health (
  countryId INTEGER NOT NULL,
  healthExp NUMERIC(3,1),
  physiciansPer1000 NUMERIC(2,1),
  popUsingSafeSanitationFacilities NUMERIC(3,1),
  popUsingSafeWaterServices NUMERIC(3,1),
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE GDP (
  countryId INTEGER NOT NULL,
  gdp INTEGER,
  gdpPerCapita INTEGER,
  rdGDPExp NUMERIC(3,1),
  healthGDPExp NUMERIC(3,1),
  PRIMARY KEY (countryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId)
);

CREATE TABLE ImportsFrom (
  countryId INTEGER NOT NULL,
  importFromCountryId INTEGER NOT NULL,
  percentImportOfTotalTrade NUMERIC(3,1),
  PRIMARY KEY (countryId, importFromCountryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId),
  FOREIGN KEY (importFromCountryId) REFERENCES Country (countryId)
);

CREATE TABLE ExportsTo (
  countryId INTEGER NOT NULL,
  exportToCountryId INTEGER NOT NULL,
  percentExportOfTotalTrade NUMERIC(3,1),
  PRIMARY KEY (countryId, exportToCountryId),
  FOREIGN KEY (countryId) REFERENCES Country (countryId),
  FOREIGN KEY (exportToCountryId) REFERENCES Country (countryId)
);

LOAD DATA LOCAL INFILE './full_relation_data/country.txt'
 INTO TABLE Country
 FIELDS TERMINATED BY '/'
 IGNORE 1 LINES;

LOAD DATA LOCAL INFILE './full_relation_data/laborForce.txt'
 INTO TABLE LaborForce
 FIELDS TERMINATED BY ' '
 IGNORE 1 LINES
 (countryId, @vlaborForceParticipationRate, @vunemploymentRate,
   @vpercentEmplAgriculture, @vpercentEmplIndustry, @vpercentEmplServices)
 SET
 laborForceParticipationRate = nullif(@vlaborForceParticipationRate,'NULL'),
 unemploymentRate = nullif(@vunemploymentRate,'NULL'),
 percentEmplAgriculture = nullif(@vpercentEmplAgriculture,'NULL'),
 percentEmplIndustry = nullif(@vpercentEmplIndustry,'NULL'),
 percentEmplServices = nullif(@vpercentEmplServices,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/population.txt'
 INTO TABLE Population
 FIELDS TERMINATED BY ' '
 IGNORE 1 LINES
 (countryId, @vestPopSize, @vpopDensity, @vrateIncrease, @vlifeExpectancy,
   @vmortalityRate, @vfertilityRate)
 SET
 estPopSize = nullif(@vestPopSize,'NULL'),
 popDensity = nullif(@vpopDensity,'NULL'),
 rateIncrease = nullif(@vrateIncrease,'NULL'),
 lifeExpectancy = nullif(@vlifeExpectancy,'NULL'),
 mortalityRate = nullif(@vmortalityRate,'NULL'),
 fertilityRate = nullif(@vfertilityRate,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/education.txt'
 INTO TABLE Education
 FIELDS TERMINATED BY ' '
 IGNORE 1 LINES
 (countryId, @vtotalPublicExp, @vprimaryEdPercent, @vsecondaryEdPercent,
   @vtertiaryEdPercent)
 SET
 totalPublicExp = nullif(@vtotalPublicExp,'NULL'),
 primaryEdPercent = nullif(@vprimaryEdPercent,'NULL'),
 secondaryEdPercent = nullif(@vsecondaryEdPercent,'NULL'),
 tertiaryEdPercent = nullif(@vtertiaryEdPercent,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/dailyCOVID19.txt'
 INTO TABLE DailyCOVID19Reports
 FIELDS TERMINATED BY ' '
 IGNORE 1 LINES;

LOAD DATA LOCAL INFILE './full_relation_data/travel.txt'
 INTO TABLE Travel
 FIELDS TERMINATED BY ','
 IGNORE 1 LINES
 (countryId, @vmigrantPercentOfPop, @vnumRefugeesAndAsylum,
   @vtourismExp, @vnumTourists)
 SET
 migrantPercentOfPop = nullif(@vmigrantPercentOfPop,'NULL'),
 numRefugeesAndAsylum = nullif(@vnumRefugeesAndAsylum,'NULL'),
 tourismExp = nullif(@vtourismExp,'NULL'),
 numTourists = nullif(@vnumTourists,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/health.txt'
 INTO TABLE Health
 FIELDS TERMINATED BY ','
 IGNORE 1 LINES
 (countryId, @vhealthExp, @vphysiciansPer1000, @vpopUsingSafeSanitationFacilities,
   @vpopUsingSafeWaterServices)
 SET
 healthExp = nullif(@vhealthExp,'NULL'),
 physiciansPer1000 = nullif(@vphysiciansPer1000,'NULL'),
 popUsingSafeSanitationFacilities = nullif(@vpopUsingSafeSanitationFacilities,'NULL'),
 popUsingSafeWaterServices = nullif(@vpopUsingSafeWaterServices,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/gdp.txt'
 INTO TABLE GDP
 FIELDS TERMINATED BY ','
 IGNORE 1 LINES
 (countryId, @vgdp, @vgdpPerCapita, @vrdGDPExp, @vhealthGDPExp)
 SET
 gdp = nullif(@vgdp,'NULL'),
 gdpPerCapita = nullif(@vgdpPerCapita,'NULL'),
 rdGDPExp = nullif(@vrdGDPExp,'NULL'),
 healthGDPExp = nullif(@vhealthGDPExp,'NULL');

LOAD DATA LOCAL INFILE './full_relation_data/importsFrom.txt'
 INTO TABLE ImportsFrom
 FIELDS TERMINATED BY ','
 IGNORE 1 LINES;

LOAD DATA LOCAL INFILE './full_relation_data/exportsTo.txt'
 INTO TABLE ExportsTo
 FIELDS TERMINATED BY ','
 IGNORE 1 LINES;

delimiter //
DROP PROCEDURE IF EXISTS CovidSortBy //
CREATE PROCEDURE CovidSortBy(IN covid_date VARCHAR(40), covid_attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
    DailyCOVID19Reports.numConfirmed,
    DailyCOVID19Reports.numDeaths,
    DailyCOVID19Reports.numRecovered
  FROM DailyCOVID19Reports, Country
  WHERE DailyCOVID19Reports.countryId = Country.countryId
    AND date = covid_date
  ORDER BY
  CASE WHEN (covid_attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (covid_attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (covid_attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC;
END;
//
DROP PROCEDURE IF EXISTS CovidByCountry //
CREATE PROCEDURE CovidByCountry(IN covid_date VARCHAR(40), country VARCHAR(40))
BEGIN
  SELECT Country.name,
    DailyCOVID19Reports.numConfirmed,
    DailyCOVID19Reports.numDeaths,
    DailyCOVID19Reports.numRecovered
  FROM DailyCOVID19Reports, Country
  WHERE DailyCOVID19Reports.countryId = Country.countryId
    AND date = covid_date
      AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS CovidTimeSeries //
CREATE PROCEDURE CovidTimeSeries(IN country VARCHAR(40))
BEGIN
  SELECT DailyCOVID19Reports.date,
    DailyCOVID19Reports.numConfirmed,
    DailyCOVID19Reports.numDeaths,
    DailyCOVID19Reports.numRecovered
  FROM DailyCOVID19Reports, Country
  WHERE DailyCOVID19Reports.countryId = Country.countryId
    AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS PopulationByCountry //
CREATE PROCEDURE PopulationByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   Population.estPopSize,
   Population.popDensity,
   Population.rateIncrease,
   Population.lifeExpectancy,
   Population.mortalityRate,
   Population.fertilityRate,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Population, Country, DailyCOVID19Reports
  WHERE Population.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS EducationByCountry //
CREATE PROCEDURE EducationByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   Education.totalPublicExp,
   Education.primaryEdPercent,
   Education.secondaryEdPercent,
   Education.tertiaryEdPercent,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Education, Country, DailyCOVID19Reports
  WHERE Education.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS LaborForceByCountry //
CREATE PROCEDURE LaborForceByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   LaborForce.laborForceParticipationRate,
   LaborForce.unemploymentRate,
   LaborForce.percentEmplAgriculture,
   LaborForce.percentEmplIndustry,
   LaborForce.percentEmplServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM LaborForce, Country, DailyCOVID19Reports
  WHERE LaborForce.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS TravelByCountry //
CREATE PROCEDURE TravelByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   Travel.migrantPercentOfPop,
   Travel.numRefugeesAndAsylum,
   Travel.tourismExp,
   Travel.numTourists,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Travel, Country, DailyCOVID19Reports
  WHERE Travel.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS HealthByCountry //
CREATE PROCEDURE HealthByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   Health.healthExp,
   Health.physiciansPer1000,
   Health.popUsingSafeSanitationFacilities,
   Health.popUsingSafeWaterServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Health, Country, DailyCOVID19Reports
  WHERE Health.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS GDPByCountry //
CREATE PROCEDURE GDPByCountry(country VARCHAR(40))
BEGIN
  SELECT Country.name,
   GDP.gdp,
   GDP.gdpPerCapita,
   GDP.rdGDPExp,
   GDP.healthGDPExp,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM GDP, Country, DailyCOVID19Reports
  WHERE GDP.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'
     AND Country.name = country;
END;
//
DROP PROCEDURE IF EXISTS PopulationCovid //
CREATE PROCEDURE PopulationCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Population.estPopSize,
   Population.popDensity,
   Population.rateIncrease,
   Population.lifeExpectancy,
   Population.mortalityRate,
   Population.fertilityRate,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM Population, Country, DailyCOVID19Reports
  WHERE Population.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS EducationCovid //
CREATE PROCEDURE EducationCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Education.totalPublicExp,
   Education.primaryEdPercent,
   Education.secondaryEdPercent,
   Education.tertiaryEdPercent,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM Education, Country, DailyCOVID19Reports
  WHERE Education.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS LaborForceCovid //
CREATE PROCEDURE LaborForceCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   LaborForce.laborForceParticipationRate,
   LaborForce.unemploymentRate,
   LaborForce.percentEmplAgriculture,
   LaborForce.percentEmplIndustry,
   LaborForce.percentEmplServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM LaborForce, Country, DailyCOVID19Reports
  WHERE LaborForce.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS TravelCovid //
CREATE PROCEDURE TravelCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Travel.migrantPercentOfPop,
   Travel.numRefugeesAndAsylum,
   Travel.tourismExp,
   Travel.numTourists,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Travel, Country, DailyCOVID19Reports
  WHERE Travel.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS HealthCovid //
CREATE PROCEDURE HealthCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Health.healthExp,
   Health.physiciansPer1000,
   Health.popUsingSafeSanitationFacilities,
   Health.popUsingSafeWaterServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Health, Country, DailyCOVID19Reports
  WHERE Health.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS GDPCovid //
CREATE PROCEDURE GDPCovid(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   GDP.gdp,
   GDP.gdpPerCapita,
   GDP.rdGDPExp,
   GDP.healthGDPExp,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM GDP, Country, DailyCOVID19Reports
  WHERE GDP.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numConfirmed') THEN DailyCOVID19Reports.numConfirmed END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numDeaths') THEN DailyCOVID19Reports.numDeaths END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRecovered') THEN DailyCOVID19Reports.numRecovered END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS ImportsByCountry //
CREATE PROCEDURE ImportsByCountry(country VARCHAR(40))
BEGIN
  SELECT countryId INTO @mainCountryId FROM Country WHERE name = country;
  SELECT Country.name,
   ImportsFrom.percentImportOfTotalTrade,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM ImportsFrom, Country, DailyCOVID19Reports
  WHERE ImportsFrom.countryId = @mainCountryId
  AND ImportsFrom.importFromCountryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08';
END;
//
DROP PROCEDURE IF EXISTS ExportsByCountry //
CREATE PROCEDURE ExportsByCountry(country VARCHAR(40))
BEGIN
  SELECT countryId INTO @mainCountryId FROM Country WHERE name = country;
  SELECT Country.name,
   ExportsTo.percentExportOfTotalTrade,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM ExportsTo, Country, DailyCOVID19Reports
  WHERE ExportsTo.countryId = @mainCountryId
  AND ExportsTo.exportToCountryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08';
END;
//
DROP PROCEDURE IF EXISTS PopulationThree //
CREATE PROCEDURE PopulationThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Population.estPopSize,
   Population.popDensity,
   Population.rateIncrease,
   Population.lifeExpectancy,
   Population.mortalityRate,
   Population.fertilityRate,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM Population, Country, DailyCOVID19Reports
  WHERE Population.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'estPopSize') THEN Population.estPopSize END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'estPopSize') THEN Population.estPopSize END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'popDensity') THEN Population.popDensity END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'popDensity') THEN Population.popDensity END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'rateIncrease') THEN Population.rateIncrease END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'rateIncrease') THEN Population.rateIncrease END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'lifeExpectancy') THEN Population.lifeExpectancy END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'lifeExpectancy') THEN Population.lifeExpectancy END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'mortalityRate') THEN Population.mortalityRate END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'mortalityRate') THEN Population.mortalityRate END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'fertilityRate') THEN Population.fertilityRate END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'fertilityRate') THEN Population.fertilityRate END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS EducationThree //
CREATE PROCEDURE EducationThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Education.totalPublicExp,
   Education.primaryEdPercent,
   Education.secondaryEdPercent,
   Education.tertiaryEdPercent,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM Education, Country, DailyCOVID19Reports
  WHERE Education.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'totalPublicExp') THEN Education.totalPublicExp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'totalPublicExp') THEN Education.totalPublicExp END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'primaryEdPercent') THEN Education.primaryEdPercent END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'primaryEdPercent') THEN Education.primaryEdPercent END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'secondaryEdPercent') THEN Education.secondaryEdPercent END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'secondaryEdPercent') THEN Education.secondaryEdPercent END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'tertiaryEdPercent') THEN Education.tertiaryEdPercent END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'tertiaryEdPercent') THEN Education.tertiaryEdPercent END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS LaborForceThree //
CREATE PROCEDURE LaborForceThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   LaborForce.laborForceParticipationRate,
   LaborForce.unemploymentRate,
   LaborForce.percentEmplAgriculture,
   LaborForce.percentEmplIndustry,
   LaborForce.percentEmplServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered

  FROM LaborForce, Country, DailyCOVID19Reports
  WHERE LaborForce.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'laborForceParticipationRate') THEN LaborForce.laborForceParticipationRate END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'laborForceParticipationRate') THEN LaborForce.laborForceParticipationRate END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'unemploymentRate') THEN LaborForce.unemploymentRate END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'unemploymentRate') THEN LaborForce.unemploymentRate END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'percentEmplAgriculture') THEN LaborForce.percentEmplAgriculture END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'percentEmplAgriculture') THEN LaborForce.percentEmplAgriculture END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'percentEmplIndustry') THEN LaborForce.percentEmplIndustry END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'percentEmplIndustry') THEN LaborForce.percentEmplIndustry END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'percentEmplServices') THEN LaborForce.percentEmplServices END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'percentEmplServices') THEN LaborForce.percentEmplServices END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS TravelThree //
CREATE PROCEDURE TravelThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Travel.migrantPercentOfPop,
   Travel.numRefugeesAndAsylum,
   Travel.tourismExp,
   Travel.numTourists,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Travel, Country, DailyCOVID19Reports
  WHERE Travel.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'migrantPercentOfPop') THEN Travel.migrantPercentOfPop END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'migrantPercentOfPop') THEN Travel.migrantPercentOfPop END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numRefugeesAndAsylum') THEN Travel.numRefugeesAndAsylum END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numRefugeesAndAsylum') THEN Travel.numRefugeesAndAsylum END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'tourismExp') THEN Travel.tourismExp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'tourismExp') THEN Travel.tourismExp END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'numTourists') THEN Travel.numTourists END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'numTourists') THEN Travel.numTourists END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS HealthThree //
CREATE PROCEDURE HealthThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   Health.healthExp,
   Health.physiciansPer1000,
   Health.popUsingSafeSanitationFacilities,
   Health.popUsingSafeWaterServices,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM Health, Country, DailyCOVID19Reports
  WHERE Health.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'healthExp') THEN Health.healthExp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'healthExp') THEN Health.healthExp END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'physiciansPer1000') THEN Health.physiciansPer1000 END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'physiciansPer1000') THEN Health.physiciansPer1000 END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'popUsingSafeSanitationFacilities') THEN Health.popUsingSafeSanitationFacilities END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'popUsingSafeSanitationFacilities') THEN Health.popUsingSafeSanitationFacilities END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'popUsingSafeWaterServices') THEN Health.popUsingSafeWaterServices END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'popUsingSafeWaterServices') THEN Health.popUsingSafeWaterServices END ASC

  LIMIT num;
END;
//
DROP PROCEDURE IF EXISTS GDPThree //
CREATE PROCEDURE GDPThree(topbottom VARCHAR(10), num SMALLINT, attribute VARCHAR(40))
BEGIN
  SELECT Country.name,
   GDP.gdp,
   GDP.gdpPerCapita,
   GDP.rdGDPExp,
   GDP.healthGDPExp,
   DailyCOVID19Reports.numConfirmed,
   DailyCOVID19Reports.numDeaths,
   DailyCOVID19Reports.numRecovered
  FROM GDP, Country, DailyCOVID19Reports
  WHERE GDP.countryId = Country.countryId
   AND DailyCOVID19Reports.countryId = Country.countryId
    AND DailyCOVID19Reports.date = '2020-05-08'

  ORDER BY
  CASE WHEN (topbottom = 'top' AND attribute = 'gdp') THEN GDP.gdp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'gdp') THEN GDP.gdp END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'gdpPerCapita') THEN GDP.gdpPerCapita END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'gdpPerCapita') THEN GDP.gdpPerCapita END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'rdGDPExp') THEN GDP.rdGDPExp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'rdGDPExp') THEN GDP.rdGDPExp END ASC,
  CASE WHEN (topbottom = 'top' AND attribute = 'healthGDPExp') THEN GDP.healthGDPExp END DESC,
  CASE WHEN (topbottom  = 'bottom' AND attribute = 'healthGDPExp') THEN GDP.healthGDPExp END ASC

  LIMIT num;
END;
//
delimiter ;
