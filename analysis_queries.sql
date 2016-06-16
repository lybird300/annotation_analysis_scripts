-- View all of the data
select * from tool_effects;

-- View the data excluding VAT rows
select * from tool_effects where tool != 'VAT';

select * from exact_match_count;

select * from adjusted_trimmed_variant_tables;

select count(*) from adjusted_trimmed_variant_tables;

-- View all data from table with 1 effect for each tool
select * from trimmed_variant_tables;

-- count = 334884, use this to make sure table is correct
select count(*) from trimmed_variant_tables;

-- Count all rows in table
-- This should be 334,884, the count of unique positions called by each tool
select count(*) from tool_effects;

-- Counts all rows in table that excludes VAT (rows = 314,004)
-- 314,004 + 20880 (number of variants VAT annotates) = 334,884 (total number from tool_effects table)
select count(*) from tool_effects where tool != 'VAT';

-- Count number of rows (count = 331,007)
select count(*) from exact_match_count;

-- This flips the table and starts from the bottom up ordered by id
-- Highest number id is listed first
select * from tool_effects order by id desc;

-- What is the difference between group by and order by?
-- Group by aggregates lines if possible
-- It is possible that group by and order by will produce the same table
-- Both of these commands put all of the tool rows together for the same position and produce the same table.
-- You can see what tools annotated a particular position.
select * from tool_effects group by chr, start, end, tool;
select * from tool_effects order by chr, start, end, tool;
select * from trimmed_variant_tables order by chr, start, end, effect, tool;
select * from adjusted_trimmed_variant_tables order by chr, start, end, effect, tool;
select * from adjusted_trimmed_variant_tables where effect = 'synonymous_variant' and tool = 'VEP';
select * from adjusted_trimmed_variant_tables group by effect;
select count(*) from adjusted_trimmed_variant_tables order by chr, start, end, effect, tool;
-- This gives you the unique chr, start and end positions in the table
-- count = 62794
select count(*) from (select chr, start, end from adjusted_trimmed_variant_tables group by chr, start, end) x;

-- This orders the table like the statement above excluding VAT 
select * from tool_effects where tool != 'VAT' order by chr, start, end, tool;

-- Count how many tools annotate a given position (position = chr, start, end)
-- Use this to make a histogram showing how many positions are annotated by 1,2,3,4,5, or all 6 tools
-- annotated_tools is an alias for count(tool). If I didn't have annotated_tools, 
-- then the column name would be count(tool) in the resulting table
select chr, start, end, count(tool) as annotated_tools from tool_effects group by chr, start, end;
select chr, start, end, count(tool) as annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end;

-- This counts the number of lines in the table given by the above command 
-- Count = 62831, total number of unique annotated positions
select count(*) from (select chr, start, end, count(tool) as annotated_tools from tool_effects group by chr, start, end) count_tools;
select count(*) from (select chr, start, end, count(tool) as annotated_tools from trimmed_variant_tables group by chr, start, end) count_tools;
select count(*) from (select chr, start, end, count(tool) as annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end) count_tools;
-- count = 62794
select count(*) from (select chr, start, end, count(tool) as annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end) count_tools;
select count(*) from (select chr, start, end, count(tool) as annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end) count_tools;

-- These are the same as the 2 commands above but they exclude VAT
select chr, start, end, count(tool) as annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end;
-- Count = 62831
-- This is the same because all of the positions that VAT annotates are also annotated by at least 1 other tool
select count(*) from (select chr, start, end, count(tool) as annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end) count_tools_exclude_VAT;

-- Show the number of tools that annotate each unique position
select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 6;

-- Show the number of tools that annotate each unique position after excluding VAT
select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 5;

-- Count how many total unique positions (chr, start, end) are annotated by all 6 tools
-- Count = 20880, the total number of unique positions VAT annotates
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 6) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables group by chr, start, end having annotated_tools = 6) alltools;

-- Count how many total unique positions are annotated by 5 tools (Count = 41,912)
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 5) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 4) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 3) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 2) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 1) alltools;

