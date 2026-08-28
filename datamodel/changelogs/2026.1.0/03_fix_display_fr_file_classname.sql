UPDATE tww_vl.file_classname
SET display_fr = CASE display_fr
    WHEN 'ACCIDENT' THEN 'accident'
    WHEN 'AMENAGEMENT_COURS_EAU' THEN 'aménagement de cours d’eau'
    WHEN 'APPAREIL_MESURE' THEN 'appareil de mesure'
    WHEN 'AQUIFERE' THEN 'aquifère'
    WHEN 'ASSOCIATION_EPURATION_EAU' THEN 'association d’épuration des eaux'
    WHEN 'BANQUETTE' THEN 'banquette'
    WHEN 'BARRAGE_ALLUVIONS' THEN 'barrage d’alluvions'
    WHEN 'BASSIN_VERSANT' THEN 'bassin versant'
    WHEN 'BASSIN_VERSANT_COMPLET' THEN 'bassin versant complet'
    WHEN 'BATIMENT' THEN 'bâtiment'
    WHEN 'BATIMENTS' THEN 'bâtiments'
    WHEN 'BATIMENTS_BAUREGBL' THEN 'bâtiments BAUREGBL'
    WHEN 'CANALISATION' THEN 'canalisation'
    WHEN 'CANTON' THEN 'canton'
    WHEN 'CAPTAGE' THEN 'captage'
    WHEN 'CARACTERISTIQUES_DEVERSOIR' THEN 'caractéristiques du déversoir'
    WHEN 'CENTRALE_COMMANDE' THEN 'centrale de commande'
    WHEN 'CHAMBRE_STANDARD' THEN 'chambre standard'
    WHEN 'COMMUNE' THEN 'commune'
    WHEN 'CONSOMMATION_ENERGIE_STEP' THEN 'consommation d’énergie de la STEP'
    WHEN 'COOPERATIVE' THEN 'coopérative'
    WHEN 'COUVERCLE' THEN 'couvercle'
    WHEN 'CUNETTE_DEBIT_TEMPS_SEC' THEN 'cunette à débit par temps sec'
    WHEN 'DEVERSOIR' THEN 'déversoir'
    WHEN 'DEVERSOIR_LATERAL' THEN 'déversoir latéral'
    WHEN 'dispositif access' THEN 'dispositif d’accès'
    WHEN 'dispositif nettoyage' THEN 'dispositif de nettoyage'
    WHEN 'dommage' THEN 'dommage'
    WHEN 'dommage aux canalisation' THEN 'dommage aux canalisations'
    WHEN 'dommage chambre standard' THEN 'dommage à la chambre standard'
    WHEN 'eaux superficielles' THEN 'eaux superficielles'
    WHEN 'échelle poissons' THEN 'échelle à poissons'
    WHEN 'éclues' THEN 'écluses'
    WHEN 'élement ouvrage' THEN 'élément d’ouvrage'
    WHEN 'ELEMENT_RESEAU_EVACUATION' THEN 'élément du réseau d’évacuation'
    WHEN 'EQUIPEMENT_ELECTRIQUE' THEN 'équipement électrique'
    WHEN 'EQUIPEMENT_ELECTROMECA' THEN 'équipement électromécanique'
    WHEN 'EVACUATION' THEN 'évacuation'
    WHEN 'EVACUATION_AVEC_REJET' THEN 'évacuation avec rejet'
    WHEN 'EVACUATION_SANS_REJET' THEN 'évacuation sans rejet'
    WHEN 'EVALUATION_GENERALE_ECO_BIOL' THEN 'évaluation générale écologique et biologique'
    WHEN 'EVENEMENT_MAINTENANCE' THEN 'événement de maintenance'
    WHEN 'EXAMEN' THEN 'examen'
    WHEN 'EXPLOITATION_AGRICOLE' THEN 'exploitation agricole'
    WHEN 'EXUTOIRE' THEN 'exutoire'
    WHEN 'FICHE_TECHNIQUE' THEN 'fiche technique'
    WHEN 'FICHIER' THEN 'fichier'
    WHEN 'fond cours d''eau' THEN 'fond de cours d’eau'
    WHEN 'FONTAINE' THEN 'fontaine'
    WHEN 'Géométrie hydraulique' THEN 'géométrie hydraulique'
    WHEN 'Installation d''infiltration' THEN 'installation d’infiltration'
    WHEN 'INSTALLATION_REFOULEMENT' THEN 'installation de refoulement'
    WHEN 'lac' THEN 'lac'
    WHEN 'LEAPING_WEIR' THEN 'déversoir à ressaut'
    WHEN 'LIEU_BAIGNADE' THEN 'lieu de baignade'
    WHEN 'LIMITEUR_DEBIT' THEN 'limiteur de débit'
    WHEN 'MESURE' THEN 'mesure'
    WHEN 'NETTOYAGE_DE_BASSINS' THEN 'nettoyage de bassins'
    WHEN 'NOEUD_RESEAU' THEN 'nœud du réseau'
    WHEN 'OBJET_RACCORDE' THEN 'objet raccordé'
    WHEN 'OFFICE' THEN 'office'
    WHEN 'ORGANISATION' THEN 'organisation'
    WHEN 'OUVRAGE_RESEAU_AS' THEN 'ouvrage du réseau d’assainissement'
    WHEN 'OUVRAGE_RETENUE' THEN 'ouvrage de retenue'
    WHEN 'OUVRAGE_SPECIAL' THEN 'ouvrage spécial'
    WHEN 'OUVRAGES_STEP' THEN 'ouvrages de STEP'
    WHEN 'PARAM_ECOULEMENT_SUP' THEN 'paramètres d’écoulement superficiel'
    WHEN 'PARAMETRES_HYDR' THEN 'paramètres hydrauliques'
    WHEN 'PASSAGE_A_GUE' THEN 'passage à gué'
    WHEN 'PASSAGE_SOUS_TUYAU' THEN 'passage sous tuyau'
    WHEN 'PERIMETRE_PROT_EAUX_SOUT' THEN 'périmètre de protection des eaux souterraines'
    WHEN 'PETITE_STEP' THEN 'petite STEP'
    WHEN 'POINT_TRONCON' THEN 'point de tronçon'
    WHEN 'PRETRAITEMENT_MECANIQUE' THEN 'prétraitement mécanique'
    WHEN 'PRIVE' THEN 'privé'
    WHEN 'PROFIL_TUYAU' THEN 'profil de tuyau'
    WHEN 'PROFIL_TUYAU_GEOM' THEN 'géométrie du profil de tuyau'
    WHEN 'PROTECTION_REFOULEMENT' THEN 'protection contre le refoulement'
    WHEN 'RAMPE' THEN 'rampe'
    WHEN 'RELATION_GEOM_HYDR' THEN 'relation géométrie hydraulique'
    WHEN 'RELATION_HQ' THEN 'relation hauteur-débit'
    WHEN 'RESERVOIR' THEN 'réservoir'
    WHEN 'RESULTAT_MESURE' THEN 'résultat de mesure'
    WHEN 'RETENUE_DE_MATIERES_SOLIDES' THEN 'retenue de matières solides'
    WHEN 'RIVE' THEN 'rive'
    WHEN 'SECTEUR_EAUX_SUP' THEN 'secteur des eaux superficielles'
    WHEN 'SECTEUR_PROTECTION_EAUX' THEN 'secteur de protection des eaux'
    WHEN 'SERIE_MESURES' THEN 'série de mesures'
    WHEN 'SEUIL' THEN 'seuil'
    WHEN 'SOURCE_DANGER' THEN 'source de danger'
    WHEN 'STATION_EPURATION' THEN 'station d’épuration'
    WHEN 'STATION_MESURE' THEN 'station de mesure'
    WHEN 'SUBSTANCE' THEN 'substance'
    WHEN 'SUPPORT_DONNEES' THEN 'support de données'
    WHEN 'SURFACE_INDIVIDUELLE' THEN 'surface individuelle'
    WHEN 'TETE_DE_RINCAGE' THEN 'tête de rinçage'
    WHEN 'TOILETTE_SANS_VIDANGE' THEN 'toilette sans vidange'
    WHEN 'TRAITEMENT_EAUX_USEES' THEN 'traitement des eaux usées'
    WHEN 'TRONCON' THEN 'tronçon'
    WHEN 'TRONCON_COURS_EAU' THEN 'tronçon de cours d’eau'
    WHEN 'VIDANGE_DE_BASSINS' THEN 'vidange de bassins'
    WHEN 'ZONE' THEN 'zone'
    WHEN 'ZONE_RESERVEE' THEN 'zone réservée'
    ELSE display_fr
