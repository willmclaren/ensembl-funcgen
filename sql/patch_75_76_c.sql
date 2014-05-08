-- Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


/**
@header patch_75_76_b.sql - result_set/experiment.display_url/archive_id
@desc   Move input_subset display_url and archive_id to the experiment table, and
        add an experiment_id field to result_set. Drop redundant input_subset fields.
*/

-- accomodate longer names like Monocytes-CD14-RO01746
alter table cell_type modify display_label varchar(30);