-- Count number of unique positions annotated by all 5 tools after excluding VAT (count = 62792)
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 5) all_pos_annotated_exclude_VAT;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 5) all_pos_annotated_exclude_VAT;

-- Count number of unique positions annotated by 4 tools after excluding VAT (count = 0)
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 4) all_pos_annotated_exclude_VAT;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 4) all_pos_annotated_exclude_VAT;

-- For the queries below, which tools are the ones that are annotating these positions?
-- Count number of unique positions annotated by 3 tools after excluding VAT (count = 2)
-- Tools are VAAST, snpEff and Seattleseq
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 3) all_pos_annotated_exclude_VAT;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 3) all_pos_annotated_exclude_VAT;
-- Gives you chr, start, end for positions annotated by 3 tools
select * from (select chr, start, end, effect, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 3) alias;
select * from (select chr, start, end, effect, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 3) alias;
-- Use start values from previous query to look up the three tools that annotate this position 
-- You can also pull up the whole tool_effects table and use the search box to find the rows
select * from tool_effects where start = 118505676;
select * from trimmed_variant_tables where start = 118505676;
select * from tool_effects where start = 10263453;

-- Count number of unique positions annotated by 2 tools after excluding VAT (count = 1)
-- Tools are ANNOVAR and VEP
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 2) all_pos_annotated_exclude_VAT;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 2) all_pos_annotated_exclude_VAT;
select * from (select chr, start, end, effect, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 2) alias;
select * from (select chr, start, end, effect, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 2) alias;
select * from tool_effects where start = 118505677;
select * from trimmed_variant_tables where start = 118505677;

select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 2) all_pos_annotated_exclude_VAT;
select * from (select chr, start, end, effect, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 2) alias;
select * from trimmed_variant_tables where start = 118505677;

-- Count number of unique positions annotated by 1 tool after excluding VAT (count = 36)
-- 35 positions annotated by ANNOVAR and 1 position annotated by VEP
select count(*) from (select chr, start, end, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 1) all_pos_annotated_exclude_VAT;
select count(*) from (select chr, start, end, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 1) all_pos_annotated_exclude_VAT;
select * from (select chr, start, end, effect, tool, count(tool) annotated_tools from tool_effects where tool != 'VAT' group by chr, start, end having annotated_tools = 1) alias;
select * from (select chr, start, end, effect, tool, count(tool) annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 1) alias;

-- Count number of tools that annotate each position from adjusted_trimmed_variant_tables (adjusted positions)
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 6) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 5) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 4) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 3) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 2) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end having annotated_tools = 1) alltools;

select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 5) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 4) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 3) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 2) alltools;
select count(*) from (select chr, start, end, count(tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end having annotated_tools = 1) alltools;

-- Count how many positions are annotated by all tools for each chromosome
select chr, count(chr) as chr_count from (select chr, start, end, count(tool) annotated_tools from tool_effects group by chr, start, end having annotated_tools = 6) alltools group by chr;

-- Show all variant effects for each position and the count of the number of tools that assigned that effect
select chr, start, end, effect, count(tool) as annotated_tools from trimmed_variant_tables group by chr, start, end, effect;

-- Show all variant effects for each position and the count of the number of tools that assigned that effect excluding VAT
-- Probably don't need this one
select chr, start, end, effect, count(tool) as annotated_tools from trimmed_variant_tables where tool != 'VAT' group by chr, start, end, effect;

select a.start, a.end, a.effect, a.tool as tool_1, b.tool as tool_2 from adjusted_trimmed_variant_tables a, adjusted_trimmed_variant_tables b where a.start = b.start and a.end = b.end and a.effect = b.effect and a.tool <> b.tool;


select * from adjusted_trimmed_variant_tables where start = 63697;

-- This gives me the count of number of tools with exact effect matches for each position
-- I could export this to give me graph of exact matches by effect
-- Or I could just report on the number of exact matches for all tools or all tools excluding VAT
select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect order by cnt desc;

-- Including VAT rows, exact matches = 17681
select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 6 order by cnt desc;

-- graph of # of tools agreed on effect
select count(*) from (select chr, start, end, effect, count(distinct tool) annotated_tools from adjusted_trimmed_variant_tables group by chr, start, end, effect having annotated_tools = 6) alltools;

select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 6 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 5 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 4 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 3 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 2 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables group by start, end, effect having cnt = 1 order by cnt desc) x;


