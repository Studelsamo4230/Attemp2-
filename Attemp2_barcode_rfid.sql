CREATE DATABASE IF NOT EXISTS tests;
USE tests;
DROP TABLE IF  EXISTS patients;
DROP TABLE IF  EXISTS samples;
DROP TABLE IF  EXISTS boxes;
DROP TABLE IF  EXISTS stations;
DROP TABLE IF  EXISTS stationsbarcode;
DROP TABLE IF  EXISTS rfid;

CREATE TABLE patients(
patient_id INT PRIMARY KEY,
patient_name VARCHAR(20)
);

CREATE TABLE samples(
sample_id INT PRIMARY KEY,
patient_id INT ,
received_date DATE,
lab_id INT NOT NULL,
batch_number VARCHAR(50) NOT NULL,
test_type VARCHAR(100) NOT NULL,
FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)

);

CREATE TABLE boxes (
    box_id INT PRIMARY KEY,
    Barcode VARCHAR(255) UNIQUE NOT NULL,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE BoxSamples (
   box_id INT,
    sample_id INT,
    PRIMARY KEY (box_id, sample_id),
    FOREIGN KEY (box_id) REFERENCES Boxes(box_id),
    FOREIGN KEY (sample_id) REFERENCES Samples(sample_id)
);

CREATE TABLE stations(
station_id INT  PRIMARY KEY AUTO_INCREMENT,
station_name VARCHAR(50)

);

CREATE TABLE stationsbarcode(
 BarcodeID INT PRIMARY KEY AUTO_INCREMENT,
    box_id INT,
    StationFrom INT,
    StationTo INT,
    FOREIGN KEY (box_id) REFERENCES boxes(box_id),
    FOREIGN KEY (StationFrom) REFERENCES Stations(station_id),
    FOREIGN KEY (StationTo) REFERENCES Stations(station_id)
    
    );
    
    CREATE TABLE RFIDLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    box_id INT,
    RFIDType ENUM('Start', 'End'),
    Timestamp DATETIME,
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
);

INSERT INTO patients(patient_id,patient_name) VALUES
('1',"Mohamed"),
('2',"Atharva"),
('3',"Yazmine");


INSERT INTO samples(sample_id,patient_id,received_date,lab_id,batch_number,test_type) VALUES
('1','1','2025-03-10','1','batch-01','ytest'),
('2','2','2025-03-11','2','batch-02','yytest'),
('3','3','2025-03-12','3','batch-03','yyytest');

INSERT INTO boxes(box_id,Barcode,location) VALUES
('1','bar-01','lab01-ep'),
('2','bar-02','lab02-ep');


INSERT INTO BoxSamples(box_id,sample_id) VALUES
('1','1'),
('1','2'),
('1','3'),

('2','1'),
('2','2'),
('2','3');

INSERT INTO stations(station_id,station_name) VALUES
('1','start'),
('2','filling'),
('3','mixing'),
('4','putting'),
('5','pushing'),
('6','transportation'),
('7','end');

INSERT INTO stationsbarcode(box_id,stationFrom, StationTo) VALUES
('1','1','2'),
('1','2','3'),
('1','3','4'),
('1','4','5'),
('1','5','6'),
('1','6','7'),

('2','1','2'),
('2','2','3'),
('2','3','4'),
('2','4','5'),
('2','5','6'),
('2','6','7');

INSERT INTO RFIDLogs (box_id, RFIDType, Timestamp) VALUES
('1', 'Start', '2025-04-26 08:00:00'),
('1', 'End',   '2025-04-26 09:15:00'),

('2', 'Start', '2025-04-26 08:05:00'),
('2', 'End',   '2025-04-26 09:10:00');

SELECT * FROM samples s 
JOIN patients p 
ON s.patient_id=p.patient_id
JOIN BoxSamples bs 
ON bs.sample_id=s.sample_id
JOIN boxes b ON bs.box_id = b.box_id
JOIN stationsbarcode k
ON k.box_id=b.box_id
JOIN RFIDLogs r
ON b.box_id=r.box_id



