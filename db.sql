-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 05, 2025 at 11:50 AM
-- Server version: 10.6.23-MariaDB-cll-lve
-- PHP Version: 8.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `citlogis_foundation`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`citlogis`@`localhost` PROCEDURE `sp_authenticate_user` (IN `p_email_or_phone` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
  DECLARE v_user_id INT;
  DECLARE v_user_status TINYINT;
  DECLARE v_failed_attempts INT;
  
  -- Find user by email or phone
  SELECT id, status, failedLoginAttempts 
  INTO v_user_id, v_user_status, v_failed_attempts
  FROM `User` 
  WHERE (email = p_email_or_phone OR phoneNumber = p_email_or_phone)
    AND password = p_password;
  
  -- Check if user exists and password is correct
  IF v_user_id IS NOT NULL THEN
    -- Check if account is locked
    IF v_user_status = 0 THEN
      SELECT 'ACCOUNT_INACTIVE' as result, NULL as user_id;
    ELSEIF v_user_status = 2 THEN
      SELECT 'ACCOUNT_SUSPENDED' as result, NULL as user_id;
    ELSE
      -- Reset failed attempts and update last login
      UPDATE `User` 
      SET failedLoginAttempts = 0, 
          lastLoginAt = NOW(),
          lastLoginIp = USER()
      WHERE id = v_user_id;
      
      SELECT 'SUCCESS' as result, v_user_id as user_id;
    END IF;
  ELSE
    -- Increment failed attempts for the email/phone
    UPDATE `User` 
    SET failedLoginAttempts = failedLoginAttempts + 1
    WHERE email = p_email_or_phone OR phoneNumber = p_email_or_phone;
    
    SELECT 'INVALID_CREDENTIALS' as result, NULL as user_id;
  END IF;
END$$

CREATE DEFINER=`citlogis`@`localhost` PROCEDURE `sp_register_user` (IN `p_name` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_phone` VARCHAR(20), IN `p_password` VARCHAR(255), IN `p_role` ENUM('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR'), IN `p_national_id` VARCHAR(20), IN `p_address` TEXT, IN `p_city` VARCHAR(100), IN `p_country` VARCHAR(100))   BEGIN
  DECLARE v_user_id INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  
  START TRANSACTION;
  
  -- Check if email or phone already exists
  IF EXISTS(SELECT 1 FROM `User` WHERE email = p_email OR phoneNumber = p_phone) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User with this email or phone already exists';
  END IF;
  
  -- Insert new user
  INSERT INTO `User` (
    name, email, phoneNumber, password, role, created_at, updatedAt,
    status, nationalId, address, city, country
  ) VALUES (
    p_name, p_email, p_phone, p_password, p_role, NOW(), NOW(),
    1, p_national_id, p_address, p_city, p_country
  );
  
  SET v_user_id = LAST_INSERT_ID();
  
  COMMIT;
  
  SELECT v_user_id as user_id, 'SUCCESS' as result;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE `activity` (
  `id` int(11) NOT NULL,
  `my_actitvity_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(3) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(250) NOT NULL,
  `start_date` varchar(100) NOT NULL,
  `end_date` varchar(100) NOT NULL,
  `image_url` varchar(200) NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `activity_type` varchar(200) NOT NULL,
  `budget_total` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `activity`
--

INSERT INTO `activity` (`id`, `my_actitvity_id`, `name`, `status`, `title`, `description`, `location`, `start_date`, `end_date`, `image_url`, `user_id`, `client_id`, `activity_type`, `budget_total`) VALUES
(1, 0, 'Activity 1', 0, '', '', 'location 1', '', '', '', 0, 0, '', 0.00),
(2, 0, 'Activity 2', 0, '', '', 'location 3', '', '', '', 0, 0, '', 0.00),
(3, 0, '', 0, 's', 'a', 'location 2', '2025-07-25T06:21', '2025-07-25T07:21', '', 0, 0, 'meeting', 0.00),
(4, 0, '', 0, 'football', 'testing', 'location 1', '2025-07-25T06:52', '2025-07-25T07:52', '', 0, 0, 'visit', 4200.00);

-- --------------------------------------------------------

--
-- Table structure for table `activity_budget`
--

CREATE TABLE `activity_budget` (
  `id` int(11) NOT NULL,
  `activity_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(11,2) NOT NULL,
  `total` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `activity_budget`
--

INSERT INTO `activity_budget` (`id`, `activity_id`, `item_name`, `quantity`, `unit_price`, `total`) VALUES
(1, 4, 'chairs', 10, 300.00, 3000.00),
(2, 4, 'tents', 3, 400.00, 1200.00);

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `department` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `staff_name` varchar(200) NOT NULL,
  `password` varchar(100) NOT NULL,
  `mobile_number` varchar(20) NOT NULL,
  `account_code` varchar(32) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `missing` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `account_balance` int(11) NOT NULL,
  `running` int(11) NOT NULL,
  `pending` int(11) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(32) NOT NULL,
  `gender` varchar(32) NOT NULL,
  `country` varchar(99) NOT NULL,
  `image` varchar(999) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `branch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `department`, `department_name`, `staff_name`, `password`, `mobile_number`, `account_code`, `fname`, `missing`, `salary`, `account_balance`, `running`, `pending`, `address`, `phone`, `gender`, `country`, `image`, `created`, `modified`, `status`, `branch`) VALUES
(22, 'Waswa', 1, 'Admin', 'Dim', 'd8578edf8458ce06fbc5bb76a58c5ca4', '07123456', '', 'Bryan', 0, 10000, -300, 300, -300, NULL, '', '', '', '', NULL, '2025-08-30 14:15:31', 0, 0),
(26, 'Finance', 2, 'Finance', 'finance@hotel.com', 'd8578edf8458ce06fbc5bb76a58c5ca4', '071111', '', '', 0, 0, 0, 0, 0, NULL, '', '', '', '', NULL, '2025-02-20 13:06:15', 1, 0),
(27, 'bryanotieno09@gmail.com', 1, 'Admin', 'My Name', 'd8578edf8458ce06fbc5bb76a58c5ca4', '0728891', '', '', 0, 0, 0, 0, 0, NULL, '', '', '', '', NULL, NULL, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `AmbulanceRequest`
--

CREATE TABLE `AmbulanceRequest` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL COMMENT 'User requesting the ambulance',
  `ambulanceId` int(11) DEFAULT NULL COMMENT 'Assigned ambulance ID',
  `purpose` varchar(500) NOT NULL COMMENT 'Purpose of ambulance use',
  `destination` varchar(500) NOT NULL COMMENT 'Destination address',
  `startDate` datetime(3) NOT NULL COMMENT 'Start date and time',
  `endDate` datetime(3) NOT NULL COMMENT 'End date and time',
  `notes` text DEFAULT NULL COMMENT 'Additional notes',
  `latitude` double DEFAULT NULL COMMENT 'Request location latitude',
  `longitude` double DEFAULT NULL COMMENT 'Request location longitude',
  `address` varchar(500) DEFAULT NULL COMMENT 'Request location address',
  `status` enum('pending','approved','rejected','assigned','completed','cancelled') NOT NULL DEFAULT 'pending' COMMENT 'Request status',
  `assignedBy` int(11) DEFAULT NULL COMMENT 'Admin who assigned the ambulance',
  `assignedAt` datetime(3) DEFAULT NULL COMMENT 'When ambulance was assigned',
  `completedAt` datetime(3) DEFAULT NULL COMMENT 'When request was completed',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `AmbulanceRequest`
--

INSERT INTO `AmbulanceRequest` (`id`, `userId`, `ambulanceId`, `purpose`, `destination`, `startDate`, `endDate`, `notes`, `latitude`, `longitude`, `address`, `status`, `assignedBy`, `assignedAt`, `completedAt`, `createdAt`, `updatedAt`) VALUES
(1, 2, NULL, 'test', 'home', '2025-07-09 00:00:00.000', '2025-07-09 00:00:00.000', 'test', -1.2149009, 36.887211, 'QVPP+2VM, Nairobi, Kenya', 'pending', NULL, NULL, NULL, '2025-07-09 00:55:29.476', '2025-07-09 00:55:29.476');

-- --------------------------------------------------------

--
-- Table structure for table `ambulances`
--

CREATE TABLE `ambulances` (
  `id` int(11) NOT NULL,
  `reg_number` varchar(100) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ambulances`
--

INSERT INTO `ambulances` (`id`, `reg_number`, `status`) VALUES
(1, 'KDH 112A', 0),
(2, 'KDB 223F', 0);

-- --------------------------------------------------------

--
-- Table structure for table `Booking`
--

CREATE TABLE `Booking` (
  `id` int(11) NOT NULL,
  `roomId` int(11) NOT NULL,
  `customerId` int(11) NOT NULL,
  `checkIn` datetime(3) NOT NULL,
  `checkOut` datetime(3) NOT NULL,
  `guests` int(11) NOT NULL,
  `totalPrice` double NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `BursaryApplication`
--

CREATE TABLE `BursaryApplication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `childName` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `parentIncome` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `applicationDate` datetime(3) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
  `notes` text DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `BursaryApplication_userId_idx` (`userId`),
  KEY `BursaryApplication_status_idx` (`status`),
  KEY `BursaryApplication_applicationDate_idx` (`applicationDate`),
  CONSTRAINT `BursaryApplication_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `BursaryPayment`
--

CREATE TABLE `BursaryPayment` (
  `id` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  `schoolId` int(11) NOT NULL,
  `amount` double NOT NULL,
  `datePaid` datetime(3) NOT NULL,
  `referenceNumber` varchar(191) DEFAULT NULL,
  `paidBy` varchar(191) DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `BursaryPayment`
--

INSERT INTO `BursaryPayment` (`id`, `studentId`, `schoolId`, `amount`, `datePaid`, `referenceNumber`, `paidBy`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 1, 1, 100, '2025-05-13 00:00:00.000', 'MPESA', 'Waswa', NULL, '2025-05-13 09:39:51.753', '0000-00-00 00:00:00.000'),
(2, 1, 1, 20000, '2025-05-13 00:00:00.000', 'test', 'Waswa', NULL, '2025-05-13 15:06:33.214', '0000-00-00 00:00:00.000'),
(3, 1, 1, 20000, '2025-05-13 00:00:00.000', 'test', 'Waswa', NULL, '2025-05-13 15:06:33.616', '0000-00-00 00:00:00.000'),
(4, 1, 1, 20000, '2025-05-13 00:00:00.000', 'test', 'Waswa', NULL, '2025-05-13 15:06:33.683', '0000-00-00 00:00:00.000'),
(5, 1, 1, 20000, '2025-07-25 00:00:00.000', 'test', 'Woosh', NULL, '2025-07-25 05:37:44.716', '0000-00-00 00:00:00.000');

-- --------------------------------------------------------

--
-- Table structure for table `Category`
--

CREATE TABLE `Category` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Category`
--

INSERT INTO `Category` (`id`, `name`) VALUES
(1, 'Medical Accessories'),
(2, 'Medicines'),
(3, 'Food Stuff');

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE `Customer` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Distribution`
--

CREATE TABLE `Distribution` (
  `id` int(11) NOT NULL,
  `journeyPlanId` int(11) NOT NULL,
  `recipientName` varchar(191) DEFAULT NULL COMMENT 'Name of the person who received the distribution',
  `recipientPhone` varchar(191) DEFAULT NULL COMMENT 'Phone number of the recipient',
  `recipientNotes` varchar(500) DEFAULT NULL COMMENT 'Additional notes about the recipient',
  `distributedBy` int(11) DEFAULT NULL COMMENT 'User ID who performed the distribution',
  `distributionDate` datetime(3) DEFAULT NULL COMMENT 'Date and time when distribution was completed',
  `photoCount` int(11) DEFAULT 0 COMMENT 'Number of photos taken during distribution',
  `finalNotes` text DEFAULT NULL COMMENT 'Final notes and observations about the distribution',
  `totalItems` int(11) DEFAULT 0 COMMENT 'Total number of items distributed',
  `distributionStatus` enum('pending','in_progress','completed','cancelled') DEFAULT 'pending' COMMENT 'Current status of the distribution process',
  `status` int(11) NOT NULL DEFAULT 0,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Distribution`
--

INSERT INTO `Distribution` (`id`, `journeyPlanId`, `recipientName`, `recipientPhone`, `recipientNotes`, `distributedBy`, `distributionDate`, `photoCount`, `finalNotes`, `totalItems`, `distributionStatus`, `status`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for 1', '2025-05-12 22:41:04.254', '2025-05-12 22:41:04.254'),
(2, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for rereerree', '2025-05-12 22:43:19.819', '2025-05-12 22:43:19.819'),
(3, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for teste', '2025-05-12 22:44:45.213', '2025-05-12 22:44:45.213'),
(4, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for poiu', '2025-05-12 22:46:19.943', '2025-05-12 22:46:19.943'),
(5, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for 54', '2025-05-12 22:52:24.034', '2025-05-12 22:52:24.034'),
(6, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for post', '2025-05-12 22:53:22.448', '2025-05-12 22:53:22.448'),
(7, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for jo', '2025-05-12 22:56:28.574', '2025-05-12 22:56:28.574'),
(8, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for wertyui', '2025-05-12 22:57:10.835', '2025-05-12 22:57:10.835'),
(9, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for cv', '2025-05-12 23:01:03.483', '2025-05-12 23:01:03.483'),
(10, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for qretre', '2025-05-12 23:04:09.340', '2025-05-12 23:04:09.340'),
(11, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'pending', 0, 'Distribution for joooooo', '2025-05-12 23:10:45.139', '2025-05-12 23:10:45.139'),
(12, 5, 'test', '12345678', 'gh', 2, '2025-07-09 00:13:24.000', 2, NULL, 8, 'completed', 0, 'Distribution for test', '2025-07-08 23:15:54.000', '2025-07-09 00:13:24.000');

-- --------------------------------------------------------

--
-- Table structure for table `DistributionItem`
--

CREATE TABLE `DistributionItem` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `distributedAt` datetime(3) DEFAULT current_timestamp(3),
  `recipientId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `DistributionItem`
--

INSERT INTO `DistributionItem` (`id`, `distributionId`, `productId`, `quantity`, `unit`, `notes`, `distributedAt`, `recipientId`) VALUES
(1, 1, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 2),
(2, 2, 1, 2, NULL, NULL, '2025-07-08 19:00:36.669', 3),
(3, 3, 1, 2, NULL, NULL, '2025-07-08 19:00:36.669', 4),
(4, 4, 1, 2, NULL, NULL, '2025-07-08 19:00:36.669', 5),
(5, 5, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 10),
(6, 6, 1, 2, NULL, NULL, '2025-07-08 19:00:36.669', 11),
(7, 7, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 12),
(8, 8, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 13),
(9, 9, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 14),
(10, 10, 1, 4, NULL, NULL, '2025-07-08 19:00:36.669', 15),
(11, 11, 1, 1, NULL, NULL, '2025-07-08 19:00:36.669', 16),
(12, 12, 1, 2, 'kg', NULL, '2025-07-08 23:15:55.000', 1),
(14, 12, 1, 3, 'units', NULL, '2025-07-09 00:05:19.000', 1),
(15, 12, 1, 3, 'units', NULL, '2025-07-09 00:13:11.000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `DistributionPhotos`
--

CREATE TABLE `DistributionPhotos` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `photoUrl` varchar(500) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `fileSize` int(11) DEFAULT NULL,
  `takenAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `DistributionPhotos`
--

INSERT INTO `DistributionPhotos` (`id`, `distributionId`, `photoUrl`, `description`, `fileSize`, `takenAt`, `createdAt`, `updatedAt`) VALUES
(1, 12, 'https://res.cloudinary.com/otienobryan/image/upload/v1752009373/whoosh/file_1752009370206_ustoqe.jpg', 'test', 223884, '2025-07-08 23:16:15.000', '2025-07-08 23:16:15.000', '2025-07-08 23:16:15.000'),
(2, 12, 'https://res.cloudinary.com/otienobryan/image/upload/v1752009373/whoosh/file_1752009370206_ustoqe.jpg', 'test', 223884, '2025-07-09 00:13:15.000', '2025-07-09 00:13:15.000', '2025-07-09 00:13:15.000');

-- --------------------------------------------------------

--
-- Table structure for table `DistributionTaskStatus`
--

CREATE TABLE `DistributionTaskStatus` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `taskType` enum('distribute','gallery','checkout') NOT NULL,
  `isCompleted` tinyint(1) DEFAULT 0,
  `completedAt` datetime(3) DEFAULT NULL,
  `completedBy` int(11) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `DistributionTaskStatus`
--

INSERT INTO `DistributionTaskStatus` (`id`, `distributionId`, `taskType`, `isCompleted`, `completedAt`, `completedBy`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 1, 'distribute', 1, '2025-07-08 19:00:36.000', 1, 'Products distributed successfully', '2025-07-08 19:00:36.896', '2025-07-08 19:00:36.896'),
(2, 1, 'gallery', 1, '2025-07-08 19:00:36.000', 1, 'Photos taken and documented', '2025-07-08 19:00:36.896', '2025-07-08 19:00:36.896'),
(3, 1, 'checkout', 1, '2025-07-08 19:00:36.000', 1, 'Distribution completed and submitted', '2025-07-08 19:00:36.896', '2025-07-08 19:00:36.896'),
(4, 12, 'distribute', 1, '2025-07-08 22:13:26.000', 2, 'Distribute task completed', '2025-07-09 00:13:10.000', '2025-07-09 00:13:25.000'),
(7, 12, 'gallery', 1, '2025-07-08 22:13:26.000', 2, 'Gallery task completed', '2025-07-09 00:13:15.000', '2025-07-09 00:13:26.000'),
(9, 12, 'checkout', 1, '2025-07-08 22:13:26.000', 2, 'Checkout task completed', '2025-07-09 00:13:25.000', '2025-07-09 00:13:26.000');

-- --------------------------------------------------------

--
-- Table structure for table `FeedbackReport`
--

CREATE TABLE `FeedbackReport` (
  `id` int(11) NOT NULL,
  `journeyPlanId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `reportId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `FeedbackReport`
--

INSERT INTO `FeedbackReport` (`id`, `journeyPlanId`, `userId`, `comment`, `createdAt`, `updatedAt`, `reportId`) VALUES
(1, 1, 1, 'testing', '2025-05-13 10:38:30.449', '0000-00-00 00:00:00.000', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `JourneyPlan`
--

CREATE TABLE `JourneyPlan` (
  `id` int(11) NOT NULL,
  `date` datetime(3) NOT NULL,
  `time` varchar(191) NOT NULL,
  `userId` int(11) NOT NULL,
  `recipientId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `checkInTime` datetime(3) DEFAULT NULL,
  `checkInLatitude` double DEFAULT NULL,
  `checkInLongitude` double DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `JourneyPlan`
--

INSERT INTO `JourneyPlan` (`id`, `date`, `time`, `userId`, `recipientId`, `locationId`, `status`, `checkInTime`, `checkInLatitude`, `checkInLongitude`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, '2025-05-12 00:00:00.000', '', 2, NULL, 1, 'checked_in', '2025-05-12 18:22:27.954', -1.3010349, 36.7777117, 'Location 1', '2025-05-12 18:20:57.684', '2025-07-07 23:47:39.000'),
(2, '2025-05-13 00:00:00.000', '', 1, NULL, 2, 'checked_in', '2025-05-13 16:02:49.613', -1.2847394, 36.8228131, 'bokoli', '2025-05-13 14:55:15.243', '2025-07-07 23:47:39.000'),
(3, '2025-07-07 00:00:00.000', '16:00:00', 2, 3, 3, 'pending', NULL, NULL, NULL, 'Evening distribution to Carol Brown', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(4, '2025-07-08 00:00:00.000', '10:00:00', 1, 4, 4, 'pending', NULL, NULL, NULL, 'Morning distribution to David Davis', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(5, '2025-07-08 00:00:00.000', '15:00:00', 2, 1, 1, 'completed', '2025-07-08 18:18:53.000', -1.3009433, 36.777719, 'Afternoon distribution to Alice Johnson', '2025-07-07 23:33:24.000', '2025-07-09 00:24:55.000'),
(6, '2025-07-06 00:00:00.000', '09:00:00', 1, 2, 2, 'completed', NULL, NULL, NULL, 'Completed distribution to Bob Wilson', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(7, '2025-07-06 00:00:00.000', '14:00:00', 2, 3, 3, 'completed', NULL, NULL, NULL, 'Completed distribution to Carol Brown', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(8, '2025-07-07 00:00:00.000', '08:00:00', 1, 1, 1, 'checked_in', '2025-07-07 23:47:39.000', -1.2921, 36.8219, 'Checked in for morning distribution', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(9, '2025-07-07 00:00:00.000', '13:00:00', 2, 2, 2, 'checked_in', '2025-07-07 23:47:39.000', -1.2921, 36.8219, 'Checked in for afternoon distribution', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(10, '2025-07-07 00:00:00.000', '11:00:00', 1, 3, 3, 'in_progress', '2025-07-07 23:47:39.000', -1.2921, 36.8219, 'Currently distributing to Carol Brown', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(11, '2025-07-07 00:00:00.000', '12:00:00', 2, 4, 4, 'in_progress', '2025-07-07 23:47:39.000', -1.2921, 36.8219, 'Currently distributing to David Davis', '2025-07-07 23:33:24.000', '2025-07-07 23:47:39.000'),
(12, '2025-07-25 00:00:00.000', '', 2, NULL, NULL, 'pending', NULL, NULL, NULL, 'heer', '2025-07-25 05:30:23.502', '0000-00-00 00:00:00.000');

-- --------------------------------------------------------

--
-- Table structure for table `Leave`
--

CREATE TABLE `Leave` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `leaveType` varchar(191) NOT NULL,
  `startDate` datetime(3) NOT NULL,
  `endDate` datetime(3) NOT NULL,
  `reason` varchar(191) NOT NULL,
  `attachment` varchar(191) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Location`
--

CREATE TABLE `Location` (
  `id` int(11) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `placeName` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Location`
--

INSERT INTO `Location` (`id`, `latitude`, `longitude`, `address`, `placeName`, `description`, `createdAt`, `updatedAt`) VALUES
(1, -1.3010349, 36.7777117, 'Nairobi, Kenya', 'Central Business District', 'Main business area in Nairobi', '2025-07-07 20:45:54.503', '2025-07-07 23:34:03.000'),
(2, -1.2847394, 36.8228131, 'Nairobi, Kenya', 'Westlands', 'Commercial district in Westlands', '2025-07-07 20:45:54.503', '2025-07-07 23:34:03.000'),
(3, -1.343488, 36.7394816, 'Nairobi, Kenya', 'Industrial Area', 'Industrial zone in Nairobi', '2025-07-07 20:45:54.503', '2025-07-07 23:34:03.000'),
(4, -1.2847516, 36.8227973, '9 Standard St, Nairobi, Kenya', 'Standard Street', 'Standard Street location', '2025-07-07 20:45:54.503', '2025-07-07 23:34:03.000');

-- --------------------------------------------------------

--
-- Table structure for table `my_activity`
--

CREATE TABLE `my_activity` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `my_activity`
--

INSERT INTO `my_activity` (`id`, `name`, `status`) VALUES
(1, 'Activity 1', 0),
(2, 'Activity 2', 0);

-- --------------------------------------------------------

--
-- Table structure for table `NoticeBoard`
--

CREATE TABLE `NoticeBoard` (
  `id` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `content` varchar(191) NOT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `NoticeBoard`
--

INSERT INTO `NoticeBoard` (`id`, `title`, `content`, `createdAt`, `updatedAt`) VALUES
(1, 'Foundation Meeting Tomorrow', 'All field staff are required to attend the monthly foundation meeting tomorrow at 9:00 AM. Important updates about distribution schedules and new procedures will be discussed.', '2025-01-15 08:00:00.000000', '2025-01-15 08:00:00.000000'),
(2, 'New Distribution Routes', 'We have updated our distribution routes for better efficiency. Please check your assigned areas in the journey plans section. Contact management if you have any questions.', '2025-01-14 14:30:00.000000', '2025-01-14 14:30:00.000000'),
(3, 'Emergency Contact Update', 'Please ensure your emergency contacts are up to date in your profile. This is crucial for safety during field operations.', '2025-01-13 10:15:00.000000', '2025-01-13 10:15:00.000000'),
(4, 'Weather Alert - Heavy Rain Expected', 'Heavy rainfall is expected in the next 48 hours. Please exercise caution during field operations and report any safety concerns immediately.', '2025-01-12 16:45:00.000000', '2025-01-12 16:45:00.000000'),
(5, 'New Product Inventory Available', 'New medical supplies have been added to our inventory. Please check the product list for updated stock levels before making distributions.', '2025-01-11 11:20:00.000000', '2025-01-11 11:20:00.000000'),
(6, 'SOS System Maintenance', 'The SOS system will undergo maintenance tonight from 10 PM to 2 AM. During this time, please use alternative emergency contact methods if needed.', '2025-01-10 09:30:00.000000', '2025-01-10 09:30:00.000000'),
(7, 'Training Session - First Aid', 'Mandatory first aid training session will be held this Friday at 2 PM. All field staff must attend. Location: Main office training room.', '2025-01-09 13:45:00.000000', '2025-01-09 13:45:00.000000'),
(8, 'Vehicle Maintenance Schedule', 'All foundation vehicles will undergo scheduled maintenance next week. Please plan your routes accordingly and inform management of any urgent transportation needs.', '2025-01-08 15:20:00.000000', '2025-01-08 15:20:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `Notices`
--

CREATE TABLE `Notices` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Notices`
--

INSERT INTO `Notices` (`id`, `title`, `description`, `created_by`, `created_at`) VALUES
(1, 'ss', 'ss', 22, '2025-07-25 09:52:14'),
(2, 'title', 'my notice', 22, '2025-07-25 09:54:13');

-- --------------------------------------------------------

--
-- Table structure for table `Order`
--

CREATE TABLE `Order` (
  `id` int(11) NOT NULL,
  `totalAmount` double NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `notes` varchar(191) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `recipientId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `journeyPlanId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `OrderItem`
--

CREATE TABLE `OrderItem` (
  `id` int(11) NOT NULL,
  `orderId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

CREATE TABLE `Product` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `currentStock` int(11) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `recipientId` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Product`
--

INSERT INTO `Product` (`id`, `name`, `category`, `description`, `currentStock`, `image`, `recipientId`, `createdAt`, `updatedAt`) VALUES
(1, 'Gloves', 'Medical Accessories', NULL, 280, NULL, NULL, '2025-05-13 00:09:53.000', '2025-05-13 00:09:53.000'),
(2, 'Rice', '', NULL, 300, NULL, NULL, '2025-07-25 05:35:16.751', '0000-00-00 00:00:00.000'),
(3, 'Sugar', '', NULL, 240, NULL, NULL, '2025-07-25 05:35:19.286', '0000-00-00 00:00:00.000');

-- --------------------------------------------------------

--
-- Table structure for table `ProductReport`
--

CREATE TABLE `ProductReport` (
  `reportId` int(11) NOT NULL,
  `productName` varchar(191) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Recipient`
--

CREATE TABLE `Recipient` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `contact` varchar(191) NOT NULL,
  `location` varchar(191) NOT NULL,
  `locationId` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `age` varchar(191) DEFAULT NULL,
  `idNumber` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Recipient`
--

INSERT INTO `Recipient` (`id`, `name`, `contact`, `location`, `locationId`, `status`, `createdAt`, `updatedAt`, `age`, `idNumber`) VALUES
(1, 'Alice Johnson', '+254722111111', 'Nairobi West', NULL, 0, '2025-07-07 23:32:36.000', '2025-07-07 23:47:39.000', '35', 'ID123456'),
(2, '1', '1', '1', NULL, 0, '2025-05-12 22:41:01.374', '2025-07-07 23:47:39.000', '1', '1'),
(3, 'rereerree', '12345678', 'qwertyui', NULL, 0, '2025-05-12 22:43:17.979', '2025-07-07 23:47:39.000', '34', '123456'),
(4, 'teste', '122112212', 'teste', NULL, 0, '2025-05-12 22:44:43.173', '2025-07-07 23:47:39.000', '12', '1222222'),
(5, 'poiu', '1234567890', 'poiu', NULL, 0, '2025-05-12 22:46:16.863', '2025-05-12 22:46:16.863', '1234567890', '234567890'),
(6, 'odoyo', '12345', 'wert', NULL, 0, '2025-05-12 22:48:53.951', '2025-05-12 22:48:53.951', '20', '12345'),
(7, '23', '23', '23', NULL, 0, '2025-05-12 22:49:14.534', '2025-05-12 22:49:14.534', '23', '23'),
(8, '12', '123', '123', NULL, 0, '2025-05-12 22:50:12.901', '2025-05-12 22:50:12.901', '123', '123'),
(9, '90', '90', '90', NULL, 0, '2025-05-12 22:51:31.737', '2025-05-12 22:51:31.737', '90', '90'),
(10, '54', 'rrr', 'rrr', NULL, 0, '2025-05-12 22:52:22.011', '2025-05-12 22:52:22.011', 'rrr', 'rrr'),
(11, 'post', '09876543', 'kffhkhf', NULL, 0, '2025-05-12 22:53:20.400', '2025-05-12 22:53:20.400', '30', '000000000'),
(12, 'jo', '234500000000', 'tyuio', NULL, 0, '2025-05-12 22:56:26.777', '2025-05-12 22:56:26.777', '32', '45678'),
(13, 'wertyui', '765432', 'sdfghj', NULL, 0, '2025-05-12 22:57:08.065', '2025-05-12 22:57:08.065', '98765', '324567'),
(14, 'cv', '122', 'vcx', NULL, 0, '2025-05-12 23:00:58.276', '2025-05-12 23:00:58.276', '12', '12'),
(15, 'qretre', '4545', 'v5d', NULL, 0, '2025-05-12 23:04:07.557', '2025-05-12 23:04:07.557', '455', '4555'),
(16, 'Joseph', '88888888', 'yyyyyyyyyyy', NULL, 0, '2025-05-12 23:10:42.344', '2025-05-12 23:10:42.344', '55', '77777777');

-- --------------------------------------------------------

--
-- Table structure for table `Report`
--

CREATE TABLE `Report` (
  `id` int(11) NOT NULL,
  `type` enum('FEEDBACK','PRODUCT_AVAILABILITY','VISIBILITY') NOT NULL,
  `journeyPlanId` int(11) DEFAULT NULL,
  `orderId` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Manager', 'Team Leader', '2025-06-06 08:38:35', '2025-07-04 13:56:20'),
(4, 'Attendant', 'Driver', '2025-06-06 08:38:55', '2025-07-04 13:56:28');

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `id` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `roomTypeId` int(11) NOT NULL,
  `price` double NOT NULL,
  `description` varchar(191) NOT NULL,
  `images` text NOT NULL,
  `isAvailable` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Room`
--

INSERT INTO `Room` (`id`, `title`, `roomTypeId`, `price`, `description`, `images`, `isAvailable`, `createdAt`, `updatedAt`) VALUES
(1, 'Cottage 1', 1, 3500, 'Luxury cottage with modern amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:55.924', '2025-05-12 20:36:58.144'),
(2, 'Cottage 2', 1, 3500, 'Luxury cottage with modern amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:56.953', '2025-05-12 20:36:58.144'),
(3, 'Cottage 3', 1, 3500, 'Luxury cottage with modern amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:57.634', '2025-05-12 20:36:58.144'),
(4, 'Cottage 4', 1, 3500, 'Luxury cottage with modern amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:58.313', '2025-05-12 20:36:58.144'),
(5, 'Standard Room 1', 2, 2500, 'Comfortable standard room with essential amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:58.989', '2025-05-12 20:36:58.144'),
(6, 'Standard Room 2', 2, 2500, 'Comfortable standard room with essential amenities and breakfast service', 'https://ik.imagekit.io/bja2qwwdjjy/Waswa/IMG-20250506-WA0026_1HBxMLhFX.jpg?updatedAt=1747082116110', 1, '2025-05-12 17:36:59.669', '2025-05-12 20:36:58.144');

-- --------------------------------------------------------

--
-- Table structure for table `RoomType`
--

CREATE TABLE `RoomType` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) NOT NULL,
  `basePrice` double NOT NULL,
  `capacity` int(11) NOT NULL,
  `amenities` text NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `RoomType`
--

INSERT INTO `RoomType` (`id`, `name`, `description`, `basePrice`, `capacity`, `amenities`, `createdAt`, `updatedAt`) VALUES
(1, 'Cottage', 'Luxury cottage with bed and breakfast service', 3500, 2, '[\\\"King Size Bed\\\", \\\"Private Bathroom\\\", \\\"Air Conditioning\\\", \\\"Free WiFi\\\", \\\"Breakfast Included\\\", \\\"Room Service\\\"]', '2025-05-12 17:02:09.249', '2025-05-12 16:53:26.729'),
(2, 'Standard Room', 'Comfortable standard room with bed and breakfast service', 2500, 2, '[\\\"Queen Size Bed\\\", \\\"Private Bathroom\\\", \\\"Air Conditioning\\\", \\\"Free WiFi\\\", \\\"Breakfast Included\\\"]', '2025-05-12 17:03:05.694', '2025-05-12 17:02:18.952');

-- --------------------------------------------------------

--
-- Table structure for table `School`
--

CREATE TABLE `School` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `address` varchar(191) DEFAULT NULL,
  `contactEmail` varchar(191) DEFAULT NULL,
  `contactPhone` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `School`
--

INSERT INTO `School` (`id`, `name`, `address`, `contactEmail`, `contactPhone`, `type`, `createdAt`, `updatedAt`) VALUES
(1, 'High School 1', NULL, NULL, NULL, NULL, '2025-05-13 04:53:06.535', '2025-05-13 04:52:51.704');

-- --------------------------------------------------------

--
-- Table structure for table `SOS`
--

CREATE TABLE `SOS` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'active',
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `premisesId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `address` varchar(191) DEFAULT NULL,
  `distressType` varchar(191) DEFAULT NULL,
  `resolvedAt` datetime(3) DEFAULT NULL,
  `userName` varchar(191) DEFAULT NULL,
  `userPhone` varchar(191) DEFAULT NULL,
  `amb_id` int(11) NOT NULL,
  `amb_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `SOS`
--

INSERT INTO `SOS` (`id`, `userId`, `latitude`, `longitude`, `status`, `notes`, `createdAt`, `updatedAt`, `premisesId`, `locationId`, `address`, `distressType`, `resolvedAt`, `userName`, `userPhone`, `amb_id`, `amb_name`) VALUES
(1, 1, -1.3010444, 36.7777117, 'active', NULL, '2025-05-10 14:37:07.731', '2025-05-10 14:37:07.731', NULL, 1, NULL, 'medical', NULL, 'Test User', '0706166875', 1, 'KDH 112A'),
(2, 1, -1.343488, 36.7394816, 'active', NULL, '2025-05-12 18:32:33.376', '2025-05-12 18:32:33.376', NULL, 3, NULL, 'medical', NULL, 'Test User', '0706166875', 0, ''),
(3, 1, -1.2847516, 36.8227973, 'active', NULL, '2025-05-13 13:19:11.654', '2025-05-13 13:19:11.654', NULL, 4, '9 Standard St, Nairobi, Kenya', 'medical', NULL, 'Test User', '0706166875', 0, ''),
(4, 1, -1.2847516, 36.8227973, 'active', NULL, '2025-05-13 13:19:28.210', '2025-05-13 13:19:28.210', NULL, 4, '9 Standard St, Nairobi, Kenya', 'medical', NULL, 'Test User', '0706166875', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

CREATE TABLE `Student` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `admissionNumber` varchar(191) DEFAULT NULL,
  `gender` varchar(191) DEFAULT NULL,
  `dateOfBirth` datetime(3) DEFAULT NULL,
  `guardianName` varchar(191) DEFAULT NULL,
  `guardianContact` varchar(191) DEFAULT NULL,
  `schoolId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Student`
--

INSERT INTO `Student` (`id`, `name`, `admissionNumber`, `gender`, `dateOfBirth`, `guardianName`, `guardianContact`, `schoolId`, `createdAt`, `updatedAt`) VALUES
(1, 'Benjamin', '1234567', 'Male', '2017-05-01 11:08:12.000', 'Jane 1', '0712345678', 1, '2025-05-13 04:53:31.138', '2025-05-13 04:53:14.188');

-- --------------------------------------------------------

--
-- Table structure for table `tb2`
--

CREATE TABLE `tb2` (
  `id` int(11) NOT NULL,
  `tb1_id` int(11) NOT NULL,
  `piece_id` varchar(200) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `piece_name` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `rate` decimal(11,2) NOT NULL,
  `total` decimal(11,2) NOT NULL,
  `month` varchar(100) NOT NULL,
  `year` varchar(100) NOT NULL,
  `created_date` varchar(100) NOT NULL,
  `my_date` varchar(100) NOT NULL,
  `status` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `staff` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tb2`
--

INSERT INTO `tb2` (`id`, `tb1_id`, `piece_id`, `product_name`, `piece_name`, `quantity`, `rate`, `total`, `month`, `year`, `created_date`, `my_date`, `status`, `staff_id`, `staff`) VALUES
(1, 1, '1', 'Gloves', '1', '1', 0.00, 0.00, 'May', '2025', '2025-05-12', '2025-05-12 06:42:02 pm', 0, 22, 'Waswa'),
(2, 1, '1', 'Gloves', '1', '10', 0.00, 0.00, 'May', '2025', '2025-05-12', '2025-05-12 06:46:32 pm', 0, 22, 'Waswa'),
(3, 2, '1', 'Gloves', '1', '10', 0.00, 0.00, 'May', '2025', '2025-05-13', '2025-05-13 03:54:22 pm', 0, 22, 'Waswa'),
(4, 0, '1', 'Gloves', '1', '100', 0.00, 0.00, 'July', '2025', '2025-07-24', '2025-07-24 10:29:23 am', 0, 22, 'Waswa'),
(5, 12, '1', 'Gloves', '1', '10', 0.00, 0.00, 'July', '2025', '2025-07-25', '2025-07-25 06:30:11 am', 0, 12, 'Woosh');

-- --------------------------------------------------------

--
-- Table structure for table `Token`
--

CREATE TABLE `Token` (
  `id` int(11) NOT NULL,
  `token` varchar(191) NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `expiresAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Token`
--

INSERT INTO `Token` (`id`, `token`, `userId`, `createdAt`, `expiresAt`) VALUES
(1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ2ODg3NzI1LCJleHAiOjE3NDY5MDU3MjV9.AwkmLTCXWsef0NKX8Hagzgv5s8oki7UbUpUSUyamQ40', 1, '2025-05-10 14:35:25.825', '2025-05-10 19:35:25.818'),
(2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ2ODg3NzQ4LCJleHAiOjE3NDY5MDU3NDh9.ki4B2jMn5NeEfM6N8-d2xXwAnv6XZ1E1uyCjx80-s8s', 1, '2025-05-10 14:35:48.108', '2025-05-10 19:35:48.106'),
(3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MDcwODcwLCJleHAiOjE3NDcwODg4NzB9.n3JHt0ApGKCuUnzpgN56LVOT6rswGpBVPV-ii4lvJWI', 1, '2025-05-12 17:27:50.360', '2025-05-12 22:27:50.358'),
(4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MDg2NzI0LCJleHAiOjE3NDcxMDQ3MjR9.VUKpviJeoDneKt1ht1WVHQcsadui8pey7cwtHmMj3Ek', 1, '2025-05-12 21:52:04.544', '2025-05-13 02:52:04.539'),
(5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MTExNjkzLCJleHAiOjE3NDcxMjk2OTN9.dY41zte_xdlSO-_0D2v-3vtVcJesPxDxg3Y5nE5X8YE', 1, '2025-05-13 04:48:13.605', '2025-05-13 09:48:13.602'),
(6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MTIzMjU2LCJleHAiOjE3NDcxNDEyNTZ9.4ZxBprClT8RpybV32sffDJBbfldh0wC4MXvEqQ18yAo', 1, '2025-05-13 08:00:56.740', '2025-05-13 13:00:56.739'),
(7, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MTMwMzM5LCJleHAiOjE3NDcxNDgzMzl9.zjKG-b2tsew4Jr2T2ZvLN3CrIV_xwILHjfMYXve175M', 1, '2025-05-13 09:58:59.224', '2025-05-13 14:58:59.223'),
(8, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MTM1NzAxLCJleHAiOjE3NDcxNTM3MDF9.iz95AyKQRNErd-Il5uhWF04IjLSMT4M9L9ipEfzhQz4', 1, '2025-05-13 11:28:21.509', '2025-05-13 16:28:21.508'),
(9, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzQ3MTQxMDgyLCJleHAiOjE3NDcxNTkwODJ9.68F4xCtWVnh-ZhAOJAekWdNC7JDDdOFF05_S3KYZU_8', 1, '2025-05-13 12:58:02.940', '2025-05-13 17:58:02.939');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR') NOT NULL DEFAULT 'USER',
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `photoUrl` varchar(500) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER','PREFER_NOT_TO_SAY') DEFAULT NULL,
  `nationalId` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Kenya',
  `postalCode` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `emergencyContactName` varchar(255) DEFAULT NULL,
  `emergencyContactPhone` varchar(20) DEFAULT NULL,
  `emergencyContactRelationship` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `employeeId` varchar(50) DEFAULT NULL,
  `hireDate` date DEFAULT NULL,
  `supervisorId` int(11) DEFAULT NULL,
  `preferredLanguage` enum('ENGLISH','SWAHILI','KIKUYU','LUHYA','KALENJIN','OTHER') NOT NULL DEFAULT 'ENGLISH',
  `emailVerified` tinyint(4) NOT NULL DEFAULT 0,
  `phoneVerified` tinyint(4) NOT NULL DEFAULT 0,
  `lastLoginAt` datetime DEFAULT NULL,
  `lastLoginIp` varchar(45) DEFAULT NULL,
  `failedLoginAttempts` int(11) NOT NULL DEFAULT 0,
  `accountLocked` tinyint(4) NOT NULL DEFAULT 0,
  `lockExpiresAt` datetime DEFAULT NULL,
  `passwordChangedAt` datetime DEFAULT NULL,
  `passwordExpiresAt` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `notificationPreferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notificationPreferences`)),
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `name`, `email`, `phoneNumber`, `password`, `role`, `created_at`, `updatedAt`, `photoUrl`, `status`, `firstName`, `lastName`, `dateOfBirth`, `gender`, `nationalId`, `city`, `state`, `country`, `postalCode`, `latitude`, `longitude`, `emergencyContactName`, `emergencyContactPhone`, `emergencyContactRelationship`, `department`, `position`, `employeeId`, `hireDate`, `supervisorId`, `preferredLanguage`, `emailVerified`, `phoneVerified`, `lastLoginAt`, `lastLoginIp`, `failedLoginAttempts`, `accountLocked`, `lockExpiresAt`, `passwordChangedAt`, `passwordExpiresAt`, `notes`, `address`, `notificationPreferences`, `tags`, `metadata`) VALUES
(1, 'Test User', 'test@example.com', '0706166879', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'USER', '2025-09-03 11:42:28.000000', '2025-09-03 12:58:28.000000', NULL, 1, 'Test', 'User', NULL, NULL, '12345678', 'Nairobi', NULL, 'Kenya', NULL, NULL, NULL, 'Emergency Contact', '0700000000', NULL, 'Field Operations', 'Field Staff', NULL, NULL, NULL, 'ENGLISH', 0, 0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Benjamin OKwama', 'admin@foundation.com', '+254711987654', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'ADMIN', '2025-09-03 11:42:28.000000', '2025-09-03 11:42:28.000000', NULL, 1, 'Benjamin', 'OKwama', NULL, NULL, '87654321', 'Kitale', NULL, 'Kenya', NULL, NULL, NULL, 'Admin Emergency', '+254700000000', NULL, 'Administration', 'System Administrator', NULL, NULL, NULL, 'ENGLISH', 0, 0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'John Doe', 'john.doe@foundation.com', '+254722333444', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'FIELD_USER', '2025-09-03 11:42:28.000000', '2025-09-03 11:42:28.000000', NULL, 1, 'John', 'Doe', NULL, NULL, '11223344', 'Eldoret', NULL, 'Kenya', NULL, NULL, NULL, 'Jane Doe', '+254733444555', NULL, 'Field Operations', 'Field Coordinator', NULL, NULL, 4, 'ENGLISH', 0, 0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'Sarah Muthoni', 'sarah.muthoni@foundation.com', '+254733111222', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'MANAGER', '2025-09-03 11:42:28.000000', '2025-09-03 11:42:28.000000', NULL, 1, 'Sarah', 'Muthoni', NULL, NULL, '55667788', 'Nakuru', NULL, 'Kenya', NULL, NULL, NULL, 'James Muthoni', '+254744222333', NULL, 'Field Operations', 'Field Manager', NULL, NULL, NULL, 'ENGLISH', 0, 0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'David Ochieng', 'david.ochieng@foundation.com', '+254744333444', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'SUPERVISOR', '2025-09-03 11:42:28.000000', '2025-09-03 11:42:28.000000', NULL, 1, 'David', 'Ochieng', NULL, NULL, '99887766', 'Kisumu', NULL, 'Kenya', NULL, NULL, NULL, 'Mary Ochieng', '+254755444555', NULL, 'Field Operations', 'Field Supervisor', NULL, NULL, 4, 'ENGLISH', 0, 0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'user',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`, `created_at`, `updated_at`) VALUES
(7, 'admin', '$2a$10$EZ0JqGFCZ90/cmijwcW1V.lRnw.TEFtWD4wA/fntMWMH9rC1XUATy', 'admin@example.com', 'admin', '2025-06-05 18:34:36.371', '2025-06-05 18:34:36.371');

-- --------------------------------------------------------

--
-- Table structure for table `User_backup`
--

CREATE TABLE `User_backup` (
  `id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phoneNumber` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `created_at` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `photoUrl` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `User_backup`
--

INSERT INTO `User_backup` (`id`, `name`, `email`, `phoneNumber`, `password`, `role`, `created_at`, `updatedAt`, `photoUrl`, `status`) VALUES
(1, 'Test User', 'test@example.com', '0706166875', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'USER', '', '2025-07-07 23:57:09.000', NULL, 0),
(2, 'Benjamin OKwama', 'admin@foundation.com', '+254711987654', '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 'field_user', '', '2025-07-07 23:57:09.000', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `VisibilityReport`
--

CREATE TABLE `VisibilityReport` (
  `reportId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `imageUrl` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Visitor`
--

CREATE TABLE `Visitor` (
  `id` int(11) NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `idPhotoUrl` varchar(191) DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `reasonForVisit` varchar(191) NOT NULL,
  `scheduledVisitTime` datetime(3) NOT NULL,
  `userId` int(11) NOT NULL,
  `userName` varchar(191) NOT NULL,
  `userPhone` varchar(191) NOT NULL,
  `visitorName` varchar(191) NOT NULL,
  `visitorPhone` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_active_users`
-- (See below for the actual view)
--
CREATE TABLE `v_active_users` (
`id` int(11)
,`name` varchar(255)
,`email` varchar(255)
,`phoneNumber` varchar(20)
,`role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR')
,`department` varchar(100)
,`position` varchar(100)
,`firstName` varchar(100)
,`lastName` varchar(100)
,`city` varchar(100)
,`country` varchar(100)
,`created_at` datetime(6)
,`lastLoginAt` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_statistics`
-- (See below for the actual view)
--
CREATE TABLE `v_user_statistics` (
`role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR')
,`total_users` bigint(21)
,`active_users` bigint(21)
,`inactive_users` bigint(21)
,`verified_users` bigint(21)
,`avg_days_since_login` decimal(11,4)
);

-- --------------------------------------------------------

--
-- Table structure for table `_DistributionRecipients`
--

CREATE TABLE `_DistributionRecipients` (
  `A` int(11) NOT NULL,
  `B` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_DistributionRecipients`
--

INSERT INTO `_DistributionRecipients` (`A`, `B`) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 10),
(6, 11),
(7, 12),
(8, 13),
(9, 14),
(10, 15),
(11, 16);

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('2543e768-53e1-4954-a3a8-e7201f16cb62', '68213dbcb3bbc2bae35958a16036632fd1beadfbbad59a04af0be0b4bd31e386', '2025-05-10 14:05:15.107', '20250509160346_init', NULL, NULL, '2025-05-10 14:05:14.015', 1),
('8f272614-3d04-4240-8c00-0937cc4fda75', '86111016179bf21ab760d67efa7d516deeaf46088997471fbe39c79500ddeeca', '2025-05-10 14:05:15.839', '20250509204435_add_photo_url', NULL, NULL, '2025-05-10 14:05:15.349', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `activity_budget`
--
ALTER TABLE `activity_budget`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  ADD PRIMARY KEY (`id`),
  ADD KEY `AmbulanceRequest_userId_idx` (`userId`),
  ADD KEY `AmbulanceRequest_ambulanceId_idx` (`ambulanceId`),
  ADD KEY `AmbulanceRequest_status_idx` (`status`),
  ADD KEY `AmbulanceRequest_startDate_idx` (`startDate`),
  ADD KEY `AmbulanceRequest_endDate_idx` (`endDate`),
  ADD KEY `AmbulanceRequest_assignedBy_fkey` (`assignedBy`),
  ADD KEY `idx_ambulance_request_user_status` (`userId`,`status`),
  ADD KEY `idx_ambulance_request_date_range` (`startDate`,`endDate`),
  ADD KEY `idx_ambulance_request_location` (`latitude`,`longitude`);

--
-- Indexes for table `ambulances`
--
ALTER TABLE `ambulances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Booking`
--
ALTER TABLE `Booking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Booking_roomId_idx` (`roomId`),
  ADD KEY `Booking_customerId_idx` (`customerId`);

--
-- Indexes for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `BursaryApplication_userId_idx` (`userId`),
  ADD KEY `BursaryApplication_status_idx` (`status`),
  ADD KEY `BursaryApplication_applicationDate_idx` (`applicationDate`);

--
-- Indexes for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `BursaryPayment_studentId_fkey` (`studentId`),
  ADD KEY `BursaryPayment_schoolId_fkey` (`schoolId`);

--
-- Indexes for table `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Customer_email_key` (`email`);

--
-- Indexes for table `Distribution`
--
ALTER TABLE `Distribution`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Distribution_journeyPlanId_idx` (`journeyPlanId`),
  ADD KEY `idx_distribution_journey_plan` (`journeyPlanId`),
  ADD KEY `idx_distribution_status` (`distributionStatus`),
  ADD KEY `idx_distribution_date` (`distributionDate`),
  ADD KEY `idx_distribution_user` (`distributedBy`);

--
-- Indexes for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `DistributionItem_distributionId_idx` (`distributionId`),
  ADD KEY `DistributionItem_productId_idx` (`productId`),
  ADD KEY `DistributionItem_recipientId_idx` (`recipientId`),
  ADD KEY `idx_distribution_item_distribution` (`distributionId`),
  ADD KEY `idx_distribution_item_product` (`productId`),
  ADD KEY `idx_distribution_item_recipient` (`recipientId`);

--
-- Indexes for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `DistributionPhotos_distributionId_idx` (`distributionId`);

--
-- Indexes for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `DistributionTaskStatus_distributionId_taskType_unique` (`distributionId`,`taskType`),
  ADD KEY `DistributionTaskStatus_distributionId_idx` (`distributionId`);

--
-- Indexes for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `FeedbackReport_reportId_key` (`reportId`),
  ADD KEY `FeedbackReport_userId_idx` (`userId`),
  ADD KEY `FeedbackReport_journeyPlanId_idx` (`journeyPlanId`);

--
-- Indexes for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `JourneyPlan_userId_idx` (`userId`),
  ADD KEY `JourneyPlan_recipientId_idx` (`recipientId`),
  ADD KEY `fk_journeyplan_location` (`locationId`);

--
-- Indexes for table `Leave`
--
ALTER TABLE `Leave`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Leave_userId_idx` (`userId`);

--
-- Indexes for table `Location`
--
ALTER TABLE `Location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_location_coordinates` (`latitude`,`longitude`);

--
-- Indexes for table `my_activity`
--
ALTER TABLE `my_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `NoticeBoard`
--
ALTER TABLE `NoticeBoard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Notices`
--
ALTER TABLE `Notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Order_userId_idx` (`userId`),
  ADD KEY `Order_recipientId_idx` (`recipientId`),
  ADD KEY `Order_journeyPlanId_idx` (`journeyPlanId`);

--
-- Indexes for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `OrderItem_orderId_productId_key` (`orderId`,`productId`),
  ADD KEY `OrderItem_orderId_idx` (`orderId`),
  ADD KEY `OrderItem_productId_idx` (`productId`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Product_recipientId_idx` (`recipientId`);

--
-- Indexes for table `ProductReport`
--
ALTER TABLE `ProductReport`
  ADD PRIMARY KEY (`reportId`);

--
-- Indexes for table `Recipient`
--
ALTER TABLE `Recipient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_recipient_location` (`locationId`);

--
-- Indexes for table `Report`
--
ALTER TABLE `Report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Report_userId_idx` (`userId`),
  ADD KEY `Report_journeyPlanId_idx` (`journeyPlanId`),
  ADD KEY `Report_orderId_idx` (`orderId`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Room_roomTypeId_idx` (`roomTypeId`);

--
-- Indexes for table `RoomType`
--
ALTER TABLE `RoomType`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `RoomType_name_key` (`name`);

--
-- Indexes for table `School`
--
ALTER TABLE `School`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `SOS`
--
ALTER TABLE `SOS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `SOS_userId_idx` (`userId`),
  ADD KEY `fk_sos_location` (`locationId`);

--
-- Indexes for table `Student`
--
ALTER TABLE `Student`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Student_schoolId_fkey` (`schoolId`);

--
-- Indexes for table `tb2`
--
ALTER TABLE `tb2`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Token`
--
ALTER TABLE `Token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Token_token_key` (`token`),
  ADD KEY `Token_userId_idx` (`userId`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_4a257d2c9837248d70640b3e36` (`email`),
  ADD UNIQUE KEY `IDX_a3a6ca48a99127554da5314f64` (`phoneNumber`),
  ADD UNIQUE KEY `IDX_5f8e78b4104bed6d543de36b39` (`nationalId`),
  ADD UNIQUE KEY `IDX_61451fc955dbcbd690dadc1ac4` (`employeeId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `VisibilityReport`
--
ALTER TABLE `VisibilityReport`
  ADD PRIMARY KEY (`reportId`);

--
-- Indexes for table `Visitor`
--
ALTER TABLE `Visitor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Visitor_userId_idx` (`userId`);

--
-- Indexes for table `_DistributionRecipients`
--
ALTER TABLE `_DistributionRecipients`
  ADD UNIQUE KEY `_DistributionRecipients_AB_unique` (`A`,`B`),
  ADD KEY `_DistributionRecipients_B_index` (`B`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity`
--
ALTER TABLE `activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `activity_budget`
--
ALTER TABLE `activity_budget`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ambulances`
--
ALTER TABLE `ambulances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Booking`
--
ALTER TABLE `Booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Category`
--
ALTER TABLE `Category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Customer`
--
ALTER TABLE `Customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Distribution`
--
ALTER TABLE `Distribution`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Leave`
--
ALTER TABLE `Leave`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Location`
--
ALTER TABLE `Location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `my_activity`
--
ALTER TABLE `my_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `NoticeBoard`
--
ALTER TABLE `NoticeBoard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Notices`
--
ALTER TABLE `Notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Order`
--
ALTER TABLE `Order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderItem`
--
ALTER TABLE `OrderItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Product`
--
ALTER TABLE `Product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Recipient`
--
ALTER TABLE `Recipient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `Report`
--
ALTER TABLE `Report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Room`
--
ALTER TABLE `Room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `RoomType`
--
ALTER TABLE `RoomType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `School`
--
ALTER TABLE `School`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `SOS`
--
ALTER TABLE `SOS`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Student`
--
ALTER TABLE `Student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tb2`
--
ALTER TABLE `tb2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Token`
--
ALTER TABLE `Token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Visitor`
--
ALTER TABLE `Visitor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Structure for view `v_active_users`
--
DROP TABLE IF EXISTS `v_active_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`citlogis`@`localhost` SQL SECURITY DEFINER VIEW `v_active_users`  AS SELECT `User`.`id` AS `id`, `User`.`name` AS `name`, `User`.`email` AS `email`, `User`.`phoneNumber` AS `phoneNumber`, `User`.`role` AS `role`, `User`.`department` AS `department`, `User`.`position` AS `position`, `User`.`firstName` AS `firstName`, `User`.`lastName` AS `lastName`, `User`.`city` AS `city`, `User`.`country` AS `country`, `User`.`created_at` AS `created_at`, `User`.`lastLoginAt` AS `lastLoginAt` FROM `User` WHERE `User`.`status` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_statistics`
--
DROP TABLE IF EXISTS `v_user_statistics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`citlogis`@`localhost` SQL SECURITY DEFINER VIEW `v_user_statistics`  AS SELECT `User`.`role` AS `role`, count(0) AS `total_users`, count(case when `User`.`status` = 1 then 1 end) AS `active_users`, count(case when `User`.`status` = 0 then 1 end) AS `inactive_users`, count(case when `User`.`emailVerified` = 1 then 1 end) AS `verified_users`, avg(case when `User`.`lastLoginAt` is not null then to_days(current_timestamp()) - to_days(`User`.`lastLoginAt`) end) AS `avg_days_since_login` FROM `User` GROUP BY `User`.`role` ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  ADD CONSTRAINT `AmbulanceRequest_ambulanceId_fkey` FOREIGN KEY (`ambulanceId`) REFERENCES `ambulances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `AmbulanceRequest_assignedBy_fkey` FOREIGN KEY (`assignedBy`) REFERENCES `admin_users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `AmbulanceRequest_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Booking`
--
ALTER TABLE `Booking`
  ADD CONSTRAINT `Booking_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Booking_roomId_fkey` FOREIGN KEY (`roomId`) REFERENCES `Room` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  ADD CONSTRAINT `BursaryApplication_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  ADD CONSTRAINT `BursaryPayment_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `BursaryPayment_studentId_fkey` FOREIGN KEY (`studentId`) REFERENCES `Student` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Distribution`
--
ALTER TABLE `Distribution`
  ADD CONSTRAINT `Distribution_distributedBy_fkey` FOREIGN KEY (`distributedBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Distribution_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  ADD CONSTRAINT `DistributionItem_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `DistributionItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `DistributionItem_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  ADD CONSTRAINT `DistributionPhotos_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  ADD CONSTRAINT `DistributionTaskStatus_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  ADD CONSTRAINT `FeedbackReport_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FeedbackReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FeedbackReport_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  ADD CONSTRAINT `JourneyPlan_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `JourneyPlan_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_journeyplan_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Leave`
--
ALTER TABLE `Leave`
  ADD CONSTRAINT `Leave_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `Order_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Order_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Order_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD CONSTRAINT `OrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `OrderItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `Product_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `ProductReport`
--
ALTER TABLE `ProductReport`
  ADD CONSTRAINT `ProductReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Recipient`
--
ALTER TABLE `Recipient`
  ADD CONSTRAINT `fk_recipient_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Report`
--
ALTER TABLE `Report`
  ADD CONSTRAINT `Report_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Report_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Report_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `Room_roomTypeId_fkey` FOREIGN KEY (`roomTypeId`) REFERENCES `RoomType` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `SOS`
--
ALTER TABLE `SOS`
  ADD CONSTRAINT `SOS_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sos_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Student`
--
ALTER TABLE `Student`
  ADD CONSTRAINT `Student_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Token`
--
ALTER TABLE `Token`
  ADD CONSTRAINT `Token_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `VisibilityReport`
--
ALTER TABLE `VisibilityReport`
  ADD CONSTRAINT `VisibilityReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Visitor`
--
ALTER TABLE `Visitor`
  ADD CONSTRAINT `Visitor_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `_DistributionRecipients`
--
ALTER TABLE `_DistributionRecipients`
  ADD CONSTRAINT `_DistributionRecipients_A_fkey` FOREIGN KEY (`A`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `_DistributionRecipients_B_fkey` FOREIGN KEY (`B`) REFERENCES `Recipient` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