-- Excluding VAT, exact matches = 45359
select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 5 order by cnt desc;
-- This gives me 45360 instead of 45359 and I don't know why
select count(*) from (select chr, start, end, effect, count(distinct tool) annotated_tools from adjusted_trimmed_variant_tables where tool != 'VAT' group by chr, start, end, effect having annotated_tools = 5) alltools;

select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 5 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 4 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 3 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 2 order by cnt desc) x;
select count(*) from (select chr, start, end, effect, count(distinct tool) as cnt from adjusted_trimmed_variant_tables where tool != 'VAT' group by start, end, effect having cnt = 1 order by cnt desc) x;


select chr, start, end, effect, tool from adjusted_trimmed_variant_tables order by start, end, effect;

select a.chr, a.start, a.end, a.effect, a.tool tool1, b.tool tool2 from adjusted_trimmed_variant_tables a, adjusted_trimmed_variant_tables b where a.chr = b.chr and a.start = b.start and a.end = b.end and a.effect = b.effect and a.tool = 'ANNOVAR' and b.tool = 'Seattleseq';
select a.chr, a.start, a.end, a.effect, a.tool tool1, b.tool tool2 from adjusted_trimmed_variant_tables a, adjusted_trimmed_variant_tables b where a.chr = b.chr and a.start = b.start and a.end = b.end and a.effect = b.effect and a.tool = 'ANNOVAR' and b.tool = 'snpEff';


select * from adjusted_trimmed_variant_tables;

/* All unique combinations of 2 tools
ANNOVAR Seattleseq
ANNOVAR snpEff
ANNOVAR VAAST
ANNOVAR VAT
ANNOVAR VEP
Seattleseq snpEff
Seattleseq VAAST
Seattleseq VAT
Seattleseq VEP
snpEff VAAST
snpEff VAT
snpEff VEP
VAAST VAT
VAAST VEP
VAT VEP
*/

-- This is to compare 2 tools for exact match on effect and chr, start, end in adjusted_trimmed_variant_tables
select 
	a.chr, 
	a.start, 
	a.end, 
	a.effect, 
	a.tool as tool1, 
	b.tool as tool2 
from 
	adjusted_trimmed_variant_tables a, 
	adjusted_trimmed_variant_tables b 
where 
	a.chr = b.chr and 
	a.start = b.start and 
	a.end = b.end and 
	a.effect = b.effect 
	and a.tool = 'ANNOVAR' 
	and b.tool = 'VAT';

select count(*) from (select 
	a.chr, 
	a.start, 
	a.end, 
	a.effect, 
	a.tool as tool1, 
	b.tool as tool2 
from 
	adjusted_trimmed_variant_tables a, 
	adjusted_trimmed_variant_tables b 
where 
	a.chr = b.chr and 
	a.start = b.start and 
	a.end = b.end and 
	a.effect = b.effect 
	and a.tool = 'snpEff' 
	and b.tool = 'VEP') x;

select * from adjusted_trimmed_variant_tables where effect = 'intragenic_variant';

-- Get discrepant variants 
-- intergenic_variant;sequence_variant;intron_variant;intragenic_variant   241
select 
	a.chr, 
	a.start, 
	a.end, 
	a.tool, 
	a.effect as effect1, 
	b.effect as effect2 
from 
	adjusted_trimmed_variant_tables a, 
	adjusted_trimmed_variant_tables b 
where 
	a.chr = b.chr and 
	a.start = b.start and 
	a.end = b.end and 
	a.effect = 'missense_variant'
    and b.effect = '3_prime_UTR_variant';
    
    
