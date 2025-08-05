------ This file generates the delta file for updating value list tables for VSA-DSS database (Modul VSA-DSS (2020)) in en for QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 05.08.2025 19:06:50

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8608,8608) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'waste_water_association',
   value_de = 'Abwasserverband',
   value_fr = 'association_epuration_eau',
   value_it = 'consorzio_depurazione',
   value_ro = 'rrr_Abwasserverband',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Wastewater association or other form of inter-municipal organization under public law.',
   description_de = 'Abwasserverband oder andere Form einer interkommunalen Organisationform des öffentlichen Rechts.',
   description_fr = 'Association d''assainissement ou autre forme d''organisation intercommunale de droit public.',
   description_it = 'Associazione di acque reflue o altra forma di organizzazione intercomunale di diritto pubblico.',
   description_ro = 'Asocia?ie de apa uzata sau alta forma de organiza?ie intercomunala de drept public.',
   display_en = 'waste_water_association',
   display_de = 'Abwasserverband',
   display_fr = 'association épuration eau',
   display_it = '',
   display_ro = ''
WHERE code = 8608;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8715,8715) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'federation',
   value_de = 'Bund',
   value_fr = 'federation',
   value_it = 'confederazione',
   value_ro = 'rrr_Bund',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Part of a federal administration (e.g. Federal Office for the Environment, FEDRO, armasuisse)',
   description_de = 'Teil einer Bundesverwaltung (z.B. Bundesamt für Umwelt, ASTRA, Armasuisse)',
   description_fr = 'Partie d''une administration fédérale (p. ex.  Office fédéral de l''environnement, OFROU, armasuisse)',
   description_it = 'Parte di un''amministrazione federale (ad es. Ufficio federale dell''ambiente, USTRA, armasuisse)',
   description_ro = 'rrr_Teil einer Bundesverwaltung (z.B. Bundesamt für Umwelt, ASTRA, Armasuisse)',
   display_en = 'federation',
   display_de = 'Bund',
   display_fr = 'fédération',
   display_it = '',
   display_ro = ''
WHERE code = 8715;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8604,8604) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'municipality',
   value_de = 'Gemeinde',
   value_fr = 'commune',
   value_it = 'comune',
   value_ro = 'municipiul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Municipality according to Federal Statistical Office',
   description_de = 'Gemeinde gemäss Bundesamt für Statistik',
   description_fr = 'Commune selon l''Office fédéral de la statistique',
   description_it = 'Comune secondo l''Ufficio federale di statistica',
   description_ro = 'Municipiul conform Oficiului Federal de Statistica',
   display_en = 'municipality',
   display_de = 'Gemeinde',
   display_fr = 'commune',
   display_it = '',
   display_ro = ''
WHERE code = 8604;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (9319,9319) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'municipal_department',
   value_de = 'Gemeindeabteilung',
   value_fr = 'departement_communal',
   value_it = 'dipartimento_comunale',
   value_ro = 'departamentul_municipal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Part of a municipal administration that assumes a role ((e.g. Geoinformation Stadt Bern) as a responsible_entity, data provider, etc. (but not as data owner / (public) owner).',
   description_de = 'Teil einer Gemeindeverwaltung, die eine Rolle übernimmt ((z.B. Geoinformation Stadt Bern) als Traegerschaft, Datenlieferant, etc. (aber nicht als Datenherr / (oeffentlicher) Eigentuemer)',
   description_fr = 'Partie d''une administration communale qui assume un rôle (par ex. Geoinformation Stadt Bern) en tant que porteur, fournisseur de données, etc. (mais pas en tant que maître des données / propriétaire (public))',
   description_it = 'Parte di un''amministrazione comunale che assume un ruolo ((ad esempio Geoinformation Stadt Bern) come sponsor, fornitore di dati, ecc. (ma non come proprietario dei dati / proprietario (pubblico)).',
   description_ro = 'Parte a unei administra?ii municipale care î?i asuma un rol ((de exemplu, Geoinformation Stadt Bern) ca sponsor, furnizor de date etc. (dar nu ca proprietar de date / proprietar (public)).',
   display_en = 'municipal_department',
   display_de = 'Gemeindeabteilung',
   display_fr = 'Département communal',
   display_it = 'Dipartimento comunale',
   display_ro = 'Departamentul municipal'
WHERE code = 9319;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8610,8610) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'cooperative',
   value_de = 'Genossenschaft_Korporation',
   value_fr = 'cooperative',
   value_it = 'cooperativa_corporazione',
   value_ro = 'rrr_Genossenschaft_Korporation',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cooperative, corporation or other form of municipal organization under public law. If private law, then display as “private”.',
   description_de = 'Genossenschaft, Korporation oder andere Form einer kommunalen Organisationsform des öffentlichen Rechts. Falls privaten Rechtes dann als "Privat" abbilden.',
   description_fr = 'Coopérative, corporation ou autre forme d''organisation communale de droit public. Si elle est de droit privé, la représenter comme « privée ».',
   description_it = 'Cooperativa, società o altra forma di organizzazione comunale di diritto pubblico. Se di diritto privato, indicare “Privato”.',
   description_ro = 'Cooperativa, corpora?ie sau alta forma de organiza?ie municipala de drept public. Daca este de drept privat, indica?i „Privat”.',
   display_en = 'cooperative',
   display_de = 'Genossenschaft_Korporation',
   display_fr = 'cooperative',
   display_it = '',
   display_ro = ''
WHERE code = 8610;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8605,8605) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'canton',
   value_de = 'Kanton',
   value_fr = 'canton',
   value_it = 'cantone',
   value_ro = 'rrr_Kanton',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Teil einer kantonalen Verwaltung (z.B. Amt für Umweltschutz, Amt für Abwasserentsorgung)',
   description_de = 'Teil einer kantonalen Verwaltung (z.B. Amt für Umweltschutz, Amt für Abwasserentsorgung)',
   description_fr = 'Partie d''une administration cantonale (p. ex.  office de l''environnement, OFROU, office de l''évacuation des eaux usées))',
   description_it = 'Parte di un''amministrazione cantonale (es. Ufficio per la protezione dell''ambiente, Ufficio per lo smaltimento delle acque)',
   description_ro = 'rrr_Teil einer kantonalen Verwaltung (z.B. Amt für Umweltschutz, Amt für Abwasserentsorgung)',
   display_en = 'canton',
   display_de = 'Kanton',
   display_fr = 'canton',
   display_it = '',
   display_ro = ''
WHERE code = 8605;

--- Adapt tww_vl.organisation_organisation_type
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode) VALUES (8606,8606) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_organisation_type SET
   value_en = 'private',
   value_de = 'Privat',
   value_fr = 'prive',
   value_it = 'privato',
   value_ro = 'privata',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Privatperson oder Privatorganisation, welche im Rahmen der Entwässerungsplanung auftritt',
   description_de = 'Privatperson oder Privatorganisation, welche im Rahmen der Entwässerungsplanung auftritt',
   description_fr = 'Personne privée ou organisation privée qui intervient dans le cadre de la planification de l''évacuation des eaux.',
   description_it = 'Persona od organizzazione privata attiva nella pianificazione dello smaltimento delle acque',
   description_ro = 'rrr_Privatperson oder Privatorganisation, welche im Rahmen der Entwässerungsplanung auftritt',
   display_en = 'private',
   display_de = 'Privat',
   display_fr = 'privé',
   display_it = 'privato',
   display_ro = 'privata'
WHERE code = 8606;

--- Adapt tww_vl.organisation_status
 INSERT INTO tww_vl.organisation_status (code, vsacode) VALUES (9047,9047) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_status SET
   value_en = 'activ',
   value_de = 'aktiv',
   value_fr = 'active',
   value_it = 'attivo',
   value_ro = 'rrr_aktiv',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'activ',
   display_de = 'aktiv',
   display_fr = 'active',
   display_it = '',
   display_ro = ''
WHERE code = 9047;

--- Adapt tww_vl.organisation_status
 INSERT INTO tww_vl.organisation_status (code, vsacode) VALUES (9048,9048) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.organisation_status SET
   value_en = 'gone',
   value_de = 'untergegangen',
   value_fr = 'disparue',
   value_it = 'decaduta',
   value_ro = 'rrr_untergegangen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gone',
   display_de = 'untergegangen',
   display_fr = 'disparue',
   display_it = '',
   display_ro = ''
WHERE code = 9048;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8649,8649) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'runoff_prevention_retention_infiltration',
   value_de = 'Abflussvermeidung_Retention_Versickerung',
   value_fr = 'limitation_ecoulement_retention_infiltration',
   value_it = 'limitazione_deflusso_ritenzione_infiltrazione',
   value_ro = 'rrr_Abflussvermeidung_Retention_Versickerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Massnahmen in der Liegenschaftsentwässerung zur Förderung des kleinräumigen Wasserkreislaufes',
   description_de = 'Massnahmen in der Liegenschaftsentwässerung zur Förderung des kleinräumigen Wasserkreislaufes',
   description_fr = 'Mesures de l''évacuation des eaux des biens-fonds visant à favoriser la circulation de l''eau à petite échelle',
   description_it = 'Misure nell''ambito dello smaltimento delle acque sui fondi per favorire il ciclo dell''acqua a livello locale',
   description_ro = 'rrr_Massnahmen in der Liegenschaftsentwässerung zur Förderung des kleinräumigen Wasserkreislaufes.',
   display_en = 'runoff_prevention_retention_infiltration',
   display_de = 'Abflussvermeidung_Retention_Versickerung',
   display_fr = 'limitation écoulement rétention infiltration',
   display_it = '',
   display_ro = ''
WHERE code = 8649;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4653,4653) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'administrative_mesure',
   value_de = 'administrative_Massnahme',
   value_fr = 'mesure_administrative',
   value_it = 'misura_amministrativa',
   value_ro = 'rrr_administrative_Massnahme',
   abbr_en = 'G',
   abbr_de = 'G',
   abbr_fr = 'G',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anpassung von Reglementen, Erarbeiten von vertraglichen Regelungen, etc.',
   description_de = 'Anpassung von Reglementen, Erarbeiten von vertraglichen Regelungen, etc.',
   description_fr = 'Adaptation de règlements, établissement de règles contractuelles, etc.',
   description_it = 'Adeguamento regolamenti, elaborazione disposizioni contrattuali, ecc.',
   description_ro = 'rrr_Anpassung von Reglementen, Erarbeiten von vertraglichen Regelungen, etc.',
   display_en = 'administrative_mesure',
   display_de = 'administrative_Massnahme',
   display_fr = 'mesure administrative',
   display_it = '',
   display_ro = ''
WHERE code = 4653;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (9144,9144) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'WWDRA',
   value_de = 'ALR',
   value_fr = 'EMR',
   value_it = 'smaltimento_acque_zone_rurali',
   value_ro = 'rrr_ALR',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Für alle Massnahmen aus dem Teilprojekt ALR',
   description_de = 'Für alle Massnahmen aus dem Teilprojekt Abwasserentsorgung im ländlichen Raum (ALR)',
   description_fr = 'Pour toutes les mesures du sous-projet Eaux usées en milieu rural (EMR)',
   description_it = 'Per tutte le misure del progetto parziale smaltimento acque nelle zone rurali',
   description_ro = 'rrr_Für alle Massnahmen aus dem Teilprojekt ALR',
   display_en = 'WWDRA',
   display_de = 'ALR',
   display_fr = 'EMR',
   display_it = '',
   display_ro = ''
WHERE code = 9144;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (5036,5036) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 5036;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4654,4654) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'abolishment',
   value_de = 'Aufhebung',
   value_fr = 'suppression',
   value_it = 'soppressione',
   value_ro = '',
   abbr_en = 'G',
   abbr_de = 'G',
   abbr_fr = 'G',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ausserbetriebnahme oder Rückbau von bestehenden Anlagen',
   description_de = 'Ausserbetriebnahme oder Rückbau von bestehenden Anlagen',
   description_fr = 'Mise hors service ou déconstruction d''installations existantes',
   description_it = 'Messa fuori esercizio o smantellamento di impianti esistenti',
   description_ro = 'rrr_Ausserbetriebnahme oder Rückbau von bestehenden Anlagen',
   display_en = 'abolishment',
   display_de = 'Aufhebung',
   display_fr = 'suppréssion',
   display_it = '',
   display_ro = ''
WHERE code = 4654;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4657,4657) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'datamanagement',
   value_de = 'Datenmanagement',
   value_fr = 'gestion_des_donnees',
   value_it = 'gestione_dati',
   value_ro = 'rrr_Datenmanagement',
   abbr_en = 'D',
   abbr_de = 'D',
   abbr_fr = 'D',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'datamanagement',
   display_de = 'Datenmanagement',
   display_fr = 'géstion des données',
   display_it = '',
   display_ro = ''
WHERE code = 4657;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8706,8706) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'maintenance_replacement',
   value_de = 'Erhaltung_Erneuerung',
   value_fr = 'maintenance_renouvellement',
   value_it = 'manutenzione_rinnovo',
   value_ro = 'rrr_Erhaltung_Erneuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   description_de = 'Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   description_fr = 'Mise en place sur l’ancien tracé ou sur un nouveau de nouvelles canalisations d''eaux usées qui intègrent la fonction des anciennes (SN EN 752).',
   description_it = 'Realizzazione di nuove canalizzazioni per acque di scarico nel tracciato attuale o in tracciato diverso; i nuovi impianti comprendono la funzione delle canalizzazioni originali (SN EN 752)',
   description_ro = 'rrr_Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   display_en = 'maintenance_replacement',
   display_de = 'Erhaltung_Erneuerung',
   display_fr = 'maintenance renouvellement',
   display_it = '',
   display_ro = ''
WHERE code = 8706;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8648,8648) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'maintenance_cleaning',
   value_de = 'Erhaltung_Reinigung',
   value_fr = 'maintenance_nettoyage',
   value_it = 'manutenzione_pulizia',
   value_ro = 'rrr_Erhaltung_Reinigung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reinigung oder Entleerung',
   description_de = 'Reinigung oder Entleerung',
   description_fr = 'Nettoyage ou vidange',
   description_it = 'Pulizia o svuotamento',
   description_ro = 'rrr_Reinigung oder Entleerung',
   display_en = 'maintenance_cleaning',
   display_de = 'Erhaltung_Reinigung',
   display_fr = 'maintenance nettoyage',
   display_it = '',
   display_ro = ''
WHERE code = 8648;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8646,8646) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'maintenance_renovation_repair',
   value_de = 'Erhaltung_Renovierung_Reparatur',
   value_fr = 'maintenance_renovation_reparation',
   value_it = 'manutenzione_rinnovo_riparazione',
   value_ro = 'rrr_Erhaltung_Renovierung_Reparatur',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Renovierung: Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz. Reparatur:  Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752).',
   description_de = 'Renovierung: Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz. Reparatur:  Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752).',
   description_fr = 'Rénovation: mesures d’amélioration de la capacité fonctionnelle actuelle des canalisations d’eaux usées impliquant tout ou partie de leur substance originelle (SN EN 752). Dans des directives plus anciennes le terme "Assainissement" était utilisé. Réparation: mesures d’élimination de dommages d’étendue limitée (SN EN 752).',
   description_it = 'Rinnovo: misure volte a migliorare la funzionalità attuale delle canalizzazioni mediante utilizzo completo o parziale della sostanza originale. Riparazione: misure volte a eliminare danni a livello locale (SN EN 752)',
   description_ro = 'rrr_Renovierung: Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz. Reparatur:  Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752).',
   display_en = 'maintenance_renovation_repair',
   display_de = 'Erhaltung_Renovierung_Reparatur',
   display_fr = 'maintenance rénovation réparation',
   display_it = '',
   display_ro = ''
WHERE code = 8646;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8647,8647) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'maintenance_unknown',
   value_de = 'Erhaltung_unbekannt',
   value_fr = 'maintenance_inconnue',
   value_it = 'manutenzione_sconosciuto',
   value_ro = 'rrr_Erhaltung_unbekannt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Falls die Erhaltungsmassnahme noch nicht spezifiziert ist',
   description_de = 'Falls die Erhaltungsmassnahme noch nicht spezifiziert ist',
   description_fr = 'Si la mesure de maintenance n''est pas encore spécifiée',
   description_it = 'Qualora la misura di manutenzione non sia ancora specificata',
   description_ro = 'rrr_Falls die Erhaltungsmassnahme noch nicht spezifiziert ist',
   display_en = 'maintenance_unknown',
   display_de = 'Erhaltung_unbekannt',
   display_fr = 'maintenance inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 8647;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4659,4659) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'sewer_infiltration_water_reduction',
   value_de = 'Fremdwasserreduktion',
   value_fr = 'reduction_ecp',
   value_it = 'riduzione_acque_chiare',
   value_ro = 'rrr_Fremdwasserreduktion',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sewer_infiltration_water_reduction',
   display_de = 'Fremdwasserreduktion',
   display_fr = 'réduction_ecp',
   display_it = '',
   display_ro = ''
WHERE code = 4659;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8645,8645) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'function_change',
   value_de = 'Funktionsaenderung',
   value_fr = 'changement_de_fonction',
   value_it = 'modifica_funzione',
   value_ro = 'rrr_Funktionsaenderung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Z.B. Änderung der Nutzungsart eines Kanalabschnitts. Für Sonderbauwerke den Wert Sonderbauwerk_Anpassung verwenden.',
   description_de = 'Z.B. Änderung der Nutzungsart eines Kanalabschnitts. Für Sonderbauwerke den Wert Sonderbauwerk_Anpassung verwenden.',
   description_fr = 'P. ex. modification du genre d''utilisation d''un tronçon de canalisation. Pour des ouvrages spéciaux, utiliser la valeur "ouvrage_special_adaptation".',
   description_it = 'Ad es. modifica del tipo di utilizzo di un tratto di collettore. Per manufatti speciali utilizzare il valore manufatto_speciale_modifica.',
   description_ro = 'rrr:Z.B. Änderung der Nutzungsart eines Kanalabschnitts. Für Sonderbauwerke den Wert Sonderbauwerk_Anpassung verwenden.',
   display_en = 'function_change',
   display_de = 'Funktionsaenderung',
   display_fr = 'changement de fonction',
   display_it = '',
   display_ro = ''
WHERE code = 8645;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4660,4660) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'gwdp_elaboration',
   value_de = 'GEP_Bearbeitung',
   value_fr = 'elaboration_PGEE',
   value_it = 'elaborazione_PGS',
   value_ro = 'rrr_GEP_Bearbeitung',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Alle Arbeiten im Zusammenhang mit der Überarbeitung oder Nachführung des GEP',
   description_de = 'Alle Arbeiten im Zusammenhang mit der Überarbeitung oder Nachführung des GEP',
   description_fr = 'Tous les travaux en lien avec la révison ou la mise à jour du PGEE',
   description_it = 'Tutti i lavori relativi alla revisione o all''aggiornamento del PGS',
   description_ro = 'rrr_Alle Arbeiten im Zusammenhang mit der Überarbeitung oder Nachführung des GEP',
   display_en = 'gwdp_elaboration',
   display_de = 'GEP_Bearbeitung',
   display_fr = 'élaboration PGEE',
   display_it = '',
   display_ro = ''
WHERE code = 4660;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4662,4662) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'control_and_surveillance',
   value_de = 'Kontrolle_und_Ueberwachung',
   value_fr = 'controle_et_surveillence',
   value_it = 'controllo_monitoraggio',
   value_ro = 'rrr_Kontrolle_und_Ueberwachung',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'control_and_surveillance',
   display_de = 'Kontrolle_und_Ueberwachung',
   display_fr = 'contrôle et surveillence',
   display_it = '',
   display_ro = ''
WHERE code = 4662;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8639,8639) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'measures_in_water_body',
   value_de = 'Massnahme_im_Gewaesser',
   value_fr = 'mesure_sur_cours_d_eau',
   value_it = 'intervento_in_corso_d_acqua',
   value_ro = 'rrr_Massnahme_im_Gewaesser',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Neuer Vorschlag Wegleitung Daten der Siedlungsentwässerung 2020: Ersetzt Bachsanierung und Bachrenaturierung als generellerer Begriff.',
   description_de = 'Neuer Vorschlag Wegleitung Daten der Siedlungsentwässerung 2020: Ersetzt Bachsanierung und Bachrenaturierung als generellerer Begriff.',
   description_fr = 'Nouvelle proposition guide des données PGEE 2020 : remplace assainissement_cours_d_eau et renaturalisation_cours_d_eau comme terme générique.',
   description_it = 'Nuova proposta Direttiva dati PGS 2020: sostituisce risanamento e rinaturazione torrenti come concetto più generico',
   description_ro = '',
   display_en = 'measures_in_water_body',
   display_de = 'Massnahme_im_Gewaesser',
   display_fr = 'mesure sur cours d''eau',
   display_it = '',
   display_ro = ''
WHERE code = 8639;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4666,4666) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'network_extension',
   value_de = 'Netzerweiterung',
   value_fr = 'extension_reseau',
   value_it = 'estensione_rete',
   value_ro = 'rrr_Netzerweiterung',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Neuerstellung von Anlagen. Für Sonderbauwerke und Ersatzneubauten die spezifischen Werte Sonderbauwerk_Neubau bzw. Erhaltung_Erneuerung verwenden.',
   description_de = 'Neuerstellung von Anlagen. Für Sonderbauwerke und Ersatzneubauten die spezifischen Werte Sonderbauwerk_Neubau bzw. Erhaltung_Erneuerung verwenden.',
   description_fr = 'Construction de nouvelles installations. Pour des ouvrages spéciaux et des reconstructions, utiliser les valeurs spécifiques "ouvrage_spécial_nouvelle_cosntruction" et "maintenance_renouvellement".',
   description_it = 'Costruzione di nuovi impianti. Per manufatti speciali e costruzioni sostitutive utilizzare i valori specifici manufatto speciale_costruzione o conservazione_rinnovo.',
   description_ro = 'rrr_Neuerstellung von Anlagen. Für Sonderbauwerke und Ersatzneubauten die spezifischen Werte Sonderbauwerk_Neubau bzw. Erhaltung_Erneuerung verwenden.',
   display_en = 'network_extension',
   display_de = 'Netzerweiterung',
   display_fr = 'extensino réseau',
   display_it = '',
   display_ro = ''
WHERE code = 4666;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8707,8707) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'special_construction_customization',
   value_de = 'Sonderbauwerk_Anpassung',
   value_fr = 'ouvrage_special_adaptation',
   value_it = 'manufatto_speciale_modifica',
   value_ro = 'rrr_Sonderbauwerk_Anpassung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hydraulisch-konzeptionelle Anpassungen wie Neueinstellung der Weiterleitmenge oder hydraulische Optimierung. Nicht verwenden für reine Erhaltungsmassnahmen.',
   description_de = 'Hydraulisch-konzeptionelle Anpassungen wie Neueinstellung der Weiterleitmenge oder hydraulische Optimierung. Nicht verwenden für reine Erhaltungsmassnahmen.',
   description_fr = 'Adaptations de la conception hydraulique, telles que nouveau réglage du débit de réacheminement ou optimisation hydraulique. Ne pas utiliser pour des mesures de maintenance pures.',
   description_it = 'Modifiche idrauliche/concettuali come nuova impostazione della quantità della portata conservata od ottimizzazione idraulica. Non utilizzare per misure di manutenzione costruttiva.',
   description_ro = 'rrr_Hydraulisch-konzeptionelle Anpassungen wie Neueinstellung der Weiterleitmenge oder hydraulische Optimierung. Nicht verwenden für reine Erhaltungsmassnahmen.',
   display_en = 'special_construction_customization',
   display_de = 'Sonderbauwerk_Anpassung',
   display_fr = 'ouvrage spécial adaptation',
   display_it = '',
   display_ro = ''
WHERE code = 8707;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8705,8705) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'special_construction_new_buildung',
   value_de = 'Sonderbauwerk_Neubau',
   value_fr = 'ouvrage_special_nouvelle_construction',
   value_it = 'manufatto_speciale_nuova_costruzione',
   value_ro = 'rrr_Sonderbauwerk_Neubau',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'special_construction_new_buildung',
   display_de = 'Sonderbauwerk_Neubau',
   display_fr = 'ouvrage spécial nouvelle construction',
   display_it = '',
   display_ro = ''
WHERE code = 8705;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (8650,8650) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'incident_prevention',
   value_de = 'Stoerfallvorsorge',
   value_fr = 'prevention_des_accidents_majeurs',
   value_it = 'prevenzione_incidenti_rilevanti',
   value_ro = 'rrr_Stoerfallvorsorge',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Neuer Vorschlag Wegleitung Daten der Siedlungsentwässerung 2020',
   description_de = 'Neuer Vorschlag Wegleitung Daten der Siedlungsentwässerung 2020',
   description_fr = 'Nouvele proposition guide des données PGEE 2020',
   description_it = 'Nuova proposta Direttiva dati PGS 2020',
   description_ro = 'rrr_Neuer Vorschlag Wegleitung Daten der Siedlungsentwässerung 2020',
   display_en = 'incident_prevention',
   display_de = 'Stoerfallvorsorge',
   display_fr = 'prévention des accidents majeurs',
   display_it = '',
   display_ro = ''
WHERE code = 8650;

--- Adapt tww_vl.measure_category
 INSERT INTO tww_vl.measure_category (code, vsacode) VALUES (4652,4652) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_category SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4652;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (4759,4759) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'M0',
   value_de = 'M0',
   value_fr = 'M0',
   value_it = 'M0',
   value_ro = 'M0',
   abbr_en = 'M0',
   abbr_de = 'M0',
   abbr_fr = 'M0',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'This measure is very urgent and to implement in short term. Time horizone <= 2 years',
   description_de = 'Die Massnahme ist sehr dringend und kurzfristig auszuführen. Zeithorizont <= 2 Jahre',
   description_fr = 'La mesure doit être exécutée en urgence et à très court terme. Délais <= 2 ans',
   description_it = 'La misura è molto urgente e deve essere realizzata a cortissimo termine <= 2 Jahre',
   description_ro = '',
   display_en = 'M0',
   display_de = 'M0',
   display_fr = 'M0',
   display_it = 'M0',
   display_ro = 'M0'
WHERE code = 4759;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (4760,4760) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'M1',
   value_de = 'M1',
   value_fr = 'M1',
   value_it = 'M1',
   value_ro = 'M1',
   abbr_en = 'M1',
   abbr_de = 'M1',
   abbr_fr = 'M1',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'This measure is pressing. Time horizone 3-4 years',
   description_de = 'Die Massnahme ist dringend auszuführen. Zeithorizont 3-4 Jahre',
   description_fr = 'La mesure doit être exécutée en rapidement. Délais 3 à 4 ans',
   description_it = 'La miura è urgente e deve essere realizzata urgentemente. Orizzonte temporale 3-4 anni',
   description_ro = '',
   display_en = 'M1',
   display_de = 'M1',
   display_fr = 'M1',
   display_it = 'M1',
   display_ro = 'M1'
WHERE code = 4760;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (4761,4761) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'M2',
   value_de = 'M2',
   value_fr = 'M2',
   value_it = 'M2',
   value_ro = 'M2',
   abbr_en = 'M2',
   abbr_de = 'M2',
   abbr_fr = 'M2',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'This measure has to be implemented in the medium-term. Time horizone 5-7 years',
   description_de = 'Die Massnahme ist mittelfristig erforderlich. Zeithorizont 5-7 Jahre',
   description_fr = 'La mesure est nécessaire à moyen terme. Délais 5 à 7 ans',
   description_it = 'La misura è necessaria a medio termine. Orizzonte temporale da 5 a 7 anni.',
   description_ro = '',
   display_en = 'M2',
   display_de = 'M2',
   display_fr = 'M2',
   display_it = 'M2',
   display_ro = 'M2'
WHERE code = 4761;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (4762,4762) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'M3',
   value_de = 'M3',
   value_fr = 'M3',
   value_it = 'M3',
   value_ro = 'M3',
   abbr_en = 'M3',
   abbr_de = 'M3',
   abbr_fr = 'M3',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'This measure has to be implemented in the long-term. Time horizone 7-10 years',
   description_de = 'Die Massnahme kann längerfristig geplant werden. Zeithorizont 7-10 Jahre',
   description_fr = 'La mesure peut être planifiée à long terme. Délais 7 à 10 ans',
   description_it = 'La misura può essere pianificata a lungo termine. Orizzonte temporale da 7 a 10 anni',
   description_ro = '',
   display_en = 'M3',
   display_de = 'M3',
   display_fr = 'M3',
   display_it = 'M3',
   display_ro = 'M3'
WHERE code = 4762;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (4763,4763) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'M4',
   value_de = 'M4',
   value_fr = 'M4',
   value_it = 'M4',
   value_ro = 'M4',
   abbr_en = 'M4',
   abbr_de = 'M4',
   abbr_fr = 'M4',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'This measure can wait until the next revision of the General Water Drainage Planning (GWDP) . Time horizone >= 10 years',
   description_de = 'Die Massnahme kann bis zur nächsten GEP-Überarbeitung warten. Zeithorizont >= 10 Jahre',
   description_fr = 'La mesure peut attendre la prochaine mise à jour du PGEE. Délais >= 10 ans',
   description_it = 'La misura può aspettare fino al prossimo aggiornamento PGS. Orizzonte temporale >= 10 anni',
   description_ro = '',
   display_en = 'M4',
   display_de = 'M4',
   display_fr = 'M4',
   display_it = 'M4',
   display_ro = 'M4'
WHERE code = 4763;

--- Adapt tww_vl.measure_priority
 INSERT INTO tww_vl.measure_priority (code, vsacode) VALUES (5584,5584) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_priority SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5584;

--- Adapt tww_vl.measure_status
 INSERT INTO tww_vl.measure_status (code, vsacode) VALUES (4764,4764) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_status SET
   value_en = 'completed',
   value_de = 'erledigt',
   value_fr = 'regle',
   value_it = 'completato',
   value_ro = 'rrr_erledigt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'completed',
   display_de = 'erledigt',
   display_fr = 'reglé',
   display_it = '',
   display_ro = ''
WHERE code = 4764;

--- Adapt tww_vl.measure_status
 INSERT INTO tww_vl.measure_status (code, vsacode) VALUES (4765,4765) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_status SET
   value_en = 'in_preparation',
   value_de = 'in_Bearbeitung',
   value_fr = 'en_preparation',
   value_it = 'in_allestimento',
   value_ro = 'rrr_in_Bearbeitung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'in_preparation',
   display_de = 'in_Bearbeitung',
   display_fr = 'en préparation',
   display_it = '',
   display_ro = ''
WHERE code = 4765;

--- Adapt tww_vl.measure_status
 INSERT INTO tww_vl.measure_status (code, vsacode) VALUES (4766,4766) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_status SET
   value_en = 'pending',
   value_de = 'pendent',
   value_fr = 'en_suspens',
   value_it = 'in_attesa',
   value_ro = 'rrr_pendent',
   abbr_en = 'in_',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pending',
   display_de = 'pendent',
   display_fr = 'en suspens',
   display_it = '',
   display_ro = ''
WHERE code = 4766;

--- Adapt tww_vl.measure_status
 INSERT INTO tww_vl.measure_status (code, vsacode) VALUES (4767,4767) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_status SET
   value_en = 'suspended',
   value_de = 'sistiert',
   value_fr = 'supprime',
   value_it = 'sospesa',
   value_ro = 'rrr_sistiert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'suspended',
   display_de = 'sistiert',
   display_fr = 'supprimé',
   display_it = '',
   display_ro = ''
WHERE code = 4767;

--- Adapt tww_vl.measure_status
 INSERT INTO tww_vl.measure_status (code, vsacode) VALUES (4768,4768) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measure_status SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4768;

--- Adapt tww_vl.mutation_kind
 INSERT INTO tww_vl.mutation_kind (code, vsacode) VALUES (5523,5523) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mutation_kind SET
   value_en = 'created',
   value_de = 'erstellt',
   value_fr = 'cree',
   value_it = 'creato',
   value_ro = 'creat',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'created',
   display_de = 'erstellt',
   display_fr = 'crée',
   display_it = '',
   display_ro = ''
WHERE code = 5523;

--- Adapt tww_vl.mutation_kind
 INSERT INTO tww_vl.mutation_kind (code, vsacode) VALUES (5582,5582) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mutation_kind SET
   value_en = 'changed',
   value_de = 'geaendert',
   value_fr = 'changee',
   value_it = 'modificato',
   value_ro = 'modificat',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'changed',
   display_de = 'geaendert',
   display_fr = 'changeé',
   display_it = '',
   display_ro = ''
WHERE code = 5582;

--- Adapt tww_vl.mutation_kind
 INSERT INTO tww_vl.mutation_kind (code, vsacode) VALUES (5583,5583) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mutation_kind SET
   value_en = 'deleted',
   value_de = 'geloescht',
   value_fr = 'effacee',
   value_it = 'eliminata',
   value_ro = 'eliminate',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'deleted',
   display_de = 'geloescht',
   display_fr = 'effacée',
   display_it = '',
   display_ro = 'eliminata'
WHERE code = 5583;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8986,8986) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Matching MGDM 134.5 andere',
   description_de = 'Matching MGDM 134.5 andere',
   description_fr = 'Matching MGDM 134.5 andere',
   description_it = 'Matching MGDM 134.5 andere',
   description_ro = 'Matching MGDM 134.5 andere',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 8986;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8978,8978) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'idividual_municipality',
   value_de = 'Einzelgemeinde',
   value_fr = 'commune_individuelle',
   value_it = 'zzz_Einzelgemeinde',
   value_ro = 'rrr_Einzelgemeinde',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einzelgemeinde (Matching MGDM 134.5: Gde)',
   description_de = 'Einzelgemeinde (Matching MGDM 134.5: Gde)',
   description_fr = 'commune individuelle  (Matching MGDM 134.5: Gde)',
   description_it = 'zzz_Einzelgemeinde (Matching MGDM 134.5: Gde)',
   description_ro = '',
   display_en = 'idividual_municipality',
   display_de = 'Einzelgemeinde',
   display_fr = 'commune individuelle',
   display_it = '',
   display_ro = ''
WHERE code = 8978;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8981,8981) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'intermunicipal_agency',
   value_de = 'Interkommunale_Anstalt',
   value_fr = 'etablissement_intercommunal',
   value_it = 'zzz_Interkommunale_Anstalt',
   value_ro = 'rrr_Interkommunale_Anstalt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Interkommunale Anstalt (Matching MGDM 134.5 IKA)',
   description_de = 'Interkommunale Anstalt (Matching MGDM 134.5 IKA)',
   description_fr = 'établissement intercommunal (Matching MGDM 134.5 IKA)',
   description_it = 'zzz_Interkommunale Anstalt (Matching MGDM 134.5 IKA)',
   description_ro = 'rrr_Interkommunale Anstalt (Matching MGDM 134.5 IKA)',
   display_en = 'intermunicipal_agency',
   display_de = 'Interkommunale_Anstalt',
   display_fr = 'établissement intercommunal',
   display_it = '',
   display_ro = ''
WHERE code = 8981;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8985,8985) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'cantonal_administration',
   value_de = 'Kantonale_Verwaltung',
   value_fr = 'administration_cantonale',
   value_it = 'zzz_Kantonale_Verwaltung',
   value_ro = 'rrr_Kantonale_Verwaltung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kantonale Verwaltung (Matching MGDM 134.5 KantVerw), Betreiber aus Klasse Kanton wählen.',
   description_de = 'Kantonale Verwaltung (Matching MGDM 134.5 KantVerw), Betreiber aus Klasse Kanton wählen.',
   description_fr = 'administration cantonale (Matching MGDM 134.5 KantVerw), Choissisez  EXPLOITANT de la classe CANTON.',
   description_it = 'zzz_Kantonale Verwaltung (Matching MGDM 134.5 KantVerw), Betreiber aus Klasse Kanton wählen.',
   description_ro = 'rrr_Kantonale Verwaltung (Matching MGDM 134.5 KantVerw), Betreiber aus Klasse Kanton wählen.',
   display_en = 'cantonal_administration',
   display_de = 'Kantonale_Verwaltung',
   display_fr = 'administration cantonale',
   display_it = '',
   display_ro = ''
WHERE code = 8985;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8983,8983) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'public_private_partnership',
   value_de = 'Oeffentlich_private_Partnerschaft',
   value_fr = 'partenariat_de_droit_prive',
   value_it = 'zzz_Oeffentlich_private_Partnerschaft',
   value_ro = 'rrr_Oeffentlich_private_Partnerschaft',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Öffentlich-private Partnerschaft (Matching MGDM 134.5 PPP)',
   description_de = 'Öffentlich-private Partnerschaft (Matching MGDM 134.5 PPP)',
   description_fr = 'partenariat de droit privé (Matching MGDM 134.5 PPP)',
   description_it = 'zzz_Öffentlich-private Partnerschaft (Matching MGDM 134.5 PPP)',
   description_ro = 'rrr_Öffentlich-private Partnerschaft (Matching MGDM 134.5 PPP)',
   display_en = 'public_private_partnership',
   display_de = 'Oeffentlich_private_Partnerschaft',
   display_fr = 'partenariat de droit privé',
   display_it = '',
   display_ro = ''
WHERE code = 8983;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8982,8982) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'public_law_stock_company',
   value_de = 'Oeffentlich_rechtliche_Aktiengesellschaft',
   value_fr = 'societe_anonyme_de_droit_public',
   value_it = 'zzz_Oeffentlich_rechtliche_Aktiengesellschaft',
   value_ro = 'rrr_Oeffentlich_rechtliche_Aktiengesellschaft',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Öffentlich-rechtliche Aktiengesellschaft (Matching MGDM 134.5 OeRAG)',
   description_de = 'Öffentlich-rechtliche Aktiengesellschaft (Matching MGDM 134.5 OeRAG)',
   description_fr = 'société anonyme de droit public(Matching MGDM 134.5 OeRAG)',
   description_it = 'zzz_Öffentlich-rechtliche Aktiengesellschaft (Matching MGDM 134.5 OeRAG)',
   description_ro = 'rrr_Öffentlich-rechtliche Aktiengesellschaft (Matching MGDM 134.5 OeRAG)',
   display_en = 'public_law_stock_company',
   display_de = 'Oeffentlich_rechtliche_Aktiengesellschaft',
   display_fr = 'societé anonyme de droit public',
   display_it = '',
   display_ro = ''
WHERE code = 8982;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8984,8984) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'private_company',
   value_de = 'Privates_Unternehmen',
   value_fr = 'entreprise_privee',
   value_it = 'zzz_Privates_Unternehmen',
   value_ro = 'rrr_Privates_Unternehmen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Privates Unternehmen (Matching MGDM 134.5 PrivUnt)',
   description_de = 'Privates Unternehmen (Matching MGDM 134.5 PrivUnt)',
   description_fr = 'entreprise privée (Matching MGDM 134.5 PrivUnt)',
   description_it = 'zzz_Privates Unternehmen (Matching MGDM 134.5 PrivUnt)',
   description_ro = 'rrr_Privates Unternehmen (Matching MGDM 134.5 PrivUnt)',
   display_en = 'private_company',
   display_de = 'Privates_Unternehmen',
   display_fr = 'entreprise privée',
   display_it = '',
   display_ro = ''
WHERE code = 8984;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8980,8980) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'domicile_municipality',
   value_de = 'Sitzgemeinde',
   value_fr = 'commune_d_implantation',
   value_it = 'zzz_Sitzgemeinde',
   value_ro = 'rrr_Sitzgemeinde',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sitzgemeinde (Matching MGDM 134.5 SitzGde)',
   description_de = 'Sitzgemeinde (Matching MGDM 134.5 SitzGde)',
   description_fr = 'commune d’implantation (Matching MGDM 134.5 SitzGde)',
   description_it = 'zzz_Sitzgemeinde (Matching MGDM 134.5 SitzGde)',
   description_ro = 'rrr_Sitzgemeinde (Matching MGDM 134.5 SitzGde)',
   display_en = 'domicile_municipality',
   display_de = 'Sitzgemeinde',
   display_fr = 'commune d''implantation',
   display_it = '',
   display_ro = ''
WHERE code = 8980;

--- Adapt tww_vl.waste_water_treatment_plant_operator_type
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode) VALUES (8979,8979) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_plant_operator_type SET
   value_en = 'special_purpose_association',
   value_de = 'Zweckverband',
   value_fr = 'groupement',
   value_it = 'zzz_Zweckverband',
   value_ro = 'rrr_Zweckverband',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zweckverband (Matching MGDM 134.5 Verband)',
   description_de = 'Zweckverband (Matching MGDM 134.5 Verband)',
   description_fr = 'groupement (Matching MGDM 134.5 Verband)',
   description_it = 'zzz_Zweckverband (Matching MGDM 134.5 Verband)',
   description_ro = 'rrr_Zweckverband (Matching MGDM 134.5 Verband)',
   display_en = 'special_purpose_association',
   display_de = 'Zweckverband',
   display_fr = 'groupement',
   display_it = '',
   display_ro = ''
WHERE code = 8979;

--- Adapt tww_vl.wastewater_structure_accessibility
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode) VALUES (3444,3444) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_accessibility SET
   value_en = 'covered',
   value_de = 'ueberdeckt',
   value_fr = 'couvert',
   value_it = 'coperto',
   value_ro = 'capac',
   abbr_en = '',
   abbr_de = 'UED',
   abbr_fr = 'COU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Here, for example, you have to dig first until you can open the lid',
   description_de = 'Hier muss man z.B. zuerst graben, bis man den Deckel öffnen kann',
   description_fr = 'Il faut par exemple déterrer le couvercle avant de pouvoir l''ouvrir',
   description_it = 'Qui, ad esempio, prima di poter aprire il chiusino bisogna scavare.',
   description_ro = 'Aici, de exemplu, trebuie sa sapi mai întâi pâna când po?i deschide capacul.',
   display_en = 'covered',
   display_de = 'ueberdeckt',
   display_fr = 'couvert',
   display_it = '',
   display_ro = 'capac'
WHERE code = 3444;

--- Adapt tww_vl.wastewater_structure_accessibility
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode) VALUES (3447,3447) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_accessibility SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3447;

--- Adapt tww_vl.wastewater_structure_accessibility
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode) VALUES (3446,3446) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_accessibility SET
   value_en = 'inaccessible',
   value_de = 'unzugaenglich',
   value_fr = 'inaccessible',
   value_it = 'non_accessibile',
   value_ro = 'inaccesibil',
   abbr_en = '',
   abbr_de = 'UZG',
   abbr_fr = 'NA',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'No free access - barriers must be cleared away, access authorizations must be requested in advance, keys are necessary, etc.',
   description_de = 'Kein freier Zugang - es sind Absperrungen wegzuräumen, Zugangsberechtigungen vorgängig anzufordern, Schlüssel notwendig, etc.',
   description_fr = 'Pas d''accès libre - des barrières doivent être enlevées, des autorisations d''accès doivent être demandées au préalable, des clés sont nécessaires, etc.',
   description_it = 'Non è possibile accedere liberamente: le barriere devono essere rimosse, le autorizzazioni all''accesso devono essere richieste in anticipo, sono necessarie le chiavi, ecc.',
   description_ro = 'Nu exista acces liber - barierele trebuie îndepartate, autoriza?iile de acces trebuie solicitate în prealabil, sunt necesare chei etc.',
   display_en = 'inaccessible',
   display_de = 'unzugaenglich',
   display_fr = 'inaccessible',
   display_it = '',
   display_ro = 'inaccesibil'
WHERE code = 3446;

--- Adapt tww_vl.wastewater_structure_accessibility
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode) VALUES (3445,3445) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_accessibility SET
   value_en = 'accessible',
   value_de = 'zugaenglich',
   value_fr = 'accessible',
   value_it = 'accessibile',
   value_ro = 'accessibil',
   abbr_en = '',
   abbr_de = 'ZG',
   abbr_fr = 'A',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zugänglich für eine Person (und nicht unbedingt ein Fahrzeug)',
   description_de = 'Zugänglich für eine Person (und nicht unbedingt ein Fahrzeug)',
   description_fr = 'Accessible pour une personne (et pas nécessairement pour un véhicule)',
   description_it = 'Possibilità d''accesso per una persona (nonnecessariamente per veicoli)',
   description_ro = 'Disponibil pentru o persoana (?i nu neaparat un vehicul)',
   display_en = 'accessible',
   display_de = 'zugaenglich',
   display_fr = 'accessible',
   display_it = '',
   display_ro = 'accessibil'
WHERE code = 3445;

--- Adapt tww_vl.wastewater_structure_elevation_determination
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode) VALUES (9321,9321) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_elevation_determination SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precise',
   value_it = 'precisa',
   value_ro = 'precisa',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précise',
   display_it = '',
   display_ro = 'precisa'
WHERE code = 9321;

--- Adapt tww_vl.wastewater_structure_elevation_determination
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode) VALUES (9323,9323) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_elevation_determination SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9323;

--- Adapt tww_vl.wastewater_structure_elevation_determination
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode) VALUES (9322,9322) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_elevation_determination SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecise',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprécise',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 9322;

--- Adapt tww_vl.wastewater_structure_financing
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode) VALUES (5510,5510) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_financing SET
   value_en = 'public',
   value_de = 'oeffentlich',
   value_fr = 'public',
   value_it = 'pubblico',
   value_ro = 'publica',
   abbr_en = 'PU',
   abbr_de = 'OE',
   abbr_fr = 'PU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gesamtheit aller erdverlegten Leitungen und Bauwerke, die über Abwassergebühren gemäss Art. 60a des Gewässerschutzgesetzes finanziert werden',
   description_de = 'Gesamtheit aller erdverlegten Leitungen und Bauwerke, die über Abwassergebühren gemäss Art. 60a des Gewässerschutzgesetzes finanziert werden',
   description_fr = 'L’intégralité des ouvrages d’assainissement qui sont financés selon l’art. 60a de la loi sur la protection des eaux (LEaux).',
   description_it = 'Integralità delle condotte sotterrate e manufatti, che vengono finaziati con le tasse per lo smaltimento acque secondo l''art. 60a della legge sulla protezione delle acque.',
   description_ro = '',
   display_en = 'public',
   display_de = 'oeffentlich',
   display_fr = 'public',
   display_it = '',
   display_ro = 'publica'
WHERE code = 5510;

--- Adapt tww_vl.wastewater_structure_financing
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode) VALUES (5511,5511) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_financing SET
   value_en = 'private',
   value_de = 'privat',
   value_fr = 'prive',
   value_it = 'privato',
   value_ro = 'privata',
   abbr_en = 'PR',
   abbr_de = 'PR',
   abbr_fr = 'PR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gesamtheit aller erdverlegten Leitungen und Bauwerke, die nicht über Abwassergebühren gemäss Art. 60a des Gewässerschutzgesetzes finanziert werden',
   description_de = 'Gesamtheit aller erdverlegten Leitungen und Bauwerke, die nicht über Abwassergebühren gemäss Art. 60a des Gewässerschutzgesetzes finanziert werden',
   description_fr = 'L’intégralité des conduites souterraines et ouvrages construits à l’intérieur et à l’extérieur des immeuble dans le domaine d’application de la SN 592 000, qui ne sont pas financés par les taxes d’épuration selon l’art. 60a de la loi sur la protection des eaux (LEaux)',
   description_it = 'Integralità delle condotte sotterrate e manufatti, che non vengono finaziati con le tasse per lo smaltimento acque secondo l''art. 60a della legge sulla protezione delle acque.',
   description_ro = '',
   display_en = 'private',
   display_de = 'privat',
   display_fr = 'privé',
   display_it = '',
   display_ro = 'privata'
WHERE code = 5511;

--- Adapt tww_vl.wastewater_structure_financing
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode) VALUES (5512,5512) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_financing SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = 'U',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5512;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (5370,5370) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'urgent',
   value_de = 'dringend',
   value_fr = 'urgente',
   value_it = 'urgente',
   value_ro = 'urgent',
   abbr_en = 'UR',
   abbr_de = 'DR',
   abbr_fr = 'UR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Die Massnahmen sind dringend auszuführen. Sofortmassnahmen wie bei kurzfristig sind zu prüfen. Zeithorizont 3-4 Jahre.',
   description_de = 'Die Massnahmen sind dringend auszuführen. Sofortmassnahmen wie bei kurzfristig sind zu prüfen. Zeithorizont 3-4 Jahre.',
   description_fr = 'Les mesures doivent être réalisées d’urgence. Des mesures immédiates doivent être envisagées comme pour le degré a_court_terme. Délai 3-4 ans',
   description_it = 'Gli interventi sono urgenti. È da valutare la necessità di eventuali interventi immediati come nel grado 0. Orizzonte 3-4 anni.',
   description_ro = 'La fel ca la termen_scurt dar 3-4 ani',
   display_en = 'urgent',
   display_de = 'dringend',
   display_fr = '',
   display_it = '',
   display_ro = 'urgent'
WHERE code = 5370;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (5368,5368) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucune',
   value_it = 'nessuno',
   value_ro = 'niciuna',
   abbr_en = 'N',
   abbr_de = 'K',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Es sind keine Massnahmen bis zur nächsten Zustandserfassung und Zustandsbeurteilung erforderlich. Zeithorizont >= 10 Jahre.',
   description_de = 'Es sind keine Massnahmen bis zur nächsten Zustandserfassung und Zustandsbeurteilung erforderlich. Zeithorizont >= 10 Jahre.',
   description_fr = 'Aucune mesure n’est nécessaire jusqu’au prochain relevé et à la prochaine évaluation de l’état. Délai >= 10 ans',
   description_it = 'Non sono necessari interventi fino al prossimo rilevamento dello stato e relativa valutazione. Orizzonte >=10 anni',
   description_ro = 'Nu este necesara nici o masura pana la urmatoarea verificare. De la 10 ani in sus.',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucune',
   display_it = '',
   display_ro = 'niciuna'
WHERE code = 5368;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (2,2) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'short_term',
   value_de = 'kurzfristig',
   value_fr = 'a_court_terme',
   value_it = 'breve_termine',
   value_ro = 'termen_scurt',
   abbr_en = 'ST',
   abbr_de = 'KF',
   abbr_fr = 'CT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Die Massnahmen sind sehr dringend und kurzfristig auszuführen. Im Sinne von Sofortmassnahmen können durch provisorische lokale Reparaturen weitere Schäden temporär verhindert werden. Zeithorizont <= 2 Jahre',
   description_de = 'Die Massnahmen sind sehr dringend und kurzfristig auszuführen. Im Sinne von Sofortmassnahmen können durch provisorische, lokale Reparaturen weitere Schäden temporär verhindert werden. Zeithorizont <= 2 Jahre',
   description_fr = 'Les mesures doivent être réalisées de façon très urgente et à court terme. A titre de mesures immédiates, des réparations locales provisoires permettent de prévenir temporairement d’autres dommages. Délai <= 2 ans',
   description_it = 'Gli interventi sono molto urgenti e da eseguire entro breve termine. Con interventi immediati di riparazioni locali provvisorie possono essere evitati temporaneamente maggiori danni. Orizzonte <=2 anni',
   description_ro = 'Masuri necesare in termen scurt, maxim 2 ani. Se pot lua masuri provizorii pentru a preveni alte pagube.',
   display_en = 'short_term',
   display_de = 'kurzfristig',
   display_fr = 'à court terme',
   display_it = '',
   display_ro = 'termen scurt'
WHERE code = 2;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (9295,9295) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'long_term',
   value_de = 'langfristig',
   value_fr = 'a_long_terme',
   value_it = 'lungo_termine',
   value_ro = 'termen_lung',
   abbr_en = 'LT',
   abbr_de = 'LF',
   abbr_fr = 'LT',
   abbr_it = 'LT',
   abbr_ro = 'TL',
   description_en = 'These measures can be planned in the long-term. Time horizone 8-10 years',
   description_de = 'Die Massnahmen können längerfristig geplant werden. Zeithorizont 8-10 Jahre.',
   description_fr = 'Les mesures peuvent être projetées à long terme. Délai 8 - 10 ans',
   description_it = 'Gli interventi possono essere pianificati a lunga scadenza. Orizzonte 8-10 anni.',
   description_ro = '8-10 ani',
   display_en = 'long_term',
   display_de = 'langfristig',
   display_fr = 'à long terme',
   display_it = '',
   display_ro = 'termen lung'
WHERE code = 9295;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (3,3) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'medium_term',
   value_de = 'mittelfristig',
   value_fr = 'a_moyen_terme',
   value_it = 'medio_termine',
   value_ro = 'termen_mediu',
   abbr_en = '',
   abbr_de = 'MF',
   abbr_fr = 'MT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Die Massnahmen sind mittelfristig erforderlich. Zeithorizont 5-7 Jahre.',
   description_de = 'Die Massnahmen sind mittelfristig erforderlich. Zeithorizont 5-7 Jahre.',
   description_fr = 'Les mesures sont nécessaires à moyen terme. Délai 5 à 7 ans',
   description_it = 'Gli interventi sono necessari a media scadenza. Orizzonte 5-7 anni.',
   description_ro = '5-7 ani',
   display_en = 'medium_term',
   display_de = 'mittelfristig',
   display_fr = 'à moyen terme',
   display_it = '',
   display_ro = 'termen mediu'
WHERE code = 3;

--- Adapt tww_vl.wastewater_structure_renovation_necessity
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode) VALUES (5369,5369) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_renovation_necessity SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5369;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4602,4602) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 4602;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4603,4603) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'field',
   value_de = 'Feld',
   value_fr = 'dans_les_champs',
   value_it = 'campo_aperto',
   value_ro = 'in_camp',
   abbr_en = 'FI',
   abbr_de = 'FE',
   abbr_fr = 'FE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'In the field (profile types for digging based on norm SIA 190)',
   description_de = 'Im Feld (Profiltypen für Grabenarbeiten nach Norm SIA 190)',
   description_fr = 'Dans les champs (type de profile selon norme SIA 190)',
   description_it = 'In campo aperto (tipi di profilo secondo norma SIA 190)',
   description_ro = 'în conformitate cu standardul SIA 190)',
   display_en = 'field',
   display_de = 'Feld',
   display_fr = 'dans les champs',
   display_it = '',
   display_ro = 'in camp'
WHERE code = 4603;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4606,4606) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'renovation_conduction_excavator',
   value_de = 'Sanierungsleitung_Bagger',
   value_fr = 'conduite_d_assainissement_retro',
   value_it = 'canalizazzione_risanmento_scavatrice',
   value_ro = 'conducte_excavate',
   abbr_en = 'RCE',
   abbr_de = 'SBA',
   abbr_fr = 'CAR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bei Sanierungsleitungen die mit einem Bagger gebaut wurden',
   description_de = 'Bei Sanierungsleitungen, die mit einem Bagger gebaut wurden',
   description_fr = 'Conduites d’assainissement posées par rétrocaveuse',
   description_it = 'Canalizzazioni di risanmento realizzate con scavatrice',
   description_ro = 'Pentru conductele care au fost construite prin excavare',
   display_en = 'renovation_conduction_excavator',
   display_de = 'Sanierungsleitung_Bagger',
   display_fr = 'conduite d''assainissement rétro',
   display_it = '',
   display_ro = 'conducte excavate'
WHERE code = 4606;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4605,4605) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'renovation_conduction_ditch_cutter',
   value_de = 'Sanierungsleitung_Grabenfraese',
   value_fr = 'conduite_d_assainissement_trancheuse',
   value_it = 'condotta_risanamento_scavafossi',
   value_ro = 'conducta_taiere_sant',
   abbr_en = 'RCD',
   abbr_de = 'SGF',
   abbr_fr = 'CAT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bei Sanierungsleitungen die mit einer Grabenfräse gebaut wurden',
   description_de = 'Bei Sanierungsleitungen, die mit einer Grabenfräse gebaut wurden',
   description_fr = 'Conduites d’assainissement posées par trancheuse',
   description_it = 'Canalizzazioni di risanmento realizzate con scavafossi rotativo',
   description_ro = '',
   display_en = 'renovation_conduction_ditch_cutter',
   display_de = 'Sanierungsleitung_Grabenfraese',
   display_fr = 'conduite d''assainissement trancheuse',
   display_it = '',
   display_ro = 'conducta taiere sant'
WHERE code = 4605;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4604,4604) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'road',
   value_de = 'Strasse',
   value_fr = 'sous_route',
   value_it = 'strada',
   value_ro = 'sub_strada',
   abbr_en = 'ST',
   abbr_de = 'ST',
   abbr_fr = 'ST',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_In der Strasse (profile types for digginng based on norm SIA 190)',
   description_de = 'In der Strasse (Profiltypen für Grabenarbeiten nach Norm SIA 190)',
   description_fr = 'sous route (type profile selon norme SIA 190)',
   description_it = 'In strada (tipi di profilo secondo norma SIA 190)',
   description_ro = 'în conformitate cu standardul SIA 190)',
   display_en = 'road',
   display_de = 'Strasse',
   display_fr = 'sous route',
   display_it = '',
   display_ro = 'sub strada'
WHERE code = 4604;

--- Adapt tww_vl.wastewater_structure_rv_construction_type
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode) VALUES (4601,4601) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_rv_construction_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 4601;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (3633,3633) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'inoperative',
   value_de = 'ausser_Betrieb',
   value_fr = 'hors_service',
   value_it = 'fuori_servizio',
   value_ro = 'rrr_ausser_Betrieb',
   abbr_en = 'NO',
   abbr_de = 'AB',
   abbr_fr = 'H',
   abbr_it = 'FS',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inoperative',
   display_de = 'ausser_Betrieb',
   display_fr = 'hors service',
   display_it = '',
   display_ro = ''
WHERE code = 3633;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (8493,8493) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'operational',
   value_de = 'in_Betrieb',
   value_fr = 'en_service',
   value_it = 'in_funzione',
   value_ro = 'functionala',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Once the facility has been commissioned',
   description_de = 'Wenn das Bauwerk in Betrieb genommen wurde',
   description_fr = 'Lorsque l’ouvrage a été mis en service',
   description_it = 'Una volta che l''impianto è stato messo in funzione',
   description_ro = 'Dupa ce instala?ia a fost pusa în func?iune',
   display_en = 'operational',
   display_de = 'in_Betrieb',
   display_fr = 'en service',
   display_it = '',
   display_ro = 'functionala'
WHERE code = 8493;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6530,6530) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'operational.tentative',
   value_de = 'in_Betrieb.provisorisch',
   value_fr = 'en_service.provisoire',
   value_it = 'in_funzione.provvisorio',
   value_ro = 'functionala.provizoriu',
   abbr_en = 'T',
   abbr_de = 'T',
   abbr_fr = 'P',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_provisorisches Bauwerk, welches temporär ein anderes ersetzt (z.B. nach Schadensfall)',
   description_de = 'Provisorisches Bauwerk, welches temporär ein anderes ersetzt (z.B. nach Schadensfall)',
   description_fr = 'Etat provisoire, remplace un ouvrage temporairement (par exemple après dégâts)',
   description_it = 'Manufatto provvisorio, che rimpiazza temporaneamente un altro (p.es. dopo un danno)',
   description_ro = 'Stare provizorie, inlocuieste temporar o structura',
   display_en = 'operational.tentative',
   display_de = 'in_Betrieb.provisorisch',
   display_fr = 'en service.provisoire',
   display_it = '',
   display_ro = 'functionala.provizoriu'
WHERE code = 6530;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6533,6533) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'operational.will_be_suspended',
   value_de = 'in_Betrieb.wird_aufgehoben',
   value_fr = 'en_service.sera_supprime',
   value_it = 'in_funzione.da_eliminare',
   value_ro = 'functionala.va_fi_eliminata',
   abbr_en = '',
   abbr_de = 'WA',
   abbr_fr = 'SS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'operational.will_be_suspended',
   display_de = 'in_Betrieb.wird_aufgehoben',
   display_fr = 'sera supprime',
   display_it = '',
   display_ro = 'functionala.va_fi_eliminata'
WHERE code = 6533;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6523,6523) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'abanndoned.suspended_not_filled',
   value_de = 'tot.aufgehoben_nicht_verfuellt',
   value_fr = 'abandonne.supprime_non_demoli',
   value_it = 'abbandonato.eliminato_non_demolito',
   value_ro = 'abandonata.eliminare_necompletata',
   abbr_en = 'SN',
   abbr_de = 'AN',
   abbr_fr = 'S',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'The sewage structure has been abandoned but not filled in.',
   description_de = 'Das Abwasserbauwerk ist aufgehoben, aber nicht verfüllt.',
   description_fr = 'L''ouvrage est supprimé, mais pas démoli',
   description_it = 'Il manufatto è soppresso ma non demolito',
   description_ro = 'rrr_Das Abwasserbauwerk ist aufgehoben, aber nicht verfüllt.',
   display_en = 'abanndoned.suspended_not_filled',
   display_de = 'tot.aufgehoben_nicht_verfuellt',
   display_fr = 'supprimé non démoli',
   display_it = '',
   display_ro = 'abandonata.eliminare_necompletata'
WHERE code = 6523;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6524,6524) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'abanndoned.suspended_unknown',
   value_de = 'tot.aufgehoben_unbekannt',
   value_fr = 'abandonne.supprime_inconnu',
   value_it = 'abbandonato.eliminato_sconosciuto',
   value_ro = 'abandonata.demolare_necunoscuta',
   abbr_en = 'SU',
   abbr_de = 'AU',
   abbr_fr = 'AI',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Das Abwasserbauwerk ist aufgehoben, aber es ist nicht bekannt, ob es verfüllt ist oder nicht.',
   description_de = 'Das Abwasserbauwerk ist aufgehoben, aber es ist nicht bekannt, ob es verfüllt ist oder nicht.',
   description_fr = 'L''ouvrage du réseau d''assainissement est supprimé, mais l''état de la mise en œuvre est inconnu',
   description_it = 'Il manufatto è stato eliminato, ma non si sa se è stato demolito o no.',
   description_ro = 'rrr_Das Abwasserbauwerk ist aufgehoben, aber es ist nicht bekannt, ob es verfüllt ist oder nicht.',
   display_en = 'abanndoned.suspended_unknown',
   display_de = 'tot.aufgehoben_unbekannt',
   display_fr = 'abandonne.supprimé inconnu',
   display_it = '',
   display_ro = 'abandonata.demolare_necunoscuta'
WHERE code = 6524;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6532,6532) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'abanndoned.filled',
   value_de = 'tot.verfuellt',
   value_fr = 'abandonne.demoli',
   value_it = 'abbandonato.demolito',
   value_ro = 'abandonata.eliminata',
   abbr_en = '',
   abbr_de = 'V',
   abbr_fr = 'D',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Das Abwasserbauwerk ist verfüllt und aufgehoben',
   description_de = 'Das Abwasserbauwerk ist verfüllt und aufgehoben',
   description_fr = 'L''ouvrage est démoli et supprimé',
   description_it = 'Il manufatto è demolito e soppresso.',
   description_ro = 'Structura este demolata si eliminata',
   display_en = 'abanndoned.filled',
   display_de = 'tot.verfuellt',
   display_fr = 'démoli',
   display_it = '',
   display_ro = 'abandonata.eliminata'
WHERE code = 6532;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (3027,3027) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3027;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6526,6526) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'other.calculation_alternative',
   value_de = 'weitere.Berechnungsvariante',
   value_fr = 'autre.variante_de_calcul',
   value_it = 'altro.variante_calcolo',
   value_ro = 'alta.varianta_calcul',
   abbr_en = 'CA',
   abbr_de = 'B',
   abbr_fr = 'C',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other.calculation_alternative',
   display_de = 'weitere.Berechnungsvariante',
   display_fr = 'variante de calcul',
   display_it = '',
   display_ro = 'alta.varianta_calcul'
WHERE code = 6526;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (7959,7959) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'other.planned',
   value_de = 'weitere.geplant',
   value_fr = 'autre.planifie',
   value_it = 'altro.previsto',
   value_ro = 'rrr_weitere.geplant',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = 'PL',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other.planned',
   display_de = 'weitere.geplant',
   display_fr = 'autre.planifié',
   display_it = '',
   display_ro = ''
WHERE code = 7959;

--- Adapt tww_vl.wastewater_structure_status
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode) VALUES (6529,6529) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_status SET
   value_en = 'other.project',
   value_de = 'weitere.Projekt',
   value_fr = 'autre.projet',
   value_it = 'altro.progetto',
   value_ro = 'alta.proiect',
   abbr_en = '',
   abbr_de = 'N',
   abbr_fr = 'PR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Konkretes Bauprojekt vorhanden oder in Ausführung (im Bau). Bei Absicht Status "geplant" verwenden. Nach Abschluss des Baus Wechsel auf Status "in_Betrieb".',
   description_de = 'Konkretes Bauprojekt vorhanden oder in Ausführung (im Bau). Bei Absicht Status "geplant" verwenden. Nach Abschluss des Baus Wechsel auf Status "in_Betrieb".',
   description_fr = 'Projet de construction concret existant ou en cours d''exécution (en construction). En cas d''intention, utiliser le statut "planifié". Une fois la construction terminée, passer au statut "en_exploitation".',
   description_it = 'Esiste un progetto definitivo o il manufatto è in costruzione. Nel caso di intenzione di realizzazione utilizzare lo stato "pianificato". Ad opera realizzata cambiare lo stato in "in_funzione".',
   description_ro = 'Stare care se mentine pana cand proiectul va fi executat.',
   display_en = 'other.project',
   display_de = 'weitere.Projekt',
   display_fr = 'autre.projet',
   display_it = '',
   display_ro = 'alta.proiect'
WHERE code = 6529;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3037,3037) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 3037;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3363,3363) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'Z0',
   value_de = 'Z0',
   value_fr = 'Z0',
   value_it = 'Z0',
   value_ro = 'Z0',
   abbr_en = '',
   abbr_de = 'Z0',
   abbr_fr = 'Z0',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Nicht mehr funktionstüchtig: Der Kanal ist bereits oder demnächst nicht mehr durchgängig: Kanal eingestürzt, totale Verwurzelung oder andere Abflusshindernisse. Der Kanal verliert Wasser (Exfiltration / mögliche Grundwasserverschmutzung).',
   description_de = 'Nicht mehr funktionstüchtig: Das Abwasserbauwerk ist bereits oder demnächst nicht mehr durchgängig: Bauwerk eingestürzt, totale Verwurzelung oder andere Abflusshindernisse. Das Bauwerk verliert Wasser (Exfiltration / mögliche Grundwasserverschmutzung).',
   description_fr = 'Plus en état de fonctionner: L''ouvrage d''assainissement n’est déjà plus parcourable ou ne le sera plus dans peu de temps: Ouvrage d''assainissement écroulé, totalement bouché par des racines ou par d’autres obstacles à l’écoulement. L''ouvrage d''assainissement perd de l’eau (exfiltration / pollution probable de l’eau souterraine)',
   description_it = 'Non più funzionante: la canalizzazione è ostruita o lo sarà entro breve termine:canale crollato, completamente pervaso da radici o altri ostacoli al deflusso. Il canale perde acqua (esfiltrazione / possibile inquinamento delle acque sotterranee)',
   description_ro = 'Nefunctionala: Constructia de canalizare nu este sau nu va mai fi traversabila. Colmatare totala de radacini sau alte obstacole ce stau in calea fluxului/debitului.',
   display_en = 'Z0',
   display_de = 'Z0',
   display_fr = 'Z0',
   display_it = '',
   display_ro = 'Z0'
WHERE code = 3363;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3359,3359) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'Z1',
   value_de = 'Z1',
   value_fr = 'Z1',
   value_it = 'Z1',
   value_ro = 'Z1',
   abbr_en = '',
   abbr_de = 'Z1',
   abbr_fr = 'Z1',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Starke Mängel: Bauliche Schäden, bei welchen die statische Sicherheit, Hydraulik oder Dichtheit nicht mehr gewährleistet ist: Rohrbrüche axial oder radial, Rohrdeformationen, visuell sichtbare Wassereintritte oder Wasseraustritte, Löcher in der Rohrwand, stark vorstehende seitliche Anschlüsse, starke Verwurzelungen, Rohrwand stark ausgewaschen. Ungeeignetes Rohrmaterial.',
   description_de = 'Starke Mängel: Bauliche Schäden, bei welchen die statische Sicherheit, Hydraulik oder Dichtheit nicht mehr gewährleistet ist: Brüche axial oder radial, (Rohr-)deformationen, visuell sichtbare Wassereintritte oder Wasseraustritte, Löcher in der Wand, stark vorstehende seitliche Anschlüsse, starke Verwurzelungen, Wand stark ausgewaschen. Ungeeignetes (Rohr-)material.',
   description_fr = 'Graves défauts: Dommages structurels ne garantissant plus la sécurité statique, l’hydraulique ou l’étanchéité: cassures, déformations, entrées ou sorties visibles d’eau, trous dans la paroi, forte saillie des raccords latéraux, fort développement des racines, paroi  fortement érodée par lavage. Matériau  inapproprié',
   description_it = 'Gravi difetti: difetti costruttivi a causa dei quali la sicurezza statica, l''idraulica o la tenuta non sono piu assicurate: rotture del tubo assiali o radiali, deformazioni del tubo, infiltrazioni o perdite d''acqua visibili, fori nella parete del tubo, raccordi laterali molto sporgenti, notevole pervasione radicale, parete del tubo molto corrosa. Materiale del tubo inadatto.',
   description_ro = 'Defecte grave. Defecte structurale ce nu mai garanteaza securitatea statica, hidraulica sau etanseitatea: rupturi, deforma?ii axiale sau radiale,(teava), patrunderea apei sau apa scurgeri ale apei vizibile, gauri în perete',
   display_en = 'Z1',
   display_de = 'Z1',
   display_fr = 'Z1',
   display_it = '',
   display_ro = 'Z1'
WHERE code = 3359;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3360,3360) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'Z2',
   value_de = 'Z2',
   value_fr = 'Z2',
   value_it = 'Z2',
   value_ro = 'Z2',
   abbr_en = '',
   abbr_de = 'Z2',
   abbr_fr = 'Z2',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mittlere Mängel: Bauliche Mängel, welche die Statik, Hydraulik oder Dichtheit beeinträchtigen: breite Rohrfugen, nicht verputzte Einläufe, Risse, leichte Abflusshindernisse wie Verkalkungen, vorstehende seitliche Anschlüsse, leichte Rohrwandbeschädigungen, einzelne Wurzeleinwüchse, Rohrwand ausgewaschen usw.',
   description_de = 'Mittlere Mängel: Bauliche Mängel, welche die Statik, Hydraulik oder Dichtheit beeinträchtigen: breite (Rohr-)fugen, nicht verputzte Einläufe, Risse, leichte Abflusshindernisse wie Verkalkungen, vorstehende seitliche Anschlüsse, leichte Wandbeschädigungen, einzelne Wurzeleinwüchse, (Rohr-)wand ausgewaschen usw.',
   description_fr = 'Défauts moyens: Défauts structurels affectant la statique, l’hydraulique ou l’étanchéité: joints avec canalisation renflés, entrées non nettoyées, fissures, légers obstacles à l’écoulement (entartrages, saillie des raccords latéraux, légers dommages à la paroi, développement localisé des racines, paroi érodée par lavage, etc.)',
   description_it = 'Difetti medi: difetti costruttivi che pregiudicano la statica, l''idraulica o la tenuta: giunti dei tubi larghi, entrate non sigillate, fessurazioni, leggeri ostacoli al deflusso come incrostazioni calcaree, raccordi laterali sporgenti, pareti dei tubi leggermente danneggiate, singole penetrazioni di radici, parete del tubo corrosa ecc.',
   description_ro = 'Defecte medii. Defecte structurale ce afecteaza statica, hidraulica sau etanseitatea: fisuri, îmbinari problematice, intrari necura?ate, mici obstacole în calea apei, calcificari, daune usoare în perete',
   display_en = 'Z2',
   display_de = 'Z2',
   display_fr = 'Z2',
   display_it = '',
   display_ro = 'Z2'
WHERE code = 3360;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3361,3361) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'Z3',
   value_de = 'Z3',
   value_fr = 'Z3',
   value_it = 'Z3',
   value_ro = 'Z3',
   abbr_en = '',
   abbr_de = 'Z3',
   abbr_fr = 'Z3',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Leichte Mängel: Bauliche Mängel oder Vorkommnisse, welche für die Dichtheit, Hydraulik oder Rohrstatik einen unbedeutenden Einfluss haben: breite Rohrfugen, schlecht verputzte seitlichen Anschlüsse, leichte Deformation bei Kunststoffleitungen, leichte Auswaschungen etc.',
   description_de = 'Leichte Mängel: Bauliche Mängel oder Vorkommnisse, welche für die Dichtheit, Hydraulik oder Statik einen unbedeutenden Einfluss haben: breite (Rohr-)fugen, schlecht verputzte seitlichen Anschlüsse, leichte Deformation bei Bauwerken aus Kunststoff, leichte Auswaschungen etc.',
   description_fr = 'Défauts légers: Défauts ou événements structurels ayant une influence insignifiante sur l’étanchéité, l’hydraulique ou la statique de l''ouvrage d''assainissement: joints avec canalisations renflées, raccords latéraux mal nettoyés, légères déformations sur matériaux plastiques, légères érosions dues au lavage, etc',
   description_it = 'Difetti lievi: difetti costruttivi o anomalie senza influenuza significativa sulla tenuta, l''idraulica o la statica dei tubi: giunti larghi dei tubi, raccordi laterali male sigillati, lievi deformazioni di condotte sintetiche, lievi corrosioni ecc.',
   description_ro = 'Defecte minimale. Defecte sau evenimente structurale ce au o influenta insignifianta asupra etanseitatii, hidraulicii, sau staticii constructiei: îmbinari umflate, racorduri slab curatite, deformatii mici',
   display_en = 'Z3',
   display_de = 'Z3',
   display_fr = 'Z3',
   display_it = '',
   display_ro = 'Z3'
WHERE code = 3361;

--- Adapt tww_vl.wastewater_structure_structure_condition
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode) VALUES (3362,3362) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_structure_condition SET
   value_en = 'Z4',
   value_de = 'Z4',
   value_fr = 'Z4',
   value_it = 'Z4',
   value_ro = 'Z4',
   abbr_en = '',
   abbr_de = 'Z4',
   abbr_fr = 'Z4',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Mängel',
   description_de = 'Keine Mängel',
   description_fr = 'Aucun défaut',
   description_it = 'Nessun difetto',
   description_ro = '',
   display_en = 'Z4',
   display_de = 'Z4',
   display_fr = 'Z4',
   display_it = '',
   display_ro = 'Z4'
WHERE code = 3362;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5325,5325) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5325;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5332,5332) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_soil',
   value_de = 'erdverlegt',
   value_fr = 'enterre',
   value_it = 'zzz_erdverlegt',
   value_ro = 'pamant',
   abbr_en = 'IS',
   abbr_de = 'EV',
   abbr_fr = 'ET',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entweder im Aushubmaterial gebettet oder Press-/Schlagvortrieb',
   description_de = 'Entweder im Aushubmaterial gebettet oder Press-/Schlagvortrieb',
   description_fr = 'avancement par méthode pousse-tube soit enrobé de matériaux d''excavation, soit par avancement pousse-tube ou presse-tube',
   description_it = 'zzz_Entweder im Aushubmaterial gebettet oder Press-/Schlagvortrieb',
   description_ro = 'Metoda de presstube sau invelit in materialele rezultate din urma escavarii',
   display_en = 'in_soil',
   display_de = 'erdverlegt',
   display_fr = 'enterré',
   display_it = '',
   display_ro = 'pamant'
WHERE code = 5332;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5328,5328) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_channel_suspended',
   value_de = 'in_Kanal_aufgehaengt',
   value_fr = 'suspendu_dans_le_canal',
   value_it = 'zzz_in_Kanal_aufgehaengt',
   value_ro = 'suspendat_in_canal',
   abbr_en = '',
   abbr_de = 'IKA',
   abbr_fr = 'CS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'in_channel_suspended',
   display_de = 'in_Kanal_aufgehaengt',
   display_fr = 'dans le  canal',
   display_it = '',
   display_ro = 'suspendat in canal'
WHERE code = 5328;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5339,5339) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_channel_concrete_casted',
   value_de = 'in_Kanal_einbetoniert',
   value_fr = 'betonne_dans_le_canal',
   value_it = 'zzz_in_Kanal_einbetoniert',
   value_ro = 'beton_in_canal',
   abbr_en = '',
   abbr_de = 'IKB',
   abbr_fr = 'CB',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'in_channel_concrete_casted',
   display_de = 'in_Kanal_einbetoniert',
   display_fr = 'bétonné dans le canal',
   display_it = '',
   display_ro = 'beton in canal'
WHERE code = 5339;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5331,5331) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_walk_in_passage',
   value_de = 'in_Leitungsgang',
   value_fr = 'en_galerie',
   value_it = 'zzz_in_Leitungsgang',
   value_ro = 'galerie',
   abbr_en = '',
   abbr_de = 'ILG',
   abbr_fr = 'G',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_SIA405 1998: inKulisse IKU',
   description_de = 'SIA405 1998: inKulisse IKU',
   description_fr = 'SIA405 1998: en_cunette CU',
   description_it = 'zzz_SIA405 1998: inKulisse IKU',
   description_ro = '',
   display_en = 'in_walk_in_passage',
   display_de = 'in_Leitungsgang',
   display_fr = 'en galerie',
   display_it = '',
   display_ro = 'galerie'
WHERE code = 5331;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5337,5337) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_jacking_pipe_concrete',
   value_de = 'in_Vortriebsrohr_Beton',
   value_fr = 'en_pousse_tube_en_beton',
   value_it = 'zzz_in_Vortriebsrohr_Beton',
   value_ro = 'beton_presstube',
   abbr_en = '',
   abbr_de = 'IVB',
   abbr_fr = 'TB',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'in_jacking_pipe_concrete',
   display_de = 'in_Vortriebsrohr_Beton',
   display_fr = 'en pousse tube en béton',
   display_it = '',
   display_ro = 'beton presstube'
WHERE code = 5337;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5336,5336) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'in_jacking_pipe_steel',
   value_de = 'in_Vortriebsrohr_Stahl',
   value_fr = 'en_pousse_tube_en_acier',
   value_it = 'zzz_in_Vortriebsrohr_Stahl',
   value_ro = 'otel_presstube',
   abbr_en = '',
   abbr_de = 'IVS',
   abbr_fr = 'TA',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'in_jacking_pipe_steel',
   display_de = 'in_Vortriebsrohr_Stahl',
   display_fr = 'en pousse tube en acier',
   display_it = '',
   display_ro = 'otel presstube'
WHERE code = 5336;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5335,5335) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'sand',
   value_de = 'Sand',
   value_fr = 'sable',
   value_it = 'zzz_Sand',
   value_ro = 'nisip',
   abbr_en = '',
   abbr_de = 'SA',
   abbr_fr = 'SA',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sand',
   display_de = 'Sand',
   display_fr = 'sable',
   display_it = '',
   display_ro = 'nisip'
WHERE code = 5335;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5333,5333) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'sia_type_1',
   value_de = 'SIA_Typ1',
   value_fr = 'SIA_type_1',
   value_it = 'SIA_tippo1',
   value_ro = 'SIA_tip_1',
   abbr_en = '',
   abbr_de = 'B1',
   abbr_fr = 'B1',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'According to the definition in SIA Standard 190',
   description_de = 'Gemäss Definition SIA Norm 190',
   description_fr = 'selon la définition Norme SIA 190',
   description_it = 'Secondo la definizione della norma SIA 190',
   description_ro = 'dupa normativ SIA 190 (Elvetia)',
   display_en = 'sia_type_1',
   display_de = 'SIA_Typ1',
   display_fr = 'SIA type 1',
   display_it = '',
   display_ro = 'SIA_tip_1'
WHERE code = 5333;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5330,5330) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'sia_type_2',
   value_de = 'SIA_Typ2',
   value_fr = 'SIA_type_2',
   value_it = 'SIA_tippo2',
   value_ro = 'SIA_tip_2',
   abbr_en = '',
   abbr_de = 'B2',
   abbr_fr = 'B2',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'According to the definition in SIA Standard 190',
   description_de = 'Gemäss Definition SIA Norm 190',
   description_fr = 'selon la définition Norme SIA 190',
   description_it = 'Secondo la definizione della norma SIA 190',
   description_ro = 'dupa normativ SIA 190 (Elvetia)',
   display_en = 'sia_type_2',
   display_de = 'SIA_Typ2',
   display_fr = 'SIA type 2',
   display_it = '',
   display_ro = 'SIA_tip_2'
WHERE code = 5330;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5334,5334) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'sia_type_3',
   value_de = 'SIA_Typ3',
   value_fr = 'SIA_type_3',
   value_it = 'SIA_tippo3',
   value_ro = 'SIA_tip_3',
   abbr_en = '',
   abbr_de = 'B3',
   abbr_fr = 'B3',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gemäss Definition SIA Norm 190',
   description_de = 'Gemäss Definition SIA Norm 190',
   description_fr = 'selon la définition Norme SIA 190',
   description_it = 'Secondo la definizione della norma SIA 190',
   description_ro = 'dupa normativ SIA 190 (Elvetia)',
   display_en = 'sia_type_3',
   display_de = 'SIA_Typ3',
   display_fr = 'SIA type 3',
   display_it = '',
   display_ro = 'SIA_tip_3'
WHERE code = 5334;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5340,5340) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'sia_type_4',
   value_de = 'SIA_Typ4',
   value_fr = 'SIA_type_4',
   value_it = 'SIA_tippo4',
   value_ro = 'SIA_tip_4',
   abbr_en = '',
   abbr_de = 'B4',
   abbr_fr = 'B4',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gemäss Definition SIA Norm 190',
   description_de = 'Gemäss Definition SIA Norm 190',
   description_fr = 'selon la définition Norme SIA 190',
   description_it = 'Secondo la definizione della norma SIA 190',
   description_ro = 'dupa normativ SIA 190 (Elvetia)',
   display_en = 'sia_type_4',
   display_de = 'SIA_Typ4',
   display_fr = 'SIA type 4',
   display_it = '',
   display_ro = 'SIA_tip_4'
WHERE code = 5340;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5327,5327) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'bed_plank',
   value_de = 'Sohlbrett',
   value_fr = 'radier_en_planches',
   value_it = 'zzz_Sohlbrett',
   value_ro = 'pat_de_pamant',
   abbr_en = '',
   abbr_de = 'SB',
   abbr_fr = 'RP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezielle Art der Bettung bei Meliorationsleitungen',
   description_de = 'Spezielle Art der Bettung bei Meliorationsleitungen',
   description_fr = 'Lit constitué de planches pour des conduites d’amélioration foncière',
   description_it = 'zzz_Spezielle Art der Bettung bei Meliorationsleitungen',
   description_ro = '',
   display_en = 'bed_plank',
   display_de = 'Sohlbrett',
   display_fr = 'radier en planches',
   display_it = '',
   display_ro = 'pat de pamant'
WHERE code = 5327;

--- Adapt tww_vl.channel_bedding_encasement
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode) VALUES (5329,5329) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_bedding_encasement SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5329;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (5341,5341) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5341;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (190,190) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'electric_welded_sleeves',
   value_de = 'Elektroschweissmuffen',
   value_fr = 'manchon_electrosoudable',
   value_it = 'zzz_Elektroschweissmuffen',
   value_ro = 'manson_electrosudabil',
   abbr_en = 'EWS',
   abbr_de = 'EL',
   abbr_fr = 'MSA',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'SIA405 1998: manchon_soude_a_arc',
   description_it = '',
   description_ro = '',
   display_en = 'electric_welded_sleeves',
   display_de = 'Elektroschweissmuffen',
   display_fr = 'manchon électrosoudable',
   display_it = '',
   display_ro = 'manson electrosudabil'
WHERE code = 190;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (187,187) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'flat_sleeves',
   value_de = 'Flachmuffen',
   value_fr = 'manchon_plat',
   value_it = 'zzz_Flachmuffen',
   value_ro = 'mason_plat',
   abbr_en = '',
   abbr_de = 'FM',
   abbr_fr = 'MP',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'flat_sleeves',
   display_de = 'Flachmuffen',
   display_fr = 'manchon plat',
   display_it = '',
   display_ro = 'mason plat'
WHERE code = 187;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (193,193) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'flange',
   value_de = 'Flansch',
   value_fr = 'bride',
   value_it = 'zzz_Flansch',
   value_ro = 'flansa',
   abbr_en = '',
   abbr_de = 'FL',
   abbr_fr = 'B',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'flange',
   display_de = 'Flansch',
   display_fr = 'bride',
   display_it = '',
   display_ro = 'flansa'
WHERE code = 193;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (185,185) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'bell_shaped_sleeves',
   value_de = 'Glockenmuffen',
   value_fr = 'emboitement_a_cloche',
   value_it = 'zzz_Glockenmuffen',
   value_ro = 'imbinare_tip_clopot',
   abbr_en = '',
   abbr_de = 'GL',
   abbr_fr = 'EC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'bell_shaped_sleeves',
   display_de = 'Glockenmuffen',
   display_fr = 'emboîtement à cloches',
   display_it = '',
   display_ro = 'imbinare tip clopot'
WHERE code = 185;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (192,192) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'coupling',
   value_de = 'Kupplung',
   value_fr = 'raccord',
   value_it = 'zzz_Kupplung',
   value_ro = 'racord',
   abbr_en = '',
   abbr_de = 'KU',
   abbr_fr = 'R',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'coupling',
   display_de = 'Kupplung',
   display_fr = 'raccord',
   display_it = '',
   display_ro = 'racord'
WHERE code = 192;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (194,194) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'screwed_sleeves',
   value_de = 'Schraubmuffen',
   value_fr = 'manchon_visse',
   value_it = 'zzz_Schraubmuffen',
   value_ro = 'manson_insurubat',
   abbr_en = '',
   abbr_de = 'SC',
   abbr_fr = 'MV',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'screwed_sleeves',
   display_de = 'Schraubmuffen',
   display_fr = 'manchon vissé',
   display_it = '',
   display_ro = 'manson insurubat'
WHERE code = 194;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (189,189) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'butt_welded',
   value_de = 'spiegelgeschweisst',
   value_fr = 'manchon_soude_au_miroir',
   value_it = 'zzz_spiegelgeschweisst',
   value_ro = 'manson_sudat_cap_la_cap',
   abbr_en = '',
   abbr_de = 'SP',
   abbr_fr = 'MSM',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'SIA405 1998: manchon_soude_miroir',
   description_it = '',
   description_ro = '',
   display_en = 'butt_welded',
   display_de = 'spiegelgeschweisst',
   display_fr = 'manchon soudé au miroir',
   display_it = '',
   display_ro = 'manson sudat cap la cap'
WHERE code = 189;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (186,186) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'beaked_sleeves',
   value_de = 'Spitzmuffen',
   value_fr = 'emboitement_simple',
   value_it = 'zzz_Spitzmuffen',
   value_ro = 'imbinare_simpla',
   abbr_en = '',
   abbr_de = 'SM',
   abbr_fr = 'ES',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'beaked_sleeves',
   display_de = 'Spitzmuffen',
   display_fr = 'emboîtement simple',
   display_it = '',
   display_ro = 'imbinare simpla'
WHERE code = 186;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (191,191) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'push_fit_sleeves',
   value_de = 'Steckmuffen',
   value_fr = 'raccord_a_serrage',
   value_it = 'zzz_Steckmuffen',
   value_ro = 'racord_de_prindere',
   abbr_en = '',
   abbr_de = 'ST',
   abbr_fr = 'RS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'SIA405 1998: raccord_de_serrage',
   description_it = '',
   description_ro = '',
   display_en = 'push_fit_sleeves',
   display_de = 'Steckmuffen',
   display_fr = 'raccord à serrage',
   display_it = '',
   display_ro = 'racord de prindere'
WHERE code = 191;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (188,188) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'slip_on_sleeves',
   value_de = 'Ueberschiebmuffen',
   value_fr = 'manchon_coulissant',
   value_it = 'zzz_Ueberschiebmuffen',
   value_ro = 'manson_culisant',
   abbr_en = '',
   abbr_de = 'UE',
   abbr_fr = 'MC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'slip_on_sleeves',
   display_de = 'Ueberschiebmuffen',
   display_fr = 'manchon coulissant',
   display_it = '',
   display_ro = 'manson culisant'
WHERE code = 188;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (3036,3036) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3036;

--- Adapt tww_vl.channel_connection_type
 INSERT INTO tww_vl.channel_connection_type (code, vsacode) VALUES (3666,3666) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_connection_type SET
   value_en = 'jacking_pipe_coupling',
   value_de = 'Vortriebsrohrkupplung',
   value_fr = 'raccord_pour_tube_de_pousse_tube',
   value_it = 'zzz_Vortriebsrohrkupplung',
   value_ro = 'racord_prin_presstube',
   abbr_en = '',
   abbr_de = 'VK',
   abbr_fr = 'RTD',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'jacking_pipe_coupling',
   display_de = 'Vortriebsrohrkupplung',
   display_fr = 'raccord pour tube de pousse tube',
   display_it = '',
   display_ro = 'racord prin presstube'
WHERE code = 3666;

--- Adapt tww_vl.channel_function_amelioration
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode) VALUES (4582,4582) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_amelioration SET
   value_en = 'main_sewer',
   value_de = 'Hauptkanal',
   value_fr = 'collecteur_principal',
   value_it = 'zzz_Hauptkanal',
   value_ro = 'rrr_Hauptkanal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine seitlichen Einmündungen. Nicht gelocht. Nur Transport',
   description_de = 'Keine seitlichen Einmündungen. Nicht gelocht. Nur Transport',
   description_fr = 'Pas de confluences latérales. Pas perforé. Seulement transport',
   description_it = 'zzz_Keine seitlichen Einmündungen. Nicht gelocht. Nur Transport',
   description_ro = '',
   display_en = 'main_sewer',
   display_de = 'Hauptkanal',
   display_fr = 'collecteur principal',
   display_it = '',
   display_ro = ''
WHERE code = 4582;

--- Adapt tww_vl.channel_function_amelioration
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode) VALUES (4583,4583) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_amelioration SET
   value_en = 'collector_sewer',
   value_de = 'Sammelkanal',
   value_fr = 'collecteur',
   value_it = 'zzz_Sammelkanal',
   value_ro = 'rrr_Sammelkanal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Falls gelocht, geschlitzt oder gestossen, dann FunktionHydraulisch = Sickerleitung - falls geschlossen, dann FunktionHydraulisch = Drainagetransportleitung. Mit seitlichen Einmündungen. Drainage und Transportfunktion',
   description_de = 'Falls gelocht, geschlitzt oder gestossen, dann FunktionHydraulisch = Sickerleitung - falls geschlossen, dann FunktionHydraulisch = Drainagetransportleitung. Mit seitlichen Einmündungen. Drainage und Transportfunktion',
   description_fr = 'Si perforé, fendu ou jointé fonction_hydraulique = conduite_de_drainage - si fermé fonction_hydraulique = conduite_de_transport_pour_le_drainage. Avec confluence latérale fonction drainage et transport',
   description_it = 'zzz_Falls gelocht, geschlitzt oder gestossen, dann FunktionHydraulisch = Sickerleitung - falls geschlossen, dann FunktionHydraulisch = Drainagetransportleitung. Mit seitlichen Einmündungen. Drainage und Transportfunktion',
   description_ro = '',
   display_en = 'collector_sewer',
   display_de = 'Sammelkanal',
   display_fr = 'collecteur',
   display_it = '',
   display_ro = ''
WHERE code = 4583;

--- Adapt tww_vl.channel_function_amelioration
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode) VALUES (4584,4584) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_amelioration SET
   value_en = 'suction_pipe',
   value_de = 'Sauger',
   value_fr = 'drains',
   value_it = 'zzz_Sauger',
   value_ro = 'rrr_Sauger',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Drainagefunktion. gelocht, geschlitzt oder gestossen. In der Regel keine seitlichen Einmündungen.',
   description_de = 'Drainagefunktion. gelocht, geschlitzt oder gestossen. In der Regel keine seitlichen Einmündungen',
   description_fr = 'Fonction de drainage, avec tuyaux percés ou à fentes, normalement sans ouverture latérale',
   description_it = 'zzz_Drainagefunktion. gelocht, geschlitzt oder gestossen. In der Regel keine seitlichen Einmündungen',
   description_ro = '',
   display_en = 'suction_pipe',
   display_de = 'Sauger',
   display_fr = 'drains',
   display_it = '',
   display_ro = ''
WHERE code = 4584;

--- Adapt tww_vl.channel_function_amelioration
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode) VALUES (4585,4585) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_amelioration SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4585;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5066,5066) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.other',
   value_de = 'PAA.andere',
   value_fr = 'OAP.autre',
   value_it = 'IPS.altro',
   value_ro = 'pwwf.alta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'other primary wastewater facilities',
   description_de = 'Andere primäre Abwasseranlagen',
   description_fr = 'autres ouvrages du réseau d’assainissement primaire (OAP)',
   description_it = 'Altri impianti principali di smaltimento acque',
   description_ro = '',
   display_en = 'pwwf.other',
   display_de = 'PAA.andere',
   display_fr = 'OAP.autre',
   display_it = '',
   display_ro = 'pwwf.alta'
WHERE code = 5066;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5068,5068) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.water_bodies',
   value_de = 'PAA.Gewaesser',
   value_fr = 'OAP.cours_d_eau',
   value_it = 'IPS.corpo_acqua',
   value_ro = 'pwwf.curs_de_apa',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erfassung aus Kanalperspektive (z.B. weil hydraulische Berechnung notwendig)',
   description_de = 'Erfassung aus Kanalperspektive (z.B. weil hydraulische Berechnung notwendig)',
   description_fr = 'Saisie selon le point de vue de la canalisation (si par exemple des calculs hydrauliques sont nécessaires). SIA405 1998: eaux_publiques',
   description_it = 'Rilievo dal punto di vista delle canalizzazioni (p. es. poiché necessaria verifica idraulica)',
   description_ro = '',
   display_en = 'pwwf.water_bodies',
   display_de = 'PAA.Gewaesser',
   display_fr = 'OAP.cours_d_eau',
   display_it = '',
   display_ro = 'pwwf.curs_de_apa'
WHERE code = 5068;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5069,5069) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.main_drain',
   value_de = 'PAA.Hauptsammelkanal',
   value_fr = 'OAP.collecteur_principal',
   value_it = 'IPS.collettore_principale',
   value_ro = 'pwwf.colector_principal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zu verwenden bei: a) Ausläufen aus einem Regenüberlauf oder einem Regenbecken. b) Durchmesser > 1000 mm (insbesondere bei längeren Strecken ohne RÜ/RB)',
   description_de = 'Zu verwenden bei: a) Ausläufen aus einem Regenüberlauf oder einem Regenbecken. b) Durchmesser > 1000 mm (insbesondere bei längeren Strecken ohne RÜ/RB)',
   description_fr = 'A utiliser pour: a) des sorties d''un déversoir d''orage ou d''un bassin d''eaux pluviales. b) des diamètres > 1000 mm (en particulier sur des tronçons longs sans DO/BEP)',
   description_it = 'Utilizzare per: a) scarichi da scaricatore di piena o da bacino. b) diametro > 1000 mm (in particolare su lunghe tratte senza bacini)',
   description_ro = 'rrr_Zu verwenden bei: a) Ausläufen aus einem Regenüberlauf oder einem Regenbecken. b) Durchmesser > 1000 mm (insbesondere bei längeren Strecken ohne RÜ/RB)',
   display_en = 'pwwf.main_drain',
   display_de = 'PAA.Hauptsammelkanal',
   display_fr = 'OAP.collecteur_principal',
   display_it = '',
   display_ro = 'pwwf.colector_principal'
WHERE code = 5069;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5070,5070) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.main_drain_regional',
   value_de = 'PAA.Hauptsammelkanal_regional',
   value_fr = 'OAP.collecteur_principal_regional',
   value_it = 'IPS.collettore_principale_regionale',
   value_ro = 'pwwf.colector_principal_regional',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Alle Kanäle im Eigentum des ARA-Verbandes oder überkommunale Transportkanäle im Eigentum der Gemeinde',
   description_de = 'Alle Kanäle im Eigentum des ARA-Verbandes oder überkommunale Transportkanäle im Eigentum der Gemeinde',
   description_fr = 'Toutes les canalisations propriété du syndicat de STEP ou les canalisations de transport intercommunales propriété de la commune',
   description_it = 'Tutti i collettori di proprietà del consorzio depurazione o collettori di trasporto intercomunali di proprietà del Comune',
   description_ro = 'colector principal ce are importanta regionala in structura ierarhica a retelei',
   display_en = 'pwwf.main_drain_regional',
   display_de = 'PAA.Hauptsammelkanal_regional',
   display_fr = 'OAP.collecteur_principal_regional',
   display_it = '',
   display_ro = 'pwwf.colector_principal_regional'
WHERE code = 5070;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5064,5064) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.residential_drainage',
   value_de = 'PAA.Liegenschaftsentwaesserung',
   value_fr = 'OAP.evacuation_bien_fonds',
   value_it = 'IPS.samltimento_acque_fondi',
   value_ro = 'pwwf.evacuare_rezidentiala',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Liegenschaftsentwässerung (hydraulisch relevant). Alle Leitungen auf einer Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   description_de = 'Liegenschaftsentwässerung (hydraulisch relevant). Alle Leitungen auf einer Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   description_fr = 'Terme générique pour l’évacuation des biens-fonds (hydrauliquement déterminant). Toutes les conduites sur un bien-fonds et pour l''acheminement en dehors du bien-fonds jusqu''au collecteur. La délimitation entre l''évacuation des biens-fonds et celle des immeubles se fait selon la norme "Conception et réalisation d''installations évacuation des eaux des biens-fonds (SN 592 000)"',
   description_it = 'Smaltimento acque dai fondi (idraulicamente rilevante). Tutte le condotte di un immobile e per il trasporto dall''immobile al collettore di raccolta. Delimitazione secondo norma SN 592 000',
   description_ro = 'rrr_Liegenschaftsentwässerung (hydraulisch relevant). Alle Leitungen auf einer Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   display_en = 'pwwf.residential_drainage',
   display_de = 'PAA.Liegenschaftsentwaesserung',
   display_fr = 'OAP.evacuation_bien_fonds',
   display_it = '',
   display_ro = 'pwwf.evacuare_rezidentiala'
WHERE code = 5064;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5071,5071) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.collector_sewer',
   value_de = 'PAA.Sammelkanal',
   value_fr = 'OAP.collecteur',
   value_it = 'IPS.collettore',
   value_ro = 'pwwf.colector',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zu verwenden für: a) alle weiteren Leitungen im Eigentum der Gemeinde und öffentlich finanziert oder b) nach Zusammenfluss von Liegenschaftsentwässerung und öffentlicher Strassenentwässerung',
   description_de = 'Zu verwenden für: a) alle weiteren Leitungen im Eigentum der Gemeinde und öffentlich finanziert oder b) nach Zusammenfluss von Liegenschaftsentwässerung und öffentlicher Strassenentwässerung',
   description_fr = 'A utiliser pour: a) toutes les autres conduites propriété de la commune et à financement public ou b) après la jonction de l''évacuation des biens-fonds et de l''évacuation publique des eaux de routes',
   description_it = 'Utilizzare per: a) tutte le altre condotte di proprietà del Comune e con finanziamento pubblico oppure b) dopo confluenza dello smaltimento acque fondi privati e smaltimento pubblico acque stradali',
   description_ro = 'rrr_Zu verwenden für: a) alle weiteren Leitungen im Eigentum der Gemeinde und öffentlich finanziert oder b) nach Zusammenfluss von Liegenschaftsentwässerung und öffentlicher Strassenentwässerung',
   display_en = 'pwwf.collector_sewer',
   display_de = 'PAA.Sammelkanal',
   display_fr = 'OAP.collecteur',
   display_it = '',
   display_ro = 'pwwf.colector'
WHERE code = 5071;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5062,5062) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.renovation_conduction',
   value_de = 'PAA.Sanierungsleitung',
   value_fr = 'OAP.conduite_d_assainissement',
   value_it = 'IPS.condotta_risanamento',
   value_ro = 'pwwf.conducta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungsleitung (hydraulisch relevant) zum abwassertechnischen Anschluss von abgelegenen Liegenschaften an die Kanalisation, bei deren Planung und Erstellung gewisse Vereinfachungen zulässig sind',
   description_de = 'Entwässerungsleitung (hydraulisch relevant) zum abwassertechnischen Anschluss von abgelegenen Liegenschaften an die Kanalisation, bei deren Planung und Erstellung gewisse Vereinfachungen zulässig sind.',
   description_fr = 'Conduite d''évacuation pour le raccordement technique de bâtiments isolés, auxquelles des simplifications ont été entreprises à la planification et à la réalisation.',
   description_it = 'Condotta di smaltimento (idraulicamente rilevante) per il raccordo di edifici isolati, per la quale sono possibili delle semplificazioni in fase di progettazione e realizzazione.',
   description_ro = '',
   display_en = 'pwwf.renovation_conduction',
   display_de = 'PAA.Sanierungsleitung',
   display_fr = 'OAP.conduite_d_assainissement',
   display_it = '',
   display_ro = 'pwwf.conducta'
WHERE code = 5062;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5072,5072) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.road_drainage',
   value_de = 'PAA.Strassenentwaesserung',
   value_fr = 'OAP.evacuation_des_eaux_de_routes',
   value_it = 'IPS.samltimento_acque_stradali',
   value_ro = 'pwwf.rigola_drum',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hydraulisch relevante Leitungen, die ausschliesslich der Strassenentwässerung dienen',
   description_de = 'Hydraulisch relevante Leitungen, die ausschliesslich der Strassenentwässerung dienen',
   description_fr = 'Conduites hydrauliquement déterminantes qui servent uniquement à l''évacuation des eaux des chaussées',
   description_it = 'Condotte idraulicamente rilevanti esclusivamente per lo smaltimento acque stradali',
   description_ro = 'rrr_Evacuare rigole (determinant hidraulic) Hydraulisch relevante Leitungen, die ausschliesslich der Strassenentwässerung dienen',
   display_en = 'pwwf.road_drainage',
   display_de = 'PAA.Strassenentwaesserung',
   display_fr = 'OAP.evacuation_des_eaux_de_routes',
   display_it = '',
   display_ro = 'pwwf.rigola_drum'
WHERE code = 5072;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5074,5074) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'pwwf.unknown',
   value_de = 'PAA.unbekannt',
   value_fr = 'OAP.inconnue',
   value_it = 'IPS.sconosciuto',
   value_ro = 'pwwf.necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pwwf.unknown',
   display_de = 'PAA.unbekannt',
   display_fr = 'OAP.inconnue',
   display_it = '',
   display_ro = 'pwwf.necunoscuta'
WHERE code = 5074;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5067,5067) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'swwf.other',
   value_de = 'SAA.andere',
   value_fr = 'OAS.autre',
   value_it = 'ISS.altro',
   value_ro = 'swwf.alta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_other secondary waste water facility z.B. alle Drainageleitungen und Entwässerungen von Flurwegen',
   description_de = 'Andere sekundäre Abwasseranlage z.B. alle Drainageleitungen und Entwässerungen von Flurwegen',
   description_fr = 'Autre ouvrages du réseau d’assainissement secondaire (OAS) p. ex. toutes les conduites de drainage et les évacuations des eaux des chemins ruraux',
   description_it = 'Altri impianti secondari di smaltimento acqua, es. tutte le condotte di drenaggio e smaltimento strade agricole',
   description_ro = 'rrr_Andere sekundäre Abwasseranlage z.B. alle Drainageleitungen und Entwässerungen von Flurwegen',
   display_en = 'swwf.other',
   display_de = 'SAA.andere',
   display_fr = 'OAS.autre',
   display_it = '',
   display_ro = 'swwf.alta'
WHERE code = 5067;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5065,5065) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'swwf.residential_drainage',
   value_de = 'SAA.Liegenschaftsentwaesserung',
   value_fr = 'OAS.evacuation_bien_fonds',
   value_it = 'ISS.smaltimento_acque_fondi',
   value_ro = 'swwf.evacuare_rezidentiala',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Liegenschaftsentwässerung (hydraulisch nicht relevant). Alle Leitungen auf einer yyy_Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   description_de = 'Liegenschaftsentwässerung (hydraulisch nicht relevant). Alle Leitungen auf einer Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   description_fr = 'Terme générique pour l’évacuation des bien fonds (hydrauliquement non déterminants). Toutes les conduites sur un bien-fonds et pour l''acheminement en dehors du bien-fonds jusqu''au collecteur. La délimitation entre l''évacuation des biens-fonds et celle des immeubles se fait selon la norme "Conception et réalisation d''installations évacuation des eaux des biens-fonds (SN 592 000)"',
   description_it = 'Smaltimento acque dai fondi (idraulicamente rilevante). Tutte le condotte di un immobile e per il trasporto dall''immobile al canale collettore di raccolta. Delimitazione secondo norma SN 592 000',
   description_ro = 'rrr_Liegenschaftsentwässerung (hydraulisch nicht relevant). Alle Leitungen auf einer Liegenschaft und für die Weiterleitung aus der Liegenschaft bis zum Sammelkanal. Abgrenzung Liegenschaftsentwässerung von Gebäudeentwässerung gemäss Norm "Planung und Erstellung von Anlagen für die Liegenschaftsentwässerung (SN 592 000)"',
   display_en = 'swwf.residential_drainage',
   display_de = 'SAA.Liegenschaftsentwaesserung',
   display_fr = 'OAS.evacuation_bien_fonds',
   display_it = '',
   display_ro = 'swwf.evacuare_rezidentiala'
WHERE code = 5065;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5063,5063) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'swwf.renovation_conduction',
   value_de = 'SAA.Sanierungsleitung',
   value_fr = 'OAS.conduite_d_assainissement',
   value_it = 'ISS.condotta_risanamento',
   value_ro = 'swwf.racord',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungsleitung (hydraulisch nicht relevant) zum abwassertechnischen Anschluss von abgelegenen Liegenschaften an die Kanalisation, bei deren Erstellung gewisse Vereinfachungen zulässig sind',
   description_de = 'Entwässerungsleitung (hydraulisch nicht relevant) zum abwassertechnischen Anschluss von abgelegenen Liegenschaften an die Kanalisation, bei deren Erstellung gewisse Vereinfachungen zulässig sind.',
   description_fr = 'Conduite d''évacuation pour le raccordement technique de bâtiments isolés, auxquelles des simplifications ont été entreprises à la réalisation.',
   description_it = 'Condotta di smaltimento (idraulicamente non rilevante) per il raccordo di edifici isolati, per la quale sono possibili delle semplificazioni in fase di realizzazione.',
   description_ro = 'rrr_conducta de evacuare pentru racordul tehnic al constructiilor izolate',
   display_en = 'swwf.renovation_conduction',
   display_de = 'SAA.Sanierungsleitung',
   display_fr = 'OAS.conduite_d_assainissement',
   display_it = '',
   display_ro = 'swwf.racord'
WHERE code = 5063;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5073,5073) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'swwf.road_drainage',
   value_de = 'SAA.Strassenentwaesserung',
   value_fr = 'OAS.evacuation_des_eaux_de_routes',
   value_it = 'ISS.smaltimento_acque_strade',
   value_ro = 'swwf.evacuare_ape_rigole',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hydraulisch nicht relevante Leitungen, die ausschliesslich der Strassenentwässerung dienen',
   description_de = 'Hydraulisch nicht relevante Leitungen, die ausschliesslich der Strassenentwässerung dienen',
   description_fr = 'Conduites hydrauliquement non déterminantes qui sert uniquement à l''évacuation des eaux des chaussées',
   description_it = 'Condotte idraulicamente non rilevanti esclusivamente per lo smaltimento acque stradali',
   description_ro = 'rrr_Evacuare rigole (nedeterminant hidraulic)',
   display_en = 'swwf.road_drainage',
   display_de = 'SAA.Strassenentwaesserung',
   display_fr = 'OAS.evacuation_des_eaux_de_routes',
   display_it = '',
   display_ro = 'swwf.evacuare_ape_rigole'
WHERE code = 5073;

--- Adapt tww_vl.channel_function_hierarchic
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode) VALUES (5075,5075) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hierarchic SET
   value_en = 'swwf.unknown',
   value_de = 'SAA.unbekannt',
   value_fr = 'OAS.inconnue',
   value_it = 'ISS.sconosciuto',
   value_ro = 'swwf.necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'swwf.unknown',
   display_de = 'SAA.unbekannt',
   display_fr = 'OAS.inconnue',
   display_it = '',
   display_ro = 'swwf.necunoscuta'
WHERE code = 5075;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (5320,5320) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5320;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (2546,2546) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'drainage_transportation_pipe',
   value_de = 'Drainagetransportleitung',
   value_fr = 'conduite_de_transport_pour_le_drainage',
   value_it = 'condotta_trasporto_drenaggi',
   value_ro = 'conducta_transport_dren',
   abbr_en = 'DTP',
   abbr_de = 'DT',
   abbr_fr = 'CTD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kanal welcher Wasser aus Drainageleitungen transportiert',
   description_de = 'Kanal, welcher Wasser aus Drainageleitungen transportiert',
   description_fr = 'Canalisation transportant de l''eau provenant d''un réseau de drainage',
   description_it = 'Canalizzazione che trasporta l''acqua proveniente da un drenaggio',
   description_ro = '',
   display_en = 'drainage_transportation_pipe',
   display_de = 'Drainagetransportleitung',
   display_fr = 'conduite de transport pour le drainage',
   display_it = '',
   display_ro = 'conducta transport dren'
WHERE code = 2546;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (22,22) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'restriction_pipe',
   value_de = 'Drosselleitung',
   value_fr = 'conduite_d_etranglement',
   value_it = 'condotta_strozzamento',
   value_ro = 'conducta_redusa',
   abbr_en = 'RP',
   abbr_de = 'DR',
   abbr_fr = 'CE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kanal mit vermindertem Querschnitt zur bewussten Begrenzung, resp. Verminderung des Abflusses. Die Funktionsweise basiert auf Abflussverhältnissen unter Druck.',
   description_de = 'Kanal mit vermindertem Querschnitt zur bewussten Begrenzung, resp. Verminderung des Abflusses. Die Funktionsweise basiert auf Abflussverhältnissen unter Druck.',
   description_fr = 'Canalisation à section restreinte afin de diminuer le débit. Son fonctionnement se base sur des écoulement en charge',
   description_it = 'Canalizzazione a sezione ridotta per diminuire la portata. Il suo funzionamento si basa sul deflusso in pressione.',
   description_ro = 'canal cu sectiune redusa pentru a miscora debitul.',
   display_en = 'restriction_pipe',
   display_de = 'Drosselleitung',
   display_fr = 'conduite d''étranglement',
   display_it = '',
   display_ro = 'conducta redusa'
WHERE code = 22;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (3610,3610) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'inverted_syphon',
   value_de = 'Duekerleitung',
   value_fr = 'siphon_inverse',
   value_it = 'canalizzazione_sifone',
   value_ro = 'sifon_inversat',
   abbr_en = 'IS',
   abbr_de = 'DU',
   abbr_fr = 'S',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Geschlossenes Leitungssystem zur Unterfahrung eines Hindernisses als Abwasserdruckleitung.',
   description_de = 'Geschlossenes Leitungssystem zur Unterfahrung eines Hindernisses als Abwasserdruckleitung.',
   description_fr = 'Système de canalisations fermé, permettant le franchissement d''un obstacle. La conduite est en charge.',
   description_it = 'Sistema di canalizzazione chiuso che permette il superamento di un ostacolo.La canalizzazione è in pressione.',
   description_ro = '',
   display_en = 'inverted_syphon',
   display_de = 'Duekerleitung',
   display_fr = 'siphon inverse',
   display_it = '',
   display_ro = 'sifon inversat'
WHERE code = 3610;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (367,367) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'gravity_pipe',
   value_de = 'Freispiegelleitung',
   value_fr = 'conduite_a_ecoulement_gravitaire',
   value_it = 'canalizzazione_gravita',
   value_ro = 'conducta_gravitationala',
   abbr_en = '',
   abbr_de = 'FL',
   abbr_fr = 'CEL',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Die Freispiegelleitung ist eine Rohrleitung, in der das Wasser gemäss dem Gesetz der Schwerkraft von einem höher gelegenen Anfangspunkt zu einem tiefer gelegenen Endpunkt gelangt. (arb)',
   description_de = 'Die Freispiegelleitung ist eine Rohrleitung, in der das Wasser gemäss dem Gesetz der Schwerkraft von einem höher gelegenen Anfangspunkt zu einem tiefer gelegenen Endpunkt gelangt. (arb)',
   description_fr = 'Canalisation, dans laquelle l''eau s''écoule selon les lois de la gravité, d''un point de départ plus élevé à un point d''arrivée plus bas',
   description_it = 'La canalizzazione in cui l''acqua defluisce a gravità da un punto iniziale più elevato ad un punto d''arrivo più basso.',
   description_ro = '',
   display_en = 'gravity_pipe',
   display_de = 'Freispiegelleitung',
   display_fr = 'conduite à écoulement gravitaire',
   display_it = 'canalizzazione gravità',
   display_ro = 'conducta gravitationala'
WHERE code = 367;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (23,23) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'pump_pressure_pipe',
   value_de = 'Pumpendruckleitung',
   value_fr = 'conduite_de_refoulement',
   value_it = 'canalizzazione_pompaggio',
   value_ro = 'conducta_de_refulare',
   abbr_en = '',
   abbr_de = 'DL',
   abbr_fr = 'CR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Druckleitung im Anschluss an ein Pumpwerk',
   description_de = 'Druckleitung im Anschluss an ein Pumpwerk',
   description_fr = 'Conduite sous pression installée à la suite d''une station de pompage permettant de gravir des pentes d''aval en amont',
   description_it = 'Canalizzazione in pressione in seguito ad una stazione di pompaggio',
   description_ro = '',
   display_en = 'pump_pressure_pipe',
   display_de = 'Pumpendruckleitung',
   display_fr = 'conduite de refoulement',
   display_it = '',
   display_ro = 'conducta de refulare'
WHERE code = 23;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (145,145) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'seepage_water_drain',
   value_de = 'Sickerleitung',
   value_fr = 'conduite_de_drainage',
   value_it = 'canalizzazione_drenaggio',
   value_ro = 'conducta_drenaj',
   abbr_en = 'SP',
   abbr_de = 'SI',
   abbr_fr = 'CI',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_1. Erdverlegte Leitung zur Sammlung und Ableitung von Hang- und Sickerwasser (SN 592 000) 2. Drainageleitung mit undichten Stossfugen, geschlitzten Rohren oder wasserdurchlässigem Rohrmaterial zur Entwässerung des Baugrundes. (arb)',
   description_de = '1. Erdverlegte Leitung zur Sammlung und Ableitung von Hang- und Sickerwasser (SN 592 000) 2. Drainageleitung mit undichten Stossfugen, geschlitzten Rohren oder wasserdurchlässigem Rohrmaterial zur Entwässerung des Baugrundes. (arb)',
   description_fr = '1. Canalisation avec ouverture vers des drains (SN 592 000)',
   description_it = 'Canalizzazione con aperture per la raccolta di acqua infiltrata (SN 592 000)',
   description_ro = 'Conducta cu deschidere catre dren (SN 592000)',
   display_en = 'seepage_water_drain',
   display_de = 'Sickerleitung',
   display_fr = 'conduite de drainage',
   display_it = '',
   display_ro = 'conducta drenaj'
WHERE code = 145;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (21,21) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'retention_pipe',
   value_de = 'Speicherleitung',
   value_fr = 'conduite_de_retention',
   value_it = 'canalizzazione_ritenzione',
   value_ro = 'conducta_de_retentie',
   abbr_en = '',
   abbr_de = 'SK',
   abbr_fr = 'CA',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zur bewussten Rückhaltung von Abwassermengen dimensionierte Leitung bei einem Regenrückhalte-, einem Fang- oder einem Stauraumkanal',
   description_de = 'Zur bewussten Rückhaltung von Abwassermengen dimensionierte Leitung bei einem Regenrückhalte-, einem Fang- oder einem Stauraumkanal',
   description_fr = 'Conduite dimensionnée afin de retenir des volumes d''eaux en lien avec un BEP, BEP_retention ou une canalisation de rétention',
   description_it = 'Canalizazzione dimensionata per la ritenzione d''acqua in relazione ad un bacino di ritenzione, un canale d''accumulo o di stoccaggio',
   description_ro = '',
   display_en = 'retention_pipe',
   display_de = 'Speicherleitung',
   display_fr = 'conduite de rétention',
   display_it = '',
   display_ro = 'conducta de retentie'
WHERE code = 21;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (144,144) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'jetting_pipe',
   value_de = 'Spuelleitung',
   value_fr = 'conduite_de_rincage',
   value_it = 'canalizzazione_spurgo',
   value_ro = 'conducta_de_spalare',
   abbr_en = 'JP',
   abbr_de = 'SL',
   abbr_fr = 'CC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Leitung mit spezieller Funktion zum Spülen einer Entwässerungsanlage',
   description_de = 'Leitung mit spezieller Funktion zum Spülen einer Entwässerungsanlage',
   description_fr = 'Canalisation avec une fonction spéciale, permettant le rinçage des installations d''évacuation des eaux',
   description_it = 'Canalizzazione con la particolare funzione di permettere lo spurgo di impianti per lo smaltimento acque',
   description_ro = '',
   display_en = 'jetting_pipe',
   display_de = 'Spuelleitung',
   display_fr = 'conduite de rinçage',
   display_it = '',
   display_ro = 'conducta de spalare'
WHERE code = 144;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (5321,5321) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5321;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (3655,3655) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'vacuum_pipe',
   value_de = 'Vakuumleitung',
   value_fr = 'conduite_sous_vide',
   value_it = 'canalizzazione_sotto_vuoto',
   value_ro = 'conducta_vidata',
   abbr_en = '',
   abbr_de = 'VL',
   abbr_fr = 'CV',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'vacuum_pipe',
   display_de = 'Vakuumleitung',
   display_fr = 'conduite sous vide',
   display_it = '',
   display_ro = 'conducta vidata'
WHERE code = 3655;

--- Adapt tww_vl.channel_function_hydraulic
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode) VALUES (8662,8662) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_function_hydraulic SET
   value_en = 'infiltration_pipe',
   value_de = 'Versickerungsleitung',
   value_fr = 'conduite_d_infiltration',
   value_it = 'condotta_d_infiltrazione',
   value_ro = 'rrr_Versickerungsleitung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Versickerungsleitungen - als Gegenstück zur Sickerleitung - werden im Besonderen bei unterirdischen Versickerungsanlagen benötigt.',
   description_de = 'Versickerungsleitungen - als Gegenstück zur Sickerleitung - werden im Besonderen bei unterirdischen Versickerungsanlagen benötigt.',
   description_fr = 'Les conduites d''infiltration - associées aux conduites de drainage - sont utilisées en particulier pour les installations infiltration souterraines.',
   description_it = 'Condotte d''infiltrazione - contrapposte alle condotte di drenaggio - necessarie in particolare per gli impianti d''infiltrazione interrati',
   description_ro = 'rrr_Versickerungsleitungen - als Gegenstück zur Sickerleitung - werden im Besonderen bei unterirdischen Versickerungsanlagen benötigt.',
   display_en = 'infiltration_pipe',
   display_de = 'Versickerungsleitung',
   display_fr = 'conduite d''infiltration',
   display_it = '',
   display_ro = ''
WHERE code = 8662;

--- Adapt tww_vl.channel_seepage
 INSERT INTO tww_vl.channel_seepage (code, vsacode) VALUES (4793,4793) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_seepage SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4793;

--- Adapt tww_vl.channel_seepage
 INSERT INTO tww_vl.channel_seepage (code, vsacode) VALUES (4794,4794) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_seepage SET
   value_en = 'wood_chips',
   value_de = 'Holzschnitzel',
   value_fr = 'copeaux_bois',
   value_it = 'zzz_Holzschnitzel',
   value_ro = 'rrr_Holzschnitzel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'wood_chips',
   display_de = 'Holzschnitzel',
   display_fr = 'copeaux bois',
   display_it = '',
   display_ro = ''
WHERE code = 4794;

--- Adapt tww_vl.channel_seepage
 INSERT INTO tww_vl.channel_seepage (code, vsacode) VALUES (4795,4795) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_seepage SET
   value_en = 'soakaway_gravel',
   value_de = 'Sickerkies',
   value_fr = 'gravier',
   value_it = 'zzz_Sickerkies',
   value_ro = 'rrr_Sickerkies',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'soakaway_gravel',
   display_de = 'Sickerkies',
   display_fr = 'gravier',
   display_it = '',
   display_ro = ''
WHERE code = 4795;

--- Adapt tww_vl.channel_seepage
 INSERT INTO tww_vl.channel_seepage (code, vsacode) VALUES (4796,4796) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_seepage SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 4796;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (5322,5322) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_z.B. auch Zugang, Be- und Entlüftung',
   description_de = 'Z.B. auch Zugang, Be- und Entlüftung',
   description_fr = 'par exemple accès, aération, désaération',
   description_it = 'Per es. anche accesso, aerazione e deareazione',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5322;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4518,4518) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'creek_water',
   value_de = 'Bachwasser',
   value_fr = 'eaux_cours_d_eau',
   value_it = 'acqua_corso_acqua',
   value_ro = 'ape_curs_de_apa',
   abbr_en = '',
   abbr_de = 'BW',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasser eines Fliessgewässers, das gemäss seinem natürlichen Zustand oberflächlich, aber an einigen Orten auch in unterirdischen Leitungen abfliesst.',
   description_de = 'Wasser eines Fliessgewässers, das gemäss seinem natürlichen Zustand oberflächlich, aber an einigen Orten auch in unterirdischen Leitungen abfliesst.',
   description_fr = 'Eaux d''un cours d''eau s''écoulant dans son état naturel à la surface, mais qui aussi être mis sous terre par endroits',
   description_it = 'Acqua di un corso d''acqua che scorre in superficie ma che può anche essere intubato a tratti.',
   description_ro = '',
   display_en = 'creek_water',
   display_de = 'Bachwasser',
   display_fr = 'eaux cours d''eau',
   display_it = '',
   display_ro = 'ape curs de apa'
WHERE code = 4518;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4516,4516) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'discharged_combined_wastewater',
   value_de = 'entlastetes_Mischabwasser',
   value_fr = 'eaux_mixtes_deversees',
   value_it = 'acque_miste_scaricate',
   value_ro = 'ape_mixte_deversate',
   abbr_en = 'DCW',
   abbr_de = 'EW',
   abbr_fr = 'EUD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasser aus einem Entlastungsbauwerk, welches zum Vorfluter geführt wird. In diesen Kanal darf kein Schmutzabwasser eingeleitet werden.',
   description_de = 'Wasser aus einem Entlastungsbauwerk, welches zum Vorfluter geführt wird. In diesen Kanal darf kein Schmutzabwasser eingeleitet werden.',
   description_fr = 'Eau conduite entre un ouvrage de déversement et un exutoire au milieu récepteur. Aucune eau usée ne doit être déversée dans cette canalisation',
   description_it = 'Acqua scaricata da un manufatto di scarico e immessa in un corso d''acqua. In questa canalizzazione non possono assere immesse acque luride.',
   description_ro = '',
   display_en = 'discharged_combined_wastewater',
   display_de = 'entlastetes_Mischabwasser',
   display_fr = 'eaux mixtes déversées',
   display_it = '',
   display_ro = 'ape mixte deversate'
WHERE code = 4516;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4524,4524) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'industrial_wastewater',
   value_de = 'Industrieabwasser',
   value_fr = 'eaux_industrielles',
   value_it = 'acque_industriali',
   value_ro = 'ape_industriale',
   abbr_en = '',
   abbr_de = 'CW',
   abbr_fr = 'EUC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Unter Industrieabwasser werden alle Abwässer verstanden, die bei Produktions- und Verarbeitungsprozessen in der Industrie anfallen.Industrieabwässer müssen i.d.R. vorbehandelt werden, bevor sie in öffentliche Kläranlagen eingeleitet werden können (siehe Indirekteinleiter). Bei direkter Einleitung in Gewässer (siehe Direkteinleiter) ist eine umfangreiche Reinigung in speziellen werkseigenen Kläranlagen erforderlich.',
   description_de = 'Unter Industrieabwasser werden alle Abwässer verstanden, die bei Produktions- und Verarbeitungsprozessen in der Industrie anfallen. Industrieabwässer müssen i.d.R. vorbehandelt werden, bevor sie in öffentliche Kläranlagen eingeleitet werden können (siehe Indirekteinleiter). Bei direkter Einleitung in Gewässer (siehe Direkteinleiter) ist eine umfangreiche Reinigung in speziellen werkseigenen Kläranlagen erforderlich.',
   description_fr = 'Eaux industrielles ou chimiques: Les eaux industrielles comprennent toutes les eaux produites lors d''un processus de production ou de fabrication. Les eaux industrielles doivent être prétraitées avant d''être déversées dans les canalisations en direction de la STEP communal (voir évacuation indirecte). En cas de déversement direct dans une eaux de surface, un traitement dans une station de traitement spécifique doit être effectué (voir évacuation directe).',
   description_it = 'Acque industriali o chimiche: comprendono le acque prodotte durante processi industriali o di fabbricazione. Acque industriali devono di regole essere pretrattate, prima di poter essere convogliate in un IDA. Nel caso di un''immissione diretta nel ricettore è necessario un trattamento in speciali impianti industriali.',
   description_ro = '',
   display_en = 'industrial_wastewater',
   display_de = 'Industrieabwasser',
   display_fr = 'eaux industrielles',
   display_it = '',
   display_ro = 'ape industriale'
WHERE code = 4524;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4522,4522) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'combined_wastewater',
   value_de = 'Mischabwasser',
   value_fr = 'eaux_mixtes',
   value_it = 'acque_miste',
   value_ro = 'ape_mixte',
   abbr_en = '',
   abbr_de = 'MW',
   abbr_fr = 'EUM',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_1. Mischung von Schmutz- und Regenabwasser, die gemeinsam abgeleitet werden 2. Abwasser welches aus einer Mischung von Schmutzabwasser und Regenabwasser besteht',
   description_de = '1. Mischung von Schmutz- und Regenabwasser, die gemeinsam abgeleitet werden 2. Abwasser welches aus einer Mischung von Schmutzabwasser und Regenabwasser besteht',
   description_fr = '1. Réunion des eaux usées et eaux pluviales dans la même canalisation',
   description_it = 'Miscela di acque luride e pluviali.',
   description_ro = '',
   display_en = 'combined_wastewater',
   display_de = 'Mischabwasser',
   display_fr = 'eaux mixtes',
   display_it = '',
   display_ro = 'ape mixte'
WHERE code = 4522;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (9023,9023) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'surface_water',
   value_de = 'Niederschlagsabwasser',
   value_fr = 'eaux_de_surface',
   value_it = 'acque_piovane',
   value_ro = 'apa_meteorica',
   abbr_en = 'RW',
   abbr_de = 'RW',
   abbr_fr = 'EUP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Water from precipitation, which has not seeped into the ground and is discharged to the drain or sewer system directly from the ground orfrom exterior building surfaces (DIN EN 16323). The allocation to polluted or unpolluted wastewater is made according to the water protection legislation or according to the instructions of the VSA guideline "Wastewater disposal during rainfall".',
   description_de = 'Unter Niederschlagswasser versteht man das Wasser, welches bei einem Niederschlagsereignis auf eine Oberfläche fällt. Solange es nicht abfliesst und direkt versickert, gilt es als Niederschlagswasser. Sobald es nicht direkt versickert, sondern zuerst über eine bebaute oder befestigte Fläche abfliesst, gilt es als Niederschlagsabwasser.',
   description_fr = 'Eaux de précipitation non infiltrées dans le sol et rejetées depuis le sol ou les surfaces extérieures des bâtiments dans les réseaux d’évacuation et d’assainissement (SIA 190.301 = EN 16323:2014). Classification en eaux polluées et non polluées selon la législation sur la protection des eaux resp. selon la directive VSA "Gestion des eaux urbaines par temps de pluie".',
   description_it = 'Precipitazione che non è infiltrata nel suolo, e che defluisce da superfici o edificazioni nella rete di smaltimento (DIN EN 16323). L''attribuzione ad acque di scarico inquinate o non inquinateavviene secondo la legge sulal protezione delel acque, rispettivamente sulla abse dell''ausilio alla direttiva VSA  "smaltimento acque meteoriche"',
   description_ro = 'rrr_Niederschlag, der nicht im Boden versickert ist und von Bodenoberflächen oder von Gebäudeaussenflächen in das Entwässerungsystem eingeleitet ist (DIN EN 16323). Die Zuordnung zu verschmutztem oder unverschmutztem Abwasser erfolgt nach der Gewässerschutzgesetzgebung bzw. nach Anleitung der VSA-Richtlinie "Abwasserentsorgung bei Regenwetter".',
   display_en = 'surface_water',
   display_de = 'Niederschlagsabwasser',
   display_fr = 'eaux de surface',
   display_it = '',
   display_ro = ''
WHERE code = 9023;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4514,4514) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'clean_wastewater',
   value_de = 'Reinabwasser',
   value_fr = 'eaux_claires',
   value_it = 'acque_chiare',
   value_ro = 'ape_conventional_curate',
   abbr_en = 'CL',
   abbr_de = 'KW',
   abbr_fr = 'EUR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sicker-, Grund-, Quell- und Brunnenwasser sowie Kühlwasser aus Durchlaufkühlungen. Gemäss Gewässerschutzgesetz gilt Reinabwasser als unverschmutztes Abwasser (SN 592''000).',
   description_de = 'Sicker-, Grund-, Quell- und Brunnenwasser sowie Kühlwasser aus Durchlaufkühlungen. Gemäss Gewässerschutzgesetz gilt Reinabwasser als unverschmutztes Abwasser (SN 592 000).',
   description_fr = 'Terme générique pour l''eau de drainage, de source, souterraine, des fontaines, ainsi que de l''eau de refroidissement. Les eaux claires sont considérées comme non polluées (SN 592 000).',
   description_it = 'Termine generico per acque di drenaggio, sorgive, di falda, di fontane e acque di raffreddamento. Secondo la LPAc le acque chiare sono considerate come non inquinate  (SN 592 000).',
   description_ro = '',
   display_en = 'clean_wastewater',
   display_de = 'Reinabwasser',
   display_fr = 'eaux claires',
   display_it = '',
   display_ro = 'ape conventional curate'
WHERE code = 4514;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4526,4526) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'wastewater',
   value_de = 'Schmutzabwasser',
   value_fr = 'eaux_usees',
   value_it = 'acque_luride',
   value_ro = 'ape_uzate',
   abbr_en = 'WW',
   abbr_de = 'SW',
   abbr_fr = 'EU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durch Gebrauch verändertes Wasser (häusliches, gewerbliches oder industrielles Abwasser), das in eine Entwässerungsanlage eingeleitet und einer Abwasserbehandlung zugeführt werden muss. Schmutzabwasser gilt als verschmutztes Abwasser im Sinne des Gewässerschutzgesetzes (SN 592 000)',
   description_de = 'Durch Gebrauch verändertes Wasser (häusliches, gewerbliches oder industrielles Abwasser), das in eine Entwässerungsanlage eingeleitet und einer Abwasserbehandlung zugeführt werden muss. Schmutzabwasser gilt als verschmutztes Abwasser im Sinne des Gewässerschutzgesetzes (SN 592 000)',
   description_fr = 'Eaux transformées par leur utilisation (domestique, artisanale ou industrielle) et qui sont rejetées dans un système d''évacuation et qui doivent être conduites à un traitement',
   description_it = 'Acqua trasformata dal loro utilizzo (domenstico, commerciale o industriale), che sono immesse in impianto di raccoltae devono essere trasportate ad un''IDA. Acque luride sono considerate acque inquinate nel senso della LPAc (SN 592 000)',
   description_ro = '',
   display_en = 'wastewater',
   display_de = 'Schmutzabwasser',
   display_fr = 'eaux usées',
   display_it = '',
   display_ro = 'ape uzate'
WHERE code = 4526;

--- Adapt tww_vl.channel_usage_current
 INSERT INTO tww_vl.channel_usage_current (code, vsacode) VALUES (4571,4571) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = 'U',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 4571;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (5323,5323) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_z.B. auch Zugang, Be- und Entlüftung',
   description_de = 'Z.B. auch Zugang, Be- und Entlüftung',
   description_fr = 'par exemple accès, aération, désaération',
   description_it = 'P. es. anche accesso, ventilazione',
   description_ro = 'de ex: acces, aerare',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5323;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4519,4519) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'creek_water',
   value_de = 'Bachwasser',
   value_fr = 'eaux_cours_d_eau',
   value_it = 'acqua_corso_acqua',
   value_ro = 'ape_curs_de_apa',
   abbr_en = '',
   abbr_de = 'BW',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasser eines Fliessgewässers, das gemäss seinem natürlichen Zustand oberflächlich, aber an einigen Orten auch in unterirdischen Leitungen abfliesst.',
   description_de = 'Wasser eines Fliessgewässers, das gemäss seinem natürlichen Zustand oberflächlich, aber an einigen Orten auch in unterirdischen Leitungen abfliesst.',
   description_fr = 'Eaux d''un cours d''eau s''écoulant dans son état naturel à la surface, mais qui peut aussi être mis sous terre par endroits',
   description_it = 'Acqua di un corso d''acqua che scorre in superficie ma che può anche essere intubato a tratti.',
   description_ro = '',
   display_en = 'creek_water',
   display_de = 'Bachwasser',
   display_fr = 'eaux cours d''eau',
   display_it = '',
   display_ro = 'ape curs de apa'
WHERE code = 4519;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4517,4517) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'discharged_combined_wastewater',
   value_de = 'entlastetes_Mischabwasser',
   value_fr = 'eaux_mixtes_deversees',
   value_it = 'acque_miste_scaricate',
   value_ro = 'ape_mixte_deversate',
   abbr_en = 'DCW',
   abbr_de = 'EW',
   abbr_fr = 'EUD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasser aus einem Entlastungsbauwerk, welches zum Vorfluter geführt wird. In diesen Kanal darf kein Schmutzabwasser eingeleitet werden.',
   description_de = 'Wasser aus einem Entlastungsbauwerk, welches zum Vorfluter geführt wird. In diesen Kanal darf kein Schmutzabwasser eingeleitet werden.',
   description_fr = 'Eau conduite entre un ouvrage de déversement et un exutoire au milieu récepteur. Aucune eau usée ne doit être déversée dans cette canalisation',
   description_it = 'Acqua scaricata da un manufatto di scarico e immessa in un corso d''acqua. In questa canalizzazione non possono assere immesse acque luride.',
   description_ro = 'Apele unui rau care curge in stare naturala pe la suprafata dar care pot urma pe alocuri un traseu subteran. Nu are voie nici o apa uzata sa intre in aceasta conducta',
   display_en = 'discharged_combined_wastewater',
   display_de = 'entlastetes_Mischabwasser',
   display_fr = 'eaux mixtes déversées',
   display_it = '',
   display_ro = 'ape mixte deversate'
WHERE code = 4517;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4525,4525) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'industrial_wastewater',
   value_de = 'Industrieabwasser',
   value_fr = 'eaux_industrielles',
   value_it = 'acque_industriali',
   value_ro = 'ape_industriale',
   abbr_en = 'IW',
   abbr_de = 'CW',
   abbr_fr = 'EUC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Unter Industrieabwasser werden alle Abwässer verstanden, die bei Produktions- und Verarbeitungsprozessen in der Industrie anfallen. Industrieabwässer müssen i.d.R. vorbehandelt werden, bevor sie in öffentliche Kläranlagen eingeleitet werden können (siehe Indirekteinleiter). Bei direkter Einleitung in Gewässer (siehe Direkteinleiter) ist eine umfangreiche Reinigung in speziellen werkseigenen Kläranlagen erforderlich.',
   description_de = 'Unter Industrieabwasser werden alle Abwässer verstanden, die bei Produktions- und Verarbeitungsprozessen in der Industrie anfallen. Industrieabwässer müssen i.d.R. vorbehandelt werden, bevor sie in öffentliche Kläranlagen eingeleitet werden können (siehe Indirekteinleiter). Bei direkter Einleitung in Gewässer (siehe Direkteinleiter) ist eine umfangreiche Reinigung in speziellen werkseigenen Kläranlagen erforderlich.',
   description_fr = 'Eaux industrielles ou chimiques: Les eaux industrielles comprennent toutes les eaux produites lors d''un processus de production ou de fabrication. Les eaux industrielles doivent être prétraitées avant d''être déversées dans les canalisations en direction de la STEP communal (voir évacuation indirecte). En cas de déversement direct dans une eaux de surface, un traitement dans une station de traitement spécifique doit être effectué (voir évacuation directe).',
   description_it = 'Acque industriali o chimiche: comprendono le acque prodotte durante processi industriali o di fabbricazione. Acque industriali devono di regole essere pretrattate, prima di poter essere convogliate in un IDA. Nel caso di un''immissione diretta nel ricettore è necessario un trattamento in speciali impianti industriali.',
   description_ro = '',
   display_en = 'industrial_wastewater',
   display_de = 'Industrieabwasser',
   display_fr = 'eaux industrielles',
   display_it = '',
   display_ro = 'ape industriale'
WHERE code = 4525;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4523,4523) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'combined_wastewater',
   value_de = 'Mischabwasser',
   value_fr = 'eaux_mixtes',
   value_it = 'acque_miste',
   value_ro = 'ape_mixte',
   abbr_en = 'CW',
   abbr_de = 'MW',
   abbr_fr = 'EUM',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_1. Mischung von Schmutz- und Regenabwasser, die gemeinsam abgeleitet werden 2. Abwasser welches aus einer Mischung von Schmutzabwasser und Regenabwasser besteht',
   description_de = '1. Mischung von Schmutz- und Regenabwasser, die gemeinsam abgeleitet werden 2. Abwasser welches aus einer Mischung von Schmutzabwasser und Regenabwasser besteht',
   description_fr = '1. Réunion des eaux usées et eaux pluviales dans la même canalisation',
   description_it = 'Miscela di acque luride e pluviali.',
   description_ro = 'Uniunea de apa meteorica si ape uzate',
   display_en = 'combined_wastewater',
   display_de = 'Mischabwasser',
   display_fr = 'eaux mixtes',
   display_it = '',
   display_ro = 'ape mixte'
WHERE code = 4523;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (9022,9022) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'surface_water',
   value_de = 'Niederschlagsabwasser',
   value_fr = 'eaux_de_surface',
   value_it = 'acque_piovane',
   value_ro = 'apa_meteorica',
   abbr_en = 'RW',
   abbr_de = 'RW',
   abbr_fr = 'EUP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Water from precipitation, which has not seeped into the ground and is discharged to the drain or sewer system directly from the ground orfrom exterior building surfaces (DIN EN 16323). The allocation to polluted or unpolluted wastewater is made according to the water protection legislation or according to the instructions of the VSA guideline "Wastewater disposal during rainfall".',
   description_de = 'Unter Niederschlagswasser versteht man das Wasser, welches bei einem Niederschlagsereignis auf eine Oberfläche fällt. Solange es nicht abfliesst und direkt versickert, gilt es als Niederschlagswasser. Sobald es nicht direkt versickert, sondern zuerst über eine bebaute oder befestigte Fläche abfliesst, gilt es als Niederschlagsabwasser.',
   description_fr = 'Eaux de précipitation non infiltrées dans le sol et rejetées depuis le sol ou les surfaces extérieures des bâtiments dans les réseaux d’évacuation et d’assainissement (SIA 190.301 = EN 16323:2014). Classification en eaux polluées et non polluées selon la législation sur la protection des eaux resp. selon la directive VSA "Gestion des eaux urbaines par temps de pluie".',
   description_it = 'Precipitazione che non è infiltrata nel suolo, e che defluisce da superfici o edificazioni nella rete di smaltimento (DIN EN 16323). L''attribuzione ad acque di scarico inquinate o non inquinateavviene secondo la legge sulal protezione delel acque, rispettivamente sulla abse dell''ausilio alla direttiva VSA  "smaltimento acque meteoriche"',
   description_ro = 'rrr_Niederschlag, der nicht im Boden versickert ist und von Bodenoberflächen oder von Gebäudeaussenflächen in das Entwässerungsystem eingeleitet ist (DIN EN 16323). Die Zuordnung zu verschmutztem oder unverschmutztem Abwasser erfolgt nach der Gewässerschutzgesetzgebung bzw. nach Anleitung der VSA-Richtlinie "Abwasserentsorgung bei Regenwetter".',
   display_en = 'surface_water',
   display_de = 'Niederschlagsabwasser',
   display_fr = 'eaux de surface',
   display_it = '',
   display_ro = ''
WHERE code = 9022;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4515,4515) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'clean_wastewater',
   value_de = 'Reinabwasser',
   value_fr = 'eaux_claires',
   value_it = 'acque_chiare',
   value_ro = 'ape_conventional_curate',
   abbr_en = 'CL',
   abbr_de = 'KW',
   abbr_fr = 'EUR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sicker-, Grund-, Quell- und Brunnenwasser sowie Kühlwasser aus Durchlaufkühlungen. Gemäss Gewässerschutzgesetz gilt Reinabwasser als unverschmutztes Abwasser (SN 592 000).',
   description_de = 'Sicker-, Grund-, Quell- und Brunnenwasser sowie Kühlwasser aus Durchlaufkühlungen. Gemäss Gewässerschutzgesetz gilt Reinabwasser als unverschmutztes Abwasser  (SN 592 000).',
   description_fr = 'Terme générique pour l''eau de drainage, de source, souterraine, des fontaines, ainsi que de l''eau de refroidissement. Les eaux claires sont considérées comme non polluées (SN 592 000)..',
   description_it = 'Termine generico per acque di drenaggio, sorgive, di falda, di fontane e acque di raffreddamento. Secondo la LPAc le acque chiare sono considerate come non inquinate  (SN 592 000).',
   description_ro = '',
   display_en = 'clean_wastewater',
   display_de = 'Reinabwasser',
   display_fr = 'eaux claires',
   display_it = '',
   display_ro = 'ape conventional curate'
WHERE code = 4515;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4527,4527) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'wastewater',
   value_de = 'Schmutzabwasser',
   value_fr = 'eaux_usees',
   value_it = 'acque_luride',
   value_ro = 'ape_uzate',
   abbr_en = 'WW',
   abbr_de = 'SW',
   abbr_fr = 'EU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durch Gebrauch verändertes Wasser (häusliches, gewerbliches oder industrielles Abwasser), das in eine Entwässerungsanlage eingeleitet und einer Abwasserbehandlung zugeführt werden muss. Schmutzabwasser gilt als verschmutztes Abwasser im Sinne des Gewässerschutzgesetzes (SN 592 000)',
   description_de = 'Durch Gebrauch verändertes Wasser (häusliches, gewerbliches oder industrielles Abwasser), das in eine Entwässerungsanlage eingeleitet und einer Abwasserbehandlung zugeführt werden muss. Schmutzabwasser gilt als verschmutztes Abwasser im Sinne des Gewässerschutzgesetzes (SN 592 000)',
   description_fr = 'Eaux transformées par leur utilisation (domestique, artisanale ou industrielle) et qui sont rejetées dans un système d''évacuation et qui doivent être conduites à un traitement',
   description_it = 'Acqua trasformata dal loro utilizzo (domenstico, commerciale o industriale), che sono immesse in impianto di raccoltae devono essere trasportate ad un''IDA. Acque luride sono considerate acque inquinate nel senso della LPAc (SN 592 000)',
   description_ro = '',
   display_en = 'wastewater',
   display_de = 'Schmutzabwasser',
   display_fr = 'eaux usées',
   display_it = '',
   display_ro = 'ape uzate'
WHERE code = 4527;

--- Adapt tww_vl.channel_usage_planned
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode) VALUES (4569,4569) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.channel_usage_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 4569;

--- Adapt tww_vl.manhole_amphibian_exit
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode) VALUES (9052,9052) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_amphibian_exit SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 9052;

--- Adapt tww_vl.manhole_amphibian_exit
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode) VALUES (9053,9053) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_amphibian_exit SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 9053;

--- Adapt tww_vl.manhole_amphibian_exit
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode) VALUES (9054,9054) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_amphibian_exit SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9054;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (4532,4532) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'drop_structure',
   value_de = 'Absturzbauwerk',
   value_fr = 'ouvrage_de_chute',
   value_it = 'manufatto_caduta',
   value_ro = 'instalatie_picurare',
   abbr_en = 'DS',
   abbr_de = 'AK',
   abbr_fr = 'OC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_de = 'Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_fr = 'Ouvrage spécial dans le réseau de canalisations servant à relier des différences d''altitude sur une petite distance, en brisant l''énergie de l''écoulement.',
   description_it = 'zzz_Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_ro = '',
   display_en = 'drop_structure',
   display_de = 'Absturzbauwerk',
   display_fr = 'ouvrage de chute',
   display_it = '',
   display_ro = 'instalatie picurare'
WHERE code = 4532;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (5344,5344) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5344;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (4533,4533) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'venting',
   value_de = 'Be_Entlueftung',
   value_fr = 'aeration',
   value_it = 'zzz_Be_Entlueftung',
   value_ro = 'aerisire',
   abbr_en = 'VE',
   abbr_de = 'BE',
   abbr_fr = 'AE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_de = 'Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_fr = 'Installation permettant une aération dans un ouvrage d''assainissement',
   description_it = 'zzz_Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_ro = '',
   display_en = 'venting',
   display_de = 'Be_Entlueftung',
   display_fr = 'aeration',
   display_it = '',
   display_ro = 'aerisire'
WHERE code = 4533;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8702,8702) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'treatment_plant',
   value_de = 'Behandlungsanlage',
   value_fr = 'installation_traitement',
   value_it = 'installazione_di_trattamento',
   value_ro = 'rrr_Behandlungsanlage',
   abbr_en = '',
   abbr_de = 'BH',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   description_de = 'Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   description_fr = 'Installation de traitement des eaux de chaussée (SETEC) ou des eaux pluviales issues des biens-fonds, telle que filtres en terre, en gravillon, en sable ou techniques et adsorbeurs artificiels. Réalisation concrète comme cuvette, chambre (standard), ouvrage spécial/bassin ou installation technique. Les chambres et bassins de décantation (= dépotoirs ou BEP clarification) ne sont pas considérés à ce titre comme des installations de traitement. Des valeurs d’attribut distinctes sont disponibles pour ces installations de traitement.',
   description_it = 'Impianto per il trattamento delle acque di scarico stradali (SABA) o delle acque meteoriche da zone edificate come filtri in terreno vegetale, filtri split, filtri a sabbia o filtri tecnici e adsorber artificiali. Realizzazioni di trincee superficiali, pozzetto d''ispezione, di manufatti speciali/bacino o impianto tecnico. Bacini di decantazione (=raccoglitori di fanghi o bacini di chiarificazione) non sono qui considerati impianti di trattamento; per questi sono previsti attributi specifici.',
   description_ro = 'rrr_Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   display_en = 'treatment_plant',
   display_de = 'Behandlungsanlage',
   display_fr = 'installation traitement',
   display_it = '',
   display_ro = ''
WHERE code = 8702;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8995,8995) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'floor_drain',
   value_de = 'Bodenablauf',
   value_fr = 'ecoulement_de_sol',
   value_it = 'scarico_a_pavimento',
   value_ro = 'rrr_Bodenablauf',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Floor drain',
   description_de = 'Bodenablauf',
   description_fr = 'Ecoulement d''eau au sol, grille de sol',
   description_it = 'scarico a pavimento',
   description_ro = '',
   display_en = 'floor_drain',
   display_de = 'Bodenablauf',
   display_fr = 'écoulement de sol',
   display_it = '',
   display_ro = ''
WHERE code = 8995;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (3267,3267) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'rain_water_manhole',
   value_de = 'Dachwasserschacht',
   value_fr = 'chambre_recolte_eaux_toitures',
   value_it = 'pozzetto_acque_tetti',
   value_ro = 'camin_vizitare_apa_meteorica',
   abbr_en = 'RWM',
   abbr_de = 'DS',
   abbr_fr = 'CRT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schacht im Bereich der Liegenschaftsentwässerung, in den in der Regel Abflussrohre vom Dach einmünden. Diese sind meist kleiner als die Einlaufschächte',
   description_de = 'Schacht im Bereich der Liegenschaftsentwässerung, in den in der Regel Abflussrohre vom Dach einmünden. Diese sind meist kleiner als die Einlaufschächte',
   description_fr = 'Chambre se trouvant entre l''évacuation des eaux des bien-fonds et du réseau des canalisations, à l''arrivée d''un tuyau de descente. Souvent de taille inférieure que des chambres avec grille d''entrée',
   description_it = 'zzz_Schacht im Bereich der Liegenschaftsentwässerung, in den in der Regel Abflussrohre vom Dach einmünden. Diese sind meist kleiner als die Einlaufschächte',
   description_ro = '',
   display_en = 'rain_water_manhole',
   display_de = 'Dachwasserschacht',
   display_fr = 'chambre de récolte des eaux de toitures',
   display_it = '',
   display_ro = 'camin vizitare apa meteorica'
WHERE code = 3267;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (3266,3266) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'gully',
   value_de = 'Einlaufschacht',
   value_fr = 'chambre_avec_grille_d_entree',
   value_it = 'pozzetto_griglia',
   value_ro = 'gura_scurgere',
   abbr_en = 'G',
   abbr_de = 'ES',
   abbr_fr = 'CG',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf zur Fassung des Oberflächenwasssers bestehend aus einem Schacht mit einem Aufsatz aus einem Rahmen und einem Rost (VSS, SN 640 356)',
   description_de = 'Ablauf zur Fassung des Oberflächenwasssers bestehend aus einem Schacht mit einem Aufsatz aus einem Rahmen und einem Rost (VSS, SN 640 356)',
   description_fr = 'chambre avec grille d''entrée (sans retenue de boues) selon SN 640 356',
   description_it = 'Pozzetto con una griglia per la raccolta di acque superficiali (VSS, SN 640 356).',
   description_ro = 'rrr_Ablauf zur Fassung des Oberflächenwasssers bestehend aus einem Schacht mit einem Aufsatz aus einem Rahmen und einem Rost (VSS, SN 640 356)',
   display_en = 'gully',
   display_de = 'Einlaufschacht',
   display_fr = 'chambre avec grille d''entrée',
   display_it = '',
   display_ro = 'gura scurgere'
WHERE code = 3266;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (3472,3472) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'drainage_channel',
   value_de = 'Entwaesserungsrinne',
   value_fr = 'rigole_de_drainage',
   value_it = 'canaletta_drenaggio',
   value_ro = 'rigola',
   abbr_en = '',
   abbr_de = 'ER',
   abbr_fr = 'RD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser',
   description_de = 'Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser',
   description_fr = 'Ouvrage rectiligne à fentes, servant à récolter les eaux de ruissellement.',
   description_it = 'zzz_Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser',
   description_ro = '',
   display_en = 'drainage_channel',
   display_de = 'Entwaesserungsrinne',
   display_fr = 'rigole de drainage',
   display_it = '',
   display_ro = 'rigola'
WHERE code = 3472;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8828,8828) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'drainage_channel_with_mud_bag',
   value_de = 'Entwaesserungsrinne_mit_Schlammsack',
   value_fr = 'rigole_de_drainage_avec_depotoir',
   value_it = 'zzz_canaletta_drenaggio_mit_Schlammsack',
   value_ro = 'rrr_Entwaesserungsrinne_mit_Schlammsack',
   abbr_en = '',
   abbr_de = 'ERS',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser und Schlammsack. Dieser ist dort, wo der Regenabwasserkanal wegführt, also beim Abwasserknoten und Deckel.',
   description_de = 'Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser mit Schlammsack. Dieser ist dort, wo der Regenabwasserkanal wegführt, also beim Abwasserknoten und Deckel.',
   description_fr = 'Ouvrage rectiligne à fentes avec dépotoir, servant à récolter les eaux de ruissellement. Le dépotoir se situe au départ du canal d''eaux de surface, donc au NOEUD_RESEAU et au couvercle.',
   description_it = 'Elemento strutturale allungato con aperture a fessura per la raccolta delle acque di deflusso superficiale con un sacco di fango. Il sacco di fango si trova dove il canale di scolo porta via, cioè al nodo (delle acque reflue) e alla copertura.',
   description_ro = 'rrr_Längliches Bauelement mit geschlitzten Öffnungen zur Aufnahme von abfliessendem Oberflächenwasser und Schlammsack. Der Schlammsack ist dort, wo der Regenabwasserkanal wegführt, also beim Abwasserknoten und Deckel.',
   display_en = 'drainage_channel_with_mud_bag',
   display_de = 'Entwaesserungsrinne_mit_Schlammsack',
   display_fr = 'rigole de drainage avec dépotoir',
   display_it = '',
   display_ro = ''
WHERE code = 8828;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8601,8601) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'grease_separator',
   value_de = 'Fettabscheider',
   value_fr = 'separateur_de_graisse',
   value_it = 'separatore_di_grasso',
   value_ro = 'rrr_Fettabscheider',
   abbr_en = '',
   abbr_de = 'FA',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Separation plant for animal and vegetable fats and oils. [SN 592 000:2012]',
   description_de = 'Abscheideanlage für tierische und pflanzliche Fette und Öle. (SN 592 000:2012)',
   description_fr = 'Séparateur pour les graisses et huiles d''origine animale et végétale . (SN 592 000:2012)',
   description_it = 'Impianto di separazione per grassi e oli animali e vegetali (SN 592 000:2012)',
   description_ro = 'rrr_Abscheideanlage für tierische und pflanzliche Fette und Öle. (SN 592 000:2012)',
   display_en = 'grease_separator',
   display_de = 'Fettabscheider',
   display_fr = 'séparateur de graisse',
   display_it = '',
   display_ro = ''
WHERE code = 8601;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (228,228) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'rail_track_gully',
   value_de = 'Geleiseschacht',
   value_fr = 'evacuation_des_eaux_des_voies_ferrees',
   value_it = 'pozzetto_binario',
   value_ro = 'evacuare_ape_cale_ferata',
   abbr_en = '',
   abbr_de = 'GL',
   abbr_fr = 'EVF',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Standard shaft for drainage of track systems',
   description_de = 'Normschacht zur Entwässerung von Geleiseanlagen',
   description_fr = 'Chambre standard servant à évacuer les eaux d''installation ferroviaires',
   description_it = 'Albero standard per il drenaggio dei sistemi di binari',
   description_ro = 'Arbore standard pentru drenajul sistemelor de cale ferata',
   display_en = 'rail_track_gully',
   display_de = 'Geleiseschacht',
   display_fr = 'évacuation des eaux des voies ferrées',
   display_it = '',
   display_ro = 'evacuare ape cale ferata'
WHERE code = 228;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8654,8654) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'combined_manhole',
   value_de = 'Kombischacht',
   value_fr = 'chambre_combine',
   value_it = 'pozzetto_doppio',
   value_ro = 'rrr_Kombischacht',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Shared manhole for two parallel wastewater lines, usually a wastewater pipe and a stormwater pipe.',
   description_de = 'Gemeinsamer Kontroll_Einsteigschacht für zwei parallel verlaufende Abwasserleitungen, meist eine Schmutz- und eine Regenabwasserleitung.',
   description_fr = 'chambre_de_visite_ou_d_inspection commmune pour deux conduites d''assainissement en parallèle, typiquement une conduite d''eaux usées et une conduite d''eaux de surface',
   description_it = 'Pozzetto di ispezione congiunto per due condotte parallele per acque di scarico, in genere una condotta per acque luride e una condotta per acque meteoriche',
   description_ro = 'rrrr_Gemeinsamer Kontroll_Einsteigschacht für zwei parallel verlaufende Abwasserleitungen, meist eine Schmutz- und eine Regenabwasserleitung.',
   display_en = 'combined_manhole',
   display_de = 'Kombischacht',
   display_fr = 'chambre combiné',
   display_it = '',
   display_ro = ''
WHERE code = 8654;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8736,8736) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'manhole',
   value_de = 'Kontroll_Einsteigschacht',
   value_fr = 'chambre_de_visite_ou_d_inspection',
   value_it = 'pozzetto_di_ispezione',
   value_ro = 'rrr_Kontroll_Einsteigschacht',
   abbr_en = '',
   abbr_de = 'KS',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Manhole or inspection chamber for maintenance and inspection purposes (definition according to SIA 190.301 / EN 16323:2014)',
   description_de = 'Einsteig- oder Kontrollschacht für Unterhalts- und Kontrollzwecke (Definition gemäss SIA 190.301 / EN 16323:2014)',
   description_fr = 'Chambre de visite ou boîte de branchement/d''inspection pour entretenir et inspecter les canalisations (définitions selon SIA 190.301 = EN 16323:2014)',
   description_it = 'Pozzetto di accesso o di controllo a scopo di manutenzione e controllo (definizione secondo SIA 190.301 / EN 16323:2014)',
   description_ro = 'rrr_Einsteig- oder Kontrollschacht für Unterhalts- und Kontrollzwecke (Definition gemäss SIA 190.301 / EN 16323:2014)',
   display_en = 'manhole',
   display_de = 'Kontroll_Einsteigschacht',
   display_fr = 'chambre de visite ou d''inspection',
   display_it = '',
   display_ro = ''
WHERE code = 8736;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (1008,1008) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'oil_separator',
   value_de = 'Oelabscheider',
   value_fr = 'separateur_d_hydrocarbures',
   value_it = 'separatore_olii',
   value_ro = 'separator_hidrocarburi',
   abbr_en = 'OS',
   abbr_de = 'OA',
   abbr_fr = 'SH',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abscheideanlage für mineralische Leichtflüssigkeiten, evtl. mit Koaleszenzstufe und/oder selbsttätigem Abschluss (SN 592 000:2012)',
   description_de = 'Abscheideanlage für mineralische Leichtflüssigkeiten, evtl. mit Koaleszenzstufe und/oder selbsttätigem Abschluss (SN 592 000:2012)',
   description_fr = 'Ouvrage servant à séparer des liquides minéraux légers de l''eau, év. par coalescence et/ou avec fermeture automatique (SN 592''000)',
   description_it = 'mpianto per la separazione di liquidi leggeri minerali, ev. con filtro a coalescenza e/o chiusura automatica (SN 592 000:2012)',
   description_ro = 'rrr_Structura speciala pentru separarea fluidelor u?oare de apa. Acesta previne patrunderea uleiurilor in mediile receptoare.',
   display_en = 'oil_separator',
   display_de = 'Oelabscheider',
   display_fr = 'séparateur d''hydrocarbures',
   display_it = '',
   display_ro = 'separator hidrocarburi'
WHERE code = 1008;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (4536,4536) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'pump_station',
   value_de = 'Pumpwerk',
   value_fr = 'station_de_pompage',
   value_it = 'stazione_pompaggio',
   value_ro = 'statie_pompare',
   abbr_en = '',
   abbr_de = 'PW',
   abbr_fr = 'SP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_de = 'Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_fr = 'Installation destinée à élever les eaux d''un niveau à un autre, soit pour le franchissement d''un obstacle, soit pour modifier des tracés devenus économiquement inacceptables en réseau gravitaire',
   description_it = 'zzz_Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_ro = '',
   display_en = 'pump_station',
   display_de = 'Pumpwerk',
   display_fr = 'station de pompage',
   display_it = '',
   display_ro = 'statie pompare'
WHERE code = 4536;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (5346,5346) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'stormwater_overflow',
   value_de = 'Regenueberlauf',
   value_fr = 'deversoir_d_orage',
   value_it = 'scaricatore_piena',
   value_ro = 'preaplin',
   abbr_en = 'SO',
   abbr_de = 'RU',
   abbr_fr = 'DO',
   abbr_it = 'SP',
   abbr_ro = '',
   description_en = 'yyy_Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_de = 'Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_fr = 'Ouvrage spécial, séparant les eaux mixtes en y rejetant une partie directement dans un cours d’eau',
   description_it = 'zzz_Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_ro = '',
   display_en = 'stormwater_overflow',
   display_de = 'Regenueberlauf',
   display_fr = 'dévérsoir d''orage',
   display_it = '',
   display_ro = 'preaplin'
WHERE code = 5346;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (2742,2742) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'slurry_collector',
   value_de = 'Schlammsammler',
   value_fr = 'depotoir',
   value_it = 'pozzetto_decantazione',
   value_ro = 'colector_aluviuni',
   abbr_en = '',
   abbr_de = 'SA',
   abbr_fr = 'D',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abscheideanlage mit Geruchsverschluss (in der Regel Tauchbogen), welche dem Rückhalt und der Entnahme unerwünschter Sinkstoffe dient (Kies, Sand, usw.). Auch Schlammfänge (=Abscheideanlagen  ohne Geruchsverschluss) sind als Schlammsammler zu attributieren.',
   description_de = 'Abscheideanlage mit Geruchsverschluss (in der Regel Tauchbogen), welche dem Rückhalt und der Entnahme unerwünschter Sinkstoffe dient (Kies, Sand, usw.). Auch Schlammfänge (=Abscheideanlagen  ohne Geruchsverschluss) sind als Schlammsammler zu attributieren.',
   description_fr = 'Installation de séparation avec siphon (typiquement coude plongeur) destinée à retenir et à prélever les matières décantables indésirables (gravier, sable etc.). Les pièges à boue (=séparateurs sans siphon) reçoivent également l''attribut dépotoir.',
   description_it = 'Impianto di separazione con blocco degli odori (di regola sifone) che serve a trattenere e rimuovere sostanze indesiderate (ghiaia, sabbia, ecc.). Anche impianti con trattenuta di fanghi = impianti di separazione senza dispositivo anti odori) vengono definiti come pozzetto raccoglitori di fanghi.',
   description_ro = 'rrr_Abscheideanlage mit Geruchsverschluss (in der Regel Tauchbogen), welche dem Rückhalt und der Entnahme unerwünschter Sinkstoffe dient (Kies, Sand, usw.). Auch Schlammfänge (=Abscheideanlagen  ohne Geruchsverschluss) sind als Schlammsammler zu attributieren.',
   display_en = 'slurry_collector',
   display_de = 'Schlammsammler',
   display_fr = 'dépotoir',
   display_it = '',
   display_ro = 'colector aluviuni'
WHERE code = 2742;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (5347,5347) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'floating_material_separator',
   value_de = 'Schwimmstoffabscheider',
   value_fr = 'separateur_de_materiaux_flottants',
   value_it = 'separatore_materiali_galleggianti',
   value_ro = 'separator_materie_flotanta',
   abbr_en = '',
   abbr_de = 'SW',
   abbr_fr = 'SMF',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_A floating material seperator is a Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_de = 'Ein Schwimmstoffabscheider ist ein Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_fr = 'Dépotoir contenant soit un siphon prolongé ou une paroi plongeante. Tient le rôle de prétraitement sur une installation d''infiltration',
   description_it = 'zzz_Ein Schwimmstoffabscheider ist ein Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_ro = '',
   display_en = 'floating_material_separator',
   display_de = 'Schwimmstoffabscheider',
   display_fr = 'séparateur de matériaux flottants',
   display_it = '',
   display_ro = 'separator materie flotanta'
WHERE code = 5347;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (4537,4537) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'jetting_manhole',
   value_de = 'Spuelschacht',
   value_fr = 'chambre_de_chasse',
   value_it = 'pozzetto_lavaggio',
   value_ro = 'camin_spalare',
   abbr_en = '',
   abbr_de = 'SS',
   abbr_fr = 'CC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Manhole required for flushing purposes. If there is no real manhole, model it as a flushing connection (structure_part).',
   description_de = 'Schacht der zu Spülzwecken benötigt wird. Falls kein richtiger Schacht als Spuelstutzen (BauwerksTeil) modellieren.',
   description_fr = 'Chambre servant d''accès spécifiquement pour le rinçage. Si pas de véritable chambre, modeliser comme tete_de_rincage (element_ouvrage)',
   description_it = 'zzz_Schacht der zu Spülzwecken benötigt wird. Falls kein richtiger Schacht als Spuelstutzen (BauwerksTeil) modellieren.',
   description_ro = 'rrr_Schacht der zu Spülzwecken benötigt wird. Falls kein richtiger Schacht als Spuelstutzen (BauwerksTeil) modellieren.',
   display_en = 'jetting_manhole',
   display_de = 'Spuelschacht',
   display_fr = 'chambre de chasse',
   display_it = '',
   display_ro = 'camin spalare'
WHERE code = 4537;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (4798,4798) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'separating_structure',
   value_de = 'Trennbauwerk',
   value_fr = 'ouvrage_de_repartition',
   value_it = 'camera_ripartizione',
   value_ro = 'separator',
   abbr_en = '',
   abbr_de = 'TB',
   abbr_fr = 'OR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Building that separates wastewater in the system but does not discharge it from the system. Exception: In front of a catch basin or catch channel, mixed wastewater is discharged into the watercourse via the separation structure after filling the basin volume. One or more inlets, two or more outlets.',
   description_de = 'Bauwerk, welches Abwasser im System auftrennt, aber nicht aus dem System entlastet. Ausnahme: Vor einem Fangbecken oder Fangkanal wird nach Füllung des Beckenvolumens Mischabwasser über das Trennbauwerk ins Gewässer entlastet. Ein oder mehrere Zuläufe, zwei oder mehr Abläufe.',
   description_fr = 'Ouvrage, qui répartit les eaux dans le système sans les déverser. Exception: avant un bassin ou un canal de stockage, les eaux mixtes sont déversées dans le cours ou plan d''eau via l''ouvrage de répartition après remplissage du volume du bassin. Une ou plusieurs entrées, deux ou plusieurs sorties.',
   description_it = 'Manufatto che suddivide le acque reflue nel sistema ma senza scaricarle. Eccezione: prima di un bacino di accumulo in parallelo, dopo riempimento del volume del bacino, le acque miste vengono scaricate nel ricettore naturale attraverso la camera di ripartizione. Uno o più entrate, due o più scarichi.',
   description_ro = 'rrr_Bauwerk, welches Abwasser im System auftrennt, aber nicht aus dem System entlastet. Ausnahme: Vor einem Fangbecken oder Fangkanal wird nach Füllung des Beckenvolumens Mischabwasser über das Trennbauwerk ins Gewässer entlastet. Ein oder mehrere Zuläufe, zwei oder mehr Abläufe.',
   display_en = 'separating_structure',
   display_de = 'Trennbauwerk',
   display_fr = 'chambre de répartition',
   display_it = '',
   display_ro = 'separator'
WHERE code = 4798;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (5345,5345) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5345;

--- Adapt tww_vl.manhole_function
 INSERT INTO tww_vl.manhole_function (code, vsacode) VALUES (8703,8703) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_function SET
   value_en = 'pretreatment_plant',
   value_de = 'Vorbehandlungsanlage',
   value_fr = 'installation_de_pretraitement',
   value_it = 'zzz_Vorbehandlungsanlage',
   value_ro = 'rrr_Vorbehandlungsanlage',
   abbr_en = 'yyy',
   abbr_de = 'VH',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_de = 'Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_fr = 'Installation destinée au prétraitement des eaux usées industrielles ou artisanales avant l''évacuation vers la STEP, telle que des installations de séparation ou de flottation. Les séparateurs d''hydrocarbures et de graisses et les chambres et bassins de décantation (= dépotoirs ou BEP clarification) ne sont pas considérés à ce titre comme des installations de prétraitement. Des valeurs d’attribut distinctes sont disponibles pour ces équipements. Utiliser la valeur "installation_de_traitement" pour eaux pluviales.',
   description_it = 'zzz_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_ro = 'rrr_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   display_en = 'pretreatment_plant',
   display_de = 'Vorbehandlungsanlage',
   display_fr = 'installation de prétraitement',
   display_it = '',
   display_ro = ''
WHERE code = 8703;

--- Adapt tww_vl.manhole_material
 INSERT INTO tww_vl.manhole_material (code, vsacode) VALUES (4540,4540) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 4540;

--- Adapt tww_vl.manhole_material
 INSERT INTO tww_vl.manhole_material (code, vsacode) VALUES (4541,4541) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_material SET
   value_en = 'concrete',
   value_de = 'Beton',
   value_fr = 'beton',
   value_it = 'calcestruzzo',
   value_ro = 'beton',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete',
   display_de = 'Beton',
   display_fr = 'béton',
   display_it = '',
   display_ro = 'beton'
WHERE code = 4541;

--- Adapt tww_vl.manhole_material
 INSERT INTO tww_vl.manhole_material (code, vsacode) VALUES (4542,4542) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_material SET
   value_en = 'plastic',
   value_de = 'Kunststoff',
   value_fr = 'matiere_plastique',
   value_it = 'materiale_sintetico',
   value_ro = 'materie_plastica',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic',
   display_de = 'Kunststoff',
   display_fr = 'matière synthétique',
   display_it = '',
   display_ro = 'materie plastica'
WHERE code = 4542;

--- Adapt tww_vl.manhole_material
 INSERT INTO tww_vl.manhole_material (code, vsacode) VALUES (4543,4543) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 4543;

--- Adapt tww_vl.manhole_possibility_intervention
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode) VALUES (9056,9056) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_possibility_intervention SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 9056;

--- Adapt tww_vl.manhole_possibility_intervention
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode) VALUES (9057,9057) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_possibility_intervention SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 9057;

--- Adapt tww_vl.manhole_possibility_intervention
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode) VALUES (9058,9058) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_possibility_intervention SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9058;

--- Adapt tww_vl.manhole_surface_inflow
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode) VALUES (5342,5342) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_surface_inflow SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5342;

--- Adapt tww_vl.manhole_surface_inflow
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode) VALUES (2741,2741) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_surface_inflow SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucune',
   value_it = 'nessuno',
   value_ro = 'niciunul',
   abbr_en = '',
   abbr_de = 'K',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucune',
   display_it = '',
   display_ro = 'niciunul'
WHERE code = 2741;

--- Adapt tww_vl.manhole_surface_inflow
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode) VALUES (2739,2739) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_surface_inflow SET
   value_en = 'grid',
   value_de = 'Rost',
   value_fr = 'grille_d_ecoulement',
   value_it = 'zzz_Rost',
   value_ro = 'grilaj',
   abbr_en = '',
   abbr_de = 'R',
   abbr_fr = 'G',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'grid',
   display_de = 'Rost',
   display_fr = 'Grille d''écoulement',
   display_it = '',
   display_ro = 'grilaj'
WHERE code = 2739;

--- Adapt tww_vl.manhole_surface_inflow
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode) VALUES (5343,5343) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_surface_inflow SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5343;

--- Adapt tww_vl.manhole_surface_inflow
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode) VALUES (2740,2740) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.manhole_surface_inflow SET
   value_en = 'intake_from_side',
   value_de = 'Zulauf_seitlich',
   value_fr = 'arrivee_laterale',
   value_it = 'zzz_Zulauf_seitlich',
   value_ro = 'admisie_laterala',
   abbr_en = '',
   abbr_de = 'ZS',
   abbr_fr = 'AL',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'intake_from_side',
   display_de = 'Zulauf_seitlich',
   display_fr = 'arrivée latérale',
   display_it = '',
   display_ro = 'admisie laterala'
WHERE code = 2740;

--- Adapt tww_vl.discharge_point_relevance
 INSERT INTO tww_vl.discharge_point_relevance (code, vsacode) VALUES (5580,5580) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.discharge_point_relevance SET
   value_en = 'relevant_for_water_course',
   value_de = 'gewaesserrelevant',
   value_fr = 'pertinent_pour_milieu_recepteur',
   value_it = 'zzz_gewaesserrelevant',
   value_ro = 'relevanta_pentru_mediul_receptor',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Alle  Gewässer-Einleitungen von öffentlichen  und  industriellen  ARA, von Kleinkläranlagen (KLARA) und von öffentlichen Misch- und Regenabwassernetzen sowie Einleitungen von reinen Strassenentwässerungen mit  einer lichten Höhe oder Breite = 30 cm. Als Gewässer im Sinne der Definition gelten alle öffentlichen Gewässer. (Definition und Standardisierung von Kennzahlen für die Abwasserentsorgung, VSA/OKI, 2016).',
   description_de = 'Alle  Gewässer-Einleitungen von öffentlichen  und  industriellen  ARA, von Kleinkläranlagen (KLARA) und von öffentlichen Misch- und Regenabwassernetzen sowie Einleitungen von reinen Strassenentwässerungen mit  einer lichten Höhe oder Breite = 30 cm. Als Gewässer im Sinne der Definition gelten alle öffentlichen Gewässer. (Definition und Standardisierung von Kennzahlen für die Abwasserentsorgung, VSA/OKI, 2016).',
   description_fr = 'Tous les rejets dans les cours et plans d''eaux de STEP publiques et industrielles, de petites STEP (miniSTEP) et de réseaux publiques d''eaux mixtes et pluviales (oder gemäss EN 16323:2014 2.1.1.3: de surface) ainsi que les rejets venant purement de l''évacuation des eaux  de routes avec une hauteur ou largeur maximale du profil >= 30 cm. Comme cours et plans d''eaux sont considérés tous les cours et plans d''eaux publiques. (Définition et standardisation d''indicateurs pour l''assainissement, VSA/OKI, 2016).',
   description_it = 'zzz_Alle  Gewässer-Einleitungen von öffentlichen  und  industriellen  ARA, von Kleinkläranlagen (KLARA) und von öffentlichen Misch- und Regenabwassernetzen sowie Einleitungen von reinen Strassenentwässerungen mit  einer lichten Höhe oder Breite = 30 cm. Als Gewässer im Sinne der Definition gelten alle öffentlichen Gewässer. (Definition und Standardisierung von Kennzahlen für die Abwasserentsorgung, VSA/OKI, 2016).',
   description_ro = 'rrr_Perturba starea sau starea unui curs de apa. Alle  Gewässer-Einleitungen von öffentlichen  und  industriellen  ARA, von Kleinkläranlagen (KLARA) und von öffentlichen Misch- und Regenabwassernetzen sowie Einleitungen von reinen Strassenentwässerungen mit  einer lichten Höhe oder Breite = 30 cm. Als Gewässer im Sinne der Definition gelten alle öffentlichen Gewässer. (Definition und Standardisierung von Kennzahlen für die Abwasserentsorgung, VSA/OKI, 2016).',
   display_en = 'relevant_for_water_course',
   display_de = 'gewaesserrelevant',
   display_fr = 'pertinent pour milieu recepteur',
   display_it = '',
   display_ro = 'relevanta pentru mediul receptor'
WHERE code = 5580;

--- Adapt tww_vl.discharge_point_relevance
 INSERT INTO tww_vl.discharge_point_relevance (code, vsacode) VALUES (5581,5581) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.discharge_point_relevance SET
   value_en = 'non_relevant_for_water_course',
   value_de = 'nicht_gewaesserrelevant',
   value_fr = 'insignifiant_pour_milieu_recepteur',
   value_it = 'zzz_nicht_gewaesserrelevant',
   value_ro = 'nerelevanta_pentru_mediul_receptor',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_All water body discharges that do not meet the criteria listed under "relevant_for_water_course".',
   description_de = 'Alle Gewässer-Einleitungen, die nicht den unter "Einleitstelle_gewaesserrelevant" aufgeführte Kriterien entsprechen.',
   description_fr = 'Tous les rejets dans les cours et plans d''eaux ne correspondant pas aux critères sous "pertinent_pour_milieu_recepteur"',
   description_it = 'zzz_Tutti gli scarichi di acqua che non soddisfano i criteri elencati in "Punto di scarico_acqua_rilevante".',
   description_ro = 'rrr_Nu perturba deloc sau foarte putin starea unui curs de apa. Alle Gewässer-Einleitungen, die nicht den unter "Einleitstelle_gewaesserrelevant" aufgeführte Kriterien entsprechen.',
   display_en = 'non_relevant_for_water_course',
   display_de = 'nicht_gewaesserrelevant',
   display_fr = 'insignifiant pour milieu recepteur',
   display_it = '',
   display_ro = 'nerelevanta pentru mediul receptor'
WHERE code = 5581;

--- Adapt tww_vl.special_structure_amphibian_exit
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode) VALUES (9052,9052) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_amphibian_exit SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 9052;

--- Adapt tww_vl.special_structure_amphibian_exit
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode) VALUES (9053,9053) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_amphibian_exit SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 9053;

--- Adapt tww_vl.special_structure_amphibian_exit
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode) VALUES (9054,9054) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_amphibian_exit SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9054;

--- Adapt tww_vl.special_structure_bypass
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode) VALUES (2682,2682) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_bypass SET
   value_en = 'inexistent',
   value_de = 'nicht_vorhanden',
   value_fr = 'inexistant',
   value_it = 'non_presente',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = 'NV',
   abbr_fr = 'IE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inexistent',
   display_de = 'nicht_vorhanden',
   display_fr = 'inexistant',
   display_it = '',
   display_ro = 'inexistent'
WHERE code = 2682;

--- Adapt tww_vl.special_structure_bypass
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode) VALUES (3055,3055) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_bypass SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3055;

--- Adapt tww_vl.special_structure_bypass
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode) VALUES (2681,2681) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_bypass SET
   value_en = 'existent',
   value_de = 'vorhanden',
   value_fr = 'existant',
   value_it = 'presente',
   value_ro = 'existent',
   abbr_en = '',
   abbr_de = 'V',
   abbr_fr = 'E',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'existent',
   display_de = 'vorhanden',
   display_fr = 'existant',
   display_it = '',
   display_ro = 'existent'
WHERE code = 2681;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (5866,5866) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'altele',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = 'altele'
WHERE code = 5866;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (9075,9075) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'in_water_body',
   value_de = 'in_Gewaesser',
   value_fr = 'dans_cours_d_eau',
   value_it = 'in_corso_d_acqua',
   value_ro = 'in_curs_apa',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   description_de = 'Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   description_fr = 'Connexion directe au cours d''eau (construction non souhaitée). Remplir aussi TROP_PLEIN_DE_SECOURS_EXUTOIRERef pour que le besoin d''intervention soit visible.',
   description_it = 'Collegamento diretto in un ricettore naturale  (costruzione indesiderata). Compilare anche scarico_emergenza_punto_immissione per rendere visibile la necessità d''intervento.',
   description_ro = 'rrr_Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   display_en = 'in_water_body',
   display_de = 'in_Gewaesser',
   display_fr = 'dans cours d''eau',
   display_it = '',
   display_ro = 'in curs appa'
WHERE code = 9075;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (9077,9077) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'in_combined_waste_water_drain',
   value_de = 'in_Mischabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_mixtes',
   value_it = 'in_canalizzazione_acque_miste',
   value_ro = 'in_canalizare_ape_mixte',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Mischwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft',
   description_de = '"in_Mischwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft',
   description_fr = 'L''ouvrage est directement connectée aux canalisations des eaux mixtes sans passer par le terrain',
   description_it = '"in_canalizzazione_acque_miste" significa che il manufatto è direttamente collegato e non passa liberamente sul terreno',
   description_ro = 'rrr_"in_Mischwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft',
   display_en = 'in_combined_waste_water_drain',
   display_de = 'in_Mischabwasserkanalisation',
   display_fr = 'dans canalisation eaux mixtes',
   display_it = '',
   display_ro = ''
WHERE code = 9077;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (9078,9078) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'in_rain_waste_water_drain',
   value_de = 'in_Regenabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_pluviales',
   value_it = 'in_canalizzazione_acque_meteoriche',
   value_ro = 'in_canalizare_apa_meteorica',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Regenabwasserkanalisation" heisst, dass die Versickerung direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft',
   description_de = '"in_Regenabwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft',
   description_fr = 'L''ouvrage est directement connectée aux canalisations des eaux pluviales sans passer par le terrain',
   description_it = '"in_canalizzazione_acque_meteoriche" significa che il manufatto è direttamente collegato e non passa liberamente sul terreno',
   description_ro = 'rrr_"in_Regenabwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft',
   display_en = 'in_rain_waste_water_drain',
   display_de = 'in_Regenabwasserkanalisation',
   display_fr = 'dans canalisation eaux pluviales',
   display_it = '',
   display_ro = ''
WHERE code = 9078;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (9079,9079) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'in_waste_water_drain',
   value_de = 'in_Schmutzabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_usees',
   value_it = 'in_canalizzazione_acque_luride',
   value_ro = 'in_canalizare_apa_uzata',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Schmutzabwasserkanalisation" heisst, dass die Versickerung direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft',
   description_de = '"in_Schmutzabwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft',
   description_fr = 'L''ouvrage est directement connectée aux canalisations des eaux useés sans passer par le terrain',
   description_it = '"in_canalizzazione_acque_luride" significa che il manufatto è direttamente collegato e non passa liberamente sul terreno',
   description_ro = 'rrr_"in_Schmutzabwasserkanalisation" heisst, dass das Bauwerk direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft',
   display_en = 'in_waste_water_drain',
   display_de = 'in_Schmutzabwasserkanalisation',
   display_fr = 'dans canalisation eaux usées',
   display_it = '',
   display_ro = ''
WHERE code = 9079;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (5878,5878) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'niciunul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = 'niciunul'
WHERE code = 5878;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (9076,9076) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'surface_discharge',
   value_de = 'oberflaechlich_ausmuendend',
   value_fr = 'deversement_en_surface',
   value_it = 'con_sbocco_superficiale',
   value_ro = 'deversare_la_suprafata',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Das Wasser überfliesst beim Einstau über das Bauwerk hinaus an die Oberfläche (Hinweis auf verstopfte Anlage).',
   description_de = 'Das Wasser überfliesst beim Einstau über das Bauwerk hinaus an die Oberfläche (Hinweis auf verstopfte Anlage).',
   description_fr = 'L''eau submerge l''ouvrage jusqu''à la surface (indiquant un colmatage)',
   description_it = 'In caso di ristagno l''acqua fluisce in superficie attraverso il manufatto (indice di impianto ostruito).',
   description_ro = 'rrr_Das Wasser überfliesst beim Einstau über das Bauwerk hinaus an die Oberfläche (Hinweis auf verstopfte Anlage).',
   display_en = 'surface_discharge',
   display_de = 'oberflaechlich_ausmuendend',
   display_fr = 'déversement en surface',
   display_it = '',
   display_ro = 'deversare la suprafata'
WHERE code = 9076;

--- Adapt tww_vl.special_structure_emergency_overflow
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode) VALUES (5867,5867) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_emergency_overflow SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5867;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (6397,6397) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'pit_without_drain',
   value_de = 'abflussloseGrube',
   value_fr = 'fosse_etanche',
   value_it = 'fossa_senza_scarico',
   value_ro = 'bazin_vidanjabil',
   abbr_en = '',
   abbr_de = 'AG',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'pit without drain',
   description_de = 'Abflusslose Grube',
   description_fr = 'Fosse étanche',
   description_it = 'Fossa senza scarico',
   description_ro = 'bazin vidanjabil',
   display_en = 'pit_without_drain',
   display_de = 'abflussloseGrube',
   display_fr = 'Fosse étanche',
   display_it = '',
   display_ro = 'bazin vidanjabil'
WHERE code = 6397;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (245,245) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'drop_structure',
   value_de = 'Absturzbauwerk',
   value_fr = 'ouvrage_de_chute',
   value_it = 'manufatto_caduta',
   value_ro = 'instalatie_picurare',
   abbr_en = 'DS',
   abbr_de = 'AK',
   abbr_fr = 'OC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_de = 'Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_fr = 'Ouvrage spécial dans le réseau de canalisations servant à relier des différences d''altitude sur une petite distance, en brisant l''énergie de l''écoulement.',
   description_it = 'zzz_Ein Absturzschacht ist ein spezielles Bauwerk im Kanalisationsnetz zur Überwindung von Höhenunterschieden auf kurze Entfernung bei gleichzeitiger Energieumwandlung',
   description_ro = 'Structura speciala în re?eaua de canalizare care serveste la normalizarea diferen?elor de altitudine pe o distan?a mica, la ruperea de energie a debitului.',
   display_en = 'drop_structure',
   display_de = 'Absturzbauwerk',
   display_fr = 'ouvrage de chute',
   display_it = '',
   display_ro = 'instalatie picurare'
WHERE code = 245;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (6398,6398) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'hydrolizing_tank',
   value_de = 'Abwasserfaulraum',
   value_fr = 'fosse_digestive',
   value_it = 'camera_fermentazione',
   value_ro = 'fosa_hidroliza',
   abbr_en = '',
   abbr_de = 'AF',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Hydrolizing tank with 3 chambers (also called privy tank)',
   description_de = 'Abwasserfaulraum: 3 Kammern',
   description_fr = 'Fosse digestive: 3 compartiments',
   description_it = 'Camera di fermentazione: 3 camere',
   description_ro = 'fosa hidroliza cu 3 compartimente',
   display_en = 'hydrolizing_tank',
   display_de = 'Abwasserfaulraum',
   display_fr = 'Fosse digestive',
   display_it = '',
   display_ro = 'fosa hidroliza'
WHERE code = 6398;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5371,5371) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Nur verwenden, wenn kein anderer Wert zutrifft. Die Funktion des Bauwerkes im Feld Bemerkung beschreiben',
   description_de = 'Nur verwenden, wenn kein anderer Wert zutrifft. Die Funktion des Bauwerkes im Feld Bemerkung beschreiben',
   description_fr = 'Seulement à utiliser s''il n''y a pas de valeur existante. Ajouter la fonction détaillée dans commentaire',
   description_it = 'zzz_Nur verwenden, wenn kein anderer Wert zutrifft. Die Funktion des Bauwerkes im Feld Bemerkung beschreiben',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5371;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (386,386) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'venting',
   value_de = 'Be_Entlueftung',
   value_fr = 'aeration',
   value_it = 'zzz_Be_Entlueftung',
   value_ro = 'aerisire',
   abbr_en = 'VE',
   abbr_de = 'BE',
   abbr_fr = 'AE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_de = 'Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_fr = 'Installation permettant une aération dans un ouvrage d''assainissement',
   description_it = 'zzz_Vorrichtung zum gewünschten Luftaustausch in Abwasserbauwerken',
   description_ro = '',
   display_en = 'venting',
   display_de = 'Be_Entlueftung',
   display_fr = 'aeration',
   display_it = '',
   display_ro = 'aerisire'
WHERE code = 386;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (8704,8704) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'treatment_plant',
   value_de = 'Behandlungsanlage',
   value_fr = 'installation_traitement',
   value_it = 'installazione_di_trattamento',
   value_ro = 'rrr_Behandlungsanlage',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   description_de = 'Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   description_fr = 'Installation de traitement des eaux de chaussée (SETEC) ou des eaux pluviales issues des biens-fonds, telle que filtres en terre, en gravillon, en sable ou techniques et adsorbeurs artificiels. Réalisation concrète comme cuvette, chambre (standard), ouvrage spécial/bassin ou installation technique. Les chambres et bassins de décantation (= dépotoirs ou BEP clarification) ne sont pas considérés à ce titre comme des installations de traitement. Des valeurs d’attribut distinctes sont disponibles pour ces installations de traitement.',
   description_it = 'Impianto per il trattamento delle acque di scarico stradali (SABA) o delle acque meteoriche da zone edificate come filtri in terreno vegetale, filtri split, filtri a sabbia o filtri tecnici e adsorber artificiali. Realizzazioni di trincee superficiali, pozzetto d''ispezione, di manufatti speciali/bacino o impianto tecnico. Bacini di decantazione (=raccoglitori di fanghi o bacini di chiarificazione) non sono qui considerati impianti di trattamento; per questi sono previsti attributi specifici.',
   description_ro = 'rrr_Anlage zur weitergehenden Behandlung von Strassenabwasser (SABA) oder Regenabwasser aus dem Liegenschaftsbereich wie Boden-, Splitt-, Sand- oder technische Filter und künstliche Adsorber. Bauliche Ausprägung als Mulde, (Norm-)Schacht, Spezialbauwerk/Becken oder technische Anlage. Reine Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Behandlungsanlagen, für sie sind separate Attribut-Werte vorhanden.',
   display_en = 'treatment_plant',
   display_de = 'Behandlungsanlage',
   display_fr = 'installation traitement',
   display_it = '',
   display_ro = ''
WHERE code = 8704;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3234,3234) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'inverse_syphon_chamber',
   value_de = 'Duekerkammer',
   value_fr = 'chambre_avec_siphon_inverse',
   value_it = 'camera_sifone',
   value_ro = 'instalatie_cu_sifon_inversat',
   abbr_en = 'ISC',
   abbr_de = 'DK',
   abbr_fr = 'SI',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezialbauwerk bei einem Abwasserdüker zur Entleerung der Leitungen am tiefsten Punkt',
   description_de = 'Spezialbauwerk bei einem Abwasserdüker zur Entleerung der Leitungen am tiefsten Punkt',
   description_fr = 'Ouvrage spécial servant à purger le siphon inverse au point le plus bas.',
   description_it = 'zzz_Spezialbauwerk bei einem Abwasserdüker zur Entleerung der Leitungen am tiefsten Punkt',
   description_ro = 'Instalatie speciala ce serveste la purjarea sifonul inversat in punctul cel mai de jos',
   display_en = 'inverse_syphon_chamber',
   display_de = 'Duekerkammer',
   display_fr = 'chambre avec siphon inverse',
   display_it = '',
   display_ro = 'instalatie cu sifon inversat'
WHERE code = 3234;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5091,5091) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'syphon_head',
   value_de = 'Duekeroberhaupt',
   value_fr = 'entree_de_siphon',
   value_it = 'zzz_Duekeroberhaupt',
   value_ro = 'cap_sifon',
   abbr_en = 'SH',
   abbr_de = 'DO',
   abbr_fr = 'ESI',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bauwerk zur Aufteilung des Abflusses auf mehrere Dükerrohre',
   description_de = 'Bauwerk zur Aufteilung des Abflusses auf mehrere Dükerrohre',
   description_fr = 'Ouvrage d’entrée d''un siphon inversé pour répartir le débit sur plusieurs tuyaux.',
   description_it = 'zzz_Bauwerk zur Aufteilung des Abflusses auf mehrere Dükerrohre',
   description_ro = 'Cap sifon inversat pentru a distribui fluxul la mai multe conducte.',
   display_en = 'syphon_head',
   display_de = 'Duekeroberhaupt',
   display_fr = 'entré de siphon',
   display_it = '',
   display_ro = 'cap sifon'
WHERE code = 5091;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (6399,6399) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'septic_tank_two_chambers',
   value_de = 'Faulgrube',
   value_fr = 'fosse_septique_2_compartiments',
   value_it = 'zzz_Faulgrube',
   value_ro = 'fosa_septica_2_compartimente',
   abbr_en = '',
   abbr_de = 'FG',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Septic tank: 2 chamber',
   description_de = 'Faulgrube: 2 Kammern',
   description_fr = 'Fosse septique: 2 compartiments',
   description_it = 'Fossa di fermentazione: 2 camere',
   description_ro = 'Fosa septica 2 compartimente',
   display_en = 'septic_tank_two_chambers',
   display_de = 'Faulgrube',
   display_fr = 'fosse septique',
   display_it = '',
   display_ro = 'fosa septica 2 compartimente'
WHERE code = 6399;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (8600,8600) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'grease_separator',
   value_de = 'Fettabscheider',
   value_fr = 'separateur_de_graisse',
   value_it = 'separatore_di_grasso',
   value_ro = 'rrr_Fettabscheider',
   abbr_en = '',
   abbr_de = 'FA',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Separation plant for animal and vegetable fats and oils. [SN 592 000:2012]',
   description_de = 'Abscheideanlage für tierische und pflanzliche Fette und Öle. (SN 592 000:2012)',
   description_fr = 'Séparateur pour les graisses et huiles d''origine animale et végétale . (SN 592 000:2012)',
   description_it = 'Impianto di separazione per grassi e oli animali e vegetali (SN 592 000:2012)',
   description_ro = 'rrr_Abscheideanlage für tierische und pflanzliche Fette und Öle. (SN 592 000:2012)',
   display_en = 'grease_separator',
   display_de = 'Fettabscheider',
   display_fr = 'séparateur de graisse',
   display_it = '',
   display_ro = ''
WHERE code = 8600;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3348,3348) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'terrain_depression',
   value_de = 'Gelaendemulde',
   value_fr = 'depression_de_terrain',
   value_it = 'zzz_Gelaendemulde',
   value_ro = 'depresiune_teren',
   abbr_en = '',
   abbr_de = 'GM',
   abbr_fr = 'DT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Natürliche oder künstliche Vertiefung im Boden, um abfliessendes Wasser zurückzuhalten',
   description_de = 'Natürliche oder künstliche Vertiefung im Boden, um abfliessendes Wasser zurückzuhalten',
   description_fr = 'Dépression de terrain artificielle ou naturelle ayant une fonction de rétention',
   description_it = 'zzz_Natürliche oder künstliche Vertiefung im Boden, um abfliessendes Wasser zurückzuhalten',
   description_ro = 'Depresiune de teren artificiala sau naturala, cu func?ie de retentie',
   display_en = 'terrain_depression',
   display_de = 'Gelaendemulde',
   display_fr = 'dépression de terrain',
   display_it = '',
   display_ro = 'depresiune teren'
WHERE code = 3348;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (336,336) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'bedload_trap',
   value_de = 'Geschiebefang',
   value_fr = 'depotoir_pour_alluvions',
   value_it = 'camera_ritenuta',
   value_ro = 'colector_aluviuni',
   abbr_en = '',
   abbr_de = 'GF',
   abbr_fr = 'DA',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezialbauwerk zur Aufnahme von im Wasser mitgeführten Material. Häufig am Übergang zu einem eingedolten Abschnitt',
   description_de = 'Spezialbauwerk zur Aufnahme von im Wasser mitgeführten Material. Häufig am Übergang zu einem eingedolten Abschnitt',
   description_fr = 'Ouvrage spécial dans un cours d''eau ouvert, servant à récolter les matériaux transportés. Se trouve souvent à l''entrée des tronçons mis sous terre.',
   description_it = 'zzz_Spezialbauwerk zur Aufnahme von im Wasser mitgeführten Material. Häufig am Übergang zu einem eingedolten Abschnitt',
   description_ro = 'Teren special, pentru recoltarea materialele transportate. Deseori, situat la intrarea în tronsoane amplasate subteran',
   display_en = 'bedload_trap',
   display_de = 'Geschiebefang',
   display_fr = 'dépotoir pour alluvions',
   display_it = '',
   display_ro = 'colector aluviuni'
WHERE code = 336;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5494,5494) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'cesspit',
   value_de = 'Guellegrube',
   value_fr = 'fosse_a_purin',
   value_it = 'fossa_liquame',
   value_ro = 'hazna',
   abbr_en = '',
   abbr_de = 'JG',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gülle- bzw. Jauchegrube',
   description_de = 'Gülle- bzw. Jauchegrube',
   description_fr = 'Fosse à purin',
   description_it = 'Fossa per liquame',
   description_ro = 'hazna sau latrina',
   display_en = 'cesspit',
   display_de = 'Guellegrube',
   display_fr = 'Fosse à purin',
   display_it = '',
   display_ro = 'hazna'
WHERE code = 5494;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (8657,8657) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'emergency_basin',
   value_de = 'Havariebecken',
   value_fr = 'bassin_d_avarie',
   value_it = 'bacino_avaria',
   value_ro = 'rrr_Havariebecken',
   abbr_en = '',
   abbr_de = 'HB',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Becken zum Auffangen von wassergefährdenden Stoffen bei einem Unfall oder Störfall.',
   description_de = 'Becken zum Auffangen von wassergefährdenden Stoffen bei einem Unfall oder Störfall.',
   description_fr = 'Bassin destiné à recueillir les substances de nature à polluer les eaux en cas d''accident ou d''accident majeur.',
   description_it = 'zzz_Bacino per la raccolta di sostanze pericolose per l''acqua in caso di incidente.',
   description_ro = 'rrr_Becken zum Auffangen von wassergefährdenden Stoffen bei einem Unfall oder Störfall.',
   display_en = 'emergency_basin',
   display_de = 'Havariebecken',
   display_fr = 'bassin d''avarie',
   display_it = 'bacino_avaria',
   display_ro = ''
WHERE code = 8657;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (6478,6478) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'septic_tank',
   value_de = 'Klaergrube',
   value_fr = 'fosse_septique',
   value_it = 'fossa_settica',
   value_ro = 'fosa_septica',
   abbr_en = '',
   abbr_de = 'KG',
   abbr_fr = 'FD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Eine Klärgrube (1 Kammer) dient der Entwässerung einer Liegenschaft, die nicht an die öffentliche Kanalisation angeschlossen ist. Eine Klärgrube ist üblicherweise ein beckenartiges, unterirdisches Bauwerk, in dem sich die festen Stoffe am Boden absetzen, Klärgruben müssen periodisch geleert werden.',
   description_de = 'Eine Klärgrube (1 Kammer) dient der Entwässerung einer Liegenschaft, die nicht an die öffentliche Kanalisation angeschlossen ist. Eine Klärgrube ist üblicherweise ein beckenartiges, unterirdisches Bauwerk, in dem sich die festen Stoffe am Boden absetzen, Klärgruben müssen periodisch geleert werden.',
   description_fr = 'Appareil destiné à la collecte, à la liquéfaction partielle des matières polluantes contenues dans les eaux usées et à la rétention des matières solides et des déchets flottants. Il est souvent utilisé pour des bâtiments qui ne sont pas raccordés à un réseau d’égouts aboutissant à un traitement (1 chambre)',
   description_it = 'Una fossa settica serve allo smaltimento acque di singoli edifici non allacciati alla rete di canalizzazione. Si tratta normalmente di una vasca sotterranea in cui sul fondo sedimantano le parti solide. Deve essere vuotato a intervalli regolari.',
   description_ro = 'rrr_Eine Klärgrube (1 Kammer) dient der Entwässerung einer Liegenschaft, die nicht an die öffentliche Kanalisation angeschlossen ist. Eine Klärgrube ist üblicherweise ein beckenartiges, unterirdisches Bauwerk, in dem sich die festen Stoffe am Boden absetzen, Klärgruben müssen periodisch geleert werden.',
   display_en = 'septic_tank',
   display_de = 'Klaergrube',
   display_fr = 'fosse septique',
   display_it = '',
   display_ro = 'fosa septica'
WHERE code = 6478;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (9302,9302) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'combined_manhole',
   value_de = 'Kombischacht',
   value_fr = 'chambre_combine',
   value_it = 'pozzetto_doppio',
   value_ro = 'rrr_Kombischacht',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Shared manhole for two parallel wastewater lines, usually a wastewater pipe and a stormwater pipe.',
   description_de = 'Gemeinsamer Kontroll_Einsteigschacht für zwei parallel verlaufende Abwasserleitungen, meist eine Schmutz- und eine Regenabwasserleitung.',
   description_fr = 'chambre_de_visite_ou_d_inspection commmune pour deux conduites d''assainissement en parallèle, typiquement une conduite d''eaux usées et une conduite d''eaux de surface',
   description_it = 'Pozzetto di ispezione congiunto per due condotte parallele per acque di scarico, in genere una condotta per acque luride e una condotta per acque meteoriche',
   description_ro = 'rrr_Gemeinsamer Kontroll_Einsteigschacht für zwei parallel verlaufende Abwasserleitungen, meist eine Schmutz- und eine Regenabwasserleitung.',
   display_en = 'combined_manhole',
   display_de = 'Kombischacht',
   display_fr = 'chambre combine',
   display_it = '',
   display_ro = ''
WHERE code = 9302;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (8739,8739) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'manhole',
   value_de = 'Kontroll_Einsteigschacht',
   value_fr = 'chambre_de_visite_ou_d_inspection',
   value_it = 'pozzetto_di_ispezione',
   value_ro = 'rrr_Kontroll_Einsteigschacht',
   abbr_en = '',
   abbr_de = 'KS',
   abbr_fr = 'RV',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Manhole or inspection chamber for maintenance and inspection purposes (definition according to SIA 190.301 / EN 16323:2014)',
   description_de = 'Einsteig- oder Kontrollschacht für Unterhalts- und Kontrollzwecke (Definition gemäss SIA 190.301 / EN 16323:2014)',
   description_fr = 'Chambre de visite ou boîte de branchement/d''inspection pour entretenir et inspecter les canalisations (définitions selon SIA 190.301 = EN 16323:2014)',
   description_it = 'zzz_Pozzetto di accesso o di controllo a scopo di manutenzione e controllo (definizione secondo SIA 190.301 / EN 16323:2014)',
   description_ro = 'rrr_Einsteig- oder Kontrollschacht für Unterhalts- und Kontrollzwecke (Definition gemäss SIA 190.301 / EN 16323:2014)',
   display_en = 'manhole',
   display_de = 'Kontroll_Einsteigschacht',
   display_fr = 'chambre de visite ou d''inspection',
   display_it = '',
   display_ro = ''
WHERE code = 8739;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (2768,2768) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'oil_separator',
   value_de = 'Oelabscheider',
   value_fr = 'separateur_d_hydrocarbures',
   value_it = 'separatore_olii',
   value_ro = 'separator_hidrocarburi',
   abbr_en = '',
   abbr_de = 'OA',
   abbr_fr = 'SH',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abscheideanlage für mineralische Leichtflüssigkeiten, evtl. mit Koaleszenzstufe und/oder selbsttätigem Abschluss (SN 592 000:2012)',
   description_de = 'Abscheideanlage für mineralische Leichtflüssigkeiten, evtl. mit Koaleszenzstufe und/oder selbsttätigem Abschluss (SN 592 000:2012)',
   description_fr = 'Ouvrage servant à séparer des liquides minéraux légers de l''eau, év. par coalescence et/ou avec fermeture automatique (SN 592''000)',
   description_it = 'mpianto per la separazione di liquidi leggeri minerali, ev. con filtro a coalescenza e/o chiusura automatica (SN 592 000:2012)',
   description_ro = 'rrr_Structura speciala pentru separarea fluidelor u?oare de apa. Acesta previne patrunderea uleiurilor in mediile receptoare.',
   display_en = 'oil_separator',
   display_de = 'Oelabscheider',
   display_fr = 'séparateur d''hydrocarbures',
   display_it = '',
   display_ro = 'separator hidrocarburi'
WHERE code = 2768;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (246,246) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'pump_station',
   value_de = 'Pumpwerk',
   value_fr = 'station_de_pompage',
   value_it = 'stazione_pompaggio',
   value_ro = 'statie_pompare',
   abbr_en = '',
   abbr_de = 'PW',
   abbr_fr = 'SP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_de = 'Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_fr = 'Installation destinée à élever les eaux d''un niveau à un autre, soit pour le franchissement d''un obstacle, soit pour modifier des tracés devenus économiquement inacceptables en réseau gravitaire',
   description_it = 'zzz_Anlage zum Heben von Abwasser innerhalb eines Kanalnetzes',
   description_ro = '',
   display_en = 'pump_station',
   display_de = 'Pumpwerk',
   display_fr = 'station de pompage',
   display_it = '',
   display_ro = 'statie pompare'
WHERE code = 246;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3673,3673) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_tank_with_overflow',
   value_de = 'Regenbecken_Durchlaufbecken',
   value_fr = 'BEP_decantation',
   value_it = 'bacino_chiarificazione',
   value_ro = 'bazin_retentie_apa_meteorica_cu_preaplin',
   abbr_en = '',
   abbr_de = 'DB',
   abbr_fr = 'BDE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bauwerk in Mischabwassernetzen zur Absetzung von partikulären Stoffen und zur Speicherung von Mischabwasser (Sekundärwirkung, es können nur kleine Regenmengen gespeichert werden).',
   description_de = 'Bauwerk in Mischabwassernetzen zur Absetzung von partikulären Stoffen und zur Speicherung von Mischabwasser (Sekundärwirkung, es können nur kleine Regenmengen gespeichert werden)',
   description_fr = 'Ouvrage de réseau d’eaux mixtes pour la décantation de matières solides et le stockage d’eaux mixtes (fonction secondaire, pour le stockage de volumes d’eau pluviale minimes).',
   description_it = 'zzz_Bauwerk in Mischabwassernetzen zur Absetzung von partikulären Stoffen und zur Speicherung von Mischabwasser (Sekundärwirkung, es können nur kleine Regenmengen gespeichert werden)',
   description_ro = 'Instalatie de retea de ape mixte ce serveste la decantarea solidelor ?i stocarea apelor mixte (ca func?ie secundara are stocarea de ape pluviale minime).',
   display_en = 'stormwater_tank_with_overflow',
   display_de = 'Regenbecken_Durchlaufbecken',
   display_fr = 'bassin de décantation',
   display_it = 'bacino_chiarificazione',
   display_ro = 'bazin retentie apa meteorica cu preaplin'
WHERE code = 3673;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3674,3674) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_tank_retaining_first_flush',
   value_de = 'Regenbecken_Fangbecken',
   value_fr = 'BEP_retention',
   value_it = 'bacino_accumulo',
   value_ro = 'bazin_retentie_apa_meteorica_prima_spalare',
   abbr_en = '',
   abbr_de = 'FB',
   abbr_fr = 'BRE',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Stormwater tank retaining the first flush',
   description_de = 'Regenüberlaufbecken, dass zum Fangen des ersten Schmutzstosses dient',
   description_fr = 'Bassin d''eau pluviale ayant comme fonction la rétention du premier flot d’orage (first flush)',
   description_it = 'zzz_Regenüberlaufbecken, dass zum Fangen des ersten Schmutzstosses dient',
   description_ro = 'Bazin retetie apa meteorica care are ca functie retentiei primului val/primei spalari',
   display_en = 'stormwater_tank_retaining_first_flush',
   display_de = 'Regenbecken_Fangbecken',
   display_fr = 'bassin de rétention',
   display_it = 'bacino_accumulo',
   display_ro = 'bazin retentie apa meteorica prima spalare'
WHERE code = 3674;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5574,5574) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_retaining_channel',
   value_de = 'Regenbecken_Fangkanal',
   value_fr = 'BEP_canal_retention',
   value_it = 'canale_accumulo',
   value_ro = 'bazin_retentie',
   abbr_en = 'TRE',
   abbr_de = 'FK',
   abbr_fr = 'BCR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Storage channel with downstream overflow into water course',
   description_de = 'Speicherleitung mit oberhalb liegendem Überlauf ins Gewässer',
   description_fr = 'Canalisation de rétention avec déversement en amont dans un cours d''eau',
   description_it = 'zzz_Speicherleitung mit oberhalb liegendem Überlauf ins Gewässer',
   description_ro = 'Canalizare de retentie cu deversare la aval intr-un curs de apa',
   display_en = 'stormwater_retaining_channel',
   display_de = 'Regenbecken_Fangkanal',
   display_fr = 'bassin canal de rétention',
   display_it = '',
   display_ro = 'bazin retentie'
WHERE code = 5574;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3675,3675) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_sedimentation_tank',
   value_de = 'Regenbecken_Regenklaerbecken',
   value_fr = 'BEP_clarification',
   value_it = 'bacino_decantazione_acque_meteoriche',
   value_ro = 'bazin_decantare',
   abbr_en = '',
   abbr_de = 'RKB',
   abbr_fr = 'BCL',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Absetzbecken für Regenabwasser im Trennsystem. Auch zu verwenden für Lammellenklärer, jedoch nicht für Becken mit weitergehenden Reinigungsstufen (Boden-/Sandfilter, Adsorber, etc.) --> Behandlungsanlage',
   description_de = 'Absetzbecken für Regenabwasser im Trennsystem. Auch zu verwenden für Lammellenklärer, jedoch nicht für Becken mit weitergehenden Reinigungsstufen (Boden-/Sandfilter, Adsorber, etc.) --> Behandlungsanlage',
   description_fr = 'Bassin d’eaux pluviales de décantation dans un système séparatif. Peut également être utilisé pour les clarificateurs à lamelles, mais pas pour les réservoirs avec des étapes de nettoyage supplémentaires (filtres à sol/sable, adsorbeurs, etc.) --> installation_traitement',
   description_it = 'zzz_Absetzbecken für Regenabwasser im Trennsystem. Auch zu verwenden für Lammellenklärer, jedoch nicht für Becken mit weitergehenden Reinigungsstufen (Boden-/Sandfilter, Adsorber, etc.) --> Behandlungsanlage',
   description_ro = 'rrr_Bazin de decantare a apelor meteorice într-un sistem de separare. Auch zu verwenden für Lammellenklärer, jedoch nicht für Becken mit weitergehenden Reinigungsstufen (Boden-/Sandfilter, Adsorber, etc.) --> Behandlungsanlage',
   display_en = 'stormwater_sedimentation_tank',
   display_de = 'Regenbecken_Regenklaerbecken',
   display_fr = 'bassin de clarification',
   display_it = 'bacino_decantazione_acque_meteoriche',
   display_ro = 'bazin decantare'
WHERE code = 3675;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3676,3676) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_retention_tank',
   value_de = 'Regenbecken_Regenrueckhaltebecken',
   value_fr = 'BEP_accumulation',
   value_it = 'bacino_ritenzione',
   value_ro = 'bazin_retentie_apa_meteorica',
   abbr_en = '',
   abbr_de = 'RRB',
   abbr_fr = 'BAC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Speicherraum für Regenabflussspitzen im Misch- oder Regenabwassernetz. Er dient der Entlastung der Kanalisation bei starkem Regen und hat im Gegensatz zu Regenüberlaufbecken keinen Überlauf oder nur einen Notüberlauf zum Gewässer',
   description_de = 'Speicherraum für Regenabflussspitzen im Misch- oder Regenabwassernetz. Er dient der Entlastung der Kanalisation bei starkem Regen und hat im Gegensatz zu Regenüberlaufbecken keinen Überlauf oder nur einen Notüberlauf zum Gewässer',
   description_fr = 'Bassin d''accumulation de débits de pointe dans un réseau d’eaux mixtes ou pluviales. Sa fonction est de décharger le réseau lors d’orages et n’a, contrairement au déversoir d’orage aucun déversement, mise à part un trop-plein vers un exutoire en milieu récepteur',
   description_it = 'zzz_Speicherraum für Regenabflussspitzen im Misch- oder Regenabwassernetz. Er dient der Entlastung der Kanalisation bei starkem Regen und hat im Gegensatz zu Regenüberlaufbecken keinen Überlauf oder nur einen Notüberlauf zum Gewässer',
   description_ro = 'Structura de stocare pentru debitele meteorice mari din sistemele pluviale sau mixte',
   display_en = 'stormwater_retention_tank',
   display_de = 'Regenbecken_Regenrueckhaltebecken',
   display_fr = 'bassin d''accumulation',
   display_it = 'bacino_ritenzione',
   display_ro = 'bazin retentie apa meteorica'
WHERE code = 3676;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5575,5575) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_retention_channel',
   value_de = 'Regenbecken_Regenrueckhaltekanal',
   value_fr = 'BEP_canal_accumulation',
   value_it = 'canale_ritenzione',
   value_ro = 'canal_retentie_apa_meteorica',
   abbr_en = 'TRC',
   abbr_de = 'RRK',
   abbr_fr = 'BCA',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Retention channel with similar function as stormwater retention tank',
   description_de = 'Speicherkanal mit der gleichen Funktionsweise wie das Regenrückhaltebecken',
   description_fr = 'Canalisation de stockage avec mode de fonctionnement identique que la bassin d''accumulation.',
   description_it = 'zzz_Speicherkanal mit der gleichen Funktionsweise wie das Regenrückhaltebecken',
   description_ro = 'Canalizare de stocare cu acela?i mod de operare ca bazinul de stocare apa meteorica',
   display_en = 'stormwater_retention_channel',
   display_de = 'Regenbecken_Regenrueckhaltekanal',
   display_fr = 'bassin canal d''accumulation',
   display_it = '',
   display_ro = 'canal retentie apa meteorica'
WHERE code = 5575;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5576,5576) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_storage_channel',
   value_de = 'Regenbecken_Stauraumkanal',
   value_fr = 'BEP_canal_stockage',
   value_it = 'canale_stoccaggio',
   value_ro = 'bazin_stocare',
   abbr_en = 'TSC',
   abbr_de = 'SRK',
   abbr_fr = 'BCS',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Storage channel wie upstream overflow into water course',
   description_de = 'Speicherleitung mit unterhalb liegendem Überlauf ins Gewässer',
   description_fr = 'Canalisation de stockage avec déversement en aval dans un cours d''eau',
   description_it = 'zzz_Speicherleitung mit unterhalb liegendem Überlauf ins Gewässer',
   description_ro = 'Canalizare de stocare cu deversare la aval intr-un curs de apa',
   display_en = 'stormwater_storage_channel',
   display_de = 'Regenbecken_Stauraumkanal',
   display_fr = 'bassin canal de stockage',
   display_it = '',
   display_ro = 'bazin stocare'
WHERE code = 5576;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3677,3677) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_composite_tank',
   value_de = 'Regenbecken_Verbundbecken',
   value_fr = 'BEP_combine',
   value_it = 'bacino_combinato',
   value_ro = 'rrr_Regenbecken_Verbundbecken',
   abbr_en = '',
   abbr_de = 'VB',
   abbr_fr = 'BCO',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kombination von Fangbecken und Klärbecken',
   description_de = 'Kombination von Fangbecken und Klärbecken',
   description_fr = 'Bassin d''eau pluviale réunissant la rétention et la clarification',
   description_it = 'zzz_Kombination von Fangbecken und Klärbecken',
   description_ro = '',
   display_en = 'stormwater_composite_tank',
   display_de = 'Regenbecken_Verbundbecken',
   display_fr = 'bassin combiné',
   display_it = 'bacino_combinato',
   display_ro = ''
WHERE code = 3677;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5372,5372) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'stormwater_overflow',
   value_de = 'Regenueberlauf',
   value_fr = 'deversoir_d_orage',
   value_it = 'scaricatore_piena',
   value_ro = 'preaplin',
   abbr_en = '',
   abbr_de = 'RU',
   abbr_fr = 'DO',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_de = 'Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_fr = 'Ouvrage spécial, séparant les eaux mixtes en y rejetant une partie directement dans un cours d’eau',
   description_it = 'zzz_Sonderbauwerk, welches Mischabwasser auftrennt und einen Teil davon direkt dem Gewaesser zuführt.',
   description_ro = 'Structura speciala, care separa apele mixte prin deversarea unei cantitati direct in cursurile de apa.',
   display_en = 'stormwater_overflow',
   display_de = 'Regenueberlauf',
   display_fr = 'dévérsoir d''orage',
   display_it = '',
   display_ro = 'preaplin'
WHERE code = 5372;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (5373,5373) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'floating_material_separator',
   value_de = 'Schwimmstoffabscheider',
   value_fr = 'separateur_de_materiaux_flottants',
   value_it = 'separatore_materiali_galleggianti',
   value_ro = 'separator_materie_flotanta',
   abbr_en = '',
   abbr_de = 'SW',
   abbr_fr = 'SMF',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ein Schwimmstoffabscheider ist ein Schlammsammler mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_de = 'Ein Schwimmstoffabscheider ist ein Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_fr = 'Dépotoir contenant soit un siphon prolongé ou une paroi plongeante. Tient le rôle de prétraitement sur une installation d''infiltration',
   description_it = 'zzz_Ein Schwimmstoffabscheider ist ein Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   description_ro = 'rrr_Ein Schwimmstoffabscheider ist ein Schlammsammler entweder mit einem verlängerten Tauchbogen oder einer Tauchwand. Wird insbesondere bei Versickerungsanlagen als Vorbehandlung gebraucht',
   display_en = 'floating_material_separator',
   display_de = 'Schwimmstoffabscheider',
   display_fr = 'séparateur de matériaux flottants',
   display_it = '',
   display_ro = 'separator materie flotanta'
WHERE code = 5373;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (383,383) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'side_access',
   value_de = 'seitlicherZugang',
   value_fr = 'acces_lateral',
   value_it = 'accesso_laterale',
   value_ro = 'acces_lateral',
   abbr_en = '',
   abbr_de = 'SZ',
   abbr_fr = 'AL',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ebenerdiger Zugang zu einem Bauwerk',
   description_de = 'Ebenerdiger Zugang zu einem Bauwerk',
   description_fr = 'Accès à un ouvrage sans descente ou montée',
   description_it = 'zzz_Ebenerdiger Zugang zu einem Bauwerk',
   description_ro = 'Acces fara coborare sau urcare/scari',
   display_en = 'side_access',
   display_de = 'seitlicherZugang',
   display_fr = 'accès latéral',
   display_it = '',
   display_ro = 'acces lateral'
WHERE code = 383;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (227,227) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'jetting_manhole',
   value_de = 'Spuelschacht',
   value_fr = 'chambre_de_chasse',
   value_it = 'pozzetto_lavaggio',
   value_ro = 'camin_spalare',
   abbr_en = '',
   abbr_de = 'SS',
   abbr_fr = 'CC',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schacht, der zu Spülzwecken benötigt wird',
   description_de = 'Schacht, der zu Spülzwecken benötigt wird',
   description_fr = 'Chambre servant d''accès spécifiquement pour le rinçage',
   description_it = 'zzz_Schacht, der zu Spülzwecken benötigt wird',
   description_ro = 'Camera acces special pentru spalare',
   display_en = 'jetting_manhole',
   display_de = 'Spuelschacht',
   display_fr = 'chambre de chasse',
   display_it = '',
   display_ro = 'camin spalare'
WHERE code = 227;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (4799,4799) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'separating_structure',
   value_de = 'Trennbauwerk',
   value_fr = 'ouvrage_de_repartition',
   value_it = 'camera_ripartizione',
   value_ro = 'separator',
   abbr_en = '',
   abbr_de = 'TS',
   abbr_fr = 'OR',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Building that separates wastewater in the system but does not discharge it from the system. Exception: In front of a catch basin or catch channel, mixed wastewater is discharged into the watercourse via the separation structure after filling the basin volume. One or more inlets, two or more outlets.',
   description_de = 'Bauwerk, welches Abwasser im System auftrennt, aber nicht aus dem System entlastet. Ausnahme: Vor einem Fangbecken oder Fangkanal wird nach Füllung des Beckenvolumens Mischabwasser über das Trennbauwerk ins Gewässer entlastet. Ein oder mehrere Zuläufe, zwei oder mehr Abläufe.',
   description_fr = 'Ouvrage, qui répartit les eaux dans le système sans les déverser. Exception: avant un bassin ou un canal de stockage, les eaux mixtes sont déversées dans le cours ou plan d''eau via l''ouvrage de répartition après remplissage du volume du bassin. Une ou plusieurs entrées, deux ou plusieurs sorties.',
   description_it = 'Manufatto che suddivide le acque reflue nel sistema ma senza scaricarle. Eccezione: prima di un bacino di accumulo in parallelo, dopo riempimento del volume del bacino, le acque miste vengono scaricate nel ricettore naturale attraverso la camera di ripartizione. Uno o più entrate, due o più scarichi.',
   description_ro = 'rrr_structura speciala care repartizeaza apele in sistem fara a le deversa. Rrr_ Ausnahme: Vor einem Fangbecken oder Fangkanal wird nach Füllung des Beckenvolumens Mischabwasser über das Trennbauwerk ins Gewässer entlastet. Are una sau mai multe intrari, doua sau mai multe iesiri.',
   display_en = 'separating_structure',
   display_de = 'Trennbauwerk',
   display_fr = 'chambre de répartition',
   display_it = '',
   display_ro = 'separator'
WHERE code = 4799;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (3008,3008) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 3008;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (9089,9089) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'pretreatment_plant',
   value_de = 'Vorbehandlungsanlage',
   value_fr = 'installation_de_pretraitement',
   value_it = 'zzz_Vorbehandlungsanlage',
   value_ro = 'rrr_Vorbehandlungsanlage',
   abbr_en = '',
   abbr_de = 'VH',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_de = 'Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_fr = 'Installation destinée au prétraitement des eaux usées industrielles ou artisanales avant l''évacuation vers la STEP, telle que des installations de séparation ou de flottation. Les séparateurs d''hydrocarbures et de graisses et les chambres et bassins de décantation (= dépotoirs ou BEP clarification) ne sont pas considérés à ce titre comme des installations de prétraitement. Des valeurs d’attribut distinctes sont disponibles pour ces équipements. Utiliser la valeur "installation_de_traitement" pour eaux pluviales.',
   description_it = 'zzz_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   description_ro = 'rrr_Anlage zur Vorbehandlung von industriellem oder gewerblichem Schmutzabwasser vor der Ableitung zur ARA wie Spalt- oder Flotationsanlagen. Reine Öl- und Fettabscheider sowie Absetzschächte und -becken (=Schlammsammler bzw. Regenklaerbecken) gelten in diesem Sinn nicht als Vorbehandlungsanlagen, für sie sind separate Attribut-Werte vorhanden. Für Regenabwasser-Behandlungsanlagen den Wert "Behandlungsanlage" verwenden.',
   display_en = 'pretreatment_plant',
   display_de = 'Vorbehandlungsanlage',
   display_fr = 'installation de prétraitement',
   display_it = '',
   display_ro = ''
WHERE code = 9089;

--- Adapt tww_vl.special_structure_function
 INSERT INTO tww_vl.special_structure_function (code, vsacode) VALUES (2745,2745) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_function SET
   value_en = 'vortex_manhole',
   value_de = 'Wirbelfallschacht',
   value_fr = 'chambre_de_chute_a_vortex',
   value_it = 'camera_caduta_vortice',
   value_ro = 'instalatie_picurare_cu_vortex',
   abbr_en = '',
   abbr_de = 'WF',
   abbr_fr = 'CT',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bauwerk zur möglichst schadlosen, geführten Ableitung von Wasser über eine gewisse  Höhenstufe. Das Bauwerk besteht aus Drallkammer, Fallrohr, Toskammer und Rezirkulationsbelüftungsrohr',
   description_de = 'Bauwerk zur möglichst schadlosen, geführten Ableitung von Wasser über eine gewisse  Höhenstufe. Das Bauwerk besteht aus Drallkammer, Fallrohr, Toskammer und Rezirkulationsbelüftungsrohr',
   description_fr = 'Ouvrage permettant l''évacuation des eaux sans dégâts sur une hauteur donnée. L''ouvrage est composé de: chambre à formation de vortex, tuyau de chute, puits dissipateur et un tuyau d''aération',
   description_it = 'zzz_Bauwerk zur möglichst schadlosen, geführten Ableitung von Wasser über eine gewisse  Höhenstufe. Das Bauwerk besteht aus Drallkammer, Fallrohr, Toskammer und Rezirkulationsbelüftungsrohr',
   description_ro = 'Instalatie pentru scurgerea apei nedaunatoare pe o înal?ime data. Instalatia este compusa din: camera in forma de vortex, conducta picurare ?i din o conducta de aerisire',
   display_en = 'vortex_manhole',
   display_de = 'Wirbelfallschacht',
   display_fr = 'chambre de chute à vortex',
   display_it = '',
   display_ro = 'instalatie picurare cu vortex'
WHERE code = 2745;

--- Adapt tww_vl.special_structure_possibility_intervention
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode) VALUES (9056,9056) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_possibility_intervention SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 9056;

--- Adapt tww_vl.special_structure_possibility_intervention
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode) VALUES (9057,9057) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_possibility_intervention SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 9057;

--- Adapt tww_vl.special_structure_possibility_intervention
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode) VALUES (9058,9058) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_possibility_intervention SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9058;

--- Adapt tww_vl.special_structure_stormwater_tank_arrangement
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode) VALUES (4608,4608) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_stormwater_tank_arrangement SET
   value_en = 'main_connection',
   value_de = 'Hauptschluss',
   value_fr = 'en_serie',
   value_it = 'in_serie',
   value_ro = 'conectare_directa',
   abbr_en = '',
   abbr_de = 'HS',
   abbr_fr = 'CD',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchfluss des Beckens bei Trockenwetter und teilweiser Durchfluss bei Regenwetter',
   description_de = 'Durchfluss des Beckens bei Trockenwetter und teilweiser Durchfluss bei Regenwetter',
   description_fr = 'Disposition qui permet une traversée en permanence de la totalité des eaux par temps sec et d''une partie des eaux par temps de pluie',
   description_it = 'Attraversamento del bacino per tempo secco e attraversamento di una parte dell''acqua per tempo di pioggia.',
   description_ro = 'Conectarea care permite trecerea continua a apelor pe timp uscat si o por?iune a apei pe timp ploios',
   display_en = 'main_connection',
   display_de = 'Hauptschluss',
   display_fr = 'en serie',
   display_it = '',
   display_ro = 'conectare directa'
WHERE code = 4608;

--- Adapt tww_vl.special_structure_stormwater_tank_arrangement
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode) VALUES (4609,4609) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_stormwater_tank_arrangement SET
   value_en = 'side_connection',
   value_de = 'Nebenschluss',
   value_fr = 'en_parallele',
   value_it = 'in_parallelo',
   value_ro = 'conectare_laterala',
   abbr_en = '',
   abbr_de = 'NS',
   abbr_fr = 'CL',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Water flow only a storm wheather',
   description_de = 'Durchfluss des Beckens nur bei Regenwetter',
   description_fr = 'Disposition qui permet uniquement une traversée des eaux par temps de pluie',
   description_it = 'Attraversamento del bacino solo per tempo di pioggia',
   description_ro = 'Conectare care permite trecerea în permanenta a tuturor apelor de timp uscat si a unei parti din apa meteorica',
   display_en = 'side_connection',
   display_de = 'Nebenschluss',
   display_fr = 'en parallele',
   display_it = '',
   display_ro = 'conectare laterala'
WHERE code = 4609;

--- Adapt tww_vl.special_structure_stormwater_tank_arrangement
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode) VALUES (4610,4610) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.special_structure_stormwater_tank_arrangement SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 4610;

--- Adapt tww_vl.infiltration_installation_defects
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode) VALUES (5361,5361) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_defects SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucunes',
   value_it = 'nessuno',
   value_ro = 'inexistente',
   abbr_en = '',
   abbr_de = 'K',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucunes',
   display_it = '',
   display_ro = 'inexistente'
WHERE code = 5361;

--- Adapt tww_vl.infiltration_installation_defects
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode) VALUES (3276,3276) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_defects SET
   value_en = 'marginal',
   value_de = 'unwesentliche',
   value_fr = 'modestes',
   value_it = 'zzz_unwesentliche',
   value_ro = 'modeste',
   abbr_en = '',
   abbr_de = 'UW',
   abbr_fr = 'MI',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"unwesentliche" heisst, dass keine Nachkontrolle nötig ist',
   description_de = '"unwesentliche" heisst, dass keine Nachkontrolle nötig ist',
   description_fr = 'ne nécessitant pas de contrôle',
   description_it = 'zzz_"unwesentliche" heisst, dass keine Nachkontrolle nötig ist',
   description_ro = 'nu necesita control',
   display_en = 'marginal',
   display_de = 'unwesentliche',
   display_fr = 'modestes',
   display_it = '',
   display_ro = 'modeste'
WHERE code = 3276;

--- Adapt tww_vl.infiltration_installation_defects
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode) VALUES (3275,3275) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_defects SET
   value_en = 'substantial',
   value_de = 'wesentliche',
   value_fr = 'importantes',
   value_it = 'zzz_wesentliche',
   value_ro = 'importante',
   abbr_en = '',
   abbr_de = 'W',
   abbr_fr = 'MA',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"wesentliche" heisst, dass eine Nachkontrolle nötig ist',
   description_de = '"wesentliche" heisst, dass eine Nachkontrolle nötig ist',
   description_fr = 'nécessitant un contrôle',
   description_it = 'zzz_"wesentliche" heisst, dass eine Nachkontrolle nötig ist',
   description_ro = 'necesita control',
   display_en = 'substantial',
   display_de = 'wesentliche',
   display_fr = 'importantes',
   display_it = '',
   display_ro = 'importante'
WHERE code = 3275;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9069,9069) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_andere',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 9069;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9074,9074) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'in_water_body',
   value_de = 'in_Gewaesser',
   value_fr = 'dans_cours_d_eau',
   value_it = 'zzz_in_Gewaesser',
   value_ro = 'in_curs_apa',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   description_de = 'Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   description_fr = 'Connexion directe au cours d''eau (construction non souhaitée). Remplir aussi TROP_PLEIN_DE_SECOURS_EXUTOIRERef pour que le besoin d''intervention soit visible.',
   description_it = 'zzz_Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   description_ro = 'rrr_Direkte Rohrverbindung zu einem Gewässer (unerwünschte Konstruktion). Notentlastung_EinleitstelleRef auch abfüllen, damit Handlungsbedarf sichtbar wird.',
   display_en = 'in_water_body',
   display_de = 'in_Gewaesser',
   display_fr = 'dans cours d''eau',
   display_it = '',
   display_ro = 'in curs appa'
WHERE code = 9074;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9070,9070) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'in_combined_waste_water_drain',
   value_de = 'in_Mischabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_mixtes',
   value_it = 'in_canalizzazione_acque_miste',
   value_ro = 'in_canalizare_ape_mixte',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Mischwasserkanalisation" heisst, dass die Versickerung direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   description_de = '"in_Mischwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   description_fr = 'L''infiltration est directement connectée aux canalisations des eaux mixtes sans passer par le terrain (état non souhaité)',
   description_it = 'zzz_"in_Mischwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   description_ro = 'rrr_"in_Mischwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   display_en = 'in_combined_waste_water_drain',
   display_de = 'in_Mischabwasserkanalisation',
   display_fr = 'dans canalisation eaux mixtes',
   display_it = '',
   display_ro = ''
WHERE code = 9070;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9072,9072) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'in_rain_waste_water_drain',
   value_de = 'in_Regenabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_pluviales',
   value_it = 'in_canalizzazione_acque_meteoriche',
   value_ro = 'in_canalizare_apa_meteorica',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Regenabwasserkanalisation" heisst, dass die Versickerung direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft (unerwünschter Zustand)',
   description_de = '"in_Regenabwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft (unerwünschter Zustand)',
   description_fr = 'L''infiltration est directement connectée aux canalisations des eaux pluviales sans passer par le terrain (état non souhaité)',
   description_it = '',
   description_ro = '',
   display_en = 'in_rain_waste_water_drain',
   display_de = 'in_Regenabwasserkanalisation',
   display_fr = 'dans canalisation eaux pluviales',
   display_it = '',
   display_ro = ''
WHERE code = 9072;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9073,9073) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'in_waste_water_drain',
   value_de = 'in_Schmutzabwasserkanalisation',
   value_fr = 'dans_canalisation_eaux_usees',
   value_it = 'in_canalizzazione_acque_luride',
   value_ro = 'in_canalizare_apa_uzata',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_"in_Schmutzabwasserkanalisation" heisst, dass die Versickerung direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   description_de = '"in_Schmutzabwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände zwischendurch läuft (unerwünschter Zustand)',
   description_fr = 'L''infiltration est directement connectée aux canalisations des eaux useés sans passer par le terrain (état non souhaité)',
   description_it = 'zzz_"in_Schmutzabwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft (unerwünschter Zustand)',
   description_ro = 'rrr_"in_Schmutzabwasserkanalisation" heisst, dass die Anlage direkt verrohrt ist und nicht frei über das Gelände  zwischendurch läuft (unerwünschter Zustand)',
   display_en = 'in_waste_water_drain',
   display_de = 'in_Schmutzabwasserkanalisation',
   display_fr = 'dans canalisation eaux usées',
   display_it = '',
   display_ro = ''
WHERE code = 9073;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (3303,3303) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = 'K',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = 'inexistent'
WHERE code = 3303;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (9071,9071) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'surface_discharge',
   value_de = 'oberflaechlich_ausmuendend',
   value_fr = 'deversement_en_surface',
   value_it = 'zzz_oberflaechlich_ausmuendend',
   value_ro = 'deversare_la_suprafata',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Das Wasser überfliesst beim Einstau über die Versickerungsanlage hinaus an die Oberfläche (gewünschter Zustand / Hinweis auf verstopfte Anlage).',
   description_de = 'Das Wasser überfliesst beim Einstau über die Versickerungsanlage hinaus an die Oberfläche (gewünschter Zustand / Hinweis auf verstopfte Anlage).',
   description_fr = 'L''eau submerge l''installation jusqu''à la surface (état souhaité / indiquant un colmatage)',
   description_it = 'zzz_Das Wasser überfliesst beim Einstau über die Versickerungsanlage hinaus an die Oberfläche (gewünschter Zustand / Hinweis auf verstopfte Anlage).',
   description_ro = 'rrr_Das Wasser überfliesst beim Einstau über die Versickerungsanlage hinaus an die Oberfläche (gewünschter Zustand / Hinweis auf verstopfte Anlage).',
   display_en = 'surface_discharge',
   display_de = 'oberflaechlich_ausmuendend',
   display_fr = 'déversement en surface',
   display_it = '',
   display_ro = 'deversare la suprafata'
WHERE code = 9071;

--- Adapt tww_vl.infiltration_installation_emergency_overflow
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode) VALUES (3308,3308) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_emergency_overflow SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3308;

--- Adapt tww_vl.infiltration_installation_filling_material
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode) VALUES (4785,4785) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_filling_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4785;

--- Adapt tww_vl.infiltration_installation_filling_material
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode) VALUES (4786,4786) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_filling_material SET
   value_en = 'wood_chips',
   value_de = 'Holzschnitzel',
   value_fr = 'copeaux_bois',
   value_it = 'zzz_Holzschnitzel',
   value_ro = 'rrr_Holzschnitzel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'wood_chips',
   display_de = 'Holzschnitzel',
   display_fr = 'copeaux bois',
   display_it = '',
   display_ro = ''
WHERE code = 4786;

--- Adapt tww_vl.infiltration_installation_filling_material
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode) VALUES (4787,4787) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_filling_material SET
   value_en = 'soakaway_gravel',
   value_de = 'Sickerkies',
   value_fr = 'gravier',
   value_it = 'zzz_Sickerkies',
   value_ro = 'rrr_Sickerkies',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'soakaway_gravel',
   display_de = 'Sickerkies',
   display_fr = 'gravier',
   display_it = '',
   display_ro = ''
WHERE code = 4787;

--- Adapt tww_vl.infiltration_installation_filling_material
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode) VALUES (4788,4788) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_filling_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 4788;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3282,3282) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'with_soil_passage',
   value_de = 'andere_mit_Bodenpassage',
   value_fr = 'autre_avec_passage_a_travers_sol',
   value_it = 'zzz_altro_mit_Bodenpassage',
   value_ro = 'altul_cu_traversare_sol',
   abbr_en = 'WSP',
   abbr_de = 'AMB',
   abbr_fr = 'APC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'with_soil_passage',
   display_de = 'andere_mit_Bodenpassage',
   display_fr = 'autre avec passage a travers sol',
   display_it = '',
   display_ro = 'altul cu traversare sol'
WHERE code = 3282;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3285,3285) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'without_soil_passage',
   value_de = 'andere_ohne_Bodenpassage',
   value_fr = 'autre_sans_passage_a_travers_sol',
   value_it = 'zzz_altro_ohne_Bodenpassage',
   value_ro = 'altul_fara_traversare_sol',
   abbr_en = 'WOP',
   abbr_de = 'AOB',
   abbr_fr = 'ASC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'without_soil_passage',
   display_de = 'andere_ohne_Bodenpassage',
   display_fr = 'autre sans passage à travers sol',
   display_it = '',
   display_ro = 'altul fara traversare sol'
WHERE code = 3285;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3279,3279) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'surface_infiltration',
   value_de = 'Flaechenfoermige_Versickerung',
   value_fr = 'infiltration_superficielle_sur_place',
   value_it = 'zzz_Flaechenfoermige_Versickerung',
   value_ro = 'infilitratie_de_suprafata',
   abbr_en = '',
   abbr_de = 'FV',
   abbr_fr = 'IS',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_flächenförmige Versickerung',
   description_de = 'flächenförmige Versickerung',
   description_fr = '',
   description_it = 'zzz_flächenförmige Versickerung',
   description_ro = '',
   display_en = 'surface_infiltration',
   display_de = 'Flaechenfoermige_Versickerung',
   display_fr = 'Infiltration superficielle sur place',
   display_it = '',
   display_ro = 'infilitratie de suprafata'
WHERE code = 3279;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (277,277) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'gravel_formation',
   value_de = 'Kieskoerper',
   value_fr = 'corps_de_gravier',
   value_it = 'zzz_Kieskoerper',
   value_ro = 'formatiune_de_pietris',
   abbr_en = '',
   abbr_de = 'KK',
   abbr_fr = 'VG',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gravel_formation',
   display_de = 'Kieskoerper',
   display_fr = 'volume de gravier',
   display_it = '',
   display_ro = 'formatiune de pietris'
WHERE code = 277;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3284,3284) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'combination_manhole_pipe',
   value_de = 'Kombination_Schacht_Strang',
   value_fr = 'combinaison_puits_bande',
   value_it = 'zzz_Kombination_Schacht_Strang',
   value_ro = 'combinatie_put_conducta',
   abbr_en = '',
   abbr_de = 'KOM',
   abbr_fr = 'CPT',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'combination_manhole_pipe',
   display_de = 'Kombination_Schacht_Strang',
   display_fr = 'combinaison puits bande',
   display_it = '',
   display_ro = 'combinatie put conducta'
WHERE code = 3284;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3281,3281) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'swale_french_drain_infiltration',
   value_de = 'MuldenRigolenversickerung',
   value_fr = 'cuvettes_rigoles_filtrantes',
   value_it = 'zzz_MuldenRigolenversickerung',
   value_ro = 'cuve_rigole_filtrante',
   abbr_en = '',
   abbr_de = 'MRV',
   abbr_fr = 'ICR',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'swale_french_drain_infiltration',
   display_de = 'MuldenRigolenversickerung',
   display_fr = 'cuvettes rigoles filtrantes',
   display_it = '',
   display_ro = 'cuve rigole filtrante'
WHERE code = 3281;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3087,3087) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3087;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3280,3280) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'percolation_over_the_shoulder',
   value_de = 'Versickerung_ueber_die_Schulter',
   value_fr = 'infiltration_par_les_bas_cotes',
   value_it = 'zzz_Versickerung_ueber_die_Schulter',
   value_ro = 'infilitratie_pe_la_cote_joase',
   abbr_en = '',
   abbr_de = 'VUS',
   abbr_fr = 'IDB',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'percolation_over_the_shoulder',
   display_de = 'Versickerung_ueber_die_Schulter',
   display_fr = 'infiltration par le bas cotes',
   display_it = '',
   display_ro = 'infilitratie pe la cote joase'
WHERE code = 3280;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (276,276) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'infiltration_basin',
   value_de = 'Versickerungsbecken',
   value_fr = 'bassin_d_infiltration',
   value_it = 'zzz_Versickerungsbecken',
   value_ro = 'bazin_infiltrare',
   abbr_en = '',
   abbr_de = 'VB',
   abbr_fr = 'BI',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'infiltration_basin',
   display_de = 'Versickerungsbecken',
   display_fr = 'bassin d''infiltration',
   display_it = '',
   display_ro = 'bazin infiltrare'
WHERE code = 276;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (278,278) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'adsorbing_well',
   value_de = 'Versickerungsschacht',
   value_fr = 'puits_d_infiltration',
   value_it = 'zzz_Versickerungsschacht',
   value_ro = 'put_de_inflitrare',
   abbr_en = '',
   abbr_de = 'VS',
   abbr_fr = 'PI',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'adsorbing_well',
   display_de = 'Versickerungsschacht',
   display_fr = 'puits d''infiltration',
   display_it = '',
   display_ro = 'put de inflitrare'
WHERE code = 278;

--- Adapt tww_vl.infiltration_installation_kind
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode) VALUES (3283,3283) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_kind SET
   value_en = 'infiltration_pipe_sections_gallery',
   value_de = 'Versickerungsstrang_Galerie',
   value_fr = 'bande_infiltration_galerie',
   value_it = 'zzz_Versickerungsstrang_Galerie',
   value_ro = 'conducta_infiltrare_galerie',
   abbr_en = '',
   abbr_de = 'VG',
   abbr_fr = 'TIG',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'infiltration_pipe_sections_gallery',
   display_de = 'Versickerungsstrang_Galerie',
   display_fr = 'bande infiltration galerie',
   display_it = '',
   display_ro = 'conducta infiltrare galerie'
WHERE code = 3283;

--- Adapt tww_vl.infiltration_installation_labeling
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode) VALUES (5362,5362) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_labeling SET
   value_en = 'labeled',
   value_de = 'beschriftet',
   value_fr = 'signalee',
   value_it = 'zzz_beschriftet',
   value_ro = 'marcat',
   abbr_en = 'L',
   abbr_de = 'BS',
   abbr_fr = 'SI',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'labeled',
   display_de = 'beschriftet',
   display_fr = 'signalée',
   display_it = '',
   display_ro = 'marcat'
WHERE code = 5362;

--- Adapt tww_vl.infiltration_installation_labeling
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode) VALUES (5363,5363) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_labeling SET
   value_en = 'not_labeled',
   value_de = 'nichtbeschriftet',
   value_fr = 'non_signalee',
   value_it = 'zzz_nichtbeschriftet',
   value_ro = 'nemarcat',
   abbr_en = '',
   abbr_de = 'NBS',
   abbr_fr = 'NSI',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_labeled',
   display_de = 'nichtbeschriftet',
   display_fr = 'non signalée',
   display_it = '',
   display_ro = 'nemarcat'
WHERE code = 5363;

--- Adapt tww_vl.infiltration_installation_labeling
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode) VALUES (5364,5364) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_labeling SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5364;

--- Adapt tww_vl.infiltration_installation_seepage_utilization
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode) VALUES (9024,9024) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_seepage_utilization SET
   value_en = 'surface_water',
   value_de = 'Niederschlagsabwasser',
   value_fr = 'eaux_de_surface',
   value_it = 'acque_piovane',
   value_ro = 'apa_meteorica',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Water from precipitation, which has not seeped into the ground and is discharged to the drain or sewer system directly from the ground orfrom exterior building surfaces (SIA 190.301 = EN 16323:2014). The allocation to polluted or unpolluted wastewater is made according to the water protection legislation or according to the instructions of the VSA guideline "Wastewater disposal during rainfall".',
   description_de = 'Unter Niederschlagswasser versteht man das Wasser, welches bei einem Niederschlagsereignis auf eine Oberfläche fällt. Solange es nicht abfliesst und direkt versickert, gilt es als Niederschlagswasser. Sobald es nicht direkt versickert, sondern zuerst über eine bebaute oder befestigte Fläche abfliesst, gilt es als Niederschlagsabwasser.',
   description_fr = 'Eaux de précipitation non infiltrées dans le sol et rejetées depuis le sol ou les surfaces extérieures des bâtiments dans les réseaux d’évacuation et d’assainissement (SIA 190.301 = EN 16323:2014). Classification en eaux polluées et non polluées selon la législation sur la protection des eaux resp. selon la directive VSA "Gestion des eaux urbaines par temps de pluie".',
   description_it = 'Acqua proveniente da precipitazioni naturali non inquinata da utilizzi. L''attribuzione ad acqua inquinata o acqua non inquinata avviene in base alla legislazione sulla protezione delle acque o alla direttiva VSA ''Smaltimento delle acque di scarico in tempo di pioggia''',
   description_ro = 'rrr_Niederschlag, der nicht im Boden versickert ist und von Bodenoberflächen oder von Gebäudeaussenflächen in das Entwässerungsystem eingeleitet ist (SIA 190.301 = EN 16323:2014). Die Zuordnung zu verschmutztem oder unverschmutztem Abwasser erfolgt nach der Gewässerschutzgesetzgebung bzw. nach Anleitung der VSA-Richtlinie "Abwasserentsorgung bei Regenwetter".',
   display_en = 'surface_water',
   display_de = 'Niederschlagsabwasser',
   display_fr = 'eaux de surface',
   display_it = '',
   display_ro = ''
WHERE code = 9024;

--- Adapt tww_vl.infiltration_installation_seepage_utilization
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode) VALUES (273,273) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_seepage_utilization SET
   value_en = 'clean_water',
   value_de = 'Reinabwasser',
   value_fr = 'eaux_claires',
   value_it = 'acque_chiare',
   value_ro = 'ape_conventional_curate',
   abbr_en = '',
   abbr_de = 'KW',
   abbr_fr = 'EC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'clean_water',
   display_de = 'Reinabwasser',
   display_fr = 'eaux propres',
   display_it = '',
   display_ro = 'ape conventional curate'
WHERE code = 273;

--- Adapt tww_vl.infiltration_installation_seepage_utilization
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode) VALUES (5359,5359) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_seepage_utilization SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5359;

--- Adapt tww_vl.infiltration_installation_vehicle_access
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode) VALUES (3289,3289) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_vehicle_access SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3289;

--- Adapt tww_vl.infiltration_installation_vehicle_access
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode) VALUES (3288,3288) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_vehicle_access SET
   value_en = 'inaccessible',
   value_de = 'unzugaenglich',
   value_fr = 'inaccessible',
   value_it = 'non_accessibile',
   value_ro = 'neaccesibil',
   abbr_en = '',
   abbr_de = 'ZU',
   abbr_fr = 'IAC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inaccessible',
   display_de = 'unzugaenglich',
   display_fr = 'inaccessible',
   display_it = '',
   display_ro = 'neaccesibil'
WHERE code = 3288;

--- Adapt tww_vl.infiltration_installation_vehicle_access
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode) VALUES (3287,3287) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_vehicle_access SET
   value_en = 'accessible',
   value_de = 'zugaenglich',
   value_fr = 'accessible',
   value_it = 'accessibile',
   value_ro = 'accessibil',
   abbr_en = '',
   abbr_de = 'Z',
   abbr_fr = 'AC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'accessible',
   display_de = 'zugaenglich',
   display_fr = 'accessible',
   display_it = '',
   display_ro = 'accessibil'
WHERE code = 3287;

--- Adapt tww_vl.infiltration_installation_watertightness
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode) VALUES (3295,3295) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_watertightness SET
   value_en = 'not_watertight',
   value_de = 'nichtwasserdicht',
   value_fr = 'non_etanche',
   value_it = 'zzz_nichtwasserdicht',
   value_ro = 'neetans',
   abbr_en = '',
   abbr_de = 'NWD',
   abbr_fr = 'NE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_watertight',
   display_de = 'nichtwasserdicht',
   display_fr = 'non étanche',
   display_it = '',
   display_ro = 'neetans'
WHERE code = 3295;

--- Adapt tww_vl.infiltration_installation_watertightness
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode) VALUES (5360,5360) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_watertightness SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5360;

--- Adapt tww_vl.infiltration_installation_watertightness
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode) VALUES (3294,3294) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_installation_watertightness SET
   value_en = 'watertight',
   value_de = 'wasserdicht',
   value_fr = 'etanche',
   value_it = 'zzz_wasserdicht',
   value_ro = 'etans',
   abbr_en = '',
   abbr_de = 'WD',
   abbr_fr = 'E',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'watertight',
   display_de = 'wasserdicht',
   display_fr = 'étanche',
   display_it = '',
   display_ro = 'etans'
WHERE code = 3294;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (331,331) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'sedimentation_basin',
   value_de = 'Absetzbecken',
   value_fr = 'bassin_de_decantation',
   value_it = 'zzz_Absetzbecken',
   value_ro = 'rrr_Absetzbecken',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sedimentation_basin',
   display_de = 'Absetzbecken',
   display_fr = 'bassin de décantation',
   display_it = '',
   display_ro = ''
WHERE code = 331;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (2974,2974) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2974;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (327,327) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'aeration_tank',
   value_de = 'Belebtschlammbecken',
   value_fr = 'bassin_a_boues_activees',
   value_it = 'zzz_Belebtschlammbecken',
   value_ro = 'rrr_Belebtschlammbecken',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'aeration_tank',
   display_de = 'Belebtschlammbecken',
   display_fr = 'bassin à boues activées',
   display_it = '',
   display_ro = ''
WHERE code = 327;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (329,329) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'fixed_bed_reactor',
   value_de = 'Festbettreaktor',
   value_fr = 'reacteur_a_biomasse_fixee',
   value_it = 'zzz_Festbettreaktor',
   value_ro = 'rrr_Festbettreaktor',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'fixed_bed_reactor',
   display_de = 'Festbettreaktor',
   display_fr = 'réacteur à biomasse fixée',
   display_it = '',
   display_ro = ''
WHERE code = 329;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (330,330) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'submerged_trickling_filter',
   value_de = 'Tauchtropfkoerper',
   value_fr = 'disque_bacterien_immerge',
   value_it = 'zzz_Tauchtropfkoerper',
   value_ro = 'rrr_Tauchtropfkoerper',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'submerged_trickling_filter or submerged_contact_bed',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'submerged_trickling_filter',
   display_de = 'Tauchtropfkoerper',
   display_fr = 'disque bactérien immergé',
   display_it = '',
   display_ro = ''
WHERE code = 330;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (328,328) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'trickling_filter',
   value_de = 'Tropfkoerper',
   value_fr = 'lit_bacterien',
   value_it = 'zzz_Tropfkoerper',
   value_ro = 'rrr_Tropfkoerper',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'trickling or percolation filter',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'trickling_filter',
   display_de = 'Tropfkoerper',
   display_fr = 'lit bactérien',
   display_it = '',
   display_ro = ''
WHERE code = 328;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (3032,3032) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3032;

--- Adapt tww_vl.wwtp_structure_kind
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode) VALUES (326,326) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wwtp_structure_kind SET
   value_en = 'primary_clarifier',
   value_de = 'Vorklaerbecken',
   value_fr = 'decanteurs_primaires',
   value_it = 'zzz_Vorklaerbecken',
   value_ro = 'rrr_Vorklaerbecken',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'primary_clarifier',
   display_de = 'Vorklaerbecken',
   display_fr = 'décanteurs primaires',
   display_it = '',
   display_ro = ''
WHERE code = 326;

--- Adapt tww_vl.maintenance_event_status
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode) VALUES (2550,2550) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_event_status SET
   value_en = 'accomplished',
   value_de = 'ausgefuehrt',
   value_fr = 'execute',
   value_it = 'eseguito',
   value_ro = 'rrr_ausgefuehrt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'accomplished',
   display_de = 'ausgefuehrt',
   display_fr = 'exécuté',
   display_it = '',
   display_ro = ''
WHERE code = 2550;

--- Adapt tww_vl.maintenance_event_status
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode) VALUES (2549,2549) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_event_status SET
   value_en = 'planned',
   value_de = 'geplant',
   value_fr = 'prevu',
   value_it = 'previsto',
   value_ro = 'rrr_geplant',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'planned',
   display_de = 'geplant',
   display_fr = 'prévu',
   display_it = '',
   display_ro = ''
WHERE code = 2549;

--- Adapt tww_vl.maintenance_event_status
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode) VALUES (3678,3678) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_event_status SET
   value_en = 'not_possible',
   value_de = 'nicht_moeglich',
   value_fr = 'impossible',
   value_it = 'non_possibile',
   value_ro = 'rrr_nicht_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Falls eine geplante Untersuchung nicht durchgeführt werden konnte.',
   description_de = 'Falls eine geplante Untersuchung nicht durchgeführt werden konnte.',
   description_fr = 'Si une inspection projetée n’a pu être réalisée',
   description_it = 'Se non è stato possibile effettuare un''indagine pianificata.',
   description_ro = 'rrr_Falls eine geplante Untersuchung nicht durchgeführt werden konnte.',
   display_en = 'not_possible',
   display_de = 'nicht_moeglich',
   display_fr = 'impossible',
   display_it = '',
   display_ro = ''
WHERE code = 3678;

--- Adapt tww_vl.maintenance_event_status
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode) VALUES (3047,3047) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_event_status SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3047;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (371,371) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'good',
   value_de = 'gut',
   value_fr = 'bonnes',
   value_it = 'zzz_gut',
   value_ro = 'rrr_gut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'good',
   display_de = 'gut',
   display_fr = 'bonnes',
   display_it = '',
   display_ro = ''
WHERE code = 371;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (374,374) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucune',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucune',
   display_it = '',
   display_ro = ''
WHERE code = 374;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (372,372) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'moderate',
   value_de = 'maessig',
   value_fr = 'moyennes',
   value_it = 'zzz_maessig',
   value_ro = 'rrr_maessig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'moderate',
   display_de = 'maessig',
   display_fr = 'moyennes',
   display_it = '',
   display_ro = ''
WHERE code = 372;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (373,373) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'bad',
   value_de = 'schlecht',
   value_fr = 'mauvaises',
   value_it = 'zzz_schlecht',
   value_ro = 'rrr_schlecht',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'bad',
   display_de = 'schlecht',
   display_fr = 'mauvaises',
   display_it = '',
   display_ro = ''
WHERE code = 373;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (3073,3073) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3073;

--- Adapt tww_vl.infiltration_zone_infiltration_capacity
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode) VALUES (2996,2996) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.infiltration_zone_infiltration_capacity SET
   value_en = 'not_allowed',
   value_de = 'unzulaessig',
   value_fr = 'non_admis',
   value_it = 'zzz_unzulaessig',
   value_ro = 'rrr_unzulaessig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_allowed',
   display_de = 'unzulaessig',
   display_fr = 'non admis',
   display_it = '',
   display_ro = ''
WHERE code = 2996;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (4783,4783) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'amelioration',
   value_de = 'Melioration',
   value_fr = 'melioration',
   value_it = 'zzz_melizzazione',
   value_ro = 'rrr_Melioration',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'amelioration',
   display_de = 'Melioration',
   display_fr = 'mélioration',
   display_it = '',
   display_ro = ''
WHERE code = 4783;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (2722,2722) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'mixed_system',
   value_de = 'Mischsystem',
   value_fr = 'systeme_unitaire',
   value_it = 'sistema_misto',
   value_ro = 'rrr_Mischsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Im Mischsystem werden häusliches, gewerbliches und industrielles Schmutzwasser und das Niederschlagswasser im Gegensatz zur Trennkanalisation gemeinsam in einer Kanalisation abgeleitet. Aufgrund der begrenzten Leistungsfähigkeit der Kläranlage und um aus technischen und wirtschaftlichen Erfordernissen den Kanalquerschnitt zu begrenzen, werden im Mischsystem an geeigneten Stellen Regenentlastungsbauwerke oder Regenrückhalteräume angeordnet. Durch Regenüberläufe in den Hauptkanälen gelangen vor allem in der Anfangsphase von Starkniederschlägen wegen der Spülwirkung hohe Schmutzmengen in die Kläranlage. Deshalb werden verstärkt Regenrückhaltebecken gebaut, die diesen "Spülstoß" auffangen und allmählich an die Kläranlage abgeben sollen. Unverschmutztes Wasser - wie Abfluss von Außengebieten, Dränagewasser, Quellen, Brunnen, usw. - darf nicht in den Mischwasserkanal eingeleitet werden. Dies wird am Entstehungsort oder nach Ableitung verrieselt, versickert oder direkt in ein Oberflächengewässer eingeleitet.',
   description_de = 'Im Mischsystem werden häusliches, gewerbliches und industrielles Schmutzwasser und das Niederschlagswasser im Gegensatz zur Trennkanalisation gemeinsam in einer Kanalisation abgeleitet. Aufgrund der begrenzten Leistungsfähigkeit der Kläranlage und um aus technischen und wirtschaftlichen Erfordernissen den Kanalquerschnitt zu begrenzen, werden im Mischsystem an geeigneten Stellen Regenentlastungsbauwerke oder Regenrückhalteräume angeordnet. Durch Regenüberläufe in den Hauptkanälen gelangen vor allem in der Anfangsphase von Starkniederschlägen wegen der Spülwirkung hohe Schmutzmengen in die Kläranlage. Deshalb werden verstärkt Regenrückhaltebecken gebaut, die diesen "Spülstoß" auffangen und allmählich an die Kläranlage abgeben sollen. Unverschmutztes Wasser - wie Abfluss von Außengebieten, Dränagewasser, Quellen, Brunnen, usw. - darf nicht in den Mischwasserkanal eingeleitet werden. Dies wird am Entstehungsort oder nach Ableitung verrieselt, versickert oder direkt in ein Oberflächengewässer eingeleitet.',
   description_fr = 'L’ensemble des eaux usées et pluviales est, en système unitaire, évacué par un réseau unique, généralement équipé de déversoirs d’orage, vannages, etc. permettant, en cas de pluies intenses, le rejet par surverse d’une partie des eaux, dirigées par un évacuateur vers le milieu naturel soit directement soit après traitement spécifique (selon M. Satin, B. Selmi, Guide technique de l’assainissement).',
   description_it = 'zzz_Im Mischsystem werden häusliches, gewerbliches und industrielles Schmutzwasser und das Niederschlagswasser im Gegensatz zur Trennkanalisation gemeinsam in einer Kanalisation abgeleitet. Aufgrund der begrenzten Leistungsfähigkeit der Kläranlage und um aus technischen und wirtschaftlichen Erfordernissen den Kanalquerschnitt zu begrenzen, werden im Mischsystem an geeigneten Stellen Regenentlastungsbauwerke oder Regenrückhalteräume angeordnet. Durch Regenüberläufe in den Hauptkanälen gelangen vor allem in der Anfangsphase von Starkniederschlägen wegen der Spülwirkung hohe Schmutzmengen in die Kläranlage. Deshalb werden verstärkt Regenrückhaltebecken gebaut, die diesen "Spülstoß" auffangen und allmählich an die Kläranlage abgeben sollen. Unverschmutztes Wasser - wie Abfluss von Außengebieten, Dränagewasser, Quellen, Brunnen, usw. - darf nicht in den Mischwasserkanal eingeleitet werden. Dies wird am Entstehungsort oder nach Ableitung verrieselt, versickert oder direkt in ein Oberflächengewässer eingeleitet.',
   description_ro = '',
   display_en = 'mixed_system',
   display_de = 'Mischsystem',
   display_fr = 'système unitaire',
   display_it = '',
   display_ro = ''
WHERE code = 2722;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (2724,2724) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'modified_system',
   value_de = 'ModifiziertesSystem',
   value_fr = 'systeme_modifie',
   value_it = 'sistema_modificato',
   value_ro = 'rrr_ModifiziertesSystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungssystemen für die getrennte Ableitung von Misch- und Regenabwasser. Das niederschlagsabhängige Abwasser von Strassen und Plätzen wird zusammen mit dem Schmutzabwasser abgeleitet. Unverschmutztes Dach- und Sickerwasser wird in die Regenabwasserkanalisation abgeleitet. (dss)',
   description_de = 'Entwässerungssystem, üblicherweise bestehend aus zwei Leitungssystemen für die getrennte Ableitung von Misch- und Regenabwasser. Das niederschlagsabhängige Abwasser von Strassen und Plätzen wird zusammen mit dem Schmutzabwasser abgeleitet. Unverschmutztes Dach- und Sickerwasser wird in die Regenabwasserkanalisation abgeleitet. (dss)',
   description_fr = 'Système d''assainissement composé normalement de deux réseaux de canalisations pour l''évacuation des eaux mixtes et pluviales. Les eaux pluviales des toitures sont évacuées avec les eaux mixtes.',
   description_it = 'zzz_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungssystemen für die getrennte Ableitung von Misch- und Regenabwasser. Das niederschlagsabhängige Abwasser von Strassen und Plätzen wird zusammen mit dem Schmutzabwasser abgeleitet. Unverschmutztes Dach- und Sickerwasser wird in die Regenabwasserkanalisation abgeleitet. (dss)',
   description_ro = '',
   display_en = 'modified_system',
   display_de = 'ModifiziertesSystem',
   display_fr = 'système modifié',
   display_it = '',
   display_ro = ''
WHERE code = 2724;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (4544,4544) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 4544;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (2723,2723) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'separated_system',
   value_de = 'Trennsystem',
   value_fr = 'systeme_separatif',
   value_it = 'sistema_separato',
   value_ro = 'rrr_Trennsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_de = 'Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_fr = 'Système d''évacuation constitué typiquement de deux systèmes de conduites/canalisations pour l’évacuation séparée des eaux usées et des eaux pluviales. Les eaux usées ainsi que les eaux pluviales provenant de surfaces non couvertes pouvant être polluées sont à raccorder au réseau des eaux usées. Le reste des eaux pluviales qui ne peuvent pas être infiltrées ou évaporées sont à raccorder au réseau d''eaux pluviales. Les liaisons avec les nœuds d’EU et d’EM ou d''EP sont obligatoires. La liaison avec un deuxième nœud (EP ou EU/EM) est autorisée.',
   description_it = 'zzz_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_ro = 'rrr_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   display_en = 'separated_system',
   display_de = 'Trennsystem',
   display_fr = 'système séparatif',
   display_it = '',
   display_ro = 'rrr_Trennsystem'
WHERE code = 2723;

--- Adapt tww_vl.drainage_system_kind
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode) VALUES (3060,3060) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainage_system_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3060;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3351,3351) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'egg',
   value_de = 'Eiprofil',
   value_fr = 'ovoide',
   value_it = 'ovoidale',
   value_ro = 'ovoid',
   abbr_en = 'E',
   abbr_de = 'E',
   abbr_fr = 'OV',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Nur für Norm-Eiprofile gemäss DIN 4263 mit Höhenbreitenverhältnis von 1.5 verwenden. Andere Eiprofile, auch solche mit Einbauten, sind als „Spezialprofil“ zu attributieren und die Profildefinition ist mitzuliefern.',
   description_de = 'Nur für Norm-Eiprofile gemäss DIN 4263 mit Höhenbreitenverhältnis von 1.5 verwenden. Andere Eiprofile, auch solche mit Einbauten, sind als „Spezialprofil“ zu attributieren und die Profildefinition ist mitzuliefern.',
   description_fr = 'A utiliser uniquement pour les profils ovoïdes normés selon DIN 4263 ayant un rapport hauteur/largeur de 1.5. Pour les autres profils ovoïdes, même ceux avec des modifications, la valeur devient « profil_special » et une définition du profil est à joindre.',
   description_it = 'Solo per profili ovoidali secondo la norma DIN 4263 con rapporto altezza/larghezza di 1.5. Altri profili ovoidali, anche quelli con installazioni, devono essere considerati come “profilo speciale” e forniti con la definizione del profilo.',
   description_ro = '',
   display_en = 'egg',
   display_de = 'Eiprofil',
   display_fr = 'ovoïde',
   display_it = '',
   display_ro = 'ovoid'
WHERE code = 3351;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3350,3350) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'circle',
   value_de = 'Kreisprofil',
   value_fr = 'circulaire',
   value_it = 'cicolare',
   value_ro = 'rotund',
   abbr_en = 'CI',
   abbr_de = 'K',
   abbr_fr = 'CI',
   abbr_it = 'CI',
   abbr_ro = 'R',
   description_en = 'Use only for circle profiles without dry weather fume or other modifications of the rectangular shape. Else use "special_profile" and send the profile geometry along with the dataset.',
   description_de = 'Nur für reine Kreisprofile ohne Trockenwetterrinne oder andere Einbauten verwenden. Sonst als „Spezialprofil“ attributieren und die Profildefinition mitliefern.',
   description_fr = 'A utiliser uniquement pour des profils circulaires normés, sans cunette de débit par temps sec ou autres modifications. Sinon la valeur devient « profil_special » et une définition du profil est à joindre.',
   description_it = 'Solo per profili circolari classici senza canaletta per tempo secco o altre installazioni. Altrimenti devono essere considerati come “profilo speciale” e forniti con la definizione del profilo.',
   description_ro = '',
   display_en = 'circle',
   display_de = 'Kreisprofil',
   display_fr = 'circulaire',
   display_it = '',
   display_ro = 'rotund'
WHERE code = 3350;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3352,3352) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'mouth',
   value_de = 'Maulprofil',
   value_fr = 'profil_en_voute',
   value_it = 'composto',
   value_ro = 'sectiune_cu_bolta',
   abbr_en = 'M',
   abbr_de = 'M',
   abbr_fr = 'V',
   abbr_it = 'C',
   abbr_ro = '',
   description_en = 'Use only for mouth profiles as defined in DIN 4263 (German Engineering Norm). If you have modifications to this use "special_profile" instead and send along the profile geometry with the dataset.',
   description_de = 'Nur für Norm-Maulprofile gemäss DIN 4263 verwenden. Abweichende Varianten, auch solche mit Einbauten, sind als „Spezialprofil“ zu attributieren und die Profildefinition ist mitzuliefern.',
   description_fr = 'A utiliser uniquement pour les profils en voûte normés selon DIN 4263. Pour les variantes, même avec modifications, la valeur devient « profil_special » et une définition du profil est à joindre.',
   description_it = 'Solo per profili composti secondo la norma DIN 4263. Altri profili composti, anche quelli con installazioni, devono essere considerati come “profilo speciale” e forniti con la definizione del profilo.',
   description_ro = '',
   display_en = 'mouth',
   display_de = 'Maulprofil',
   display_fr = 'profil en voûte',
   display_it = '',
   display_ro = 'sectiune cu bolta'
WHERE code = 3352;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3354,3354) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'open',
   value_de = 'offenes_Profil',
   value_fr = 'profil_ouvert',
   value_it = 'sezione_aperta',
   value_ro = 'profil_deschis',
   abbr_en = 'OP',
   abbr_de = 'OP',
   abbr_fr = 'PO',
   abbr_it = 'SA',
   abbr_ro = '',
   description_en = 'Use only for rectangular profiles without dry weather fume or other modifications of the For open profiles. Send the profile geometry along with the data set.',
   description_de = 'Für offene Profile. Profildefinition mitliefern',
   description_fr = 'A utiliser uniquement pour les profils ouverts. Une définition du profil est à joindre.',
   description_it = 'Per profili aperti. Fornire con la definizione del profilo.',
   description_ro = '',
   display_en = 'open',
   display_de = 'offenes_Profil',
   display_fr = 'profil ouvert',
   display_it = '',
   display_ro = 'profil deschis'
WHERE code = 3354;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3353,3353) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'rectangular',
   value_de = 'Rechteckprofil',
   value_fr = 'rectangulaire',
   value_it = 'rettangolare',
   value_ro = 'dreptunghiular',
   abbr_en = 'R',
   abbr_de = 'R',
   abbr_fr = 'R',
   abbr_it = 'R',
   abbr_ro = 'D',
   description_en = 'Use only for rectangular profiles without dry weather fume or other modifications of the rectangular shape. Else use "special_profile" and send the profile geometry along with the dataset.',
   description_de = 'Nur für reine Rechteckprofile ohne Trockenwetterrinne oder andere Einbauten verwenden. Sonst als „Spezialprofil“ attributieren und die Profildefinition mitliefern.',
   description_fr = 'A utiliser uniquement pour des profils rectangulaires normés, sans cunette de débit par temps sec ou autres modifications. Sinon la valeur devient « profil_special » et une définition du profil est à joindre.',
   description_it = 'Solo per profili rettangolari senza canaletta per tempo secco o altre installazioni. Altrimenti devono essere considerati come “profilo speciale” e forniti con la definizione del profilo.',
   description_ro = '',
   display_en = 'rectangular',
   display_de = 'Rechteckprofil',
   display_fr = 'rectangulaire',
   display_it = '',
   display_ro = 'dreptunghiular'
WHERE code = 3353;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3355,3355) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'special',
   value_de = 'Spezialprofil',
   value_fr = 'profil_special',
   value_it = 'sezione_speciale',
   value_ro = 'sectiune_speciala',
   abbr_en = 'S',
   abbr_de = 'S',
   abbr_fr = 'PS',
   abbr_it = 'S',
   abbr_ro = 'S',
   description_en = 'For closed not normed profiles. The profile geometry always has to go along with this profile also.',
   description_de = 'Für geschlossene nicht-Normprofile. Profildefinition mitliefern.',
   description_fr = 'Pour des profils fermés non conformes. Une définition du profil est à joindre.',
   description_it = 'Per profili chiusi non a norma. Fornire con la definizione del profilo.',
   description_ro = '',
   display_en = 'special',
   display_de = 'Spezialprofil',
   display_fr = 'profil spécial',
   display_it = '',
   display_ro = 'sectiune speciala'
WHERE code = 3355;

--- Adapt tww_vl.pipe_profile_profile_type
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode) VALUES (3357,3357) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pipe_profile_profile_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = 'U',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = 'S',
   abbr_ro = 'N',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3357;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (3210,3210) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 3210;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (387,387) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'biological',
   value_de = 'biologisch',
   value_fr = 'biologique',
   value_it = 'zzz_biologisch',
   value_ro = 'rrr_biologisch',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'biological',
   display_de = 'biologisch',
   display_fr = 'biologique',
   display_it = '',
   display_ro = ''
WHERE code = 387;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (388,388) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'chemical',
   value_de = 'chemisch',
   value_fr = 'chimique',
   value_it = 'zzz_chemisch',
   value_ro = 'rrr_chemisch',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'chemical',
   display_de = 'chemisch',
   display_fr = 'chimique',
   display_it = '',
   display_ro = ''
WHERE code = 388;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (389,389) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'filtration',
   value_de = 'Filtration',
   value_fr = 'filtration',
   value_it = 'zzz_Filtration',
   value_ro = 'rrr_Filtration',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'filtration',
   display_de = 'Filtration',
   display_fr = 'filtration',
   display_it = '',
   display_ro = ''
WHERE code = 389;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (366,366) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'mechanical',
   value_de = 'mechanisch',
   value_fr = 'mecanique',
   value_it = 'zzz_mechanisch',
   value_ro = 'rrr_mechanisch',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'mechanical',
   display_de = 'mechanisch',
   display_fr = 'mécanique',
   display_it = '',
   display_ro = ''
WHERE code = 366;

--- Adapt tww_vl.waste_water_treatment_kind
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode) VALUES (3076,3076) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.waste_water_treatment_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3076;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (141,141) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'aerob_cold',
   value_de = 'aerobkalt',
   value_fr = 'aerobie_froid',
   value_it = 'zzz_aerobkalt',
   value_ro = 'rrr_aerobkalt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'aerob_cold',
   display_de = 'aerobkalt',
   display_fr = 'aerobie_froid',
   display_it = '',
   display_ro = ''
WHERE code = 141;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (332,332) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'aerobthermophil',
   value_de = 'aerobthermophil',
   value_fr = 'aerobie_thermophile',
   value_it = 'zzz_aerobthermophil',
   value_ro = 'rrr_aerobthermophil',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'aerobthermophil',
   display_de = 'aerobthermophil',
   display_fr = 'aerobie_thermophile',
   display_it = '',
   display_ro = ''
WHERE code = 332;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (333,333) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'anaerob_cold',
   value_de = 'anaerobkalt',
   value_fr = 'anaerobie_froid',
   value_it = 'zzz_anaerobkalt',
   value_ro = 'rrr_anaerobkalt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'anaerob_cold',
   display_de = 'anaerobkalt',
   display_fr = 'anaérobie froid',
   display_it = '',
   display_ro = ''
WHERE code = 333;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (334,334) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'anaerob_mesophil',
   value_de = 'anaerobmesophil',
   value_fr = 'anaerobie_mesophile',
   value_it = 'zzz_anaerobmesophil',
   value_ro = 'rrr_anaerobmesophil',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'anaerob_mesophil',
   display_de = 'anaerobmesophil',
   display_fr = 'anaérobie mésophile',
   display_it = '',
   display_ro = ''
WHERE code = 334;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (335,335) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'anaerob_thermophil',
   value_de = 'anaerobthermophil',
   value_fr = 'anaerobie_thermophile',
   value_it = 'zzz_anaerobthermophil',
   value_ro = 'rrr_anaerobthermophil',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'anaerob_thermophil',
   display_de = 'anaerobthermophil',
   display_fr = 'anaérobie thermophile',
   display_it = '',
   display_ro = ''
WHERE code = 335;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (2994,2994) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2994;

--- Adapt tww_vl.sludge_treatment_stabilisation
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode) VALUES (3004,3004) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sludge_treatment_stabilisation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3004;

--- Adapt tww_vl.reach_point_elevation_accuracy
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode) VALUES (3248,3248) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_elevation_accuracy SET
   value_en = 'more_than_6cm',
   value_de = 'groesser_6cm',
   value_fr = 'plusque_6cm',
   value_it = 'piu_6cm',
   value_ro = 'mai_mare_6cm',
   abbr_en = '',
   abbr_de = 'G06',
   abbr_fr = 'S06',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dies ist der Bereich der Höhengenauigkeit aller Punkte, die nur geschätzt sind',
   description_de = 'Dies ist der Bereich der Höhengenauigkeit aller Punkte, die nur geschätzt sind',
   description_fr = 'Fourchette de précision de l''altitude d''un point estimé',
   description_it = 'zzz_Dies ist der Bereich der Höhengenauigkeit aller Punkte, die nur geschätzt sind',
   description_ro = '',
   display_en = 'more_than_6cm',
   display_de = 'groesser_6cm',
   display_fr = 'plus que 6cm',
   display_it = '',
   display_ro = 'mai mare 6cm'
WHERE code = 3248;

--- Adapt tww_vl.reach_point_elevation_accuracy
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode) VALUES (3245,3245) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_elevation_accuracy SET
   value_en = 'plusminus_1cm',
   value_de = 'plusminus_1cm',
   value_fr = 'plus_moins_1cm',
   value_it = 'piu_meno_1cm',
   value_ro = 'plus_minus_1cm',
   abbr_en = '',
   abbr_de = 'P01',
   abbr_fr = 'P01',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dies ist der Bereich der Höhengenauigkeit eines nivellierten Punktes',
   description_de = 'Dies ist der Bereich der Höhengenauigkeit eines nivellierten Punktes',
   description_fr = 'Fourchette de précision de l''altitude d''un point nivelé',
   description_it = 'zzz_Dies ist der Bereich der Höhengenauigkeit eines nivellierten Punktes',
   description_ro = '',
   display_en = 'plusminus_1cm',
   display_de = 'plusminus_1cm',
   display_fr = 'plus moins 1cm',
   display_it = '',
   display_ro = 'plus minus 1cm'
WHERE code = 3245;

--- Adapt tww_vl.reach_point_elevation_accuracy
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode) VALUES (3246,3246) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_elevation_accuracy SET
   value_en = 'plusminus_3cm',
   value_de = 'plusminus_3cm',
   value_fr = 'plus_moins_3cm',
   value_it = 'piu_meno_3cm',
   value_ro = 'plus_minus_3cm',
   abbr_en = '',
   abbr_de = 'P03',
   abbr_fr = 'P03',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dies ist der Bereich der Höhengenauigkeit eines mit GPS eingemessenen Punktes',
   description_de = 'Dies ist der Bereich der Höhengenauigkeit eines mit GPS eingemessenen Punktes',
   description_fr = 'Fourchette de précision de l''altitude d''un point déterminé par GPS',
   description_it = 'zzz_Dies ist der Bereich der Höhengenauigkeit eines mit GPS eingemessenen Punktes',
   description_ro = '',
   display_en = 'plusminus_3cm',
   display_de = 'plusminus_3cm',
   display_fr = 'plus moins 3cm',
   display_it = '',
   display_ro = 'plus minus 3cm'
WHERE code = 3246;

--- Adapt tww_vl.reach_point_elevation_accuracy
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode) VALUES (3247,3247) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_elevation_accuracy SET
   value_en = 'plusminus_6cm',
   value_de = 'plusminus_6cm',
   value_fr = 'plus_moins_6cm',
   value_it = 'piu_meno_6cm',
   value_ro = 'plus_minus_6cm',
   abbr_en = '',
   abbr_de = 'P06',
   abbr_fr = 'P06',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dies ist die Höhengenauigkeit eines mit Vermessungswerkzeugen (Theodolit) eingemessenen Punktes',
   description_de = 'Dies ist die Höhengenauigkeit eines mit Vermessungswerkzeugen (Theodolit) eingemessenen Punktes',
   description_fr = 'Fourchette de précision de l''altitude d''un point déterminé par un instrument de mensuration (théodolite)',
   description_it = 'zzz_Dies ist die Höhengenauigkeit eines mit Vermessungswerkzeugen (Theodolit) eingemessenen Punktes',
   description_ro = '',
   display_en = 'plusminus_6cm',
   display_de = 'plusminus_6cm',
   display_fr = 'plus moins 6cm',
   display_it = '',
   display_ro = 'plus minus 6cm'
WHERE code = 3247;

--- Adapt tww_vl.reach_point_elevation_accuracy
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode) VALUES (5376,5376) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_elevation_accuracy SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5376;

--- Adapt tww_vl.reach_point_outlet_shape
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode) VALUES (5374,5374) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_outlet_shape SET
   value_en = 'round_edged',
   value_de = 'abgerundet',
   value_fr = 'arrondie',
   value_it = 'zzz_abgerundet',
   value_ro = 'rotunjita',
   abbr_en = 'RE',
   abbr_de = 'AR',
   abbr_fr = 'AR',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'round_edged',
   display_de = 'abgerundet',
   display_fr = 'arrondie',
   display_it = '',
   display_ro = 'rotunjita'
WHERE code = 5374;

--- Adapt tww_vl.reach_point_outlet_shape
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode) VALUES (298,298) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_outlet_shape SET
   value_en = 'orifice',
   value_de = 'blendenfoermig',
   value_fr = 'en_forme_de_seuil_ou_diaphragme',
   value_it = 'zzz_blendenfoermig',
   value_ro = 'orificiu',
   abbr_en = 'O',
   abbr_de = 'BF',
   abbr_fr = 'FSD',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'orifice',
   display_de = 'blendenfoermig',
   display_fr = 'en forme de seuil',
   display_it = '',
   display_ro = 'orificiu'
WHERE code = 298;

--- Adapt tww_vl.reach_point_outlet_shape
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode) VALUES (3358,3358) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_outlet_shape SET
   value_en = 'no_cross_section_change',
   value_de = 'keine_Querschnittsaenderung',
   value_fr = 'pas_de_changement_de_section',
   value_it = 'zzz_keine_Querschnittsaenderung',
   value_ro = 'fara_schimbare_sectiune',
   abbr_en = '',
   abbr_de = 'KQ',
   abbr_fr = 'PCS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_cross_section_change',
   display_de = 'keine_Querschnittsaenderung',
   display_fr = 'pas de changement de section',
   display_it = '',
   display_ro = 'fara schimbare sectiune'
WHERE code = 3358;

--- Adapt tww_vl.reach_point_outlet_shape
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode) VALUES (286,286) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_outlet_shape SET
   value_en = 'sharp_edged',
   value_de = 'scharfkantig',
   value_fr = 'aretes_vives',
   value_it = 'zzz_scharfkantig',
   value_ro = 'margini_ascutite',
   abbr_en = '',
   abbr_de = 'SK',
   abbr_fr = 'AV',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sharp_edged',
   display_de = 'scharfkantig',
   display_fr = 'arêtes vives',
   display_it = '',
   display_ro = 'margini ascutite'
WHERE code = 286;

--- Adapt tww_vl.reach_point_outlet_shape
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode) VALUES (5375,5375) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_outlet_shape SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5375;

--- Adapt tww_vl.reach_point_pipe_closure
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode) VALUES (8999,8999) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_pipe_closure SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 8999;

--- Adapt tww_vl.reach_point_pipe_closure
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode) VALUES (9000,9000) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_pipe_closure SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 9000;

--- Adapt tww_vl.reach_point_pipe_closure
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode) VALUES (9001,9001) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_point_pipe_closure SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9001;

--- Adapt tww_vl.wastewater_node_elevation_accuracy
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode) VALUES (9061,9061) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_elevation_accuracy SET
   value_en = 'more_than_6cm',
   value_de = 'groesser_6cm',
   value_fr = 'plusque_6cm',
   value_it = 'piu_6cm',
   value_ro = 'mai_mare_6cm',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'more_than_6cm',
   display_de = 'groesser_6cm',
   display_fr = 'plusque 6cm',
   display_it = '',
   display_ro = 'mai mare 6cm'
WHERE code = 9061;

--- Adapt tww_vl.wastewater_node_elevation_accuracy
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode) VALUES (9062,9062) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_elevation_accuracy SET
   value_en = 'plusminus_1cm',
   value_de = 'plusminus_1cm',
   value_fr = 'plus_moins_1cm',
   value_it = 'piu_meno_1cm',
   value_ro = 'plus_minus_1cm',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_1cm',
   display_de = 'plusminus_1cm',
   display_fr = 'plus moins 1cm',
   display_it = '',
   display_ro = ''
WHERE code = 9062;

--- Adapt tww_vl.wastewater_node_elevation_accuracy
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode) VALUES (9063,9063) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_elevation_accuracy SET
   value_en = 'plusminus_3cm',
   value_de = 'plusminus_3cm',
   value_fr = 'plus_moins_3cm',
   value_it = 'piu_meno_3cm',
   value_ro = 'plus_minus_3cm',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_3cm',
   display_de = 'plusminus_3cm',
   display_fr = 'plus moins 3cm',
   display_it = '',
   display_ro = ''
WHERE code = 9063;

--- Adapt tww_vl.wastewater_node_elevation_accuracy
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode) VALUES (9064,9064) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_elevation_accuracy SET
   value_en = 'plusminus_6cm',
   value_de = 'plusminus_6cm',
   value_fr = 'plus_moins_6cm',
   value_it = 'piu_meno_6cm',
   value_ro = 'plus_minus_6cm',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_6cm',
   display_de = 'plusminus_6cm',
   display_fr = 'plus moins 6cm',
   display_it = '',
   display_ro = ''
WHERE code = 9064;

--- Adapt tww_vl.wastewater_node_elevation_accuracy
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode) VALUES (9060,9060) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_elevation_accuracy SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9060;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (4621,4621) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'slope_change',
   value_de = 'Gefaellsbruch',
   value_fr = 'changement_de_pente',
   value_it = 'zzz_Gefaellsbruch',
   value_ro = 'rrr_Gefaellsbruch',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'slope_change',
   display_de = 'Gefaellsbruch',
   display_fr = 'changement de pente',
   display_it = '',
   display_ro = ''
WHERE code = 4621;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (9083,9083) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'slope_caliber_change',
   value_de = 'Gefaellsbruch_Kaliberwechsel',
   value_fr = 'changement_de_pente_et_calibre',
   value_it = 'zzz_Gefaellsbruch_Kaliberwechsel',
   value_ro = 'rrr_Gefaellsbruch_Kaliberwechsel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'slope_caliber_change',
   display_de = 'Gefaellsbruch_Kaliberwechsel',
   display_fr = 'changement de pente et calibre',
   display_it = '',
   display_ro = ''
WHERE code = 9083;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (4623,4623) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'change_of_diameter',
   value_de = 'Kaliberwechsel',
   value_fr = 'changement_de_calibre',
   value_it = 'zzz_Kaliberwechsel',
   value_ro = 'rr_Kaliberwechsel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'change_of_diameter',
   display_de = 'Kaliberwechsel',
   display_fr = 'changement de calibre',
   display_it = '',
   display_ro = ''
WHERE code = 4623;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (4622,4622) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'standard_manhole',
   value_de = 'Normschacht',
   value_fr = 'chambre_standard',
   value_it = 'zzz_Normschacht',
   value_ro = 'rrr_Normschacht',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'standard_manhole',
   display_de = 'Normschacht',
   display_fr = 'chambre standard',
   display_it = '',
   display_ro = ''
WHERE code = 4622;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (9084,9084) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'standard_manhole_slope_change',
   value_de = 'Normschacht_Gefaellsbruch',
   value_fr = 'chambre_standard_changement_de_pente',
   value_it = 'zzz_Normschacht_Gefaellsbruch',
   value_ro = 'rrr_Normschacht_Gefaellsbruch',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'standard_manhole_slope_change',
   display_de = 'Normschacht_Gefaellsbruch',
   display_fr = 'chambre standard changement de pente',
   display_it = '',
   display_ro = ''
WHERE code = 9084;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (9086,9086) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'standard_manhole_slope_caliber_change',
   value_de = 'Normschacht_Gefaellsbruch_Kaliberwechsel',
   value_fr = 'chambre_standard_changement_de_pente_et_calibre',
   value_it = 'zzz_Normschacht_Gefaellsbruch_Kaliberwechsel',
   value_ro = 'rrr_Normschacht_Gefaellsbruch_Kaliberwechsel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'standard_manhole_slope_caliber_change',
   display_de = 'Normschacht_Gefaellsbruch_Kaliberwechsel',
   display_fr = 'chambre standard changement de pente et calibre',
   display_it = '',
   display_ro = ''
WHERE code = 9086;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (9085,9085) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'standard_manhole_caliber_change',
   value_de = 'Normschacht_Kaliberwechsel',
   value_fr = 'chambre_standard_changement_de_calibre',
   value_it = 'zzz_Normschacht_Kaliberwechsel',
   value_ro = 'rrr_Normschacht_Kaliberwechsel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'standard_manhole_caliber_change',
   display_de = 'Normschacht_Kaliberwechsel',
   display_fr = 'chambre standard changement de calibre',
   display_it = '',
   display_ro = ''
WHERE code = 9085;

--- Adapt tww_vl.wastewater_node_function_node_amelioration
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode) VALUES (4620,4620) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_node_function_node_amelioration SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 4620;

--- Adapt tww_vl.reach_elevation_determination
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode) VALUES (4780,4780) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_elevation_determination SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precise',
   value_it = 'precisa',
   value_ro = 'precisa',
   abbr_en = '',
   abbr_de = 'LG',
   abbr_fr = 'P',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_mittlerer Fehler: Sigma <= +/- 6 cm, Toleranz 3*Sigma <= +/- 18 cm',
   description_de = 'Mittlerer Fehler: Sigma <= +/- 6 cm, Toleranz 3*Sigma <= +/- 18 cm für Abwasser',
   description_fr = '+/- 6 cm, lors de la détermination du tracé par différentes mesures, le triple, c''est-à-dire +/- 18 cm',
   description_it = 'zzz_Mittlerer Fehler: Sigma <= +/- 6 cm, Toleranz 3*Sigma <= +/- 18 cm',
   description_ro = '+/- 6 cm , la stabilirea traseului prin diverse masuratori se introduce triplu, adica +/- 18 cm',
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précise',
   display_it = '',
   display_ro = 'precisa'
WHERE code = 4780;

--- Adapt tww_vl.reach_elevation_determination
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode) VALUES (4778,4778) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_elevation_determination SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 4778;

--- Adapt tww_vl.reach_elevation_determination
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode) VALUES (4779,4779) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_elevation_determination SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecise',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
   abbr_en = '',
   abbr_de = 'LU',
   abbr_fr = 'IP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'see precise',
   description_de = 'Siehe genau',
   description_fr = 'voir sous précis',
   description_it = 'zzz_Siehe genau',
   description_ro = 'in afara intervalului de la precisa',
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprécise',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 4779;

--- Adapt tww_vl.reach_horizontal_positioning
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode) VALUES (5378,5378) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_horizontal_positioning SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precise',
   value_it = 'precisa',
   value_ro = 'precisa',
   abbr_en = '',
   abbr_de = 'LG',
   abbr_fr = 'P',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_+/- 10 cm, bei der Lagebestimmung aus unterschiedlichen Messungen das Dreifache, d.h. +/- 30 cm (Norm SIA405)',
   description_de = '+/- 10 cm, bei der Lagebestimmung aus unterschiedlichen Messungen das Dreifache, d.h. +/- 30 cm (Norm SIA405)',
   description_fr = '+/- 10 cm, lors de la détermination du tracé par différentes mesures, le triple, c''est-à-dire +/- 30 cm (norme SIA 405 1998, point 4 23 3)',
   description_it = '+/- 10 cm, il triplo nel caso di determinazioni planimetrica con differenti misura, ovvero +/- 30 cm (norma SIA405)',
   description_ro = '+/- 10 cm , la stabilirea traseului prin diverse masuratori se introduce triplu, adica +/- 30 cm',
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précise',
   display_it = '',
   display_ro = 'precisa'
WHERE code = 5378;

--- Adapt tww_vl.reach_horizontal_positioning
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode) VALUES (5379,5379) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_horizontal_positioning SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5379;

--- Adapt tww_vl.reach_horizontal_positioning
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode) VALUES (5380,5380) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_horizontal_positioning SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecise',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
   abbr_en = '',
   abbr_de = 'LU',
   abbr_fr = 'IP',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'see accurate',
   description_de = 'Siehe genau',
   description_fr = 'voir precise',
   description_it = 'Vedi preciso',
   description_ro = 'in afara intervalului de la precisa',
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprécise',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 5380;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (5383,5383) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5383;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (248,248) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'coating',
   value_de = 'Anstrich_Beschichtung',
   value_fr = 'peinture_revetement',
   value_it = 'zzz_Anstrich_Beschichtung',
   value_ro = 'strat_vopsea',
   abbr_en = 'C',
   abbr_de = 'B',
   abbr_fr = 'PR',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'coating',
   display_de = 'Anstrich_Beschichtung',
   display_fr = 'peinture/revêtement',
   display_it = '',
   display_ro = 'strat vopsea'
WHERE code = 248;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (250,250) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'brick_lining',
   value_de = 'Kanalklinkerauskleidung',
   value_fr = 'revetement_en_brique',
   value_it = 'zzz_Kanalklinkerauskleidung',
   value_ro = 'strat_caramida',
   abbr_en = '',
   abbr_de = 'KL',
   abbr_fr = 'RB',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'brick_lining',
   display_de = 'Kanalklinkerauskleidung',
   display_fr = 'revêtement en brique',
   display_it = '',
   display_ro = 'strat caramida'
WHERE code = 250;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (251,251) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'stoneware_lining',
   value_de = 'Steinzeugauskleidung',
   value_fr = 'revetement_en_gres',
   value_it = 'zzz_Steinzeugauskleidung',
   value_ro = 'strat_gresie',
   abbr_en = '',
   abbr_de = 'ST',
   abbr_fr = 'RG',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'stoneware_lining',
   display_de = 'Steinzeugauskleidung',
   display_fr = 'revêtement en grès',
   display_it = '',
   display_ro = 'strat gresie'
WHERE code = 251;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (5384,5384) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5384;

--- Adapt tww_vl.reach_inside_coating
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode) VALUES (249,249) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_inside_coating SET
   value_en = 'cement_mortar_lining',
   value_de = 'Zementmoertelauskleidung',
   value_fr = 'revetement_en_mortier_de_ciment',
   value_it = 'zzz_Zementmoertelauskleidung',
   value_ro = 'strat_mortar_ciment',
   abbr_en = '',
   abbr_de = 'ZM',
   abbr_fr = 'RM',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cement_mortar_lining',
   display_de = 'Zementmoertelauskleidung',
   display_fr = 'revêtement en mortier de ciment',
   display_it = '',
   display_ro = 'strat mortar ciment'
WHERE code = 249;

--- Adapt tww_vl.reach_leak_protection
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode) VALUES (8710,8710) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_leak_protection SET
   value_en = 'inexistent',
   value_de = 'nicht_vorhanden',
   value_fr = 'inexistant',
   value_it = 'non_presente',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inexistent',
   display_de = 'nicht_vorhanden',
   display_fr = 'inexistant',
   display_it = '',
   display_ro = ''
WHERE code = 8710;

--- Adapt tww_vl.reach_leak_protection
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode) VALUES (8711,8711) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_leak_protection SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8711;

--- Adapt tww_vl.reach_leak_protection
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode) VALUES (8709,8709) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_leak_protection SET
   value_en = 'existent',
   value_de = 'vorhanden',
   value_fr = 'existant',
   value_it = 'presente',
   value_ro = 'existent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'existent',
   display_de = 'vorhanden',
   display_fr = 'existant',
   display_it = '',
   display_ro = ''
WHERE code = 8709;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5381,5381) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = 'A',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5381;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (2754,2754) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'asbestos_cement',
   value_de = 'Asbestzement',
   value_fr = 'amiante_ciment',
   value_it = 'cemento_amianto',
   value_ro = 'azbociment',
   abbr_en = 'AC',
   abbr_de = 'AZ',
   abbr_fr = 'AC',
   abbr_it = 'CA',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'asbestos_cement',
   display_de = 'Asbestzement',
   display_fr = 'amiante ciment',
   display_it = '',
   display_ro = 'azbociment'
WHERE code = 2754;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3638,3638) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'concrete_normal',
   value_de = 'Beton_Normalbeton',
   value_fr = 'beton_normal',
   value_it = 'calcestruzzo_normale',
   value_ro = 'beton_normal',
   abbr_en = 'CN',
   abbr_de = 'NB',
   abbr_fr = 'BN',
   abbr_it = 'CN',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete_normal',
   display_de = 'Beton_Normalbeton',
   display_fr = 'béton normal',
   display_it = '',
   display_ro = 'beton normal'
WHERE code = 3638;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3639,3639) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'concrete_insitu',
   value_de = 'Beton_Ortsbeton',
   value_fr = 'beton_coule_sur_place',
   value_it = 'calcestruzzo_gettato_opera',
   value_ro = 'beton_turnat_insitu',
   abbr_en = 'CI',
   abbr_de = 'OB',
   abbr_fr = 'BCP',
   abbr_it = 'CGO',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete_insitu',
   display_de = 'Beton_Ortsbeton',
   display_fr = 'béton coulé sur place',
   display_it = '',
   display_ro = 'beton turnat insitu'
WHERE code = 3639;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3640,3640) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'concrete_presspipe',
   value_de = 'Beton_Pressrohrbeton',
   value_fr = 'beton_pousse_tube',
   value_it = 'calcestruzzo_spingitubo',
   value_ro = 'beton_presstube',
   abbr_en = 'CP',
   abbr_de = 'PRB',
   abbr_fr = 'BPT',
   abbr_it = 'CST',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = 'conducta a fost impinsa cu ajutorul unui presstube iar materialul trebuie sa aibe standardul care sa sustina aceasta operatiune fara a fi specificat explicit',
   display_en = 'concrete_presspipe',
   display_de = 'Beton_Pressrohrbeton',
   display_fr = 'béton pousse tube',
   display_it = '',
   display_ro = 'beton presstube'
WHERE code = 3640;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3641,3641) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'concrete_special',
   value_de = 'Beton_Spezialbeton',
   value_fr = 'beton_special',
   value_it = 'calcestruzzo_speciale',
   value_ro = 'beton_special',
   abbr_en = 'CS',
   abbr_de = 'SB',
   abbr_fr = 'BS',
   abbr_it = 'CS',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete_special',
   display_de = 'Beton_Spezialbeton',
   display_fr = 'béton spécial',
   display_it = '',
   display_ro = 'beton special'
WHERE code = 3641;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3256,3256) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'concrete_unknown',
   value_de = 'Beton_unbekannt',
   value_fr = 'beton_inconnu',
   value_it = 'calcestruzzo_sconosciuto',
   value_ro = 'beton_necunoscut',
   abbr_en = 'CU',
   abbr_de = 'BU',
   abbr_fr = 'BI',
   abbr_it = 'CSC',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete_unknown',
   display_de = 'Beton_unbekannt',
   display_fr = 'béton inconnu',
   display_it = '',
   display_ro = 'beton necunoscut'
WHERE code = 3256;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (147,147) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'fiber_cement',
   value_de = 'Faserzement',
   value_fr = 'fibrociment',
   value_it = 'fibrocemento',
   value_ro = 'fibrociment',
   abbr_en = 'FC',
   abbr_de = 'FZ',
   abbr_fr = 'FC',
   abbr_it = 'FC',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'fiber_cement',
   display_de = 'Faserzement',
   display_fr = 'fibrociment',
   display_it = '',
   display_ro = 'fibrociment'
WHERE code = 147;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (2755,2755) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'bricks',
   value_de = 'Gebrannte_Steine',
   value_fr = 'terre_cuite',
   value_it = 'ceramica',
   value_ro = 'teracota',
   abbr_en = 'BR',
   abbr_de = 'SG',
   abbr_fr = 'TC',
   abbr_it = 'CE',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'bricks',
   display_de = 'Gebrannte_Steine',
   display_fr = 'terre cuite',
   display_it = '',
   display_ro = 'teracota'
WHERE code = 2755;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (148,148) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'cast_ductile_iron',
   value_de = 'Guss_duktil',
   value_fr = 'fonte_ductile',
   value_it = 'ghisa_duttile',
   value_ro = 'fonta_ductila',
   abbr_en = 'ID',
   abbr_de = 'GD',
   abbr_fr = 'FD',
   abbr_it = 'GD',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cast_ductile_iron',
   display_de = 'Guss_duktil',
   display_fr = 'fonte ductile',
   display_it = '',
   display_ro = 'fonta ductila'
WHERE code = 148;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3648,3648) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'cast_gray_iron',
   value_de = 'Guss_Grauguss',
   value_fr = 'fonte_grise',
   value_it = 'ghisa_grigia',
   value_ro = 'fonta_cenusie',
   abbr_en = 'CGI',
   abbr_de = 'GG',
   abbr_fr = 'FG',
   abbr_it = 'GG',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cast_gray_iron',
   display_de = 'Guss_Grauguss',
   display_fr = 'fonte grise',
   display_it = '',
   display_ro = 'fonta cenusie'
WHERE code = 3648;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5076,5076) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_epoxy_resin',
   value_de = 'Kunststoff_Epoxydharz',
   value_fr = 'matiere_synthetique_resine_d_epoxy',
   value_it = 'materiale_sintetico_resina_epossidica',
   value_ro = 'plastic_rasina_epoxi',
   abbr_en = 'PER',
   abbr_de = 'EP',
   abbr_fr = 'EP',
   abbr_it = 'MSR',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic_epoxy_resin',
   display_de = 'Kunststoff_Epoxydharz',
   display_fr = 'matière synthétique resine d''epoxy',
   display_it = '',
   display_ro = 'plastic rasina epoxi'
WHERE code = 5076;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5077,5077) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_highdensity_polyethylene',
   value_de = 'Kunststoff_Hartpolyethylen',
   value_fr = 'matiere_synthetique_polyethylene_dur',
   value_it = 'materiale_sintetico_polietilene_duro',
   value_ro = 'plastic_PEHD',
   abbr_en = 'HPE',
   abbr_de = 'HPE',
   abbr_fr = 'PD',
   abbr_it = 'MSP',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic_highdensity_polyethylene',
   display_de = 'Kunststoff_Hartpolyethylen',
   display_fr = 'matière synthétique polyéthylène dur',
   display_it = '',
   display_ro = 'plastic PEHD'
WHERE code = 5077;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5078,5078) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_polyester_GUP',
   value_de = 'Kunststoff_Polyester_GUP',
   value_fr = 'matiere_synthetique_polyester_PRV',
   value_it = 'materiale_sintetico_poliestere_GUP',
   value_ro = 'plastic_poliester_GUP',
   abbr_en = 'GUP',
   abbr_de = 'GUP',
   abbr_fr = 'GUP',
   abbr_it = 'GUP',
   abbr_ro = '',
   description_en = 'GUP: glass fibre reinforced unsaturated polyester',
   description_de = 'GUP: glass fibre reinforced unsaturated polyester',
   description_fr = 'PRV: polyester renforcé de fibre de verre',
   description_it = 'GUP: glass fibre reinforced unsaturated polyester',
   description_ro = 'GUP: glass fibre reinforced unsaturated polyester',
   display_en = 'plastic_polyester_GUP',
   display_de = 'Kunststoff_Polyester_GUP',
   display_fr = 'matière synthétique polyester GUP',
   display_it = '',
   display_ro = 'plastic poliester GUP'
WHERE code = 5078;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5079,5079) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_polyethylene',
   value_de = 'Kunststoff_Polyethylen',
   value_fr = 'matiere_synthetique_polyethylene',
   value_it = 'materiale_sintetico_polietilene',
   value_ro = 'plastic_PE',
   abbr_en = 'PE',
   abbr_de = 'PE',
   abbr_fr = 'PE',
   abbr_it = 'PE',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic_polyethylene',
   display_de = 'Kunststoff_Polyethylen',
   display_fr = 'matière synthétique polyéthylène',
   display_it = '',
   display_ro = 'plastic PE'
WHERE code = 5079;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5080,5080) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_polypropylene',
   value_de = 'Kunststoff_Polypropylen',
   value_fr = 'matiere_synthetique_polypropylene',
   value_it = 'materiale_sintetico_polipropilene',
   value_ro = 'plastic_polipropilena',
   abbr_en = 'PP',
   abbr_de = 'PP',
   abbr_fr = 'PP',
   abbr_it = 'PP',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic_polypropylene',
   display_de = 'Kunststoff_Polypropylen',
   display_fr = 'matière synthétique polypropylène',
   display_it = '',
   display_ro = 'plastic polipropilena'
WHERE code = 5080;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5081,5081) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_PVC',
   value_de = 'Kunststoff_Polyvinilchlorid',
   value_fr = 'matiere_synthetique_PVC',
   value_it = 'materiale_sintetico_PVC',
   value_ro = 'plastic_PVC',
   abbr_en = 'PVC',
   abbr_de = 'PVC',
   abbr_fr = 'PVC',
   abbr_it = 'PVC',
   abbr_ro = '',
   description_en = 'yyy_Ein Polymerisatkunstoff, der hart, weich oder niedrig­molekular eingestellt werden kann. In der Abwassertechnik als Rohstoff für Rohre verwendet. (arb)',
   description_de = 'Ein Polymerisatkunststoff, der hart, weich oder niedrig-molekular eingestellt werden kann. In der Abwassertechnik als Rohstoff für Rohre verwendet. (arb)',
   description_fr = 'polychlorure de vinyle',
   description_it = 'Policloruro di vinile',
   description_ro = 'Policlorura de vinil',
   display_en = 'plastic_PVC',
   display_de = 'Kunststoff_Polyvinilchlorid',
   display_fr = 'matière synthétique PVC',
   display_it = '',
   display_ro = 'plastic PVC'
WHERE code = 5081;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (5382,5382) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'plastic_unknown',
   value_de = 'Kunststoff_unbekannt',
   value_fr = 'matiere_synthetique_inconnue',
   value_it = 'materiale_sintetico_sconosciuto',
   value_ro = 'plastic_necunoscut',
   abbr_en = 'PU',
   abbr_de = 'KUU',
   abbr_fr = 'MSI',
   abbr_it = 'MSC',
   abbr_ro = '',
   description_en = 'yyy_Kunststoff unbekannter Art',
   description_de = 'Kunststoff unbekannter Art',
   description_fr = 'matière synthétique inconnu',
   description_it = 'Materiale sintetico sconosciuto',
   description_ro = '',
   display_en = 'plastic_unknown',
   display_de = 'Kunststoff_unbekannt',
   display_fr = 'matière synthétique inconnue',
   display_it = '',
   display_ro = 'plastic necunoscut'
WHERE code = 5382;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (153,153) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'steel',
   value_de = 'Stahl',
   value_fr = 'acier',
   value_it = 'acciaio',
   value_ro = 'otel',
   abbr_en = 'ST',
   abbr_de = 'ST',
   abbr_fr = 'AC',
   abbr_it = 'AC',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'steel',
   display_de = 'Stahl',
   display_fr = 'acier',
   display_it = '',
   display_ro = 'otel'
WHERE code = 153;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3654,3654) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'steel_stainless',
   value_de = 'Stahl_rostfrei',
   value_fr = 'acier_inoxydable',
   value_it = 'acciaio_inossidabile',
   value_ro = 'inox',
   abbr_en = 'SST',
   abbr_de = 'STI',
   abbr_fr = 'ACI',
   abbr_it = 'ACI',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'steel_stainless',
   display_de = 'Stahl_rostfrei',
   display_fr = 'acier inoxydable',
   display_it = '',
   display_ro = 'inox'
WHERE code = 3654;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (154,154) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'stoneware',
   value_de = 'Steinzeug',
   value_fr = 'gres',
   value_it = 'gres',
   value_ro = 'gresie',
   abbr_en = 'SW',
   abbr_de = 'STZ',
   abbr_fr = 'GR',
   abbr_it = 'GR',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'stoneware',
   display_de = 'Steinzeug',
   display_fr = 'grès',
   display_it = '',
   display_ro = 'gresie'
WHERE code = 154;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (2761,2761) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'clay',
   value_de = 'Ton',
   value_fr = 'argile',
   value_it = 'argilla',
   value_ro = 'argila',
   abbr_en = 'CL',
   abbr_de = 'T',
   abbr_fr = 'AR',
   abbr_it = 'AR',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'clay',
   display_de = 'Ton',
   display_fr = 'argile',
   display_it = '',
   display_ro = 'argila'
WHERE code = 2761;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (3016,3016) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = 'U',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = 'SC',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3016;

--- Adapt tww_vl.reach_material
 INSERT INTO tww_vl.reach_material (code, vsacode) VALUES (2762,2762) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_material SET
   value_en = 'cement',
   value_de = 'Zement',
   value_fr = 'ciment',
   value_it = 'cemento',
   value_ro = 'ciment',
   abbr_en = 'C',
   abbr_de = 'Z',
   abbr_fr = 'C',
   abbr_it = 'C',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cement',
   display_de = 'Zement',
   display_fr = 'ciment',
   display_it = '',
   display_ro = 'ciment'
WHERE code = 2762;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6459,6459) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 6459;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6461,6461) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'epoxy_resin_glass_fibre_laminate',
   value_de = 'Epoxidharz_Glasfaserlaminat',
   value_fr = 'resine_epoxy_lamine_en_fibre_de_verre',
   value_it = 'zzz_Epoxidharz_Glasfaserlaminat',
   value_ro = 'rasina_epoxi_laminata_in_fibra_de_sticla',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'epoxy resin glass fibre laminate',
   description_de = 'Epoxidharz Glasfaserlaminat',
   description_fr = 'résine epoxy lamine en fibre de verre',
   description_it = 'zzz_Epoxidharz_Glasfaserlaminat',
   description_ro = '',
   display_en = 'epoxy_resin_glass_fibre_laminate',
   display_de = 'Epoxidharz_Glasfaserlaminat',
   display_fr = 'résine époxy lamine en fibre de verre',
   display_it = '',
   display_ro = 'rasina epoxi laminata in fibra de sticla'
WHERE code = 6461;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6460,6460) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'epoxy_resin_plastic_felt',
   value_de = 'Epoxidharz_Kunststofffilz',
   value_fr = 'resine_epoxy_feutre_synthetique',
   value_it = 'zzz_Epoxidharz_Kunststofffilz',
   value_ro = 'rasina_epoxi_asemanatoare_plastic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'epoxy resin plastic_felt',
   description_de = 'Epoxidharz Kunststofffilz',
   description_fr = 'résine epoxy feutre synthetique',
   description_it = 'zzz_Epoxidharz_Kunststofffilz',
   description_ro = '',
   display_en = 'epoxy_resin_plastic_felt',
   display_de = 'Epoxidharz_Kunststofffilz',
   display_fr = 'résine époxy feutre synthétique',
   display_it = '',
   display_ro = 'rasina epoxi asemanatoare plastic'
WHERE code = 6460;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6483,6483) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'GUP_pipe',
   value_de = 'GUP_Rohr',
   value_fr = 'tuyau_PRV',
   value_it = 'zzz_GUP_Rohr',
   value_ro = 'conducta_PAFS',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '	glass fiber reinforced unsaturated polyester (GUP)',
   description_de = 'Rohr aus glasfaserverstärktem, ungesättigtem Polyester : GUP oder GF-UP',
   description_fr = 'Polyester 	non saturé renforcé de fibres de verre (PRV),  tuyau HOBAS.  En allemand GF-UP',
   description_it = 'zzz_glasfaserverstärkten, ungesättigtem Polyester : GUP oder GF-UP',
   description_ro = 'poliester armat cu fibra de sticla',
   display_en = 'GUP_pipe',
   display_de = 'GUP_Rohr',
   display_fr = '',
   display_it = '',
   display_ro = 'conducta PAFS'
WHERE code = 6483;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6462,6462) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'HDPE',
   value_de = 'HDPE',
   value_fr = 'HDPE',
   value_it = 'HDPE',
   value_ro = 'PEHD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'HDPE',
   display_de = 'HDPE',
   display_fr = 'HDPE',
   display_it = 'HDPE',
   display_ro = 'PEHD'
WHERE code = 6462;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6484,6484) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'isocyanate_resin_glass_fibre_laminate',
   value_de = 'Isocyanatharze_Glasfaserlaminat',
   value_fr = 'isocyanat_resine_lamine_en_fibre_de_verre',
   value_it = 'zzz_Isocynatharze_Glasfaserlaminat',
   value_ro = 'izocianat_rasina_laminat_in_fibra_sticla',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'isocyanate resin glass fibre laminate',
   description_de = 'Isocynatharze Glasfaserlaminat',
   description_fr = 'isocyanat résine lamine en fibre de verre',
   description_it = 'zzz_Isocynatharze_Glasfaserlaminat',
   description_ro = '',
   display_en = 'isocyanate_resin_glass_fibre_laminate',
   display_de = 'Isocyanatharze_Glasfaserlaminat',
   display_fr = '',
   display_it = '',
   display_ro = 'izocianat rasina laminat in fibra sticla'
WHERE code = 6484;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6485,6485) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'isocyanate_resin_plastic_felt',
   value_de = 'Isocyanatharze_Kunststofffilz',
   value_fr = 'isocyanat_resine_lamine_feutre_synthetique',
   value_it = 'zzz_Isocynatharze_Kunststofffilz',
   value_ro = 'izocianat_rasina_laminat_asemanatoare_plastic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'isocyanate resin plastic felt',
   description_de = 'Isocyanatharze_Kunststofffilz',
   description_fr = 'isocyanat résine lamine feutre synthetique',
   description_it = 'zzz_Isocynatharze_Kunststofffilz',
   description_ro = '',
   display_en = 'isocyanate_resin_plastic_felt',
   display_de = 'Isocyanatharze_Kunststofffilz',
   display_fr = '',
   display_it = '',
   display_ro = 'izocianat rasina laminat asemanatoare plastic'
WHERE code = 6485;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6464,6464) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'polyester_resin_glass_fibre_laminate',
   value_de = 'Polyesterharz_Glasfaserlaminat',
   value_fr = 'resine_de_polyester_lamine_en_fibre_de_verre',
   value_it = 'zzz_Polyesterharz_Glasfaserlaminat',
   value_ro = 'rasina_de_poliester_laminata_in_fibra_de_sticla',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'polyester resin glass fibre laminate',
   description_de = 'Polyesterharz Glasfaserlaminat',
   description_fr = 'résine de polyester lamine en fibre de verre',
   description_it = '',
   description_ro = '',
   display_en = 'polyester_resin_glass_fibre_laminate',
   display_de = 'Polyesterharz_Glasfaserlaminat',
   display_fr = 'résine de polyester lamine en fibre de verre',
   display_it = '',
   display_ro = 'rasina de poliester laminata in fibra de sticla'
WHERE code = 6464;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6463,6463) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'polyester_resin_plastic_felt',
   value_de = 'Polyesterharz_Kunststofffilz',
   value_fr = 'resine_de_polyester_feutre_synthetique',
   value_it = 'zzz_Polyesterharz_Kunststofffilz',
   value_ro = 'rasina_poliester_asemanatare_plastic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'polyester resin plastic felt',
   description_de = 'Polyesterharz Kunststofffilz',
   description_fr = 'résine de polyester feutre synthetique',
   description_it = 'zzz_Polyesterharz_Kunststofffilz',
   description_ro = '',
   display_en = 'polyester_resin_plastic_felt',
   display_de = 'Polyesterharz_Kunststofffilz',
   display_fr = 'résine de polyester feutre synthétique',
   display_it = '',
   display_ro = 'rasina poliester asemanatare plastic'
WHERE code = 6463;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6482,6482) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'polypropylene',
   value_de = 'Polypropylen',
   value_fr = 'polypropylene',
   value_it = 'polipropilene',
   value_ro = 'polipropilena',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'polypropylene',
   display_de = 'Polypropylen',
   display_fr = 'polypropylène',
   display_it = '',
   display_ro = 'polipropilena'
WHERE code = 6482;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6465,6465) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'PVC',
   value_de = 'Polyvinilchlorid',
   value_fr = 'PVC',
   value_it = 'zzz_Polyvinilchlorid',
   value_ro = 'PVC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'PVC',
   display_de = 'Polyvinilchlorid',
   display_fr = 'PVC',
   display_it = '',
   display_ro = 'PVC'
WHERE code = 6465;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6466,6466) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'bottom_with_polyester_concret_shell',
   value_de = 'Sohle_mit_Schale_aus_Polyesterbeton',
   value_fr = 'radier_avec_pellicule_en_beton_polyester',
   value_it = 'zzz_Sohle_mit_Schale_aus_Polyesterbeton',
   value_ro = 'radier_cu_pelicula_din_beton_poliester',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'bottom with polyester concret shell',
   description_de = 'Sohle mit Schale aus Polyesterbeton',
   description_fr = 'radier avec pellicule en béton polyester',
   description_it = 'zzz_Sohle_mit_Schale_aus_Polyesterbeton',
   description_ro = '',
   display_en = 'bottom_with_polyester_concret_shell',
   display_de = 'Sohle_mit_Schale_aus_Polyesterbeton',
   display_fr = 'radier avec péllicule en béton polyester',
   display_it = '',
   display_ro = 'radier cu pelicula din beton poliester'
WHERE code = 6466;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6467,6467) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 6467;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6486,6486) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'UP_resin_LED_synthetic_fibre_liner',
   value_de = 'UP_Harz_LED_Synthesefaserliner',
   value_fr = 'UP_resine_LED_fibre_synthetiques_liner',
   value_it = 'zzz_UP_Harz_LED_Synthesefaserliner',
   value_ro = 'rasina_UP_LED_captuseala_fibra_sintetica',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'synthetic fibre liner with unsaturated polyester resin (UP resin), tempering with UV-LED',
   description_de = 'Synthesefaserliner mit ungesättigtes Polyesterharz (UP Harz), Härtung mit UV-LED',
   description_fr = 'Fibre synthetiques liner 	avec résine polyester non saturé (UP résine) UP, durcissement avec UV-LED',
   description_it = 'zzz_Synthesefaserliner mit ungesättigtes Polyesterharz (UP Harz), Härtung mit UV-LED',
   description_ro = 'captuseala din fibra sintetica cu rasina de poliester nesaturata, calita cu LED-UV',
   display_en = 'UP_resin_LED_synthetic_fibre_liner',
   display_de = 'UP_Harz_LED_Synthesefaserliner',
   display_fr = '',
   display_it = '',
   display_ro = 'rasina UP LED captuseala fibra sintetica'
WHERE code = 6486;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6468,6468) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'vinyl_ester_resin_glass_fibre_laminate',
   value_de = 'Vinylesterharz_Glasfaserlaminat',
   value_fr = 'resine_d_ester_vinylique_lamine_en_fibre_de_verre',
   value_it = 'zzz_Vinylesterharz_Glasfaserlaminat',
   value_ro = 'rasina_de_ester_vinil_laminata_in_fibra_de_sticla',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'vinyl ester resin glass fibre laminate',
   description_de = 'Vinylesterharz Glasfaserlaminat',
   description_fr = 'Résine d''ester vinylique lamine en fibre de verre',
   description_it = 'zzz_Vinylesterharz Glasfaserlaminat',
   description_ro = '',
   display_en = 'vinyl_ester_resin_glass_fibre_laminate',
   display_de = 'Vinylesterharz_Glasfaserlaminat',
   display_fr = 'résine d''éster vinylique lamine en fibre de verre',
   display_it = '',
   display_ro = 'rasina de ester vinil laminata in fibra de sticla'
WHERE code = 6468;

--- Adapt tww_vl.reach_reliner_material
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode) VALUES (6469,6469) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_reliner_material SET
   value_en = 'vinyl_ester_resin_plastic_felt',
   value_de = 'Vinylesterharz_Kunststofffilz',
   value_fr = 'resine_d_ester_vinylique_feutre_synthetique',
   value_it = 'zzz_Vinylesterharz_Kunststofffilz',
   value_ro = 'rasina_de_ester_vinil',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'vinyl ester resin plastic felt',
   description_de = 'Vinylesterharz Kunststofffilz',
   description_fr = 'Résine d''ester vinylique feutre synthetique',
   description_it = 'zzz_Vinylesterharz_Kunststofffilz',
   description_ro = 'rasina_de_ester_vinil_asemanatoare_plasticului',
   display_en = 'vinyl_ester_resin_plastic_felt',
   display_de = 'Vinylesterharz_Kunststofffilz',
   display_fr = 'resrésine d''éster  vinylique feutre synthétique',
   display_it = '',
   display_ro = 'rasina de ester vinil'
WHERE code = 6469;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6448,6448) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 6448;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6479,6479) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'close_fit_relining',
   value_de = 'Close_Fit_Relining',
   value_fr = 'close_fit_relining',
   value_it = 'zzz_Close_Fit_Relining',
   value_ro = 'reconditionare_close_fit',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'close_fit_relining',
   display_de = 'Close_Fit_Relining',
   display_fr = 'close fit relining',
   display_it = '',
   display_ro = 'reconditionare close fit'
WHERE code = 6479;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6449,6449) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'relining_short_tube',
   value_de = 'Kurzrohrrelining',
   value_fr = 'relining_tube_court',
   value_it = 'zzz_Kurzrohrrelining',
   value_ro = 'reconditionare_tub_scurt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'relining_short_tube',
   display_de = 'Kurzrohrrelining',
   display_fr = 'relining tube court',
   display_it = '',
   display_ro = 'reconditionare tub scurt'
WHERE code = 6449;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6481,6481) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'grouted_in_place_lining',
   value_de = 'Noppenschlauchrelining',
   value_fr = 'Noppenschlauchrelining',
   value_it = 'zzz_Noppenschlauchrelining',
   value_ro = 'chituire',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Grouted in place lining',
   description_de = '',
   description_fr = 'terme française inconnue (english: Grouted in place lining)',
   description_it = '',
   description_ro = '',
   display_en = 'grouted_in_place_lining',
   display_de = 'Noppenschlauchrelining',
   display_fr = 'Noppenschlauchrelining',
   display_it = '',
   display_ro = 'chituire'
WHERE code = 6481;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6452,6452) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'partial_liner',
   value_de = 'Partieller_Liner',
   value_fr = 'liner_partiel',
   value_it = 'zzz_Partieller_Liner',
   value_ro = 'captuseala_partiala',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'partial_liner',
   display_de = 'Partieller_Liner',
   display_fr = 'liner partiel',
   display_it = '',
   display_ro = 'captuseala partiala'
WHERE code = 6452;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6450,6450) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'pipe_string_relining',
   value_de = 'Rohrstrangrelining',
   value_fr = 'chemisage_par_ligne_de_tuyau',
   value_it = 'zzz_Rohrstrangrelining',
   value_ro = 'pipe_string_relining',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Pipe string relining',
   description_de = '',
   description_fr = 'Chemisage par ligne de tuyau',
   description_it = '',
   description_ro = '',
   display_en = 'pipe_string_relining',
   display_de = 'Rohrstrangrelining',
   display_fr = 'chemisage par ligne de tuyau',
   display_it = '',
   display_ro = 'pipe string relining'
WHERE code = 6450;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6451,6451) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'hose_relining',
   value_de = 'Schlauchrelining',
   value_fr = 'chemisage_par_gainage',
   value_it = 'zzz_Schlauchrelining',
   value_ro = 'reconditionare_prin_camasuire',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Hose relining',
   description_de = '',
   description_fr = 'Hhemisage par gainage',
   description_it = '',
   description_ro = '',
   display_en = 'hose_relining',
   display_de = 'Schlauchrelining',
   display_fr = 'chemisage par gainage',
   display_it = '',
   display_ro = 'reconditionare prin camasuire'
WHERE code = 6451;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6453,6453) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 6453;

--- Adapt tww_vl.reach_relining_construction
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode) VALUES (6480,6480) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_construction SET
   value_en = 'spiral_lining',
   value_de = 'Wickelrohrrelining',
   value_fr = 'chemisage_par_tube_spirale',
   value_it = 'zzz_Wickelrohrrelining',
   value_ro = 'captusire_prin_tub_spirala',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Spiral lining',
   description_de = '',
   description_fr = 'Chemisage par tube spirale',
   description_it = 'zzz_Wickelrohrrelining',
   description_ro = '',
   display_en = 'spiral_lining',
   display_de = 'Wickelrohrrelining',
   display_fr = 'chemisage par tube spirale',
   display_it = '',
   display_ro = 'captusire prin tub spirala'
WHERE code = 6480;

--- Adapt tww_vl.reach_relining_kind
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode) VALUES (6455,6455) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_kind SET
   value_en = 'full_reach',
   value_de = 'ganze_Haltung',
   value_fr = 'troncon_entier',
   value_it = 'condotta_intera',
   value_ro = 'tronson_intreg',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'full_reach',
   display_de = 'ganze_Haltung',
   display_fr = '',
   display_it = '',
   display_ro = 'tronson intreg'
WHERE code = 6455;

--- Adapt tww_vl.reach_relining_kind
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode) VALUES (6456,6456) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_kind SET
   value_en = 'partial',
   value_de = 'partiell',
   value_fr = 'partiellement',
   value_it = 'parziale',
   value_ro = 'partial',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'partial',
   display_de = 'partiell',
   display_fr = 'partiellement',
   display_it = '',
   display_ro = 'partial'
WHERE code = 6456;

--- Adapt tww_vl.reach_relining_kind
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode) VALUES (6457,6457) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_relining_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 6457;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3317,3317) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'filter_bag',
   value_de = 'Filtersack',
   value_fr = 'percolateur',
   value_it = 'zzz_Filtersack',
   value_ro = 'rrr_Filtersack',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'filter_bag',
   display_de = 'Filtersack',
   display_fr = 'percolateur',
   display_it = '',
   display_ro = ''
WHERE code = 3317;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3319,3319) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'artificial_adsorber',
   value_de = 'KuenstlicherAdsorber',
   value_fr = 'adsorbeur_artificiel',
   value_it = 'zzz_KuenstlicherAdsorber',
   value_ro = 'rrr_KuenstlicherAdsorber',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'artificial_adsorber',
   display_de = 'KuenstlicherAdsorber',
   display_fr = 'adsorbeur artificiel',
   display_it = '',
   display_ro = ''
WHERE code = 3319;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3318,3318) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'swale_french_drain_system',
   value_de = 'MuldenRigolenSystem',
   value_fr = 'systeme_cuvettes_rigoles',
   value_it = 'zzz_MuldenRigolenSystem',
   value_ro = 'rrr_MuldenRigolenSystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Versickerunganlage, in der das unverschmutzte Niederschlagsabwasser in einer Mulde gesammelt und anschliessend über eine humusietre Bodenschicht in eine tieferliegende Sickerleitung versickert wird. (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_de = 'Versickerungsanlage, in der das unverschmutzte Niederschlagsabwasser in einer Mulde gesammelt und anschliessend über eine humusierte Bodenschicht in eine tieferliegende Sickerleitung versickert wird. (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_fr = 'Installation d’infiltration, par laquelle des eaux pluviales non polluées sont récoltées dans une cunette et forcées à s’infiltrer à travers une couche d’humus dans une conduite de drainage plus profonde.',
   description_it = 'zzz_Versickerunganlage, in der das unverschmutzte Niederschlagsabwasser in einer Mulde gesammelt und anschliessend über eine humusietre Bodenschicht in eine tieferliegende Sickerleitung versickert wird. (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_ro = 'rrr_Versickerungsanlage, in der das unverschmutzte Niederschlagsabwasser in einer Mulde gesammelt und anschliessend über eine humusierte Bodenschicht in eine tieferliegende Sickerleitung versickert wird. (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   display_en = 'swale_french_drain_system',
   display_de = 'MuldenRigolenSystem',
   display_fr = 'système cuvettes-rigoles',
   display_it = '',
   display_ro = ''
WHERE code = 3318;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3320,3320) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'slurry_collector',
   value_de = 'Schlammsammler',
   value_fr = 'collecteur_de_boue',
   value_it = 'pozzetto_decantazione',
   value_ro = 'colector_aluviuni',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_3. Bei Versickerungsanlage gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002)',
   description_de = '3. Bei Versickerungsanlage gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002)',
   description_fr = '3. Aux installations d''infiltration, selon directive VSA "Evacuation des eaux pluviales" (2002)',
   description_it = 'zzz_3. Bei Versickerungsanlage gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002)',
   description_ro = '',
   display_en = 'slurry_collector',
   display_de = 'Schlammsammler',
   display_fr = 'collecteur de boue',
   display_it = '',
   display_ro = ''
WHERE code = 3320;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3321,3321) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'floating_matter_separator',
   value_de = 'Schwimmstoffabscheider',
   value_fr = 'separateur_materiaux_flottants',
   value_it = 'separatore_materiali_galleggianti',
   value_ro = 'separator_materie_flotanta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Baute zum Abscheiden von Schwimmstoffen (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_de = 'Baute zum Abscheiden von Schwimmstoffen (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_fr = 'Ouvrage servant à séparer l''eau des matières flottantes (selon directive VSA "Evacuation des eaux pluviales", édition 2002)',
   description_it = 'zzz_Baute zum Abscheiden von Schwimmstoffen (gemäss VSA Richtlinie Regenwasserentsorgung (Ausgabe 2002))',
   description_ro = '',
   display_en = 'floating_matter_separator',
   display_de = 'Schwimmstoffabscheider',
   display_fr = 'séparateur de matériaux flottants',
   display_it = '',
   display_ro = 'separator materie flotanta'
WHERE code = 3321;

--- Adapt tww_vl.mechanical_pretreatment_kind
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode) VALUES (3322,3322) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.mechanical_pretreatment_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3322;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (2992,2992) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2992;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (346,346) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'retention_in_habitat',
   value_de = 'Biotop',
   value_fr = 'retention_dans_bassins_et_depressions',
   value_it = 'zzz_Biotop',
   value_ro = 'rrr_Biotop',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'retention_in_habitat',
   display_de = 'Biotop',
   display_fr = 'biotope',
   display_it = '',
   display_ro = ''
WHERE code = 346;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (345,345) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'roof_retention',
   value_de = 'Dachretention',
   value_fr = 'retention_sur_toits',
   value_it = 'zzz_Dachretention',
   value_ro = 'rrr_Dachretention',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'roof_retention',
   display_de = 'Dachretention',
   display_fr = 'rétention en toiture',
   display_it = '',
   display_ro = ''
WHERE code = 345;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (348,348) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'parking_lot',
   value_de = 'Parkplatz',
   value_fr = 'retention_sur_routes_et_places',
   value_it = 'zzz_Parkplatz',
   value_ro = 'rrr_Parkplaetze',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'aire de stationnement',
   description_it = '',
   description_ro = '',
   display_en = 'parking_lot',
   display_de = 'Parkplatz',
   display_fr = 'rétention sur routes et places',
   display_it = '',
   display_ro = ''
WHERE code = 348;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (347,347) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'accumulation_channel',
   value_de = 'Staukanal',
   value_fr = 'retention_dans_canalisations_stockage',
   value_it = 'zzz_Staukanal',
   value_ro = 'rrr_Staukanal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'accumulation_channel',
   display_de = 'Staukanal',
   display_fr = 'canal de rétention',
   display_it = '',
   display_ro = ''
WHERE code = 347;

--- Adapt tww_vl.retention_body_kind
 INSERT INTO tww_vl.retention_body_kind (code, vsacode) VALUES (3031,3031) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.retention_body_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3031;

--- Adapt tww_vl.overflow_char_kind_overflow_char
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode) VALUES (6220,6220) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_char_kind_overflow_char SET
   value_en = 'hq',
   value_de = 'HQ',
   value_fr = 'HQ',
   value_it = 'HQ',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_H-Q Beziehung: Hoehe (H) und Durchfluss (Q) Richtung ARA abfüllen',
   description_de = 'H-Q Beziehung: Hoehe (H) und Durchfluss (Q) Richtung ARA abfüllen',
   description_fr = 'ligne H / Q: H = hauteur d’eau lors du déversement [m.s.m.], Q = débit conservé vers STEP [l/s]',
   description_it = 'Assegnare altezza (H) e portata (Q)',
   description_ro = '',
   display_en = 'hq',
   display_de = 'HQ',
   display_fr = 'HQ',
   display_it = '',
   display_ro = ''
WHERE code = 6220;

--- Adapt tww_vl.overflow_char_kind_overflow_char
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode) VALUES (6221,6221) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_char_kind_overflow_char SET
   value_en = 'qq',
   value_de = 'QQ',
   value_fr = 'QQ',
   value_it = 'QQ',
   value_ro = 'QQ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Q-Q-Beziehung: Zufluss (Q1) und Durchfluss Richtung ARA (Q2) abfüllen',
   description_de = 'Q-Q-Beziehung: Zufluss (Q1) und Durchfluss Richtung ARA (Q2) abfüllen',
   description_fr = 'ligne Q1 / Q2: Q1 = débit d’entrée [l/s], Q2 = débit acheminé vers STEP [l/s]',
   description_it = 'Registrare afflusso (Q1) e portata (Q2)',
   description_ro = '',
   display_en = 'qq',
   display_de = 'QQ',
   display_fr = 'QQ',
   display_it = '',
   display_ro = ''
WHERE code = 6221;

--- Adapt tww_vl.overflow_char_kind_overflow_char
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode) VALUES (6228,6228) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_char_kind_overflow_char SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 6228;

--- Adapt tww_vl.structure_part_renovation_demand
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode) VALUES (138,138) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.structure_part_renovation_demand SET
   value_en = 'not_necessary',
   value_de = 'nicht_notwendig',
   value_fr = 'pas_necessaire',
   value_it = 'zzz_nicht_notwendig',
   value_ro = 'nenecesare',
   abbr_en = 'NN',
   abbr_de = 'NN',
   abbr_fr = 'PN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_necessary',
   display_de = 'nicht_notwendig',
   display_fr = 'pas nécessaire',
   display_it = '',
   display_ro = 'nenecesare'
WHERE code = 138;

--- Adapt tww_vl.structure_part_renovation_demand
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode) VALUES (137,137) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.structure_part_renovation_demand SET
   value_en = 'necessary',
   value_de = 'notwendig',
   value_fr = 'necessaire',
   value_it = 'zzz_notwendig',
   value_ro = 'necesare',
   abbr_en = 'N',
   abbr_de = 'N',
   abbr_fr = 'N',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'necessary',
   display_de = 'notwendig',
   display_fr = 'nécessaire',
   display_it = '',
   display_ro = 'necesare'
WHERE code = 137;

--- Adapt tww_vl.structure_part_renovation_demand
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode) VALUES (5358,5358) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.structure_part_renovation_demand SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5358;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (5357,5357) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5357;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (243,243) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'pressurized_door',
   value_de = 'Drucktuere',
   value_fr = 'porte_etanche',
   value_it = 'zzz_Drucktuere',
   value_ro = 'usa_presurizata',
   abbr_en = 'PD',
   abbr_de = 'D',
   abbr_fr = 'PE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pressurized_door',
   display_de = 'Drucktuere',
   display_fr = 'portes étanches',
   display_it = '',
   display_ro = 'usa presurizata'
WHERE code = 243;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (92,92) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucun_equipement_d_acces',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = 'K',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucun équipement d''accès',
   display_it = '',
   display_ro = 'inexistent'
WHERE code = 92;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (240,240) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'ladder',
   value_de = 'Leiter',
   value_fr = 'echelle',
   value_it = 'zzz_Leiter',
   value_ro = 'scara',
   abbr_en = '',
   abbr_de = 'L',
   abbr_fr = 'EC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'ladder',
   display_de = 'Leiter',
   display_fr = 'échelle',
   display_it = '',
   display_ro = 'scara'
WHERE code = 240;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (241,241) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'step_iron',
   value_de = 'Steigeisen',
   value_fr = 'echelons',
   value_it = 'zzz_Steigeisen',
   value_ro = 'esaloane',
   abbr_en = '',
   abbr_de = 'S',
   abbr_fr = 'ECO',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'step_iron',
   display_de = 'Steigeisen',
   display_fr = 'échelons',
   display_it = '',
   display_ro = 'e?aloane'
WHERE code = 241;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (3473,3473) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'staircase',
   value_de = 'Treppe',
   value_fr = 'escalier',
   value_it = 'zzz_Treppe',
   value_ro = 'structura_scari',
   abbr_en = '',
   abbr_de = 'R',
   abbr_fr = 'ES',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'staircase',
   display_de = 'Treppe',
   display_fr = 'escaliers',
   display_it = '',
   display_ro = 'structura scari'
WHERE code = 3473;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (91,91) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'footstep_niches',
   value_de = 'Trittnischen',
   value_fr = 'marchepieds',
   value_it = 'zzz_Trittnischen',
   value_ro = 'trepte',
   abbr_en = '',
   abbr_de = 'N',
   abbr_fr = 'N',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'niches ou marchepied',
   description_it = '',
   description_ro = '',
   display_en = 'footstep_niches',
   display_de = 'Trittnischen',
   display_fr = 'marchepieds',
   display_it = '',
   display_ro = 'trepte'
WHERE code = 91;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (3230,3230) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'door',
   value_de = 'Tuere',
   value_fr = 'porte',
   value_it = 'porta',
   value_ro = 'usa',
   abbr_en = '',
   abbr_de = 'T',
   abbr_fr = 'P',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'door',
   display_de = 'Tuere',
   display_fr = 'porte',
   display_it = '',
   display_ro = 'usa'
WHERE code = 3230;

--- Adapt tww_vl.access_aid_kind
 INSERT INTO tww_vl.access_aid_kind (code, vsacode) VALUES (3048,3048) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.access_aid_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3048;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (3221,3221) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = 'alta'
WHERE code = 3221;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (354,354) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'combined',
   value_de = 'kombiniert',
   value_fr = 'combine',
   value_it = 'zzz_kombiniert',
   value_ro = 'combinata',
   abbr_en = '',
   abbr_de = 'KOM',
   abbr_fr = 'COM',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'combined',
   display_de = 'kombiniert',
   display_fr = 'combiné',
   display_it = '',
   display_ro = 'combinata'
WHERE code = 354;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (5356,5356) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'plastic',
   value_de = 'Kunststoff',
   value_fr = 'matiere_synthetique',
   value_it = 'materiale_sintetico',
   value_ro = 'materie_sintetica',
   abbr_en = '',
   abbr_de = 'KU',
   abbr_fr = 'MS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plastic',
   display_de = 'Kunststoff',
   display_fr = 'matière synthétique',
   display_it = '',
   display_ro = 'materie sintetica'
WHERE code = 5356;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (238,238) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'stoneware',
   value_de = 'Steinzeug',
   value_fr = 'gres',
   value_it = 'gres',
   value_ro = 'gresie',
   abbr_en = '',
   abbr_de = 'STZ',
   abbr_fr = 'GR',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'stoneware',
   display_de = 'Steinzeug',
   display_fr = 'grès',
   display_it = '',
   display_ro = 'gresie'
WHERE code = 238;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (3017,3017) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3017;

--- Adapt tww_vl.dryweather_flume_material
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode) VALUES (237,237) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dryweather_flume_material SET
   value_en = 'cement_mortar',
   value_de = 'Zementmoertel',
   value_fr = 'mortier_de_ciment',
   value_it = 'zzz_Zementmoertel',
   value_ro = 'mortar_ciment',
   abbr_en = '',
   abbr_de = 'ZM',
   abbr_fr = 'MC',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cement_mortar',
   display_de = 'Zementmoertel',
   display_fr = 'mortier de ciment',
   display_it = '',
   display_ro = 'mortar ciment'
WHERE code = 237;

--- Adapt tww_vl.cover_cover_shape
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode) VALUES (5353,5353) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_cover_shape SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5353;

--- Adapt tww_vl.cover_cover_shape
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode) VALUES (3499,3499) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_cover_shape SET
   value_en = 'rectangular',
   value_de = 'eckig',
   value_fr = 'anguleux',
   value_it = 'zzz_eckig',
   value_ro = 'dreptunghic',
   abbr_en = 'R',
   abbr_de = 'E',
   abbr_fr = 'AX',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'rectangular',
   display_de = 'eckig',
   display_fr = 'anguleux',
   display_it = '',
   display_ro = 'dreptunghic'
WHERE code = 3499;

--- Adapt tww_vl.cover_cover_shape
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode) VALUES (3498,3498) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_cover_shape SET
   value_en = 'round',
   value_de = 'rund',
   value_fr = 'rond',
   value_it = 'zzz_rund',
   value_ro = 'rotund',
   abbr_en = '',
   abbr_de = 'R',
   abbr_fr = 'R',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'round',
   display_de = 'rund',
   display_fr = 'rond',
   display_it = '',
   display_ro = 'rotund'
WHERE code = 3498;

--- Adapt tww_vl.cover_cover_shape
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode) VALUES (5354,5354) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_cover_shape SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5354;

--- Adapt tww_vl.cover_fastening
 INSERT INTO tww_vl.cover_fastening (code, vsacode) VALUES (5350,5350) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_fastening SET
   value_en = 'not_bolted',
   value_de = 'nicht_verschraubt',
   value_fr = 'non_vissee',
   value_it = 'zzz_nicht_verschraubt',
   value_ro = 'neinsurubata',
   abbr_en = '',
   abbr_de = 'NVS',
   abbr_fr = 'NVS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_bolted',
   display_de = 'nicht_verschraubt',
   display_fr = 'non visée',
   display_it = '',
   display_ro = 'neinsurubata'
WHERE code = 5350;

--- Adapt tww_vl.cover_fastening
 INSERT INTO tww_vl.cover_fastening (code, vsacode) VALUES (5351,5351) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_fastening SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5351;

--- Adapt tww_vl.cover_fastening
 INSERT INTO tww_vl.cover_fastening (code, vsacode) VALUES (5352,5352) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_fastening SET
   value_en = 'bolted',
   value_de = 'verschraubt',
   value_fr = 'vissee',
   value_it = 'zzz_verschraubt',
   value_ro = 'insurubata',
   abbr_en = '',
   abbr_de = 'VS',
   abbr_fr = 'VS',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'bolted',
   display_de = 'verschraubt',
   display_fr = 'vissée',
   display_it = '',
   display_ro = 'insurubata'
WHERE code = 5352;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (5355,5355) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = 'O',
   abbr_de = 'A',
   abbr_fr = 'AU',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 5355;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (234,234) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'concrete',
   value_de = 'Beton',
   value_fr = 'beton',
   value_it = 'calcestruzzo',
   value_ro = 'beton',
   abbr_en = 'C',
   abbr_de = 'B',
   abbr_fr = 'B',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'concrete',
   display_de = 'Beton',
   display_fr = 'béton',
   display_it = '',
   display_ro = 'beton'
WHERE code = 234;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (233,233) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'cast_iron',
   value_de = 'Guss',
   value_fr = 'fonte',
   value_it = 'ghisa',
   value_ro = 'fonta',
   abbr_en = '',
   abbr_de = 'G',
   abbr_fr = 'F',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cast_iron',
   display_de = 'Guss',
   display_fr = 'fonte',
   display_it = '',
   display_ro = 'fonta'
WHERE code = 233;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (5547,5547) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'cast_iron_with_pavement_filling',
   value_de = 'Guss_mit_Belagsfuellung',
   value_fr = 'fonte_avec_remplissage_enrobe',
   value_it = 'zzz_Guss_mit_Belagsfuellung',
   value_ro = 'fonta_cu_umplutura',
   abbr_en = 'CIP',
   abbr_de = 'GBL',
   abbr_fr = 'FRE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'fonte avec remplissage enrobé',
   description_it = '',
   description_ro = '',
   display_en = 'cast_iron_with_pavement_filling',
   display_de = 'Guss_mit_Belagsfuellung',
   display_fr = 'fonte avec remplissage enrobé',
   display_it = '',
   display_ro = 'fonta cu umplutura'
WHERE code = 5547;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (235,235) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'cast_iron_with_concrete_filling',
   value_de = 'Guss_mit_Betonfuellung',
   value_fr = 'fonte_avec_remplissage_beton',
   value_it = 'zzz_Guss_mit_Betonfuellung',
   value_ro = 'fonta_cu_umplutura_beton',
   abbr_en = '',
   abbr_de = 'GBT',
   abbr_fr = 'FRB',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cast_iron_with_concrete_filling',
   display_de = 'Guss_mit_Betonfuellung',
   display_fr = 'fonte avec remplissage en  béton',
   display_it = '',
   display_ro = 'fonta cu umplutura beton'
WHERE code = 235;

--- Adapt tww_vl.cover_material
 INSERT INTO tww_vl.cover_material (code, vsacode) VALUES (3015,3015) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_material SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3015;

--- Adapt tww_vl.cover_positional_accuracy
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode) VALUES (3243,3243) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_positional_accuracy SET
   value_en = 'more_than_50cm',
   value_de = 'groesser_50cm',
   value_fr = 'plusque_50cm',
   value_it = 'maggiore_50cm',
   value_ro = 'mai_mare_50cm',
   abbr_en = '',
   abbr_de = 'G50',
   abbr_fr = 'S50',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'more_than_50cm',
   display_de = 'groesser_50cm',
   display_fr = 'plus que 50cm',
   display_it = '',
   display_ro = 'mai mare 50cm'
WHERE code = 3243;

--- Adapt tww_vl.cover_positional_accuracy
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode) VALUES (3241,3241) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_positional_accuracy SET
   value_en = 'plusminus_10cm',
   value_de = 'plusminus_10cm',
   value_fr = 'plus_moins_10cm',
   value_it = 'piu_meno_10cm',
   value_ro = 'plus_minus_10cm',
   abbr_en = '',
   abbr_de = 'P10',
   abbr_fr = 'P10',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_10cm',
   display_de = 'plusminus_10cm',
   display_fr = 'plus moins 10cm',
   display_it = '',
   display_ro = 'plus minus 10cm'
WHERE code = 3241;

--- Adapt tww_vl.cover_positional_accuracy
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode) VALUES (3236,3236) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_positional_accuracy SET
   value_en = 'plusminus_3cm',
   value_de = 'plusminus_3cm',
   value_fr = 'plus_moins_3cm',
   value_it = 'piu_meno_3cm',
   value_ro = 'plus_minus_3cm',
   abbr_en = '',
   abbr_de = 'P03',
   abbr_fr = 'P03',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_3cm',
   display_de = 'plusminus_3cm',
   display_fr = 'plus moins 3cm',
   display_it = '',
   display_ro = 'plus minus 3cm'
WHERE code = 3236;

--- Adapt tww_vl.cover_positional_accuracy
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode) VALUES (3242,3242) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_positional_accuracy SET
   value_en = 'plusminus_50cm',
   value_de = 'plusminus_50cm',
   value_fr = 'plus_moins_50cm',
   value_it = 'piu_meno_50cm',
   value_ro = 'plus_minus_50cm',
   abbr_en = '',
   abbr_de = 'P50',
   abbr_fr = 'P50',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'plusminus_50cm',
   display_de = 'plusminus_50cm',
   display_fr = 'plus moins 50cm',
   display_it = '',
   display_ro = 'plusminus 50cm'
WHERE code = 3242;

--- Adapt tww_vl.cover_positional_accuracy
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode) VALUES (5349,5349) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_positional_accuracy SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 5349;

--- Adapt tww_vl.cover_sludge_bucket
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode) VALUES (423,423) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_sludge_bucket SET
   value_en = 'inexistent',
   value_de = 'nicht_vorhanden',
   value_fr = 'inexistant',
   value_it = 'non_presente',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = 'NV',
   abbr_fr = 'IE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'inexistent',
   display_de = 'nicht_vorhanden',
   display_fr = 'inexistant',
   display_it = '',
   display_ro = 'inexistent'
WHERE code = 423;

--- Adapt tww_vl.cover_sludge_bucket
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode) VALUES (3066,3066) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_sludge_bucket SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3066;

--- Adapt tww_vl.cover_sludge_bucket
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode) VALUES (422,422) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_sludge_bucket SET
   value_en = 'existent',
   value_de = 'vorhanden',
   value_fr = 'existant',
   value_it = 'presente',
   value_ro = 'existent',
   abbr_en = '',
   abbr_de = 'V',
   abbr_fr = 'E',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'existent',
   display_de = 'vorhanden',
   display_fr = 'existant',
   display_it = '',
   display_ro = 'existent'
WHERE code = 422;

--- Adapt tww_vl.cover_venting
 INSERT INTO tww_vl.cover_venting (code, vsacode) VALUES (229,229) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_venting SET
   value_en = 'vented',
   value_de = 'entlueftet',
   value_fr = 'aere',
   value_it = 'zzz_entlueftet',
   value_ro = 'cu_aerisire',
   abbr_en = '',
   abbr_de = 'EL',
   abbr_fr = 'AE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'vented',
   display_de = 'entlueftet',
   display_fr = 'aere',
   display_it = '',
   display_ro = 'cu aerisire'
WHERE code = 229;

--- Adapt tww_vl.cover_venting
 INSERT INTO tww_vl.cover_venting (code, vsacode) VALUES (230,230) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_venting SET
   value_en = 'not_vented',
   value_de = 'nicht_entlueftet',
   value_fr = 'non_aere',
   value_it = 'zzz_nicht_entlueftet',
   value_ro = 'fara_aerisire',
   abbr_en = '',
   abbr_de = 'NEL',
   abbr_fr = 'NAE',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_vented',
   display_de = 'nicht_entlueftet',
   display_fr = 'non aéré',
   display_it = '',
   display_ro = 'fara aerisire'
WHERE code = 230;

--- Adapt tww_vl.cover_venting
 INSERT INTO tww_vl.cover_venting (code, vsacode) VALUES (5348,5348) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.cover_venting SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 5348;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (2980,2980) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2980;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (376,376) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'illumination',
   value_de = 'Beleuchtung',
   value_fr = 'eclairage',
   value_it = 'zzz_Beleuchtung',
   value_ro = 'rrr_Beleuchtung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'illumination',
   display_de = 'Beleuchtung',
   display_fr = 'éclairage',
   display_it = '',
   display_ro = ''
WHERE code = 376;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (3255,3255) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'remote_control_system',
   value_de = 'Fernwirkanlage',
   value_fr = 'installation_de_telecommande',
   value_it = 'zzz_Fernwirkanlage',
   value_ro = 'rrr_Fernwirkanlage',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'remote_control_system',
   display_de = 'Fernwirkanlage',
   display_fr = 'Installation de télécommande',
   display_it = '',
   display_ro = ''
WHERE code = 3255;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (378,378) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'radio_unit',
   value_de = 'Funk',
   value_fr = 'radio',
   value_it = 'zzz_Funk',
   value_ro = 'rrr_Funk',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'radio_unit',
   display_de = 'Funk',
   display_fr = 'radio',
   display_it = '',
   display_ro = ''
WHERE code = 378;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (377,377) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'phone',
   value_de = 'Telephon',
   value_fr = 'telephone',
   value_it = 'telefono',
   value_ro = 'telefon',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'phone',
   display_de = 'Telephon',
   display_fr = 'téléphone',
   display_it = '',
   display_ro = ''
WHERE code = 377;

--- Adapt tww_vl.electric_equipment_kind
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode) VALUES (3038,3038) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electric_equipment_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3038;

--- Adapt tww_vl.electromechanical_equipment_kind
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode) VALUES (2981,2981) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electromechanical_equipment_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2981;

--- Adapt tww_vl.electromechanical_equipment_kind
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode) VALUES (380,380) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electromechanical_equipment_kind SET
   value_en = 'leakage_water_pump',
   value_de = 'Leckwasserpumpe',
   value_fr = 'pompe_d_epuisement',
   value_it = 'zzz_Leckwasserpumpe',
   value_ro = 'rrr_Leckwasserpumpe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'leakage_water_pump',
   display_de = 'Leckwasserpumpe',
   display_fr = 'pompe d''épuisement',
   display_it = '',
   display_ro = ''
WHERE code = 380;

--- Adapt tww_vl.electromechanical_equipment_kind
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode) VALUES (337,337) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electromechanical_equipment_kind SET
   value_en = 'air_dehumidifier',
   value_de = 'Luftentfeuchter',
   value_fr = 'deshumidificateur',
   value_it = 'zzz_Luftentfeuchter',
   value_ro = 'rrr_Luftentfeuchter',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'air_dehumidifier',
   display_de = 'Luftentfeuchter',
   display_fr = 'dessiccateur',
   display_it = '',
   display_ro = ''
WHERE code = 337;

--- Adapt tww_vl.electromechanical_equipment_kind
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode) VALUES (3072,3072) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.electromechanical_equipment_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3072;

--- Adapt tww_vl.benching_kind
 INSERT INTO tww_vl.benching_kind (code, vsacode) VALUES (5319,5319) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.benching_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'alta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'alta'
WHERE code = 5319;

--- Adapt tww_vl.benching_kind
 INSERT INTO tww_vl.benching_kind (code, vsacode) VALUES (94,94) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.benching_kind SET
   value_en = 'double_sided',
   value_de = 'beidseitig',
   value_fr = 'double',
   value_it = 'zzz_beidseitig',
   value_ro = 'dubla',
   abbr_en = 'DS',
   abbr_de = 'BB',
   abbr_fr = 'D',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'double_sided',
   display_de = 'beidseitig',
   display_fr = 'double',
   display_it = '',
   display_ro = 'dubla'
WHERE code = 94;

--- Adapt tww_vl.benching_kind
 INSERT INTO tww_vl.benching_kind (code, vsacode) VALUES (93,93) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.benching_kind SET
   value_en = 'one_sided',
   value_de = 'einseitig',
   value_fr = 'simple',
   value_it = 'zzz_einseitig',
   value_ro = 'simpla',
   abbr_en = 'OS',
   abbr_de = 'EB',
   abbr_fr = 'S',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'one_sided',
   display_de = 'einseitig',
   display_fr = 'simple',
   display_it = '',
   display_ro = 'simpla'
WHERE code = 93;

--- Adapt tww_vl.benching_kind
 INSERT INTO tww_vl.benching_kind (code, vsacode) VALUES (3231,3231) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.benching_kind SET
   value_en = 'none',
   value_de = 'kein',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'niciun',
   abbr_en = '',
   abbr_de = 'KB',
   abbr_fr = 'AN',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'kein',
   display_fr = 'aucun',
   display_it = '',
   display_ro = 'niciun'
WHERE code = 3231;

--- Adapt tww_vl.benching_kind
 INSERT INTO tww_vl.benching_kind (code, vsacode) VALUES (3033,3033) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.benching_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = 'U',
   abbr_fr = 'I',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscuta'
WHERE code = 3033;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (2979,2979) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2979;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3466,3466) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'railway_site',
   value_de = 'Bahnanlagen',
   value_fr = 'installation_ferroviaire',
   value_it = 'zzz_Bahnanlagen',
   value_ro = 'rrr_Bahnanlagen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'railway_site',
   display_de = 'Bahnanlagen',
   display_fr = 'Installation ferroviaire',
   display_it = '',
   display_ro = ''
WHERE code = 3466;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3461,3461) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'roof_industrial_or_commercial_building',
   value_de = 'DachflaecheIndustrieundGewerbebetriebe',
   value_fr = 'surface_toits_bat_industriels_artisanaux',
   value_it = 'zzz_DachflaecheIndustrieundGewerbebetriebe',
   value_ro = 'rrr_DachflaecheIndustrieundGewerbebetriebe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'roof_industrial_or_commercial_building',
   display_de = 'DachflaecheIndustrieundGewerbebetriebe',
   display_fr = 'surface toits bâtiments industriels artisanaux',
   display_it = '',
   display_ro = ''
WHERE code = 3461;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3460,3460) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'roof_residential_or_office_building',
   value_de = 'DachflaecheWohnundBuerogebaeude',
   value_fr = 'surface_toits_imm_habitation_administratifs',
   value_it = 'zzz_DachflaecheWohnundBuerogebaeude',
   value_ro = 'rrr_DachflaecheWohnundBuerogebaeude',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'roof_residential_or_office_building',
   display_de = 'DachflaecheWohnundBuerogebaeude',
   display_fr = 'surface toits immeubles habitation administratifs',
   display_it = '',
   display_ro = ''
WHERE code = 3460;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3464,3464) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'access_or_collecting_road',
   value_de = 'Erschliessungs_Sammelstrassen',
   value_fr = 'routes_de_desserte_et_collectives',
   value_it = 'zzz_Erschliessungs_Sammelstrassen',
   value_ro = 'rrr_Erschliessungs_Sammelstrassen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'access_or_collecting_road',
   display_de = 'Erschliessungs_Sammelstrassen',
   display_fr = 'routes de désserte et collectives',
   display_it = '',
   display_ro = ''
WHERE code = 3464;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3467,3467) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'parking_lot',
   value_de = 'Parkplaetze',
   value_fr = 'parkings',
   value_it = 'zzz_Parkplaetze',
   value_ro = 'rrr_Parkplaetze',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'parking_lot',
   display_de = 'Parkplaetze',
   display_fr = 'parkings',
   display_it = '',
   display_ro = ''
WHERE code = 3467;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3462,3462) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'transfer_site_or_stockyard',
   value_de = 'UmschlagundLagerplaetze',
   value_fr = 'places_transbordement_entreposage',
   value_it = 'zzz_UmschlagundLagerplaetze',
   value_ro = 'rrr_UmschlagundLagerplaetze',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'transfer_site_or_stockyard',
   display_de = 'UmschlagundLagerplaetze',
   display_fr = 'places transbordement entreposage',
   display_it = '',
   display_ro = ''
WHERE code = 3462;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3029,3029) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3029;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3465,3465) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'connecting_or_principal_or_major_road',
   value_de = 'Verbindungs_Hauptverkehrs_Hochleistungsstrassen',
   value_fr = 'routes_de_raccordement_principales_grand_trafic',
   value_it = 'zzz_Verbindungs_Hauptverkehrs_Hochleistungsstrassen',
   value_ro = 'rrr_Verbindungs_Hauptverkehrs_Hochleistungsstrassen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'connecting_or_principal_or_major_road',
   display_de = 'Verbindungs_Hauptverkehrs_Hochleistungsstrassen',
   display_fr = 'routes de raccordement principales grand trafic',
   display_it = '',
   display_ro = ''
WHERE code = 3465;

--- Adapt tww_vl.individual_surface_function
 INSERT INTO tww_vl.individual_surface_function (code, vsacode) VALUES (3463,3463) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_function SET
   value_en = 'forecourt_and_access_road',
   value_de = 'VorplaetzeZufahrten',
   value_fr = 'places_devant_entree_acces',
   value_it = 'zzz_VorplaetzeZufahrten',
   value_ro = 'rrr_VorplaetzeZufahrten',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'forecourt_and_access_road',
   display_de = 'VorplaetzeZufahrten',
   display_fr = 'places devant entrée acces',
   display_it = '',
   display_ro = ''
WHERE code = 3463;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (2978,2978) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2978;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (2031,2031) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'paved',
   value_de = 'befestigt',
   value_fr = 'impermeabilise',
   value_it = 'zzz_befestigt',
   value_ro = 'rrr_befestigt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'paved',
   display_de = 'befestigt',
   display_fr = 'imperméabilisé',
   display_it = '',
   display_ro = ''
WHERE code = 2031;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (2032,2032) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'forested',
   value_de = 'bestockt',
   value_fr = 'boise',
   value_it = 'zzz_bestockt',
   value_ro = 'rrr_bestockt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'forested',
   display_de = 'bestockt',
   display_fr = 'boisé',
   display_it = '',
   display_ro = ''
WHERE code = 2032;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (2033,2033) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'soil_covered',
   value_de = 'humusiert',
   value_fr = 'couverture_vegetale',
   value_it = 'zzz_humusiert',
   value_ro = 'rrr_humusiert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'soil_covered',
   display_de = 'humusiert',
   display_fr = 'terre végétale',
   display_it = '',
   display_ro = ''
WHERE code = 2033;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (3030,3030) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3030;

--- Adapt tww_vl.individual_surface_pavement
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode) VALUES (2034,2034) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.individual_surface_pavement SET
   value_en = 'barren',
   value_de = 'vegetationslos',
   value_fr = 'sans_vegetation',
   value_it = 'zzz_vegetationslos',
   value_ro = 'rrr_vegetationslos',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'barren',
   display_de = 'vegetationslos',
   display_fr = 'sans végétation',
   display_it = '',
   display_ro = ''
WHERE code = 2034;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8532,8532) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 8532;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8527,8527) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'no_control',
   value_de = 'keine_Steuerung',
   value_fr = 'aucune_commande',
   value_it = 'nessun_comando',
   value_ro = 'rrr_keine_Steuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_control',
   display_de = 'keine_Steuerung',
   display_fr = 'aucune commande',
   display_it = '',
   display_ro = ''
WHERE code = 8527;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8528,8528) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'local_control',
   value_de = 'lokale_Steuerung',
   value_fr = 'commande_locale',
   value_it = 'comando_locale',
   value_ro = 'rrr_lokale_Steuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'No remote transmission/alarming',
   description_de = 'Keine Fernübertragung/Alarmierung',
   description_fr = 'Pas de transmission à distance/d''alarme',
   description_it = 'Nessuna trasmissione/allarme a distanza',
   description_ro = 'Fara transmisie/alarmare de la distan?a',
   display_en = 'local_control',
   display_de = 'lokale_Steuerung',
   display_fr = 'commande locale',
   display_it = '',
   display_ro = ''
WHERE code = 8528;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8529,8529) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'transmission_alarm',
   value_de = 'Uebermittlung_Alarm',
   value_fr = 'transmission_alarme',
   value_it = 'trasmissione_allarme',
   value_ro = 'rrr_Uebermittlung_Alarm',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Requires local control. Alarms are transmitted but no other signals',
   description_de = 'Setzt lokale Steuerung voraus. Alarme werden übertragen aber keine weiteren Signale.',
   description_fr = 'Nécessite une commande locale. Les alarmes sont transmises mais aucun autre signal.',
   description_it = 'Richiede un controllo locale. Gli allarmi vengono trasmessi ma nessun altro segnale.',
   description_ro = 'Necesita control local. Alarmele sunt transmise, dar nu ?i alte semnale',
   display_en = 'transmission_alarm',
   display_de = 'Uebermittlung_Alarm',
   display_fr = 'transmission alarme',
   display_it = '',
   display_ro = ''
WHERE code = 8529;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8530,8530) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'transmission_measuring_signals',
   value_de = 'Uebermittlung_Messsignale',
   value_fr = 'transmission_signaux_mesure',
   value_it = 'trasmissione_segnali_misura',
   value_ro = 'rrr_Uebermittlung_Messsignale',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Requires local control. In addition to alarms, other measurement data is also transmitted, usually to a process control system (PCS).',
   description_de = 'Setzt lokale Steuerung voraus. Neben Alarmen werden auch weitere Messdaten übertragen, i.d.R. auf ein Prozessleitsystem (PLS).',
   description_fr = 'Présuppose une commande locale. Outre les alarmes, d''autres données de mesure sont transmises, généralement à un système de contrôle de processus (SCP).',
   description_it = 'Richiede un controllo locale. Oltre agli allarmi, vengono trasmessi anche altri dati di misurazione, di solito a un sistema di controllo di processo (SCP)',
   description_ro = 'Necesita control local. În plus fa?a de alarme, sunt transmise ?i alte date de masurare, de obicei catre un sistem de control al procesului (SCP).',
   display_en = 'transmission_measuring_signals',
   display_de = 'Uebermittlung_Messsignale',
   display_fr = 'transmission signaux mesure',
   display_it = '',
   display_ro = ''
WHERE code = 8530;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8533,8533) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8533;

--- Adapt tww_vl.log_card_control_remote_control
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode) VALUES (8531,8531) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_control_remote_control SET
   value_en = 'interconnection_control',
   value_de = 'Verbundsteuerung',
   value_fr = 'commande_combinee',
   value_it = 'comando_composito',
   value_ro = 'rrr_Verbundsteuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Requires local control. In addition to alarms, other measurement data is also transmitted to a process control system (PCS). The PCS can also send control or status signals back to the structure for interconnected control.',
   description_de = 'Setzt lokale Steuerung voraus. Neben Alarmen werden auch weitere Messdaten auf ein Prozessleitsystem (PLS) übertragen. Das PLS kann ausserdem auch Steuerungs- oder Statussignale an das Bauwerk zurücksenden zwecks Verbundsteuerung.',
   description_fr = 'Présuppose une commande locale. Outre les alarmes, d''autres données de mesure sont transmises à un un système de contrôle de processus (SCP). Le SCP peut en outre renvoyer des signaux de commande ou d''état à l''ouvrage en vue d''une commande interconnectée.',
   description_it = 'Richiede un controllo locale. Oltre agli allarmi, altri dati di misurazione vengono trasmessi a un sistema di controllo di processo (SCP). Il SCP può anche inviare segnali di controllo o di stato all''edificio per il controllo interconnesso.',
   description_ro = 'Necesita control local. În plus fa?a de alarme, alte date de masurare sunt, de asemenea, transmise catre un sistem de control al procesului (SCP). SCP poate trimite, de asemenea, semnale de control sau de stare catre cladire în scopul controlului interconectat.',
   display_en = 'interconnection_control',
   display_de = 'Verbundsteuerung',
   display_fr = 'commande combinée',
   display_it = '',
   display_ro = ''
WHERE code = 8531;

--- Adapt tww_vl.log_card_information_source
 INSERT INTO tww_vl.log_card_information_source (code, vsacode) VALUES (5601,5601) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_information_source SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 5601;

--- Adapt tww_vl.log_card_information_source
 INSERT INTO tww_vl.log_card_information_source (code, vsacode) VALUES (5604,5604) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_information_source SET
   value_en = 'gwdp_wwtp_catchment_area',
   value_de = 'GEP_ARA_Einzugsgebiet',
   value_fr = 'bassin_versant_STEP',
   value_it = 'PGS_IDA_bacino_imbrifero',
   value_ro = 'rrr_GEP_ARA_Einzugsgebiet',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gwdp_wwtp_catchment_area',
   display_de = 'GEP_ARA_Einzugsgebiet',
   display_fr = 'bassin versant STEP',
   display_it = '',
   display_ro = ''
WHERE code = 5604;

--- Adapt tww_vl.log_card_information_source
 INSERT INTO tww_vl.log_card_information_source (code, vsacode) VALUES (5602,5602) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_information_source SET
   value_en = 'gwdp_responsible_body',
   value_de = 'GEP_Traegerschaft',
   value_fr = 'entite_responsable_PGEE',
   value_it = 'PGS_ente_responsabile',
   value_ro = 'rrr_GEP_Traegerschaft',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gwdp_responsible_body',
   display_de = 'GEP_Traegerschaft',
   display_fr = 'entité résponsable PGEE',
   display_it = '',
   display_ro = ''
WHERE code = 5602;

--- Adapt tww_vl.log_card_information_source
 INSERT INTO tww_vl.log_card_information_source (code, vsacode) VALUES (5603,5603) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.log_card_information_source SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 5603;

--- Adapt tww_vl.catchment_area_direct_discharge_current
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode) VALUES (5457,5457) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_current SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5457;

--- Adapt tww_vl.catchment_area_direct_discharge_current
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode) VALUES (5458,5458) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_current SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5458;

--- Adapt tww_vl.catchment_area_direct_discharge_current
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode) VALUES (5463,5463) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5463;

--- Adapt tww_vl.catchment_area_direct_discharge_planned
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode) VALUES (5459,5459) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_planned SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5459;

--- Adapt tww_vl.catchment_area_direct_discharge_planned
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode) VALUES (5460,5460) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_planned SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5460;

--- Adapt tww_vl.catchment_area_direct_discharge_planned
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode) VALUES (5464,5464) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_direct_discharge_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5464;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (9068,9068) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'drainage_system',
   value_de = 'Drainagesystem',
   value_fr = 'systeme_de_drainage',
   value_it = 'sistema_di_drenaggio',
   value_ro = 'rrr_Drainagesystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   description_de = 'Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   description_fr = 'Surfaces drainées à l''extérieur de l''agglomération qui sont raccordées  à l''assainissement urbain.',
   description_it = 'Superfici drenate fuori dalla zona abitata, allacciate allo smaltimento della zona abitata.',
   description_ro = 'rrr_Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   display_en = 'drainage_system',
   display_de = 'Drainagesystem',
   display_fr = 'système de drainage',
   display_it = 'Sistema di drenaggio',
   display_ro = ''
WHERE code = 9068;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5186,5186) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'mixed_system',
   value_de = 'Mischsystem',
   value_fr = 'systeme_unitaire',
   value_it = 'sistema_misto',
   value_ro = 'rrr_Mischsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schmutzabwasser und Regenabwasser – soweit es nicht versickert oder verdunstet werden kamm – sind an das Mischabwassernetz angeschlossen. Verbindung zu SW/MW-Knoten obligatorisch, Verbindung zu RW-Knoten nicht zulässig.',
   description_de = 'Schmutzabwasser und Regenabwasser – soweit es nicht versickert oder verdunstet werden kann – sind an das Mischabwassernetz angeschlossen. Verbindung zu SW/MW-Knoten obligatorisch, Verbindung zu RW-Knoten nicht zulässig.',
   description_fr = 'Les eaux usées et les eaux pluviales ne pouvant pas être infiltrées ou évaporées sont raccordées au réseau d’évacuation des eaux unitaire. La liaison avec les nœuds d’EU et d’EM sont obligatoires, celle avec les nœuds EP interdites.',
   description_it = 'Le acque luride e le acque meteoriche non infiltrabili e che non evaporano devono essere allacciate alla rete delle acque miste. Collegamento obbligatorio ai nodi acque luride/miste, collegamento ad acque meteoriche non ammissibile.',
   description_ro = '',
   display_en = 'mixed_system',
   display_de = 'Mischsystem',
   display_fr = 'système unitaire',
   display_it = '',
   display_ro = ''
WHERE code = 5186;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5188,5188) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'modified_system',
   value_de = 'ModifiziertesSystem',
   value_fr = 'systeme_modifie',
   value_it = 'sistema_modificato',
   value_ro = 'rrr_ModifiziertesSystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Im Unterschied zum reinen Trennsystem wird beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer Teil des Regenabwassers zur ARA abgeleitet. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   description_de = 'Im Unterschied zum reinen Trennsystem wird beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer Teil des Regenabwassers zur ARA abgeleitet. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   description_fr = 'Contrairement au système séparatif, dans le système modifié, outre les eaux pluviales provenant surfaces non couvertes pouvant être polluées, une autre partie des eaux pluviales (nécessitant généralement un traitement) doit être acheminée vers la STEP. La liaison avec les nœuds EU/EM est obligatoire, celle avec le nœud EP est admise.',
   description_it = 'Diversamente dal sistema separato, nel sistema modificato oltre alle acque meteoriche di superfici non coperte ed esposte a incidenti deve essere condotta nell''IDA un''altra parte delle acque meteoriche (che in genere necessita di trattamento). Collegamento obbligatorio ai nodi acque luride/miste. Collegamento ammissibile ai nodi acque meteoriche.',
   description_ro = 'rrr_Im Unterschied zum reinen Trennsystem wird beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer Teil des Regenabwassers zur ARA abgeleitet. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   display_en = 'modified_system',
   display_de = 'ModifiziertesSystem',
   display_fr = 'système modifié',
   display_it = '',
   display_ro = ''
WHERE code = 5188;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5185,5185) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Teileinzugsgebiet das entwässert wird, aber nicht an eine PAA angeschlossen ist. Z.B. eine Fläche, die über eine SAA direkt in ein Gewässer entwässert wird, oder eine Fläche mit Versickerung über die Schulter. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_de = 'Teileinzugsgebiet das entwässert wird, aber nicht an eine PAA angeschlossen ist. Z.B. eine Fläche, die über eine SAA direkt in ein Gewässer entwässert wird, oder eine Fläche mit Versickerung über die Schulter. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_fr = 'Un bassin versant assaini mais non raccordé à un OAP, par exemple une surface directement raccordée vers un cours d’eau via un OAS ou une surface avec de l’infiltration par les bas côtés. Aucune liaison possible avec le réseau des canalisations.',
   description_it = 'Area tributaria da cui l''acqua viene smaltita, ma che anche in futuro non viene collegata ad un impianto IPS. P. es un''area collegata da un ISS ad un ricettore o un''area con infiltrazione sulla banchina. Un collegamento con la rete di canalizzazioni non è ammissibile.',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 5185;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5537,5537) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'not_drained',
   value_de = 'nicht_entwaessert',
   value_fr = 'non_evacue',
   value_it = 'non_evacuato',
   value_ro = 'rrr_nicht_entwaessert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungstechnisch (noch) nicht erschlossene Fläche innerhalb des öffentlichen Kanalisationsbereichs. Z.B. noch nicht überbaute Liegenschaft innerhalb der Bauzone. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_de = 'Entwässerungstechnisch (noch) nicht erschlossene Fläche innerhalb des öffentlichen Kanalisationsbereichs. Z.B. noch nicht überbaute Liegenschaft innerhalb der Bauzone. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_fr = 'Surface encore non raccordée d’un point de vue de l’assainissement, à l’intérieur du périmètre d’assainissement, par exemple des propriété non construites en zone à bâtir. Aucune liaison possible avec le réseau des canalisations.',
   description_it = 'Superficie non (ancora) servita come sistema di smaltimento acque all''interno dell''area di canalizzazione pubblica. Ad es. immobile non edificato all''interno della zona edificabile. Un collegamento alla rete di canalizzazione non è ammissibile.',
   description_ro = '',
   display_en = 'not_drained',
   display_de = 'nicht_entwaessert',
   display_fr = 'non evacué',
   display_it = '',
   display_ro = ''
WHERE code = 5537;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5187,5187) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'separated_system',
   value_de = 'Trennsystem',
   value_fr = 'systeme_separatif',
   value_it = 'sistema_separato',
   value_ro = 'rrr_Trennsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Schmutzabwasser und Regenabwasser welches gemäss aktueller Gesetzgebung als verschmutzt gilt, sind an das Schmutzabwassernetz angeschlossen, nicht verschmutztes Regenabwasser an das Regenabwassernetz. Verbindung zu SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_de = 'Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_fr = 'Système d’évacuation des eaux comprenant en principe deux systèmes de réseaux de canalisations pour l’évacuation séparée des eaux usées et des eaux pluviales. Les eaux usées  ainsi que les eaux pluviales provenant de surfaces non couvertes pouvant être polluées sont raccordées au réseau des eaux usées. Le reste des eaux pluviales qui ne peuvent pas être infiltrées ou évaporées sont raccordées au réseau d''eaux pluviales. Les liaisons avec les nœuds d’EU et d’EM ou d''EP sont obligatoires. La liaison avec un deuxième nœud (EP ou EU/EM) est autorisée.',
   description_it = 'Sistema di smaltimento usuale composto da due reti di canalizzazione per lo smaltimento separato di acque luride e meteoriche. Le acque luride e le acque meteoriche di superfici non coperte esposte a incidenti devono essere collegate alla rete delle acque luride; le restanti acque meteoriche, se non infiltrabili e se non evaporano, vanno collegate alla rete delle acque meteoriche. Il collegamento a un nodo acque luride/acque miste o a un nodo acque meteoriche è obbligatorio. Il collegamento a un secondo nodo (acque meteoriche o acque luride/miste) è ammissibile.',
   description_ro = 'rrr_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz angeschlossen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   display_en = 'separated_system',
   display_de = 'Trennsystem',
   display_fr = 'système séparatif',
   display_it = '',
   display_ro = 'rrr_Trennsystem'
WHERE code = 5187;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (5189,5189) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Das Entwässerungssystem ist noch nicht bekannt. Dieser Wert ist nur bei einer noch nicht abgeschlossenen GEP-Bearbeitung zulässig. Keine Regeln bezüglich Verbindung zum Kanalnetz.',
   description_de = 'Das Entwässerungssystem ist noch nicht bekannt. Dieser Wert ist nur bei einer noch nicht abgeschlossenen GEP-Bearbeitung zulässig. Keine Regeln bezüglich Verbindung zum Kanalnetz.',
   description_fr = 'Cette valeur n’est admise que lors de l''élaboration d’un PGEE. Aucune règle quant aux liaisons avec le réseau des canalisations.',
   description_it = 'Questo valore è ammesso unicamente durante l''elaborazione PGS. Nessuna regola relativa a collegamenti alla rete di smaltimento.',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5189;

--- Adapt tww_vl.catchment_area_drainage_system_current
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode) VALUES (8693,8693) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_current SET
   value_en = 'separated_system_in_preparation',
   value_de = 'vorbereitetes_Trennsystem',
   value_fr = 'systeme_separatif_prepare',
   value_it = 'predisposizione_sistema_separato',
   value_ro = 'rrr_vorbereitetes_Trennsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet.',
   description_de = 'Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet.',
   description_fr = 'Doit être attribuée si le sous-bassin versant est évacué en système séparatif (voir description pour cette valeur) et la conduite d''eaux pluviales OAP auquel le sous-bassin versant est raccordée débouche plus bas dans le réseau d''eaux mixtes.',
   description_it = 'Da assegnare se le aree tributarie sono drenate nel sistema misto (v. descrizione di questo valore, la condotta acque meteoriche IPS alla quale è allacciata l''area tributaria sfocia più in basso nella rete delle acque miste e la situazione non cambiera nemmeno in futuro.',
   description_ro = 'rrr_Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet.',
   display_en = 'separated_system_in_preparation',
   display_de = 'vorbereitetes_Trennsystem',
   display_fr = 'systeme séparatif préparé',
   display_it = '',
   display_ro = ''
WHERE code = 8693;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (9067,9067) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'drainage_system',
   value_de = 'Drainagesystem',
   value_fr = 'systeme_de_drainage',
   value_it = 'sistema_di_drenaggio',
   value_ro = 'rrr_Drainagesystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   description_de = 'Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   description_fr = 'Surfaces drainées à l''extérieur de l''agglomération qui sont raccordées à l''assainissement urbain.',
   description_it = 'Superfici drenate fuori dalla zona abitata, allacciate allo smaltimento della zona abitata.',
   description_ro = 'rrr_Drainierte Flächen ausserhalb Siedlungsgebiet, die an die Siedlungsentwässerung angeschlossen sind',
   display_en = 'drainage_system',
   display_de = 'Drainagesystem',
   display_fr = 'système de drainage',
   display_it = 'Sistema di drenaggio',
   display_ro = ''
WHERE code = 9067;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5191,5191) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'mixed_system',
   value_de = 'Mischsystem',
   value_fr = 'systeme_unitaire',
   value_it = 'sistema_misto',
   value_ro = 'rrr_Mischsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schmutzabwasser und Regenabwasser – soweit sie nicht versickert oder verdunstet werden – sind an das Mischabwassernetz anzuschliessen. Verbindung zu SW/MW-Knoten obligatorisch, Verbindung zu RW-Knoten nicht zulässig.',
   description_de = 'Schmutzabwasser und Regenabwasser – soweit es nicht versickert oder verdunstet werden kann – sind an das Mischabwassernetz anzuschliessen. Verbindung zu SW/MW-Knoten obligatorisch, Verbindung zu RW-Knoten nicht zulässig.',
   description_fr = 'Les eaux usées et les eaux pluviales ne pouvant pas être infiltrées ou évaporées sont à raccorder au réseau d’évacuation des eaux mixtes. La liaison avec les nœuds EU/EM est obligatoire, la liaison avec le nœud EP n’est pas admise.',
   description_it = 'Le acque luride e le acque meteoriche non infiltrabili e che non evaporano devono essere allacciate alla rete delle acque miste. Collegamento obbligatorio ai nodi acque luride/miste, collegamento ad acque meteoriche non ammissibile.',
   description_ro = 'rrr_Schmutzabwasser und Regenabwasser – soweit sie nicht versickert oder verdunstet werden – sind an das Mischabwassernetz anzuschliessen. Verbindung zu SW/MW-Knoten obligatorisch, Verbindung zu RW-Knoten nicht zulässig.',
   display_en = 'mixed_system',
   display_de = 'Mischsystem',
   display_fr = 'système unitaire',
   display_it = '',
   display_ro = ''
WHERE code = 5191;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5193,5193) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'modified_system',
   value_de = 'ModifiziertesSystem',
   value_fr = 'systeme_modifie',
   value_it = 'sistema_modificato',
   value_ro = 'rrr_ModifiziertesSystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Im Unterschied zum reinen Trennsystem ist beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer (i.d.R. behandlungsbedürftiger) Teil des Regenabwassers zur ARA abzuleiten. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   description_de = 'Im Unterschied zum reinen Trennsystem ist beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer (i.d.R. behandlungsbedürftiger) Teil des Regenabwassers zur ARA abzuleiten. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   description_fr = 'Contrairement au système séparatif, dans le système modifié, outre les eaux pluviales provenant de surfaces non couvertes pouvant être polluées, une autre partie des eaux pluviales (nécessitant généralement un traitement) doit être acheminée vers la STEP. La liaison avec les nœuds EP/EM est obligatoire, celle avec le nœud EP est admise.',
   description_it = 'Diversamente dal sistema separato, nel sistema modificato oltre alle acque meteoriche di superfici non coperte ed esposte a incidenti deve essere condotta nell''IDA un''altra parte delle acque meteoriche (che in genere necessita di trattamento). Collegamento obbligatorio ai nodi acque luride/miste. Collegamento ammissibile ai nodi acque meteoriche.',
   description_ro = 'rrr_Im Unterschied zum reinen Trennsystem ist beim modifizierten System neben dem Regenabwasser von nicht überdachten havariegefährdeten Flächen ein weiterer (i.d.R. behandlungsbedürftiger) Teil des Regenabwassers zur ARA abzuleiten. Verbindung zu SW/MW-Knoten ist obligatorisch. Verbindung zu RW-Knoten zulässig.',
   display_en = 'modified_system',
   display_de = 'ModifiziertesSystem',
   display_fr = 'système modifié',
   display_it = '',
   display_ro = 'rrr_ModifiziertesSystem'
WHERE code = 5193;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5194,5194) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Teileinzugsgebiet, das entwässert wird, aber (auch in Zukunft) nicht an eine PAA angeschlossen ist. Z.B. eine Fläche, die über eine SAA direkt in ein Gewässer entwässert wird, oder eine Fläche mit Versickerung über die Schulter. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_de = 'Teileinzugsgebiet, das entwässert wird, aber (auch in Zukunft) nicht an eine PAA angeschlossen ist. Z.B. eine Fläche, die über eine SAA direkt in ein Gewässer entwässert wird, oder eine Fläche mit Versickerung über die Schulter. Keine Verbindung mit dem Kanalnetz zulässig.',
   description_fr = 'Un bassin versant à assainir mais non raccordé (ultérieurement) à un OAP, par exemple une surface directement raccordée vers un cours d’eau via un OAS ou une surface avec de l’infiltration par les bas côtés. Aucune liaison possible avec le réseau des canalisations.',
   description_it = 'Area tributaria da cui l''acqua viene smaltita, ma che anche in futuro non viene collegata ad un impianto IPS. P. es un''area collegata da un ISS ad un ricettore o un''area con infiltrazione sulla banchina. Un collegamento con la rete di canalizzazioni non è ammissibile.',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 5194;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5536,5536) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'not_drained',
   value_de = 'nicht_entwaessert',
   value_fr = 'non_evacue',
   value_it = 'non_evacuato',
   value_ro = 'rrr_nicht_entwaessert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fläche innerhalb des öffentlichen Kanalisationsbereichs, die auch in Zukunft nicht erschlossen wird (seltener Fall). Keine Verbindung mit dem Kanalnetz zulässig.',
   description_de = 'Fläche innerhalb des öffentlichen Kanalisationsbereichs, die auch in Zukunft nicht erschlossen wird (seltener Fall). Keine Verbindung mit dem Kanalnetz zulässig.',
   description_fr = 'Surface encore à l’intérieur du périmètre d’assainissement qui ne sera pas raccordée (cas rare). Aucune liaison possible avec le réseau des canalisations.',
   description_it = 'Area all''interno della zona servita che anche in futuro non sarà collegatra alla canalizzazione. Un collegamento alla rete di canalizzazione non è ammissibile.',
   description_ro = '',
   display_en = 'not_drained',
   display_de = 'nicht_entwaessert',
   display_fr = 'non evacué',
   display_it = '',
   display_ro = ''
WHERE code = 5536;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5192,5192) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'separated_system',
   value_de = 'Trennsystem',
   value_fr = 'systeme_separatif',
   value_it = 'sistema_separato',
   value_ro = 'rrr_Trennsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz anzuschliessen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_de = 'Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz anzuschliessen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   description_fr = 'Système d’évacuation des eaux comprenant en principe deux systèmes de réseaux de canalisations pour l’évacuation séparée des eaux usées et des eaux pluviales. Les eaux usées  ainsi que les eaux pluviales provenant de surfaces non couvertes pouvant être polluées sont à raccorder au réseau des eaux usées. Le reste des eaux pluviales qui ne peuvent pas être infiltrées ou évaporées sont à raccorder au réseaux des eaux pluviales. Les liaisons avec les nœuds d’EU et d’EM ou d''EP sont obligatoires. La liaison avec un deuxième nœud (EP ou EU/EM) est autorisée.',
   description_it = 'Sistema di smaltimento usuale composto da due reti di canalizzazione per lo smaltimento separato di acque luride e meteoriche. Le acque luride e le acque meteoriche di superfici non coperte esposte a incidenti devono essere collegate alla rete delle acque luride; le restanti acque meteoriche, se non infiltrabili e se non evaporano, vanno collegate alla rete delle acque meteoriche. Il collegamento a un nodo acque luride/acque miste o a un nodo acque meteoriche è obbligatorio. Il collegamento a un secondo nodo (acque meteoriche o acque luride/miste) è ammissibile.',
   description_ro = 'rrr_Entwässerungssystem, üblicherweise bestehend aus zwei Leitungs-/Kanalsystemen für die getrennte Ableitung von Schmutz- und Regenabwasser. Das Schmutzabwasser sowie das Regenabwasser von nicht überdachten havariegefährdeten Flächen sind an das Schmutzabwassernetz anzuschliessen, das übrige Regenabwasser – soweit es nicht versickert oder verdunstet wird – an das Regenabwassernetz. Verbindung zu einem SW/MW-Knoten oder RW-Knoten ist obligatorisch. Verbindung zu zweitem Knoten (RW bzw. SW/MW-Knoten) ist zulässig.',
   display_en = 'separated_system',
   display_de = 'Trennsystem',
   display_fr = 'système séparatif',
   display_it = '',
   display_ro = 'rrr_Trennsystem'
WHERE code = 5192;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (5195,5195) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dieser Wert ist nur bei einer noch nicht abgeschlossenen GEP-Bearbeitung zulässig. Keine Regeln bezüglich Verbindung zum Kanalnetz.',
   description_de = 'Dieser Wert ist nur bei einer noch nicht abgeschlossenen GEP-Bearbeitung zulässig. Keine Regeln bezüglich Verbindung zum Kanalnetz.',
   description_fr = 'Cette valeur n’est admise que lors de l''élaboration d’un PGEE. Aucune règle quant aux liaisons avec le réseau des canalisations.',
   description_it = 'Questo valore è ammesso unicamente durante l''elaborazione PGS. Nessuna regola relativa a collegamenti alla rete di smaltimento.',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5195;

--- Adapt tww_vl.catchment_area_drainage_system_planned
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode) VALUES (8692,8692) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_drainage_system_planned SET
   value_en = 'separated_system_in_preparation',
   value_de = 'vorbereitetes_Trennsystem',
   value_fr = 'systeme_separatif_prepare',
   value_it = 'predisposizione_sistema_separato',
   value_ro = 'rrr_vorbereitetes_Trennsystem',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet und dies auch in Zukunft nicht ändern wird.',
   description_de = 'Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet und dies auch in Zukunft nicht ändern wird.',
   description_fr = 'Les sous-bassins versants dont les eaux usées sont évacuées par un réseau d''eaux usées et les eaux pluviales par un réseau d''eaux pluviales doivent, d''après le guide, avoir le SYSTEME_EVACUATION_EAUX_ACTUEL "systeme_separatif". Si les conduites d''eaux pluviales OAP débouchent ensuite sur le système mixte car le système séparatif n''est pas terminé (et ne sera peut-être jamais réalisé), l''attribut systeme_separatif peut être trompeur.',
   description_it = 'Da assegnare se le aree tributarie sono smaltite nel sistema misto (v. descrizione di questo valore, la condotta acque meteoriche IPS alla quale è allacciata l''area tributaria sfocia più in basso nella rete delle acque miste e la situazione non cambiera nemmeno in futuro.',
   description_ro = 'rrr_Ist zu vergeben, wenn Teileinzugsgebiete im Trennsystem entwässert sind (siehe Beschreibung zu diesem Wert), die PAA-Regenabwasserleitung, an die das Teileinzugsgebiet angeschlossen ist, aber weiter unten ins Mischabwassernetz mündet und dies auch in Zukunft nicht ändern wird.',
   display_en = 'separated_system_in_preparation',
   display_de = 'vorbereitetes_Trennsystem',
   display_fr = 'systeme séparatif préparé',
   display_it = '',
   display_ro = ''
WHERE code = 8692;

--- Adapt tww_vl.catchment_area_infiltration_current
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode) VALUES (5452,5452) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_current SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5452;

--- Adapt tww_vl.catchment_area_infiltration_current
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode) VALUES (5453,5453) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_current SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5453;

--- Adapt tww_vl.catchment_area_infiltration_current
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode) VALUES (5165,5165) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5165;

--- Adapt tww_vl.catchment_area_infiltration_planned
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode) VALUES (5461,5461) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_planned SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5461;

--- Adapt tww_vl.catchment_area_infiltration_planned
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode) VALUES (5462,5462) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_planned SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5462;

--- Adapt tww_vl.catchment_area_infiltration_planned
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode) VALUES (5170,5170) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_infiltration_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5170;

--- Adapt tww_vl.catchment_area_retention_current
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode) VALUES (5467,5467) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_current SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5467;

--- Adapt tww_vl.catchment_area_retention_current
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode) VALUES (5468,5468) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_current SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5468;

--- Adapt tww_vl.catchment_area_retention_current
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode) VALUES (5469,5469) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5469;

--- Adapt tww_vl.catchment_area_retention_planned
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode) VALUES (5470,5470) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_planned SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5470;

--- Adapt tww_vl.catchment_area_retention_planned
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode) VALUES (5471,5471) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_planned SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5471;

--- Adapt tww_vl.catchment_area_retention_planned
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode) VALUES (5472,5472) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_retention_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5472;

--- Adapt tww_vl.measuring_point_damming_device
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode) VALUES (5720,5720) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_damming_device SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5720;

--- Adapt tww_vl.measuring_point_damming_device
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode) VALUES (5721,5721) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_damming_device SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 5721;

--- Adapt tww_vl.measuring_point_damming_device
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode) VALUES (5722,5722) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_damming_device SET
   value_en = 'overflow_weir',
   value_de = 'Ueberfallwehr',
   value_fr = 'lame_deversante',
   value_it = 'sfioratore',
   value_ro = 'rrr_Ueberfallwehr',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'All shape like triangle weir etc.',
   description_de = 'Alle Formen wie Dreieckwehr etc.',
   description_fr = 'toutes les formes, telles que seuil en bec de canard, etc.',
   description_it = 'zzz_Alle Formen wie Dreieckwehr etc.',
   description_ro = '',
   display_en = 'overflow_weir',
   display_de = 'Ueberfallwehr',
   display_fr = 'lame déversante',
   display_it = '',
   display_ro = ''
WHERE code = 5722;

--- Adapt tww_vl.measuring_point_damming_device
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode) VALUES (5724,5724) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_damming_device SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5724;

--- Adapt tww_vl.measuring_point_damming_device
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode) VALUES (5723,5723) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_damming_device SET
   value_en = 'venturi_necking',
   value_de = 'Venturieinschnuerung',
   value_fr = 'etranglement_venturi',
   value_it = 'restringimento_venturi',
   value_ro = 'rrr_Venturieinschnuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'venturi_necking',
   display_de = 'Venturieinschnuerung',
   display_fr = 'étranglement venturi',
   display_it = '',
   display_ro = ''
WHERE code = 5723;

--- Adapt tww_vl.measuring_point_purpose
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode) VALUES (4595,4595) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_purpose SET
   value_en = 'both',
   value_de = 'beides',
   value_fr = 'les_deux',
   value_it = 'entrambi',
   value_ro = 'rrr_beides',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cost sharing and technical purpose',
   description_de = 'Kostenverteilung und technischer Zweck',
   description_fr = 'Répartition des coûts et but technique',
   description_it = 'zzz_Kostenverteilung und technischer Zweck',
   description_ro = '',
   display_en = 'both',
   display_de = 'beides',
   display_fr = 'les deux',
   display_it = '',
   display_ro = ''
WHERE code = 4595;

--- Adapt tww_vl.measuring_point_purpose
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode) VALUES (4593,4593) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_purpose SET
   value_en = 'cost_sharing',
   value_de = 'Kostenverteilung',
   value_fr = 'repartition_des_couts',
   value_it = 'ripartizione_costi',
   value_ro = 'rrr_Kostenverteilung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cost_sharing',
   display_de = 'Kostenverteilung',
   display_fr = 'répartition des coûts',
   display_it = '',
   display_ro = ''
WHERE code = 4593;

--- Adapt tww_vl.measuring_point_purpose
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode) VALUES (4594,4594) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_purpose SET
   value_en = 'technical_purpose',
   value_de = 'technischer_Zweck',
   value_fr = 'but_technique',
   value_it = 'scopo_tecnico',
   value_ro = 'rrr_technischer_Zweck',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'technical purpose for example control',
   description_de = 'Technischer Zweck, z.B. zur Steuerung',
   description_fr = 'but technique par example réglage',
   description_it = 'zzz_Technischer Zweck, z.B. zur Steuerung',
   description_ro = '',
   display_en = 'technical_purpose',
   display_de = 'technischer_Zweck',
   display_fr = 'but téchnique',
   display_it = '',
   display_ro = ''
WHERE code = 4594;

--- Adapt tww_vl.measuring_point_purpose
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode) VALUES (4592,4592) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_point_purpose SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4592;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5702,5702) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5702;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5703,5703) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'static_sounding_stick',
   value_de = 'Drucksonde',
   value_fr = 'sonde_de_pression',
   value_it = 'sensore_pressione',
   value_ro = 'rrr_Drucksonde',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'static_sounding_stick',
   display_de = 'Drucksonde',
   display_fr = 'sonde de préssion',
   display_it = '',
   display_ro = ''
WHERE code = 5703;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5704,5704) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'bubbler_system',
   value_de = 'Lufteinperlung',
   value_fr = 'injection_bulles_d_air',
   value_it = 'insufflazione',
   value_ro = 'rrr_Lufteinperlung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'bubbler_system',
   display_de = 'Lufteinperlung',
   display_fr = 'injection bulle d''air',
   display_it = '',
   display_ro = ''
WHERE code = 5704;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5705,5705) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'EMF_partly_filled',
   value_de = 'MID_teilgefuellt',
   value_fr = 'MID_partiellement_rempli',
   value_it = 'MPE_parzialmente_riempito',
   value_ro = 'rrr_MID_teilgefuellt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Electro-magnetic / Magnetic-inductive flow meter for partly filled pipes',
   description_de = 'Magnetisch-induktives Durchflussmesssgerät für teilgefüllte Rohre',
   description_fr = 'Débitmètre électromagnétique pour tuyau partiellement rempli',
   description_it = 'Misuratore di portata elettromagnetico per condotte parzialmente riempite',
   description_ro = '',
   display_en = 'EMF_partly_filled',
   display_de = 'MID_teilgefuellt',
   display_fr = 'DEM partiellement rempli',
   display_it = '',
   display_ro = ''
WHERE code = 5705;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5706,5706) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'EMF_filled',
   value_de = 'MID_vollgefuellt',
   value_fr = 'MID_rempli',
   value_it = 'MPE_riempito',
   value_ro = 'rrr_MID_vollgefuellt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Electro-magnetic / Magnetic-inductive flow meter for fully filled pipes',
   description_de = 'Magnetisch-induktives Durchflussmesssgerät für vollgefüllte Rohre',
   description_fr = 'Débitmètre électromagnétique pour tuyau rempli',
   description_it = 'Misuratore di portata elettromagnetico per condotte riempite',
   description_ro = '',
   display_en = 'EMF_filled',
   display_de = 'MID_vollgefuellt',
   display_fr = 'DEM rempli',
   display_it = '',
   display_ro = ''
WHERE code = 5706;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5707,5707) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'radar',
   value_de = 'Radar',
   value_fr = 'radar',
   value_it = 'radar',
   value_ro = 'radar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'radar',
   display_de = 'Radar',
   display_fr = 'radar',
   display_it = '',
   display_ro = ''
WHERE code = 5707;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5708,5708) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'float',
   value_de = 'Schwimmer',
   value_fr = 'flotteur',
   value_it = 'galleggiante',
   value_ro = 'rrr_Schwimmer',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'float',
   display_de = 'Schwimmer',
   display_fr = 'flotteur',
   display_it = '',
   display_ro = ''
WHERE code = 5708;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (6322,6322) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'ultrasound',
   value_de = 'Ultraschall',
   value_fr = 'ultrason',
   value_it = 'ultrasuono',
   value_ro = 'ultrasunete',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'ultrasound',
   display_de = 'Ultraschall',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code = 6322;

--- Adapt tww_vl.measuring_device_kind
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode) VALUES (5709,5709) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measuring_device_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5709;

--- Adapt tww_vl.measurement_series_kind
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode) VALUES (3217,3217) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_series_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 3217;

--- Adapt tww_vl.measurement_series_kind
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode) VALUES (2646,2646) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_series_kind SET
   value_en = 'continuous',
   value_de = 'kontinuierlich',
   value_fr = 'continu',
   value_it = 'zzz_kontinuierlich',
   value_ro = 'rrr_kontinuierlich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'continuous',
   display_de = 'kontinuierlich',
   display_fr = 'continu',
   display_it = '',
   display_ro = ''
WHERE code = 2646;

--- Adapt tww_vl.measurement_series_kind
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode) VALUES (2647,2647) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_series_kind SET
   value_en = 'rain_weather',
   value_de = 'Regenwetter',
   value_fr = 'temps_de_pluie',
   value_it = 'tempo_pioggia',
   value_ro = 'rrr_Regenwetter',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'rain_weather',
   display_de = 'Regenwetter',
   display_fr = 'temps de pluie',
   display_it = '',
   display_ro = ''
WHERE code = 2647;

--- Adapt tww_vl.measurement_series_kind
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode) VALUES (8778,8778) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_series_kind SET
   value_en = 'simulation',
   value_de = 'Simulation',
   value_fr = 'simulation',
   value_it = 'simulazione',
   value_ro = 'rrr_Simulation',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Results from a (hydraulic) simulation',
   description_de = 'Resultate aus einer (hydraulischen) Simulation',
   description_fr = 'Résultats d''une simulation (hydraulique)',
   description_it = 'Risultati di una simulazione (idraulica)',
   description_ro = '',
   display_en = 'simulation',
   display_de = 'Simulation',
   display_fr = 'simulation',
   display_it = '',
   display_ro = ''
WHERE code = 8778;

--- Adapt tww_vl.measurement_series_kind
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode) VALUES (3053,3053) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_series_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3053;

--- Adapt tww_vl.measurement_result_measurement_type
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode) VALUES (5732,5732) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_result_measurement_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5732;

--- Adapt tww_vl.measurement_result_measurement_type
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode) VALUES (5733,5733) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_result_measurement_type SET
   value_en = 'flow',
   value_de = 'Durchfluss',
   value_fr = 'debit',
   value_it = 'portata',
   value_ro = 'rrr_Durchfluss',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'flow',
   display_de = 'Durchfluss',
   display_fr = 'débit',
   display_it = '',
   display_ro = ''
WHERE code = 5733;

--- Adapt tww_vl.measurement_result_measurement_type
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode) VALUES (5734,5734) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_result_measurement_type SET
   value_en = 'level',
   value_de = 'Niveau',
   value_fr = 'niveau',
   value_it = 'livello',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'level',
   display_de = 'Niveau',
   display_fr = 'niveau',
   display_it = '',
   display_ro = ''
WHERE code = 5734;

--- Adapt tww_vl.measurement_result_measurement_type
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode) VALUES (5735,5735) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.measurement_result_measurement_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5735;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (3667,3667) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 3667;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (301,301) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'gaz_engine',
   value_de = 'Benzinmotor',
   value_fr = 'moteur_a_essence',
   value_it = 'zzz_Benzinmotor',
   value_ro = 'motor_benzina',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gaz_engine',
   display_de = 'Benzinmotor',
   display_fr = 'moteur à essence',
   display_it = '',
   display_ro = 'motor benzina'
WHERE code = 301;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (302,302) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'diesel_engine',
   value_de = 'Dieselmotor',
   value_fr = 'moteur_diesel',
   value_it = 'zzz_Dieselmotor',
   value_ro = 'motor_diesel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'diesel_engine',
   display_de = 'Dieselmotor',
   display_fr = 'moteur diesel',
   display_it = '',
   display_ro = 'motor diesel'
WHERE code = 302;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (303,303) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'electric_engine',
   value_de = 'Elektromotor',
   value_fr = 'moteur_electrique',
   value_it = 'zzz_Elektromotor',
   value_ro = 'motor_electric',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'electric_engine',
   display_de = 'Elektromotor',
   display_fr = 'moteur électrique',
   display_it = '',
   display_ro = 'motor electric'
WHERE code = 303;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (433,433) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'hydraulic',
   value_de = 'hydraulisch',
   value_fr = 'hydraulique',
   value_it = 'zzz_hydraulisch',
   value_ro = 'hidraulic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'hydraulic',
   display_de = 'hydraulisch',
   display_fr = 'hydraulique',
   display_it = '',
   display_ro = 'hidraulic'
WHERE code = 433;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (300,300) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 300;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (305,305) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'manual',
   value_de = 'manuell',
   value_fr = 'manuel',
   value_it = 'zzz_manuell',
   value_ro = 'manual',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'manual',
   display_de = 'manuell',
   display_fr = 'manuel',
   display_it = '',
   display_ro = 'manual'
WHERE code = 305;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (304,304) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'pneumatic',
   value_de = 'pneumatisch',
   value_fr = 'pneumatique',
   value_it = 'zzz_pneumatisch',
   value_ro = 'pneumatic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pneumatic',
   display_de = 'pneumatisch',
   display_fr = 'pneumatique',
   display_it = '',
   display_ro = 'pneumatic'
WHERE code = 304;

--- Adapt tww_vl.overflow_actuation
 INSERT INTO tww_vl.overflow_actuation (code, vsacode) VALUES (3005,3005) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_actuation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3005;

--- Adapt tww_vl.overflow_adjustability
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode) VALUES (355,355) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_adjustability SET
   value_en = 'fixed',
   value_de = 'fest',
   value_fr = 'fixe',
   value_it = 'zzz_fest',
   value_ro = 'rrr_fix',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'fixed',
   display_de = 'fest',
   display_fr = 'fixe',
   display_it = '',
   display_ro = ''
WHERE code = 355;

--- Adapt tww_vl.overflow_adjustability
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode) VALUES (3021,3021) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_adjustability SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3021;

--- Adapt tww_vl.overflow_adjustability
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode) VALUES (356,356) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_adjustability SET
   value_en = 'adjustable',
   value_de = 'verstellbar',
   value_fr = 'reglable',
   value_it = 'zzz_verstellbar',
   value_ro = 'rrr_verstellbar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'adjustable',
   display_de = 'verstellbar',
   display_fr = 'réglable',
   display_it = '',
   display_ro = ''
WHERE code = 356;

--- Adapt tww_vl.overflow_control
 INSERT INTO tww_vl.overflow_control (code, vsacode) VALUES (308,308) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_control SET
   value_en = 'closed_loop_control',
   value_de = 'geregelt',
   value_fr = 'avec_regulation',
   value_it = 'zzz_geregelt',
   value_ro = 'rrr_geregelt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Closing the loop (= add a feedback signal), makes it closed loop control',
   description_de = 'Die Regelung ist ein Vorgang in einem System, bei dem die zu regelnde Größe fortlaufend gemessen und mit dem Sollwert verglichen wird. Bei Abweichungen wird dieser korrigiert bzw. angepasst.',
   description_fr = 'La régulation est un procédé dans un système, où la grandeur à régler est mesurée en permanence et comparée à une valeur étalon. Lors de déviations, cette valeur est corrigée, voire adaptée.',
   description_it = 'zzz_Die Regelung ist ein Vorgang in einem System, bei dem die zu regelnde Größe fortlaufend gemessen und mit dem Sollwert verglichen wird. Bei Abweichungen wird dieser korrigiert bzw. angepasst.',
   description_ro = '',
   display_en = 'closed_loop_control',
   display_de = 'geregelt',
   display_fr = 'avec régulation',
   display_it = '',
   display_ro = ''
WHERE code = 308;

--- Adapt tww_vl.overflow_control
 INSERT INTO tww_vl.overflow_control (code, vsacode) VALUES (307,307) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_control SET
   value_en = 'open_loop_control',
   value_de = 'gesteuert',
   value_fr = 'avec_commande',
   value_it = 'zzz_gesteuert',
   value_ro = 'rrr_gesteuert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'An open-loop control system doesn''t have or doesn''t use feedback',
   description_de = 'Steuern nennt man einen Vorgang, bei dem eine Eingangsgrösse, durch bestimmte Gesetzmässigkeiten im System, eine Ausgangsgrösse beeinflusst.',
   description_fr = 'La commande est un processus déterminant un résultat influencé par une donnée de base et les régularités d’un système.',
   description_it = 'zzz_Steuern nennt man einen Vorgang, bei dem eine Eingangsgrösse, durch bestimmte Gesetzmässigkeiten im System, eine Ausgangsgrösse beeinflusst.',
   description_ro = '',
   display_en = 'open_loop_control',
   display_de = 'gesteuert',
   display_fr = 'avec commande',
   display_it = '',
   display_ro = ''
WHERE code = 307;

--- Adapt tww_vl.overflow_control
 INSERT INTO tww_vl.overflow_control (code, vsacode) VALUES (306,306) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_control SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 306;

--- Adapt tww_vl.overflow_control
 INSERT INTO tww_vl.overflow_control (code, vsacode) VALUES (3028,3028) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_control SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3028;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (3228,3228) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 3228;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (3384,3384) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'internal',
   value_de = 'intern',
   value_fr = 'interne',
   value_it = 'zzz_intern',
   value_ro = 'rrr_intern',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Interner Weiterfluss ohne Verzweigung (v.a. bei Pumpen)',
   description_de = 'Interner Weiterfluss ohne Verzweigung (v.a. bei Pumpen)',
   description_fr = 'Passage interne sans ramification (pompes)',
   description_it = 'zzz_Interner Weiterfluss ohne Verzweigung (v.a. bei Pumpen)',
   description_ro = '',
   display_en = 'internal',
   display_de = 'intern',
   display_fr = 'interne',
   display_it = '',
   display_ro = ''
WHERE code = 3384;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (217,217) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'emergency_overflow',
   value_de = 'Notentlastung',
   value_fr = 'deversoir_de_secours',
   value_it = 'scarico_emergenza',
   value_ro = 'rrr_Notentlastung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bauwerk zur Ableitung von Wasser bei einem Betriebsversagen',
   description_de = 'Bauwerk zur Ableitung von Wasser bei einem Betriebsversagen',
   description_fr = 'Déversement entrant en action lors d''une défaillance technique',
   description_it = 'zzz_Bauwerk zur Ableitung von Wasser bei einem Betriebsversagen',
   description_ro = '',
   display_en = 'emergency_overflow',
   display_de = 'Notentlastung',
   display_fr = 'déversoir de secours',
   display_it = '',
   display_ro = ''
WHERE code = 217;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (5544,5544) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'stormwater_overflow',
   value_de = 'Regenueberlauf',
   value_fr = 'deversoir_d_orage',
   value_it = 'scaricatore_piena',
   value_ro = 'preaplin',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ueberlauf  zur Entlastung von Mischabwasser beim Überschreiten des Dimensionierungsabflusses in ein Gewässer',
   description_de = 'Ueberlauf zur Entlastung von Mischabwasser beim Überschreiten des Dimensionierungsabflusses in ein Gewässer.',
   description_fr = 'Déversoir servant à décharger les débits de pointe du réseau des canalisations d’eaux mixtes dans un cours d''eau ou plan d''eau.',
   description_it = 'zzz_Ueberlauf zur Entlastung von Mischabwasser beim Überschreiten des Dimensionierungsabflusses in ein Gewäser',
   description_ro = 'rrr_Ueberlauf zur Entlastung von Mischabwasser beim Überschreiten des Dimensionierungsabflusses in ein Gewässer',
   display_en = 'stormwater_overflow',
   display_de = 'Regenueberlauf',
   display_fr = 'dévérsoir d''orage',
   display_it = '',
   display_ro = ''
WHERE code = 5544;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (5546,5546) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'internal_overflow',
   value_de = 'Trennueberlauf',
   value_fr = 'deversoir_interne',
   value_it = 'zzz_Trennueberlauf',
   value_ro = 'rrr_Trennueberlauf',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_interne Entlastung im Kanalnetz, z.B. in ein Becken oder in einen anderen Kanal.',
   description_de = 'interne Entlastung im Kanalnetz, z.B. in ein Becken oder in einen anderen Kanal.',
   description_fr = 'Déversoir interne dans le réseau, par exemple dans un bassin ou autre canalisation',
   description_it = 'zzz_interne Entlastung im Kanalnetz, z.B. in ein Becken oder in einen anderen Kanal.',
   description_ro = '',
   display_en = 'internal_overflow',
   display_de = 'Trennueberlauf',
   display_fr = 'déversoir interne',
   display_it = '',
   display_ro = ''
WHERE code = 5546;

--- Adapt tww_vl.overflow_function
 INSERT INTO tww_vl.overflow_function (code, vsacode) VALUES (3010,3010) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3010;

--- Adapt tww_vl.overflow_signal_transmission
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode) VALUES (2694,2694) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_signal_transmission SET
   value_en = 'receiving',
   value_de = 'empfangen',
   value_fr = 'recevoir',
   value_it = 'zzz_empfangen',
   value_ro = 'rrr_empfangen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'receiving',
   display_de = 'empfangen',
   display_fr = 'recevoir',
   display_it = '',
   display_ro = ''
WHERE code = 2694;

--- Adapt tww_vl.overflow_signal_transmission
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode) VALUES (2693,2693) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_signal_transmission SET
   value_en = 'sending',
   value_de = 'senden',
   value_fr = 'emettre',
   value_it = 'zzz_senden',
   value_ro = 'rrr_senden',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sending',
   display_de = 'senden',
   display_fr = 'émettre',
   display_it = '',
   display_ro = ''
WHERE code = 2693;

--- Adapt tww_vl.overflow_signal_transmission
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode) VALUES (2695,2695) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_signal_transmission SET
   value_en = 'sending_receiving',
   value_de = 'senden_empfangen',
   value_fr = 'emettre_recevoir',
   value_it = 'zzz_senden_empfangen',
   value_ro = 'rrr_senden_empfangen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sending_receiving',
   display_de = 'senden_empfangen',
   display_fr = 'émettre et recevoir',
   display_it = '',
   display_ro = ''
WHERE code = 2695;

--- Adapt tww_vl.overflow_signal_transmission
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode) VALUES (3056,3056) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.overflow_signal_transmission SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3056;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3213,3213) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = 'altul'
WHERE code = 3213;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3154,3154) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'gaz_engine',
   value_de = 'Benzinmotor',
   value_fr = 'moteur_a_essence',
   value_it = 'zzz_Benzinmotor',
   value_ro = 'motor_benzina',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gaz_engine',
   display_de = 'Benzinmotor',
   display_fr = 'moteur à essence',
   display_it = '',
   display_ro = 'motor benzina'
WHERE code = 3154;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3155,3155) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'diesel_engine',
   value_de = 'Dieselmotor',
   value_fr = 'moteur_diesel',
   value_it = 'zzz_Dieselmotor',
   value_ro = 'motor_diesel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'diesel_engine',
   display_de = 'Dieselmotor',
   display_fr = 'moteur diesel',
   display_it = '',
   display_ro = 'motor diesel'
WHERE code = 3155;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3156,3156) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'electric_engine',
   value_de = 'Elektromotor',
   value_fr = 'moteur_electrique',
   value_it = 'zzz_Elektromotor',
   value_ro = 'motor_electric',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'electric_engine',
   display_de = 'Elektromotor',
   display_fr = 'moteur électrique',
   display_it = '',
   display_ro = 'motor electric'
WHERE code = 3156;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3152,3152) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'hydraulic',
   value_de = 'hydraulisch',
   value_fr = 'hydraulique',
   value_it = 'zzz_hydraulisch',
   value_ro = 'hidraulic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'hydraulic',
   display_de = 'hydraulisch',
   display_fr = 'hydraulique',
   display_it = '',
   display_ro = 'hidraulic'
WHERE code = 3152;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3153,3153) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'niciunul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = 'niciunul'
WHERE code = 3153;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3157,3157) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'manual',
   value_de = 'manuell',
   value_fr = 'manuel',
   value_it = 'zzz_manuell',
   value_ro = 'manual',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'manual',
   display_de = 'manuell',
   display_fr = 'manuel',
   display_it = '',
   display_ro = 'manual'
WHERE code = 3157;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3158,3158) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'pneumatic',
   value_de = 'pneumatisch',
   value_fr = 'pneumatique',
   value_it = 'zzz_pneumatisch',
   value_ro = 'pneumatic',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pneumatic',
   display_de = 'pneumatisch',
   display_fr = 'pneumatique',
   display_it = '',
   display_ro = 'pneumatic'
WHERE code = 3158;

--- Adapt tww_vl.throttle_shut_off_unit_actuation
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode) VALUES (3151,3151) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_actuation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscut',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'necunoscut'
WHERE code = 3151;

--- Adapt tww_vl.throttle_shut_off_unit_adjustability
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode) VALUES (3159,3159) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_adjustability SET
   value_en = 'fixed',
   value_de = 'fest',
   value_fr = 'fixe',
   value_it = 'zzz_fest',
   value_ro = 'rrr_fix',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'fixed',
   display_de = 'fest',
   display_fr = 'fixe',
   display_it = '',
   display_ro = ''
WHERE code = 3159;

--- Adapt tww_vl.throttle_shut_off_unit_adjustability
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode) VALUES (3161,3161) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_adjustability SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3161;

--- Adapt tww_vl.throttle_shut_off_unit_adjustability
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode) VALUES (3160,3160) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_adjustability SET
   value_en = 'adjustable',
   value_de = 'verstellbar',
   value_fr = 'reglable',
   value_it = 'zzz_verstellbar',
   value_ro = 'rrr_verstellbar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'adjustable',
   display_de = 'verstellbar',
   display_fr = 'réglable',
   display_it = '',
   display_ro = ''
WHERE code = 3160;

--- Adapt tww_vl.throttle_shut_off_unit_control
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode) VALUES (3162,3162) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_control SET
   value_en = 'closed_loop_control',
   value_de = 'geregelt',
   value_fr = 'avec_regulation',
   value_it = 'zzz_geregelt',
   value_ro = 'rrr_geregelt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Closing the loop (= add a feedback signal), makes it closed loop control',
   description_de = 'Die Regelung ist ein Vorgang in einem System, bei dem die zu regelnde Größe fortlaufend gemessen und mit dem Sollwert verglichen wird. Bei Abweichungen wird dieser korrigiert bzw. angepasst.',
   description_fr = 'La régulation est un procédé dans un système, où la grandeur à régler est mesurée en permanence et comparée à une valeur étalon. Lors de déviations, cette valeur est corrigée, voire adaptée.',
   description_it = 'zzz_Die Regelung ist ein Vorgang in einem System, bei dem die zu regelnde Größe fortlaufend gemessen und mit dem Sollwert verglichen wird. Bei Abweichungen wird dieser korrigiert bzw. angepasst.',
   description_ro = '',
   display_en = 'closed_loop_control',
   display_de = 'geregelt',
   display_fr = 'avec régulation',
   display_it = '',
   display_ro = ''
WHERE code = 3162;

--- Adapt tww_vl.throttle_shut_off_unit_control
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode) VALUES (3163,3163) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_control SET
   value_en = 'open_loop_control',
   value_de = 'gesteuert',
   value_fr = 'avec_commande',
   value_it = 'zzz_gesteuert',
   value_ro = 'rrr_gesteuert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'An open-loop control system doesn''t have or doesn''t use feedback',
   description_de = 'Steuern nennt man einen Vorgang, bei dem eine Eingangsgrösse, durch bestimmte Gesetzmässigkeiten im System, eine Ausgangsgrösse beeinflusst.',
   description_fr = 'La commande est un processus déterminant un résultat influencé par une donnée de base et les régularités d’un système.',
   description_it = 'zzz_Steuern nennt man einen Vorgang, bei dem eine Eingangsgrösse, durch bestimmte Gesetzmässigkeiten im System, eine Ausgangsgrösse beeinflusst.',
   description_ro = '',
   display_en = 'open_loop_control',
   display_de = 'gesteuert',
   display_fr = 'avec commande',
   display_it = '',
   display_ro = ''
WHERE code = 3163;

--- Adapt tww_vl.throttle_shut_off_unit_control
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode) VALUES (3165,3165) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_control SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 3165;

--- Adapt tww_vl.throttle_shut_off_unit_control
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode) VALUES (3164,3164) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_control SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3164;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2973,2973) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2973;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2746,2746) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'orifice',
   value_de = 'Blende',
   value_fr = 'diaphragme_ou_seuil',
   value_it = 'zzz_Blende',
   value_ro = 'diafragma_sau_prag',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'orifice',
   display_de = 'Blende',
   display_fr = 'diaphragme ou seuil',
   display_it = '',
   display_ro = 'diafragma sau prag'
WHERE code = 2746;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2691,2691) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'stop_log',
   value_de = 'Dammbalken',
   value_fr = 'batardeau',
   value_it = 'zzz_Dammbalken',
   value_ro = 'rrr_Dammbalken',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'stop_log',
   display_de = 'Dammbalken',
   display_fr = 'batardeau',
   display_it = '',
   display_ro = ''
WHERE code = 2691;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (252,252) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'throttle_flap',
   value_de = 'Drosselklappe',
   value_fr = 'clapet_de_limitation',
   value_it = 'zzz_Drosselklappe',
   value_ro = 'rrr_Drosselklappe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflussregulator',
   description_de = 'Abflussregulator',
   description_fr = 'regulateur_de_debit',
   description_it = 'zzz_Abflussregulator',
   description_ro = '',
   display_en = 'throttle_flap',
   display_de = 'Drosselklappe',
   display_fr = 'clapet de limitation',
   display_it = '',
   display_ro = ''
WHERE code = 252;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (135,135) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'throttle_valve',
   value_de = 'Drosselschieber',
   value_fr = 'vanne_de_limitation',
   value_it = 'zzz_Drosselschieber',
   value_ro = 'rrr_Drosselschieber',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflussregulator',
   description_de = 'Abflussregulator',
   description_fr = 'regulateur_de_debit',
   description_it = 'zzz_Abflussregulator',
   description_ro = '',
   display_en = 'throttle_valve',
   display_de = 'Drosselschieber',
   display_fr = 'vanne de limitation',
   display_it = '',
   display_ro = ''
WHERE code = 135;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (6490,6490) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'throttle_section',
   value_de = 'Drosselstrecke',
   value_fr = 'conduite_d_etranglement',
   value_it = 'tratta_regolazione',
   value_ro = 'rrr_Drosselstrecke',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zugehöriger Kanal mit FunktionHydraulisch=Drosselleitung attributieren (Erfassungsregel)',
   description_de = 'Zugehöriger Kanal mit FunktionHydraulisch=Drosselleitung attributieren (Erfassungsregel)',
   description_fr = 'Avec une conduite d’étranglement il faut aussi saisie une CANALISATION.FONCTION_HYDRAULIQUE = conduite_d_etranglement',
   description_it = 'zzz_Zugehöriger Kanal mit FunktionHydraulisch=Drosselleitung attributieren (Erfassungsregel)',
   description_ro = '',
   display_en = 'throttle_section',
   display_de = 'Drosselstrecke',
   display_fr = 'conduite d''étranglement',
   display_it = '',
   display_ro = ''
WHERE code = 6490;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (6491,6491) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'leapingweir',
   value_de = 'Leapingwehr',
   value_fr = 'leaping_weir',
   value_it = 'leaping_weir',
   value_ro = 'rrr_Leapingwehr',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zusätzlich ist ein Leapingwehr zu erfassen',
   description_de = 'Zusätzlich ist ein Leapingwehr zu erfassen',
   description_fr = 'Il faut aussi saissit une LEAPING_WEIR',
   description_it = 'zzz_Zusätzlich ist ein Leapingwehr zu erfassen',
   description_ro = '',
   display_en = 'leapingweir',
   display_de = 'Leapingwehr',
   display_fr = 'leapingweir',
   display_it = '',
   display_ro = ''
WHERE code = 6491;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (6492,6492) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'pomp',
   value_de = 'Pumpe',
   value_fr = 'pompe',
   value_it = 'pompa',
   value_ro = 'rrr_Pumpe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zusätzlich ist ein Foerderaggregat zu erfassen',
   description_de = 'Zusätzlich ist ein Foerderaggregat zu erfassen',
   description_fr = 'Il faut aussi saissit une INSTALLATION_REFOULEMENT',
   description_it = 'zzz_Zusätzlich ist ein Foerderaggregat zu erfassen',
   description_ro = '',
   display_en = 'pomp',
   display_de = 'Pumpe',
   display_fr = 'pompe',
   display_it = '',
   display_ro = ''
WHERE code = 6492;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2690,2690) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'backflow_flap',
   value_de = 'Rueckstauklappe',
   value_fr = 'clapet_de_non_retour_a_battant',
   value_it = 'clappa_anti_rigurgito',
   value_ro = 'clapeta _antirefulare',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'backflow_flap',
   display_de = 'Rueckstauklappe',
   display_fr = 'clapet de non retour à battant',
   display_it = '',
   display_ro = 'clapeta  antirefulare'
WHERE code = 2690;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2688,2688) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'gate_valve',
   value_de = 'Schieber',
   value_fr = 'vanne',
   value_it = 'saracinesca',
   value_ro = 'rrr_Schieber',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Siehe auch Absperrorgan, Drosselorgan',
   description_de = 'Siehe auch Absperrorgan, Drosselorgan',
   description_fr = 'Voir sous limiteur de débit.',
   description_it = 'zzz_Siehe auch Absperrorgan, Drosselorgan',
   description_ro = '',
   display_en = 'gate_valve',
   display_de = 'Schieber',
   display_fr = 'vanne',
   display_it = '',
   display_ro = ''
WHERE code = 2688;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (134,134) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'tube_throttle',
   value_de = 'Schlauchdrossel',
   value_fr = 'limiteur_a_membrane',
   value_it = 'zzz_Schlauchdrossel',
   value_ro = 'rrr_Schlauchdrossel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflussregulator',
   description_de = 'Abflussregulator',
   description_fr = 'regulateur_de_debit',
   description_it = 'zzz_Abflussregulator',
   description_ro = '',
   display_en = 'tube_throttle',
   display_de = 'Schlauchdrossel',
   display_fr = 'limiteur à membrane',
   display_it = '',
   display_ro = ''
WHERE code = 134;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (2689,2689) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'sliding_valve',
   value_de = 'Schuetze',
   value_fr = 'vanne_ecluse',
   value_it = 'zzz_Schuetze',
   value_ro = 'vana_cu?it',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sliding_valve',
   display_de = 'Schuetze',
   display_fr = 'vanne écluse',
   display_it = '',
   display_ro = 'vana cu?it'
WHERE code = 2689;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (5755,5755) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'gate_shield',
   value_de = 'Stauschild',
   value_fr = 'plaque_de_retenue',
   value_it = 'paratoia_cilindrica',
   value_ro = 'rrr_Stauschild',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gate_shield',
   display_de = 'Stauschild',
   display_fr = 'plaque de retenue',
   display_it = '',
   display_ro = ''
WHERE code = 5755;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (3046,3046) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3046;

--- Adapt tww_vl.throttle_shut_off_unit_kind
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode) VALUES (133,133) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_kind SET
   value_en = 'whirl_throttle',
   value_de = 'Wirbeldrossel',
   value_fr = 'limiteur_a_vortex',
   value_it = 'zzz_Wirbeldrossel',
   value_ro = 'rrr_Wirbeldrossel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflussregulator',
   description_de = 'Abflussregulator',
   description_fr = 'regulateur_de_debit',
   description_it = 'zzz_Abflussregulator',
   description_ro = '',
   display_en = 'whirl_throttle',
   display_de = 'Wirbeldrossel',
   display_fr = 'limiteur à vortex',
   display_it = '',
   display_ro = ''
WHERE code = 133;

--- Adapt tww_vl.throttle_shut_off_unit_signal_transmission
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode) VALUES (3171,3171) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_signal_transmission SET
   value_en = 'receiving',
   value_de = 'empfangen',
   value_fr = 'recevoir',
   value_it = 'zzz_empfangen',
   value_ro = 'rrr_empfangen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'receiving',
   display_de = 'empfangen',
   display_fr = 'recevoir',
   display_it = '',
   display_ro = ''
WHERE code = 3171;

--- Adapt tww_vl.throttle_shut_off_unit_signal_transmission
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode) VALUES (3172,3172) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_signal_transmission SET
   value_en = 'sending',
   value_de = 'senden',
   value_fr = 'emettre',
   value_it = 'zzz_senden',
   value_ro = 'rrr_senden',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sending',
   display_de = 'senden',
   display_fr = 'émettre',
   display_it = '',
   display_ro = ''
WHERE code = 3172;

--- Adapt tww_vl.throttle_shut_off_unit_signal_transmission
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode) VALUES (3169,3169) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_signal_transmission SET
   value_en = 'sending_receiving',
   value_de = 'senden_empfangen',
   value_fr = 'emettre_recevoir',
   value_it = 'zzz_senden_empfangen',
   value_ro = 'rrr_senden_empfangen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sending_receiving',
   display_de = 'senden_empfangen',
   display_fr = 'émettre et recevoir',
   display_it = '',
   display_ro = ''
WHERE code = 3169;

--- Adapt tww_vl.throttle_shut_off_unit_signal_transmission
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode) VALUES (3170,3170) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.throttle_shut_off_unit_signal_transmission SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3170;

--- Adapt tww_vl.prank_weir_weir_edge
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode) VALUES (2995,2995) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_edge SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2995;

--- Adapt tww_vl.prank_weir_weir_edge
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode) VALUES (351,351) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_edge SET
   value_en = 'rectangular',
   value_de = 'rechteckig',
   value_fr = 'angulaire',
   value_it = 'zzz_rechteckig',
   value_ro = 'rrr_rechteckig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'rectangular',
   display_de = 'rechteckig',
   display_fr = 'rectiligne',
   display_it = '',
   display_ro = ''
WHERE code = 351;

--- Adapt tww_vl.prank_weir_weir_edge
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode) VALUES (350,350) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_edge SET
   value_en = 'round',
   value_de = 'rund',
   value_fr = 'arrondie',
   value_it = 'zzz_rund',
   value_ro = 'rotund',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'round',
   display_de = 'rund',
   display_fr = 'circulaire',
   display_it = '',
   display_ro = 'rotund'
WHERE code = 350;

--- Adapt tww_vl.prank_weir_weir_edge
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode) VALUES (349,349) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_edge SET
   value_en = 'sharp_edged',
   value_de = 'scharfkantig',
   value_fr = 'arete_vive',
   value_it = 'zzz_scharfkantig',
   value_ro = 'margini_ascutite',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'sharp_edged',
   display_de = 'scharfkantig',
   display_fr = 'en paroi mince',
   display_it = '',
   display_ro = 'margini ascutite'
WHERE code = 349;

--- Adapt tww_vl.prank_weir_weir_edge
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode) VALUES (3014,3014) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_edge SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3014;

--- Adapt tww_vl.prank_weir_weir_kind
 INSERT INTO tww_vl.prank_weir_weir_kind (code, vsacode) VALUES (5772,5772) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_kind SET
   value_en = 'raised',
   value_de = 'hochgezogen',
   value_fr = 'a_seuil_sureleve',
   value_it = 'laterale_alto',
   value_ro = 'rrr_hochgezogen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Streichwehr mit hochgezogener Wehrschwelle',
   description_de = 'Streichwehr mit hochgezogener Wehrschwelle',
   description_fr = 'déversoir latéral a seuil surélevé',
   description_it = 'zzz_Streichwehr mit hochgezogener Wehrschwelle',
   description_ro = '',
   display_en = 'raised',
   display_de = 'hochgezogen',
   display_fr = 'à seuil surélevé',
   display_it = '',
   display_ro = ''
WHERE code = 5772;

--- Adapt tww_vl.prank_weir_weir_kind
 INSERT INTO tww_vl.prank_weir_weir_kind (code, vsacode) VALUES (5771,5771) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.prank_weir_weir_kind SET
   value_en = 'low',
   value_de = 'niedrig',
   value_fr = 'a_seuil_abaisse',
   value_it = 'laterale_basso',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Streichwehr mit niedriger Wehrschwelle',
   description_de = 'Streichwehr mit niedriger Wehrschwelle',
   description_fr = 'déversoir latéral à seuil abaissé',
   description_it = 'zzz_Streichwehr mit niedriger Wehrschwelle',
   description_ro = '',
   display_en = 'low',
   display_de = 'niedrig',
   display_fr = 'à seuil abaisse',
   display_it = '',
   display_ro = ''
WHERE code = 5771;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (2983,2983) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2983;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (2662,2662) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'compressed_air_system',
   value_de = 'Druckluftanlage',
   value_fr = 'systeme_a_air_comprime',
   value_it = 'impianto_aria_compressa',
   value_ro = 'rrr_Druckluftanlage',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'compressed_air_system',
   display_de = 'Druckluftanlage',
   display_fr = 'système à air comprimé',
   display_it = '',
   display_ro = ''
WHERE code = 2662;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (314,314) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'piston_pump',
   value_de = 'Kolbenpumpe',
   value_fr = 'pompe_a_piston',
   value_it = 'pompa_pistoni',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'piston_pump',
   display_de = 'Kolbenpumpe',
   display_fr = 'pompe à piston',
   display_it = '',
   display_ro = ''
WHERE code = 314;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (309,309) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'centrifugal_pump',
   value_de = 'Kreiselpumpe',
   value_fr = 'pompe_centrifuge',
   value_it = 'pompa_centrifuga',
   value_ro = 'rrr_Kreiselpumpe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'centrifugal_pump',
   display_de = 'Kreiselpumpe',
   display_fr = 'pompe centrifuge',
   display_it = '',
   display_ro = ''
WHERE code = 309;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (310,310) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'screw_pump',
   value_de = 'Schneckenpumpe',
   value_fr = 'pompe_a_vis',
   value_it = 'pompa_a_vite',
   value_ro = 'rrr_Schneckenpumpe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'aussi appelée vis sans fin ou vis d’Archimède',
   description_it = '',
   description_ro = '',
   display_en = 'screw_pump',
   display_de = 'Schneckenpumpe',
   display_fr = 'vis d''Archimède',
   display_it = '',
   display_ro = ''
WHERE code = 310;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (3082,3082) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3082;

--- Adapt tww_vl.pump_construction_type
 INSERT INTO tww_vl.pump_construction_type (code, vsacode) VALUES (2661,2661) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_construction_type SET
   value_en = 'vacuum_system',
   value_de = 'Vakuumanlage',
   value_fr = 'systeme_a_vide_d_air',
   value_it = 'impinato_a_vuoto_aria',
   value_ro = 'rrr_Vakuumanlage',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'vacuum_system',
   display_de = 'Vakuumanlage',
   display_fr = 'système à vide d''air',
   display_it = '',
   display_ro = ''
WHERE code = 2661;

--- Adapt tww_vl.pump_placement_of_actuation
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode) VALUES (318,318) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_actuation SET
   value_en = 'wet',
   value_de = 'nass',
   value_fr = 'immerge',
   value_it = 'zzz_nass',
   value_ro = 'rrr_nass',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'wet',
   display_de = 'nass',
   display_fr = 'immergé',
   display_it = '',
   display_ro = ''
WHERE code = 318;

--- Adapt tww_vl.pump_placement_of_actuation
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode) VALUES (311,311) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_actuation SET
   value_en = 'dry',
   value_de = 'trocken',
   value_fr = 'non_submersible',
   value_it = 'zzz_trocken',
   value_ro = 'rrr_trocken',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'dry',
   display_de = 'trocken',
   display_fr = 'non submersible',
   display_it = '',
   display_ro = ''
WHERE code = 311;

--- Adapt tww_vl.pump_placement_of_actuation
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode) VALUES (3070,3070) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_actuation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3070;

--- Adapt tww_vl.pump_placement_of_pump
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode) VALUES (362,362) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_pump SET
   value_en = 'horizontal',
   value_de = 'horizontal',
   value_fr = 'horizontal',
   value_it = 'zzz_horizontal',
   value_ro = 'rrr_horizontal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'horizontal',
   display_de = 'horizontal',
   display_fr = 'horizontal',
   display_it = '',
   display_ro = ''
WHERE code = 362;

--- Adapt tww_vl.pump_placement_of_pump
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode) VALUES (3071,3071) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_pump SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3071;

--- Adapt tww_vl.pump_placement_of_pump
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode) VALUES (363,363) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.pump_placement_of_pump SET
   value_en = 'vertical',
   value_de = 'vertikal',
   value_fr = 'vertical',
   value_it = 'zzz_vertikal',
   value_ro = 'rrr_vertikal',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'vertical',
   display_de = 'vertikal',
   display_fr = 'vertical',
   display_it = '',
   display_ro = ''
WHERE code = 363;

--- Adapt tww_vl.leapingweir_opening_shape
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode) VALUES (3581,3581) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.leapingweir_opening_shape SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 3581;

--- Adapt tww_vl.leapingweir_opening_shape
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode) VALUES (3582,3582) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.leapingweir_opening_shape SET
   value_en = 'circle',
   value_de = 'Kreis',
   value_fr = 'circulaire',
   value_it = 'zzz_Kreis',
   value_ro = 'rrr_Kreis',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'circle',
   display_de = 'Kreis',
   display_fr = 'circulaire',
   display_it = '',
   display_ro = ''
WHERE code = 3582;

--- Adapt tww_vl.leapingweir_opening_shape
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode) VALUES (3585,3585) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.leapingweir_opening_shape SET
   value_en = 'parable',
   value_de = 'Parabel',
   value_fr = 'parabolique',
   value_it = 'zzz_Parabel',
   value_ro = 'rrr_Parabel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'parable',
   display_de = 'Parabel',
   display_fr = 'parabolique',
   display_it = '',
   display_ro = ''
WHERE code = 3585;

--- Adapt tww_vl.leapingweir_opening_shape
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode) VALUES (3583,3583) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.leapingweir_opening_shape SET
   value_en = 'rectangular',
   value_de = 'Rechteck',
   value_fr = 'rectangulaire',
   value_it = 'zzz_Rechteck',
   value_ro = 'rrr_Rechteck',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'rectangular',
   display_de = 'Rechteck',
   display_fr = 'rectangulaire',
   display_it = '',
   display_ro = ''
WHERE code = 3583;

--- Adapt tww_vl.leapingweir_opening_shape
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode) VALUES (3584,3584) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.leapingweir_opening_shape SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3584;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9308,9308) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = 'altul'
WHERE code = 9308;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9309,9309) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'cleaning',
   value_de = 'Reinigung',
   value_fr = 'nettoyage',
   value_it = 'pulizia',
   value_ro = 'rrr_Reinigung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cleaning or emptying',
   description_de = 'Reinigung oder Entleerung',
   description_fr = 'Nettoyage ou vidange',
   description_it = 'Pulizia o svuotamento',
   description_ro = 'rrr_Reinigung oder Entleerung',
   display_en = 'cleaning',
   display_de = 'Reinigung',
   display_fr = 'nettoyage',
   display_it = '',
   display_ro = ''
WHERE code = 9309;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9310,9310) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'restoration_replacement',
   value_de = 'Sanierung_Erneuerung',
   value_fr = 'rehabilitation_renouvellement',
   value_it = 'risanamento_sostituzione',
   value_ro = 'rrr_Sanierung_Erneuerung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   description_de = 'Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   description_fr = 'Mise en place sur l’ancien tracé ou sur un nouveau de nouvelles canalisations d''eaux usées qui intègrent la fonction des anciennes (SN EN 752).',
   description_it = 'Costruzione di nuove fognature nel layout di linea esistente o di linee diverse, con i nuovi impianti che incorporano la funzione delle fognature originali (SN EN 752).',
   description_ro = 'rrr_Herstellung neuer Abwasserkanäle in der bisherigen oder anderer Linienführung, wobei die neuen Anlagen die Funktion der ursprünglichen Abwasserkanäle einbeziehen (SN EN 752).',
   display_en = 'restoration_replacement',
   display_de = 'Sanierung_Erneuerung',
   display_fr = 'réhabilitationn rénouvellement',
   display_it = '',
   display_ro = ''
WHERE code = 9310;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9311,9311) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'restoration_renovation',
   value_de = 'Sanierung_Renovierung',
   value_fr = 'rehabilitation_renovation',
   value_it = 'risanamento_rinnovamento',
   value_ro = 'rrr_Sanierung_Renovierung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz  (SN EN 752). In älteren Normen und Richtlinien wird diese Massnahme mit "Sanierung" bezeichnet.',
   description_de = 'Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz  (SN EN 752). In älteren Normen und Richtlinien wird diese Massnahme mit ''Sanierung'' bezeichnet.',
   description_fr = 'Mesures d’amélioration de la capacité fonctionnelle actuelle des canalisations d’eaux usées impliquant tout ou partie de leur substance originelle (SN EN 752). Dans des directives plus anciennes le terme "Assainissement" était utilisé.',
   description_it = 'Misure per migliorare l''attuale funzionalità delle fognature, incorporando in tutto o in parte la loro sostanza originale (SN EN 752)',
   description_ro = 'rrr_Massnahmen zur Verbesserung der aktuellen Funktionsfähigkeit von Abwasserkanälen unter vollständigem oder teilweisem Einbezug ihrerursprünglichen Substanz  (SN EN 752). In älteren Normen und Richtlinien wird diese Massnahme mit "Sanierung" bezeichnet.',
   display_en = 'restoration_renovation',
   display_de = 'Sanierung_Renovierung',
   display_fr = 'réhabilitation rénovation',
   display_it = '',
   display_ro = ''
WHERE code = 9311;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9312,9312) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'restoration_repair',
   value_de = 'Sanierung_Reparatur',
   value_fr = 'rehabilitation_reparation',
   value_it = 'risanamento_riparazione',
   value_ro = 'rrr_Sanierung_Reparatur',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752). In älteren Normen und Richtlinien wird diese Massnahme mit "Instandsetzung" bezeichnet.',
   description_de = 'Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752). In älteren Normen und Richtlinien wird diese Massnahme mit ''Instandsetzung'' bezeichnet.',
   description_fr = 'Mesures d’élimination de dommages d’étendue limitée (SN EN 752).',
   description_it = 'Misure per la riparazione di danni localizzati (SN EN 752).',
   description_ro = 'rrr_Massnahmen zur Behebung örtlich begrenzter Schäden (SN EN 752).',
   display_en = 'restoration_repair',
   display_de = 'Sanierung_Reparatur',
   display_fr = 'réhabilitation réparation',
   display_it = '',
   display_ro = ''
WHERE code = 9312;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9313,9313) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'restoration_unknown',
   value_de = 'Sanierung_unbekannt',
   value_fr = 'rehabilitation_inconnue',
   value_it = 'risanamento_sconosciuto',
   value_ro = 'rrr_Sanierung_unbekannt',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Alle Massnahmen zur Wiederherstellung oder Verbesserung von vorhandenen Entwässerungsanlagen. Die Massnahmen umfassen Reparatur, Renovierung und Erneuerung  (SN EN 752). In älteren Normen und Richtlinien wird dieser Begriff mit "Erhaltung" bezeichnet.',
   description_de = 'Alle Massnahmen zur Wiederherstellung oder Verbesserung von vorhandenen Entwässerungsanlagen. Die Massnahmen umfassen Reparatur, Renovierung und Erneuerung  (SN EN 752). In älteren Normen und Richtlinien wird dieser Begriff mit ''Erhaltung'' bezeichnet.',
   description_fr = 'Toutes les mesures de remise en état ou d’amélioration des installations d’évacuation des eaux existantes. Ces mesures comprennent la réparation, la rénovation et le renouvellement (SN EN 752). Dans des directives plus anciennes le terme "conservation" était utilisé.',
   description_it = 'Tutte le misure per ripristinare o migliorare i sistemi di drenaggio esistenti. Le misure comprendono la riparazione, il restauro e il rinnovo (SN EN 752).',
   description_ro = 'rrr_Alle Massnahmen zur Wiederherstellung oder Verbesserung von vorhandenen Entwässerungsanlagen. Die Massnahmen umfassen Reparatur, Renovierung und Erneuerung  (SN EN 752). In älteren Normen und Richtlinien wird dieser Begriff mit "Erhaltung" bezeichnet.',
   display_en = 'restoration_unknown',
   display_de = 'Sanierung_unbekannt',
   display_fr = 'réhabilitation inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9313;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9314,9314) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 9314;

--- Adapt tww_vl.maintenance_kind
 INSERT INTO tww_vl.maintenance_kind (code, vsacode) VALUES (9315,9315) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.maintenance_kind SET
   value_en = 'examination',
   value_de = 'Untersuchung',
   value_fr = 'examen',
   value_it = 'zzz_Untersuchung',
   value_ro = 'rrr_Untersuchung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andere Untersuchungen als TV-Untersuchungen und Biologisch Oekologische Gesamtbeurteilungen - diese mit den entsprechenden Subklassen erfassen',
   description_de = 'Andere Untersuchungen als TV-Untersuchungen und Biologisch Oekologische Gesamtbeurteilungen - diese mit den entsprechenden Subklassen erfassen',
   description_fr = 'xxx_Andere Untersuchungen als TV-Untersuchungen und Biologisch Oekologische Gesamtbeurteilungen - diese mit den entsprechenden Subklassen erfassen',
   description_it = 'zzz_Andere Untersuchungen als TV-Untersuchungen und Biologisch Oekologische Gesamtbeurteilungen - diese mit den entsprechenden Subklassen erfassen',
   description_ro = 'rrr_Andere Untersuchungen als TV-Untersuchungen und Biologisch Oekologische Gesamtbeurteilungen - diese mit den entsprechenden Subklassen erfassen',
   display_en = 'examination',
   display_de = 'Untersuchung',
   display_fr = 'examen',
   display_it = '',
   display_ro = ''
WHERE code = 9315;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (5896,5896) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'equal',
   value_de = 'gleich',
   value_fr = 'egal',
   value_it = 'uguale',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'equal',
   display_de = 'gleich',
   display_fr = 'egal',
   display_it = '',
   display_ro = ''
WHERE code = 5896;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (6328,6328) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'no_comparison_possible',
   value_de = 'kein_Vergleich_moeglich',
   value_fr = 'aucune_comparaison_possible',
   value_it = 'confronto_non_possibile',
   value_ro = 'rrr_kein_Vergleich_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_comparison_possible',
   display_de = 'kein_Vergleich_moeglich',
   display_fr = 'aucune comparaison possible',
   display_it = '',
   display_ro = ''
WHERE code = 6328;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (8572,8572) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8572;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (6271,6271) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'unclear',
   value_de = 'unklar',
   value_fr = 'pas_clair',
   value_it = 'non_chiaro',
   value_ro = 'rrr_unklar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unclear',
   display_de = 'unklar',
   display_fr = 'pas clair',
   display_it = '',
   display_ro = ''
WHERE code = 6271;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (6269,6269) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'improvement',
   value_de = 'Verbesserung',
   value_fr = 'amelioration',
   value_it = 'miglioramento',
   value_ro = 'rrrr_Verbesserung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'improvement',
   display_de = 'Verbesserung',
   display_fr = 'amélioration',
   display_it = '',
   display_ro = ''
WHERE code = 6269;

--- Adapt tww_vl.bio_ecol_assessment_comparison_last
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode) VALUES (6270,6270) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_comparison_last SET
   value_en = 'worsening',
   value_de = 'Verschlechterung',
   value_fr = 'deterioration',
   value_it = 'peggioramento',
   value_ro = 'rrr_Verschlechterung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'worsening',
   display_de = 'Verschlechterung',
   display_fr = 'détérioration',
   display_it = '',
   display_ro = ''
WHERE code = 6270;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8687,8687) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'big',
   value_de = 'gross',
   value_fr = 'elevee',
   value_it = 'grande',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'big',
   display_de = 'gross',
   display_fr = 'élevée',
   display_it = '',
   display_ro = ''
WHERE code = 8687;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8685,8685) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'none_or_small',
   value_de = 'kein_klein',
   value_fr = 'aucune_petite',
   value_it = 'nessuno_piccolo',
   value_ro = 'rrr_kein_klein',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none_or_small',
   display_de = 'kein_klein',
   display_fr = 'aucune petite',
   display_it = '',
   display_ro = ''
WHERE code = 8685;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8689,8689) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'no_conclusion_possible',
   value_de = 'keine_Aussage_moeglich',
   value_fr = 'aucun_avis_possible',
   value_it = 'giudizio_non_possibile',
   value_ro = 'rrr_keine_Aussage_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_conclusion_possible',
   display_de = 'keine_Aussage_moeglich',
   display_fr = 'aucun avis possible',
   display_it = '',
   display_ro = ''
WHERE code = 8689;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8686,8686) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'moderate',
   value_de = 'mittel',
   value_fr = 'moyen',
   value_it = 'medio',
   value_ro = 'rrr_mittel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'moderate',
   display_de = 'mittel',
   display_fr = 'moyen',
   display_it = '',
   display_ro = ''
WHERE code = 8686;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8690,8690) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 8690;

--- Adapt tww_vl.bio_ecol_assessment_impact_auxiliary_indic
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode) VALUES (8688,8688) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_auxiliary_indic SET
   value_en = 'unclear',
   value_de = 'unklar',
   value_fr = 'pas_clair',
   value_it = 'non_chiaro',
   value_ro = 'rrr_unklar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unclear',
   display_de = 'unklar',
   display_fr = 'pas clair',
   display_it = '',
   display_ro = ''
WHERE code = 8688;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8666,8666) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'big',
   value_de = 'gross',
   value_fr = 'elevee',
   value_it = 'grande',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'big',
   display_de = 'gross',
   display_fr = 'élevée',
   display_it = '',
   display_ro = ''
WHERE code = 8666;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8664,8664) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'none',
   value_de = 'kein',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'niciun',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'kein',
   display_fr = 'aucun',
   display_it = '',
   display_ro = 'niciun'
WHERE code = 8664;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8668,8668) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'no_conclusion_possible',
   value_de = 'keine_Aussage_moeglich',
   value_fr = 'aucun_avis_possible',
   value_it = 'giudizio_non_possibile',
   value_ro = 'rrr_keine_Aussage_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_conclusion_possible',
   display_de = 'keine_Aussage_moeglich',
   display_fr = 'aucun avis possible',
   display_it = '',
   display_ro = ''
WHERE code = 8668;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8665,8665) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'small_medium',
   value_de = 'klein_mittel',
   value_fr = 'faible_moyenne',
   value_it = 'medio_piccolo',
   value_ro = 'rrr_klein_mittel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'small_medium',
   display_de = 'klein_mittel',
   display_fr = 'faible moyenne',
   display_it = '',
   display_ro = ''
WHERE code = 8665;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8669,8669) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 8669;

--- Adapt tww_vl.bio_ecol_assessment_impact_external_aspect
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode) VALUES (8667,8667) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_external_aspect SET
   value_en = 'unclear',
   value_de = 'unklar',
   value_fr = 'pas_clair',
   value_it = 'non_chiaro',
   value_ro = 'rrr_unklar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unclear',
   display_de = 'unklar',
   display_fr = 'pas clair',
   display_it = '',
   display_ro = ''
WHERE code = 8667;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8673,8673) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'big',
   value_de = 'gross',
   value_fr = 'elevee',
   value_it = 'grande',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'big',
   display_de = 'gross',
   display_fr = 'élevée',
   display_it = '',
   display_ro = ''
WHERE code = 8673;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8671,8671) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'none_or_small',
   value_de = 'kein_klein',
   value_fr = 'aucune_petite',
   value_it = 'nessuno_piccolo',
   value_ro = 'rrr_kein_klein',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none_or_small',
   display_de = 'kein_klein',
   display_fr = 'aucune petite',
   display_it = '',
   display_ro = ''
WHERE code = 8671;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8675,8675) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'no_conclusion_possible',
   value_de = 'keine_Aussage_moeglich',
   value_fr = 'aucun_avis_possible',
   value_it = 'giudizio_non_possibile',
   value_ro = 'rrr_keine_Aussage_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_conclusion_possible',
   display_de = 'keine_Aussage_moeglich',
   display_fr = 'aucun avis possible',
   display_it = '',
   display_ro = ''
WHERE code = 8675;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8672,8672) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'moderate',
   value_de = 'mittel',
   value_fr = 'moyen',
   value_it = 'medio',
   value_ro = 'rrr_mittel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'moderate',
   display_de = 'mittel',
   display_fr = 'moyen',
   display_it = '',
   display_ro = ''
WHERE code = 8672;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8676,8676) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 8676;

--- Adapt tww_vl.bio_ecol_assessment_impact_macroinvertebrates
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode) VALUES (8674,8674) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_macroinvertebrates SET
   value_en = 'unclear',
   value_de = 'unklar',
   value_fr = 'pas_clair',
   value_it = 'non_chiaro',
   value_ro = 'rrr_unklar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unclear',
   display_de = 'unklar',
   display_fr = 'pas clair',
   display_it = '',
   display_ro = ''
WHERE code = 8674;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8680,8680) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'big',
   value_de = 'gross',
   value_fr = 'elevee',
   value_it = 'grande',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'big',
   display_de = 'gross',
   display_fr = 'élevée',
   display_it = '',
   display_ro = ''
WHERE code = 8680;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8678,8678) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'none_or_small',
   value_de = 'kein_klein',
   value_fr = 'aucune_petite',
   value_it = 'nessuno_piccolo',
   value_ro = 'rrr_kein_klein',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none_or_small',
   display_de = 'kein_klein',
   display_fr = 'aucune petite',
   display_it = '',
   display_ro = ''
WHERE code = 8678;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8682,8682) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'no_conclusion_possible',
   value_de = 'keine_Aussage_moeglich',
   value_fr = 'aucun_avis_possible',
   value_it = 'giudizio_non_possibile',
   value_ro = 'rrr_keine_Aussage_moeglich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no_conclusion_possible',
   display_de = 'keine_Aussage_moeglich',
   display_fr = 'aucun avis possible',
   display_it = '',
   display_ro = ''
WHERE code = 8682;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8679,8679) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'moderate',
   value_de = 'mittel',
   value_fr = 'moyen',
   value_it = 'medio',
   value_ro = 'rrr_mittel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'moderate',
   display_de = 'mittel',
   display_fr = 'moyen',
   display_it = '',
   display_ro = ''
WHERE code = 8679;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8683,8683) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 8683;

--- Adapt tww_vl.bio_ecol_assessment_impact_water_plants
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode) VALUES (8681,8681) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_impact_water_plants SET
   value_en = 'unclear',
   value_de = 'unklar',
   value_fr = 'pas_clair',
   value_it = 'non_chiaro',
   value_ro = 'rrr_unklar',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unclear',
   display_de = 'unklar',
   display_fr = 'pas clair',
   display_it = '',
   display_ro = ''
WHERE code = 8681;

--- Adapt tww_vl.bio_ecol_assessment_intervention_demand
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode) VALUES (5945,5945) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_intervention_demand SET
   value_en = 'yes_short_term',
   value_de = 'ja_kurzfristig',
   value_fr = 'oui_a_court_terme',
   value_it = 'si_corto_termine',
   value_ro = 'rrr_ja_kurzfristig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Great influence of the discharge point due to investigation, therefore need for action in the short term.',
   description_de = 'Grosser Einfluss der Einleitstelle aufgrund Untersuchung, daher kurzfristiger Handlungsbedarf.',
   description_fr = 'Forte influence du rejet sur la base de l''analyse, donc besoin d''intervention à court terme.',
   description_it = 'Grande influenza del punto di scarico a causa delle indagini, quindi necessità di interventi a breve termine.',
   description_ro = 'Influen?a mare a punctului de deversare din cauza investiga?iei, prin urmare este nevoie de masuri pe termen scurt.',
   display_en = 'yes_short_term',
   display_de = 'ja_kurzfristig',
   display_fr = 'oui à court terme',
   display_it = '',
   display_ro = ''
WHERE code = 5945;

--- Adapt tww_vl.bio_ecol_assessment_intervention_demand
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode) VALUES (6272,6272) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_intervention_demand SET
   value_en = 'yes_long_term',
   value_de = 'ja_laengerfristig',
   value_fr = 'oui_a_long_terme',
   value_it = 'si_lungo_termine',
   value_ro = 'rrr_ja_laengerfristig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Medium impact of discharge point based on investigation, therefore longer term action required.',
   description_de = 'Mittlerer Einfluss der Einleitstelle aufgrund der Untersuchung, daher längerfristiger Handlungsbedarf.',
   description_fr = 'Influence moyenne du rejet sur la base de l''analyse, donc besoin d''intervention à long terme.',
   description_it = 'Impatto medio del punto di scarico in base all''indagine, quindi necessità di intervento a lungo termine.',
   description_ro = 'Impactul mediu al punctului de deversare pe baza investiga?iei, prin urmare este nevoie de masuri pe termen lung.',
   display_en = 'yes_long_term',
   display_de = 'ja_laengerfristig',
   display_fr = 'oui à long terme',
   display_it = '',
   display_ro = ''
WHERE code = 6272;

--- Adapt tww_vl.bio_ecol_assessment_intervention_demand
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode) VALUES (8695,8695) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_intervention_demand SET
   value_en = 'no_conclusion_possible',
   value_de = 'keine_Aussage_moeglich',
   value_fr = 'aucun_avis_possible',
   value_it = 'giudizio_non_possibile',
   value_ro = 'nicio_declaratie_posibila',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Due to the circumstances, the investigation does not allow any statement on the influence of the discharge point on the water body. A further water investigation could not provide any additional findings.',
   description_de = 'Die Untersuchung lässt aufgrund der Gegebenheiten keine Aussage zum Einfluss der Einleitstelle auf das Gewässer zu. Eine weitere Gewäasseruntersuchung könnte keine zusätzlichen Erkenntnisse liefern.',
   description_fr = 'En raison des conditions, l''analyse ne permet pas de se prononcer sur l''influence du rejet. Une autre analyse ne permettrait pas fournir de connaissances supplémentaires.',
   description_it = 'A causa delle circostanze, l''indagine non consente di fare dichiarazioni sull''influenza del punto di scarico sul corpo idrico. Un''ulteriore indagine sulle acque non ha potuto fornire ulteriori risultati.',
   description_ro = 'Din cauza circumstan?elor, ancheta nu permite nicio declara?ie privind influen?a punctului de deversare asupra corpului de apa. O investiga?ie suplimentara a apei nu a putut furniza constatari suplimentare.',
   display_en = 'no_conclusion_possible',
   display_de = 'keine_Aussage_moeglich',
   display_fr = 'aucun avis possible',
   display_it = '',
   display_ro = ''
WHERE code = 8695;

--- Adapt tww_vl.bio_ecol_assessment_intervention_demand
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode) VALUES (5944,5944) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_intervention_demand SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'No influence of the discharge point based on the investigation, therefore no action required.',
   description_de = 'Kein Einfluss der Einleitstelle aufgrund der Untersuchung, daher kein Handlungsbedarf.',
   description_fr = 'Pas d''influence du rejet sur la base de l''analyse, donc pas de besoin d''intervention.',
   description_it = 'L''indagine non ha evidenziato alcuna influenza sul punto di scarico, pertanto non è necessario intervenire.',
   description_ro = 'Nu exista nicio influen?a a punctului de deversare pe baza investiga?iei, prin urmare nu este necesara nicio ac?iune.',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5944;

--- Adapt tww_vl.bio_ecol_assessment_intervention_demand
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode) VALUES (9093,9093) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_intervention_demand SET
   value_en = 'clarify_status',
   value_de = 'Status_klaeren',
   value_fr = 'clarifier_statut',
   value_it = 'chiarire_stato',
   value_ro = 'rrr_Status_klaeren',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'The investigation yielded unclear results. Further findings are expected from a renewed / more extensive water investigation.',
   description_de = 'Die Untersuchung ergab unklare Ergebnisse. Von einer erneuten / weitergehenden Gewässeruntersuchung sind weitere Erkenntnisse zu erwarten.',
   description_fr = 'L''analyse a donné des résultats peu clairs. Des informations supplémentaires sont attendues d''une analyse nouvelle / plus approfondie.',
   description_it = 'I risultati dell''indagine non erano chiari. Si attendono ulteriori risultati da una nuova e più estesa indagine sui corsi d''acqua.',
   description_ro = 'Rezultatele anchetei au fost neclare. Sunt a?teptate alte constatari în urma unei investiga?ii reînnoite / mai ample a cursului de apa.',
   display_en = 'clarify_status',
   display_de = 'Status_klaeren',
   display_fr = 'clarifier statut',
   display_it = '',
   display_ro = ''
WHERE code = 9093;

--- Adapt tww_vl.bio_ecol_assessment_io_calculation
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode) VALUES (5953,5953) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_io_calculation SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5953;

--- Adapt tww_vl.bio_ecol_assessment_io_calculation
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode) VALUES (5952,5952) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_io_calculation SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5952;

--- Adapt tww_vl.bio_ecol_assessment_io_calculation
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode) VALUES (5954,5954) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_io_calculation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5954;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (8492,8492) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'river_backwater',
   value_de = 'Fluss_Stau',
   value_fr = 'retention',
   value_it = 'corso_d_acqua_di_accummulo',
   value_ro = 'rrr_Fluss_Stau',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'rétention',
   description_it = '',
   description_ro = '',
   display_en = 'river_backwater',
   display_de = 'Fluss_Stau',
   display_fr = 'rétention',
   display_it = '',
   display_ro = 'rrr_Fluss_Stau'
WHERE code = 8492;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5884,5884) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'large_river',
   value_de = 'Groesseres_Fliessgewaesser',
   value_fr = 'gros_cours_d_eau',
   value_it = 'grosso_fiume',
   value_ro = 'rrr_Groesseres_Fliessgewaesser',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'large_river',
   display_de = 'Groesseres_Fliessgewaesser',
   display_fr = 'gros cours d''eau',
   display_it = '',
   display_ro = 'rrr_Groesseres_Fliessgewaesser'
WHERE code = 5884;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5883,5883) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'large_midland_creek',
   value_de = 'Grosser_Mittellandbach',
   value_fr = 'gros_ruisseau_du_Plateau',
   value_it = 'grande_corso_d_acqua_dell_altopiano',
   value_ro = 'rrr_Grosser_Mittellandbach',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'large_midland_creek',
   display_de = 'Grosser_Mittellandbach',
   display_fr = 'gros ruisseau du Plateau',
   display_it = '',
   display_ro = 'rrr_Grosser_Mittellandbach'
WHERE code = 5883;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5885,5885) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'large_prealps_creek',
   value_de = 'Grosser_Voralpenbach',
   value_fr = 'gros_ruisseau_des_Prealpes',
   value_it = 'grande_corso_d_acqua_prealpino',
   value_ro = 'rrr_Grosser_Voralpenbach',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'large_prealps_creek',
   display_de = 'Grosser_Voralpenbach',
   display_fr = 'gros ruisseau des Préalpes',
   display_it = '',
   display_ro = 'rrr_Grosser_Voralpenbach'
WHERE code = 5885;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (8491,8491) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'very_large_river',
   value_de = 'Grosses_Fliessgewaesser',
   value_fr = 'tres_gros_cours_d_eau',
   value_it = 'fiume_molto_grande',
   value_ro = 'rrr_Grosses_Fliessgewaesser',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'very_large_river',
   display_de = 'Grosses_Fliessgewaesser',
   display_fr = 'tres gros cours d''eau',
   display_it = '',
   display_ro = 'rrr_Grosses_Fliessgewaesser'
WHERE code = 8491;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5886,5886) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'small_midland_creek',
   value_de = 'Kleiner_Mittellandbach',
   value_fr = 'petit_ruisseau_du_Plateau',
   value_it = 'piccolo_corso_d_acqua_dell_altopiano',
   value_ro = 'rrr_Kleiner_Mittellandbach',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'small_midland_creek',
   display_de = 'Kleiner_Mittellandbach',
   display_fr = 'petit ruisseau du Plateau',
   display_it = '',
   display_ro = 'rrr_Kleiner_Mittellandbach'
WHERE code = 5886;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5887,5887) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'small_prealps_creek',
   value_de = 'Kleiner_Voralpenbach',
   value_fr = 'petit_ruisseau_des_Prealpes',
   value_it = 'piccolo_corso_d_acqua_prealpino',
   value_ro = 'rrr_Kleiner_Voralpenbach',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'small_prealps_creek',
   display_de = 'Kleiner_Voralpenbach',
   display_fr = 'petit ruisseau des Préalpes',
   display_it = '',
   display_ro = 'rrr_Kleiner_Voralpenbach'
WHERE code = 5887;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5888,5888) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'spring_waters',
   value_de = 'Quellgewaesser',
   value_fr = 'region_de_source',
   value_it = 'acque_sorgive',
   value_ro = 'rrr_Quellgewaesser',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'spring_waters',
   display_de = 'Quellgewaesser',
   display_fr = 'région de source',
   display_it = '',
   display_ro = 'rrr_Quellgewaesser'
WHERE code = 5888;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (9149,9149) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'lake',
   value_de = 'See',
   value_fr = 'lac',
   value_it = 'lago',
   value_ro = 'rrr_See',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'With Module G of the VSA Guideline Wastewater Management in Stormwater (2021), the distinction between small and large lakes will be abolished. This is not relevant for the water ecological assessment and is also not clearly defined.',
   description_de = 'Mit dem Modul G der VSA-Richtlinie Abwasserbewirtschaftung bei Regenwetter (2021), wird die Unterscheidung von kleinen und grossen Seen aufgehoben. Diese ist für die gewässerökologische Beurteilung nicht relevant und auch nicht klar definiert.',
   description_fr = 'Le module G de la directive VSA sur la gestion des eaux usées par temps de pluie (2021) supprime la distinction entre petits et grands lacs. Elle n''est pas pertinente pour l''évaluation écologique des masses d''eau et n''est pas clairement définie.',
   description_it = 'Il modulo G della linea guida VSA sulla gestione delle acque reflue in tempo di pioggia (2021) abolisce la distinzione tra laghi piccoli e grandi. Questo non è rilevante per la valutazione ecologica dei corpi idrici e non è chiaramente definito.',
   description_ro = 'rrr_Mit dem Modul G der VSA-Richtlinie Abwasserbewirtschaftung bei Regenwetter (2021), wird die Unterscheidung von kleinen und grossen Seen aufgehoben. Diese ist für die gewässerökologische Beurteilung nicht relevant und auch nicht klar definiert.',
   display_en = 'lake',
   display_de = 'See',
   display_fr = 'lac',
   display_it = '',
   display_ro = ''
WHERE code = 9149;

--- Adapt tww_vl.bio_ecol_assessment_kind_water_body
 INSERT INTO tww_vl.bio_ecol_assessment_kind_water_body (code, vsacode) VALUES (5890,5890) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_kind_water_body SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = 'rrr_unbekannt'
WHERE code = 5890;

--- Adapt tww_vl.bio_ecol_assessment_relevance_matrix
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode) VALUES (5949,5949) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_relevance_matrix SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5949;

--- Adapt tww_vl.bio_ecol_assessment_relevance_matrix
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode) VALUES (5948,5948) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_relevance_matrix SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5948;

--- Adapt tww_vl.bio_ecol_assessment_relevance_matrix
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode) VALUES (5950,5950) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.bio_ecol_assessment_relevance_matrix SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5950;

--- Adapt tww_vl.hydraulic_char_data_is_overflowing
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode) VALUES (5774,5774) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_is_overflowing SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5774;

--- Adapt tww_vl.hydraulic_char_data_is_overflowing
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode) VALUES (5775,5775) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_is_overflowing SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5775;

--- Adapt tww_vl.hydraulic_char_data_is_overflowing
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode) VALUES (5778,5778) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_is_overflowing SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5778;

--- Adapt tww_vl.hydraulic_char_data_main_weir_kind
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode) VALUES (6422,6422) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_main_weir_kind SET
   value_en = 'leapingweir',
   value_de = 'Leapingwehr',
   value_fr = 'LEAPING_WEIR',
   value_it = 'leaping_weir',
   value_ro = 'rrr_Leapingwehr',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'leapingweir',
   display_de = 'Leapingwehr',
   display_fr = 'LEAPING_WEIR',
   display_it = '',
   display_ro = ''
WHERE code = 6422;

--- Adapt tww_vl.hydraulic_char_data_main_weir_kind
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode) VALUES (6420,6420) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_main_weir_kind SET
   value_en = 'prank_weir_raised',
   value_de = 'Streichwehr_hochgezogen',
   value_fr = 'deversoir_lateral_a_seuil_sureleve',
   value_it = 'stramazzo_laterale_alto',
   value_ro = 'rrr_Streichwehr_hochgezogen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Streichwehr mit hochgezogener Wehrschwelle',
   description_de = 'Streichwehr mit hochgezogener Wehrschwelle',
   description_fr = 'Déversoir latéral à seuil surélevé',
   description_it = 'Stramazzo laterale con sfioro alto',
   description_ro = '',
   display_en = 'prank_weir_raised',
   display_de = 'Streichwehr_hochgezogen',
   display_fr = 'déversoir lateral à seuil surélévé',
   display_it = '',
   display_ro = ''
WHERE code = 6420;

--- Adapt tww_vl.hydraulic_char_data_main_weir_kind
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode) VALUES (6421,6421) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_main_weir_kind SET
   value_en = 'prank_weir_low',
   value_de = 'Streichwehr_niedrig',
   value_fr = 'deversoir_lateral_a_seuil_abaisse',
   value_it = 'stamazzo_laterale_basso',
   value_ro = 'rrr_Streichwehr_niedrig',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Streichwehr mit niedriger Wehrschwelle',
   description_de = 'Streichwehr mit niedriger Wehrschwelle',
   description_fr = 'Déversoir latéral à seuil abaissé',
   description_it = 'Stramazzo laterale con sfioro basso',
   description_ro = '',
   display_en = 'prank_weir_low',
   display_de = 'Streichwehr_niedrig',
   display_fr = 'déversoir lateral à seuil abaissé',
   display_it = '',
   display_ro = ''
WHERE code = 6421;

--- Adapt tww_vl.hydraulic_char_data_pump_characteristics
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode) VALUES (6374,6374) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_pump_characteristics SET
   value_en = 'alternating',
   value_de = 'alternierend',
   value_fr = 'alterne',
   value_it = 'alternato',
   value_ro = 'rrr_alternierend',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'alternating',
   display_de = 'alternierend',
   display_fr = 'alterne',
   display_it = '',
   display_ro = ''
WHERE code = 6374;

--- Adapt tww_vl.hydraulic_char_data_pump_characteristics
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode) VALUES (6375,6375) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_pump_characteristics SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 6375;

--- Adapt tww_vl.hydraulic_char_data_pump_characteristics
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode) VALUES (6376,6376) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_pump_characteristics SET
   value_en = 'single',
   value_de = 'einzeln',
   value_fr = 'individuel',
   value_it = 'singolo',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'single',
   display_de = 'einzeln',
   display_fr = 'individuel',
   display_it = '',
   display_ro = ''
WHERE code = 6376;

--- Adapt tww_vl.hydraulic_char_data_pump_characteristics
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode) VALUES (6377,6377) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_pump_characteristics SET
   value_en = 'parallel',
   value_de = 'parallel',
   value_fr = 'parallele',
   value_it = 'parallelo',
   value_ro = 'rrr_parallel',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'parallel',
   display_de = 'parallel',
   display_fr = 'parallele',
   display_it = '',
   display_ro = ''
WHERE code = 6377;

--- Adapt tww_vl.hydraulic_char_data_pump_characteristics
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode) VALUES (6378,6378) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_pump_characteristics SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 6378;

--- Adapt tww_vl.hydraulic_char_data_status
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode) VALUES (6371,6371) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_status SET
   value_en = 'planned',
   value_de = 'geplant',
   value_fr = 'prevu',
   value_it = 'pianificato',
   value_ro = 'rrr_geplant',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Optimaler Zustand nach der Umsetzung der Massnahmen',
   description_de = 'Optimaler Zustand nach der Umsetzung der Massnahmen',
   description_fr = 'Etat optimisé après réalisation des mesures',
   description_it = 'zzz_Optimaler Zustand nach der Umsetzung der Massnahmen',
   description_ro = '',
   display_en = 'planned',
   display_de = 'geplant',
   display_fr = 'prévu',
   display_it = '',
   display_ro = ''
WHERE code = 6371;

--- Adapt tww_vl.hydraulic_char_data_status
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode) VALUES (6372,6372) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_status SET
   value_en = 'current',
   value_de = 'Ist',
   value_fr = 'actuel',
   value_it = 'attuale',
   value_ro = 'rrr_Ist',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'current',
   display_de = 'Ist',
   display_fr = 'actuel',
   display_it = '',
   display_ro = ''
WHERE code = 6372;

--- Adapt tww_vl.hydraulic_char_data_status
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode) VALUES (6373,6373) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.hydraulic_char_data_status SET
   value_en = 'current_optimized',
   value_de = 'Ist_optimiert',
   value_fr = 'actuel_opt',
   value_it = 'attuale_ottimizzato',
   value_ro = 'rrr_Ist_optimiert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Optimierter Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen',
   description_de = 'Optimierter Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen',
   description_fr = 'Etat actuel optimisé avant la réalisation d’éventuelles mesures supplémentaires',
   description_it = 'zzz_Optimierter Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen',
   description_ro = '',
   display_en = 'current_optimized',
   display_de = 'Ist_optimiert',
   display_fr = 'actuel optimisé',
   display_it = '',
   display_ro = ''
WHERE code = 6373;

--- Adapt tww_vl.backflow_prevention_kind
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode) VALUES (5760,5760) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.backflow_prevention_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5760;

--- Adapt tww_vl.backflow_prevention_kind
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode) VALUES (5759,5759) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.backflow_prevention_kind SET
   value_en = 'pump',
   value_de = 'Pumpe',
   value_fr = 'pompe',
   value_it = 'pompa',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pump',
   display_de = 'Pumpe',
   display_fr = 'pompe',
   display_it = '',
   display_ro = ''
WHERE code = 5759;

--- Adapt tww_vl.backflow_prevention_kind
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode) VALUES (5757,5757) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.backflow_prevention_kind SET
   value_en = 'backflow_flap',
   value_de = 'Rueckstauklappe',
   value_fr = 'clapet_de_non_retour_a_battant',
   value_it = 'clappa_anti_rigurgito',
   value_ro = 'clapeta _antirefulare',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'backflow_flap',
   display_de = 'Rueckstauklappe',
   display_fr = 'clapet de non retour à battant',
   display_it = '',
   display_ro = ''
WHERE code = 5757;

--- Adapt tww_vl.backflow_prevention_kind
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode) VALUES (5758,5758) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.backflow_prevention_kind SET
   value_en = 'gate_shield',
   value_de = 'Stauschild',
   value_fr = 'plaque_de_retenue',
   value_it = 'paratoia_cilindrica',
   value_ro = 'rrr_Stauschild',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gate_shield',
   display_de = 'Stauschild',
   display_fr = 'plaque de retenue',
   display_it = '',
   display_ro = ''
WHERE code = 5758;

--- Adapt tww_vl.backflow_prevention_kind
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode) VALUES (8636,8636) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.backflow_prevention_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8636;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5664,5664) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5664;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (8624,8624) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'brush_rakes',
   value_de = 'Buerstenrechen',
   value_fr = 'degrilleur_a_brosses',
   value_it = 'Ranghinatori_a_spazzola',
   value_ro = 'rrr_Buerstenrechen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Brush rakes',
   description_de = 'Bürstenrechen',
   description_fr = 'dégrilleur a brosses',
   description_it = 'Ranghinatori a spazzola',
   description_ro = 'rrr_Bürstenrechen',
   display_en = 'brush_rakes',
   display_de = 'Buerstenrechen',
   display_fr = 'dégrilleur à brosses',
   display_it = '',
   display_ro = ''
WHERE code = 8624;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5665,5665) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'fine_screen',
   value_de = 'Feinrechen',
   value_fr = 'grille_fine',
   value_it = 'griglia_fine',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_auch Siebrechen genannt',
   description_de = 'auch Siebrechen genannt',
   description_fr = '',
   description_it = 'zzz_auch Siebrechen genannt',
   description_ro = '',
   display_en = 'fine_screen',
   display_de = 'Feinrechen',
   display_fr = 'grille fine',
   display_it = '',
   display_ro = ''
WHERE code = 5665;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5666,5666) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'coarse_screen',
   value_de = 'Grobrechen',
   value_fr = 'grille_grossiere',
   value_it = 'griglia_grossa',
   value_ro = 'rrr_Grobrechen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Stababstand > 10mm',
   description_de = 'Stababstand > 10mm',
   description_fr = 'maille > 10mm',
   description_it = 'distanza barre > 10mm',
   description_ro = '',
   display_en = 'coarse_screen',
   display_de = 'Grobrechen',
   display_fr = 'grille grossière',
   display_it = '',
   display_ro = ''
WHERE code = 5666;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5667,5667) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'sieve',
   value_de = 'Sieb',
   value_fr = 'tamis',
   value_it = 'filtro',
   value_ro = 'rrr_Sieb',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Lochblech',
   description_de = 'Lochblech',
   description_fr = 'tôle perforée',
   description_it = 'lamiera perforata',
   description_ro = '',
   display_en = 'sieve',
   display_de = 'Sieb',
   display_fr = 'tamis',
   display_it = '',
   display_ro = ''
WHERE code = 5667;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (8625,8625) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'gate_shield',
   value_de = 'Stauschild',
   value_fr = 'plaque_de_retenue',
   value_it = 'paratoia_cilindrica',
   value_ro = 'rrr_Stauschild',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Gate shield',
   description_de = 'Stauschild',
   description_fr = 'plaque de retenue',
   description_it = 'zzz_Stauschild',
   description_ro = 'rrr_Stauschild',
   display_en = 'gate_shield',
   display_de = 'Stauschild',
   display_fr = 'plaque de retenue',
   display_it = '',
   display_ro = ''
WHERE code = 8625;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5668,5668) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'scumboard',
   value_de = 'Tauchwand',
   value_fr = 'paroi_plongeante',
   value_it = 'parete_sommersa',
   value_ro = 'rrr_Tauchwand',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = 'parete sommersa',
   description_ro = '',
   display_en = 'scumboard',
   display_de = 'Tauchwand',
   display_fr = 'paroi plongeante',
   display_it = '',
   display_ro = ''
WHERE code = 5668;

--- Adapt tww_vl.solids_retention_kind
 INSERT INTO tww_vl.solids_retention_kind (code, vsacode) VALUES (5669,5669) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.solids_retention_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5669;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (5621,5621) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'airjet',
   value_de = 'Air_Jet',
   value_fr = 'aeration_et_brassage',
   value_it = 'airjet',
   value_ro = 'rrr_Air_Jet',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Druckluftstrom, auch Injektorpumpe genannt',
   description_de = 'Druckluftstrom, auch Injektorpumpe genannt',
   description_fr = 'flux d''air comprimé, aussi appelé pompe injectrice',
   description_it = 'Flusso d''aria in pressione',
   description_ro = 'rrr_Druckluftstrom, auch Injektorpumpe genannt',
   display_en = 'airjet',
   display_de = 'Air_Jet',
   display_fr = 'aeration_et_brassage',
   display_it = '',
   display_ro = ''
WHERE code = 5621;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (5620,5620) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 5620;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (8621,8621) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'scraper_installation',
   value_de = 'Raeumereinrichtung',
   value_fr = 'dispositif_de_curage',
   value_it = 'zzz_Raeumereinrichtung',
   value_ro = 'rrr_Raeumereinrichtung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'scrapper installation',
   description_de = 'Räumereinrichtung',
   description_fr = 'dispositif de curage',
   description_it = 'Attrezzature per raschietti',
   description_ro = 'rrr_Räumereinrichtung',
   display_en = 'scraper_installation',
   display_de = 'Raeumereinrichtung',
   display_fr = 'dispositif de curage',
   display_it = '',
   display_ro = ''
WHERE code = 8621;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (8622,8622) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'agitator',
   value_de = 'Ruehrwerk',
   value_fr = 'agitateur',
   value_it = 'agitatore',
   value_ro = 'rrr_Ruehrwerk',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'agitator',
   display_de = 'Ruehrwerk',
   display_fr = 'agitateur',
   display_it = '',
   display_ro = ''
WHERE code = 8622;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (8623,8623) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'meandered_gutter',
   value_de = 'Schlaengelrinne',
   value_fr = 'cunette_courbe',
   value_it = 'cunetta_curva',
   value_ro = 'rrr_Schlaengelrinne',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'meandered_gutter',
   display_de = 'Schlaengelrinne',
   display_fr = 'cunette courbe',
   display_it = '',
   display_ro = ''
WHERE code = 8623;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (5623,5623) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'surge_flushing',
   value_de = 'Schwallspuelung',
   value_fr = 'rincage_en_cascade',
   value_it = 'lavaggio_getto',
   value_ro = 'rrr_Schwallspülung',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'surge_flushing',
   display_de = 'Schwallspuelung',
   display_fr = 'rinçage en cascade',
   display_it = '',
   display_ro = ''
WHERE code = 5623;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (5624,5624) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'tipping_bucket',
   value_de = 'Spuelkippe',
   value_fr = 'bac_de_rincage',
   value_it = 'benna_ribaltabile',
   value_ro = 'rrr_Spuelkippe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'bac de rinçage ou rigole basculante',
   description_it = '',
   description_ro = '',
   display_en = 'tipping_bucket',
   display_de = 'Spuelkippe',
   display_fr = 'bac de rincage',
   display_it = '',
   display_ro = ''
WHERE code = 5624;

--- Adapt tww_vl.tank_cleaning_kind
 INSERT INTO tww_vl.tank_cleaning_kind (code, vsacode) VALUES (8626,8626) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_cleaning_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8626;

--- Adapt tww_vl.tank_emptying_kind
 INSERT INTO tww_vl.tank_emptying_kind (code, vsacode) VALUES (5626,5626) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_emptying_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 5626;

--- Adapt tww_vl.tank_emptying_kind
 INSERT INTO tww_vl.tank_emptying_kind (code, vsacode) VALUES (8638,8638) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_emptying_kind SET
   value_en = 'gravitation',
   value_de = 'Gravitation',
   value_fr = 'gravitation',
   value_it = 'gravitazione',
   value_ro = 'rrr_Gravitation',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'The value "gravitation" is used if the structure is emptied without any supporting device',
   description_de = 'Der Wert „Gravitation“ wird verwendet, wenn das Bauwerk ohne Hilfsbetrieb entleert wird.',
   description_fr = 'La valeur „gravitation“ est à utiliser lorsque le bassin est vidangé sans appareillage.',
   description_it = 'Il valore "gravitazione" è utilizzato quando il manufatto viene vuotato senza componenti ausiliari.',
   description_ro = '',
   display_en = 'gravitation',
   display_de = 'Gravitation',
   display_fr = 'gravitation',
   display_it = '',
   display_ro = ''
WHERE code = 8638;

--- Adapt tww_vl.tank_emptying_kind
 INSERT INTO tww_vl.tank_emptying_kind (code, vsacode) VALUES (5628,5628) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_emptying_kind SET
   value_en = 'pump',
   value_de = 'Pumpe',
   value_fr = 'pompe',
   value_it = 'pompa',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pump',
   display_de = 'Pumpe',
   display_fr = 'pompe',
   display_it = '',
   display_ro = ''
WHERE code = 5628;

--- Adapt tww_vl.tank_emptying_kind
 INSERT INTO tww_vl.tank_emptying_kind (code, vsacode) VALUES (5629,5629) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_emptying_kind SET
   value_en = 'gate_valve',
   value_de = 'Schieber',
   value_fr = 'vanne',
   value_it = 'saracinesca',
   value_ro = 'rrr_Schieber',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'gate_valve',
   display_de = 'Schieber',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code = 5629;

--- Adapt tww_vl.tank_emptying_kind
 INSERT INTO tww_vl.tank_emptying_kind (code, vsacode) VALUES (8637,8637) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.tank_emptying_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8637;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (4949,4949) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4949;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (4946,4946) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'liquid_manure_application',
   value_de = 'Guelleaustrag',
   value_fr = 'epandage',
   value_it = 'zzz_Guelleaustrag',
   value_ro = 'rrr_Guelleaustrag',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = 'Landwirtschaftliche Verwertung',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'liquid_manure_application',
   display_de = 'Guelleaustrag',
   display_fr = 'epandage',
   display_it = '',
   display_ro = ''
WHERE code = 4946;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (6474,6474) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 6474;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (4947,4947) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'public_sewer',
   value_de = 'oeffentlicheKanalisation',
   value_fr = 'canalisation_publique',
   value_it = 'zzz_oeffentlicheKanalisation',
   value_ro = 'rrr_oeffentlicheKanalisation',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grube wird mit Saugwagen geleert und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt.',
   description_de = 'Grube wird mit Saugwagen geleert und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt.',
   description_fr = 'Fosse vidangée par un véhicule d’aspiration et boues évacuées à un autre endroit dans les canalisations publiques',
   description_it = 'zzz_Grube wird mit Saugwagen geleert und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt.',
   description_ro = '',
   display_en = 'public_sewer',
   display_de = 'oeffentlicheKanalisation',
   display_fr = 'canalisation publique',
   display_it = '',
   display_ro = ''
WHERE code = 4947;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (4945,4945) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4945;

--- Adapt tww_vl.disposal_disposal_place_current
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode) VALUES (4948,4948) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_current SET
   value_en = 'central_WWTP',
   value_de = 'zentraleARA',
   value_fr = 'STEP_centrale',
   value_it = 'zzz_zentraleARA',
   value_ro = 'rrr_zentraleARA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_de = 'Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_fr = 'Fosse vidangée par un véhicule d’aspiration et dont le contenu est amené directement à une STEP centralisée',
   description_it = 'zzz_Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_ro = '',
   display_en = 'central_WWTP',
   display_de = 'zentraleARA',
   display_fr = 'STEP centrale',
   display_it = '',
   display_ro = ''
WHERE code = 4948;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (4954,4954) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4954;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (4951,4951) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'liquid_manure_application',
   value_de = 'Guelleaustrag',
   value_fr = 'epandage',
   value_it = 'zzz_Guelleaustrag',
   value_ro = 'rrr_Guelleaustrag',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = 'Landwirtschaftliche Verwertung',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'liquid_manure_application',
   display_de = 'Guelleaustrag',
   display_fr = 'epandage',
   display_it = '',
   display_ro = ''
WHERE code = 4951;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (6400,6400) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'none',
   value_de = 'keiner',
   value_fr = 'aucun',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'none',
   display_de = 'keiner',
   display_fr = 'aucun',
   display_it = '',
   display_ro = ''
WHERE code = 6400;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (4952,4952) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'public_sewer',
   value_de = 'oeffentlicheKanalisation',
   value_fr = 'canalisation_publique',
   value_it = 'zzz_oeffentlicheKanalisation',
   value_ro = 'rrr_oeffentlicheKanalisation',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grube wird mit Saugwagen geleert und und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt',
   description_de = 'Grube wird mit Saugwagen geleert und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt',
   description_fr = 'Fosse vidangée par un véhicule d’aspiration et boues évacuées à un autre endroit dans les canalisations publiques',
   description_it = 'zzz_Grube wird mit Saugwagen geleert und der Schlamm an einem anderen Ort in die öffentliche Kanalisation entsorgt',
   description_ro = '',
   display_en = 'public_sewer',
   display_de = 'oeffentlicheKanalisation',
   display_fr = 'canalisation publique',
   display_it = '',
   display_ro = ''
WHERE code = 4952;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (4950,4950) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4950;

--- Adapt tww_vl.disposal_disposal_place_planned
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode) VALUES (4953,4953) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.disposal_disposal_place_planned SET
   value_en = 'central_WWTP',
   value_de = 'zentraleARA',
   value_fr = 'STEP_centrale',
   value_it = 'zzz_zentraleARA',
   value_ro = 'rrr_zentraleARA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_de = 'Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_fr = 'Fosse vidangée par un véhicule d’aspiration et dont le contenu est amené directement à une STEP centralisée',
   description_it = 'zzz_Grube wird mit Saugwagen geleert und Inhalt direkt auf die zentrale ARA gefahren',
   description_ro = '',
   display_en = 'central_WWTP',
   display_de = 'zentraleARA',
   display_fr = 'STEP centrale',
   display_it = '',
   display_ro = ''
WHERE code = 4953;

--- Adapt tww_vl.building_group_connecting_obligation
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode) VALUES (5484,5484) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connecting_obligation SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 5484;

--- Adapt tww_vl.building_group_connecting_obligation
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode) VALUES (5485,5485) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connecting_obligation SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 5485;

--- Adapt tww_vl.building_group_connecting_obligation
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode) VALUES (5486,5486) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connecting_obligation SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5486;

--- Adapt tww_vl.building_group_connection_wwtp
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode) VALUES (5095,5095) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connection_wwtp SET
   value_en = 'connected',
   value_de = 'angeschlossen',
   value_fr = 'raccorde',
   value_it = 'zzz_angeschlossen',
   value_ro = 'rrr_angeschlossen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Falls angeschlossen, muss Kanalnetz erfasst werden',
   description_de = 'Falls angeschlossen, muss Kanalnetz erfasst werden',
   description_fr = 'Si raccordé, le réseau de canalisation doit être saisi',
   description_it = 'zzz_Falls angeschlossen, muss Kanalnetz erfasst werden',
   description_ro = '',
   display_en = 'connected',
   display_de = 'angeschlossen',
   display_fr = 'raccorde',
   display_it = '',
   display_ro = ''
WHERE code = 5095;

--- Adapt tww_vl.building_group_connection_wwtp
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode) VALUES (5096,5096) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connection_wwtp SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erfassen Sie zusätzlich ein Objekt Entsorgung und das zugehörige Abwasserbauwerk (Spezialbauwerk, KLARA oder Toilette)',
   description_de = 'Erfassen Sie zusätzlich ein Objekt Entsorgung und das zugehörige Abwasserbauwerk (Spezialbauwerk, KLARA oder Toilette)',
   description_fr = 'Veuillez saisir en plus un objet EVACUATION et l''OUVRAGE_RESEAU_AS correspondente (OUVRAGE_SPECIAL, PETITE_STEP ou TOILETTE)',
   description_it = 'zzz_Erfassen Sie zusätzlich ein Objekt Entsorgung und das zugehörige Abwasserbauwerk (Spezialbauwerk, KLARA oder Toilette)',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 5096;

--- Adapt tww_vl.building_group_connection_wwtp
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode) VALUES (5097,5097) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_connection_wwtp SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5097;

--- Adapt tww_vl.building_group_drainage_map
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode) VALUES (4840,4840) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drainage_map SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 4840;

--- Adapt tww_vl.building_group_drainage_map
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode) VALUES (4841,4841) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drainage_map SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 4841;

--- Adapt tww_vl.building_group_drainage_map
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode) VALUES (4839,4839) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drainage_map SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4839;

--- Adapt tww_vl.building_group_drinking_water_network
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode) VALUES (4826,4826) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_network SET
   value_en = 'connected',
   value_de = 'angeschlossen',
   value_fr = 'raccorde',
   value_it = 'zzz_angeschlossen',
   value_ro = 'rrr_angeschlossen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'connected',
   display_de = 'angeschlossen',
   display_fr = 'raccorde',
   display_it = '',
   display_ro = ''
WHERE code = 4826;

--- Adapt tww_vl.building_group_drinking_water_network
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode) VALUES (4827,4827) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_network SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 4827;

--- Adapt tww_vl.building_group_drinking_water_network
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode) VALUES (4825,4825) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_network SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4825;

--- Adapt tww_vl.building_group_drinking_water_others
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode) VALUES (4833,4833) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_others SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4833;

--- Adapt tww_vl.building_group_drinking_water_others
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode) VALUES (4830,4830) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_others SET
   value_en = 'none',
   value_de = 'keine',
   value_fr = 'aucune',
   value_it = 'nessuno',
   value_ro = 'inexistent',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine andere Trinkwasserversorgung als allfälliger Netzanschluss',
   description_de = 'Keine andere Trinkwasserversorgung als allfälliger Netzanschluss',
   description_fr = 'Aucune autre alimentation en eau potable que réseau',
   description_it = 'zzz_Keine andere Trinkwasserversorgung als allfälliger Netzanschluss',
   description_ro = '',
   display_en = 'none',
   display_de = 'keine',
   display_fr = 'aucune',
   display_it = '',
   display_ro = ''
WHERE code = 4830;

--- Adapt tww_vl.building_group_drinking_water_others
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode) VALUES (4831,4831) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_others SET
   value_en = 'source',
   value_de = 'Quelle',
   value_fr = 'source',
   value_it = 'zzz_Quelle',
   value_ro = 'rrr_Quelle',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'source',
   display_de = 'Quelle',
   display_fr = 'source',
   display_it = '',
   display_ro = ''
WHERE code = 4831;

--- Adapt tww_vl.building_group_drinking_water_others
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode) VALUES (4829,4829) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_others SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4829;

--- Adapt tww_vl.building_group_drinking_water_others
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode) VALUES (4832,4832) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_drinking_water_others SET
   value_en = 'cistern',
   value_de = 'Zisterne',
   value_fr = 'citerne',
   value_it = 'zzz_Zisterne',
   value_ro = 'rrr_Zisterne',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'cistern',
   display_de = 'Zisterne',
   display_fr = 'citerne',
   display_it = '',
   display_ro = ''
WHERE code = 4832;

--- Adapt tww_vl.building_group_electric_connection
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode) VALUES (4836,4836) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_electric_connection SET
   value_en = 'connected',
   value_de = 'angeschlossen',
   value_fr = 'raccorde',
   value_it = 'zzz_angeschlossen',
   value_ro = 'rrr_angeschlossen',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'connected',
   display_de = 'angeschlossen',
   display_fr = 'raccorde',
   display_it = '',
   display_ro = ''
WHERE code = 4836;

--- Adapt tww_vl.building_group_electric_connection
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode) VALUES (4837,4837) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_electric_connection SET
   value_en = 'not_connected',
   value_de = 'nicht_angeschlossen',
   value_fr = 'non_raccorde',
   value_it = 'non_collegato',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_connected',
   display_de = 'nicht_angeschlossen',
   display_fr = 'non racordée',
   display_it = '',
   display_ro = ''
WHERE code = 4837;

--- Adapt tww_vl.building_group_electric_connection
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode) VALUES (4835,4835) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_electric_connection SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4835;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4823,4823) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 4823;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4820,4820) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'holiday_building',
   value_de = 'Feriengebaeude',
   value_fr = 'uniquement_vacances',
   value_it = 'zzz_Feriengebaeude',
   value_ro = 'rrr_Feriengebaeude',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reine Feriennutzung',
   description_de = 'Reine Feriennutzung',
   description_fr = 'Affectation des bâtiments uniquement pour vacances',
   description_it = 'zzz_Reine Feriennutzung',
   description_ro = '',
   display_en = 'holiday_building',
   display_de = 'Feriengebaeude',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code = 4820;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4821,4821) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'industry_craft',
   value_de = 'IndustrieGewerbe',
   value_fr = 'entreprise',
   value_it = 'zzz_IndustrieGewerbe',
   value_ro = 'rrr_IndustrieGewerbe',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Industrie- oder Gewerbebetrieb',
   description_de = 'Industrie- oder Gewerbebetrieb',
   description_fr = 'Entreprise industrielle ou artisanale',
   description_it = 'zzz_Industrie- oder Gewerbebetrieb',
   description_ro = '',
   display_en = 'industry_craft',
   display_de = 'IndustrieGewerbe',
   display_fr = 'entreprise',
   display_it = '',
   display_ro = ''
WHERE code = 4821;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4822,4822) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'farm',
   value_de = 'Landwirtschaftsbetrieb',
   value_fr = 'exploitation_agricole',
   value_it = 'zzz_Landwirtschaftsbetrieb',
   value_ro = 'rrr_Landwirtschaftsbetrieb',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'farm',
   display_de = 'Landwirtschaftsbetrieb',
   display_fr = 'exploitation agricole',
   display_it = '',
   display_ro = ''
WHERE code = 4822;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4818,4818) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4818;

--- Adapt tww_vl.building_group_function
 INSERT INTO tww_vl.building_group_function (code, vsacode) VALUES (4819,4819) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_function SET
   value_en = 'residential_building',
   value_de = 'Wohngebaeude',
   value_fr = 'uniquement_habitation',
   value_it = 'zzz_Wohngebaeude',
   value_ro = 'rrr_Wohngebaeude',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reine Wohnnutzung',
   description_de = 'Reine Wohnnutzung',
   description_fr = 'Affectation des bâtiments uniquement au logement',
   description_it = 'zzz_Reine Wohnnutzung',
   description_ro = '',
   display_en = 'residential_building',
   display_de = 'Wohngebaeude',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code = 4819;

--- Adapt tww_vl.building_group_renovation_necessity
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode) VALUES (8797,8797) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_renovation_necessity SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 8797;

--- Adapt tww_vl.building_group_renovation_necessity
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode) VALUES (8798,8798) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_renovation_necessity SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 8798;

--- Adapt tww_vl.building_group_renovation_necessity
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode) VALUES (8799,8799) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.building_group_renovation_necessity SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 8799;

--- Adapt tww_vl.farm_cesspit_volume
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode) VALUES (5490,5490) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_cesspit_volume SET
   value_en = 'own_and_third_part_operation',
   value_de = 'Eigen_und_Fremdbetrieb',
   value_fr = 'exploitation_propre_et_externe',
   value_it = 'zzz_Eigen_und_Fremdbetrieb',
   value_ro = 'rrr_Eigen_und_Fremdbetrieb',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'own_and_third_part_operation',
   display_de = 'Eigen_und_Fremdbetrieb',
   display_fr = 'exploitation propre et externe',
   display_it = '',
   display_ro = ''
WHERE code = 5490;

--- Adapt tww_vl.farm_cesspit_volume
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode) VALUES (5488,5488) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_cesspit_volume SET
   value_en = 'own_operation',
   value_de = 'Eigenbetrieb',
   value_fr = 'exploitation_propre',
   value_it = 'zzz_Eigenbetrieb',
   value_ro = 'rrr_Eigenbetrieb',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'own_operation',
   display_de = 'Eigenbetrieb',
   display_fr = 'exploitation propre',
   display_it = '',
   display_ro = ''
WHERE code = 5488;

--- Adapt tww_vl.farm_cesspit_volume
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode) VALUES (5489,5489) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_cesspit_volume SET
   value_en = 'third_party_operation',
   value_de = 'Fremdbetrieb',
   value_fr = 'exploitation_externe',
   value_it = 'zzz_Fremdbetrieb',
   value_ro = 'rrr_Fremdbetrieb',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'third_party_operation',
   display_de = 'Fremdbetrieb',
   display_fr = 'exploitation externe',
   display_it = '',
   display_ro = ''
WHERE code = 5489;

--- Adapt tww_vl.farm_cesspit_volume
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode) VALUES (5491,5491) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_cesspit_volume SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5491;

--- Adapt tww_vl.farm_conformity
 INSERT INTO tww_vl.farm_conformity (code, vsacode) VALUES (4896,4896) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_conformity SET
   value_en = 'conform',
   value_de = 'konform',
   value_fr = 'conforme',
   value_it = 'zzz_konform',
   value_ro = 'rrr_konform',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'conform',
   display_de = 'konform',
   display_fr = 'conformée',
   display_it = '',
   display_ro = ''
WHERE code = 4896;

--- Adapt tww_vl.farm_conformity
 INSERT INTO tww_vl.farm_conformity (code, vsacode) VALUES (4898,4898) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_conformity SET
   value_en = 'restoration_postponed',
   value_de = 'Sanierung_aufgeschoben',
   value_fr = 'differee',
   value_it = 'zzz_Sanierung_aufgeschoben',
   value_ro = 'rrr_Sanierung_aufgeschoben',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sanierung aufgrund Gesuch aufgeschoben',
   description_de = 'Sanierung aufgrund Gesuch aufgeschoben',
   description_fr = 'Assainissement suspendu suite à une demande',
   description_it = 'zzz_Sanierung aufgrund Gesuch aufgeschoben',
   description_ro = '',
   display_en = 'restoration_postponed',
   display_de = 'Sanierung_aufgeschoben',
   display_fr = 'différée',
   display_it = '',
   display_ro = ''
WHERE code = 4898;

--- Adapt tww_vl.farm_conformity
 INSERT INTO tww_vl.farm_conformity (code, vsacode) VALUES (4897,4897) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_conformity SET
   value_en = 'restoration_pending',
   value_de = 'Sanierung_bevorstehend',
   value_fr = 'imminente',
   value_it = 'zzz_Sanierung_bevorstehend',
   value_ro = 'rrr_Sanierung_bevorstehend',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bevorstehende Sanierung',
   description_de = 'Bevorstehende Sanierung',
   description_fr = 'Assainissement imminent',
   description_it = 'zzz_Bevorstehende Sanierung',
   description_ro = '',
   display_en = 'restoration_pending',
   display_de = 'Sanierung_bevorstehend',
   display_fr = 'imminente',
   display_it = '',
   display_ro = ''
WHERE code = 4897;

--- Adapt tww_vl.farm_conformity
 INSERT INTO tww_vl.farm_conformity (code, vsacode) VALUES (4895,4895) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_conformity SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4895;

--- Adapt tww_vl.farm_continuance
 INSERT INTO tww_vl.farm_continuance (code, vsacode) VALUES (4890,4890) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_continuance SET
   value_en = 'not_defined',
   value_de = 'nicht_definiert',
   value_fr = 'non_definie',
   value_it = 'zzz_nicht_definiert',
   value_ro = 'rrr_nicht_definiert',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'not_defined',
   display_de = 'nicht_definiert',
   display_fr = 'non définie',
   display_it = '',
   display_ro = ''
WHERE code = 4890;

--- Adapt tww_vl.farm_continuance
 INSERT INTO tww_vl.farm_continuance (code, vsacode) VALUES (4892,4892) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_continuance SET
   value_en = 'improble',
   value_de = 'unwahrscheinlich',
   value_fr = 'improbable',
   value_it = 'zzz_unwahrscheinlich',
   value_ro = 'rrr_unwahrscheinlich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'improble',
   display_de = 'unwahrscheinlich',
   display_fr = 'improbable',
   display_it = '',
   display_ro = ''
WHERE code = 4892;

--- Adapt tww_vl.farm_continuance
 INSERT INTO tww_vl.farm_continuance (code, vsacode) VALUES (4891,4891) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_continuance SET
   value_en = 'probable',
   value_de = 'wahrscheinlich',
   value_fr = 'probable',
   value_it = 'zzz_wahrscheinlich',
   value_ro = 'rrr_wahrscheinlich',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'probable',
   display_de = 'wahrscheinlich',
   display_fr = 'probable',
   display_it = '',
   display_ro = ''
WHERE code = 4891;

--- Adapt tww_vl.farm_shepherds_hut_wastewater
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode) VALUES (4869,4869) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_shepherds_hut_wastewater SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 4869;

--- Adapt tww_vl.farm_shepherds_hut_wastewater
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode) VALUES (4870,4870) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_shepherds_hut_wastewater SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 4870;

--- Adapt tww_vl.farm_shepherds_hut_wastewater
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode) VALUES (4871,4871) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_shepherds_hut_wastewater SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4871;

--- Adapt tww_vl.farm_stable_cattle
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode) VALUES (4875,4875) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_stable_cattle SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_In der Regel wird der Stall für die Viehhaltung verwendet.',
   description_de = 'In der Regel wird der Stall für die Viehhaltung verwendet.',
   description_fr = 'Normalement l''ecurie est utilisé pour des bétails',
   description_it = 'zzz_In der Regel wird der Stall für die Viehhaltung verwendet.',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 4875;

--- Adapt tww_vl.farm_stable_cattle
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode) VALUES (4876,4876) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_stable_cattle SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 4876;

--- Adapt tww_vl.farm_stable_cattle
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode) VALUES (4877,4877) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.farm_stable_cattle SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 4877;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5013,5013) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 5013;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5014,5014) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'activated_sludge_process',
   value_de = 'Belebtschlammverfahren',
   value_fr = 'boues_activees',
   value_it = 'zzz_Belebtschlammverfahren',
   value_ro = 'rrr_Belebtschlammverfahren',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Belebtschlammverfahren',
   description_de = 'Belebtschlammverfahren',
   description_fr = 'Boues activées',
   description_it = 'zzz_Belebtschlammverfahren',
   description_ro = '',
   display_en = 'activated_sludge_process',
   display_de = 'Belebtschlammverfahren',
   display_fr = 'boues activées',
   display_it = '',
   display_ro = ''
WHERE code = 5014;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5022,5022) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'bed_process',
   value_de = 'Bettverfahren',
   value_fr = 'lit_bacterien',
   value_it = 'zzz_Bettverfahren',
   value_ro = 'rrr_Bettverfahren',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wirbelbettverfahren / Festbettverfahren',
   description_de = 'Wirbelbettverfahren / Festbettverfahren',
   description_fr = 'Lit bactérien',
   description_it = 'zzz_Wirbelbettverfahren / Festbettverfahren',
   description_ro = '',
   display_en = 'bed_process',
   display_de = 'Bettverfahren',
   display_fr = 'lit bactérien',
   display_it = '',
   display_ro = ''
WHERE code = 5022;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5023,5023) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'membran_bioreactor',
   value_de = 'Membranbioreaktor',
   value_fr = 'reacteur_a_biomasse_fixee',
   value_it = 'zzz_Membranbioreaktor',
   value_ro = 'rrr_Membranbioreaktor',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Membranbelebungsanlage / Membranbioreaktor (MBR)',
   description_de = 'Membranbelebungsanlage / Membranbioreaktor (MBR)',
   description_fr = 'Réacteur à biomasse fixée',
   description_it = 'zzz_Membranbelebungsanlage / Membranbioreaktor (MBR)',
   description_ro = '',
   display_en = 'membran_bioreactor',
   display_de = 'Membranbioreaktor',
   display_fr = 'réacteur à biomasse fixée',
   display_it = '',
   display_ro = ''
WHERE code = 5023;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5020,5020) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'constructed_wetland',
   value_de = 'Pflanzenklaeranlage',
   value_fr = 'filtration_par_plantes',
   value_it = 'zzz_Pflanzenklaeranlage',
   value_ro = '',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewachsener Bodenfilter / Pflanzenkläranlage',
   description_de = 'Bewachsener Bodenfilter / Pflanzenkläranlage',
   description_fr = 'Filtration par les plantes',
   description_it = 'zzz_Bewachsener Bodenfilter / Pflanzenkläranlage',
   description_ro = '',
   display_en = 'constructed_wetland',
   display_de = 'Pflanzenklaeranlage',
   display_fr = 'filtration par plantes',
   display_it = '',
   display_ro = ''
WHERE code = 5020;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5019,5019) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'sandfilter',
   value_de = 'Sandfilter',
   value_fr = 'filtre_a_sable',
   value_it = 'zzz_Sandfilter',
   value_ro = 'rrr_Sandfilter',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Unbewachsener Bodenfilter / Sandfilter',
   description_de = 'Unbewachsener Bodenfilter / Sandfilter',
   description_fr = 'Filtre à sable',
   description_it = 'zzz_Unbewachsener Bodenfilter / Sandfilter',
   description_ro = '',
   display_en = 'sandfilter',
   display_de = 'Sandfilter',
   display_fr = 'filtre à sable',
   display_it = '',
   display_ro = ''
WHERE code = 5019;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5015,5015) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'sequencing_batch_reactor',
   value_de = 'SequencingBatchReactor',
   value_fr = 'charge_sequentielle_SBR',
   value_it = 'zzz_SequencingBatchReactor',
   value_ro = 'rrr_SequencingBatchReactor',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Sequencing Batch Reactor (SBR)',
   description_de = 'Einbeckenanlage / Sequencing Batch Reactor (SBR)',
   description_fr = 'Charge séquentielle (SBR)',
   description_it = 'zzz_Einbeckenanlage / Sequencing Batch Reactor (SBR)',
   description_ro = '',
   display_en = 'sequencing_batch_reactor',
   display_de = 'SequencingBatchReactor',
   display_fr = 'charge sequentielle SBR',
   display_it = '',
   display_ro = ''
WHERE code = 5015;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5016,5016) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'immersion_trickle_filter',
   value_de = 'Tauchkoerper',
   value_fr = 'disques_biologiques',
   value_it = 'zzz_Tauchkoerper',
   value_ro = 'rrr_Tauchkoerper',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tauchtropfkörper / Rotationstauchkörper',
   description_de = 'Tauchtropfkörper / Rotationstauchkörper',
   description_fr = 'Disques biologiques',
   description_it = 'zzz_Tauchtropfkörper / Rotationstauchkörper',
   description_ro = '',
   display_en = 'immersion_trickle_filter',
   display_de = 'Tauchkoerper',
   display_fr = 'disques biologiques',
   display_it = '',
   display_ro = ''
WHERE code = 5016;

--- Adapt tww_vl.small_treatment_plant_function
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode) VALUES (5021,5021) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 5021;

--- Adapt tww_vl.small_treatment_plant_remote_monitoring
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode) VALUES (6414,6414) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_remote_monitoring SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code = 6414;

--- Adapt tww_vl.small_treatment_plant_remote_monitoring
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode) VALUES (6415,6415) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_remote_monitoring SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code = 6415;

--- Adapt tww_vl.small_treatment_plant_remote_monitoring
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode) VALUES (6416,6416) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.small_treatment_plant_remote_monitoring SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 6416;

--- Adapt tww_vl.drainless_toilet_kind
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode) VALUES (6411,6411) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainless_toilet_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 6411;

--- Adapt tww_vl.drainless_toilet_kind
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode) VALUES (6408,6408) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainless_toilet_kind SET
   value_en = 'chemical_toilet',
   value_de = 'chemischeToilette',
   value_fr = 'toilette_chimique',
   value_it = 'toilette_chimica',
   value_ro = 'rrr_chemischeToilette',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'chemical_toilet',
   display_de = 'chemischeToilette',
   display_fr = 'toilette chimique',
   display_it = '',
   display_ro = ''
WHERE code = 6408;

--- Adapt tww_vl.drainless_toilet_kind
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode) VALUES (6410,6410) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainless_toilet_kind SET
   value_en = 'compost_toilet',
   value_de = 'Komposttoilette',
   value_fr = 'toilette_a_compost',
   value_it = 'toilette_compostante',
   value_ro = 'rrr_Komposttoilette',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'compost toilet',
   description_de = '',
   description_fr = 'Toilette à compost',
   description_it = 'Toilette compostante',
   description_ro = '',
   display_en = 'compost_toilet',
   display_de = 'Komposttoilette',
   display_fr = 'toilet à compost',
   display_it = '',
   display_ro = ''
WHERE code = 6410;

--- Adapt tww_vl.drainless_toilet_kind
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode) VALUES (6412,6412) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainless_toilet_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconu',
   display_it = '',
   display_ro = ''
WHERE code = 6412;

--- Adapt tww_vl.drainless_toilet_kind
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode) VALUES (6409,6409) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.drainless_toilet_kind SET
   value_en = 'incinerating_toilet',
   value_de = 'Verbrennungstoilette',
   value_fr = 'toilette_d_incineration',
   value_it = 'toilette_inceneriscono',
   value_ro = 'rrr_Verbrennungstoilette',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'incinerating toilet',
   description_de = '',
   description_fr = 'Toilette d''incinération',
   description_it = 'toilette di incenerimento',
   description_ro = '',
   display_en = 'incinerating_toilet',
   display_de = 'Verbrennungstoilette',
   display_fr = 'toilette d''incineration',
   display_it = '',
   display_ro = ''
WHERE code = 6409;

--- Adapt tww_vl.wastewater_structure_text_plantype
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode) VALUES (7844,7844) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_plantype SET
   value_en = 'pipeline_registry',
   value_de = 'Leitungskataster',
   value_fr = 'cadastre_des_conduites_souterraines',
   value_it = 'catasto_delle_canalizzazioni',
   value_ro = 'rrr_Leitungskataster',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pipeline_registry',
   display_de = 'Leitungskataster',
   display_fr = 'cadastre des conduites souterraines',
   display_it = '',
   display_ro = ''
WHERE code = 7844;

--- Adapt tww_vl.wastewater_structure_text_plantype
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode) VALUES (7846,7846) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_plantype SET
   value_en = 'overviewmap.om10',
   value_de = 'Uebersichtsplan.UeP10',
   value_fr = 'plan_d_ensemble.pe10',
   value_it = 'piano_di_insieme.pi10',
   value_ro = 'rrr_Uebersichtsplan.UeP10',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:10''000',
   description_de = '1:10''000',
   description_fr = '1:10''000',
   description_it = '1:10''000',
   description_ro = '1:10''000',
   display_en = 'overviewmap.om10',
   display_de = 'Uebersichtsplan.UeP10',
   display_fr = 'plan d''ensemble.pe10',
   display_it = '',
   display_ro = ''
WHERE code = 7846;

--- Adapt tww_vl.wastewater_structure_text_plantype
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode) VALUES (7847,7847) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_plantype SET
   value_en = 'overviewmap.om2',
   value_de = 'Uebersichtsplan.UeP2',
   value_fr = 'plan_d_ensemble.pe2',
   value_it = 'piano_di_insieme.pi2',
   value_ro = 'rrr_Uebersichtsplan.UeP2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:2''000',
   description_de = '1:2''000',
   description_fr = '1:2''000',
   description_it = '1:2''000',
   description_ro = '1:2''000',
   display_en = 'overviewmap.om2',
   display_de = 'Uebersichtsplan.UeP2',
   display_fr = 'plan d''ensemble.pe2',
   display_it = '',
   display_ro = ''
WHERE code = 7847;

--- Adapt tww_vl.wastewater_structure_text_plantype
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode) VALUES (7848,7848) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_plantype SET
   value_en = 'overviewmap.om5',
   value_de = 'Uebersichtsplan.UeP5',
   value_fr = 'plan_d_ensemble.pe5',
   value_it = 'piano_di_insieme.pi5',
   value_ro = 'rrr_Uebersichtsplan.UeP5',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:5''000',
   description_de = '1:5''000',
   description_fr = '1:5''000',
   description_it = '1:5''000',
   description_ro = '1:5''000',
   display_en = 'overviewmap.om5',
   display_de = 'Uebersichtsplan.UeP5',
   display_fr = 'plan d''ensemble.pe5',
   display_it = '',
   display_ro = ''
WHERE code = 7848;

--- Adapt tww_vl.wastewater_structure_text_plantype
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode) VALUES (7845,7845) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_plantype SET
   value_en = 'network_plan',
   value_de = 'Werkplan',
   value_fr = 'plan_de_reseau',
   value_it = 'zzz_Werkplan',
   value_ro = 'rrr_Werkplan',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'network_plan',
   display_de = 'Werkplan',
   display_fr = 'plan de réseau',
   display_it = '',
   display_ro = ''
WHERE code = 7845;

--- Adapt tww_vl.wastewater_structure_text_texthali
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode) VALUES (7850,7850) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_texthali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Left',
   description_de = 'Left',
   description_fr = 'Left',
   description_it = 'Left',
   description_ro = 'Left',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7850;

--- Adapt tww_vl.wastewater_structure_text_texthali
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode) VALUES (7851,7851) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_texthali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Center',
   description_de = 'Center',
   description_fr = 'Center',
   description_it = 'Center',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7851;

--- Adapt tww_vl.wastewater_structure_text_texthali
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode) VALUES (7852,7852) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_texthali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Right',
   description_de = 'Right',
   description_fr = 'Right',
   description_it = 'Right',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7852;

--- Adapt tww_vl.wastewater_structure_text_textvali
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode) VALUES (7853,7853) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_textvali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Top',
   description_de = 'Top',
   description_fr = 'Top',
   description_it = 'Top',
   description_ro = '',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7853;

--- Adapt tww_vl.wastewater_structure_text_textvali
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode) VALUES (7854,7854) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_textvali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cap',
   description_de = 'Cap',
   description_fr = 'Cap',
   description_it = 'Cap',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7854;

--- Adapt tww_vl.wastewater_structure_text_textvali
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode) VALUES (7855,7855) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_textvali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Half',
   description_de = 'Half',
   description_fr = 'Half',
   description_it = 'Half',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7855;

--- Adapt tww_vl.wastewater_structure_text_textvali
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode) VALUES (7856,7856) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_textvali SET
   value_en = '3',
   value_de = '3',
   value_fr = '3',
   value_it = '3',
   value_ro = '3',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Base',
   description_de = 'Base',
   description_fr = 'Base',
   description_it = 'Base',
   description_ro = '',
   display_en = '3',
   display_de = '3',
   display_fr = '3',
   display_it = '3',
   display_ro = '3'
WHERE code = 7856;

--- Adapt tww_vl.wastewater_structure_text_textvali
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode) VALUES (7857,7857) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_text_textvali SET
   value_en = '4',
   value_de = '4',
   value_fr = '4',
   value_it = '4',
   value_ro = '4',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Bottom',
   description_de = 'Bottom',
   description_fr = 'Bottom',
   description_it = 'Bottom',
   description_ro = '',
   display_en = '4',
   display_de = '4',
   display_fr = '4',
   display_it = '4',
   display_ro = '4'
WHERE code = 7857;

--- Adapt tww_vl.reach_text_plantype
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode) VALUES (7844,7844) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_plantype SET
   value_en = 'pipeline_registry',
   value_de = 'Leitungskataster',
   value_fr = 'cadastre_des_conduites_souterraines',
   value_it = 'catasto_delle_canalizzazioni',
   value_ro = 'rrr_Leitungskataster',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pipeline_registry',
   display_de = 'Leitungskataster',
   display_fr = 'cadastre des conduites souterraines',
   display_it = '',
   display_ro = ''
WHERE code = 7844;

--- Adapt tww_vl.reach_text_plantype
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode) VALUES (7846,7846) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_plantype SET
   value_en = 'overviewmap.om10',
   value_de = 'Uebersichtsplan.UeP10',
   value_fr = 'plan_d_ensemble.pe10',
   value_it = 'piano_di_insieme.pi10',
   value_ro = 'rrr_Uebersichtsplan.UeP10',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:10''000',
   description_de = '1:10''000',
   description_fr = '1:10''000',
   description_it = '1:10''000',
   description_ro = '1:10''000',
   display_en = 'overviewmap.om10',
   display_de = 'Uebersichtsplan.UeP10',
   display_fr = 'plan d''ensemble.pe10',
   display_it = '',
   display_ro = ''
WHERE code = 7846;

--- Adapt tww_vl.reach_text_plantype
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode) VALUES (7847,7847) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_plantype SET
   value_en = 'overviewmap.om2',
   value_de = 'Uebersichtsplan.UeP2',
   value_fr = 'plan_d_ensemble.pe2',
   value_it = 'piano_di_insieme.pi2',
   value_ro = 'rrr_Uebersichtsplan.UeP2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:2''000',
   description_de = '1:2''000',
   description_fr = '1:2''000',
   description_it = '1:2''000',
   description_ro = '1:2''000',
   display_en = 'overviewmap.om2',
   display_de = 'Uebersichtsplan.UeP2',
   display_fr = 'plan d''ensemble.pe2',
   display_it = '',
   display_ro = ''
WHERE code = 7847;

--- Adapt tww_vl.reach_text_plantype
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode) VALUES (7848,7848) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_plantype SET
   value_en = 'overviewmap.om5',
   value_de = 'Uebersichtsplan.UeP5',
   value_fr = 'plan_d_ensemble.pe5',
   value_it = 'piano_di_insieme.pi5',
   value_ro = 'rrr_Uebersichtsplan.UeP5',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:5''000',
   description_de = '1:5''000',
   description_fr = '1:5''000',
   description_it = '1:5''000',
   description_ro = '1:5''000',
   display_en = 'overviewmap.om5',
   display_de = 'Uebersichtsplan.UeP5',
   display_fr = 'plan d''ensemble.pe5',
   display_it = '',
   display_ro = ''
WHERE code = 7848;

--- Adapt tww_vl.reach_text_plantype
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode) VALUES (7845,7845) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_plantype SET
   value_en = 'network_plan',
   value_de = 'Werkplan',
   value_fr = 'plan_de_reseau',
   value_it = 'zzz_Werkplan',
   value_ro = 'rrr_Werkplan',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'network_plan',
   display_de = 'Werkplan',
   display_fr = 'plan de réseau',
   display_it = '',
   display_ro = ''
WHERE code = 7845;

--- Adapt tww_vl.reach_text_texthali
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode) VALUES (7850,7850) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_texthali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Left',
   description_de = 'Left',
   description_fr = 'Left',
   description_it = 'Left',
   description_ro = 'Left',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7850;

--- Adapt tww_vl.reach_text_texthali
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode) VALUES (7851,7851) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_texthali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Center',
   description_de = 'Center',
   description_fr = 'Center',
   description_it = 'Center',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7851;

--- Adapt tww_vl.reach_text_texthali
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode) VALUES (7852,7852) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_texthali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Right',
   description_de = 'Right',
   description_fr = 'Right',
   description_it = 'Right',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7852;

--- Adapt tww_vl.reach_text_textvali
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode) VALUES (7853,7853) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_textvali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Top',
   description_de = 'Top',
   description_fr = 'Top',
   description_it = 'Top',
   description_ro = '',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7853;

--- Adapt tww_vl.reach_text_textvali
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode) VALUES (7854,7854) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_textvali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cap',
   description_de = 'Cap',
   description_fr = 'Cap',
   description_it = 'Cap',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7854;

--- Adapt tww_vl.reach_text_textvali
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode) VALUES (7855,7855) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_textvali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Half',
   description_de = 'Half',
   description_fr = 'Half',
   description_it = 'Half',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7855;

--- Adapt tww_vl.reach_text_textvali
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode) VALUES (7856,7856) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_textvali SET
   value_en = '3',
   value_de = '3',
   value_fr = '3',
   value_it = '3',
   value_ro = '3',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Base',
   description_de = 'Base',
   description_fr = 'Base',
   description_it = 'Base',
   description_ro = '',
   display_en = '3',
   display_de = '3',
   display_fr = '3',
   display_it = '3',
   display_ro = '3'
WHERE code = 7856;

--- Adapt tww_vl.reach_text_textvali
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode) VALUES (7857,7857) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_text_textvali SET
   value_en = '4',
   value_de = '4',
   value_fr = '4',
   value_it = '4',
   value_ro = '4',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Bottom',
   description_de = 'Bottom',
   description_fr = 'Bottom',
   description_it = 'Bottom',
   description_ro = '',
   display_en = '4',
   display_de = '4',
   display_fr = '4',
   display_it = '4',
   display_ro = '4'
WHERE code = 7857;

--- Adapt tww_vl.catchment_area_text_plantype
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode) VALUES (7844,7844) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_plantype SET
   value_en = 'pipeline_registry',
   value_de = 'Leitungskataster',
   value_fr = 'cadastre_des_conduites_souterraines',
   value_it = 'catasto_delle_canalizzazioni',
   value_ro = 'rrr_Leitungskataster',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pipeline_registry',
   display_de = 'Leitungskataster',
   display_fr = 'cadastre des conduites souterraines',
   display_it = '',
   display_ro = ''
WHERE code = 7844;

--- Adapt tww_vl.catchment_area_text_plantype
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode) VALUES (7846,7846) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_plantype SET
   value_en = 'overviewmap.om10',
   value_de = 'Uebersichtsplan.UeP10',
   value_fr = 'plan_d_ensemble.pe10',
   value_it = 'piano_di_insieme.pi10',
   value_ro = 'rrr_Uebersichtsplan.UeP10',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:10''000',
   description_de = '1:10''000',
   description_fr = '1:10''000',
   description_it = '1:10''000',
   description_ro = '1:10''000',
   display_en = 'overviewmap.om10',
   display_de = 'Uebersichtsplan.UeP10',
   display_fr = 'plan d''ensemble.pe10',
   display_it = '',
   display_ro = ''
WHERE code = 7846;

--- Adapt tww_vl.catchment_area_text_plantype
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode) VALUES (7847,7847) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_plantype SET
   value_en = 'overviewmap.om2',
   value_de = 'Uebersichtsplan.UeP2',
   value_fr = 'plan_d_ensemble.pe2',
   value_it = 'piano_di_insieme.pi2',
   value_ro = 'rrr_Uebersichtsplan.UeP2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:2''000',
   description_de = '1:2''000',
   description_fr = '1:2''000',
   description_it = '1:2''000',
   description_ro = '1:2''000',
   display_en = 'overviewmap.om2',
   display_de = 'Uebersichtsplan.UeP2',
   display_fr = 'plan d''ensemble.pe2',
   display_it = '',
   display_ro = ''
WHERE code = 7847;

--- Adapt tww_vl.catchment_area_text_plantype
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode) VALUES (7848,7848) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_plantype SET
   value_en = 'overviewmap.om5',
   value_de = 'Uebersichtsplan.UeP5',
   value_fr = 'plan_d_ensemble.pe5',
   value_it = 'piano_di_insieme.pi5',
   value_ro = 'rrr_Uebersichtsplan.UeP5',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:5''000',
   description_de = '1:5''000',
   description_fr = '1:5''000',
   description_it = '1:5''000',
   description_ro = '1:5''000',
   display_en = 'overviewmap.om5',
   display_de = 'Uebersichtsplan.UeP5',
   display_fr = 'plan d''ensemble.pe5',
   display_it = '',
   display_ro = ''
WHERE code = 7848;

--- Adapt tww_vl.catchment_area_text_plantype
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode) VALUES (7845,7845) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_plantype SET
   value_en = 'network_plan',
   value_de = 'Werkplan',
   value_fr = 'plan_de_reseau',
   value_it = 'zzz_Werkplan',
   value_ro = 'rrr_Werkplan',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'network_plan',
   display_de = 'Werkplan',
   display_fr = 'plan de réseau',
   display_it = '',
   display_ro = ''
WHERE code = 7845;

--- Adapt tww_vl.catchment_area_text_texthali
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode) VALUES (7850,7850) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_texthali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Left',
   description_de = 'Left',
   description_fr = 'Left',
   description_it = 'Left',
   description_ro = 'Left',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7850;

--- Adapt tww_vl.catchment_area_text_texthali
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode) VALUES (7851,7851) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_texthali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Center',
   description_de = 'Center',
   description_fr = 'Center',
   description_it = 'Center',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7851;

--- Adapt tww_vl.catchment_area_text_texthali
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode) VALUES (7852,7852) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_texthali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Right',
   description_de = 'Right',
   description_fr = 'Right',
   description_it = 'Right',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7852;

--- Adapt tww_vl.catchment_area_text_textvali
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode) VALUES (7853,7853) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_textvali SET
   value_en = '0',
   value_de = '0',
   value_fr = '0',
   value_it = '0',
   value_ro = '0',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Top',
   description_de = 'Top',
   description_fr = 'Top',
   description_it = 'Top',
   description_ro = '',
   display_en = '0',
   display_de = '0',
   display_fr = '0',
   display_it = '0',
   display_ro = '0'
WHERE code = 7853;

--- Adapt tww_vl.catchment_area_text_textvali
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode) VALUES (7854,7854) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_textvali SET
   value_en = '1',
   value_de = '1',
   value_fr = '1',
   value_it = '1',
   value_ro = '1',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Cap',
   description_de = 'Cap',
   description_fr = 'Cap',
   description_it = 'Cap',
   description_ro = '',
   display_en = '1',
   display_de = '1',
   display_fr = '1',
   display_it = '1',
   display_ro = '1'
WHERE code = 7854;

--- Adapt tww_vl.catchment_area_text_textvali
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode) VALUES (7855,7855) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_textvali SET
   value_en = '2',
   value_de = '2',
   value_fr = '2',
   value_it = '2',
   value_ro = '2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Half',
   description_de = 'Half',
   description_fr = 'Half',
   description_it = 'Half',
   description_ro = '',
   display_en = '2',
   display_de = '2',
   display_fr = '2',
   display_it = '2',
   display_ro = '2'
WHERE code = 7855;

--- Adapt tww_vl.catchment_area_text_textvali
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode) VALUES (7856,7856) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_textvali SET
   value_en = '3',
   value_de = '3',
   value_fr = '3',
   value_it = '3',
   value_ro = '3',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Base',
   description_de = 'Base',
   description_fr = 'Base',
   description_it = 'Base',
   description_ro = '',
   display_en = '3',
   display_de = '3',
   display_fr = '3',
   display_it = '3',
   display_ro = '3'
WHERE code = 7856;

--- Adapt tww_vl.catchment_area_text_textvali
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode) VALUES (7857,7857) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.catchment_area_text_textvali SET
   value_en = '4',
   value_de = '4',
   value_fr = '4',
   value_it = '4',
   value_ro = '4',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Bottom',
   description_de = 'Bottom',
   description_fr = 'Bottom',
   description_it = 'Bottom',
   description_ro = '',
   display_en = '4',
   display_de = '4',
   display_fr = '4',
   display_it = '4',
   display_ro = '4'
WHERE code = 7857;

--- Adapt tww_vl.wastewater_structure_symbol_plantype
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode) VALUES (7874,7874) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_symbol_plantype SET
   value_en = 'pipeline_registry',
   value_de = 'Leitungskataster',
   value_fr = 'cadastre_des_conduites_souterraines',
   value_it = 'catasto_delle_canalizzazioni',
   value_ro = 'rrr_Leitungskataster',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pipeline_registry',
   display_de = 'Leitungskataster',
   display_fr = 'cadastre des conduites souterraines',
   display_it = '',
   display_ro = ''
WHERE code = 7874;

--- Adapt tww_vl.wastewater_structure_symbol_plantype
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode) VALUES (7876,7876) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_symbol_plantype SET
   value_en = 'overviewmap.om10',
   value_de = 'Uebersichtsplan.UeP10',
   value_fr = 'plan_d_ensemble.pe10',
   value_it = 'piano_di_insieme.pi10',
   value_ro = 'rrr_Uebersichtsplan.UeP10',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:10''000',
   description_de = '1:10''000',
   description_fr = '1:10''000',
   description_it = '1:10''000',
   description_ro = '1:10''000',
   display_en = 'overviewmap.om10',
   display_de = 'Uebersichtsplan.UeP10',
   display_fr = 'plan d''ensemble.pe10',
   display_it = '',
   display_ro = ''
WHERE code = 7876;

--- Adapt tww_vl.wastewater_structure_symbol_plantype
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode) VALUES (7877,7877) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_symbol_plantype SET
   value_en = 'overviewmap.om2',
   value_de = 'Uebersichtsplan.UeP2',
   value_fr = 'plan_d_ensemble.pe2',
   value_it = 'piano_di_insieme.pi2',
   value_ro = 'rrr_Uebersichtsplan.UeP2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:2''000',
   description_de = '1:2''000',
   description_fr = '1:2''000',
   description_it = '1:2''000',
   description_ro = '1:2''000',
   display_en = 'overviewmap.om2',
   display_de = 'Uebersichtsplan.UeP2',
   display_fr = 'plan d''ensemble.pe2',
   display_it = '',
   display_ro = ''
WHERE code = 7877;

--- Adapt tww_vl.wastewater_structure_symbol_plantype
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode) VALUES (7878,7878) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_symbol_plantype SET
   value_en = 'overviewmap.om5',
   value_de = 'Uebersichtsplan.UeP5',
   value_fr = 'plan_d_ensemble.pe5',
   value_it = 'piano_di_insieme.pi5',
   value_ro = 'rrr_Uebersichtsplan.UeP5',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:5''000',
   description_de = '1:5''000',
   description_fr = '1:5''000',
   description_it = '1:5''000',
   description_ro = '1:5''000',
   display_en = 'overviewmap.om5',
   display_de = 'Uebersichtsplan.UeP5',
   display_fr = 'plan d''ensemble.pe5',
   display_it = '',
   display_ro = ''
WHERE code = 7878;

--- Adapt tww_vl.wastewater_structure_symbol_plantype
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode) VALUES (7875,7875) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.wastewater_structure_symbol_plantype SET
   value_en = 'network_plan',
   value_de = 'Werkplan',
   value_fr = 'plan_de_reseau',
   value_it = 'zzz_Werkplan',
   value_ro = 'rrr_Werkplan',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'network_plan',
   display_de = 'Werkplan',
   display_fr = 'plan de réseau',
   display_it = '',
   display_ro = ''
WHERE code = 7875;

--- Adapt tww_vl.reach_progression_alternative_plantype
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode) VALUES (9282,9282) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_progression_alternative_plantype SET
   value_en = 'pipeline_registry',
   value_de = 'Leitungskataster',
   value_fr = 'cadastre_des_conduites_souterraines',
   value_it = 'catasto_delle_canalizzazioni',
   value_ro = 'rrr_Leitungskataster',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'pipeline_registry',
   display_de = 'Leitungskataster',
   display_fr = 'cadastre des conduites souterraines',
   display_it = '',
   display_ro = ''
WHERE code = 9282;

--- Adapt tww_vl.reach_progression_alternative_plantype
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode) VALUES (9285,9285) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_progression_alternative_plantype SET
   value_en = 'overviewmap.om10',
   value_de = 'Uebersichtsplan.UeP10',
   value_fr = 'plan_d_ensemble.pe10',
   value_it = 'piano_di_insieme.pi10',
   value_ro = 'rrr_Uebersichtsplan.UeP10',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:10''000',
   description_de = '1:10''000',
   description_fr = '1:10''000',
   description_it = '1:10''000',
   description_ro = '1:10''000',
   display_en = 'overviewmap.om10',
   display_de = 'Uebersichtsplan.UeP10',
   display_fr = 'plan d''ensemble.pe10',
   display_it = '',
   display_ro = ''
WHERE code = 9285;

--- Adapt tww_vl.reach_progression_alternative_plantype
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode) VALUES (9286,9286) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_progression_alternative_plantype SET
   value_en = 'overviewmap.om2',
   value_de = 'Uebersichtsplan.UeP2',
   value_fr = 'plan_d_ensemble.pe2',
   value_it = 'piano_di_insieme.pi2',
   value_ro = 'rrr_Uebersichtsplan.UeP2',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:2''000',
   description_de = '1:2''000',
   description_fr = '1:2''000',
   description_it = '1:2''000',
   description_ro = '1:2''000',
   display_en = 'overviewmap.om2',
   display_de = 'Uebersichtsplan.UeP2',
   display_fr = 'plan d''ensemble.pe2',
   display_it = '',
   display_ro = ''
WHERE code = 9286;

--- Adapt tww_vl.reach_progression_alternative_plantype
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode) VALUES (9287,9287) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_progression_alternative_plantype SET
   value_en = 'overviewmap.om5',
   value_de = 'Uebersichtsplan.UeP5',
   value_fr = 'plan_d_ensemble.pe5',
   value_it = 'piano_di_insieme.pi5',
   value_ro = 'rrr_Uebersichtsplan.UeP5',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '1:5''000',
   description_de = '1:5''000',
   description_fr = '1:5''000',
   description_it = '1:5''000',
   description_ro = '1:5''000',
   display_en = 'overviewmap.om5',
   display_de = 'Uebersichtsplan.UeP5',
   display_fr = 'plan d''ensemble.pe5',
   display_it = '',
   display_ro = ''
WHERE code = 9287;

--- Adapt tww_vl.reach_progression_alternative_plantype
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode) VALUES (9284,9284) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.reach_progression_alternative_plantype SET
   value_en = 'network_plan',
   value_de = 'Werkplan',
   value_fr = 'plan_de_reseau',
   value_it = 'zzz_Werkplan',
   value_ro = 'rrr_Werkplan',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'network_plan',
   display_de = 'Werkplan',
   display_fr = 'plan de réseau',
   display_it = '',
   display_ro = ''
WHERE code = 9284;
