SELECT * FROM financial_loan;

-- TOTAL LOAN APPLICATION

SELECT COUNT(id) AS total_loan_applications FROM financial_loan;

SELECT COUNT(id) AS mtd_total_loan_applications
FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                        YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                        MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                        1
                    )
  AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan);

SELECT COUNT(id) AS pmtd_total_loan_applications
FROM financial_loan
WHERE issue_date >= DATEADD(MONTH, -1,
                        DATEFROMPARTS(YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                        MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                        1)) 
  AND issue_date <= DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan));

-- TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS total_funded_amount FROM financial_loan;

SELECT SUM(loan_amount) AS mtd_total_funded_amount FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                                    YEAR((SELECT MAX(issue_date) FROM financial_loan)), 
                                    MONTH((SELECT MAX(issue_date) FROM financial_loan)), 
                                    1)
AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan);

SELECT SUM(loan_amount) AS pmtd_total_funded_amount FROM financial_loan
WHERE issue_date >= DATEADD(
                            MONTH, -1, DATEFROMPARTS(
                                        YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                        MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                        1
                                        )
                            )
    AND issue_date <= DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan));

-- TOTAL AMOUNT RECEIVED

SELECT SUM(total_payment) AS total_amount_received FROM financial_loan;

SELECT SUM(total_payment) AS mtd_total_amount_received FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                                    YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                    MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                    1
                                    )
AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan);

SELECT SUM(total_payment) AS pmtd_total_amount_received FROM financial_loan
WHERE issue_date >= DATEADD(
                            MONTH, -1, 
                            DATEFROMPARTS(
                                            YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                            MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                            1
                                            )
                            )

AND issue_date <= DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan));

-- AVERAGE INTEREST RATE

SELECT AVG(int_rate)*100 AS avg_int_rate FROM financial_loan;

SELECT AVG(int_rate)*100 AS mtd_avg_int_rate FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                                    YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                    MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                    1
                                    )
AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan);

SELECT AVG(int_rate)*100 AS pmtd_avg_int_rate FROM financial_loan
WHERE issue_date >= DATEADD(
                            MONTH, -1, 
                            DATEFROMPARTS(
                                            YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                            MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                            1
                                            )
                            )
AND issue_date <= DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan));

-- AVERAGE DTI

SELECT AVG(dti)*100 AS avg_dti FROM financial_loan;

SELECT AVG(dti)*100 AS mtd_avg_dti FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                                    YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                    MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                    1
                                    )
AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan);

SELECT AVG(dti)*100 AS pmtd_avg_dti FROM financial_loan
WHERE issue_date >= DATEADD(
                            MONTH, -1, 
                            DATEFROMPARTS(
                                            YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                            MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                            1
                                            )
                            )
AND issue_date <= DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan));

-- GOOD LOAN APPLICATION PERCENTAGE

SELECT
    COUNT(
    CASE WHEN loan_status = 'Fully Paid' OR  loan_status = 'Current' THEN id END
    ) * 100.0 / COUNT(id)
AS good_loan_application_percentage
FROM financial_loan;

-- GOOD LOAN APPLICATION

SELECT COUNT(id) AS good_loan_application FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- GOOD LOAN TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS good_loan_total_funded_amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- GOOD LOAN TOTAL RECEIVED AMOUNT

SELECT SUM(total_payment) AS good_loan_total_received_amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- BAD LOAN APPLICATION PERCENTAGE

SELECT COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id) 
AS bad_loan_application_percentage FROM financial_loan;

-- BAD LOAN APPLICATION

SELECT COUNT(id) AS bad_loan_application FROM financial_loan
WHERE loan_status = 'Charged Off';

-- BAD LOAN TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS bad_loan_total_funded_amount FROM financial_loan
WHERE loan_status = 'Charged Off';

-- BAD LOAN TOTAL RECEIVED AMOUNT

SELECT SUM(total_payment) AS 'Received Amount' FROM financial_loan
WHERE loan_status = 'Charged Off';

-- LOAN STATUS GRID VIEW

SELECT
    loan_status,
    COUNT(id) AS total_loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received,
    AVG(int_rate)*100 AS avg_int_rate,
    AVG(dti)*100 AS avg_dti
FROM financial_loan
GROUP BY loan_status;

SELECT
    loan_status,
    SUM(loan_amount) AS mtd_total_funded_amount,
    SUM(total_payment) AS mtd_total_payment_amount
FROM financial_loan
WHERE issue_date >= DATEFROMPARTS(
                                    YEAR((SELECT MAX(issue_date) FROM financial_loan)),
                                    MONTH((SELECT MAX(issue_date) FROM financial_loan)),
                                    1
                                    )
AND issue_date <= (SELECT MAX(issue_date) FROM financial_loan)
GROUP BY loan_status;

-- MONTHLY TRENDS

SELECT
    DATENAME(MONTH, issue_date) AS month_name,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);

-- REGIONAL ANALYSIS

SELECT
    address_state,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY address_state
ORDER BY address_state;

-- LOAN TERM ANALYSIS

SELECT
    term,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY term
ORDER BY term;

-- EMPLOYEE LENGTH ANALYSIS

SELECT
    emp_length,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

-- LOAN PURPOSE BREAKDOWN

SELECT
    purpose,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY purpose
ORDER BY purpose;

-- HOME OWNERSHIP ANALYSIS

SELECT
    home_ownership,
    COUNT(id) AS loan_application,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;