-- **1. Create a new Linux VM in Google Cloud Platform
-- create vm with docker image
gcloud compute instances create-with-container final-project-kiger \
    --project=scenarioweek10 \
    --zone=us-central1-c \
    --machine-type=e2-small \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=542602767858-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=projects/cos-cloud/global/images/cos-stable-101-17162-127-51 \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=final-project-kiger \
    --container-image=mcr.microsoft.com/mssql/server:2019-latest \
    --container-restart-policy=always \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=ec-src=vm_add-gcloud,container-vm=cos-stable-101-17162-127-51


--  gcloud compute instances list (see instance information)

-- copy the pokemon_backup to the docker container
docker cp './pokemon.bak' ecstatic_germain:"/home/Pokemon.bak"

--  in powershell
-- docker commit to create image
docker commit ecstatic_germain jandyrae/cit326-final:pokemon_backup
-- docker push to dockerhub repo
docker push ecstatic_germain jandyrae/cit326-final:pokemon_backup



--**2.  Move your chosen database into your new docker server in GCP
--  then in gcp ssh
-- docker pull image in from repo
docker pull jandyrae/cit326-final:pokemon_backup
-- docker run command in ssh
docker run --name kiger_final -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=cit326Password$' -e 'MSSQL_AGENT_ENABLED=True' -p 49433:1433 -d jandyrae/cit326-final:pokemon_backup


/*********************************************
3. Create at least two new schemas 
*********************************************/

USE [pokemon_kiger]
GO
CREATE SCHEMA [actions]
GO
CREATE SCHEMA [items]
GO
CREATE SCHEMA [character]
GO
USE [pokemon_kiger]
select 'alter schema actions transfer ' + name + ';' from sys.tables;
alter schema actions transfer move_flag_prose;
alter schema actions transfer pokemon_moves;
alter schema actions transfer move_changelog;
alter schema actions transfer move_flavor_text;
alter schema actions transfer move_target_prose;
alter schema actions transfer move_meta_stat_changes;
alter schema actions transfer encounter_methods;
alter schema actions transfer move_targets;
alter schema actions transfer pokemon_move_methods;
alter schema actions transfer move_damage_classes;
alter schema actions transfer move_damage_class_prose;
alter schema actions transfer move_effect_changelog;
alter schema actions transfer move_effect_changelog_prose;
alter schema actions transfer move_meta_categories;
alter schema actions transfer move_flags;
alter schema actions transfer move_battle_styles;
alter schema actions transfer move_meta_category_prose;
alter schema actions transfer move_effects;
alter schema actions transfer move_battle_style_prose;
alter schema actions transfer ability_prose;
alter schema actions transfer move_meta;
alter schema actions transfer version_group_pokemon_move_methods;
alter schema actions transfer move_flavor_summaries;
alter schema actions transfer move_meta_ailments;
alter schema actions transfer ability_flavor_text;
alter schema actions transfer move_names;
alter schema actions transfer ability_changelog_prose;
alter schema actions transfer encounter_condition_prose;
alter schema actions transfer encounter_slots;
alter schema actions transfer item_fling_effect_prose;
alter schema actions transfer move_flag_map;
alter schema actions transfer ability_names;
alter schema actions transfer encounter_condition_value_prose;
alter schema actions transfer pokemon_abilities;
alter schema actions transfer moves;
alter schema actions transfer encounters;
alter schema actions transfer ability_changelog;
alter schema actions transfer move_meta_ailment_names;
alter schema actions transfer move_effect_prose;

select 'alter schema items transfer ' + name + ';' from sys.tables;
alter schema items transfer item_game_indices;
alter schema items transfer item_flag_map;
alter schema items transfer item_pocket_names;
alter schema items transfer item_flavor_summaries;
alter schema items transfer item_flag_prose;
alter schema items transfer item_prose;
alter schema items transfer item_names;
alter schema items transfer item_categories;
alter schema items transfer item_flags;
alter schema items transfer item_fling_effects;
alter schema items transfer item_pockets;
alter schema items transfer item_category_prose;
alter schema items transfer item_flavor_text;

select 'alter schema character transfer ' + name + ';' from sys.tables;
alter schema character transfer growth_rate_prose;
alter schema character transfer pokemon_species_flavor_text;
alter schema character transfer pokemon_types;
alter schema character transfer pokemon_egg_groups;
alter schema character transfer pokemon;
alter schema character transfer pokemon_forms;
alter schema character transfer version_groups;
alter schema character transfer location_area_prose;
alter schema character transfer region_names;
alter schema character transfer pokemon_form_names;
alter schema character transfer pokemon_form_generations;
alter schema character transfer pal_park;
alter schema character transfer evolution_chains;
alter schema character transfer pokemon_move_method_prose;
alter schema character transfer pokemon_form_pokeathlon_stats;
alter schema character transfer pokemon_shape_prose;
alter schema character transfer pokemon_evolution;
alter schema character transfer nature_names;
alter schema character transfer types;
alter schema character transfer pokemon_habitat_names;
alter schema character transfer version_names;
alter schema character transfer evolution_triggers;
alter schema character transfer machines;
alter schema character transfer pokemon_habitats;
alter schema character transfer locations;
alter schema character transfer genders;
alter schema character transfer versions;
alter schema character transfer pokemon_dex_numbers;
alter schema character transfer pokemon_species;
alter schema character transfer language_names;
alter schema character transfer egg_groups;
alter schema character transfer pokemon_species_flavor_summaries;
alter schema character transfer pal_park_area_names;
alter schema character transfer pokemon_colors;
alter schema character transfer pokemon_species_prose;
alter schema character transfer version_group_regions;
alter schema character transfer pal_park_areas;
alter schema character transfer location_area_encounter_rates;
alter schema character transfer type_efficacy;
alter schema character transfer regions;
alter schema character transfer growth_rates;
alter schema character transfer egg_group_prose;
alter schema character transfer languages;
alter schema character transfer pokeathlon_stats;
alter schema character transfer natures;
alter schema character transfer pokemon_shapes;
alter schema character transfer stats;
alter schema character transfer stat_names;
alter schema character transfer pokemon_color_names;
alter schema character transfer pokedex_prose;
alter schema character transfer pokemon_species_names;
alter schema character transfer stat_hints;
alter schema character transfer generations;
alter schema character transfer pokedexes;
alter schema character transfer evolution_trigger_prose;
alter schema character transfer experience;
alter schema character transfer type_names;
alter schema character transfer pokemon_stats;
alter schema character transfer pokemon_items;
alter schema character transfer location_areas;
alter schema character transfer pokemon_game_indices;
alter schema character transfer generation_names;

