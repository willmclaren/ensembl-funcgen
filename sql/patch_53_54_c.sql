# patch_53_54_c.sql
#
# title: Add multispecies support
#
# description:
# Modifies coord_system and seq_region to ensure that the primary keys and structure allows for multispecies 

ALTER TABLE meta ADD KEY `meta_species_index` (`species_id`);

# Auto-inc fields are indexed before primary key removal to avoid an ERROR 1075 (42000).

ALTER TABLE coord_system ADD column `species_id` int(10) DEFAULT 1;
ALTER TABLE coord_system ADD index `coord_species_idx` (`species_id`);
ALTER TABLE coord_system ADD index `coord_system_id_idx` (`coord_system_id`);
ALTER TABLE coord_system DROP primary key;
ALTER TABLE coord_system ADD primary key (`name`,`version`,`schema_build`,`species_id`);

ALTER TABLE seq_region ADD index `seq_region_id_idx` (`seq_region_id`);
ALTER TABLE seq_region DROP PRIMARY KEY;
ALTER TABLE seq_region ADD PRIMARY KEY  (`name`, `schema_build`, `coord_system_id`);

# patch identifier
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_53_54_c.sql|multispecies');
