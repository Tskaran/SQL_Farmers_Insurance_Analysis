-- ============================================================
-- SQL Assignment: Farmers Insurance Analysis
-- Assignment ID: SQL/02
-- Dataset: PMFBY (Pradhan Mantri Fasal Bima Yojana)
-- Database: ndap
-- ------------------------------------------------------------
-- Group Name  : Thairu_Heta_Jai_Likith
-- Team Members:
--   1. Thairu Shiva Ram Karan
--   2. Heta Bhatt
--   3. Jai Raj Singh
--   4. Likith L
-- ============================================================
-- SCALING NOTES:
--   FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount,
--   GrossPremiumAmountToBePaid, SumInsured  → stored in LAKHS (×1,00,000)
--   InsuredLandArea                          → stored in THOUSAND HECTARES (×1,000)
--   1 crore = 100 lakhs  →  column value of 100 = 1 crore
--   500,000 INR = 5 lakhs → column value of 5
-- ============================================================

USE ndap;

-- ----------------------------------------------------------------------------------------------
-- SECTION 1.
-- SELECT Queries [5 Marks]

-- Q1. Retrieve the names of all states (srcStateName) from the dataset.
-- [2 Marks]

SELECT DISTINCT srcStateName
FROM FarmersInsuranceData
ORDER BY srcStateName;

-- ###

-- Q2. Retrieve the total number of farmers covered (TotalFarmersCovered)
--     and the sum insured (SumInsured) for each state (srcStateName),
--     ordered by TotalFarmersCovered in descending order.
-- [3 Marks]

SELECT
    srcStateName,
    SUM(TotalFarmersCovered)  AS TotalFarmersCovered,
    SUM(SumInsured)           AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;

-- ###

-- --------------------------------------------------------------------------------------
-- SECTION 2.
-- Filtering Data (WHERE) [15 Marks]

-- Q3. Retrieve all records where Year is '2020'.
-- [2 Marks]

SELECT *
FROM FarmersInsuranceData
WHERE srcYear = 2020;

-- ###

-- Q4. Retrieve all rows where the TotalPopulationRural is greater than 1 million
--     and the srcStateName is 'HIMACHAL PRADESH'.
-- [3 Marks]

SELECT *
FROM FarmersInsuranceData
WHERE TotalPopulationRural > 1000000
  AND srcStateName = 'HIMACHAL PRADESH';

-- ###

-- Q5. Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount
--     for each district in the year 2018,
--     ordered by FarmersPremiumAmount in ascending order.
-- [5 Marks]

SELECT
    srcStateName,
    srcDistrictName,
    SUM(FarmersPremiumAmount) AS TotalFarmersPremiumAmount
FROM FarmersInsuranceData
WHERE srcYear = 2018
GROUP BY srcStateName, srcDistrictName
ORDER BY TotalFarmersPremiumAmount ASC;

-- ###

-- Q6. Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of
--     premiums (GrossPremiumAmountToBePaid) for each state (srcStateName)
--     where the insured land area (InsuredLandArea) is greater than 5.0 and Year is 2018.
-- [5 Marks]

SELECT
    srcStateName,
    SUM(TotalFarmersCovered)        AS TotalFarmersCovered,
    SUM(GrossPremiumAmountToBePaid) AS TotalGrossPremium
FROM FarmersInsuranceData
WHERE InsuredLandArea > 5.0
  AND srcYear = 2018
GROUP BY srcStateName;

-- ###

-- ------------------------------------------------------------------------------------------------
-- SECTION 3.
-- Aggregation (GROUP BY) [10 Marks]

-- Q7. Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
-- [3 Marks]

SELECT
    srcYear,
    AVG(InsuredLandArea) AS AvgInsuredLandArea
FROM FarmersInsuranceData
GROUP BY srcYear
ORDER BY srcYear;

-- ###

-- Q8. Calculate the total number of farmers covered (TotalFarmersCovered)
--     for each district (srcDistrictName) where Insurance units is greater than 0.
-- [3 Marks]

SELECT
    srcDistrictName,
    SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE `Insurance units` > 0
GROUP BY srcDistrictName
ORDER BY TotalFarmersCovered DESC;

-- ###

-- Q9. For each state (srcStateName), calculate the total premium amounts
--     (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount)
--     and the total number of farmers covered (TotalFarmersCovered).
--     Only include records where SumInsured > 500,000 INR.
--     Note: SumInsured is stored in lakhs, so 500,000 INR = 5 lakhs → column value > 5
-- [4 Marks]

SELECT
    srcStateName,
    SUM(FarmersPremiumAmount)  AS TotalFarmersPremium,
    SUM(StatePremiumAmount)    AS TotalStatePremium,
    SUM(GOVPremiumAmount)      AS TotalGOVPremium,
    SUM(TotalFarmersCovered)   AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE SumInsured > 5
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 4.
-- Sorting Data (ORDER BY) [10 Marks]

-- Q10. Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation
--      in the year 2020.
-- [2 Marks]

SELECT
    srcDistrictName,
    srcStateName,
    TotalPopulation
FROM FarmersInsuranceData
WHERE srcYear = 2020
ORDER BY TotalPopulation DESC
LIMIT 5;

