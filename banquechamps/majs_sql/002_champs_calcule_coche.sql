DO $$
BEGIN

	-- Ajout type de champs coche_calcule
	IF NOT EXISTS (SELECT 1 FROM meta.infos_type WHERE int_code = 'coche_calcule') THEN
	   INSERT INTO meta.infos_type (int_code, int_libelle, int_multiple, int_historique) 
	   	  VALUES ('coche_calcule', 'Case à cocher calculée', FALSE, FALSE);
	END IF;

END;
$$;
