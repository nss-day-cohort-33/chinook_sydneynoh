--1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.

SELECT c.CustomerId, (c.FirstName || " " || c.LastName) AS "FullName", c.Country
FROM Customer c 
WHERE c.Country != "USA";

--2. Provide a query only showing the Customers from Brazil.

SELECT c.CustomerId, (c.FirstName || " " || c.LastName) AS "FullName", c.Country
FROM Customer c 
WHERE c.Country = "Brazil";

--3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.

SELECT (c.FirstName || " " || c.LastName) AS "FullName", i.InvoiceId, i.InvoiceDate, i.BillingCountry 
FROM Customer c
JOIN  Invoice i ON c.CustomerId = i.CustomerId
WHERE i.BillingCountry = "Brazil";

--4. Provide a query showing only the Employees who are Sales Agents.

SELECT (e.FirstName || " " || e.LastName) AS "FullName", e.Title
FROM Employee e
WHERE e.Title = "Sales Support Agent";

--5.  Provide a query showing a unique/distinct list of billing countries from the Invoice table.

SELECT DISTINCT i.BillingCountry
FROM Invoice i;

--6. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.

SELECT (e.FirstName || " " || e.LastName) AS "FullName", i.InvoiceId
FROM Employee e 
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON i.CustomerId = c.CustomerId
ORDER BY e.EmployeeId;

--7. Provide a query that shows the Invoice Total, Customer name, Country and Sales Agent name for all invoices and customers.

SELECT i.Total, (c.FirstName || " " || c.LastName) AS "Customer Name", c.Country, (e.FirstName || " " || e.LastName) AS "Rep Name"
FROM Customer c 
LEFT JOIN Invoice i on i.CustomerId = c.CustomerId
JOIN Employee e on c.SupportRepId = e.EmployeeId;

--8. How many Invoices were there in 2009 and 2011?

SELECT strftime('%Y', i.InvoiceDate) AS Year,
COUNT(*)
FROM Invoice i
WHERE YEAR = "2009" OR YEAR = "2011"
GROUP BY YEAR;

--9. What are the respective total sales for each of those years?

SELECT strftime('%Y', i.InvoiceDate) AS Year, SUM(i.Total) as Total_Sales
FROM Invoice i
WHERE YEAR = "2009" OR YEAR = "2011"
GROUP BY YEAR;

--10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.

SELECT i.InvoiceId,
COUNT(*)
FROM InvoiceLine i
WHERE i.InvoiceId = 37;

--11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY 

SELECT i.InvoiceId,
COUNT(*)
FROM InvoiceLine i
GROUP BY i.InvoiceId;

--12. Provide a query that includes the purchased track name with each invoice line item.

SELECT i.InvoiceLineId, t.Name 
FROM InvoiceLine i 
JOIN Track t ON i.TrackId = t.TrackId;

--13. Provide a query that includes the purchased track name AND artist name with each invoice line item.

SELECT i.InvoiceLineId, t.Name, t.Composer 
FROM InvoiceLine i 
JOIN Track t ON i.TrackId = t.TrackId;

-- 14. Provide a query that shows the # of invoices per country. HINT: GROUP BY

SELECT i.BillingCountry,
COUNT(*)
FROM Invoice i
GROUP BY i.BillingCountry;

-- 15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.

SELECT p.Name,
COUNT(pt.TrackId)
FROM PlaylistTrack pt
JOIN Playlist p ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId;

-- 16. Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.

SELECT t.Name as Track_Name, a.Title AS Album_Title, g.Name AS Genre, m.MediaTypeId AS Media_Type
FROM Track t 
JOIN Album a ON a.AlbumId = t.AlbumId
JOIN Genre g ON g.GenreId = t.GenreId
JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId;

-- 17. Provide a query that shows all Invoices but includes the # of invoice line items.

SELECT *,
COUNT(*) AS line_items
FROM Invoice i 
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
GROUP BY i.InvoiceId;

-- 18. Provide a query that shows total sales made by each sales agent.

SELECT (e.FirstName || " " || e.LastName) AS "Employee Name",
SUM(i.Total)
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

-- 19. Which sales agent made the most in sales in 2009?

SELECT * FROM
(SELECT strftime('%Y', i.InvoiceDate) AS Year, (e.FirstName || " " || e.LastName) AS "Employee Name",
COUNT(i.InvoiceId) AS sales
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
WHERE YEAR = "2009"
GROUP BY e.EmployeeId
ORDER BY sales DESC)
LIMIT 1;

-- 20. Which sales agent made the most in sales over all?

SELECT * FROM
(SELECT (e.FirstName || " " || e.LastName) AS "Employee Name",
TOTAL(i.Total) as Sales_Total
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId
ORDER BY Sales_Total DESC)
LIMIT 1;

-- 21. Provide a query that shows the count of customers assigned to each sales agent.

SELECT c.CustomerId, (e.FirstName || " " || e.LastName) AS "Employee Name",
COUNT(c.CustomerId) AS Customers_Assgn
FROM Customer c
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

-- 22. Provide a query that shows the total sales per country.

SELECT i.BillingCountry,
TOTAL(i.Total) AS Total_Sales
FROM Invoice i 
GROUP BY i.BillingCountry;

-- 23. Which country's customers spent the most?

SELECT * FROM 
(SELECT i.BillingCountry,
MAX(i.Total) AS Total_Sales
FROM Invoice i 
GROUP BY i.BillingCountry
ORDER BY Total_Sales DESC)
LIMIT 1;

-- 24. Provide a query that shows the most purchased track of 2013.

SELECT i.TrackId,
COUNT(i.InvoiceLineId)
FROM InvoiceLine i
GROUP BY i.TrackId;

-- 25. Provide a query that shows the top 5 most purchased tracks over all.

SELECT * FROM 
(SELECT i.TrackId,
COUNT(i.InvoiceLineId) AS Total_Sales
FROM InvoiceLine i
GROUP BY i.TrackId
ORDER BY Total_Sales DESC)
LIMIT 5;

-- 26. Provide a query that shows the top 3 best selling artists.

SELECT * FROM
(SELECT t.TrackId, t.Composer,
COUNT(i.InvoiceLineId) as Total_Sales
FROM InvoiceLine i 
JOIN Track t ON t.TrackId = i.TrackId
WHERE t.Composer NOT NULL
GROUP BY i.TrackId
ORDER BY Total_Sales DESC)
LIMIT 3;

-- 27. Provide a query that shows the most purchased Media Type.

SELECT * FROM
(SELECT m.MediaTypeId, m.Name,
COUNT(i.InvoiceLineId) AS Total_Sales
FROM InvoiceLine i 
JOIN Track t ON t.TrackId = i.TrackId
JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY Total_Sales DESC)
LIMIT 1;

