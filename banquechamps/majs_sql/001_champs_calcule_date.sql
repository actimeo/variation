DO $$
BEGIN

	-- Ajout type de champs date_calcule
	IF NOT EXISTS (SELECT 1 FROM meta.infos_type WHERE int_code = 'date_calcule') THEN
	   INSERT INTO meta.infos_type (int_code, int_libelle, int_multiple, int_historique) 
	   	  VALUES ('date_calcule', 'Date calculée', FALSE, FALSE);
	END IF;

	-- Ajout colonne inf_formule à meta.info
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'meta' AND 
	   		        table_name ='info' and
		 	       column_name ='inf_formule') THEN
	   	ALTER TABLE meta.info ADD column inf_formule text;
	END IF;

END;
$$;
