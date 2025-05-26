-- Determining the projected life distribution of lyft drivers.  

WITH driver_days AS
(
	SELECT
		d.driver_id,
		DATE_PART('day', MAX(t.timestamp) - MIN(d.driver_onboard_date)) AS diff
		-- Finding the duration a driver is associated with lyft
		-- We find the difference in days between drivers last ride and onboard date and call it diff
	FROM
		driver_ids d
	JOIN 
		ride_ids r
	ON 
		d.driver_id = r.driver_id
	JOIN
		ride_timestamps t
	ON 
		r.ride_id = t.ride_id
	WHERE
		t.event = 'dropped_off_at'  
		-- We select the last dropped off timestamp for calculation
	GROUP BY
		d.driver_id
	ORDER BY
		diff DESC
)
-- Here we will find number of drivers that last for particular days
SELECT
	diff AS n_days,
	COUNT(driver_id) AS n_drivers
FROM
	driver_days
GROUP BY
	diff
ORDER BY
	n_days ASC