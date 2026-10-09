INSERT INTO public.api_resource(
	api_id, name, endpoint, method, schedule, destination, destination_table, enabled, additional, api_key_reference)
	VALUES 
	(1, 'Civilian Labor Force (Seasonally Adjusted)', 'LNS11000000', 'POST', 'daily', 'http://garage.garage.svc.cluster.local:3900/', 'BLS_series', TRUE, '{"Bucket": "garage-bucket"}', ''),
	(1, 'Civilian Unemployment (Seasonally Adjusted)', 'LNS13000000', 'POST', 'daily', 'http://garage.garage.svc.cluster.local:3900/', 'BLS_series', TRUE, '{"Bucket": "garage-bucket"}', ''),
	(1, 'Unemployment Rate (Seasonally Adjusted)', 'LNS14000000', 'POST', 'daily', 'http://garage.garage.svc.cluster.local:3900/', 'BLS_series', TRUE, '{"Bucket": "garage-bucket"}', ''),
	(1, 'Total Private Average Hourly Earnings of Prod. and Nonsup. Employees - Seasonally Adjusted', 'CES0500000008', 'POST', 'daily', 'http://garage.garage.svc.cluster.local:3900/', 'BLS_series', TRUE, '{"Bucket": "garage-bucket"}', '');