END
WHERE display_fr IN (
    'ACCIDENT',
    'AMENAGEMENT_COURS_EAU',
    'APPAREIL_MESURE',
    'AQUIFERE',
    'ASSOCIATION_EPURATION_EAU',
    'BANQUETTE',
    'BARRAGE_ALLUVIONS',
    'BASSIN_VERSANT',
    'BASSIN_VERSANT_COMPLET',
    'BATIMENT',
    'BATIMENTS',
    'BATIMENTS_BAUREGBL',
    'CANALISATION',
    'CANTON',
    'CAPTAGE',
    'CARACTERISTIQUES_DEVERSOIR',
    'CENTRALE_COMMANDE',
    'CHAMBRE_STANDARD',
    'COMMUNE',
    'CONSOMMATION_ENERGIE_STEP',
    'COOPERATIVE',
    'COUVERCLE',
    'CUNETTE_DEBIT_TEMPS_SEC',
    'DEVERSOIR',
    'DEVERSOIR_LATERAL',
    'dispositif access',
    'dispositif nettoyage',
    'dommage',
    'dommage aux canalisation',
    'dommage chambre standard',
    'eaux superficielles',
    'échelle poissons',
    'éclues',
    'élement ouvrage',
    'ELEMENT_RESEAU_EVACUATION',
    'EQUIPEMENT_ELECTRIQUE',
    'EQUIPEMENT_ELECTROMECA',
    'EVACUATION',
    'EVACUATION_AVEC_REJET',
    'EVACUATION_SANS_REJET',
    'EVALUATION_GENERALE_ECO_BIOL',
    'EVENEMENT_MAINTENANCE',
    'EXAMEN',
    'EXPLOITATION_AGRICOLE',
    'EXUTOIRE',
    'FICHE_TECHNIQUE',
    'FICHIER',
    'fond cours d''eau',
    'FONTAINE',
    'Géométrie hydraulique',
    'Installation d''infiltration',
    'INSTALLATION_REFOULEMENT',
    'lac',
    'LEAPING_WEIR',
    'LIEU_BAIGNADE',
    'LIMITEUR_DEBIT',
    'MESURE',
    'NETTOYAGE_DE_BASSINS',
    'NOEUD_RESEAU',
    'OBJET_RACCORDE',
    'OFFICE',
    'ORGANISATION',
    'OUVRAGE_RESEAU_AS',
    'OUVRAGE_RETENUE',
    'OUVRAGE_SPECIAL',
    'OUVRAGES_STEP',
    'PARAM_ECOULEMENT_SUP',
    'PARAMETRES_HYDR',
    'PASSAGE_A_GUE',
    'PASSAGE_SOUS_TUYAU',
    'PERIMETRE_PROT_EAUX_SOUT',
    'PETITE_STEP',
    'POINT_TRONCON',
    'PRETRAITEMENT_MECANIQUE',
    'PRIVE',
    'PROFIL_TUYAU',
    'PROFIL_TUYAU_GEOM',
    'PROTECTION_REFOULEMENT',
    'RAMPE',
    'RELATION_GEOM_HYDR',
    'RELATION_HQ',
    'RESERVOIR',
    'RESULTAT_MESURE',
    'RETENUE_DE_MATIERES_SOLIDES',
    'RIVE',
    'SECTEUR_EAUX_SUP',
    'SECTEUR_PROTECTION_EAUX',
    'SERIE_MESURES',
    'SEUIL',
    'SOURCE_DANGER',
    'STATION_EPURATION',
    'STATION_MESURE',
    'SUBSTANCE',
    'SUPPORT_DONNEES',
    'SURFACE_INDIVIDUELLE',
    'TETE_DE_RINCAGE',
    'TOILETTE_SANS_VIDANGE',
    'TRAITEMENT_EAUX_USEES',
    'TRONCON',
    'TRONCON_COURS_EAU',
    'VIDANGE_DE_BASSINS',
    'ZONE',
    'ZONE_RESERVEE'
);

UPDATE tww_vl.file_classname
SET display_fr = CASE code
    WHEN 3824 THEN 'système d’évacuation des eaux'
    WHEN 3827 THEN 'cours d’eau'
    WHEN 3843 THEN 'zone de protection des eaux souterraines'
    WHEN 3868 THEN 'volume de rétention'
    WHEN 3872 THEN 'traitement des boues'
    WHEN 3880 THEN 'tuyau de chute par temps sec'
    WHEN 3888 THEN 'zone d’infiltration'
END
WHERE code IN (3824, 3827, 3843, 3868, 3872, 3880, 3888);
