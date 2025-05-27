/*
  Warnings:

  - You are about to drop the column `towerHealth` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `towerPlace` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "towerHealth",
DROP COLUMN "towerPlace";
