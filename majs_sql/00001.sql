DO $$
BEGIN
	-- Ajout icone aux sous-menu personne
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'meta' AND 
	   		        table_name ='sousmenu' and
		 	       column_name ='sme_icone') THEN
	   	ALTER TABLE meta.sousmenu ADD column sme_icone varchar;
	END IF;

	-- Suppression de l'ancienne config des utilisateurs
	-- DELETE FROM meta.rootsousmenu WHERE rsm_id = 2;

	-- Ajout agendas de ressources
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
	       	        WHERE table_schema = 'events' AND
			        table_name = 'agressources') THEN
	    CREATE TABLE events.agressources (
	    	   agr_id serial,
		   agr_code varchar,
		   agr_titre varchar);		   
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
	       	        WHERE table_schema = 'events' AND
			        table_name = 'agressources_secteur') THEN
	    CREATE TABLE events.agressources_secteur (
	    	   ase_id serial,
		   agr_id integer,
		   sec_id integer);
	END IF;

	-- Ajout configuration des types de documents
	-- IF NOT EXISTS (SELECT 1 FROM meta.rootsousmenu WHERE rsm_script = '/root/document_types.php') THEN
	--     UPDATE meta.rootsousmenu SET rsm_ordre = rsm_ordre + 1 WHERE rsm_ordre > 3;
	--     INSERT INTO meta.rootsousmenu (rsm_libelle, rsm_ordre, rsm_icone, rsm_script)
	--         VALUES ('Types documents', 4, '/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/spread_sheet_32.png', '/root/document_types.php');
	-- END IF;

	-- Ajout configuration des types de documents par etablissement
	-- IF NOT EXISTS (SELECT 1 FROM meta.adminsousmenu WHERE asm_script = '/admin/documents_types.php') THEN
	--    UPDATE meta.adminsousmenu SET asm_ordre = asm_ordre + 1 WHERE asm_ordre > 10;
	--    INSERT INTO meta.adminsousmenu (asm_libelle, asm_ordre, asm_icone, asm_script)
	--    	  VALUES ('Types documents', 11, '/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/spread_sheet_32.png', '/admin/documents_types.php');
	-- END IF;

	-- Ajout table document.document_type_etablissement
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
	       	        WHERE table_schema = 'document' AND
			        table_name = 'document_type_etablissement') THEN
	    CREATE TABLE document.document_type_etablissement (
	    	   dte_id serial,
		   dty_id integer,
		   eta_id integer,
		   CONSTRAINT document_type_etablissement_pkey PRIMARY KEY (dte_id ),
		   CONSTRAINT document_type_etablissement_eta_id_fkey FOREIGN KEY (eta_id)
      		   	      REFERENCES etablissement (eta_id) MATCH SIMPLE
      			      ON UPDATE NO ACTION ON DELETE NO ACTION,
		   CONSTRAINT document_type_etablissement_dty_id_fkey FOREIGN KEY (dty_id)
		              REFERENCES document.document_type (dty_id) MATCH SIMPLE
			      ON UPDATE NO ACTION ON DELETE NO ACTION
	    );
	    CREATE INDEX fki_document_type_etablissement_eta_id_fkey
	    	   ON document.document_type_etablissement
		   USING btree
		   (eta_id);
	    CREATE INDEX fki_document_type_etablissement_dty_id_fkey
  	    	   ON document.document_type_etablissement
  		   USING btree
		   (dty_id);
	END IF;

	-- Ajout document.documents.dty_id
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'document' AND 
	   		        table_name ='documents' and
		 	       column_name ='dty_id') THEN
	   	ALTER TABLE document.documents ADD column dty_id integer;
		ALTER TABLE document.documents ADD CONSTRAINT documents_dty_id_fkey 
		      FOREIGN KEY (dty_id)
		      REFERENCES document.document_type (dty_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
	 	CREATE INDEX fki_documents_dty_id_fkey
  		       ON document.documents
  		       USING btree
		       (dty_id);
	END IF;

	-- Ajout document.document.doc_date_creation
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'document' AND 
	   		        table_name ='document' and
		 	       column_name ='doc_date_creation') THEN
		ALTER TABLE document.document ADD COLUMN doc_date_creation timestamp with time zone;
	END IF;

	-- Ajout document.document.uti_id_creation
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'document' AND 
	   		        table_name ='document' and
		 	       column_name ='uti_id_creation') THEN
		ALTER TABLE document.document ADD COLUMN uti_id_creation integer;
		ALTER TABLE document.document ADD CONSTRAINT document_uti_id_creation_fkey 
		      FOREIGN KEY (uti_id_creation)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_document_uti_id_creation_fkey
		       ON document.document
  		       USING btree 
		       (uti_id_creation);
	END IF;


	-- Ajout events.event.eve_date_creation
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'events' AND 
	   		        table_name ='event' and
		 	       column_name ='eve_date_creation') THEN
		ALTER TABLE events.event ADD COLUMN eve_date_creation timestamp with time zone;
	END IF;

	-- Ajout login.utilisateur.uti_digest
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'login' AND 
	   		        table_name ='utilisateur' and
		 	       column_name ='uti_digest') THEN
		ALTER TABLE login.utilisateur ADD COLUMN uti_digest varchar;
		UPDATE login.utilisateur SET uti_digest = md5 (uti_login || ':Accueil:' || uti_pwd) WHERE uti_pwd notnull;
	END IF;

	-- Ajout Réseau > Imports
	-- IF NOT EXISTS (SELECT 1 FROM meta.rootsousmenu WHERE rsm_script = '/root/imports.php') THEN
	--    INSERT INTO meta.rootsousmenu (rsm_libelle, rsm_ordre, rsm_icone, rsm_script)
	--    	  VALUES ('Imports', (SELECT MAX(rsm_ordre) FROM meta.rootsousmenu)+1, '/Images/IS_Real_vista_Database/originals/png/NORMAL/32/insert_table_32.png', '/root/imports.php');
	-- END IF;

	-- Ajout ing_obligatoire
	-- Ajout icone aux sous-menu personne
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'meta' AND 
	   		        table_name ='info_groupe' and
		 	       column_name ='ing_obligatoire') THEN
	   	ALTER TABLE meta.info_groupe ADD column ing_obligatoire BOOLEAN NOT NULL DEFAULT FALSE;
	END IF;

	-- Ajout liste.liste.lis_pagination_tout
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'liste' AND 
	   		        table_name ='liste' and
		 	       column_name ='lis_pagination_tout') THEN
	   	ALTER TABLE liste.liste ADD column lis_pagination_tout BOOLEAN NOT NULL DEFAULT FALSE;
	END IF;

	-- Ajout personne_info_*.uti_id 
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_boolean' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_boolean ADD column uti_id integer;
		ALTER TABLE public.personne_info_boolean ADD CONSTRAINT personne_info_boolean_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_boolean_uti_id_fkey 
		       ON public.personne_info_boolean
  		       USING btree 
		       (uti_id);		
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_date' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_date ADD column uti_id integer;
		ALTER TABLE public.personne_info_date ADD CONSTRAINT personne_info_date_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_date_uti_id_fkey 
		       ON public.personne_info_date
  		       USING btree 
		       (uti_id);		
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_integer' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_integer ADD column uti_id integer;
		ALTER TABLE public.personne_info_integer ADD CONSTRAINT personne_info_integer_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_integer_uti_id_fkey 
		       ON public.personne_info_integer
  		       USING btree 
		       (uti_id);		
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_integer2' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_integer2 ADD column uti_id integer;
		ALTER TABLE public.personne_info_integer2 ADD CONSTRAINT personne_info_integer2_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_integer2_uti_id_fkey 
		       ON public.personne_info_integer2
  		       USING btree 
		       (uti_id);		
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_text' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_text ADD column uti_id integer;
		ALTER TABLE public.personne_info_text ADD CONSTRAINT personne_info_text_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_text_uti_id_fkey 
		       ON public.personne_info_text
  		       USING btree 
		       (uti_id);		
	END IF;
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns
	       	        WHERE table_schema = 'public' AND 
	   		        table_name ='personne_info_varchar' and
		 	       column_name ='uti_id') THEN
	   	ALTER TABLE public.personne_info_varchar ADD column uti_id integer;
		ALTER TABLE public.personne_info_varchar ADD CONSTRAINT personne_info_varchar_uti_id_fkey 
		      FOREIGN KEY (uti_id)
      		      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      		      ON UPDATE NO ACTION ON DELETE NO ACTION;
		CREATE INDEX fki_personne_info_varchar_uti_id_fkey 
		       ON public.personne_info_varchar
  		       USING btree 
		       (uti_id);		
	END IF;

	-- token based auth
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
	       	        WHERE table_schema = 'login' AND
			        table_name = 'token') THEN
	    CREATE TABLE login.token (
	    	   tok_id serial,
		   uti_id integer,
		   tok_token integer,
		   tok_date_creation timestamp with time zone,
		   CONSTRAINT token_tok_id_pkey PRIMARY KEY (tok_id),
		   CONSTRAINT token_uti_id_fkey FOREIGN KEY (uti_id)
      		   	      REFERENCES login.utilisateur (uti_id) MATCH SIMPLE
      			      ON UPDATE NO ACTION ON DELETE NO ACTION,
	           CONSTRAINT token_tok_token_unique UNIQUE (tok_token)
	           );
	    CREATE INDEX fki_token_uti_id_fkey 
		       ON login.utilisateur
  		       USING btree 
		       (uti_id);		
	END IF;
	
	-- Suppression de la table login.utilisateur_etablissement
        DROP TABLE IF EXISTS login.utilisateur_etablissement;

	-- Suppression de la table meta.aide
        DROP TABLE IF EXISTS meta.aide;

	-- Suppression du schéma calendrier
	DROP SCHEMA IF EXISTS calendrier CASCADE;

	-- Suppression du schéma import
	DROP SCHEMA IF EXISTS import CASCADE;

	-- Ajout utilisateur kavarna en base
	IF NOT EXISTS (SELECT 1 FROM login.utilisateur WHERE uti_login = 'kavarna') THEN
	   INSERT INTO login.utilisateur (uti_login, uti_salt, uti_root, uti_config) 
	   	  VALUES ('kavarna', 'gnWE6bRd4yHps', TRUE, TRUE);
	END IF;

	-- Ajout traduction de début et fin d'appartenance à un groupe
	IF NOT EXISTS (SELECT 1 FROM localise.terme WHERE ter_code = 'info_groupe_date_debut') THEN
	   INSERT INTO localise.terme (ter_code, ter_commentaire) VALUES 
	   	  ('info_groupe_date_debut', '"Etiquette dans popup édition appartenance usagers aux groupes'),
	          ('info_groupe_date_fin', '"Etiquette dans popup édition appartenance usagers aux groupes');
	   INSERT INTO localise.localisation_secteur (ter_id, loc_valeur) VALUES
	          ( (SELECT ter_id FROM localise.terme WHERE ter_code = 'info_groupe_date_debut'), 'Début'),
	          ( (SELECT ter_id FROM localise.terme WHERE ter_code = 'info_groupe_date_fin'), 'Fin');
	END IF;

	-- Ajout Réseau > Intitulés
	-- IF NOT EXISTS (SELECT 1 FROM meta.rootsousmenu WHERE rsm_script = '/root/localise.php') THEN
	--    INSERT INTO meta.rootsousmenu (rsm_libelle, rsm_ordre, rsm_icone, rsm_script)
	--    	  VALUES ('Intitulés', (SELECT MAX(rsm_ordre) FROM meta.rootsousmenu)+1, 'Images/IS_Real_vista_Mail_icons/originals/png/NORMAL/32/blacklist_32.png', '/root/localise.php');
	-- END IF;

	-- Ajout liste.champ.cha_champs_supp	
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'liste' AND 
	   		        table_name ='champ' and
		 	       column_name ='cha_champs_supp') THEN
		ALTER TABLE liste.champ ADD COLUMN cha_champs_supp BOOLEAN DEFAULT FALSE;
	END IF;

	-- Ajout table liste.supp
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
	       	        WHERE table_schema = 'liste' AND
			        table_name = 'supp') THEN
	    CREATE TABLE liste.supp (
	    	   sup_id serial PRIMARY KEY,
		   cha_id integer REFERENCES liste.champ,
		   inf_id integer REFERENCES meta.info,
		   sup_ordre integer
            );
	END IF;

	-- Ajout Réseau > Debug
	-- IF NOT EXISTS (SELECT 1 FROM meta.rootsousmenu WHERE rsm_script = '/root/debug.php') THEN
	--    INSERT INTO meta.rootsousmenu (rsm_libelle, rsm_ordre, rsm_icone, rsm_script)
	--    	  VALUES ('Debug', (SELECT MAX(rsm_ordre) FROM meta.rootsousmenu)+1, '/Images/IS_Real_vista_Social/originals/png/NORMAL/32/report_bug_32.png', '/root/debug.php');
	-- END IF;

	-- Ajout liste.champ.cha__contact_filtre_utilisateur
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'liste' AND 
	   		        table_name ='champ' and
		 	       column_name ='cha__contact_filtre_utilisateur') THEN
		ALTER TABLE liste.champ ADD COLUMN cha__contact_filtre_utilisateur BOOLEAN;				
	END IF;

	-- Ajout events.event.eve_journee
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'events' AND 
	   		        table_name ='event' and
		 	       column_name ='eve_journee') THEN
		ALTER TABLE events.event ADD COLUMN eve_journee BOOLEAN NOT NULL DEFAULT FALSE;
	END IF;

	-- Ajout events.event.eve_ponctuel
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'events' AND 
	   		        table_name ='event' and
		 	       column_name ='eve_ponctuel') THEN
	    ALTER TABLE events.event ADD COLUMN eve_ponctuel BOOLEAN NOT NULL DEFAULT FALSE;

	    -- Corrige dates events :
	    --  - pas de date de fin -> ponctuel
	    UPDATE events.event SET eve_fin = eve_debut, eve_ponctuel = true WHERE eve_fin ISNULL;
	    --  - date debut = date de fin -> ponctuel
	    UPDATE events.event SET eve_ponctuel = true WHERE eve_debut = eve_fin;

	END IF;

	-- Suppression procedure.procedure_affectation.asm_id
	IF EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'procedure' AND 
	   		        table_name ='procedure_affectation' and
		 	       column_name ='asm_id') THEN
	   	ALTER TABLE procedure.procedure_affectation DROP column asm_id;
	END IF;

	-- Suppression de la table meta.adminsousmenu
	DROP FUNCTION IF EXISTS meta.meta_adminsousmenu_liste();
	DROP FUNCTION IF EXISTS meta.meta_adminsousmenu_liste(prm_token integer);
        DROP TABLE IF EXISTS meta.adminsousmenu;

	-- Suppression de la table meta.rootsousmenu
	DROP FUNCTION IF EXISTS meta.meta_rootsousmenu_liste();
	DROP FUNCTION IF EXISTS meta.meta_rootsousmenu_liste(prm_token integer);
        DROP TABLE IF EXISTS meta.rootsousmenu;

	-- Ajout de secteurs de la santé et divers autres
	IF NOT EXISTS (SELECT 1 FROM meta.secteur WHERE sec_code = 'soins_infirmiers') THEN
	   INSERT INTO meta.secteur (sec_code, sec_nom, sec_est_prise_en_charge, sec_icone) VALUES
	   	       ('soins_infirmiers','Soins infirmiers',FALSE,'/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/nurse_%d.png'),
		       ('dietetique','Suivi diététique',FALSE,'/Images/IS_Real_vista_Food/originals/png/NORMAL/%d/apples_%d.png'),
		       ('ergotherapie','Ergothérapie',FALSE,'/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/occupational_therapy_%d.png'),
		       ('physiotherapie','Physiothérapie',FALSE,'/Images/IS_real_vista_sports/originals/png/NORMAL/%d/floor_gymnastics_%d.png'),
		       ('kinesitherapie','Kinésithérapie',FALSE,'/Images/IS_Real_vista_3d_graphics/originals/png/NORMAL/%d/figure_%d.png'),
		       ('orthophonie','Orthophonie',FALSE,'/Images/IS_Real_vista_Communications/originals/png/NORMAL/%d/kiss_%d.png'),
		       ('psychomotricite','Psychomotricité',FALSE,'/Images/IS_real_vista_sports/originals/png/NORMAL/%d/balance_beam_%d.png'),
		       ('psychologie','Psychologie',FALSE,'/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/ophthalmology_%d.png'),
		       ('droits_de_sejour','Droits de séjour',FALSE,'/Images/IS_Real_vista_Flags/originals/png/NORMAL/%d/France_%d.png'),
		       ('aide_formalites','Aide aux formalités administratives',FALSE,'/Images/IS_Real_vista_Accounting/originals/png/NORMAL/%d/stamp_%d.png');
        END IF;

	-- Ajout des colonnes des nouveaux secteurs a la table groupe
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'public' AND 
	   		        table_name ='groupe' and
		 	       column_name ='grp_soins_infirmiers_contact') THEN
 	  ALTER TABLE public.groupe ADD COLUMN grp_soins_infirmiers_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_soins_infirmiers_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_dietetique_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_dietetique_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_ergotherapie_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_ergotherapie_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_physiotherapie_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_physiotherapie_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_kinesitherapie_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_kinesitherapie_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_orthophonie_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_orthophonie_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_psychomotricite_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_psychomotricite_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_psychologie_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_psychologie_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_droits_de_sejour_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_droits_de_sejour_type integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_aide_formalites_contact integer;
 	  ALTER TABLE public.groupe ADD COLUMN grp_aide_formalites_type integer;
	END IF;

	-- Ajout liste.liste.lis_code
	IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
	   	        WHERE table_schema = 'liste' AND 
	   		        table_name ='liste' and
		 	       column_name ='lis_code') THEN
 	  ALTER TABLE liste.liste ADD COLUMN lis_code varchar UNIQUE;
	  
	  UPDATE liste.liste SET lis_code = pour_code (lis_nom) WHERE lis_code ISNULL;
	END IF;
END;
$$;