-- create logins for the db
USE [master]
GO
CREATE LOGIN [actions_dev] WITH PASSWORD=N'password', DEFAULT_DATABASE=[pokemon_kiger], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [pokemon_kiger]
GO
CREATE USER [actions_dev] FOR LOGIN [actions_dev]
GO
-- ***************************************
USE [master]
GO
CREATE LOGIN [items_dev] WITH PASSWORD=N'password', DEFAULT_DATABASE=[pokemon_kiger], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [pokemon_kiger]
GO
CREATE USER [items_dev] FOR LOGIN [items_dev]
GO
-- ***************************************
USE [master]
CREATE LOGIN [character_dev] WITH PASSWORD=N'password', DEFAULT_DATABASE=[pokemon_kiger], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [pokemon_kiger]
GO
CREATE USER [character_dev] FOR LOGIN [character_dev]
GO
-- ***************************************
USE [master]
CREATE LOGIN [final_test_user] WITH PASSWORD=N'password', DEFAULT_DATABASE=[pokemon_kiger], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [pokemon_kiger]
GO
CREATE USER [final_test_user] FOR LOGIN [final_test_user]
GO

-- grant select for schema
USE [pokemon_kiger]
GRANT SELECT ON SCHEMA::[actions] TO [actions_dev]
GO

GRANT SELECT ON SCHEMA::[items] TO [items_dev]
GO

GRANT SELECT ON SCHEMA::[character] TO [character_dev]
GO

GRANT SELECT ON SCHEMA::[character] TO [final_test_user]
GO

-- login as final_test_user to show access, can only see character schema
-- works upon login
SELECT TOP (10) [id]
      ,[baby_trigger_item_id]
  FROM [pokemon].[character].[evolution_chains]
-- error of permission denied
SELECT TOP (10) [id]
      ,[identifier]
  FROM [pokemon].[actions].[move_flags]


/****************************************************
4. Create a view that combines (joins) data from two tables  
****************************************************/
use [pokemon_kiger]
  create view character.pokemon_info as
  select i.identifier as Name, n.name as species, t.name as type_name, m.identifier as attack_type, s.base_experience as base_xp, s.height, s.weight
  from character.pokemon s inner join character.pokemon_species i on s.id = i.id 
	inner join character.pokemon_species_names n on n.pokemon_species_id = s.id
	inner join actions.moves m on m.id = i.id 
	inner join character.type_names t on t.type_id = m.type_id;

-- select to view
GRANT SELECT ON character.pokemon_info TO [final_test_user]
GO

  -- login as  and check view that utilizes schemas not granted access to
SELECT TOP (10) [Name]
      ,[species]
      ,[type_name]
      ,[attack_type]
      ,[base_xp]
      ,[height]
      ,[weight]
  FROM [pokemon].[character].[pokemon_info]

/****************************************************
5. Create a new database level role, new login, and add it as member to new role  
****************************************************/
use [pokemon_kiger]
CREATE ROLE [final_test]
GO
ALTER AUTHORIZATION ON SCHEMA::[dbo] TO [final_test]
GO
GRANT SELECT ON [actions].[ability_names] TO [final_test]
GO
GRANT SELECT ON [character].[pokemon_info] TO [final_test]
GO
GRANT SELECT ON SCHEMA::[character] TO [final_test]
GO
-- new login
USE [master]
CREATE LOGIN [final_running_buddy] WITH PASSWORD=N'password', DEFAULT_DATABASE=[pokemon_kiger], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
-- add user as member to role
use [pokemon_kiger]
GO
CREATE USER [final_running_buddy] FOR LOGIN [final_running_buddy]
GO
ALTER ROLE [final_test] ADD MEMBER [final_running_buddy]
GO

/***************************************************
6. Set up column level encryption
****************************************************/
-- ColumnName encrypted is 
-- character.pokemon_forms.is_battle_only



/***************************************************
7. backup AND then restore
****************************************************/
ALTER DATABASE pokemon_kiger SET RECOVERY FULL
GO
-- change for cloud db
BACKUP DATABASE [pokemon_kiger] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\pokemon.bak' WITH INIT,  NAME = N'pokemon_kiger-Full Database Backup', CHECKSUM
GO

USE [master]
RESTORE DATABASE [pokemon_kiger] FROM DISK - --...
/* EXAMPLE
RESTORE DATABASE [sample] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\fullsample.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
*/