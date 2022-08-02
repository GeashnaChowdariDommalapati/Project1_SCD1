
<br />
<div align="center">
  <h1 align="center">Implementing SCD1 In Hive</h1>
</div>
<br>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#loading-data-to-mysql">Loading Data To MySQL</a></li>
    <li><a href="#loading-data-to-hdfs">Loading Data To HDFS</a></li>
    <li><a href="#creating-hive-managed-table-and-loading-data-from-hdfs">Creating Hive Managed Table and Loading Data From HDFS</a></li>
    <li><a href="#creating-external-table-on-basis-of-dynamic-partition-and-load-data-by-performing-scd1">Creating External Table On Basis of Dynamic Partition and load data by performing SCD1</a></li>
    <li><a href="#creating-staging-table-and-performing-data-recialiation">Creating Staging Table And Performing Data Recialiation</a></li>
    <li><a href="#loading-data-again-to-the-mysql">Loading Data Again To The MySQL</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

![Hive1](https://user-images.githubusercontent.com/107996709/182199935-86e1f322-1a27-413c-9592-1cdea893389e.png)

A company XYZ receives the data in some file formats in local file system, the company wishes to load the data to the MySQL by creating a table and load the table data into hdfs and transfer the data from hdfs to the hive manages table and from the hive managed table the data is transferred to the hive external table by doing dynamic partition on basis of month and year and later when the new file is uploaded it will perform scd1 to make sure the updated data is only stored and then the data is transferred from external table to a staging table by performing data reconcialiation and finally load the data again to MySQL.



### Built With

Technologies and tools that are used in the project

* MySQL
* Unix Shell Scripting
* Hadoop
* Sqoop
* Hive

## Loading Data To MySQL

* For Loadng the data to the MySQL from local file system, We faced a challenge that the data is not loading with the normal login of mysql in shell scripting.
* To overcome that we have to activate two properties.
* For opening the MySQL in shell
    * mysql --local-infile=1 -uusername -p
* Before loading the data to the MySQL table
    * SET GLOBAL local_infile=1;





## Loading Data To HDFS

* While loading the Data from MySQL table to HDFS, the structure is changing like the column places are replacing.
* To overcome that we wrote a free form query which contains all the column names sequentially.



## Creating Hive Managed Table and Loading Data From HDFS

* As it is not possible to directly load the data from hdfs to hive external table, I created a managed table to load the data from hdfs to hive internal table.
* Loading of data can be done by just creating a table and a load data inpath command.


## Creating External Table On Basis of Dynamic Partition and load data by performing SCD1

* In the external table, the first task is to create a dynamic partition on basis of month and year and the second task is to perform SCD1.
* For the dynamic partition, entry time column can be used but the challenge here is, the column format is not feasible to take the month and year out of it, so I used unix_timestamp and from_unixtime functions to change the given format data to hipoc seconds and it again it will change the hipoc seconds to datetime format which is suitable to take the month and year by using month and year functions.
* For the SCD1, the method I followed is to use left join, right join and inner join which gives the outputs individually and finally combine all the outputs by using union which automatically eliminates duplicates which is the historical records.


## Creating Staging Table And Performing Data Recialiation

* Data reconcialiation in the sense, the number of records entering has to be exactly equal when it is exporting the data again to the MySQL table.
* In our case data reconcialiation is done by using the timestamp column which is created in the input MySQL table.

## Loading Data Again To The MySQL

* In the end, I loading the data from the staging table to the MySQL by using sqoop expor command.
