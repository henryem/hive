
create table tmp_smb_bucket_10(userid int, pageid int, postid int, type string) partitioned by (ds string) CLUSTERED BY (userid) SORTED BY (pageid, postid, type, userid) INTO 2 BUCKETS STORED AS RCFILE; 

alter table tmp_smb_bucket_10 add partition (ds = '1');
alter table tmp_smb_bucket_10 add partition (ds = '2');

set hive.optimize.bucketmapjoin = true;
set hive.optimize.bucketmapjoin.sortedmerge = true;
set hive.input.format = org.apache.hadoop.hive.ql.io.BucketizedHiveInputFormat;
 
explain
select /*+mapjoin(a)*/ * from tmp_smb_bucket_10 a join tmp_smb_bucket_10 b 
on (a.ds = '1' and b.ds = '2' and
    a.userid = b.userid and
    a.pageid = b.pageid and
    a.postid = b.postid and
    a.type = b.type);