select count(*) from (select 
	a.chr, 
	a.start, 
	a.end, 
    a.tool,
	a.effect as effect1,
    b.effect as effect2,
    c.effect as effect3,
	d.effect as effect4

from 
	adjusted_trimmed_variant_tables a, 
	adjusted_trimmed_variant_tables b,
    adjusted_trimmed_variant_tables c,
    adjusted_trimmed_variant_tables d

where 
	a.chr = b.chr and 
    a.chr = c.chr and
    a.chr = d.chr and
    b.chr = c.chr and
    b.chr = d.chr and
    c.chr = d.chr and
	a.start = b.start and 
    a.start = c.start and
    a.start = d.start and
    b.start = c.start and
    b.start = d.start and
    c.start = d.start and
	a.end = b.end and
    a.end = c.end and
    a.end = d.end and
    b.end = c.end and
    b.end = d.end and
    c.end = d.end and
	a.effect = 'intergenic_variant'
    and b.effect = 'sequence_variant'
    and c.effect = 'intron_variant'
    and d.effect = 'intragenic_variant')x;
    
-- Create a view with variants only from ANNOVAR, snpEff and VAAST and then query on this for discrepant variants
create view same_ref as select * from adjusted_trimmed_variant_tables where tool = 'ANNOVAR' or tool = 'VAAST' or tool = 'snpEff';
select * from same_ref;

select 
	a.chr, 
	a.start, 
	a.end, 
    a.tool as tool1,
    b.tool as tool2,
    c.tool as tool3,
	a.effect as effect1,
    b.effect as effect2,
    c.effect as effect3

from 
	same_ref a, 
	same_ref b,
    same_ref c

where 
	a.chr = b.chr and 
    a.chr = c.chr and
    b.chr = c.chr and
	a.start = b.start and 
    a.start = c.start and
    b.start = c.start and
	a.end = b.end and
    a.end = c.end and
    b.end = c.end and
    a.effect = 'exon_variant'
    and b.effect = 'non_coding_transcript_exon_variant'
    and c.effect = 'intron_variant';

select 
	a.chr, 
	a.start, 
	a.end, 
    a.tool as tool1,
    b.tool as tool2,
    c.tool as tool3,
	a.effect as effect1,
    b.effect as effect2,
    c.effect as effect3

from 
	same_ref a, 
	same_ref b,
    same_ref c

where 
	a.chr = b.chr and 
    a.chr = c.chr and
    b.chr = c.chr and
	a.start = b.start and 
    a.start = c.start and
    b.start = c.start and
	a.end = b.end and
    a.end = c.end and
    b.end = c.end and
    a.effect = 'missense_variant'
    and b.effect = 'exonic_splice_region_variant'
    and c.effect = 'splice_acceptor_variant';
    
select 
	a.chr, 
	a.start, 
	a.end, 
    a.tool as tool1,
    b.tool as tool2,
    c.tool as tool3,
	a.effect as effect1,
    b.effect as effect2,
    c.effect as effect3

from 
	same_ref a, 
	same_ref b,
    same_ref c

where 
	a.chr = b.chr and 
    a.chr = c.chr and
    b.chr = c.chr and
	a.start = b.start and 
    a.start = c.start and
    b.start = c.start and
	a.end = b.end and
    a.end = c.end and
    b.end = c.end and
    a.effect = 'disruptive_inframe_insertion'
    and b.effect = 'stop_gained'
    and c.effect = 'inframe_insertion';
    
-- Update snpeff after fixing some of the most severe effects
drop temporary table if exists `temp_table`;
drop temporary table if exists `snpeff`;

CREATE TEMPORARY TABLE temp_table (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chr` VARCHAR(45) NULL,
  `start` INT NULL,
  `end` INT NULL,
  `transcript` LONGTEXT NULL,
  `effect` LONGTEXT NULL,
  `tool` VARCHAR(45) NULL,
  `original_position` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));
  
LOAD DATA LOCAL INFILE '/Users/nicole/Desktop/snpeff_table.txt' INTO TABLE temp_table FIELDS TERMINATED BY '\t';
select * from temp_table;
set sql_safe_updates=0;
update adjusted_trimmed_variant_tables join temp_table using (id) set adjusted_trimmed_variant_tables.effect = temp_table.effect;
select * from adjusted_trimmed_variant_tables where tool = 'snpEff';