-- ###

-- Q11. Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts
--      with the lowest non-zero FarmersPremiumAmount,
--      ordered by SumInsured and then FarmersPremiumAmount.
-- [3 Marks]

SELECT
    srcStateName,
    srcDistrictName,
    SumInsured,
    FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > 0
ORDER BY SumInsured ASC, FarmersPremiumAmount ASC
LIMIT 10;

-- ###

-- Q12. Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the
--      ratio of insured farmers (TotalFarmersCovered) to total population (TotalPopulation)
--      is highest. Sort by the ratio in descending order.
-- [5 Marks]

SELECT
    srcStateName,
    srcYear,
    SUM(TotalFarmersCovered)                                         AS TotalFarmersCovered,
    SUM(TotalPopulation)                                             AS TotalPopulation,
    SUM(TotalFarmersCovered) / NULLIF(SUM(TotalPopulation), 0)      AS InsuredToPopulationRatio
FROM FarmersInsuranceData
WHERE TotalPopulation > 0
GROUP BY srcStateName, srcYear
ORDER BY InsuredToPopulationRatio DESC
LIMIT 3;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 5.
-- String Functions [6 Marks]

-- Q13. Create StateShortName by retrieving the first 3 characters of the srcStateName
--      for each unique state.
-- [2 Marks]

SELECT DISTINCT
    srcStateName,
    LEFT(srcStateName, 3) AS StateShortName
FROM FarmersInsuranceData
ORDER BY srcStateName;

-- ###

-- Q14. Retrieve the srcDistrictName where the district name starts with 'B'.
-- [2 Marks]

SELECT DISTINCT srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE 'B%'
ORDER BY srcDistrictName;

-- ###

-- Q15. Retrieve the srcStateName and srcDistrictName where the district name
--      contains the word 'pur' at the end.
-- [2 Marks]

SELECT DISTINCT
    srcStateName,
    srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE '%pur'
ORDER BY srcStateName, srcDistrictName;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 6.
-- Joins [14 Marks]

-- Q16. Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve
--      the aggregated FarmersPremiumAmount for districts where the district's Insurance units
--      for an individual year are greater than 10.
-- [4 Marks]
-- Note: Since all data is in a single table, we self-join to match state+district records
--       that have InsuranceUnits > 10 in any individual year row, then aggregate premium.

SELECT
    a.srcStateName,
    a.srcDistrictName,
    SUM(a.FarmersPremiumAmount) AS TotalFarmersPremiumAmount
FROM FarmersInsuranceData a
INNER JOIN (
    SELECT DISTINCT srcStateName, srcDistrictName
    FROM FarmersInsuranceData
    WHERE `Insurance units` > 10
) b
    ON a.srcStateName    = b.srcStateName
   AND a.srcDistrictName = b.srcDistrictName
GROUP BY a.srcStateName, a.srcDistrictName
ORDER BY TotalFarmersPremiumAmount DESC;

-- ###

-- Q17. Retrieve srcStateName, srcDistrictName, Year, TotalPopulation for each district
--      and the highest recorded FarmersPremiumAmount for that district over all available years.
--      Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
--      Note: 20 crores = 2000 lakhs → column value > 2000
-- [5 Marks]

SELECT
    f.srcStateName,
    f.srcDistrictName,
    f.srcYear                    AS Year,
    f.TotalPopulation,
    m.MaxFarmersPremium
FROM FarmersInsuranceData f
INNER JOIN (
    SELECT
        srcStateName,
        srcDistrictName,
        MAX(FarmersPremiumAmount) AS MaxFarmersPremium
    FROM FarmersInsuranceData
    GROUP BY srcStateName, srcDistrictName
    HAVING MAX(FarmersPremiumAmount) > 2000
) m
    ON f.srcStateName    = m.srcStateName
   AND f.srcDistrictName = m.srcDistrictName
ORDER BY m.MaxFarmersPremium DESC, f.srcStateName, f.srcDistrictName, f.srcYear;

-- ###

-- Q18. Perform a LEFT JOIN to combine total population statistics with farmers' data
--      (TotalFarmersCovered, SumInsured) for each district and state.
--      Return total FarmersPremiumAmount and average population count for each district
--      aggregated over the years, where total FarmersPremiumAmount > 100 crores.
--      Sort by total FarmersPremiumAmount, highest first.
--      Note: 100 crores = 10,000 lakhs → column sum > 10000
-- [5 Marks]

SELECT
    a.srcStateName,
    a.srcDistrictName,
    SUM(a.FarmersPremiumAmount)  AS TotalFarmersPremiumAmount,
    AVG(b.TotalPopulation)       AS AvgPopulation
FROM FarmersInsuranceData a
LEFT JOIN FarmersInsuranceData b
    ON a.srcStateName    = b.srcStateName
   AND a.srcDistrictName = b.srcDistrictName
   AND a.srcYear         = b.srcYear
GROUP BY a.srcStateName, a.srcDistrictName
HAVING SUM(a.FarmersPremiumAmount) > 10000
ORDER BY TotalFarmersPremiumAmount DESC;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 7.
-- Subqueries [10 Marks]

