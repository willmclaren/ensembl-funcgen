-- This one is for general patche
-- Can be applied multiple times with any problems
-- Put dependent patches in later patches

--Some v49 patches which were overwritten 
alter table data_set modify name varchar(100) default NULL;
alter table feature_set modify name varchar(100) default NULL;

-- Alter feature_type and add PSEUDO feature types for regulatory string
alter table feature_type modify `class` enum('Insulator','DNA','Regulatory Feature','Histone','RNA','Polymerase','Transcription Factor','Transcription Factor Complex','Overlap','Regulatory Motif','Region','Enhancer','Expression', 'Pseudo') default NULL;

insert into feature_type values(NULL, 'TSS 2.5KB', 'Pseudo', 'Feature is within +/-2.5KB of the Transcript Start Site');
insert into feature_type values(NULL, 'TTS 2.5KB', 'Pseudo', 'Feature is within +/-2.5KB of the Transcript Termination Site');

--This may change if we do another build for v50
update meta set meta_value='9,8,23,24,25,26,11,27,12,6,5,4,28,29,13,30,31,14,32,33,34,10,35,36,8,9,11,12,4,13,14,10,178400,178401' where meta_key='regulatory_string_feature_type_id';
