-- Create BursaryApplication table
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