-- Q19. Find the districts (srcDistrictName) where the TotalFarmersCovered is greater than
--      the average TotalFarmersCovered across all records.
--      Note: Aggregated by district first, then compared against the overall average.
-- [2 Marks]

SELECT
    srcDistrictName,
    srcStateName,
    SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
GROUP BY srcDistrictName, srcStateName
HAVING SUM(TotalFarmersCovered) > (
    SELECT AVG(TotalFarmersCovered)
    FROM FarmersInsuranceData
)
ORDER BY TotalFarmersCovered DESC;

-- ###

-- Q20. Find the srcStateName where the SumInsured is higher than the SumInsured of
--      the district with the highest FarmersPremiumAmount.
-- [3 Marks]

SELECT DISTINCT srcStateName, SumInsured
FROM FarmersInsuranceData
WHERE SumInsured > (
    SELECT SumInsured
    FROM FarmersInsuranceData
    ORDER BY FarmersPremiumAmount DESC
    LIMIT 1
)
ORDER BY SumInsured DESC;

-- ###

-- Q21. Find the srcDistrictName where the FarmersPremiumAmount is higher than the average
--      FarmersPremiumAmount of the state that has the highest TotalPopulation.
-- [5 Marks]

SELECT DISTINCT srcDistrictName, srcStateName, FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > (
    SELECT AVG(FarmersPremiumAmount)
    FROM FarmersInsuranceData
    WHERE srcStateName = (
        SELECT srcStateName
        FROM FarmersInsuranceData
        ORDER BY TotalPopulation DESC
        LIMIT 1
    )
)
ORDER BY FarmersPremiumAmount DESC;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 8.
-- Advanced SQL Functions (Window Functions) [10 Marks]

-- Q22. Use the ROW_NUMBER() function to assign a row number to each record in the dataset
--      ordered by total farmers covered in descending order.
-- [3 Marks]

SELECT
    ROW_NUMBER() OVER (ORDER BY TotalFarmersCovered DESC) AS RowNum,
    rowID,
    srcStateName,
    srcDistrictName,
    srcYear,
    TotalFarmersCovered
FROM FarmersInsuranceData;

-- ###

-- Q23. Use the RANK() function to rank the districts (srcDistrictName) based on the
--      SumInsured (descending) and partition by alphabetical srcStateName.
-- [3 Marks]

SELECT
    srcStateName,
    srcDistrictName,
    srcYear,
    SumInsured,
    RANK() OVER (
        PARTITION BY srcStateName
        ORDER BY SumInsured DESC
    ) AS SumInsuredRank
FROM FarmersInsuranceData
ORDER BY srcStateName ASC, SumInsuredRank ASC;

-- ###

-- Q24. Use the SUM() window function to calculate a cumulative sum of FarmersPremiumAmount
--      for each district (srcDistrictName), ordered ascending by srcYear,
--      partitioned by srcStateName.
--      Note: Partitioned by srcStateName only as specified in the assignment.
-- [4 Marks]

SELECT
    srcStateName,
    srcDistrictName,
    srcYear,
    FarmersPremiumAmount,
    SUM(FarmersPremiumAmount) OVER (
        PARTITION BY srcStateName
        ORDER BY srcYear ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeFarmersPremium
FROM FarmersInsuranceData
ORDER BY srcStateName, srcDistrictName, srcYear;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 9.
-- Data Integrity (Constraints, Foreign Keys) [4 Marks]

-- Q25. Create a table 'districts' with DistrictCode as the primary key and columns for
--      DistrictName and StateCode.
--      Create another table 'states' with StateCode as primary key and column for StateName.
-- [2 Marks]

CREATE TABLE IF NOT EXISTS states (
    StateCode   INT          NOT NULL,
    StateName   VARCHAR(255) NOT NULL,
    CONSTRAINT pk_states PRIMARY KEY (StateCode)
);

CREATE TABLE IF NOT EXISTS districts (
    DistrictCode   INT          NOT NULL,
    DistrictName   VARCHAR(255) NOT NULL,
    StateCode      INT          NOT NULL,
    CONSTRAINT pk_districts PRIMARY KEY (DistrictCode)
);

-- ###

-- Q26. Add a foreign key constraint to the districts table that references the
--      StateCode column from the states table.
-- [2 Marks]

ALTER TABLE districts
    ADD CONSTRAINT fk_districts_states
    FOREIGN KEY (StateCode) REFERENCES states(StateCode)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 10.
-- UPDATE and DELETE [6 Marks]

-- Q27. Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
-- [2 Marks]

UPDATE FarmersInsuranceData
SET FarmersPremiumAmount = 500.0
WHERE rowID = 1;

-- ###

-- Q28. Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
-- [2 Marks]

UPDATE FarmersInsuranceData
SET srcYear = 2021
WHERE srcStateName = 'HIMACHAL PRADESH';

-- ###

-- Q29. Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
-- [2 Marks]

DELETE FROM FarmersInsuranceData
WHERE TotalFarmersCovered < 10000
  AND srcYear = 2020;

-- ###

-- ============================================================
-- END OF ASSIGNMENT
-- ============================================================
